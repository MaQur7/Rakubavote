import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:rakubavote/core/audit/audit_log.dart';
import 'package:rakubavote/core/crypto/device_keys.dart';
import 'package:rakubavote/core/crypto/hashing.dart';
import 'package:rakubavote/core/crypto/signed_artifact.dart';
import 'package:rakubavote/core/db/registry_db.dart';
import 'package:rakubavote/core/domain/ballot_definition.dart';
import 'package:rakubavote/core/domain/templates.dart';
import 'package:rakubavote/core/theme.dart';
import 'package:rakubavote/features/registration/registration_service.dart';
import 'package:rakubavote/features/setup/election_service.dart';

import '../support/fixtures.dart';

void main() {
  late RegistryDb db;
  late DeviceKeys station;
  late ElectionService svc;
  const po = 'Presiding officer';

  setUp(() async {
    db = memoryRegistry();
    station = await DeviceKeys.generate();
    svc = ElectionService(db, station);
  });
  tearDown(() => db.close());

  Future<String> association() => svc.createElection(
      template: ElectionTemplate.association,
      orgName: 'CIEC Community Independent Electoral Committee',
      name: 'CIEC Community Association Election',
      year: 2026,
      stationName: 'Station 1',
      languages: ['en', 'ar', 'din'],
      official: po);

  test('templates pre-fill positions with distinct readable colours', () async {
    final id = await association();
    final ps = await svc.positions(id);
    expect([for (final p in ps) (p.sortOrder, p.titles)], [
      (1, '{"en":"Chairman"}'),
      (2, '{"en":"Secretary General"}'),
      (3, '{"en":"Finance Secretary"}'),
    ]);
    expect(ps.map((p) => p.colour).toSet(), hasLength(3));
    final e = (await svc.currentElection())!;
    expect(e.idLabel, 'Member ID');
    expect(e.groupLabel, 'Branch');
  });

  test('blank template starts empty; party primary has one position', () async {
    final blank = await svc.createElection(
        template: ElectionTemplate.blank, orgName: 'O', name: 'N', year: 2026, stationName: 'S',
        languages: ['en'], official: po);
    expect(await svc.positions(blank), isEmpty);
    final party = await svc.createElection(
        template: ElectionTemplate.partyPrimary, orgName: 'O', name: 'N', year: 2026, stationName: 'S',
        languages: ['en'], official: po);
    expect(await svc.positions(party), hasLength(1));
  });

  test('candidates: numbers must be unique within a position', () async {
    final id = await association();
    final chair = (await svc.positions(id)).first;
    await svc.saveCandidate(positionId: chair.id, number: 1, name: 'A', official: po);
    expect(await svc.nextCandidateNumber(chair.id), 2);
    expect(
      () => svc.saveCandidate(positionId: chair.id, number: 1, name: 'B', official: po),
      throwsA(isA<SetupException>().having((e) => e.failure, 'f', SetupFailure.duplicateCandidateNumber)),
    );
  });

  test('13+ candidates on one position', () async {
    final id = await svc.createElection(
        template: ElectionTemplate.partyPrimary, orgName: 'Party', name: 'Primary', year: 2026,
        stationName: 'S', languages: ['en'], official: po);
    final flag = (await svc.positions(id)).first;
    for (var i = 1; i <= 15; i++) {
      await svc.saveCandidate(positionId: flag.id, number: i, name: 'Aspirant $i', official: po);
    }
    final def = await svc.buildBallot(id);
    expect(def.positions.single.candidates, hasLength(15));
  });

  test('a colour too light for white text is refused', () async {
    final id = await association();
    final chair = (await svc.positions(id)).first;
    expect(
      () => svc.updatePosition(chair.id, colour: RakubaColors.lightThatch.toARGB32(), official: po),
      throwsA(isA<SetupException>().having((e) => e.failure, 'f', SetupFailure.lowContrastColour)),
    );
  });

  group('signing the ballot', () {
    late String id;
    setUp(() async {
      id = await association();
      for (final p in await svc.positions(id)) {
        await svc.saveCandidate(positionId: p.id, number: 1, name: '${p.titles} one', official: po,
            photo: Uint8List.fromList([1, 2, 3]));
        await svc.saveCandidate(positionId: p.id, number: 2, name: '${p.titles} two', official: po);
      }
    });

    test('signed ballot verifies and covers photos by hash', () async {
      final signed = await svc.signBallot(id, official: po);
      final again = await SignedArtifact.parseAndVerify(signed.encode(),
          expectedKind: ArtifactKind.ballot, trustedSigners: [station.signingPublic]);
      final def = BallotDefinition.fromJson(again.payload);
      expect(def.positions, hasLength(3));
      expect(def.positions.first.candidates.first.photoSha256, sha256Hex([1, 2, 3]));
      expect(def.positions.first.candidates.last.photoSha256, isNull);
    });

    test('any change after signing clears the signature', () async {
      await svc.signBallot(id, official: po);
      expect(await svc.signedBallot(id), isNotNull);
      final chair = (await svc.positions(id)).first;
      await svc.updatePosition(chair.id, chooseN: 1, allowNoChoice: false, official: po);
      expect(await svc.signedBallot(id), isNull);
    });

    test('an invalid ballot cannot be signed', () async {
      await svc.addPosition(id, titles: {'en': 'Treasurer'}, official: po);
      expect(
        () => svc.signBallot(id, official: po),
        throwsA(isA<SetupException>().having((e) => e.failure, 'f', SetupFailure.ballotInvalid)),
      );
    });

    test('positions can be reordered', () async {
      final ps = await svc.positions(id);
      await svc.movePosition(ps[2].id, -1, official: po);
      final after = await svc.positions(id);
      expect(after.map((p) => p.id), [ps[0].id, ps[2].id, ps[1].id]);
    });
  });

  group('fee', () {
    test('can be set before the first voter and is locked after', () async {
      final id = await association();
      await svc.setFee(id, enabled: true, amount: 500, currency: FeeCurrency.ssp,
          unpaidPolicy: UnpaidPolicy.block, official: po);
      expect((await svc.feeConfig(id)).amount, 500);
      await RegistrationService(db).register(id,
          const VoterInput(fullName: 'Mary Achol', feePaid: true, receiptNo: 'R-0001'), official: po);
      expect(await svc.feeLocked(id), isTrue);
      expect(
        () => svc.setFee(id, enabled: true, amount: 1000, currency: FeeCurrency.ssp,
            unpaidPolicy: UnpaidPolicy.block, official: po),
        throwsA(isA<SetupException>().having((e) => e.failure, 'f', SetupFailure.feeLocked)),
      );
    });

    test('an enabled fee needs an amount', () async {
      final id = await association();
      expect(
        () => svc.setFee(id, enabled: true, amount: 0, currency: FeeCurrency.usd,
            unpaidPolicy: UnpaidPolicy.block, official: po),
        throwsA(isA<SetupException>()),
      );
    });
  });

  test('every setup change is in the audit log with the official name', () async {
    final id = await association();
    final chair = (await svc.positions(id)).first;
    await svc.saveCandidate(positionId: chair.id, number: 1, name: 'A', official: 'Second official');
    final entries = await svc.audit.entries();
    expect(entries.first.action, AuditAction.electionCreated);
    expect(entries.last.actor, 'Second official');
    expect((await svc.audit.verify()).isValid, isTrue);
  });
}

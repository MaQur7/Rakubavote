import 'package:flutter_test/flutter_test.dart';
import 'package:rakubavote/core/audit/audit_log.dart';
import 'package:rakubavote/core/crypto/device_keys.dart';
import 'package:rakubavote/core/crypto/signed_artifact.dart';
import 'package:rakubavote/core/db/registry_db.dart';
import 'package:rakubavote/core/domain/register_snapshot.dart';
import 'package:rakubavote/core/domain/templates.dart';
import 'package:rakubavote/features/register_lock/review_service.dart';
import 'package:rakubavote/features/registration/registration_service.dart';
import 'package:rakubavote/features/setup/election_service.dart';

import '../support/fixtures.dart';

void main() {
  late RegistryDb db;
  late DeviceKeys station;
  late ElectionService setup;
  late RegistrationService reg;
  late ReviewService review;
  late String id;
  const po = 'Presiding officer';

  setUp(() async {
    db = memoryRegistry();
    station = await DeviceKeys.generate();
    setup = ElectionService(db, station);
    reg = RegistrationService(db, clock: () => DateTime(2026, 11, 1));
    review = ReviewService(db, station, clock: () => DateTime(2026, 11, 3, 14));
    id = await setup.createElection(
        template: ElectionTemplate.association, orgName: 'CIEC', name: 'Election', year: 2026,
        stationName: 'Station 1', languages: ['en'], official: po);
    for (final p in await setup.positions(id)) {
      await setup.saveCandidate(positionId: p.id, number: 1, name: 'A', official: po);
      await setup.saveCandidate(positionId: p.id, number: 2, name: 'B', official: po);
    }
    for (final n in ['Mary Achol Deng', 'Peter Lado', 'Mary Akol Deng', 'John Garang']) {
      await reg.register(id, VoterInput(fullName: n, groupName: 'Juba'), official: po);
    }
  });
  tearDown(() => db.close());

  test('display period moves the election into review', () async {
    await review.setDisplayPeriod(id, start: DateTime(2026, 11, 2), end: DateTime(2026, 11, 9), official: po);
    final e = (await setup.currentElection())!;
    expect(e.state, 'review');
    expect(e.reviewEnd, DateTime(2026, 11, 9));
    expect(
      () => review.setDisplayPeriod(id, start: DateTime(2026, 11, 9), end: DateTime(2026, 11, 2), official: po),
      throwsA(isA<ReviewException>()),
    );
  });

  test('suggests duplicate pairs without changing anything', () async {
    final pairs = await review.possibleDuplicatePairs(id);
    expect(pairs.map((p) => (p.a.voterNo, p.b.voterNo)), [(1, 3)]);
    expect(await reg.voterCount(id), 4);
  });

  group('objections', () {
    test('duplicate: remove takes the voter off the register, number not reused', () async {
      final o = await review.raiseObjection(id,
          kind: ObjectionKind.duplicate, subjectVoterNo: 3, otherVoterNo: 1,
          raisedByName: 'Agent of candidate 2', official: po);
      expect(await review.openObjectionCount(id), 1);
      expect(await review.decide(o, ObjectionDecision.remove, official: po), 3);
      expect(await reg.voterCount(id), 3);
      expect(await review.openObjectionCount(id), 0);
      final next = await reg.register(id, const VoterInput(fullName: 'New'), official: po);
      expect(next.voterNo, 5);
    });

    test('duplicate: keep both changes nothing', () async {
      final o = await review.raiseObjection(id,
          kind: ObjectionKind.duplicate, subjectVoterNo: 3, otherVoterNo: 1, raisedByName: 'X', official: po);
      expect(await review.decide(o, ObjectionDecision.keepBoth, official: po), isNull);
      expect(await reg.voterCount(id), 4);
    });

    test('missing name: add registers the claimant with a new number', () async {
      final o = await review.raiseObjection(id,
          kind: ObjectionKind.missing, claimantName: 'Rebecca Nyandeng', raisedByName: 'Rebecca Nyandeng',
          detail: 'Registered on 28 October, paper record page 4', official: po);
      final n = await review.decide(o, ObjectionDecision.add,
          official: po, newVoter: const VoterInput(fullName: 'Rebecca Nyandeng', groupName: 'Juba'));
      expect(n, 5);
      expect((await review.voterByNumber(id, 5))!.fullName, 'Rebecca Nyandeng');
    });

    test('a decision must fit the kind and is made once', () async {
      final o = await review.raiseObjection(id,
          kind: ObjectionKind.missing, claimantName: 'Someone', raisedByName: 'Someone', official: po);
      expect(() => review.decide(o, ObjectionDecision.remove, official: po),
          throwsA(isA<ReviewException>().having((e) => e.failure, 'f', ReviewFailure.decisionNotAllowed)));
      await review.decide(o, ObjectionDecision.reject, official: po);
      expect(() => review.decide(o, ObjectionDecision.add, official: po),
          throwsA(isA<ReviewException>().having((e) => e.failure, 'f', ReviewFailure.alreadyDecided)));
    });

    test('an objection about an unknown voter number is refused', () async {
      expect(
        () => review.raiseObjection(id,
            kind: ObjectionKind.duplicate, subjectVoterNo: 99, otherVoterNo: 1, raisedByName: 'X', official: po),
        throwsA(isA<ReviewException>().having((e) => e.failure, 'f', ReviewFailure.voterNotFound)),
      );
    });

    test('every objection and decision is in the audit log, without names', () async {
      final o = await review.raiseObjection(id,
          kind: ObjectionKind.missing, claimantName: 'Rebecca Nyandeng', raisedByName: 'Rebecca Nyandeng',
          official: po);
      await review.decide(o, ObjectionDecision.reject, official: 'Second official');
      final entries = await review.audit.entries();
      expect(entries.map((e) => e.action), containsAllInOrder([AuditAction.objectionRaised, AuditAction.objectionDecided]));
      expect(entries.last.actor, 'Second official');
      expect(entries.map((e) => e.payload).join(), isNot(contains('Rebecca')));
    });
  });

  group('lock', () {
    test('needs a signed ballot', () async {
      expect(() => review.lockRegister(id, official: po),
          throwsA(isA<ReviewException>().having((e) => e.failure, 'f', ReviewFailure.ballotNotSigned)));
    });

    test('needs every objection resolved', () async {
      await setup.signBallot(id, official: po);
      await review.raiseObjection(id,
          kind: ObjectionKind.duplicate, subjectVoterNo: 3, otherVoterNo: 1, raisedByName: 'X', official: po);
      expect(() => review.lockRegister(id, official: po),
          throwsA(isA<ReviewException>().having((e) => e.failure, 'f', ReviewFailure.openObjections)));
    });

    test('signs the active register, bound to the ballot, with a fingerprint', () async {
      final ballot = await setup.signBallot(id, official: po);
      final o = await review.raiseObjection(id,
          kind: ObjectionKind.duplicate, subjectVoterNo: 3, otherVoterNo: 1, raisedByName: 'X', official: po);
      await review.decide(o, ObjectionDecision.remove, official: po);

      final signed = await review.lockRegister(id, official: po);
      final again = await SignedArtifact.parseAndVerify(signed.encode(),
          expectedKind: ArtifactKind.register, trustedSigners: [station.signingPublic]);
      final snap = RegisterSnapshot.fromJson(again.payload);
      expect(snap.entries.map((e) => e.voterNo), [1, 2, 4]);
      expect(snap.ballotHash, ballot.hashHex);
      expect(snap.toJson().toString(), isNot(contains('fee')), reason: 'fee data is not in the register');
      expect((await review.lockRecord(id))!.fingerprint, signed.fingerprint);
      expect((await setup.currentElection())!.state, 'locked');
      expect(await review.checkLockedRegister(id), RegisterCheck.valid);
    });

    test('after locking: no registration, no objections, no ballot changes', () async {
      await setup.signBallot(id, official: po);
      await review.lockRegister(id, official: po);
      expect(() => reg.register(id, const VoterInput(fullName: 'Late'), official: po),
          throwsA(isA<RegistrationException>().having((e) => e.failure, 'f', RegistrationFailure.registerLocked)));
      expect(
        () => review.raiseObjection(id,
            kind: ObjectionKind.missing, claimantName: 'Late', raisedByName: 'Late', official: po),
        throwsA(isA<ReviewException>().having((e) => e.failure, 'f', ReviewFailure.registerLocked)),
      );
      final chair = (await setup.positions(id)).first;
      expect(() => setup.updatePosition(chair.id, chooseN: 2, official: po),
          throwsA(isA<SetupException>().having((e) => e.failure, 'f', SetupFailure.ballotFrozen)));
      expect(() => review.lockRegister(id, official: po), throwsA(isA<ReviewException>()));
    });

    test('a lost card can still be replaced after locking; the register still checks', () async {
      await setup.signBallot(id, official: po);
      await review.lockRegister(id, official: po);
      final v = (await review.voterByNumber(id, 2))!;
      await reg.replaceCard(v.id, official: po, reason: 'Lost');
      expect(await review.checkLockedRegister(id), RegisterCheck.valid);
    });

    test('a change made around the database guards is detected', () async {
      await setup.signBallot(id, official: po);
      await review.lockRegister(id, official: po);
      await db.customStatement('DROP TRIGGER register_locked_update');
      await db.customStatement("UPDATE voters SET full_name = 'Someone Else' WHERE voter_no = 2");
      expect(await review.checkLockedRegister(id), RegisterCheck.changedSinceLock);
    });

    test('a register signed by another laptop fails the check', () async {
      await setup.signBallot(id, official: po);
      await review.lockRegister(id, official: po);
      final other = ReviewService(db, await DeviceKeys.generate());
      expect(await other.checkLockedRegister(id), RegisterCheck.badSignature);
    });
  });
}

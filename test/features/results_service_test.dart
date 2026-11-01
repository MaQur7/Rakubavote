import 'package:flutter_test/flutter_test.dart';
import 'package:rakubavote/core/crypto/device_keys.dart';
import 'package:rakubavote/core/crypto/signed_artifact.dart';
import 'package:rakubavote/core/crypto/voting_token.dart';
import 'package:rakubavote/core/db/ballot_box_db.dart';
import 'package:rakubavote/core/db/ballot_box_repository.dart';
import 'package:rakubavote/core/db/registry_db.dart';
import 'package:rakubavote/core/domain/vote.dart';
import 'package:rakubavote/features/checkin/checkin_service.dart';
import 'package:rakubavote/features/results/results_service.dart';
import 'package:rakubavote/station/enrollment.dart';

import '../support/election_builder.dart';
import '../support/fixtures.dart';

void main() {
  late RegistryDb registry;
  late BallotBoxDb laptopBox;
  late DeviceKeys station;
  late String id;
  late ResultsService results;
  late CheckInService desk;
  late List<BallotBoxRepository> booths;
  const po = 'Presiding officer';

  setUp(() async {
    registry = memoryRegistry();
    laptopBox = memoryBallotBox();
    station = await DeviceKeys.generate();
    id = await buildLockedElection(registry, station, voters: 10);
    results = ResultsService(registry, laptopBox, station);
    desk = CheckInService(registry, station);
    final signedBallot = (await (registry.select(registry.elections)).getSingle()).signedBallot!;
    booths = [];
    for (var i = 0; i < 2; i++) {
      final keys = await DeviceKeys.generate();
      await EnrollmentService(registry).enroll(
          role: DeviceRole.booth, signingPublic: keys.signingPublic, exchangePublic: keys.exchangePublic,
          label: 'Booth ${i + 1}', official: po);
      final repo = BallotBoxRepository(memoryBallotBox(), keys);
      await repo.loadBallot(signedBallot, stationPublicKey: station.signingPublic);
      booths.add(repo);
    }
  });
  tearDown(() async {
    await registry.close();
    await laptopBox.close();
    for (final b in booths) {
      await b.db.close();
    }
  });

  /// Checks in voter [n] and votes at [booth] for candidate [pick] everywhere.
  Future<void> vote(int n, int booth, int pick) async {
    final v = await (registry.select(registry.voters)..where((x) => x.voterNo.equals(n))).getSingle();
    final token = await desk.checkIn(v.id, method: 'name', official: 'Desk');
    final hash = VotingToken.tokenHash(id, token);
    for (final b in booths) {
      await b.activateToken(hash);
    }
    final repo = booths[booth];
    await repo.castBallot(tokenHash: hash, selections: {
      for (final p in repo.ballot!.positions) p.id: [p.candidates[pick].id],
    });
  }

  test('close, collect, count and sign', () async {
    await vote(1, 0, 0);
    await vote(2, 0, 1);
    await vote(3, 1, 0);
    await vote(4, 1, 0);
    // Voter 5 checks in but walks away.
    final v5 = await (registry.select(registry.voters)..where((x) => x.voterNo.equals(5))).getSingle();
    await desk.checkIn(v5.id, method: 'name', official: 'Desk');

    await expectLater(results.computeResults(official: po),
        throwsA(isA<ResultsException>().having((e) => e.failure, 'f', ResultsFailure.pollsNotClosed)));
    await results.closePolls(official: po);
    await expectLater(desk.checkIn(v5.id, method: 'name', official: 'Desk'), throwsA(isA<CheckInException>()));

    for (final b in booths) {
      await results.importBatch((await b.exportBatch()).encode(), official: po);
    }
    final status = await results.batchStatus();
    expect(status.map((s) => s.ballots), [2, 2]);

    final signed = await results.computeResults(official: po);
    await signed.verify(expectedKind: ArtifactKind.results, trustedSigners: [station.signingPublic]);
    final view = (await results.currentResults())!;
    expect(view.signed.fingerprint, signed.fingerprint);
    final chair = view.positions.first;
    expect([for (final c in chair['candidates'] as List) (c as Map)['votes']], [3, 1]);
    expect(chair['tie'], isEmpty);
    expect(view.reconciliation['checkedIn'], 5);
    expect(view.reconciliation['ballots'], 4);
    expect(view.reconciliation['tokensUsed'], 4);
    expect(view.checkInsMatchVotes, isFalse, reason: 'one checked-in voter did not vote');
    expect(view.clean, isTrue);

    final qr = await results.qrSummary(signed);
    expect(qr.encode().length, lessThan(1200), reason: 'fits in one QR code');
    expect(qr.payload['r'], signed.hashHex);
  });

  test('a tie is flagged, not broken', () async {
    await vote(1, 0, 0);
    await vote(2, 1, 1);
    await results.closePolls(official: po);
    for (final b in booths) {
      await results.importBatch((await b.exportBatch()).encode(), official: po);
    }
    final view = ResultsView(await results.computeResults(official: po));
    expect((view.positions.first['tie'] as List), hasLength(2));
    expect(view.payload.keys, isNot(contains('winners')));
  });

  test('batches from unknown booths, other elections or older exports are refused', () async {
    await vote(1, 0, 0);
    final rogue = BallotBoxRepository(memoryBallotBox(), await DeviceKeys.generate());
    await rogue.loadBallot((await (registry.select(registry.elections)).getSingle()).signedBallot!,
        stationPublicKey: station.signingPublic);
    await expectLater(results.importBatch((await rogue.exportBatch()).encode(), official: po),
        throwsA(isA<ResultsException>().having((e) => e.failure, 'f', ResultsFailure.unknownBooth)));
    await rogue.db.close();

    final first = await booths[0].exportBatch();
    final second = await booths[0].exportBatch();
    await results.importBatch(second.encode(), official: po);
    await expectLater(results.importBatch(first.encode(), official: po),
        throwsA(isA<ResultsException>().having((e) => e.failure, 'f', ResultsFailure.olderBatch)));
    await expectLater(results.importBatch('not json', official: po),
        throwsA(isA<ResultsException>().having((e) => e.failure, 'f', ResultsFailure.badBatch)));
  });

  test('a late batch can be added and results counted again', () async {
    await vote(1, 0, 0);
    await vote(2, 1, 0);
    await results.closePolls(official: po);
    await results.importBatch((await booths[0].exportBatch()).encode(), official: po);
    final early = ResultsView(await results.computeResults(official: po));
    expect(early.reconciliation['ballots'], 1);
    await results.importBatch((await booths[1].exportBatch()).encode(), official: po);
    final late = ResultsView(await results.computeResults(official: po));
    expect(late.reconciliation['ballots'], 2);
    expect(late.checkInsMatchVotes, isTrue);
  });

  test('a revoked booth is not counted', () async {
    await vote(1, 0, 0);
    await vote(2, 1, 0);
    await results.closePolls(official: po);
    for (final b in booths) {
      await results.importBatch((await b.exportBatch()).encode(), official: po);
    }
    await EnrollmentService(registry).revoke(booths[1].boothKeys.deviceId, official: po);
    final view = ResultsView(await results.computeResults(official: po));
    expect(view.reconciliation['ballots'], 1);
  });

  test('the results file holds no voter or code data', () async {
    await vote(1, 0, 0);
    await results.closePolls(official: po);
    await results.importBatch((await booths[0].exportBatch()).encode(), official: po);
    final text = (await results.computeResults(official: po)).encode();
    final voters = await registry.select(registry.voters).get();
    for (final v in voters) {
      expect(text.contains(v.fullName), isFalse);
      expect(text.contains(v.id), isFalse);
    }
    for (final t in await registry.select(registry.issuedTokens).get()) {
      expect(text.contains(t.tokenHash), isFalse);
    }
    expect(noChoice, isNotEmpty);
  });
}

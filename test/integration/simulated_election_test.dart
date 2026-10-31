import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:rakubavote/core/counting/combine.dart';
import 'package:rakubavote/core/counting/reconciliation.dart';
import 'package:rakubavote/core/counting/tally.dart';
import 'package:rakubavote/core/crypto/device_keys.dart';
import 'package:rakubavote/core/crypto/signed_artifact.dart';
import 'package:rakubavote/core/crypto/voting_token.dart';
import 'package:rakubavote/core/db/ballot_box_db.dart';
import 'package:rakubavote/core/db/ballot_box_repository.dart';
import 'package:rakubavote/core/domain/ballot_definition.dart';
import 'package:rakubavote/core/domain/vote.dart';
import 'package:rakubavote/core/domain/vote_batch.dart';

import '../support/fixtures.dart';
import '../support/simulated_checkin.dart';

/// A full simulated election: 500 registered voters, 3 booths, a ballot with
/// a 13-candidate position. Check-in, live code activation, voting, closing,
/// batch verification, counting and reconciliation. Expected counts are kept
/// separately from the app's data and compared at the end.
void main() {
  test('500-voter election across three booths counts exactly', () async {
    const electionId = 'sim-2026';
    final rng = Random(20261105);
    final ballot = sampleBallot(electionId: electionId, withLargePosition: true);

    final station = await DeviceKeys.generate();
    final registry = memoryRegistry();
    await seedRegister(registry, electionId, 500);
    final signedBallot = await SignedArtifact.sign(ArtifactKind.ballot, ballot.toJson(), station);

    final booths = <BallotBoxRepository>[];
    final boxes = <BallotBoxDb>[];
    for (var i = 0; i < 3; i++) {
      final box = memoryBallotBox();
      boxes.add(box);
      final repo = BallotBoxRepository(box, await DeviceKeys.generate());
      await repo.loadBallot(signedBallot.encode(), stationPublicKey: station.signingPublic);
      booths.add(repo);
    }

    // What voters actually chose, kept outside the system for comparison.
    final expected = {for (final p in ballot.positions) p.id: <String, int>{}};
    void remember(Map<String, List<String>> sel) {
      sel.forEach((pid, choices) {
        for (final c in choices) {
          expected[pid]![c] = (expected[pid]![c] ?? 0) + 1;
        }
      });
    }

    Map<String, List<String>> randomSelection(BallotDefinition b) => {
          for (final p in b.positions)
            p.id: (p.allowNoChoice && rng.nextInt(12) == 0)
                ? [noChoice]
                : [p.candidates[rng.nextInt(p.candidates.length)].id],
        };

    // Turnout: 470 of 500 check in; 3 of those leave without voting.
    final order = List.generate(500, (i) => i + 1)..shuffle(rng);
    final turnout = order.take(470).toList();
    final walkedAway = turnout.take(3).toSet();
    var hour = 7;
    var voted = 0;

    for (var k = 0; k < turnout.length; k++) {
      if (k % 60 == 0) hour++;
      final voterNo = turnout[k];
      final token = await simulateCheckIn(registry, electionId, 'voter-$voterNo',
          hour: '2026-11-05T${hour.toString().padLeft(2, '0')}');
      final hash = VotingToken.tokenHash(electionId, token);
      // Live activation: the laptop broadcasts the hash to every booth.
      for (final b in booths) {
        await b.activateToken(hash);
      }
      if (walkedAway.contains(voterNo)) continue;

      final booth = booths[rng.nextInt(booths.length)];
      // The voter types the code as printed on the slip.
      final typed = VotingToken.normalise(VotingToken.format(token).toLowerCase())!;
      final typedHash = VotingToken.tokenHash(electionId, typed);
      final sel = randomSelection(ballot);
      await booth.castBallot(tokenHash: typedHash, selections: sel);
      remember(sel);
      voted++;
      for (final other in booths.where((b) => b != booth)) {
        await other.markUsedElsewhere(typedHash);
      }
    }

    // Closing: each booth signs its batch; the laptop verifies every signature.
    final enrolled = [for (final b in booths) b.boothKeys.signingPublic];
    final verified = <VoteBatch>[];
    for (final b in booths) {
      final signed = await b.exportBatch();
      final roundTrip = SignedArtifact.parse(signed.encode());
      verified.add(await VoteBatch.verifySigned(roundTrip,
          electionId: electionId, enrolledBoothKeys: enrolled));
    }

    final issued = {
      for (final t in await registry.select(registry.issuedTokens).get()) t.tokenHash,
    };
    final combined = combineBatches(verified, issuedTokenHashes: issued);
    expect(combined.clean, isTrue);

    final result = tally(ballot, combined.rows);
    expect(result.ballotCount, voted);
    expect(result.hasProblems, isFalse);
    for (final p in result.positions) {
      for (final c in p.counts) {
        expect(c.votes, expected[p.position.id]![c.candidate.id] ?? 0,
            reason: '${p.position.id}/${c.candidate.id}');
      }
      expect(p.noChoice, expected[p.position.id]![noChoice] ?? 0);
      expect(p.ballots, voted);
    }

    final checkIns = await registry.select(registry.checkIns).get();
    final rec = Reconciliation(
      registered: 500,
      checkedIn: checkIns.length,
      manualCheckIns: 0,
      tokensIssued: issued.length,
      tokensUsed: combined.tokensUsed,
      ballots: result.ballotCount,
    );
    expect(rec.checkedIn, 470);
    expect(rec.ballots, 467);
    expect(rec.checkInsMatchVotes, isFalse);
    expect(rec.issues, ['3 checked-in voter(s) did not use their code.']);

    // The signed results reproduce the same fingerprint when signed data is re-read.
    final signedResults =
        await SignedArtifact.sign(ArtifactKind.results, result.toJson(), station);
    final reread = await SignedArtifact.parseAndVerify(signedResults.encode(),
        expectedKind: ArtifactKind.results, trustedSigners: [station.signingPublic]);
    expect(reread.fingerprint, signedResults.fingerprint);

    await registry.close();
    for (final b in boxes) {
      await b.close();
    }
  }, timeout: const Timeout(Duration(minutes: 5)));

  test('a code used at two booths while Wi-Fi was down is caught at closing', () async {
    const electionId = 'e-offline';
    final station = await DeviceKeys.generate();
    final signed = await SignedArtifact.sign(
        ArtifactKind.ballot, sampleBallot(electionId: electionId).toJson(), station);
    final a = BallotBoxRepository(memoryBallotBox(), await DeviceKeys.generate());
    final b = BallotBoxRepository(memoryBallotBox(), await DeviceKeys.generate());
    for (final r in [a, b]) {
      await r.loadBallot(signed.encode(), stationPublicKey: station.signingPublic);
    }
    final hash = VotingToken.tokenHash(electionId, 'ABCDEF');
    await a.activateToken(hash);
    await b.activateToken(hash);
    final sel = {'chair': ['chair-c1'], 'secgen': ['secgen-c1'], 'fin': ['fin-c1']};
    await a.castBallot(tokenHash: hash, selections: sel);
    await b.castBallot(tokenHash: hash, selections: sel); // "used" message never arrived
    final batches = [
      for (final r in [a, b])
        await VoteBatch.verifySigned(await r.exportBatch(),
            electionId: electionId,
            enrolledBoothKeys: [a.boothKeys.signingPublic, b.boothKeys.signingPublic]),
    ];
    final combined = combineBatches(batches, issuedTokenHashes: {hash});
    expect(combined.codesUsedAtTwoBooths, 1);
    expect(combined.tokensUsed, 2);
    expect(combined.clean, isFalse);
  });

  test('a batch from a booth that was not enrolled is rejected', () async {
    final station = await DeviceKeys.generate();
    final signed = await SignedArtifact.sign(ArtifactKind.ballot, sampleBallot().toJson(), station);
    final rogue = BallotBoxRepository(memoryBallotBox(), await DeviceKeys.generate());
    await rogue.loadBallot(signed.encode(), stationPublicKey: station.signingPublic);
    final batch = await rogue.exportBatch();
    final enrolled = await DeviceKeys.generate();
    await expectLater(
        VoteBatch.verifySigned(batch, electionId: 'e1', enrolledBoothKeys: [enrolled.signingPublic]),
        throwsA(isA<ArtifactVerificationException>()));
  });

  test('a vote changed inside a signed batch is rejected', () async {
    const electionId = 'e1';
    final station = await DeviceKeys.generate();
    final signed = await SignedArtifact.sign(ArtifactKind.ballot, sampleBallot().toJson(), station);
    final repo = BallotBoxRepository(memoryBallotBox(), await DeviceKeys.generate());
    await repo.loadBallot(signed.encode(), stationPublicKey: station.signingPublic);
    final hash = VotingToken.tokenHash(electionId, 'ABCDEF');
    await repo.activateToken(hash);
    await repo.castBallot(
        tokenHash: hash, selections: {'chair': ['chair-c1'], 'secgen': ['secgen-c1'], 'fin': ['fin-c1']});
    final json = (await repo.exportBatch()).toJson();
    ((json['payload'] as Map)['votes'] as List).first['c'] = ['chair-c2'];
    await expectLater(
        VoteBatch.verifySigned(SignedArtifact.parse(json),
            electionId: electionId, enrolledBoothKeys: [repo.boothKeys.signingPublic]),
        throwsA(isA<ArtifactVerificationException>()));
  });
}

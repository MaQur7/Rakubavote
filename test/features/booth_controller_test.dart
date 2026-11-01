import 'package:flutter_test/flutter_test.dart';
import 'package:rakubavote/core/counting/tally.dart';
import 'package:rakubavote/core/crypto/device_keys.dart';
import 'package:rakubavote/core/crypto/signed_artifact.dart';
import 'package:rakubavote/core/crypto/voting_token.dart';
import 'package:rakubavote/core/db/ballot_box_repository.dart';
import 'package:rakubavote/core/domain/vote.dart';
import 'package:rakubavote/features/booth/booth_controller.dart';

import '../support/fixtures.dart';

void main() {
  late BallotBoxRepository repo;
  late BoothController booth;
  var now = DateTime(2026, 11, 5, 10);

  Future<void> activate(String code) =>
      repo.activateToken(VotingToken.tokenHash('e1', VotingToken.normalise(code)!));

  setUp(() async {
    final station = await DeviceKeys.generate();
    repo = BallotBoxRepository(memoryBallotBox(), await DeviceKeys.generate());
    final signed = await SignedArtifact.sign(
        ArtifactKind.ballot, sampleBallot(withLargePosition: true, chooseNForSecretary: 2).toJson(), station);
    await repo.loadBallot(signed.encode(), stationPublicKey: station.signingPublic);
    now = DateTime(2026, 11, 5, 10);
    booth = BoothController(repo, clock: () => now);
  });
  tearDown(() => repo.db.close());

  group('code', () {
    test('an activated code starts the ballot; typing is forgiving', () async {
      await activate('7K4Q9M');
      expect(await booth.submitCode('7k4-q9m '), isNull);
      expect(booth.stage, BoothStage.position);
      expect(booth.index, 0);
    });

    test('unknown, malformed and used codes are explained', () async {
      expect(await booth.submitCode('ABCDEF'), CodeProblem.notFound);
      expect(await booth.submitCode('12'), CodeProblem.notFound);
      await activate('7K4Q9M');
      await booth.submitCode('7K4Q9M');
      for (final p in booth.ballot.positions) {
        booth.index = booth.ballot.positions.indexOf(p);
        p.allowNoChoice ? booth.tapNoChoice() : booth.tapCandidate(p.candidates.first.id);
      }
      booth.stage = BoothStage.review;
      await booth.confirm();
      booth.reset();
      expect(await booth.submitCode('7K4Q9M'), CodeProblem.alreadyUsed);
    });

    test('after five wrong codes the booth pauses for a minute', () async {
      for (var i = 0; i < 4; i++) {
        expect(await booth.submitCode('ABCDEF'), CodeProblem.notFound);
      }
      expect(await booth.submitCode('ABCDEF'), CodeProblem.tooManyTries);
      await activate('7K4Q9M');
      expect(await booth.submitCode('7K4Q9M'), CodeProblem.tooManyTries);
      now = now.add(const Duration(minutes: 1, seconds: 1));
      expect(await booth.submitCode('7K4Q9M'), isNull);
    });
  });

  group('choosing', () {
    setUp(() async {
      await activate('7K4Q9M');
      await booth.submitCode('7K4Q9M');
    });

    test('choose one: tapping another candidate replaces the choice', () {
      final p = booth.position;
      expect(booth.canContinue, isFalse);
      booth.tapCandidate(p.candidates[0].id);
      booth.tapCandidate(p.candidates[1].id);
      expect(booth.selectionFor(p.id), [p.candidates[1].id]);
      booth.tapNoChoice();
      expect(booth.selectionFor(p.id), [noChoice]);
      booth.tapCandidate(p.candidates[0].id);
      expect(booth.selectionFor(p.id), [p.candidates[0].id]);
      expect(booth.canContinue, isTrue);
    });

    test('choose N: adds up to N, a second tap removes', () {
      booth.tapCandidate(booth.position.candidates[0].id);
      booth.next();
      final p = booth.position; // Secretary General, choose 2 of 4
      expect(p.chooseN, 2);
      booth.tapCandidate(p.candidates[0].id);
      booth.tapCandidate(p.candidates[1].id);
      booth.tapCandidate(p.candidates[2].id); // ignored: already two
      expect(booth.selectionFor(p.id), [p.candidates[0].id, p.candidates[1].id]);
      booth.tapCandidate(p.candidates[0].id);
      expect(booth.selectionFor(p.id), [p.candidates[1].id]);
    });

    test('number entry picks the candidate with that number', () {
      while (booth.position.candidates.length < 13) {
        booth.position.allowNoChoice ? booth.tapNoChoice() : null;
        booth.next();
      }
      expect(booth.chooseByNumber(7), isTrue);
      expect(booth.selectionFor(booth.position.id), ['flag-c7']);
      expect(booth.chooseByNumber(14), isFalse);
    });

    test('next needs a choice; review after the last; change returns to review', () {
      booth.next();
      expect(booth.index, 0, reason: 'no choice made yet');
      for (var i = 0; i < booth.positionCount; i++) {
        booth.tapNoChoice();
        expect(booth.nextPosition == null, booth.isLastPosition);
        booth.next();
      }
      expect(booth.stage, BoothStage.review);
      booth.change(1);
      expect(booth.stage, BoothStage.position);
      expect(booth.index, 1);
      expect(booth.nextPosition, isNull, reason: 'button says Review when changing');
      booth.tapCandidate(booth.position.candidates.first.id);
      booth.next();
      expect(booth.stage, BoothStage.review);
    });

    test('back from the first position returns to the welcome screen', () {
      booth.back();
      expect(booth.stage, BoothStage.welcome);
    });
  });

  test('confirm saves exactly the choices, then reset forgets them', () async {
    await activate('7K4Q9M');
    await booth.submitCode('7K4Q9M');
    booth.setLanguage('ar');
    expect(booth.locale, 'ar');
    booth.tapCandidate('chair-c2');
    booth.next();
    booth.tapCandidate('secgen-c1');
    booth.tapCandidate('secgen-c3');
    booth.next();
    booth.tapNoChoice();
    booth.next();
    booth.chooseByNumber(11);
    booth.next();
    expect(booth.stage, BoothStage.review);
    await booth.confirm();
    expect(booth.stage, BoothStage.end);

    final r = tally(booth.ballot, await repo.allVotes());
    expect(r.ballotCount, 1);
    expect(r.positions[0].counts.map((c) => c.votes), [0, 1]);
    expect(r.positions[1].counts.map((c) => c.votes), [1, 0, 1, 0]);
    expect(r.positions[2].noChoice, 1);
    expect(r.positions[3].counts[10].votes, 1);

    booth.reset();
    expect(booth.stage, BoothStage.welcome);
    expect(booth.locale, 'en');
    expect(booth.selectionFor('chair'), isEmpty);
  });
}

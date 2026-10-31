import 'package:flutter_test/flutter_test.dart';
import 'package:rakubavote/core/counting/reconciliation.dart';
import 'package:rakubavote/core/counting/tally.dart';
import 'package:rakubavote/core/crypto/bytes.dart';
import 'package:rakubavote/core/domain/vote.dart';

import '../support/fixtures.dart';

VoteRow row(String ballot, String position, List<String> choices) =>
    VoteRow(ballotId: ballot, positionId: position, choices: VoteRow.normaliseChoices(choices), signature: '');

List<VoteRow> ballotRows(String id, {String chair = 'chair-c1', String secgen = 'secgen-c1', String fin = 'fin-c1'}) =>
    [row(id, 'chair', [chair]), row(id, 'secgen', [secgen]), row(id, 'fin', [fin])];

void main() {
  final ballot = sampleBallot();

  test('counts each position, in candidate-number order', () {
    final rows = [
      ...ballotRows('b1'),
      ...ballotRows('b2', chair: 'chair-c2'),
      ...ballotRows('b3', fin: noChoice),
    ];
    final r = tally(ballot, rows);
    expect(r.ballotCount, 3);
    expect(r.hasProblems, isFalse);
    final chair = r.positions[0];
    expect(chair.counts.map((c) => c.votes), [2, 1]);
    expect(chair.counts.map((c) => c.candidate.number), [1, 2]);
    expect(r.positions[2].noChoice, 1);
    expect(r.positions[2].counts.first.votes, 2);
  });

  test('result does not depend on the order of the rows', () {
    final rows = [for (var i = 0; i < 60; i++) ...ballotRows('b$i', chair: i.isEven ? 'chair-c1' : 'chair-c2')];
    final a = tally(ballot, rows).toJson();
    final shuffled = [...rows];
    secureShuffle(shuffled);
    expect(tally(ballot, shuffled).toJson(), a);
  });

  test('a tie at the top is flagged, never broken', () {
    final rows = [
      ...ballotRows('b1', secgen: 'secgen-c1'),
      ...ballotRows('b2', secgen: 'secgen-c2'),
    ];
    final secgen = tally(ballot, rows).positions[1];
    expect(secgen.hasTie, isTrue);
    expect(secgen.tiedAtCutoff.map((c) => c.id), containsAll(['secgen-c1', 'secgen-c2']));
    // The result carries counts and the tie flag only: there is no "winner" field.
    expect(secgen.toJson().keys, isNot(contains('winner')));
  });

  test('no tie when one candidate leads', () {
    final rows = [...ballotRows('b1'), ...ballotRows('b2'), ...ballotRows('b3', chair: 'chair-c2')];
    expect(tally(ballot, rows).positions[0].hasTie, isFalse);
  });

  group('choose N', () {
    final b = sampleBallot(chooseNForSecretary: 2);
    test('up to N choices count for each candidate', () {
      final rows = [
        row('b1', 'chair', ['chair-c1']),
        row('b1', 'secgen', ['secgen-c1', 'secgen-c3']),
        row('b1', 'fin', ['fin-c1']),
      ];
      final r = tally(b, rows).positions[1];
      expect(r.invalid, 0);
      expect(r.counts.map((c) => c.votes), [1, 0, 1, 0]);
    });
    test('more than N choices is invalid', () {
      final rows = [row('b1', 'secgen', ['secgen-c1', 'secgen-c2', 'secgen-c3'])];
      expect(tally(b, rows).positions[1].invalid, 1);
    });
    test('tie at the edge of the N places is flagged', () {
      final rows = [
        row('b1', 'secgen', ['secgen-c1', 'secgen-c2']),
        row('b2', 'secgen', ['secgen-c1', 'secgen-c3']),
      ];
      final p = tally(b, rows).positions[1];
      expect(p.tiedAtCutoff.map((c) => c.id), unorderedEquals(['secgen-c2', 'secgen-c3']));
    });
  });

  test('invalid rows are counted as invalid, not as votes', () {
    final rows = [
      row('b1', 'chair', ['fin-c1']), // candidate from another position
      row('b2', 'chair', [noChoice, 'chair-c1']), // no choice mixed with a choice
      row('b3', 'chair', []),
      row('b4', 'nope', ['x']),
    ];
    final r = tally(ballot, rows);
    expect(r.positions[0].invalid, 3);
    expect(r.positions[0].counts.every((c) => c.votes == 0), isTrue);
    expect(r.unknownPositionRows, 1);
    expect(r.hasProblems, isTrue);
  });

  test('a ballot missing a position is reported', () {
    final r = tally(ballot, [row('b1', 'chair', ['chair-c1'])]);
    expect(r.incompleteBallots, 1);
  });

  test('13 candidates are counted correctly', () {
    final b = sampleBallot(withLargePosition: true);
    final rows = <VoteRow>[];
    for (var i = 0; i < 130; i++) {
      rows.addAll([...ballotRows('b$i'), row('b$i', 'flag', ['flag-c${i % 13 + 1}'])]);
    }
    final flag = tally(b, rows).positions[3];
    expect(flag.counts, hasLength(13));
    expect(flag.counts.every((c) => c.votes == 10), isTrue);
    expect(flag.hasTie, isTrue);
  });

  group('reconciliation', () {
    test('matching numbers pass', () {
      const r = Reconciliation(
          registered: 100, checkedIn: 80, manualCheckIns: 2, tokensIssued: 80, tokensUsed: 80, ballots: 80);
      expect(r.checkInsMatchVotes, isTrue);
      expect(r.issues, isEmpty);
    });
    test('an unused code is explained', () {
      const r = Reconciliation(
          registered: 100, checkedIn: 80, manualCheckIns: 0, tokensIssued: 80, tokensUsed: 79, ballots: 79);
      expect(r.checkInsMatchVotes, isFalse);
      expect(r.issues.single, contains('did not use'));
    });
    test('more ballots than codes is flagged', () {
      const r = Reconciliation(
          registered: 100, checkedIn: 80, manualCheckIns: 0, tokensIssued: 80, tokensUsed: 80, ballots: 81);
      expect(r.issues, contains('Ballots (81) differ from codes used (80).'));
    });
  });
}

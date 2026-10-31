import '../crypto/bytes.dart';
import '../domain/ballot_definition.dart';
import '../domain/vote.dart';

class CandidateCount {
  const CandidateCount(this.candidate, this.votes);
  final CandidateDef candidate;
  final int votes;
}

/// Count for one position. Ties are flagged and recorded only: the platform
/// never breaks a tie or declares a winner by rule (decision D3).
class PositionResult {
  PositionResult({
    required this.position,
    required this.counts,
    required this.noChoice,
    required this.invalid,
    required this.ballots,
  });

  final PositionDef position;
  /// In ballot order (by candidate number), not ranked.
  final List<CandidateCount> counts;
  final int noChoice;
  final int invalid;
  final int ballots;

  /// Candidates sharing the vote count at the edge of the [PositionDef.chooseN]
  /// places, where the order of the top candidates is not decided by votes.
  /// Empty when there is no tie at that edge.
  List<CandidateDef> get tiedAtCutoff {
    final n = position.chooseN;
    if (counts.length <= n) return const [];
    final ranked = [...counts]..sort((a, b) => b.votes.compareTo(a.votes));
    final edge = ranked[n - 1].votes;
    if (ranked[n].votes != edge) return const [];
    return [for (final c in ranked) if (c.votes == edge) c.candidate];
  }

  bool get hasTie => tiedAtCutoff.isNotEmpty;

  Map<String, Object?> toJson() => {
        'positionId': position.id,
        'ballots': ballots,
        'noChoice': noChoice,
        'invalid': invalid,
        'counts': {for (final c in counts) c.candidate.id: c.votes},
        'tie': [for (final c in tiedAtCutoff) c.id],
      };
}

class TallyResult {
  TallyResult({
    required this.positions,
    required this.ballotCount,
    required this.incompleteBallots,
    required this.unknownPositionRows,
  });

  final List<PositionResult> positions;
  /// Distinct ballot ids counted.
  final int ballotCount;
  /// Ballots missing a row for some position (should be 0).
  final int incompleteBallots;
  /// Rows for a position not on the ballot (should be 0).
  final int unknownPositionRows;

  bool get hasProblems =>
      incompleteBallots > 0 ||
      unknownPositionRows > 0 ||
      positions.any((p) => p.invalid > 0);

  Map<String, Object?> toJson() => {
        'ballots': ballotCount,
        'incompleteBallots': incompleteBallots,
        'unknownPositionRows': unknownPositionRows,
        'positions': [for (final p in positions) p.toJson()],
      };
}

/// True when [row] is a valid choice under the position's rules.
bool isValidChoice(PositionDef p, VoteRow row) {
  final c = row.choices;
  if (c.isEmpty) return false;
  if (c.contains(noChoice)) return c.length == 1 && p.allowNoChoice;
  if (c.length > p.chooseN) return false;
  if (c.toSet().length != c.length) return false;
  return c.every((id) => p.candidateById(id) != null);
}

/// Counts verified vote rows. Input order does not matter; rows are shuffled
/// first anyway so nothing downstream can depend on arrival order.
TallyResult tally(BallotDefinition ballot, Iterable<VoteRow> rows) {
  final list = rows.toList();
  secureShuffle(list);

  final perPosition = {for (final p in ballot.positions) p.id: <String, int>{}};
  final noChoiceCount = {for (final p in ballot.positions) p.id: 0};
  final invalidCount = {for (final p in ballot.positions) p.id: 0};
  final ballotsPerPosition = {for (final p in ballot.positions) p.id: 0};
  final positionsPerBallot = <String, Set<String>>{};
  var unknown = 0;

  for (final r in list) {
    final p = ballot.positionById(r.positionId);
    if (p == null) {
      unknown++;
      continue;
    }
    final seen = positionsPerBallot.putIfAbsent(r.ballotId, () => {});
    if (!seen.add(r.positionId)) {
      // Same position twice on one ballot: count once as invalid.
      invalidCount[p.id] = invalidCount[p.id]! + 1;
      continue;
    }
    ballotsPerPosition[p.id] = ballotsPerPosition[p.id]! + 1;
    if (!isValidChoice(p, r)) {
      invalidCount[p.id] = invalidCount[p.id]! + 1;
    } else if (r.isNoChoice) {
      noChoiceCount[p.id] = noChoiceCount[p.id]! + 1;
    } else {
      final m = perPosition[p.id]!;
      for (final id in r.choices) {
        m[id] = (m[id] ?? 0) + 1;
      }
    }
  }

  final allPositionIds = ballot.positions.map((p) => p.id).toSet();
  final incomplete =
      positionsPerBallot.values.where((s) => !s.containsAll(allPositionIds)).length;

  return TallyResult(
    ballotCount: positionsPerBallot.length,
    incompleteBallots: incomplete,
    unknownPositionRows: unknown,
    positions: [
      for (final p in ballot.positions)
        PositionResult(
          position: p,
          counts: [
            for (final c in [...p.candidates]..sort((a, b) => a.number.compareTo(b.number)))
              CandidateCount(c, perPosition[p.id]![c.id] ?? 0),
          ],
          noChoice: noChoiceCount[p.id]!,
          invalid: invalidCount[p.id]!,
          ballots: ballotsPerPosition[p.id]!,
        ),
    ],
  );
}

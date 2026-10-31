import '../domain/vote.dart';
import '../domain/vote_batch.dart';

/// Votes from all booths, merged at closing, with integrity findings.
class CombinedVotes {
  CombinedVotes({
    required this.rows,
    required this.ballotsPerBooth,
    required this.tokensUsed,
    required this.codesUsedAtTwoBooths,
    required this.codesNeverIssued,
    required this.duplicateBallotIds,
  });

  final List<VoteRow> rows;
  final Map<String, int> ballotsPerBooth;
  final int tokensUsed;
  /// Same code accepted by two booths (possible only while Wi-Fi was down).
  final int codesUsedAtTwoBooths;
  /// Codes used at a booth that the laptop never issued.
  final int codesNeverIssued;
  final int duplicateBallotIds;

  bool get clean => codesUsedAtTwoBooths == 0 && codesNeverIssued == 0 && duplicateBallotIds == 0;
}

/// Merges verified batches, keeping only the latest batch per booth (each
/// batch is the booth's full set). Findings are reported, never "fixed".
CombinedVotes combineBatches(Iterable<VoteBatch> batches, {required Set<String> issuedTokenHashes}) {
  final latest = <String, VoteBatch>{};
  for (final b in batches) {
    final cur = latest[b.boothDeviceId];
    if (cur == null || b.batchSeq > cur.batchSeq) latest[b.boothDeviceId] = b;
  }
  final rows = <VoteRow>[];
  final seenBallots = <String, String>{};
  var duplicateBallots = 0;
  final tokenUse = <String, int>{};
  final perBooth = <String, int>{};
  for (final b in latest.values) {
    perBooth[b.boothDeviceId] = b.ballotCount;
    for (final h in b.usedTokenHashes) {
      tokenUse[h] = (tokenUse[h] ?? 0) + 1;
    }
    for (final r in b.rows) {
      final owner = seenBallots[r.ballotId];
      if (owner != null && owner != b.boothDeviceId) {
        duplicateBallots++;
        continue;
      }
      seenBallots[r.ballotId] = b.boothDeviceId;
      rows.add(r);
    }
  }
  return CombinedVotes(
    rows: rows,
    ballotsPerBooth: perBooth,
    tokensUsed: tokenUse.values.fold(0, (a, b) => a + b),
    codesUsedAtTwoBooths: tokenUse.values.where((n) => n > 1).length,
    codesNeverIssued: tokenUse.keys.where((h) => !issuedTokenHashes.contains(h)).length,
    duplicateBallotIds: duplicateBallots,
  );
}

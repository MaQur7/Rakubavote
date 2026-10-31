import '../crypto/device_keys.dart';
import '../crypto/signed_artifact.dart';
import 'vote.dart';

/// All votes from one booth, signed by that booth. Rows are ordered by their
/// random ballot id, which is a random permutation unrelated to the order in
/// which people voted (and is deterministic, so the batch hash is stable).
class VoteBatch {
  VoteBatch({
    required this.electionId,
    required this.boothDeviceId,
    required this.batchSeq,
    required List<String> usedTokenHashes,
    required List<VoteRow> rows,
  })  : usedTokenHashes = [...usedTokenHashes]..sort(),
        rows = sortRows(rows);

  final String electionId;
  final String boothDeviceId;
  final int batchSeq;
  /// Hashes of the codes used at this booth, sorted. They are not linked to
  /// any ballot; the laptop uses them to catch a code used at two booths.
  final List<String> usedTokenHashes;
  final List<VoteRow> rows;

  int get usedTokenCount => usedTokenHashes.length;

  int get ballotCount => rows.map((r) => r.ballotId).toSet().length;

  static List<VoteRow> sortRows(Iterable<VoteRow> rows) => [...rows]..sort((a, b) {
      final c = a.ballotId.compareTo(b.ballotId);
      return c != 0 ? c : a.positionId.compareTo(b.positionId);
    });

  Map<String, Object?> toJson() => {
        'electionId': electionId,
        'booth': boothDeviceId,
        'seq': batchSeq,
        'ballots': ballotCount,
        'usedTokens': usedTokenHashes,
        'votes': [for (final r in rows) r.toJson()],
      };

  factory VoteBatch.fromJson(Map m) => VoteBatch(
        electionId: m['electionId'] as String,
        boothDeviceId: m['booth'] as String,
        batchSeq: m['seq'] as int,
        usedTokenHashes: (m['usedTokens'] as List).cast<String>(),
        rows: [for (final v in m['votes'] as List) VoteRow.fromJson(v as Map)],
      );

  Future<SignedArtifact> sign(DeviceKeys boothKeys) =>
      SignedArtifact.sign(ArtifactKind.voteBatch, toJson(), boothKeys);

  /// Verifies the batch signature, that the signer is the booth named in the
  /// batch, and every vote row signature. Returns the batch or throws.
  static Future<VoteBatch> verifySigned(
    SignedArtifact artifact, {
    required String electionId,
    required Iterable<List<int>> enrolledBoothKeys,
  }) async {
    await artifact.verify(expectedKind: ArtifactKind.voteBatch, trustedSigners: enrolledBoothKeys);
    final batch = VoteBatch.fromJson(artifact.payload);
    if (batch.electionId != electionId) {
      throw ArtifactVerificationException(VerificationFailure.wrongKind, 'other election');
    }
    if (batch.boothDeviceId != artifact.signerDeviceId) {
      throw ArtifactVerificationException(VerificationFailure.untrustedSigner, 'booth id');
    }
    for (final r in batch.rows) {
      if (!await r.verify(electionId, artifact.signerPublicKey)) {
        throw ArtifactVerificationException(VerificationFailure.badSignature, 'vote row');
      }
    }
    return batch;
  }
}

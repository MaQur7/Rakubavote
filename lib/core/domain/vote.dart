import '../crypto/bytes.dart';
import '../crypto/canonical_json.dart';
import '../crypto/device_keys.dart';

/// Marker stored instead of candidate ids when the voter chose
/// "No choice for this position".
const noChoice = 'NO_CHOICE';

/// One position on one ballot. This is everything a vote row may contain:
/// random ballot id, position, choice and the booth's signature.
class VoteRow {
  const VoteRow({
    required this.ballotId,
    required this.positionId,
    required this.choices,
    required this.signature,
  });

  final String ballotId;
  final String positionId;
  /// Sorted candidate ids, or [noChoice] alone.
  final List<String> choices;
  /// base64url Ed25519 signature.
  final String signature;

  bool get isNoChoice => choices.length == 1 && choices.first == noChoice;

  static List<String> normaliseChoices(Iterable<String> c) => c.toSet().toList()..sort();

  static List<int> signedMessage(
          String electionId, String ballotId, String positionId, List<String> choices) =>
      canonicalJsonBytes({'k': 'vote', 'e': electionId, 'b': ballotId, 'p': positionId, 'c': choices});

  static Future<VoteRow> create({
    required String electionId,
    required String ballotId,
    required String positionId,
    required Iterable<String> choices,
    required DeviceKeys boothKeys,
  }) async {
    final c = normaliseChoices(choices);
    final sig = await boothKeys.sign(signedMessage(electionId, ballotId, positionId, c));
    return VoteRow(ballotId: ballotId, positionId: positionId, choices: c, signature: b64(sig));
  }

  Future<bool> verify(String electionId, List<int> boothPublicKey) async {
    try {
      return await verifyEd25519(signedMessage(electionId, ballotId, positionId, choices),
          unb64(signature), boothPublicKey);
    } catch (_) {
      return false;
    }
  }

  Map<String, Object?> toJson() =>
      {'b': ballotId, 'p': positionId, 'c': choices, 's': signature};

  factory VoteRow.fromJson(Map m) => VoteRow(
        ballotId: m['b'] as String,
        positionId: m['p'] as String,
        choices: (m['c'] as List).cast<String>(),
        signature: m['s'] as String,
      );

  /// Exact key set allowed in a serialised vote. Tests assert nothing else leaks in.
  static const allowedJsonKeys = {'b', 'p', 'c', 's'};
}

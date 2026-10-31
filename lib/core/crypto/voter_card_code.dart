import 'dart:typed_data';

import 'bytes.dart';
import 'canonical_json.dart';
import 'device_keys.dart';

/// The text inside a voter card QR code: voter number and signature only.
///
/// Format: `RKV1.<voterNo>.<base64url signature>`. The signature covers the
/// election id, voter number and card issue number, so a reprinted card makes
/// every earlier card fail verification ("This card was replaced").
abstract final class VoterCardCode {
  static const prefix = 'RKV1';

  static Uint8List _message(String electionId, int voterNo, int cardIssue) =>
      canonicalJsonBytes({'k': 'voter-card', 'e': electionId, 'n': voterNo, 'i': cardIssue});

  static Future<String> create({
    required String electionId,
    required int voterNo,
    required int cardIssue,
    required DeviceKeys stationKeys,
  }) async {
    final sig = await stationKeys.sign(_message(electionId, voterNo, cardIssue));
    return '$prefix.$voterNo.${b64(sig)}';
  }

  /// Reads the voter number without checking the signature (to look the voter up).
  static ({int voterNo, Uint8List signature})? parse(String qr) {
    final parts = qr.trim().split('.');
    if (parts.length != 3 || parts[0] != prefix) return null;
    final n = int.tryParse(parts[1]);
    if (n == null || n <= 0) return null;
    try {
      final sig = unb64(parts[2]);
      return sig.length == 64 ? (voterNo: n, signature: sig) : null;
    } catch (_) {
      return null;
    }
  }

  static Future<bool> verify({
    required String qr,
    required String electionId,
    required int currentCardIssue,
    required List<int> stationPublicKey,
  }) async {
    final p = parse(qr);
    if (p == null) return false;
    return verifyEd25519(
        _message(electionId, p.voterNo, currentCardIssue), p.signature, stationPublicKey);
  }
}

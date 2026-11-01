import 'dart:convert';

import 'package:cryptography/cryptography.dart';

import '../core/crypto/bytes.dart';
import '../core/crypto/canonical_json.dart';
import '../core/crypto/fingerprint.dart';

/// Pairing codes: 8 Crockford characters (40 bits), valid for 10 minutes,
/// shown on the laptop as text and as a QR code. The tablet proves it knows
/// the code with an HMAC over its keys, so a device that only overhears the
/// local network cannot pair. The officer then compares device ids and
/// approves (docs/protocol.md).
abstract final class Pairing {
  static const codeLength = 8;
  static const validFor = Duration(minutes: 10);
  static const qrPrefix = 'RKVP1';

  static String newCode() {
    final sb = StringBuffer();
    for (var i = 0; i < codeLength; i++) {
      sb.write(crockfordAlphabet[secureRandomInt(32)]);
    }
    return sb.toString();
  }

  static String formatCode(String code) => '${code.substring(0, 4)}-${code.substring(4)}';

  static String? normaliseCode(String input) {
    final s = input.toUpperCase().replaceAll(RegExp(r'[\s-]'), '').replaceAll('O', '0').replaceAll(RegExp('[IL]'), '1');
    if (s.length != codeLength || s.split('').any((c) => !crockfordAlphabet.contains(c))) return null;
    return s;
  }

  static Future<String> mac({
    required String code,
    required String role,
    required String label,
    required List<int> signing,
    required List<int> exchange,
    required String stationId,
  }) async {
    final m = await Hmac.sha256().calculateMac(
      canonicalJsonBytes({
        'role': role,
        'label': label,
        'signing': b64(signing),
        'exchange': b64(exchange),
        'station': stationId,
      }),
      secretKey: SecretKey(utf8.encode(code)),
    );
    return b64(m.bytes);
  }

  /// What the laptop's pairing QR code holds: address, port, code and the
  /// laptop id (so the tablet can check it reached the right laptop).
  static String qrText({required String host, required int port, required String code, required String stationId}) =>
      '$qrPrefix|$host|$port|$code|$stationId';

  static ({String host, int port, String code, String stationId})? parseQr(String text) {
    final p = text.trim().split('|');
    if (p.length != 5 || p[0] != qrPrefix) return null;
    final port = int.tryParse(p[2]);
    final code = normaliseCode(p[3]);
    if (port == null || code == null) return null;
    return (host: p[1], port: port, code: code, stationId: p[4]);
  }
}

/// Monotonic message counter that survives restarts without storage.
class SeqCounter {
  int _last = 0;
  int next() {
    final now = DateTime.now().microsecondsSinceEpoch;
    _last = now > _last ? now : _last + 1;
    return _last;
  }
}

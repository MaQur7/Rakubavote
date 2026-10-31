import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

final Random _secure = Random.secure();

/// Cryptographically secure random bytes.
Uint8List randomBytes(int length) {
  final out = Uint8List(length);
  for (var i = 0; i < length; i++) {
    out[i] = _secure.nextInt(256);
  }
  return out;
}

/// Uniform secure random integer in [0, max).
int secureRandomInt(int max) => _secure.nextInt(max);

/// A random 128-bit identifier as 32 lowercase hex characters. Used for
/// ballot ids, voter ids and other ids that must not reveal order or time.
String randomId() => hexEncode(randomBytes(16));

/// In-place Fisher–Yates shuffle with a secure random source.
void secureShuffle<T>(List<T> list) {
  for (var i = list.length - 1; i > 0; i--) {
    final j = _secure.nextInt(i + 1);
    final tmp = list[i];
    list[i] = list[j];
    list[j] = tmp;
  }
}

String hexEncode(List<int> bytes) {
  final sb = StringBuffer();
  for (final b in bytes) {
    sb.write(b.toRadixString(16).padLeft(2, '0'));
  }
  return sb.toString();
}

Uint8List hexDecode(String hex) {
  if (hex.length.isOdd) throw const FormatException('Odd-length hex string');
  final out = Uint8List(hex.length ~/ 2);
  for (var i = 0; i < out.length; i++) {
    out[i] = int.parse(hex.substring(i * 2, i * 2 + 2), radix: 16);
  }
  return out;
}

/// Base64url without padding.
String b64(List<int> bytes) => base64Url.encode(bytes).replaceAll('=', '');

Uint8List unb64(String s) {
  final padded = s.padRight((s.length + 3) ~/ 4 * 4, '=');
  return base64Url.decode(padded);
}

/// Constant-time comparison for secrets and MACs.
bool constantTimeEquals(List<int> a, List<int> b) {
  if (a.length != b.length) return false;
  var diff = 0;
  for (var i = 0; i < a.length; i++) {
    diff |= a[i] ^ b[i];
  }
  return diff == 0;
}

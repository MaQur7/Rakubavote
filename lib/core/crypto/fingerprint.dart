import 'dart:typed_data';

/// Crockford base32 alphabet: no I, L, O or U, so codes are easy to read aloud
/// and copy by hand.
const crockfordAlphabet = '0123456789ABCDEFGHJKMNPQRSTVWXYZ';

/// Short human-checkable code for a SHA-256 hash: the first 40 bits as eight
/// Crockford base32 characters, shown as `XXXX-XXXX`. Agents copy this down
/// for the locked register and the results and compare it later.
String fingerprintCode(Uint8List hash) {
  if (hash.length < 5) throw ArgumentError('Hash too short for a fingerprint');
  var bits = 0;
  for (var i = 0; i < 5; i++) {
    bits = (bits << 8) | hash[i];
  }
  final chars = List<String>.filled(8, '0');
  for (var i = 7; i >= 0; i--) {
    chars[i] = crockfordAlphabet[bits & 31];
    bits >>= 5;
  }
  return '${chars.sublist(0, 4).join()}-${chars.sublist(4).join()}';
}

/// Normalises a fingerprint typed by a person (case, spaces, look-alike letters).
String normaliseFingerprint(String input) {
  final s = input
      .toUpperCase()
      .replaceAll(RegExp(r'[\s-]'), '')
      .replaceAll('O', '0')
      .replaceAll(RegExp('[IL]'), '1');
  return s.length == 8 ? '${s.substring(0, 4)}-${s.substring(4)}' : s;
}

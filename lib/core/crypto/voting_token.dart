import 'hashing.dart';
import 'bytes.dart';

/// One-time voting code printed on the voter's slip, shown as `7K4-Q9M`.
///
/// 31-character alphabet without look-alikes (no 0/O, 1/I/L), 6 characters,
/// about 30 bits. A booth only accepts codes the laptop has activated, so
/// guessing is not a practical attack. Only [tokenHash] is ever stored.
abstract final class VotingToken {
  static const alphabet = '23456789ABCDEFGHJKMNPQRSTUVWXYZ';
  static const length = 6;

  static String generate() {
    final sb = StringBuffer();
    for (var i = 0; i < length; i++) {
      sb.write(alphabet[secureRandomInt(alphabet.length)]);
    }
    return sb.toString();
  }

  static String format(String token) => '${token.substring(0, 3)}-${token.substring(3)}';

  /// Cleans up what a voter typed. Returns null if it cannot be a code.
  static String? normalise(String input) {
    final s = input.toUpperCase().replaceAll(RegExp(r'[\s\-]'), '');
    if (s.length != length) return null;
    for (final ch in s.split('')) {
      if (!alphabet.contains(ch)) return null;
    }
    return s;
  }

  /// The only form of a token that is stored anywhere. Scoped to one election.
  static String tokenHash(String electionId, String normalisedToken) =>
      sha256HexOfString('rakubavote-token|$electionId|$normalisedToken');
}

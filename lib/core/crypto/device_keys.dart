import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';

import 'bytes.dart';
import 'hashing.dart';

final _ed25519 = Ed25519();
final _x25519 = X25519();

/// Long-term keys of one device. Ed25519 signs artifacts and votes; X25519
/// sets up encrypted channels with paired devices (milestone 6).
class DeviceKeys {
  DeviceKeys._(this.signingSeed, this.exchangeSeed, this._signing, this.signingPublic,
      this.exchangePublic);

  final Uint8List signingSeed;
  final Uint8List exchangeSeed;
  final SimpleKeyPair _signing;
  final Uint8List signingPublic;
  final Uint8List exchangePublic;

  static Future<DeviceKeys> generate() => fromSeeds(randomBytes(32), randomBytes(32));

  static Future<DeviceKeys> fromSeeds(Uint8List signingSeed, Uint8List exchangeSeed) async {
    final signing = await _ed25519.newKeyPairFromSeed(signingSeed);
    final exchange = await _x25519.newKeyPairFromSeed(exchangeSeed);
    final sp = await signing.extractPublicKey();
    final xp = await exchange.extractPublicKey();
    return DeviceKeys._(signingSeed, exchangeSeed, signing, Uint8List.fromList(sp.bytes),
        Uint8List.fromList(xp.bytes));
  }

  /// Short stable device id derived from the signing public key.
  String get deviceId => deviceIdFor(signingPublic);

  Future<Uint8List> sign(List<int> message) async {
    final sig = await _ed25519.sign(message, keyPair: _signing);
    return Uint8List.fromList(sig.bytes);
  }

  Future<SimpleKeyPair> exchangeKeyPair() => _x25519.newKeyPairFromSeed(exchangeSeed);
}

String deviceIdFor(List<int> signingPublicKey) =>
    sha256Hex(signingPublicKey).substring(0, 16);

Future<bool> verifyEd25519(
    List<int> message, List<int> signature, List<int> publicKey) async {
  if (signature.length != 64 || publicKey.length != 32) return false;
  try {
    return await _ed25519.verify(
      message,
      signature: Signature(signature,
          publicKey: SimplePublicKey(publicKey, type: KeyPairType.ed25519)),
    );
  } catch (_) {
    return false;
  }
}

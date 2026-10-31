import 'dart:convert';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';

import 'bytes.dart';

/// Argon2id cost settings. [standard] is for real devices; tests use [fast].
class KdfParams {
  const KdfParams({required this.memoryKiB, required this.iterations, this.parallelism = 1});

  static const standard = KdfParams(memoryKiB: 19456, iterations: 2);
  static const fast = KdfParams(memoryKiB: 64, iterations: 1);

  final int memoryKiB;
  final int iterations;
  final int parallelism;

  Map<String, Object?> toJson() =>
      {'alg': 'argon2id', 'm': memoryKiB, 't': iterations, 'p': parallelism};

  static KdfParams fromJson(Map m) => KdfParams(
      memoryKiB: m['m'] as int, iterations: m['t'] as int, parallelism: m['p'] as int);
}

class WrongPinException implements Exception {
  @override
  String toString() => 'WrongPinException';
}

/// Secrets of one device, kept encrypted on disk under a key derived from the
/// officer PIN. The database keys are random, so changing the PIN only
/// re-wraps this small record; the databases are never re-encrypted.
class DeviceSecrets {
  DeviceSecrets({
    required this.registryDbKey,
    required this.ballotBoxDbKey,
    required this.signingSeed,
    required this.exchangeSeed,
  });

  factory DeviceSecrets.generate() => DeviceSecrets(
        registryDbKey: randomBytes(32),
        ballotBoxDbKey: randomBytes(32),
        signingSeed: randomBytes(32),
        exchangeSeed: randomBytes(32),
      );

  final Uint8List registryDbKey;
  final Uint8List ballotBoxDbKey;
  final Uint8List signingSeed;
  final Uint8List exchangeSeed;

  Map<String, Object?> toJson() => {
        'registry': b64(registryDbKey),
        'ballotbox': b64(ballotBoxDbKey),
        'sign': b64(signingSeed),
        'kx': b64(exchangeSeed),
      };

  static DeviceSecrets fromJson(Map m) => DeviceSecrets(
        registryDbKey: unb64(m['registry'] as String),
        ballotBoxDbKey: unb64(m['ballotbox'] as String),
        signingSeed: unb64(m['sign'] as String),
        exchangeSeed: unb64(m['kx'] as String),
      );
}

/// The on-disk vault record (JSON). Contains no secret in clear.
abstract final class KeyVault {
  static final _aead = AesGcm.with256bits();

  static Future<SecretKey> _kek(String pin, List<int> salt, KdfParams p) {
    final argon = Argon2id(
        parallelism: p.parallelism, memory: p.memoryKiB, iterations: p.iterations, hashLength: 32);
    return argon.deriveKey(secretKey: SecretKey(utf8.encode(pin)), nonce: salt);
  }

  static Future<String> seal(DeviceSecrets secrets, String pin,
      {KdfParams params = KdfParams.standard}) async {
    final salt = randomBytes(16);
    final kek = await _kek(pin, salt, params);
    final box = await _aead.encrypt(utf8.encode(jsonEncode(secrets.toJson())),
        secretKey: kek, nonce: randomBytes(12), aad: utf8.encode('rakubavote-vault-v1'));
    return jsonEncode({
      'v': 1,
      'kdf': params.toJson(),
      'salt': b64(salt),
      'nonce': b64(box.nonce),
      'ct': b64(box.cipherText),
      'mac': b64(box.mac.bytes),
    });
  }

  /// Throws [WrongPinException] if the PIN is wrong or the vault was altered.
  static Future<DeviceSecrets> open(String vaultJson, String pin) async {
    final m = jsonDecode(vaultJson) as Map;
    final params = KdfParams.fromJson(m['kdf'] as Map);
    final kek = await _kek(pin, unb64(m['salt'] as String), params);
    try {
      final clear = await _aead.decrypt(
        SecretBox(unb64(m['ct'] as String),
            nonce: unb64(m['nonce'] as String), mac: Mac(unb64(m['mac'] as String))),
        secretKey: kek,
        aad: utf8.encode('rakubavote-vault-v1'),
      );
      return DeviceSecrets.fromJson(jsonDecode(utf8.decode(clear)) as Map);
    } on SecretBoxAuthenticationError {
      throw WrongPinException();
    }
  }

  static Future<String> changePin(String vaultJson, String oldPin, String newPin,
      {KdfParams params = KdfParams.standard}) async =>
      seal(await open(vaultJson, oldPin), newPin, params: params);
}

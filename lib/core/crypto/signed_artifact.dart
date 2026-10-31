import 'dart:convert';
import 'dart:typed_data';

import 'bytes.dart';
import 'canonical_json.dart';
import 'device_keys.dart';
import 'fingerprint.dart';
import 'hashing.dart';

/// Kinds of signed artifact. The kind is part of what is signed, so a
/// signature on a ballot can never be replayed as a register or results.
enum ArtifactKind {
  ballot('ballot'),
  register('register'),
  voteBatch('vote-batch'),
  results('results'),
  auditCheckpoint('audit-checkpoint');

  const ArtifactKind(this.wire);
  final String wire;

  static ArtifactKind? fromWire(String s) {
    for (final k in values) {
      if (k.wire == s) return k;
    }
    return null;
  }
}

enum VerificationFailure { malformed, wrongKind, untrustedSigner, badSignature }

class ArtifactVerificationException implements Exception {
  ArtifactVerificationException(this.failure, [this.detail = '']);
  final VerificationFailure failure;
  final String detail;

  @override
  String toString() => 'ArtifactVerificationException(${failure.name}: $detail)';
}

/// A payload signed with a device's Ed25519 key. Serialised as JSON for files,
/// USB bundles and the station network.
class SignedArtifact {
  SignedArtifact._(this.kind, this.payload, this.signerPublicKey, this.signature);

  static const version = 1;

  final ArtifactKind kind;
  final Map<String, Object?> payload;
  final Uint8List signerPublicKey;
  final Uint8List signature;

  static Uint8List _message(ArtifactKind kind, Map<String, Object?> payload, List<int> signer) =>
      canonicalJsonBytes({
        'v': version,
        'kind': kind.wire,
        'signer': b64(signer),
        'payload': payload,
      });

  static Future<SignedArtifact> sign(
      ArtifactKind kind, Map<String, Object?> payload, DeviceKeys keys) async {
    // Round-trip through canonical JSON so the stored payload is exactly what was signed.
    final normalised =
        (jsonDecode(canonicalJson(payload)) as Map).cast<String, Object?>();
    final msg = _message(kind, normalised, keys.signingPublic);
    final sig = await keys.sign(msg);
    return SignedArtifact._(kind, normalised, keys.signingPublic, sig);
  }

  /// SHA-256 of the signed message. Changes if anything in the artifact changes.
  Uint8List get hash => sha256(_message(kind, payload, signerPublicKey));
  String get hashHex => hexEncode(hash);

  /// Short code agents copy down, for example `K7QM-2H9X`.
  String get fingerprint => fingerprintCode(hash);

  String get signerDeviceId => deviceIdFor(signerPublicKey);

  Map<String, Object?> toJson() => {
        'v': version,
        'kind': kind.wire,
        'signer': b64(signerPublicKey),
        'payload': payload,
        'sig': b64(signature),
      };

  String encode() => canonicalJson(toJson());

  static SignedArtifact parse(Object? json) {
    try {
      final m = (json is String ? jsonDecode(json) : json) as Map;
      if (m['v'] != version) {
        throw ArtifactVerificationException(VerificationFailure.malformed, 'version');
      }
      final kind = ArtifactKind.fromWire(m['kind'] as String);
      if (kind == null) {
        throw ArtifactVerificationException(VerificationFailure.malformed, 'kind');
      }
      return SignedArtifact._(kind, (m['payload'] as Map).cast<String, Object?>(),
          unb64(m['signer'] as String), unb64(m['sig'] as String));
    } on ArtifactVerificationException {
      rethrow;
    } catch (e) {
      throw ArtifactVerificationException(VerificationFailure.malformed, '$e');
    }
  }

  /// Checks kind, signer and signature. Throws [ArtifactVerificationException]
  /// on any problem; the UI turns the failure into plain words.
  Future<void> verify({
    required ArtifactKind expectedKind,
    Iterable<List<int>>? trustedSigners,
  }) async {
    if (kind != expectedKind) {
      throw ArtifactVerificationException(
          VerificationFailure.wrongKind, 'expected ${expectedKind.wire}, got ${kind.wire}');
    }
    if (trustedSigners != null &&
        !trustedSigners.any((k) => constantTimeEquals(k, signerPublicKey))) {
      throw ArtifactVerificationException(VerificationFailure.untrustedSigner);
    }
    final ok = await verifyEd25519(
        _message(kind, payload, signerPublicKey), signature, signerPublicKey);
    if (!ok) throw ArtifactVerificationException(VerificationFailure.badSignature);
  }

  static Future<SignedArtifact> parseAndVerify(
    Object? json, {
    required ArtifactKind expectedKind,
    Iterable<List<int>>? trustedSigners,
  }) async {
    final a = parse(json);
    await a.verify(expectedKind: expectedKind, trustedSigners: trustedSigners);
    return a;
  }
}

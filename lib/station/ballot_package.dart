import 'dart:convert';
import 'dart:typed_data';

import '../core/crypto/bytes.dart';
import '../core/crypto/canonical_json.dart';
import '../core/crypto/device_keys.dart';
import '../core/crypto/hashing.dart';
import '../core/crypto/signed_artifact.dart';
import '../core/domain/ballot_definition.dart';

enum PackageFailure { malformed, badSignature, wrongStation, missingImage, imageChanged }

class PackageException implements Exception {
  PackageException(this.failure, [this.detail = '']);
  final PackageFailure failure;
  final String detail;
  @override
  String toString() => 'PackageException(${failure.name}: $detail)';
}

/// What a booth needs to show a ballot: the signed ballot, the images it
/// refers to by hash, and the public key of the laptop that signed it.
/// Contains no personal data, so it may travel on an unencrypted USB drive;
/// the signature and image hashes make any change visible.
class BallotPackage {
  BallotPackage({required this.signedBallot, required this.stationPublicKey, required this.media});

  static const fileExtension = 'rkvballot';
  static const type = 'rakubavote-ballot-package';

  final SignedArtifact signedBallot;
  final Uint8List stationPublicKey;
  final Map<String, Uint8List> media;

  BallotDefinition get ballot => BallotDefinition.fromJson(signedBallot.payload);

  /// Short id of the laptop, shown on both screens for comparison.
  String get stationDeviceId => deviceIdFor(stationPublicKey);

  String suggestedFileName() =>
      'rakubavote-ballot-${signedBallot.fingerprint}.$fileExtension';

  String encode() => canonicalJson({
        'type': type,
        'v': 1,
        'station': b64(stationPublicKey),
        'ballot': signedBallot.toJson(),
        'media': {for (final e in media.entries) e.key: b64(e.value)},
      });

  /// Parses and checks a package. If [pinnedStationKey] is given (the booth
  /// already trusts a laptop), the ballot must be signed by that laptop.
  static Future<BallotPackage> decodeAndVerify(String text, {List<int>? pinnedStationKey}) async {
    final Map m;
    try {
      m = jsonDecode(text) as Map;
      if (m['type'] != type || m['v'] != 1) throw const FormatException('type');
    } catch (e) {
      throw PackageException(PackageFailure.malformed, '$e');
    }
    final station = unb64(m['station'] as String);
    if (pinnedStationKey != null && !constantTimeEquals(pinnedStationKey, station)) {
      throw PackageException(PackageFailure.wrongStation);
    }
    final SignedArtifact signed;
    try {
      signed = await SignedArtifact.parseAndVerify(m['ballot'],
          expectedKind: ArtifactKind.ballot, trustedSigners: [station]);
    } on ArtifactVerificationException catch (e) {
      throw PackageException(
          e.failure == VerificationFailure.malformed ? PackageFailure.malformed : PackageFailure.badSignature);
    }
    final media = <String, Uint8List>{
      for (final e in (m['media'] as Map).entries) e.key as String: unb64(e.value as String),
    };
    for (final e in media.entries) {
      if (sha256Hex(e.value) != e.key) throw PackageException(PackageFailure.imageChanged, e.key);
    }
    final def = BallotDefinition.fromJson(signed.payload);
    for (final h in def.mediaHashes) {
      if (!media.containsKey(h)) throw PackageException(PackageFailure.missingImage, h);
    }
    return BallotPackage(signedBallot: signed, stationPublicKey: station, media: media);
  }
}

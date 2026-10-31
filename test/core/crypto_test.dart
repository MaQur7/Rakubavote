import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:rakubavote/core/crypto/bytes.dart';
import 'package:rakubavote/core/crypto/canonical_json.dart';
import 'package:rakubavote/core/crypto/device_keys.dart';
import 'package:rakubavote/core/crypto/fingerprint.dart';
import 'package:rakubavote/core/crypto/hashing.dart';
import 'package:rakubavote/core/crypto/key_vault.dart';
import 'package:rakubavote/core/crypto/signed_artifact.dart';
import 'package:rakubavote/core/crypto/voter_card_code.dart';
import 'package:rakubavote/core/crypto/voting_token.dart';

void main() {
  group('canonical JSON', () {
    test('sorts keys at every level and has no whitespace', () {
      expect(canonicalJson({'b': 1, 'a': {'d': [true, null], 'c': 'x'}}),
          '{"a":{"c":"x","d":[true,null]},"b":1}');
    });
    test('same value, different key order, same bytes', () {
      expect(canonicalJson({'x': 1, 'y': 2}), canonicalJson({'y': 2, 'x': 1}));
    });
    test('rejects floating point numbers', () {
      expect(() => canonicalJson({'a': 1.5}), throwsArgumentError);
    });
    test('handles Arabic and local letters', () {
      final s = canonicalJson({'t': 'الرئيس ŋɛɔ'});
      expect(jsonDecode(s)['t'], 'الرئيس ŋɛɔ');
    });
  });

  test('SHA-256 matches a known vector', () {
    expect(sha256HexOfString('abc'),
        'ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad');
  });

  group('fingerprint code', () {
    test('is eight Crockford characters in two groups', () {
      final f = fingerprintCode(sha256(utf8.encode('register')));
      expect(f, matches(RegExp(r'^[0-9A-HJKMNP-TV-Z]{4}-[0-9A-HJKMNP-TV-Z]{4}$')));
    });
    test('is stable for the same hash', () {
      final h = sha256(utf8.encode('x'));
      expect(fingerprintCode(h), fingerprintCode(h));
    });
    test('typed codes are normalised', () {
      expect(normaliseFingerprint('k7qm 2h9x'), 'K7QM-2H9X');
      expect(normaliseFingerprint('O1IL-0000'), '0111-0000');
    });
  });

  group('device keys', () {
    test('same seeds give the same keys and device id', () async {
      final a = await DeviceKeys.generate();
      final b = await DeviceKeys.fromSeeds(a.signingSeed, a.exchangeSeed);
      expect(b.signingPublic, a.signingPublic);
      expect(b.deviceId, a.deviceId);
      expect(a.deviceId, hasLength(16));
    });
  });

  group('signed artifacts', () {
    late DeviceKeys station;
    setUp(() async => station = await DeviceKeys.generate());

    test('round trip verifies', () async {
      final a = await SignedArtifact.sign(ArtifactKind.ballot, {'positions': [1, 2]}, station);
      final b = await SignedArtifact.parseAndVerify(a.encode(),
          expectedKind: ArtifactKind.ballot, trustedSigners: [station.signingPublic]);
      expect(b.hashHex, a.hashHex);
      expect(b.fingerprint, a.fingerprint);
    });

    test('any change to the payload breaks the signature', () async {
      final a = await SignedArtifact.sign(ArtifactKind.results, {'votes': 10}, station);
      final tampered = a.toJson()..['payload'] = {'votes': 11};
      expect(
        () => SignedArtifact.parseAndVerify(jsonEncode(tampered), expectedKind: ArtifactKind.results),
        throwsA(isA<ArtifactVerificationException>()
            .having((e) => e.failure, 'failure', VerificationFailure.badSignature)),
      );
    });

    test('a ballot signature cannot pass as results', () async {
      final a = await SignedArtifact.sign(ArtifactKind.ballot, {'x': 1}, station);
      final relabelled = a.toJson()..['kind'] = 'results';
      expect(
        () => SignedArtifact.parseAndVerify(jsonEncode(relabelled), expectedKind: ArtifactKind.results),
        throwsA(isA<ArtifactVerificationException>()
            .having((e) => e.failure, 'failure', VerificationFailure.badSignature)),
      );
      expect(
        () => a.verify(expectedKind: ArtifactKind.results),
        throwsA(isA<ArtifactVerificationException>()
            .having((e) => e.failure, 'failure', VerificationFailure.wrongKind)),
      );
    });

    test('a signer that is not trusted is rejected', () async {
      final other = await DeviceKeys.generate();
      final a = await SignedArtifact.sign(ArtifactKind.register, {'x': 1}, other);
      expect(
        () => a.verify(expectedKind: ArtifactKind.register, trustedSigners: [station.signingPublic]),
        throwsA(isA<ArtifactVerificationException>()
            .having((e) => e.failure, 'failure', VerificationFailure.untrustedSigner)),
      );
    });

    test('garbage is reported as malformed', () {
      expect(
        () => SignedArtifact.parse('{"v":1}'),
        throwsA(isA<ArtifactVerificationException>()
            .having((e) => e.failure, 'failure', VerificationFailure.malformed)),
      );
    });
  });

  group('voter card QR', () {
    late DeviceKeys station;
    setUp(() async => station = await DeviceKeys.generate());

    test('holds only the voter number and a signature', () async {
      final qr = await VoterCardCode.create(
          electionId: 'e1', voterNo: 142, cardIssue: 1, stationKeys: station);
      final parts = qr.split('.');
      expect(parts, hasLength(3));
      expect(parts[0], 'RKV1');
      expect(parts[1], '142');
      expect(unb64(parts[2]), hasLength(64));
    });

    test('verifies for the current card issue only', () async {
      final card1 = await VoterCardCode.create(
          electionId: 'e1', voterNo: 142, cardIssue: 1, stationKeys: station);
      Future<bool> check(String qr, int issue) => VoterCardCode.verify(
          qr: qr, electionId: 'e1', currentCardIssue: issue, stationPublicKey: station.signingPublic);
      expect(await check(card1, 1), isTrue);
      // Card reprinted: issue 2. The old card must fail.
      expect(await check(card1, 2), isFalse);
    });

    test('changing the voter number breaks it', () async {
      final qr = await VoterCardCode.create(
          electionId: 'e1', voterNo: 142, cardIssue: 1, stationKeys: station);
      final forged = qr.replaceFirst('.142.', '.143.');
      expect(
          await VoterCardCode.verify(
              qr: forged, electionId: 'e1', currentCardIssue: 1, stationPublicKey: station.signingPublic),
          isFalse);
    });

    test('a card from another election fails', () async {
      final qr = await VoterCardCode.create(
          electionId: 'e1', voterNo: 7, cardIssue: 1, stationKeys: station);
      expect(
          await VoterCardCode.verify(
              qr: qr, electionId: 'e2', currentCardIssue: 1, stationPublicKey: station.signingPublic),
          isFalse);
    });
  });

  group('voting token', () {
    test('uses only unambiguous characters', () {
      for (var i = 0; i < 500; i++) {
        final t = VotingToken.generate();
        expect(t, hasLength(6));
        expect(t, isNot(matches(RegExp('[01ILO]'))));
      }
    });
    test('normalises what a voter types', () {
      expect(VotingToken.normalise('7k4-q9m'), '7K4Q9M');
      expect(VotingToken.normalise(' 7K4 Q9M '), '7K4Q9M');
      expect(VotingToken.normalise('7K4-Q9'), isNull);
      expect(VotingToken.normalise('7K4-Q0M'), isNull);
      expect(VotingToken.format('7K4Q9M'), '7K4-Q9M');
    });
    test('hash is scoped to the election', () {
      expect(VotingToken.tokenHash('e1', '7K4Q9M'), isNot(VotingToken.tokenHash('e2', '7K4Q9M')));
      expect(VotingToken.tokenHash('e1', '7K4Q9M'), hasLength(64));
    });
  });

  group('key vault', () {
    test('opens with the right PIN and gives back the same secrets', () async {
      final s = DeviceSecrets.generate();
      final vault = await KeyVault.seal(s, '482913', params: KdfParams.fast);
      final o = await KeyVault.open(vault, '482913');
      expect(o.registryDbKey, s.registryDbKey);
      expect(o.signingSeed, s.signingSeed);
      expect(vault, isNot(contains(b64(s.registryDbKey))));
    });
    test('wrong PIN is refused', () async {
      final vault = await KeyVault.seal(DeviceSecrets.generate(), '482913', params: KdfParams.fast);
      expect(() => KeyVault.open(vault, '000000'), throwsA(isA<WrongPinException>()));
    });
    test('changing the PIN keeps the database keys', () async {
      final s = DeviceSecrets.generate();
      final v1 = await KeyVault.seal(s, '1111', params: KdfParams.fast);
      final v2 = await KeyVault.changePin(v1, '1111', '2222', params: KdfParams.fast);
      expect((await KeyVault.open(v2, '2222')).ballotBoxDbKey, s.ballotBoxDbKey);
      expect(() => KeyVault.open(v2, '1111'), throwsA(isA<WrongPinException>()));
    });
  });
}

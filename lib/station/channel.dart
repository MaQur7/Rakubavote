import 'dart:convert';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';

import '../core/crypto/bytes.dart';
import '../core/crypto/canonical_json.dart';
import '../core/crypto/device_keys.dart';

enum ChannelFailure { malformed, badSignature, unknownDevice, replayed, cannotDecrypt, wrongElection }

class ChannelException implements Exception {
  ChannelException(this.failure, [this.detail = '']);
  final ChannelFailure failure;
  final String detail;
  @override
  String toString() => 'ChannelException(${failure.name}: $detail)';
}

/// One side's view of a paired device: its keys and the shared AES key.
class Peer {
  Peer({required this.deviceId, required this.signingPublic, required this.sharedKey});
  final String deviceId;
  final Uint8List signingPublic;
  final SecretKey sharedKey;
  /// Highest sequence number accepted from this peer (replay protection).
  int lastSeqIn = 0;
}

final _x25519 = X25519();
final _aead = AesGcm.with256bits();
final _hkdf = Hkdf(hmac: Hmac.sha256(), outputLength: 32);

/// AES-256 key shared by the laptop and one device: HKDF-SHA256 over their
/// X25519 agreement, salted with both device ids in a fixed order.
Future<SecretKey> deriveSharedKey(DeviceKeys mine, List<int> peerExchangePublic, String peerDeviceId) async {
  final secret = await _x25519.sharedSecretKey(
    keyPair: await mine.exchangeKeyPair(),
    remotePublicKey: SimplePublicKey(peerExchangePublic, type: KeyPairType.x25519),
  );
  final ids = [mine.deviceId, peerDeviceId]..sort();
  return _hkdf.deriveKey(
    secretKey: secret,
    nonce: utf8.encode(ids.join('|')),
    info: utf8.encode('rakubavote-channel-v1'),
  );
}

/// Signed, encrypted message between the laptop and a paired device.
/// Everything except the body is visible; the body is AES-GCM encrypted
/// and the whole envelope is signed by the sender (docs/protocol.md).
class Envelope {
  Envelope({
    required this.type,
    required this.electionId,
    required this.deviceId,
    required this.seq,
    required this.nonce,
    required this.body,
    required this.signature,
  });

  final String type;
  final String electionId;
  /// The sender's device id.
  final String deviceId;
  final int seq;
  final Uint8List nonce;
  /// Ciphertext followed by the 16-byte GCM tag.
  final Uint8List body;
  final Uint8List signature;

  static Uint8List _signed(String type, String election, String device, int seq, List<int> nonce, List<int> body) =>
      canonicalJsonBytes({
        'type': type,
        'election': election,
        'device': device,
        'seq': seq,
        'nonce': b64(nonce),
        'body': b64(body),
      });

  static Future<Envelope> seal({
    required String type,
    required String electionId,
    required DeviceKeys sender,
    required SecretKey sharedKey,
    required int seq,
    required Map<String, Object?> payload,
  }) async {
    final nonce = randomBytes(12);
    final box = await _aead.encrypt(
      utf8.encode(canonicalJson(payload)),
      secretKey: sharedKey,
      nonce: nonce,
      aad: utf8.encode('$type|$electionId|${sender.deviceId}|$seq'),
    );
    final body = Uint8List.fromList([...box.cipherText, ...box.mac.bytes]);
    final sig = await sender.sign(_signed(type, electionId, sender.deviceId, seq, nonce, body));
    return Envelope(
        type: type, electionId: electionId, deviceId: sender.deviceId, seq: seq, nonce: nonce, body: body, signature: sig);
  }

  /// Checks signature, sequence and election, then decrypts the body.
  Future<Map<String, Object?>> open(Peer from, {required String electionId}) async {
    if (deviceId != from.deviceId) throw ChannelException(ChannelFailure.unknownDevice);
    if (this.electionId != electionId) throw ChannelException(ChannelFailure.wrongElection);
    final ok = await verifyEd25519(
        _signed(type, this.electionId, deviceId, seq, nonce, body), signature, from.signingPublic);
    if (!ok) throw ChannelException(ChannelFailure.badSignature);
    if (seq <= from.lastSeqIn) throw ChannelException(ChannelFailure.replayed, '$seq');
    if (body.length < 16) throw ChannelException(ChannelFailure.malformed);
    try {
      final clear = await _aead.decrypt(
        SecretBox(body.sublist(0, body.length - 16), nonce: nonce, mac: Mac(body.sublist(body.length - 16))),
        secretKey: from.sharedKey,
        aad: utf8.encode('$type|${this.electionId}|$deviceId|$seq'),
      );
      from.lastSeqIn = seq;
      return (jsonDecode(utf8.decode(clear)) as Map).cast<String, Object?>();
    } on SecretBoxAuthenticationError {
      throw ChannelException(ChannelFailure.cannotDecrypt);
    }
  }

  Map<String, Object?> toJson() => {
        'type': type,
        'election': electionId,
        'device': deviceId,
        'seq': seq,
        'nonce': b64(nonce),
        'body': b64(body),
        'sig': b64(signature),
      };

  String encode() => jsonEncode(toJson());

  static Envelope parse(String text) {
    try {
      final m = jsonDecode(text) as Map;
      return Envelope(
        type: m['type'] as String,
        electionId: m['election'] as String,
        deviceId: m['device'] as String,
        seq: m['seq'] as int,
        nonce: unb64(m['nonce'] as String),
        body: unb64(m['body'] as String),
        signature: unb64(m['sig'] as String),
      );
    } catch (e) {
      throw ChannelException(ChannelFailure.malformed, '$e');
    }
  }
}

/// Message types (docs/protocol.md).
abstract final class Msg {
  // Requests from a device (POST /rpc) and their replies.
  static const ballotGet = 'ballot.get';
  static const checkinSearch = 'checkin.search';
  static const checkinCard = 'checkin.card';
  static const checkinIssue = 'checkin.issue';
  static const checkinManual = 'checkin.manual';
  static const checkinCounts = 'checkin.counts';
  static const batchSubmit = 'batch.submit';
  static const reply = 'reply';
  static const error = 'error';
  // Live events over the WebSocket.
  static const hello = 'hello';
  static const tokenActivate = 'token.activate';
  static const tokenSync = 'token.sync';
  static const tokenUsed = 'token.used';
  static const pollsState = 'polls.state';
  static const heartbeat = 'heartbeat';
}

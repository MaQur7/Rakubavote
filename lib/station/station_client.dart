import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';

import '../core/crypto/bytes.dart';
import '../core/crypto/device_keys.dart';
import '../features/checkin/checkin_backend.dart';
import '../features/checkin/checkin_service.dart';
import 'channel.dart';
import 'enrollment.dart';
import 'pairing.dart';

enum LinkFailure { cannotReach, wrongLaptop, codeRefused, rejected, timedOut, notPaired, refused }

class LinkException implements Exception {
  LinkException(this.failure, [this.detail = '']);
  final LinkFailure failure;
  final String detail;
  @override
  String toString() => 'LinkException(${failure.name}: $detail)';
}

/// What a tablet remembers about its laptop after pairing. Public keys and
/// an address only; the tablet's own secrets stay in its vault.
class StationLink {
  StationLink({
    required this.host,
    required this.port,
    required this.stationId,
    required this.signingPublic,
    required this.exchangePublic,
    required this.electionId,
    required this.stationName,
  });

  final String host;
  final int port;
  final String stationId;
  final List<int> signingPublic;
  final List<int> exchangePublic;
  final String electionId;
  final String stationName;

  Uri get base => Uri(scheme: 'http', host: host, port: port);

  Map<String, Object?> toJson() => {
        'host': host,
        'port': port,
        'station': stationId,
        'signing': b64(signingPublic),
        'exchange': b64(exchangePublic),
        'election': electionId,
        'name': stationName,
      };

  factory StationLink.fromJson(Map m) => StationLink(
        host: m['host'] as String,
        port: m['port'] as int,
        stationId: m['station'] as String,
        signingPublic: unb64(m['signing'] as String),
        exchangePublic: unb64(m['exchange'] as String),
        electionId: m['election'] as String,
        stationName: m['name'] as String,
      );
}

/// Pairs this tablet with the laptop. Returns the link once the officer
/// approves, after showing [onWaiting] the device id to compare.
Future<StationLink> pairWithStation({
  required String host,
  required int port,
  required String code,
  required DeviceRole role,
  required String label,
  required DeviceKeys keys,
  String? expectedStationId,
  void Function(String deviceId)? onWaiting,
  Duration pollEvery = const Duration(seconds: 2),
  Duration giveUpAfter = const Duration(minutes: 5),
  http.Client? client,
}) async {
  final c = client ?? http.Client();
  final base = Uri(scheme: 'http', host: host, port: port);
  final Map hello;
  try {
    hello = jsonDecode((await c.get(base.resolve('/hello')).timeout(const Duration(seconds: 8))).body) as Map;
  } catch (e) {
    throw LinkException(LinkFailure.cannotReach, '$e');
  }
  final stationSigning = unb64(hello['signing'] as String);
  final stationId = deviceIdFor(stationSigning);
  if (stationId != hello['station'] || (expectedStationId != null && expectedStationId != stationId)) {
    throw LinkException(LinkFailure.wrongLaptop);
  }
  final mac = await Pairing.mac(
      code: code,
      role: role.name,
      label: label,
      signing: keys.signingPublic,
      exchange: keys.exchangePublic,
      stationId: stationId);
  final res = await c.post(base.resolve('/pair'),
      body: jsonEncode({
        'role': role.name,
        'label': label,
        'signing': b64(keys.signingPublic),
        'exchange': b64(keys.exchangePublic),
        'mac': mac,
      }));
  if (res.statusCode != 200) throw LinkException(LinkFailure.codeRefused);
  final requestId = (jsonDecode(res.body) as Map)['request'] as String;
  onWaiting?.call(keys.deviceId);
  final deadline = DateTime.now().add(giveUpAfter);
  while (DateTime.now().isBefore(deadline)) {
    final s = (jsonDecode((await c.get(base.resolve('/pair/$requestId'))).body) as Map)['status'];
    if (s == 'approved') {
      return StationLink(
        host: host,
        port: port,
        stationId: stationId,
        signingPublic: stationSigning,
        exchangePublic: unb64(hello['exchange'] as String),
        electionId: hello['election'] as String,
        stationName: hello['name'] as String,
      );
    }
    if (s == 'rejected') throw LinkException(LinkFailure.rejected);
    await Future<void>.delayed(pollEvery);
  }
  throw LinkException(LinkFailure.timedOut);
}

/// Encrypted requests and live events between a paired tablet and the laptop.
class StationClient {
  StationClient(this.link, this.keys, {http.Client? client}) : _http = client ?? http.Client();

  final StationLink link;
  final DeviceKeys keys;
  final http.Client _http;
  final _seq = SeqCounter();
  Peer? _peer;

  Future<Peer> peer() async => _peer ??= Peer(
      deviceId: link.stationId,
      signingPublic: Uint8List.fromList(link.signingPublic),
      sharedKey: await deriveSharedKey(keys, link.exchangePublic, link.stationId));

  Future<Envelope> seal(String type, Map<String, Object?> payload) async => Envelope.seal(
      type: type,
      electionId: link.electionId,
      sender: keys,
      sharedKey: (await peer()).sharedKey,
      seq: _seq.next(),
      payload: payload);

  /// Sends a request; returns the reply, or throws the error the laptop sent.
  Future<Map<String, Object?>> rpc(String type, Map<String, Object?> payload) async {
    final env = await seal(type, payload);
    final http.Response res;
    try {
      res = await _http.post(link.base.resolve('/rpc'), body: env.encode()).timeout(const Duration(seconds: 15));
    } catch (e) {
      throw LinkException(LinkFailure.cannotReach, '$e');
    }
    if (res.statusCode == 403) throw LinkException(LinkFailure.notPaired, res.body);
    if (res.statusCode != 200) throw LinkException(LinkFailure.refused, '${res.statusCode}');
    final reply = Envelope.parse(res.body);
    final body = await reply.open(await peer(), electionId: link.electionId);
    if (reply.type == Msg.error) {
      final code = body['code'] as String;
      for (final f in CheckInFailure.values) {
        if (f.name == code) throw CheckInException(f);
      }
      throw LinkException(LinkFailure.refused, code);
    }
    return body;
  }

  /// Opens the live event socket. Each event is (type, payload).
  Future<({Stream<(String, Map<String, Object?>)> events, Future<void> Function(String, Map<String, Object?>) send, Future<void> Function() close})>
      connectEvents({Map<String, Object?> hello = const {}}) async {
    final uri = link.base.replace(scheme: 'ws', path: '/events');
    final WebSocketChannel ws;
    try {
      ws = WebSocketChannel.connect(uri);
      await ws.ready.timeout(const Duration(seconds: 8));
    } catch (e) {
      throw LinkException(LinkFailure.cannotReach, '$e');
    }
    ws.sink.add((await seal(Msg.hello, hello)).encode());
    final p = await peer();
    final events = ws.stream.asyncMap((data) async {
      final env = Envelope.parse(data as String);
      return (env.type, await env.open(p, electionId: link.electionId));
    });
    return (
      events: events,
      send: (String type, Map<String, Object?> payload) async => ws.sink.add((await seal(type, payload)).encode()),
      close: () => ws.sink.close(),
    );
  }
}

/// The check-in desk on a paired tablet: every action goes to the laptop,
/// which alone decides who has been checked in.
class RemoteCheckInBackend implements CheckInBackend {
  RemoteCheckInBackend(this.client, {required this.official, this.countsEvery = const Duration(seconds: 5)});
  final StationClient client;
  final String official;
  final Duration countsEvery;

  @override
  Future<List<VoterView>> search(String query) async {
    final r = await client.rpc(Msg.checkinSearch, {'q': query, 'official': official});
    return [for (final v in r['voters'] as List) VoterView.fromJson(v as Map)];
  }

  @override
  Future<CardView> lookupCard(String qr) async {
    final r = await client.rpc(Msg.checkinCard, {'qr': qr, 'official': official});
    return CardView(CardResult.values.byName(r['result'] as String),
        r['voter'] == null ? null : VoterView.fromJson(r['voter'] as Map));
  }

  @override
  Future<String> checkIn(String voterId, {required String method}) async =>
      (await client.rpc(Msg.checkinIssue, {'voter': voterId, 'method': method, 'official': official}))['token'] as String;

  @override
  Future<String> manualCheckIn(int voterNo, {required ManualReason reason, String details = ''}) async =>
      (await client.rpc(Msg.checkinManual,
          {'voterNo': voterNo, 'reason': reason.name, 'details': details, 'official': official}))['token'] as String;

  @override
  Stream<DeskCounts> counts() async* {
    while (true) {
      try {
        final r = await client.rpc(Msg.checkinCounts, {'official': official});
        yield (checkedIn: r['checkedIn'] as int, registered: r['registered'] as int);
      } on LinkException {
        // Shown as unchanged; the desk screen reports connection problems on actions.
      }
      await Future<void>.delayed(countsEvery);
    }
  }
}

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:drift/drift.dart' show Value;
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../core/crypto/bytes.dart';
import '../core/crypto/device_keys.dart';
import '../core/db/ballot_box_db.dart';
import '../core/db/registry_db.dart';
import '../features/checkin/checkin_backend.dart';
import '../features/checkin/checkin_service.dart';
import '../features/results/results_service.dart';
import '../features/setup/election_service.dart';
import 'ballot_package.dart';
import 'channel.dart';
import 'enrollment.dart';
import 'pairing.dart';

class PairRequest {
  PairRequest({
    required this.id,
    required this.role,
    required this.label,
    required this.signingPublic,
    required this.exchangePublic,
  });
  final String id;
  final DeviceRole role;
  final String label;
  final List<int> signingPublic;
  final List<int> exchangePublic;
  String status = 'pending';
  String get deviceId => deviceIdFor(signingPublic);
}

/// The laptop's local station server (HTTP + WebSocket over the station
/// Wi-Fi only). Devices must be paired and approved by the officer; every
/// message after that is signed and encrypted per device (channel.dart).
class StationServer {
  StationServer({
    required this.registry,
    required this.ballotBox,
    required this.keys,
    required this.checkIn,
    required this.official,
  })  : enrollment = EnrollmentService(registry),
        results = ResultsService(registry, ballotBox, keys);

  final RegistryDb registry;
  final BallotBoxDb ballotBox;
  final DeviceKeys keys;
  final CheckInService checkIn;
  /// Name of the presiding officer using the laptop, for the audit log.
  final String Function() official;
  final EnrollmentService enrollment;
  final ResultsService results;

  HttpServer? _http;
  final _seq = SeqCounter();
  final _peers = <String, Peer>{};
  final _sockets = <String, WebSocketChannel>{};
  final _pending = <String, PairRequest>{};
  String? _code;
  DateTime? _codeExpires;
  int _badCodes = 0;
  StreamSubscription<Election?>? _electionSub;
  StreamSubscription<List<IssuedToken>>? _tokenSub;
  StreamSubscription<({int total, int remaining})>? _poolSub;
  int _lastPoolTotal = -1;
  Set<String> _knownActive = {};
  String? _lastState;

  final _changes = StreamController<void>.broadcast();
  /// Fires when pairing requests or connections change (for the UI).
  Stream<void> get changes => _changes.stream;

  int? get port => _http?.port;
  bool get running => _http != null;
  List<PairRequest> get pendingRequests => [for (final r in _pending.values) if (r.status == 'pending') r];
  Set<String> get connectedDevices => _sockets.keys.toSet();
  String? get pairingCode => _codeExpires != null && DateTime.now().isBefore(_codeExpires!) ? _code : null;

  Future<int> start({int port = 47800, InternetAddress? address}) async {
    if (_http != null) return _http!.port;
    final router = Router()
      ..get('/hello', _hello)
      ..post('/pair', _pair)
      ..get('/pair/<id>', _pairStatus)
      ..post('/rpc', _rpc)
      ..get('/events', webSocketHandler(_onSocket));
    _http = await shelf_io.serve(router.call, address ?? InternetAddress.anyIPv4, port);
    // Every new active code reaches the booths, whichever desk issued it.
    _knownActive = (await _activeHashes()).toSet();
    _tokenSub = (registry.select(registry.issuedTokens)..where((t) => t.state.equals('active')))
        .watch()
        .listen((rows) {
      final now = {for (final r in rows) r.tokenHash};
      for (final h in now.difference(_knownActive)) {
        _broadcast(Msg.tokenActivate, {'hash': h}, role: DeviceRole.booth);
      }
      _knownActive = now;
    });
    // Pool hashes go to the booths whenever the pool grows (D1).
    _poolSub = checkIn.watchPoolStatus().listen((p) async {
      if (p.total == _lastPoolTotal) return;
      _lastPoolTotal = p.total;
      if (p.total > 0) await _broadcast(Msg.tokenPool, {'hashes': await checkIn.poolHashes()}, role: DeviceRole.booth);
    });
    _electionSub = ElectionService(registry, keys).watchElection().listen((e) {
      if (e != null && e.state != _lastState) {
        _lastState = e.state;
        _broadcast(Msg.pollsState, {'state': e.state}, role: null);
      }
    });
    return _http!.port;
  }

  Future<void> stop() async {
    await _tokenSub?.cancel();
    await _poolSub?.cancel();
    await _electionSub?.cancel();
    final open = _sockets.values.toList();
    _sockets.clear();
    for (final s in open) {
      await s.sink.close();
    }
    await _http?.close(force: true);
    _http = null;
    _changes.add(null);
  }

  /// IPv4 addresses officers can type on a tablet.
  static Future<List<String>> localAddresses() async => [
        for (final i in await NetworkInterface.list(type: InternetAddressType.IPv4))
          for (final a in i.addresses)
            if (!a.isLoopback) a.address,
      ];

  String newPairingCode() {
    _code = Pairing.newCode();
    _codeExpires = DateTime.now().add(Pairing.validFor);
    _badCodes = 0;
    _changes.add(null);
    return _code!;
  }

  Future<DeviceEnrollment> approve(String requestId) async {
    final r = _pending[requestId]!;
    final d = await enrollment.enroll(
      role: r.role,
      signingPublic: Uint8List.fromList(r.signingPublic),
      exchangePublic: Uint8List.fromList(r.exchangePublic),
      label: r.label,
      official: official(),
    );
    r.status = 'approved';
    _changes.add(null);
    return d;
  }

  void reject(String requestId) {
    _pending[requestId]?.status = 'rejected';
    _changes.add(null);
  }

  // ---------------------------------------------------------------- helpers

  Future<Election> _election() async => (await (registry.select(registry.elections)..limit(1)).getSingle());

  Response _json(Object body, {int status = 200}) =>
      Response(status, body: jsonEncode(body), headers: {'content-type': 'application/json'});

  Future<Peer?> _peer(String deviceId) async {
    final cached = _peers[deviceId];
    if (cached != null) return cached;
    final d = await enrollment.byId(deviceId);
    if (d == null) return null;
    final p = Peer(
        deviceId: deviceId, signingPublic: d.signingPublic, sharedKey: await deriveSharedKey(keys, d.exchangePublic, deviceId));
    return _peers[deviceId] = p;
  }

  Future<Envelope> _seal(String type, Peer to, Map<String, Object?> payload) async => Envelope.seal(
      type: type,
      electionId: (await _election()).id,
      sender: keys,
      sharedKey: to.sharedKey,
      seq: _seq.next(),
      payload: payload);

  // ---------------------------------------------------------------- routes

  Future<Response> _hello(Request req) async {
    final e = await _election();
    return _json({
      'station': keys.deviceId,
      'signing': b64(keys.signingPublic),
      'exchange': b64(keys.exchangePublic),
      'election': e.id,
      'name': e.stationName,
      'state': e.state,
    });
  }

  Future<Response> _pair(Request req) async {
    final m = jsonDecode(await req.readAsString()) as Map;
    final code = pairingCode;
    if (code == null || _badCodes >= 5) return _json({'error': 'no_code'}, status: 403);
    final role = DeviceRole.values.byName(m['role'] as String);
    final signing = unb64(m['signing'] as String);
    final exchange = unb64(m['exchange'] as String);
    final expected = await Pairing.mac(
        code: code, role: role.name, label: m['label'] as String, signing: signing, exchange: exchange, stationId: keys.deviceId);
    if (!constantTimeEquals(utf8.encode(expected), utf8.encode(m['mac'] as String))) {
      _badCodes++;
      return _json({'error': 'bad_code'}, status: 403);
    }
    final r = PairRequest(
        id: randomId(), role: role, label: m['label'] as String, signingPublic: signing, exchangePublic: exchange);
    _pending[r.id] = r;
    _changes.add(null);
    return _json({'request': r.id, 'device': r.deviceId});
  }

  Response _pairStatus(Request req, String id) {
    final r = _pending[id];
    return _json({'status': r?.status ?? 'unknown'});
  }

  Future<Response> _rpc(Request req) async {
    final Envelope env;
    try {
      env = Envelope.parse(await req.readAsString());
    } on ChannelException {
      return Response(400);
    }
    final peer = await _peer(env.deviceId);
    if (peer == null) return Response.forbidden('not paired');
    final Map<String, Object?> body;
    try {
      body = await env.open(peer, electionId: (await _election()).id);
    } on ChannelException catch (e) {
      return Response.forbidden(e.failure.name);
    }
    final role = (await enrollment.byId(env.deviceId))!.role;
    Map<String, Object?> out;
    var type = Msg.reply;
    try {
      out = await _handle(env.type, body, role: role, deviceId: env.deviceId);
    } on CheckInException catch (e) {
      type = Msg.error;
      out = {'code': e.failure.name};
    } on ResultsException catch (e) {
      type = Msg.error;
      out = {'code': e.failure.name};
    } on _Forbidden {
      type = Msg.error;
      out = {'code': 'forbidden'};
    }
    return Response.ok((await _seal(type, peer, out)).encode());
  }

  Future<Map<String, Object?>> _handle(String type, Map<String, Object?> b,
      {required String role, required String deviceId}) async {
    final e = await _election();
    final who = '${b['official'] ?? 'Official'} (device $deviceId)';
    void need(DeviceRole r) {
      if (role != r.name) throw _Forbidden();
    }

    switch (type) {
      case Msg.ballotGet:
        final svc = ElectionService(registry, keys);
        final signed = await svc.signedBallot(e.id);
        if (signed == null) return {'package': null};
        return {
          'package': BallotPackage(signedBallot: signed, stationPublicKey: keys.signingPublic, media: await svc.ballotMedia(e.id))
              .encode(),
        };
      case Msg.checkinSearch:
        need(DeviceRole.checkin);
        final list = await LocalCheckInBackend(checkIn, official: who).search(b['q'] as String);
        return {'voters': [for (final v in list) v.toJson()]};
      case Msg.checkinCard:
        need(DeviceRole.checkin);
        final r = await LocalCheckInBackend(checkIn, official: who).lookupCard(b['qr'] as String);
        return {'result': r.result.name, 'voter': r.voter?.toJson()};
      case Msg.checkinIssue:
        need(DeviceRole.checkin);
        return {'token': await checkIn.checkIn(b['voter'] as String, method: b['method'] as String, official: who)};
      case Msg.checkinManual:
        need(DeviceRole.checkin);
        return {
          'token': await checkIn.manualCheckIn(b['voterNo'] as int,
              reason: ManualReason.values.byName(b['reason'] as String), details: b['details'] as String? ?? '', official: who),
        };
      case Msg.checkinCounts:
        need(DeviceRole.checkin);
        final c = await checkIn.watchCounts().first;
        return {'checkedIn': c.checkedIn, 'registered': c.registered};
      case Msg.batchSubmit:
        need(DeviceRole.booth);
        final batch = await results.importBatch(b['batch'] as String, official: who);
        _changes.add(null);
        return {'ballots': batch.ballotCount};
      default:
        throw _Forbidden();
    }
  }

  // ---------------------------------------------------------------- events

  void _onSocket(WebSocketChannel ws, String? _) {
    String? deviceId;
    ws.stream.listen((data) async {
      try {
        final env = Envelope.parse(data as String);
        final peer = await _peer(env.deviceId);
        if (peer == null) {
          await ws.sink.close();
          return;
        }
        final body = await env.open(peer, electionId: (await _election()).id);
        if (deviceId == null) {
          if (env.type != Msg.hello) {
            await ws.sink.close();
            return;
          }
          deviceId = env.deviceId;
          await _sockets[deviceId]?.sink.close();
          _sockets[deviceId!] = ws;
          _changes.add(null);
          // A booth reports the codes it used while disconnected.
          for (final h in (body['used'] as List? ?? const []).cast<String>()) {
            await _markUsed(h, from: deviceId!);
          }
          await _sendTo(deviceId!, Msg.pollsState, {'state': (await _election()).state});
          final d = await enrollment.byId(deviceId!);
          if (d?.role == DeviceRole.booth.name) {
            await _sendTo(deviceId!, Msg.tokenSync, {'active': await _activeHashes()});
            final pool = await checkIn.poolHashes();
            if (pool.isNotEmpty) await _sendTo(deviceId!, Msg.tokenPool, {'hashes': pool});
          }
          return;
        }
        if (env.type == Msg.tokenUsed) await _markUsed(body['hash'] as String, from: deviceId!);
      } on ChannelException {
        await ws.sink.close();
      }
    }, onDone: () {
      if (deviceId != null && identical(_sockets[deviceId], ws)) {
        _sockets.remove(deviceId);
        _changes.add(null);
      }
    });
  }

  Future<List<String>> _activeHashes() async => [
        for (final t in await (registry.select(registry.issuedTokens)..where((t) => t.state.equals('active'))).get())
          t.tokenHash,
      ]..sort();

  Future<void> _markUsed(String hash, {required String from}) async {
    await (registry.update(registry.issuedTokens)..where((t) => t.tokenHash.equals(hash)))
        .write(const IssuedTokensCompanion(state: Value('used')));
    await _broadcast(Msg.tokenUsed, {'hash': hash}, role: DeviceRole.booth, except: from);
  }

  Future<void> _sendTo(String deviceId, String type, Map<String, Object?> payload) async {
    final ws = _sockets[deviceId];
    final peer = await _peer(deviceId);
    if (ws == null || peer == null) return;
    ws.sink.add((await _seal(type, peer, payload)).encode());
  }

  Future<void> _broadcast(String type, Map<String, Object?> payload, {DeviceRole? role, String? except}) async {
    for (final id in _sockets.keys.toList()) {
      if (id == except) continue;
      if (role != null && (await enrollment.byId(id))?.role != role.name) continue;
      await _sendTo(id, type, payload);
    }
  }
}

class _Forbidden implements Exception {}

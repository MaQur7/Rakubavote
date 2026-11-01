import 'dart:async';

import '../core/db/ballot_box_repository.dart';
import 'ballot_package.dart';
import 'channel.dart';
import 'station_client.dart';

enum BoothLinkState { disconnected, connecting, connected }

/// Keeps a booth in step with the laptop over the station Wi-Fi: receives
/// activated codes, reports used codes, and sends the signed vote batch
/// when the polls close. Reconnects by itself.
class BoothLink {
  BoothLink(this.client, this.repo, {this.retryEvery = const Duration(seconds: 3)});

  final StationClient client;
  final BallotBoxRepository repo;
  final Duration retryEvery;

  final _state = StreamController<BoothLinkState>.broadcast();
  Stream<BoothLinkState> get states => _state.stream;
  BoothLinkState state = BoothLinkState.disconnected;
  String pollsState = 'unknown';
  /// Set once the laptop has confirmed it received this booth's votes.
  int? submittedBallots;

  bool _running = false;
  Future<void> Function(String, Map<String, Object?>)? _send;
  Future<void> Function()? _close;
  StreamSubscription<(String, Map<String, Object?>)>? _sub;
  final _closed = StreamController<void>.broadcast();
  /// Fires when the laptop closes the polls.
  Stream<void> get pollsClosed => _closed.stream;

  void _set(BoothLinkState s) {
    state = s;
    _state.add(s);
  }

  /// Loads (or re-checks) the ballot from the laptop.
  Future<void> fetchBallot() async {
    final r = await client.rpc(Msg.ballotGet, const {});
    final text = r['package'] as String?;
    if (text == null) return;
    final pkg = await BallotPackage.decodeAndVerify(text, pinnedStationKey: await repo.pinnedStationKey());
    await repo.loadBallot(pkg.signedBallot.encode(), stationPublicKey: pkg.stationPublicKey, media: pkg.media);
  }

  Future<void> start() async {
    if (_running) return;
    _running = true;
    repo.usedListeners.add(_onUsed);
    unawaited(_loop());
  }

  Future<void> stop() async {
    _running = false;
    repo.usedListeners.remove(_onUsed);
    await _sub?.cancel();
    await _close?.call();
    _set(BoothLinkState.disconnected);
  }

  Future<void> _loop() async {
    while (_running) {
      _set(BoothLinkState.connecting);
      try {
        final conn = await client.connectEvents(hello: {'used': await repo.usedTokenHashes()});
        _send = conn.send;
        _close = conn.close;
        _set(BoothLinkState.connected);
        final done = Completer<void>();
        _sub = conn.events.listen(_onEvent, onDone: done.complete, onError: (_) {
          if (!done.isCompleted) done.complete();
        });
        await done.future;
      } catch (_) {
        // Not reachable; try again shortly.
      }
      _send = null;
      if (_running) {
        _set(BoothLinkState.disconnected);
        await Future<void>.delayed(retryEvery);
      }
    }
  }

  Future<void> _onEvent((String, Map<String, Object?>) e) async {
    final (type, body) = e;
    switch (type) {
      case Msg.tokenActivate:
        await repo.activateToken(body['hash'] as String);
      case Msg.tokenUsed:
        await repo.markUsedElsewhere(body['hash'] as String);
      case Msg.tokenSync:
        final active = (body['active'] as List).cast<String>().toSet();
        for (final h in await repo.activeTokenHashes()) {
          if (!active.contains(h)) await repo.markUsedElsewhere(h);
        }
        for (final h in active) {
          await repo.activateToken(h);
        }
      case Msg.tokenPool:
        await repo.storePool((body['hashes'] as List).cast<String>());
        _state.add(state);
      case Msg.pollsState:
        pollsState = body['state'] as String;
        if (pollsState == 'closed') {
          _closed.add(null);
          await submitVotes();
        }
    }
  }

  void _onUsed(String hash) {
    final send = _send;
    if (send != null) unawaited(send(Msg.tokenUsed, {'hash': hash}));
    // If offline, the used code is reported in the next hello.
  }

  /// Signs and sends all votes on this booth. Safe to repeat (D12).
  Future<int> submitVotes() async {
    final batch = await repo.exportBatch();
    final r = await client.rpc(Msg.batchSubmit, {'batch': batch.encode()});
    submittedBallots = r['ballots'] as int;
    _state.add(state);
    return submittedBallots!;
  }
}

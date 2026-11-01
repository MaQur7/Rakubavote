import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:rakubavote/core/crypto/device_keys.dart';
import 'package:rakubavote/core/db/ballot_box_db.dart';
import 'package:rakubavote/core/db/ballot_box_repository.dart';
import 'package:rakubavote/core/db/registry_db.dart';
import 'package:rakubavote/core/domain/vote.dart';
import 'package:rakubavote/features/checkin/checkin_service.dart';
import 'package:rakubavote/features/results/results_service.dart';
import 'package:rakubavote/station/booth_link.dart';
import 'package:rakubavote/station/channel.dart';
import 'package:rakubavote/station/enrollment.dart';
import 'package:rakubavote/station/pairing.dart';
import 'package:rakubavote/station/station_client.dart';
import 'package:rakubavote/station/station_server.dart';

import '../support/election_builder.dart';
import '../support/fixtures.dart';

/// Waits until [check] is true (real time; network events are asynchronous).
Future<void> eventually(Future<bool> Function() check, {Duration timeout = const Duration(seconds: 10)}) async {
  final end = DateTime.now().add(timeout);
  while (DateTime.now().isBefore(end)) {
    if (await check()) return;
    await Future<void>.delayed(const Duration(milliseconds: 50));
  }
  fail('condition not met in time');
}

void main() {
  late RegistryDb registry;
  late BallotBoxDb laptopBox;
  late DeviceKeys station;
  late StationServer server;
  late int port;
  const po = 'Presiding officer';

  setUp(() async {
    registry = memoryRegistry();
    laptopBox = memoryBallotBox();
    station = await DeviceKeys.generate();
    await buildLockedElection(registry, station, voters: 6);
    server = StationServer(
        registry: registry,
        ballotBox: laptopBox,
        keys: station,
        checkIn: CheckInService(registry, station),
        official: () => po);
    port = await server.start(port: 0, address: InternetAddress.loopbackIPv4);
  });
  tearDown(() async {
    await server.stop();
    await registry.close();
    await laptopBox.close();
  });

  /// Pairs a tablet, approving it on the laptop as soon as it asks.
  Future<StationLink> pair(DeviceKeys keys, DeviceRole role, String label) async {
    final code = server.pairingCode ?? server.newPairingCode();
    final sub = server.changes.listen((_) {
      for (final r in server.pendingRequests) {
        if (r.deviceId == keys.deviceId) server.approve(r.id);
      }
    });
    try {
      return await pairWithStation(
          host: '127.0.0.1', port: port, code: code, role: role, label: label, keys: keys,
          expectedStationId: station.deviceId, pollEvery: const Duration(milliseconds: 50));
    } finally {
      await sub.cancel();
    }
  }

  test('a wrong pairing code is refused; a rejected device gets no link', () async {
    server.newPairingCode();
    final keys = await DeviceKeys.generate();
    await expectLater(
        pairWithStation(host: '127.0.0.1', port: port, code: 'AAAAAAAA', role: DeviceRole.booth, label: 'B', keys: keys),
        throwsA(isA<LinkException>().having((e) => e.failure, 'f', LinkFailure.codeRefused)));
    final sub = server.changes.listen((_) {
      for (final r in server.pendingRequests) {
        server.reject(r.id);
      }
    });
    await expectLater(
        pairWithStation(
            host: '127.0.0.1', port: port, code: server.pairingCode!, role: DeviceRole.booth, label: 'B', keys: keys,
            pollEvery: const Duration(milliseconds: 50)),
        throwsA(isA<LinkException>().having((e) => e.failure, 'f', LinkFailure.rejected)));
    await sub.cancel();
    await expectLater(
        pairWithStation(
            host: '127.0.0.1', port: port, code: server.pairingCode!, role: DeviceRole.booth, label: 'B', keys: keys,
            expectedStationId: 'someotherlaptop'),
        throwsA(isA<LinkException>().having((e) => e.failure, 'f', LinkFailure.wrongLaptop)));
  });

  test('an unpaired device cannot call the laptop', () async {
    final keys = await DeviceKeys.generate();
    final fake = StationLink(
        host: '127.0.0.1', port: port, stationId: station.deviceId, signingPublic: station.signingPublic,
        exchangePublic: station.exchangePublic, electionId: 'x', stationName: 'S');
    await expectLater(StationClient(fake, keys).rpc(Msg.ballotGet, {}),
        throwsA(isA<LinkException>().having((e) => e.failure, 'f', LinkFailure.notPaired)));
  });

  test('full election day over the station network', () async {
    // Pair two booths and a check-in tablet.
    final boothRepos = <BallotBoxRepository>[];
    final links = <BoothLink>[];
    for (var i = 0; i < 2; i++) {
      final keys = await DeviceKeys.generate();
      final link = await pair(keys, DeviceRole.booth, 'Booth ${i + 1}');
      final repo = BallotBoxRepository(memoryBallotBox(), keys);
      final bl = BoothLink(StationClient(link, keys), repo, retryEvery: const Duration(milliseconds: 100));
      await bl.fetchBallot();
      expect(repo.ballot, isNotNull);
      await bl.start();
      boothRepos.add(repo);
      links.add(bl);
    }
    final deskKeys = await DeviceKeys.generate();
    final deskLink = await pair(deskKeys, DeviceRole.checkin, 'Desk tablet');
    final desk = RemoteCheckInBackend(StationClient(deskLink, deskKeys), official: 'Check-in official');
    await eventually(() async => server.connectedDevices.length == 2);

    // A booth cannot use check-in requests.
    await expectLater(StationClient(deskLink, deskKeys).rpc(Msg.batchSubmit, {'batch': '{}'}),
        throwsA(isA<LinkException>()));

    // Check-in on the tablet; the code is live at both booths at once.
    final found = await desk.search('Voter 2');
    expect(found.single.voterNo, 2);
    final token = await desk.checkIn(found.single.id, method: 'name');
    await expectLater(desk.checkIn(found.single.id, method: 'name'),
        throwsA(isA<CheckInException>().having((e) => e.failure, 'f', CheckInFailure.alreadyCheckedIn)));
    final hash = (await registry.select(registry.issuedTokens).getSingle()).tokenHash;
    await eventually(() async => (await boothRepos[0].checkToken(hash)) == null);
    await eventually(() async => (await boothRepos[1].checkToken(hash)) == null);
    expect(token, hasLength(6));

    // Vote at booth 1; booth 2 drops the code; the laptop marks it used.
    final b = boothRepos[0];
    await b.castBallot(tokenHash: hash, selections: {
      for (final p in b.ballot!.positions) p.id: [p.candidates.first.id],
    });
    await eventually(() async => (await boothRepos[1].checkToken(hash)) != null);
    await eventually(() async => (await registry.select(registry.issuedTokens).getSingle()).state == 'used');

    // A second voter, manual check-in, votes at booth 2 with No choice.
    final t2 = await desk.manualCheckIn(4, reason: ManualReason.cardLost);
    expect(t2, hasLength(6));
    final h2 = (await (registry.select(registry.issuedTokens)..where((t) => t.state.equals('active'))).getSingle()).tokenHash;
    await eventually(() async => (await boothRepos[1].checkToken(h2)) == null);
    await boothRepos[1].castBallot(tokenHash: h2, selections: {
      for (final p in boothRepos[1].ballot!.positions) p.id: [noChoice],
    });

    // Close the polls on the laptop: booths send their votes by themselves.
    final results = ResultsService(registry, laptopBox, station);
    await results.closePolls(official: po);
    await eventually(() async => links.every((l) => l.submittedBallots != null));
    final status = await results.batchStatus();
    expect(status.map((s) => s.ballots), [1, 1]);

    final view = ResultsView(await results.computeResults(official: po));
    expect(view.reconciliation['checkedIn'], 2);
    expect(view.reconciliation['ballots'], 2);
    expect(view.checkInsMatchVotes, isTrue);
    expect(view.clean, isTrue);
    final chair = view.positions.first;
    expect([for (final c in chair['candidates'] as List) (c as Map)['votes']], [1, 0]);
    expect(chair['noChoice'], 1);

    for (final l in links) {
      await l.stop();
    }
    for (final r in boothRepos) {
      await r.db.close();
    }
  }, timeout: const Timeout(Duration(minutes: 2)));

  test('a booth that was offline reports its used codes when it reconnects', () async {
    final keys = await DeviceKeys.generate();
    final link = await pair(keys, DeviceRole.booth, 'Booth');
    final repo = BallotBoxRepository(memoryBallotBox(), keys);
    final bl = BoothLink(StationClient(link, keys), repo, retryEvery: const Duration(milliseconds: 100));
    await bl.fetchBallot();
    await bl.start();
    await eventually(() async => server.connectedDevices.length == 1);

    final v = await (registry.select(registry.voters)..limit(1)).getSingle();
    await CheckInService(registry, station).checkIn(v.id, method: 'name', official: 'Desk');
    final hash = (await registry.select(registry.issuedTokens).getSingle()).tokenHash;
    await eventually(() async => (await repo.checkToken(hash)) == null);

    await bl.stop(); // Wi-Fi drops
    await repo.castBallot(tokenHash: hash, selections: {
      for (final p in repo.ballot!.positions) p.id: [p.candidates.first.id],
    });
    expect((await registry.select(registry.issuedTokens).getSingle()).state, 'active');
    await bl.start(); // back
    await eventually(() async => (await registry.select(registry.issuedTokens).getSingle()).state == 'used');
    await bl.stop();
    await repo.db.close();
  });

  test('pairing QR text round trip', () {
    final text = Pairing.qrText(host: '192.168.8.10', port: 47800, code: 'K7QM2H9X', stationId: 'abc123');
    final p = Pairing.parseQr(text)!;
    expect((p.host, p.port, p.code, p.stationId), ('192.168.8.10', 47800, 'K7QM2H9X', 'abc123'));
    expect(Pairing.parseQr('hello'), isNull);
    expect(Pairing.normaliseCode('k7qm-2h9x'), 'K7QM2H9X');
  });
}

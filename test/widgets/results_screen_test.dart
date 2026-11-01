import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rakubavote/app/device_store.dart';
import 'package:rakubavote/app/localization.dart';
import 'package:rakubavote/app/providers.dart';
import 'package:rakubavote/core/crypto/device_keys.dart';
import 'package:rakubavote/core/crypto/signed_artifact.dart';
import 'package:rakubavote/core/crypto/voting_token.dart';
import 'package:rakubavote/core/db/ballot_box_repository.dart';
import 'package:rakubavote/core/theme.dart';
import 'package:rakubavote/features/booth/booth_controller.dart';
import 'package:rakubavote/features/booth/booth_screen.dart';
import 'package:rakubavote/features/checkin/checkin_service.dart';
import 'package:rakubavote/features/results/results_service.dart';
import 'package:rakubavote/l10n/app_localizations.dart';
import 'package:rakubavote/station/enrollment.dart';

import '../support/app_harness.dart';
import '../support/election_builder.dart';
import '../support/fixtures.dart';

void main() {
  late DeviceSession session;
  setUp(() async => session = await memoryAdminSession());

  testWidgets('close the polls, see booth votes, show results with a tie', (tester) async {
    // Wide window: the test font is wider than the real one.
    tester.view.physicalSize = const Size(2200, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final booth = await tester.runAsync(() async {
      final reg = session.registry!;
      final id = await buildLockedElection(reg, session.keys, voters: 4);
      final keys = await DeviceKeys.generate();
      await EnrollmentService(reg).enroll(
          role: DeviceRole.booth, signingPublic: keys.signingPublic, exchangePublic: keys.exchangePublic,
          label: 'Booth 1', official: 'PO');
      final repo = BallotBoxRepository(memoryBallotBox(), keys);
      await repo.loadBallot((await reg.select(reg.elections).getSingle()).signedBallot!,
          stationPublicKey: session.keys.signingPublic);
      final desk = CheckInService(reg, session.keys);
      for (var n = 1; n <= 3; n++) {
        final v = await (reg.select(reg.voters)..where((x) => x.voterNo.equals(n))).getSingle();
        final token = await desk.checkIn(v.id, method: 'name', official: 'Desk');
        if (n == 3) continue; // checked in, did not vote
        final h = VotingToken.tokenHash(id, token);
        await repo.activateToken(h);
        await repo.castBallot(tokenHash: h, selections: {
          for (final p in repo.ballot!.positions) p.id: [p.candidates[n - 1].id],
        });
      }
      return repo;
    });

    await tester.pumpWidget(appWithSession(session));
    await settle(tester);
    await tester.tap(find.byKey(const ValueKey('admin-tab-3')));
    await settle(tester);
    await tester.tap(find.byKey(const ValueKey('close-polls')));
    await settle(tester);
    await tester.tap(find.byKey(const ValueKey('confirm-dialog')));
    await settle(tester);
    expect(find.text('Waiting for votes'), findsOneWidget);

    // The booth's batch arrives (over Wi-Fi in real use).
    await tester.runAsync(() async {
      final batch = await booth!.exportBatch();
      await ResultsService(session.registry!, session.ballotBox!, session.keys)
          .importBatch(batch.encode(), official: 'PO');
    });
    await tester.tap(find.byKey(const ValueKey('admin-tab-2')));
    await settle(tester);
    await tester.tap(find.byKey(const ValueKey('admin-tab-3')));
    await settle(tester);
    expect(find.text('Votes received: 2'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('show-results')));
    await settle(tester);
    await settle(tester);
    expect(find.byKey(const ValueKey('results-fingerprint')), findsOneWidget);
    expect(find.text('Check-ins and votes differ'), findsOneWidget);
    expect(find.text('• 1 checked-in voter(s) did not vote.'), findsOneWidget);
    expect(find.textContaining('Tie: 2 candidates have 1 votes.'), findsWidgets);
    expect(find.textContaining('receipt'), findsNothing);
    await tester.runAsync(booth!.db.close);
    await finish(tester, session);
  });

  testWidgets('a booth shows "The polls are closed" when the laptop closes them', (tester) async {
    tester.view.physicalSize = const Size(800, 1280);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final repo = (await tester.runAsync(() async {
      final station = await DeviceKeys.generate();
      final r = BallotBoxRepository(memoryBallotBox(), await DeviceKeys.generate());
      await r.loadBallot((await SignedArtifact.sign(ArtifactKind.ballot, sampleBallot().toJson(), station)).encode(),
          stationPublicKey: station.signingPublic);
      return r;
    }))!;
    final closed = ValueNotifier(false);
    await tester.pumpWidget(MaterialApp(
      theme: buildRakubaTheme(arabic: false),
      localizationsDelegates: rakubaLocalizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: BoothScreen(controller: BoothController(repo), pollsClosed: closed),
    ));
    await settle(tester);
    expect(find.byKey(const ValueKey('start-voting')), findsOneWidget);
    closed.value = true;
    await tester.pump();
    expect(find.text('The polls are closed'), findsOneWidget);
    expect(find.byKey(const ValueKey('start-voting')), findsNothing);
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
    await tester.runAsync(repo.db.close);
    await tester.pump(const Duration(seconds: 1));
  });

  testWidgets('devices page starts the network and shows a pairing code', (tester) async {
    useLaptopScreen(tester);
    await tester.runAsync(() => buildLockedElection(session.registry!, session.keys, voters: 1));
    await tester.pumpWidget(appWithSession(session));
    await settle(tester);
    await tester.tap(find.byKey(const ValueKey('open-devices')));
    await settle(tester);
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('No tablets are paired yet.'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('start-network')));
    await pumpUntilFound(tester, find.text('The station network is on.'));
    expect(find.text('The station network is on.'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('new-pairing-code')));
    await tester.pump();
    final code = tester.widget<SelectableText>(find.byKey(const ValueKey('pairing-code'))).data!;
    expect(code, matches(RegExp(r'^[0-9A-Z]{4}-[0-9A-Z]{4}$')));
    await tester.runAsync(() => lastContainer.read(stationServerProvider).stop());
    await finish(tester, session);
  });
}


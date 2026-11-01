import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rakubavote/app/device_store.dart';
import 'package:rakubavote/app/localization.dart';
import 'package:rakubavote/app/providers.dart';
import 'package:rakubavote/core/counting/tally.dart';
import 'package:rakubavote/core/crypto/device_keys.dart';
import 'package:rakubavote/core/crypto/key_vault.dart';
import 'package:rakubavote/core/crypto/signed_artifact.dart';
import 'package:rakubavote/core/crypto/voting_token.dart';
import 'package:rakubavote/core/db/ballot_box_repository.dart';
import 'package:rakubavote/core/theme.dart';
import 'package:rakubavote/features/booth/booth_controller.dart';
import 'package:rakubavote/features/booth/booth_home.dart';
import 'package:rakubavote/features/booth/booth_screen.dart';
import 'package:rakubavote/l10n/app_localizations.dart';
import 'package:rakubavote/platform/beep.dart';

import '../support/app_harness.dart';
import '../support/fixtures.dart';

void useTablet(WidgetTester tester) {
  tester.view.physicalSize = const Size(800, 1280);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
}

void main() {
  late DeviceKeys station;
  late BallotBoxRepository repo;
  late BoothController booth;
  late SilentBeep beep;

  Future<void> setUpBooth(WidgetTester tester) async {
    await tester.runAsync(() async {
      station = await DeviceKeys.generate();
      repo = BallotBoxRepository(memoryBallotBox(), await DeviceKeys.generate());
      final signed = await SignedArtifact.sign(
          ArtifactKind.ballot, sampleBallot(withLargePosition: true).toJson(), station);
      await repo.loadBallot(signed.encode(), stationPublicKey: station.signingPublic);
      await repo.activateToken(VotingToken.tokenHash('e1', '7K4Q9M'));
    });
    booth = BoothController(repo);
    beep = SilentBeep();
    await tester.pumpWidget(MaterialApp(
      theme: buildRakubaTheme(arabic: false),
      localizationsDelegates: rakubaLocalizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: BoothScreen(controller: booth, beep: beep),
    ));
    await settle(tester);
  }

  Future<void> close(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
    await tester.runAsync(repo.db.close);
  }

  testWidgets('a voter votes on every screen, changes one choice, and the booth clears', (tester) async {
    useTablet(tester);
    await setUpBooth(tester);
    expect(find.text('CIEC Community Independent Electoral Committee'), findsOneWidget);
    expect(find.text('Powered by Rakubavote'), findsOneWidget);

    await tester.enterText(find.byKey(const ValueKey('booth-code')), 'ABCDEF');
    await tester.tap(find.byKey(const ValueKey('start-voting')));
    await settle(tester);
    expect(find.text('That code was not found. Check your slip or ask an official.'), findsOneWidget);

    await tester.enterText(find.byKey(const ValueKey('booth-code')), '7k4-q9m');
    await tester.tap(find.byKey(const ValueKey('start-voting')));
    await settle(tester);

    // Position 1: Chairman, two candidates (mockup 3).
    expect(find.text('Position 1 of 4'), findsOneWidget);
    expect(find.text('Chairman'), findsOneWidget);
    expect(find.text('Next: Secretary General'), findsOneWidget);
    final next = find.byKey(const ValueKey('booth-next'));
    expect(tester.widget<FilledButton>(next).onPressed, isNull, reason: 'a choice is needed first');
    await tester.tap(find.byKey(const ValueKey('cand-1')));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('cand-2')));
    await tester.pump();
    expect(booth.selectionFor('chair'), ['chair-c2']);
    await tester.tap(next);
    await tester.pump();

    // Position 2.
    await tester.tap(find.byKey(const ValueKey('cand-1')));
    await tester.pump();
    await tester.tap(next);
    await tester.pump();

    // Position 3: No choice.
    await tester.ensureVisible(find.byKey(const ValueKey('no-choice')));
    await tester.tap(find.byKey(const ValueKey('no-choice')));
    await tester.pump();
    await tester.tap(next);
    await tester.pump();

    // Position 4: 13 candidates (mockup 3b), chosen by typing the number.
    expect(find.text('13 candidates. Tap one, or type their number below.'), findsOneWidget);
    await tester.enterText(find.byKey(const ValueKey('candidate-number')), '07');
    await tester.pump();
    expect(find.text('07 · Candidate 7'), findsOneWidget, reason: 'current choice pinned at the bottom');
    expect(find.text('Review'), findsOneWidget);
    await tester.tap(next);
    await tester.pump();

    // Review (mockup 4): change Chairman back to candidate 1.
    expect(find.text('Check your choices'), findsOneWidget);
    expect(find.text('No choice for this position'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('change-0')));
    await tester.pump();
    expect(find.text('Review'), findsOneWidget, reason: 'after Change the button returns to review');
    await tester.tap(find.byKey(const ValueKey('cand-1')));
    await tester.pump();
    await tester.tap(next);
    await tester.pump();
    expect(find.text('1 · Candidate 1'), findsWidgets);

    await tester.tap(find.byKey(const ValueKey('confirm-vote')));
    await settle(tester);

    // End (mockup 5).
    expect(find.byKey(const ValueKey('end-title')), findsOneWidget);
    expect(find.text('Thank you. Your vote has been recorded.'), findsOneWidget);
    expect(find.textContaining('receipt'), findsNothing, reason: 'no receipts (D18)');
    expect(beep.plays, 1);
    await tester.pump(const Duration(seconds: 10));
    expect(find.byKey(const ValueKey('start-voting')), findsOneWidget, reason: 'cleared for the next voter');

    final r = await tester.runAsync(() async => tally(booth.ballot, await repo.allVotes()));
    expect(r!.ballotCount, 1);
    expect(r.positions[0].counts.first.votes, 1);
    expect(r.positions[2].noChoice, 1);
    expect(r.positions[3].counts[6].votes, 1);

    // The used code cannot vote again.
    await tester.enterText(find.byKey(const ValueKey('booth-code')), '7K4Q9M');
    await tester.tap(find.byKey(const ValueKey('start-voting')));
    await settle(tester);
    expect(find.text('This code has already been used. Ask an official.'), findsOneWidget);
    await close(tester);
  });

  testWidgets('the ballot in Arabic is right to left', (tester) async {
    useTablet(tester);
    await setUpBooth(tester);
    await tester.tap(find.byKey(const ValueKey('lang-ar')));
    await tester.pump();
    expect(find.text('ابدأ التصويت'), findsOneWidget);
    expect(Directionality.of(tester.element(find.text('ابدأ التصويت'))), TextDirection.rtl);
    expect(find.text('Powered by Rakubavote'), findsOneWidget, reason: 'the name is never translated');
    await tester.enterText(find.byKey(const ValueKey('booth-code')), '7K4Q9M');
    await tester.tap(find.byKey(const ValueKey('start-voting')));
    await settle(tester);
    expect(find.text('المنصب 1 من 4'), findsOneWidget);
    expect(Directionality.of(tester.element(find.byKey(const ValueKey('cand-1')))), TextDirection.rtl);
    await close(tester);
  });

  testWidgets('pool mode needs the officer PIN; the booth then accepts pool codes', (tester) async {
    useTablet(tester);
    final dir = (await tester.runAsync(() => Directory.systemTemp.createTemp('rkv-booth')))!;
    final store = DeviceStore(dir, kdf: KdfParams.fast);
    final session = (await tester.runAsync(() => store.setUp(mode: DeviceMode.booth, pin: '482913', official: 'Booth officer')))!;
    final station = (await tester.runAsync(DeviceKeys.generate))!;
    final repo = BallotBoxRepository(session.ballotBox!, session.keys);
    final poolHash = VotingToken.tokenHash('e1', 'PQRSTU');
    await tester.runAsync(() async {
      final signed = await SignedArtifact.sign(ArtifactKind.ballot, sampleBallot().toJson(), station);
      await repo.loadBallot(signed.encode(), stationPublicKey: station.signingPublic);
      await repo.storePool([poolHash]);
    });
    expect(await tester.runAsync(() => repo.checkToken(poolHash)), CastFailure.codeNotActive,
        reason: 'pool codes do nothing until pool mode is on');

    final c = ProviderContainer(overrides: [deviceStoreProvider.overrideWith((ref) async => store)]);
    c.read(sessionProvider.notifier).unlocked(session);
    await tester.pumpWidget(UncontrolledProviderScope(
      container: c,
      child: MaterialApp(
        theme: buildRakubaTheme(arabic: false),
        localizationsDelegates: rakubaLocalizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const BoothHome(),
      ),
    ));
    await settle(tester);
    expect(find.text('This booth holds 1 pre-loaded codes.'), findsOneWidget);
    expect(find.textContaining('USB'), findsNothing, reason: 'no USB inputs on the booth');

    await tester.tap(find.byKey(const ValueKey('pool-on')));
    await settle(tester);
    await tester.enterText(find.byKey(const ValueKey('leave-pin')), '000000');
    await tester.tap(find.byKey(const ValueKey('leave-confirm')));
    // Checking the PIN reads the vault (real time).
    await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 500)));
    await settle(tester);
    expect(find.byKey(const ValueKey('pool-mode-on')), findsNothing, reason: 'wrong PIN');

    await tester.tap(find.byKey(const ValueKey('pool-on')));
    await settle(tester);
    await tester.enterText(find.byKey(const ValueKey('leave-pin')), '482913');
    await tester.tap(find.byKey(const ValueKey('leave-confirm')));
    await pumpUntilFound(tester, find.byKey(const ValueKey('pool-mode-on')));
    expect(find.text('Pre-loaded codes are in use on this booth.'), findsOneWidget);
    expect(await tester.runAsync(() => repo.checkToken(poolHash)), isNull);
    final log = (await tester.runAsync(() => repo.audit.entries()))!;
    expect(log.last.action, 'token.pool_fallback');

    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
    await tester.runAsync(session.close);
    await tester.runAsync(() => dir.delete(recursive: true));
  });
}

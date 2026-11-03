import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rakubavote/app/app.dart';
import 'package:rakubavote/app/device_store.dart';
import 'package:rakubavote/app/providers.dart';
import 'package:rakubavote/core/crypto/key_vault.dart';
import 'package:rakubavote/features/admin/admin_shell.dart';
import 'package:rakubavote/features/device_setup/device_setup_screen.dart';
import 'package:rakubavote/features/device_setup/unlock_screen.dart';

import '../support/app_harness.dart';
import '../support/screens.dart';

void main() {
  late Directory dir;
  setUp(() async => dir = await Directory.systemTemp.createTemp('rkv-ui'));
  tearDown(() async {
    if (await dir.exists()) await dir.delete(recursive: true);
  });

  Widget app(ProviderContainer c) => UncontrolledProviderScope(container: c, child: const RakubavoteApp());
  ProviderContainer container() => ProviderContainer(overrides: [
        deviceStoreProvider.overrideWith((ref) async => DeviceStore(dir, kdf: KdfParams.fast)),
      ]);

  for (final code in ['en', 'ar', 'din']) {
    testWidgets('first run shows device setup in $code with the right direction', (tester) async {
      useLaptopScreen(tester);
      final c = container();
      c.read(localeProvider.notifier).set(Locale(code));
      await tester.pumpWidget(app(c));
      await settle(tester);
      expect(find.byType(DeviceSetupScreen), findsOneWidget);
      final dir = Directionality.of(tester.element(find.byType(DeviceSetupScreen)));
      expect(dir, code == 'ar' ? TextDirection.rtl : TextDirection.ltr);
      await finish(tester);
    });
  }

  testWidgets('set up as station admin, lock, then unlock with the PIN', (tester) async {
    useLaptopScreen(tester);
    final c = container();
    await tester.pumpWidget(app(c));
    await settle(tester);

    await tester.tap(find.byKey(const ValueKey('mode-admin')));
    await tester.pump();
    await tester.enterText(find.byKey(const ValueKey('setup-name')), 'Mary Achol');
    await tester.enterText(find.byKey(const ValueKey('setup-pin')), '4829');
    await tester.enterText(find.byKey(const ValueKey('setup-pin2')), '4829');
    await tester.ensureVisible(find.byKey(const ValueKey('setup-submit')));
    await tester.tap(find.byKey(const ValueKey('setup-submit')));
    await tester.pump();
    expect(find.text('The PIN must be 6 to 12 digits.'), findsOneWidget);
    await screen(tester, 'device-setup-error');

    await tester.enterText(find.byKey(const ValueKey('setup-pin')), '482913');
    await tester.enterText(find.byKey(const ValueKey('setup-pin2')), '482913');
    await tester.tap(find.byKey(const ValueKey('setup-submit')));
    await pumpUntilFound(tester, find.byType(AdminShell));
    expect(find.byType(AdminShell), findsOneWidget);
    expect(c.read(sessionProvider)!.official, 'Mary Achol');

    await tester.runAsync(() => c.read(sessionProvider.notifier).lock());
    await pumpUntilFound(tester, find.byType(UnlockScreen));
    expect(find.byType(UnlockScreen), findsOneWidget);
    await screen(tester, 'unlock');

    await tester.enterText(find.byKey(const ValueKey('unlock-name')), 'Mary Achol');
    await tester.enterText(find.byKey(const ValueKey('unlock-pin')), '000000');
    await tester.tap(find.byKey(const ValueKey('unlock-submit')));
    await pumpUntilFound(tester, find.text('That PIN is not correct. Try again.'));
    expect(find.text('That PIN is not correct. Try again.'), findsOneWidget);

    await tester.enterText(find.byKey(const ValueKey('unlock-pin')), '482913');
    await tester.tap(find.byKey(const ValueKey('unlock-submit')));
    await pumpUntilFound(tester, find.byType(AdminShell));
    expect(find.byType(AdminShell), findsOneWidget);
    final s = c.read(sessionProvider);
    c.read(sessionProvider.notifier).state = null;
    await finish(tester, s);
  });
}

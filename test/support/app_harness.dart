import 'dart:io';

import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rakubavote/app/app.dart';
import 'package:rakubavote/app/device_store.dart';
import 'package:rakubavote/app/providers.dart';
import 'package:rakubavote/core/crypto/device_keys.dart';
import 'package:rakubavote/core/crypto/key_vault.dart';

import 'fixtures.dart';

/// An unlocked admin laptop with in-memory databases.
Future<DeviceSession> memoryAdminSession({String official = 'Presiding officer'}) async {
  final secrets = DeviceSecrets.generate();
  final keys = await DeviceKeys.fromSeeds(secrets.signingSeed, secrets.exchangeSeed);
  return DeviceSession(
    info: DeviceInfo(mode: DeviceMode.admin, deviceId: keys.deviceId),
    keys: keys,
    secrets: secrets,
    official: official,
    registry: memoryRegistry(),
    ballotBox: memoryBallotBox(),
  );
}

/// Large laptop-sized window so the two-column admin layouts are used.
void useLaptopScreen(WidgetTester tester) {
  tester.view.physicalSize = const Size(1600, 1000);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
}

/// The provider container of the most recent [appWithSession] (to stop the
/// station server or read providers in tests).
late ProviderContainer lastContainer;

Widget appWithSession(DeviceSession session, {Locale locale = const Locale('en')}) {
  // Each test opens its own in-memory databases; drift's duplicate-instance
  // warning does not apply.
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  final container = ProviderContainer(overrides: [
    deviceStoreProvider.overrideWith((ref) async => DeviceStore(Directory.systemTemp, kdf: KdfParams.fast)),
  ]);
  container.read(sessionProvider.notifier).unlocked(session);
  container.read(localeProvider.notifier).set(locale);
  lastContainer = container;
  return UncontrolledProviderScope(container: container, child: const RakubavoteApp());
}

/// Lets drift streams and futures settle (they use real async gaps).
Future<void> settle(WidgetTester tester) async {
  for (var i = 0; i < 10; i++) {
    await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 20)));
    await tester.pump();
  }
}

/// Ends a widget test cleanly: unmount the app so drift streams cancel,
/// flush their timers, then close databases on the real clock.
Future<void> finish(WidgetTester tester, [DeviceSession? session]) async {
  await tester.pumpWidget(const SizedBox());
  await tester.pump(const Duration(seconds: 1));
  if (session != null) await tester.runAsync(session.close);
  await tester.pump(const Duration(seconds: 1));
}

/// Alternates real-time waits and frames until [finder] matches, for work
/// that does real file I/O (vault, database files).
Future<void> pumpUntilFound(WidgetTester tester, Finder finder, {int tries = 100}) async {
  for (var i = 0; i < tries && finder.evaluate().isEmpty; i++) {
    await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 30)));
    await tester.pump();
  }
}

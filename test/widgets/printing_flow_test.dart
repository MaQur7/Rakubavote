import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rakubavote/app/device_store.dart';

import '../support/app_harness.dart';
import '../support/election_builder.dart';

void main() {
  late DeviceSession session;
  setUp(() async => session = await memoryAdminSession());

  testWidgets('print all unprinted cards, replace a lost card, print the register', (tester) async {
    tester.view.physicalSize = const Size(2200, 1300);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.runAsync(() => buildLockedElection(session.registry!, session.keys, voters: 4, openPolls: false));
    await tester.pumpWidget(appWithSession(session));
    await settle(tester);
    await tester.tap(find.byKey(const ValueKey('admin-tab-1')));
    await settle(tester);
    expect(find.text('Not printed'), findsNWidgets(4));

    await tester.tap(find.byKey(const ValueKey('print-unprinted')));
    await settle(tester);
    await tester.tap(find.byKey(const ValueKey('layout-a6')));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('cards-print')));
    await settle(tester);
    await settle(tester);
    expect(lastPdfOutput.printed.single, 'rakubavote-cards-0001-0004');
    expect(find.text('Printed'), findsNWidgets(4));

    // Lost card: a new issue is needed, then printed again.
    await tester.tap(find.byKey(const ValueKey('voter-row-2')));
    await settle(tester);
    expect(find.text('Card issue: 1'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('replace-card')));
    await settle(tester);
    await tester.tap(find.byKey(const ValueKey('reason-lost')));
    await settle(tester);
    expect(find.text('Card issue: 2'), findsOneWidget);
    expect(find.text('New card to print'), findsWidgets);
    await tester.tap(find.byKey(const ValueKey('print-card')));
    await settle(tester);
    await tester.tap(find.byKey(const ValueKey('cards-save-pdf')));
    await settle(tester);
    await settle(tester);
    expect(lastPdfOutput.saved.single, 'rakubavote-cards-0002');
    expect(find.text('Card issue: 2'), findsOneWidget);
    await tester.tapAt(const Offset(10, 10)); // close the dialog
    await settle(tester);

    // The register (locked, so the file name carries the fingerprint).
    await tester.tap(find.byKey(const ValueKey('admin-tab-2')));
    await settle(tester);
    await tester.tap(find.byKey(const ValueKey('print-register')));
    await settle(tester);
    await tester.tap(find.byKey(const ValueKey('register-save-pdf')));
    await settle(tester);
    await settle(tester);
    expect(lastPdfOutput.saved.last, matches(RegExp(r'^rakubavote-register-[0-9A-Z]{4}-[0-9A-Z]{4}$')));
    await finish(tester, session);
  });
}

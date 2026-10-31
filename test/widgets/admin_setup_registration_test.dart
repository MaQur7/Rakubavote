import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rakubavote/app/device_store.dart';
import 'package:rakubavote/core/domain/templates.dart';
import 'package:rakubavote/features/registration/registration_service.dart';
import 'package:rakubavote/features/setup/election_service.dart';

import '../support/app_harness.dart';

void main() {
  late DeviceSession session;
  setUp(() async => session = await memoryAdminSession());

  testWidgets('create an election from the association template', (tester) async {
    useLaptopScreen(tester);
    await tester.pumpWidget(appWithSession(session));
    await settle(tester);
    expect(find.text('New election'), findsOneWidget);

    await tester.enterText(find.byKey(const ValueKey('create-org')), 'CIEC');
    await tester.enterText(find.byKey(const ValueKey('create-name')), 'CIEC Community Association Election');
    await tester.tap(find.byKey(const ValueKey('create-submit')));
    await settle(tester);

    expect(find.text('1 · Chairman'), findsOneWidget);
    expect(find.text('2 · Secretary General'), findsOneWidget);
    expect(find.text('3 · Finance Secretary'), findsOneWidget);
    expect(find.text('Save and sign ballot'), findsOneWidget);
    await finish(tester, session);
  });

  testWidgets('add a candidate and sign the ballot shows a fingerprint', (tester) async {
    useLaptopScreen(tester);
    final svc = ElectionService(session.registry!, session.keys);
    final id = await tester.runAsync(() => svc.createElection(
        template: ElectionTemplate.partyPrimary, orgName: 'Party', name: 'Primary', year: 2026,
        stationName: 'Station 1', languages: ['en'], official: 'PO'));
    final flag = (await tester.runAsync(() => svc.positions(id!)))!.single;
    await tester.runAsync(() => svc.saveCandidate(positionId: flag.id, number: 1, name: 'First', official: 'PO'));

    await tester.pumpWidget(appWithSession(session));
    await settle(tester);
    await tester.tap(find.byKey(const ValueKey('add-candidate')));
    await settle(tester);
    expect(find.byKey(const ValueKey('cand-number')), findsOneWidget);
    expect(tester.widget<TextField>(find.byKey(const ValueKey('cand-number'))).controller!.text, '2');
    await tester.enterText(find.byKey(const ValueKey('cand-name')), 'Second');
    await tester.tap(find.byKey(const ValueKey('cand-save')));
    await settle(tester);
    expect(find.text('Second'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('sign-ballot')));
    await settle(tester);
    expect(find.text('Ballot signed'), findsOneWidget);
    expect(find.textContaining(RegExp(r'Fingerprint: [0-9A-Z]{4}-[0-9A-Z]{4}')), findsOneWidget);
    await finish(tester, session);
  });

  testWidgets('register a voter, see the duplicate warning, fee becomes locked', (tester) async {
    useLaptopScreen(tester);
    final svc = ElectionService(session.registry!, session.keys);
    final id = await tester.runAsync(() => svc.createElection(
        template: ElectionTemplate.association, orgName: 'CIEC', name: 'Election', year: 2026,
        stationName: 'Station 1', languages: ['en', 'ar'], official: 'PO'));
    await tester.runAsync(() => svc.setFee(id!, enabled: true, amount: 500, currency: FeeCurrency.ssp,
        unpaidPolicy: UnpaidPolicy.block, official: 'PO'));

    await tester.pumpWidget(appWithSession(session));
    await settle(tester);
    expect(find.text('Set before registration starts. Locked once the first voter is registered.'),
        findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('admin-tab-1')));
    await settle(tester);
    expect(find.text('Registration fee: 500 SSP'), findsOneWidget);

    await tester.enterText(find.byKey(const ValueKey('reg-name')), 'Mary Achol Deng');
    await tester.enterText(find.byKey(const ValueKey('reg-group')), 'Juba');
    await tester.tap(find.byKey(const ValueKey('reg-save')));
    await settle(tester);
    expect(find.byKey(const ValueKey('reg-error')), findsOneWidget, reason: 'unpaid is blocked');

    await tester.tap(find.byKey(const ValueKey('reg-paid')));
    await tester.pump();
    await tester.enterText(find.byKey(const ValueKey('reg-receipt')), 'R-0001');
    await tester.tap(find.byKey(const ValueKey('reg-save')));
    await settle(tester);
    expect(find.text('Saved. Voter No. 0001.'), findsOneWidget);
    expect(find.text('0001'), findsOneWidget);

    await tester.enterText(find.byKey(const ValueKey('reg-name')), 'Mary Akol Deng');
    await tester.enterText(find.byKey(const ValueKey('reg-group')), 'Juba');
    // The duplicate check waits 300 ms after typing stops.
    await tester.pump(const Duration(milliseconds: 400));
    await settle(tester);
    expect(find.byKey(const ValueKey('reg-duplicate')), findsOneWidget);
    expect(find.descendant(of: find.byKey(const ValueKey('reg-duplicate')), matching: find.textContaining('Voter No. 0001')), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('admin-tab-0')));
    await settle(tester);
    expect(find.text('Locked: voters are already registered.'), findsOneWidget);

    final voters = await tester.runAsync(() => RegistrationService(session.registry!).voterCount(id!));
    expect(voters, 1);
    await finish(tester, session);
  });

  testWidgets('school election asks for consent before registering', (tester) async {
    useLaptopScreen(tester);
    final svc = ElectionService(session.registry!, session.keys);
    await tester.runAsync(() => svc.createElection(
        template: ElectionTemplate.school, orgName: 'Juba Day School', name: 'Prefects', year: 2026,
        stationName: 'Hall', languages: ['en'], official: 'PO'));
    await tester.pumpWidget(appWithSession(session));
    await settle(tester);
    await tester.tap(find.byKey(const ValueKey('admin-tab-1')));
    await settle(tester);
    await tester.enterText(find.byKey(const ValueKey('reg-name')), 'Student One');
    await tester.tap(find.byKey(const ValueKey('reg-save')));
    await settle(tester);
    expect(find.text("Record the school's consent in Setup before registering students."), findsOneWidget);
    await finish(tester, session);
  });

  testWidgets('admin screens render right-to-left in Arabic', (tester) async {
    useLaptopScreen(tester);
    await tester.pumpWidget(appWithSession(session, locale: const Locale('ar')));
    await settle(tester);
    expect(find.text('انتخاب جديد'), findsOneWidget);
    expect(Directionality.of(tester.element(find.text('انتخاب جديد'))), TextDirection.rtl);
    await finish(tester, session);
  });
}

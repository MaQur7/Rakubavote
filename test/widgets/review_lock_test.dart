import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rakubavote/app/device_store.dart';
import 'package:rakubavote/core/domain/templates.dart';
import 'package:rakubavote/features/register_lock/review_service.dart';
import 'package:rakubavote/features/registration/registration_service.dart';
import 'package:rakubavote/features/setup/election_service.dart';

import '../support/app_harness.dart';

void main() {
  late DeviceSession session;
  setUp(() async => session = await memoryAdminSession());

  Future<String> seed(WidgetTester tester, {bool sign = true}) async {
    final svc = ElectionService(session.registry!, session.keys);
    final reg = RegistrationService(session.registry!);
    final review = ReviewService(session.registry!, session.keys);
    return (await tester.runAsync(() async {
      final id = await svc.createElection(
          template: ElectionTemplate.association, orgName: 'CIEC', name: 'Election', year: 2026,
          stationName: 'Station 1', languages: ['en'], official: 'PO');
      for (final p in await svc.positions(id)) {
        await svc.saveCandidate(positionId: p.id, number: 1, name: 'A', official: 'PO');
        await svc.saveCandidate(positionId: p.id, number: 2, name: 'B', official: 'PO');
      }
      for (final n in ['Mary Achol Deng', 'Peter Lado', 'Mary Akol Deng']) {
        await reg.register(id, VoterInput(fullName: n, groupName: 'Juba'), official: 'PO');
      }
      if (sign) await svc.signBallot(id, official: 'PO');
      await review.raiseObjection(id,
          kind: ObjectionKind.duplicate, subjectVoterNo: 3, otherVoterNo: 1,
          raisedByName: 'Agent of candidate 2', official: 'PO');
      return id;
    }))!;
  }

  testWidgets('resolve objections, then lock and see the fingerprint', (tester) async {
    useLaptopScreen(tester);
    await seed(tester);
    await tester.pumpWidget(appWithSession(session));
    await settle(tester);
    await tester.tap(find.byKey(const ValueKey('admin-tab-2')));
    await settle(tester);

    expect(find.text('Voter No. 0003 · possible duplicate of 0001'), findsOneWidget);
    expect(find.textContaining('Raised by Agent of candidate 2 on '), findsOneWidget);
    expect(find.text('Lock register (resolve 1 objections first)'), findsOneWidget);

    // Record a "missing name" objection through the dialog, then reject it.
    await tester.tap(find.byKey(const ValueKey('raise-objection')));
    await settle(tester);
    await tester.tap(find.text('Missing name'));
    await tester.pump();
    await tester.enterText(find.byKey(const ValueKey('obj-claimant')), 'Rebecca Nyandeng');
    await tester.enterText(find.byKey(const ValueKey('obj-raised-by')), 'Rebecca Nyandeng');
    await tester.tap(find.byKey(const ValueKey('obj-save')));
    await settle(tester);
    expect(find.text('Missing name: Rebecca Nyandeng'), findsOneWidget);
    expect(find.text('Lock register (resolve 2 objections first)'), findsOneWidget);

    await tester.tap(find.widgetWithText(OutlinedButton, 'Reject'));
    await settle(tester);
    await tester.tap(find.widgetWithText(OutlinedButton, 'Remove 0003'));
    await settle(tester);
    expect(find.textContaining('Decided by Presiding officer on '), findsNWidgets(2));
    expect(find.text('Lock register'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('lock-register')));
    await settle(tester);
    await tester.tap(find.byKey(const ValueKey('lock-confirm')));
    await settle(tester);
    await settle(tester);

    expect(find.text('The register is locked'), findsOneWidget);
    final code = tester.widget<SelectableText>(find.byKey(const ValueKey('register-fingerprint'))).data!;
    expect(code, matches(RegExp(r'^[0-9A-Z]{4}-[0-9A-Z]{4}$')));
    expect(find.text('Checked: the signed register matches the data on this laptop.'), findsOneWidget);
    expect(find.byKey(const ValueKey('raise-objection')), findsNothing);
    await finish(tester, session);
  });

  testWidgets('locking without a signed ballot explains what to do', (tester) async {
    useLaptopScreen(tester);
    final id = await seed(tester, sign: false);
    final review = ReviewService(session.registry!, session.keys);
    await tester.runAsync(() async {
      final o = (await review.db.select(review.db.objections).get()).single;
      await review.decide(o.id, ObjectionDecision.keepBoth, official: 'PO');
    });
    await tester.pumpWidget(appWithSession(session));
    await settle(tester);
    await tester.tap(find.byKey(const ValueKey('admin-tab-2')));
    await settle(tester);
    await tester.tap(find.byKey(const ValueKey('lock-register')));
    await settle(tester);
    await tester.tap(find.byKey(const ValueKey('lock-confirm')));
    await settle(tester);
    expect(find.text('Sign the ballot in Setup before locking the register.'), findsOneWidget);
    expect(await tester.runAsync(() => review.lockRecord(id)), isNull);
    await finish(tester, session);
  });
}

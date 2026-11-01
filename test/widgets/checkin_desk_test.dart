import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rakubavote/app/device_store.dart';
import 'package:rakubavote/core/crypto/voter_card_code.dart';
import 'package:rakubavote/core/crypto/voting_token.dart';
import 'package:rakubavote/features/checkin/checkin_screen.dart';
import 'package:rakubavote/features/registration/registration_service.dart';

import '../support/app_harness.dart';
import '../support/election_builder.dart';

void main() {
  late DeviceSession session;
  setUp(() async => session = await memoryAdminSession());

  Future<void> openDesk(WidgetTester tester) async {
    await tester.pumpWidget(appWithSession(session));
    await settle(tester);
    await tester.tap(find.byKey(const ValueKey('admin-tab-2')));
    await settle(tester);
    await tester.tap(find.byKey(const ValueKey('open-polls')));
    await settle(tester);
    await tester.tap(find.byKey(const ValueKey('open-polls-confirm')));
    await settle(tester);
    expect(find.byKey(const ValueKey('polls-open')), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('open-checkin-desk')));
    await settle(tester);
    await tester.pump(const Duration(seconds: 1));
    expect(find.byType(CheckInScreen), findsOneWidget);
  }

  testWidgets('open polls, find by name, issue a code, refuse a second one', (tester) async {
    useLaptopScreen(tester);
    await tester.runAsync(() => buildLockedElection(session.registry!, session.keys, openPolls: false));
    await openDesk(tester);
    expect(find.text('Checked in: 0 of 5'), findsOneWidget);

    await tester.enterText(find.byKey(const ValueKey('checkin-query')), 'Voter 3');
    await tester.pump(const Duration(milliseconds: 300));
    await settle(tester);
    expect(find.text('Registered · Has not voted'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('issue-token')));
    await settle(tester);

    final shown = tester.widget<Text>(find.byKey(const ValueKey('issued-token'))).data!;
    expect(VotingToken.normalise(shown), isNotNull);
    expect(find.textContaining('It is not linked to the vote, so the ballot stays secret.'), findsOneWidget);
    expect(find.text('Checked in: 1 of 5'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('next-voter')));
    await settle(tester);
    expect(find.byKey(const ValueKey('issued-token')), findsNothing);

    await tester.enterText(find.byKey(const ValueKey('checkin-query')), '3');
    await tester.pump(const Duration(milliseconds: 300));
    await settle(tester);
    expect(find.text('Already checked in'), findsOneWidget);
    expect(find.text('This voter has already received a token.'), findsOneWidget);
    expect(find.byKey(const ValueKey('issue-token')), findsNothing);
    await finish(tester, session);
  });

  testWidgets('card scanned by a USB scanner; an old card is refused', (tester) async {
    useLaptopScreen(tester);
    final id = await tester.runAsync(() => buildLockedElection(session.registry!, session.keys, openPolls: false));
    final oldCard = await tester.runAsync(
        () => VoterCardCode.create(electionId: id!, voterNo: 2, cardIssue: 1, stationKeys: session.keys));
    final validCard = await tester.runAsync(
        () => VoterCardCode.create(electionId: id!, voterNo: 4, cardIssue: 1, stationKeys: session.keys));
    await tester.runAsync(() async {
      final v = await (session.registry!.select(session.registry!.voters)..where((x) => x.voterNo.equals(2)))
          .getSingle();
      await RegistrationService(session.registry!).replaceCard(v.id, official: 'PO', reason: 'Lost');
    });
    await openDesk(tester);

    await tester.enterText(find.byKey(const ValueKey('checkin-query')), oldCard!);
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await settle(tester);
    expect(find.text('This card was replaced. Ask for the new card, or use manual check-in.'), findsOneWidget);
    expect(find.byKey(const ValueKey('issue-token')), findsNothing);

    await tester.enterText(find.byKey(const ValueKey('checkin-query')), validCard!);
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await settle(tester);
    expect(tester.widget<Text>(find.byKey(const ValueKey('checkin-voter-name'))).data, 'Voter 4');
    await tester.tap(find.byKey(const ValueKey('issue-token')));
    await settle(tester);
    expect(find.byKey(const ValueKey('issued-token')), findsOneWidget);
    await finish(tester, session);
  });

  testWidgets('manual check-in from the printed register needs a reason', (tester) async {
    useLaptopScreen(tester);
    await tester.runAsync(() => buildLockedElection(session.registry!, session.keys, openPolls: false));
    await openDesk(tester);
    await tester.tap(find.byKey(const ValueKey('manual-checkin')));
    await settle(tester);
    await tester.enterText(find.byKey(const ValueKey('manual-number')), '5');
    await settle(tester);
    expect(find.text('Voter 5'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('manual-submit')));
    await settle(tester);
    expect(find.text('Choose a reason and add details.'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('reason-cardLost')));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('manual-submit')));
    await settle(tester);
    expect(find.byKey(const ValueKey('issued-token')), findsOneWidget);
    expect(find.text('Checked in: 1 of 5'), findsOneWidget);
    await finish(tester, session);
  });
}

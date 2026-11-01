import 'package:flutter_test/flutter_test.dart';
import 'package:rakubavote/core/audit/audit_log.dart';
import 'package:rakubavote/core/crypto/device_keys.dart';
import 'package:rakubavote/core/crypto/voter_card_code.dart';
import 'package:rakubavote/core/crypto/voting_token.dart';
import 'package:rakubavote/core/db/registry_db.dart';
import 'package:rakubavote/features/checkin/checkin_service.dart';
import 'package:rakubavote/features/registration/registration_service.dart';

import '../support/election_builder.dart';
import '../support/fixtures.dart';

void main() {
  late RegistryDb db;
  late DeviceKeys station;
  late String id;
  var now = DateTime(2026, 11, 5, 9, 15);
  late CheckInService desk;
  const official = 'Check-in official';

  setUp(() async {
    db = memoryRegistry();
    station = await DeviceKeys.generate();
    id = await buildLockedElection(db, station);
    now = DateTime(2026, 11, 5, 9, 15);
    desk = CheckInService(db, station, clock: () => now);
  });
  tearDown(() => db.close());

  Future<Voter> voter(int n) =>
      (db.select(db.voters)..where((v) => v.voterNo.equals(n))).getSingle();
  Future<String> card(int n, int issue) =>
      VoterCardCode.create(electionId: id, voterNo: n, cardIssue: issue, stationKeys: station);

  group('polls', () {
    test('check-in is refused until the polls are open', () async {
      final db2 = memoryRegistry();
      await buildLockedElection(db2, station, openPolls: false);
      final d = CheckInService(db2, station);
      final v = await (db2.select(db2.voters)..limit(1)).getSingle();
      await expectLater(d.checkIn(v.id, method: 'name', official: official),
          throwsA(isA<CheckInException>().having((e) => e.failure, 'f', CheckInFailure.pollsNotOpen)));
      await d.openPolls(official: 'PO');
      expect(await d.checkIn(v.id, method: 'name', official: official), hasLength(6));
      await db2.close();
    });
  });

  group('voter card', () {
    test('a valid card finds the voter', () async {
      final r = await desk.lookupCard(await card(3, 1));
      expect(r.result, CardResult.valid);
      expect(r.voter!.voterNo, 3);
    });

    test('an old card after a reprint is reported as replaced', () async {
      final old = await card(3, 1);
      await RegistrationService(db).replaceCard((await voter(3)).id, official: 'PO', reason: 'Lost');
      expect((await desk.lookupCard(old)).result, CardResult.replaced);
      expect((await desk.lookupCard(await card(3, 2))).result, CardResult.valid);
    });

    test('a forged or foreign card is invalid', () async {
      final other = await DeviceKeys.generate();
      final foreign = await VoterCardCode.create(electionId: id, voterNo: 3, cardIssue: 1, stationKeys: other);
      expect((await desk.lookupCard(foreign)).result, CardResult.invalid);
      expect((await desk.lookupCard('hello')).result, CardResult.invalid);
      expect((await desk.lookupCard(await card(99, 1))).result, CardResult.notOnRegister);
    });
  });

  test('search by number or name', () async {
    expect((await desk.search('4')).single.voter.voterNo, 4);
    expect((await desk.search('voter')).length, 5);
    expect(await desk.search('  '), isEmpty);
  });

  group('checking in', () {
    test('issues a code once; the code is never stored', () async {
      final v = await voter(2);
      final activated = <String>[];
      desk.activationListeners.add(activated.add);
      final token = await desk.checkIn(v.id, method: 'qr', official: official);
      expect(VotingToken.normalise(token), token);

      final hash = VotingToken.tokenHash(id, token);
      expect(activated, [hash]);
      final issued = await db.select(db.issuedTokens).get();
      expect(issued.single.tokenHash, hash);
      expect(issued.single.state, 'active');

      final c = (await db.select(db.checkIns).get()).single;
      expect(c.hourBucket, '2026-11-05T09', reason: 'hour only, never the minute');
      expect(c.method, 'qr');
      // The plain code appears nowhere in the database.
      final dump = await db.customSelect(
          "SELECT group_concat(token_hash) || (SELECT group_concat(hour_bucket || official || method) FROM check_ins) || "
          "(SELECT group_concat(payload) FROM audit_log) AS s FROM issued_tokens").getSingle();
      expect(dump.read<String>('s'), isNot(contains(token)));

      expect(() => desk.checkIn(v.id, method: 'name', official: official),
          throwsA(isA<CheckInException>().having((e) => e.failure, 'f', CheckInFailure.alreadyCheckedIn)));
      expect(await db.select(db.issuedTokens).get(), hasLength(1));
      expect((await desk.search('2')).single.checkedIn, isTrue);
    });

    test('ordinary check-ins are not logged one by one; hours are counted', () async {
      for (var n = 1; n <= 3; n++) {
        await desk.checkIn((await voter(n)).id, method: 'name', official: official);
      }
      now = DateTime(2026, 11, 5, 10, 2);
      await desk.checkIn((await voter(4)).id, method: 'name', official: official);
      final entries = await desk.audit.entries();
      final hourly = entries.where((e) => e.action == AuditAction.checkinHourlyCount).toList();
      expect(hourly.single.payload, '{"count":3,"hour":"2026-11-05T09"}');
      final sincePolls = entries.skipWhile((e) => e.action != AuditAction.pollsOpened);
      expect(sincePolls.map((e) => e.payload).join(), isNot(contains('"voterNo"')),
          reason: 'no per-voter check-in entries');
      await desk.flushHourlyCounts(official: 'PO');
      final after = (await desk.audit.entries()).where((e) => e.action == AuditAction.checkinHourlyCount);
      expect(after.map((e) => e.payload), ['{"count":3,"hour":"2026-11-05T09"}', '{"count":1,"hour":"2026-11-05T10"}']);
      await desk.flushHourlyCounts(official: 'PO');
      expect((await desk.audit.entries()).where((e) => e.action == AuditAction.checkinHourlyCount), hasLength(2));
    });

    test('manual check-in needs a reason and is logged by itself', () async {
      expect(() => desk.manualCheckIn(5, reason: ManualReason.other, official: official),
          throwsA(isA<CheckInException>().having((e) => e.failure, 'f', CheckInFailure.reasonRequired)));
      final token = await desk.manualCheckIn(5, reason: ManualReason.cardLost, official: official);
      expect(token, hasLength(6));
      final c = (await db.select(db.checkIns).get()).single;
      expect(c.method, 'manual');
      expect(c.manualReason, 'cardLost');
      final last = (await desk.audit.entries()).last;
      expect(last.action, AuditAction.manualCheckin);
      expect(last.payload, '{"reason":"cardLost","voterNo":5}');
      expect(() => desk.manualCheckIn(42, reason: ManualReason.cardLost, official: official),
          throwsA(isA<CheckInException>().having((e) => e.failure, 'f', CheckInFailure.voterNotFound)));
    });

    test('a removed voter cannot be checked in', () async {
      final db2 = memoryRegistry();
      final id2 = await buildLockedElection(db2, station, openPolls: false);
      // Remove a voter directly before polls (as an objection decision would before locking).
      await db2.customStatement('DROP TRIGGER register_locked_update');
      await db2.customStatement("UPDATE voters SET status = 'removed' WHERE voter_no = 1");
      final d = CheckInService(db2, station);
      await d.openPolls(official: 'PO');
      final v = await (db2.select(db2.voters)..where((x) => x.voterNo.equals(1))).getSingle();
      await expectLater(d.checkIn(v.id, method: 'name', official: official),
          throwsA(isA<CheckInException>().having((e) => e.failure, 'f', CheckInFailure.voterRemoved)));
      expect(id2, isNotEmpty);
      await db2.close();
    });
  });

  test('counts for the desk', () async {
    await desk.checkIn((await voter(1)).id, method: 'name', official: official);
    final c = await desk.watchCounts().first;
    expect(c.checkedIn, 1);
    expect(c.registered, 5);
  });
}

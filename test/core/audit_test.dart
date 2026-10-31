import 'package:drift/drift.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rakubavote/core/audit/audit_log.dart';

import '../support/fixtures.dart';

void main() {
  for (final kind in ['registry', 'ballot box']) {
    group('audit log in $kind db', () {
      late GeneratedDatabase db;
      late AuditLogService log;

      setUp(() {
        db = kind == 'registry' ? memoryRegistry() : memoryBallotBox();
        log = AuditLogService(db, clock: () => DateTime.utc(2026, 11, 5, 9, 30, 12, 345));
      });
      tearDown(() => db.close());

      test('entries chain from the genesis hash', () async {
        final a = await log.append(actor: 'Presiding officer', action: AuditAction.electionCreated);
        final b = await log.append(
            actor: 'Presiding officer', action: AuditAction.feeConfigured, payload: {'amount': 500});
        expect(a.seq, 1);
        expect(a.prevHash, genesisHash);
        expect(b.prevHash, a.hash);
        expect(a.ts, '2026-11-05T09:30:12.000Z', reason: 'time is kept to the second only');
        expect((await log.verify()).isValid, isTrue);
        expect(await log.headHash(), b.hash);
      });

      test('the database refuses to edit an entry', () async {
        await log.append(actor: 'A', action: 'x');
        expect(() => db.customStatement("UPDATE audit_log SET actor = 'B'"), throwsA(anything));
      });

      test('the database refuses to delete an entry', () async {
        await log.append(actor: 'A', action: 'x');
        expect(() => db.customStatement('DELETE FROM audit_log'), throwsA(anything));
      });

      test('an edit made around the triggers is detected', () async {
        for (var i = 0; i < 5; i++) {
          await log.append(actor: 'A', action: 'step', payload: {'i': i});
        }
        // An attacker with raw database access drops the trigger and edits entry 3.
        await db.customStatement('DROP TRIGGER audit_log_no_update');
        await db.customStatement(
            "UPDATE audit_log SET payload = '{\"i\":99}' WHERE seq = 3");
        final v = await log.verify();
        expect(v.isValid, isFalse);
        expect(v.firstBadSeq, 3);
      });

      test('a removed entry is detected', () async {
        for (var i = 0; i < 4; i++) {
          await log.append(actor: 'A', action: 'step', payload: {'i': i});
        }
        await db.customStatement('DROP TRIGGER audit_log_no_delete');
        await db.customStatement('DELETE FROM audit_log WHERE seq = 2');
        final v = await log.verify();
        expect(v.isValid, isFalse);
        expect(v.firstBadSeq, 3);
      });

      test('a re-hashed forgery still breaks the link to the next entry', () async {
        for (var i = 0; i < 3; i++) {
          await log.append(actor: 'A', action: 'step', payload: {'i': i});
        }
        final e = (await log.entries())[0];
        final forgedHash = AuditLogService.computeHash(
            seq: 1, prevHash: e.prevHash, ts: e.ts, actor: 'Someone else', action: e.action,
            payload: e.payload);
        await db.customStatement('DROP TRIGGER audit_log_no_update');
        await db.customStatement(
            "UPDATE audit_log SET actor = 'Someone else', hash = '$forgedHash' WHERE seq = 1");
        final v = await log.verify();
        expect(v.firstBadSeq, 2);
      });
    });
  }
}

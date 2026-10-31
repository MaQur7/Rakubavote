import 'dart:io';

import 'package:drift/drift.dart' hide isNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:rakubavote/core/crypto/bytes.dart';
import 'package:rakubavote/core/db/open_encrypted.dart';
import 'package:rakubavote/core/db/registry_db.dart';

import '../support/fixtures.dart';

Future<void> insertElection(RegistryDb db) => db.into(db.elections).insert(ElectionsCompanion.insert(
      id: 'e1',
      orgName: 'Org',
      name: 'Election',
      year: 2026,
      template: 'association',
      languages: '["en"]',
      idLabel: 'Member ID',
      groupLabel: 'Branch',
      stationName: 'Station 1',
    ));

Future<void> insertVoter(RegistryDb db, String id, int no) =>
    db.into(db.voters).insert(VotersCompanion.insert(
        id: id, electionId: 'e1', voterNo: no, fullName: 'Voter $no', registeredOn: '2026-11-01',
        registeredBy: 'Official'));

void main() {
  group('encryption at rest', () {
    late Directory dir;
    setUp(() async => dir = await Directory.systemTemp.createTemp('rkv'));
    tearDown(() => dir.delete(recursive: true));

    test('the file on disk is not readable SQLite and contains no names', () async {
      final file = File('${dir.path}/registry.db');
      final key = randomBytes(32);
      final db = RegistryDb(openEncrypted(file: file, key: key));
      await insertElection(db);
      await insertVoter(db, 'v1', 1);
      await db.close();
      final bytes = await file.readAsBytes();
      expect(String.fromCharCodes(bytes.take(15)), isNot('SQLite format 3'));
      expect(String.fromCharCodes(bytes).contains('Voter 1'), isFalse);

      final reopened = RegistryDb(openEncrypted(file: file, key: key));
      expect((await reopened.select(reopened.voters).get()).single.fullName, 'Voter 1');
      await reopened.close();
    });

    test('a wrong key cannot open the database', () async {
      final file = File('${dir.path}/registry.db');
      final db = RegistryDb(openEncrypted(file: file, key: randomBytes(32)));
      await insertElection(db);
      await db.close();
      final wrong = RegistryDb(openEncrypted(file: file, key: randomBytes(32)));
      await expectLater(wrong.select(wrong.elections).get(), throwsA(anything));
    });
  });

  group('rules enforced by the database', () {
    late RegistryDb db;
    setUp(() async {
      db = memoryRegistry();
      await insertElection(db);
      await db.into(db.feeConfigs).insert(FeeConfigsCompanion.insert(
          electionId: 'e1', enabled: true, amount: const Value(500)));
    });
    tearDown(() => db.close());

    test('fee can change before the first voter', () async {
      await (db.update(db.feeConfigs)..where((f) => f.electionId.equals('e1')))
          .write(const FeeConfigsCompanion(amount: Value(1000)));
      expect((await db.select(db.feeConfigs).getSingle()).amount, 1000);
    });

    test('fee is locked after the first voter', () async {
      await insertVoter(db, 'v1', 1);
      await expectLater(
        (db.update(db.feeConfigs)..where((f) => f.electionId.equals('e1')))
            .write(const FeeConfigsCompanion(amount: Value(1))),
        throwsA(anything),
      );
      await expectLater(db.delete(db.feeConfigs).go(), throwsA(anything));
    });

    test('the register cannot change after it is locked', () async {
      await insertVoter(db, 'v1', 1);
      await db.into(db.registerLocks).insert(RegisterLocksCompanion.insert(
          electionId: 'e1', signedRegister: '{}', fingerprint: 'AAAA-AAAA', lockedBy: 'PO',
          lockedAt: DateTime.utc(2026, 11, 3)));
      await expectLater(insertVoter(db, 'v2', 2), throwsA(anything));
      await expectLater(
        (db.update(db.voters)..where((v) => v.id.equals('v1')))
            .write(const VotersCompanion(fullName: Value('Changed'))),
        throwsA(anything),
      );
      await expectLater(db.delete(db.voters).go(), throwsA(anything));
      // Reprinting a card (card issue) is still allowed after locking.
      await (db.update(db.voters)..where((v) => v.id.equals('v1')))
          .write(const VotersCompanion(cardIssue: Value(2)));
    });

    test('voter numbers are unique per election', () async {
      await insertVoter(db, 'v1', 1);
      await expectLater(insertVoter(db, 'v2', 1), throwsA(anything));
    });
  });
}

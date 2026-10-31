import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:rakubavote/app/device_store.dart';
import 'package:rakubavote/core/crypto/device_keys.dart';
import 'package:rakubavote/core/crypto/key_vault.dart';
import 'package:rakubavote/core/db/open_encrypted.dart';
import 'package:rakubavote/core/db/registry_db.dart';
import 'package:rakubavote/core/domain/templates.dart';
import 'package:rakubavote/features/registration/duplicates.dart';
import 'package:rakubavote/features/registration/registration_service.dart';
import 'package:rakubavote/features/setup/election_service.dart';

import '../support/fixtures.dart';

void main() {
  late RegistryDb db;
  late ElectionService setup;
  late RegistrationService reg;
  const po = 'Registration official';

  setUp(() async {
    db = memoryRegistry();
    setup = ElectionService(db, await DeviceKeys.generate());
    reg = RegistrationService(db, clock: () => DateTime(2026, 11, 1, 10));
  });
  tearDown(() => db.close());

  Future<String> election({ElectionTemplate t = ElectionTemplate.association}) => setup.createElection(
      template: t, orgName: 'Org', name: 'Election', year: 2026, stationName: 'Station 1',
      languages: ['en'], official: po);

  group('duplicate names', () {
    test('order, case and punctuation do not matter', () {
      expect(similarNames('Deng, Mary  Achol', 'mary achol deng'), isTrue);
    });
    test('small spelling differences are caught', () {
      expect(similarNames('Mary Achol Deng', 'Mary Akol Deng'), isTrue);
    });
    test('different people are not flagged', () {
      expect(similarNames('Mary Achol Deng', 'John Garang Kuol'), isFalse);
    });
  });

  test('voter numbers go up one at a time and the date is recorded', () async {
    final id = await election();
    final a = await reg.register(id, const VoterInput(fullName: 'Voter One'), official: po);
    final b = await reg.register(id, const VoterInput(fullName: 'Voter Two'), official: po);
    expect([a.voterNo, b.voterNo], [1, 2]);
    final v = await (db.select(db.voters)..where((x) => x.id.equals(a.id))).getSingle();
    expect(v.registeredOn, '2026-11-01');
    expect(v.registeredBy, po);
    expect((await setup.currentElection())!.state, 'registration');
  });

  test('possible duplicates are reported but not blocked', () async {
    final id = await election();
    await reg.register(id, const VoterInput(fullName: 'Mary Achol Deng', groupName: 'Juba branch'), official: po);
    await reg.register(id, const VoterInput(fullName: 'Peter Lado', memberId: 'M-77'), official: po);
    final sameName = await reg.register(id,
        const VoterInput(fullName: 'Mary Akol Deng', groupName: 'Juba Branch'), official: po);
    expect(sameName.duplicates.single.reason, DuplicateReason.similarNameSameGroup);
    final otherGroup = await reg.register(id,
        const VoterInput(fullName: 'Mary Achol Deng', groupName: 'Wau branch'), official: po);
    expect(otherGroup.duplicates, isEmpty);
    final sameId = await reg.register(id, const VoterInput(fullName: 'Someone', memberId: 'm-77'), official: po);
    expect(sameId.duplicates.single.reason, DuplicateReason.sameMemberId);
  });

  test('school elections need consent recorded before registration', () async {
    final id = await election(t: ElectionTemplate.school);
    expect(
      () => reg.register(id, const VoterInput(fullName: 'Student'), official: po),
      throwsA(isA<RegistrationException>().having((e) => e.failure, 'f', RegistrationFailure.consentMissing)),
    );
    await setup.recordSchoolConsent(id, official: 'Head teacher');
    expect((await reg.register(id, const VoterInput(fullName: 'Student'), official: po)).voterNo, 1);
  });

  group('fee rules', () {
    test('block policy refuses unpaid registration', () async {
      final id = await election();
      await setup.setFee(id, enabled: true, amount: 500, currency: FeeCurrency.ssp,
          unpaidPolicy: UnpaidPolicy.block, official: po);
      expect(
        () => reg.register(id, const VoterInput(fullName: 'A'), official: po),
        throwsA(isA<RegistrationException>().having((e) => e.failure, 'f', RegistrationFailure.feeUnpaidBlocked)),
      );
    });

    test('allow-with-flag policy registers and flags', () async {
      final id = await election();
      await setup.setFee(id, enabled: true, amount: 500, currency: FeeCurrency.ssp,
          unpaidPolicy: UnpaidPolicy.allowFlagged, official: po);
      final r = await reg.register(id, const VoterInput(fullName: 'A'), official: po);
      final v = await (db.select(db.voters)..where((x) => x.id.equals(r.id))).getSingle();
      expect(v.unpaidFlag, isTrue);
    });

    test('paid needs a receipt number', () async {
      final id = await election();
      await setup.setFee(id, enabled: true, amount: 500, currency: FeeCurrency.ssp,
          unpaidPolicy: UnpaidPolicy.block, official: po);
      expect(
        () => reg.register(id, const VoterInput(fullName: 'A', feePaid: true), official: po),
        throwsA(isA<RegistrationException>().having((e) => e.failure, 'f', RegistrationFailure.receiptRequired)),
      );
    });

    test('either currency: the official picks SSP or USD', () async {
      final id = await election();
      await setup.setFee(id, enabled: true, amount: 5, currency: FeeCurrency.either,
          unpaidPolicy: UnpaidPolicy.block, official: po);
      expect(
        () => reg.register(id, const VoterInput(fullName: 'A', feePaid: true, receiptNo: 'R1'), official: po),
        throwsA(isA<RegistrationException>()),
      );
      await reg.register(id,
          const VoterInput(fullName: 'A', feePaid: true, receiptNo: 'R1', feeCurrency: 'USD'), official: po);
    });

    test('fee summary totals by currency and by official', () async {
      final id = await election();
      await setup.setFee(id, enabled: true, amount: 500, currency: FeeCurrency.either,
          unpaidPolicy: UnpaidPolicy.allowFlagged, official: po);
      await reg.register(id, const VoterInput(fullName: 'A', feePaid: true, receiptNo: 'R1', feeCurrency: 'SSP'),
          official: 'Official A');
      await reg.register(id, const VoterInput(fullName: 'B', feePaid: true, receiptNo: 'R2', feeCurrency: 'SSP'),
          official: 'Official B');
      await reg.register(id, const VoterInput(fullName: 'C', feePaid: true, receiptNo: 'R3', feeCurrency: 'USD'),
          official: 'Official B');
      await reg.register(id, const VoterInput(fullName: 'D'), official: 'Official A');
      final s = await reg.feeSummary(id);
      expect(s.byCurrency, {'SSP': 1000, 'USD': 500});
      expect(s.byOfficial['Official B'], {'SSP': 500, 'USD': 500});
      expect(s.paidCount, 3);
      expect(s.unpaidCount, 1);
      expect(s.flaggedCount, 1);
    });
  });

  test('the audit log has the voter number but no personal data', () async {
    final id = await election();
    await reg.register(id, const VoterInput(fullName: 'Mary Achol Deng', memberId: 'M-123', groupName: 'Juba'),
        official: po);
    final text = [for (final e in await reg.audit.entries()) e.payload].join('\n');
    expect(text, contains('"voterNo":1'));
    expect(text, isNot(contains('Mary')));
    expect(text, isNot(contains('M-123')));
    expect(text, isNot(contains('Juba')));
  });

  group('CSV import', () {
    test('imports rows and explains skipped ones', () async {
      final id = await election();
      const csv = '﻿Full Name,Member ID,County,Fee paid,Receipt no\r\n'
          'Mary Achol Deng,D-001,Juba,yes,R-1\r\n'
          ',D-002,Juba,no,\r\n'
          'Peter Lado,007,Wau,no,\r\n'
          'Mary Akol Deng,D-009,Juba,no,\r\n';
      final r = await reg.importCsv(id, csv, official: po);
      expect(r.importedVoterNos, [1, 2, 3]);
      expect(r.skipped.single.line, 3);
      expect(r.possibleDuplicates, [3]);
      final peter = await (db.select(db.voters)..where((v) => v.voterNo.equals(2))).getSingle();
      expect(peter.memberId, '007', reason: 'IDs are kept as text');
      expect(peter.groupName, 'Wau');
    });

    test('a file without a name column is refused clearly', () async {
      final id = await election();
      final r = await reg.importCsv(id, 'id,group\n1,A\n', official: po);
      expect(r.importedVoterNos, isEmpty);
      expect(r.skipped.single.reason, contains('full_name'));
    });

    test('the fee policy applies to imported rows too', () async {
      final id = await election();
      await setup.setFee(id, enabled: true, amount: 500, currency: FeeCurrency.ssp,
          unpaidPolicy: UnpaidPolicy.block, official: po);
      final r = await reg.importCsv(id, 'full_name,fee_paid,receipt_no\nA,yes,R1\nB,no,\n', official: po);
      expect(r.importedVoterNos, [1]);
      expect(r.skipped.single.reason, 'feeUnpaidBlocked');
    });
  });

  test('replacing a card raises the card issue and is logged', () async {
    final id = await election();
    final v = await reg.register(id, const VoterInput(fullName: 'A'), official: po);
    expect(await reg.replaceCard(v.id, official: po, reason: 'Lost'), 2);
    expect((await reg.audit.entries()).last.action, 'voter.card_replaced');
  });

  group('device store', () {
    late Directory dir;
    setUp(() async => dir = await Directory.systemTemp.createTemp('rkv-device'));
    tearDown(() => dir.delete(recursive: true));

    test('set up, lock, unlock with the PIN, back up to a folder', () async {
      final store = DeviceStore(dir, kdf: KdfParams.fast);
      expect(await store.readInfo(), isNull);
      expect(() => store.setUp(mode: DeviceMode.admin, pin: '123', official: po), throwsArgumentError);
      final s = await store.setUp(mode: DeviceMode.admin, pin: '482913', official: po);
      expect(s.registry, isNotNull);
      expect(s.ballotBox, isNotNull);
      final svc = ElectionService(s.registry!, s.keys);
      final eid = await svc.createElection(template: ElectionTemplate.association, orgName: 'O', name: 'N',
          year: 2026, stationName: 'S', languages: ['en'], official: po);
      await RegistrationService(s.registry!).register(eid,
          VoterInput(fullName: 'Backed Up', photo: Uint8List.fromList([9, 9])), official: po);

      final usb = await Directory.systemTemp.createTemp('rkv-usb');
      final out = await store.backup(s, usb, now: DateTime(2026, 11, 2, 15, 4));
      expect(out.path, endsWith('rakubavote-backup-20261102-1504'));
      await s.close();

      expect(() => store.unlock(pin: '000000', official: po), throwsA(isA<WrongPinException>()));
      final again = await store.unlock(pin: '482913', official: po);
      expect(again.keys.deviceId, s.keys.deviceId);
      await again.close();

      // The backup opens with the vault from the backup and the same PIN.
      final secrets = await KeyVault.open(await File('${out.path}/vault.json').readAsString(), '482913');
      final restored = RegistryDb(openEncrypted(file: File('${out.path}/registry.db'), key: secrets.registryDbKey));
      expect((await restored.select(restored.voters).getSingle()).fullName, 'Backed Up');
      expect((await restored.customSelect("SELECT name FROM sqlite_master WHERE type='trigger'").get()),
          isNotEmpty, reason: 'triggers are copied too');
      await restored.close();
      final raw = await File('${out.path}/registry.db').readAsBytes();
      expect(String.fromCharCodes(raw).contains('Backed Up'), isFalse);
      await usb.delete(recursive: true);
    });

    test('a booth tablet has no register database', () async {
      final store = DeviceStore(dir, kdf: KdfParams.fast);
      final s = await store.setUp(mode: DeviceMode.booth, pin: '482913', official: po);
      expect(s.registry, isNull);
      expect(s.ballotBox, isNotNull);
      await s.close();
      expect(await store.registryFile.exists(), isFalse);
    });
  });
}

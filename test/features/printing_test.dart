import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:rakubavote/core/crypto/device_keys.dart';
import 'package:rakubavote/core/crypto/voter_card_code.dart';
import 'package:rakubavote/core/db/registry_db.dart';
import 'package:rakubavote/core/domain/templates.dart';
import 'package:rakubavote/features/registration/registration_service.dart';
import 'package:rakubavote/features/setup/election_service.dart';
import 'package:rakubavote/printing/card_service.dart';
import 'package:rakubavote/printing/register_pdf.dart';
import 'package:rakubavote/printing/voter_card_pdf.dart';

import '../support/election_builder.dart';
import '../support/fixtures.dart';

final labels = CardLabels(
  cardTitle: 'Voter registration card',
  fullName: 'Full name',
  voterNo: 'Voter No.',
  fee: 'Fee',
  registeredLine: (d, s) => 'Registered $d at $s. Not transferable.',
  qrNote: 'Voter No. + signature only. No personal data.',
  officialSignature: 'Registration official: name and signature',
  officialSeal: 'Official seal',
);

final registerLabels = RegisterLabels(
  title: 'Voter register',
  voterNo: 'Voter No.',
  name: 'Name',
  idLabel: 'Member ID',
  groupLabel: 'Branch',
  draftNote: 'Draft: not locked yet',
  lockedNote: (f) => 'Locked. Fingerprint: $f',
  generatedOn: (d) => 'Printed $d',
  pageOf: (p, n) => 'Page $p of $n',
  total: (n) => '$n voters',
);

int pageCount(Uint8List pdf) => RegExp(r'/Type\s*/Page[^s]').allMatches(latin1.decode(pdf)).length;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized(); // asset bundle for fonts

  late RegistryDb db;
  late DeviceKeys station;
  late CardService cards;
  late String id;

  setUp(() async {
    db = memoryRegistry();
    station = await DeviceKeys.generate();
    final setup = ElectionService(db, station);
    id = await setup.createElection(
        template: ElectionTemplate.association, orgName: 'CIEC Community Independent Electoral Committee',
        name: 'Community Association Election', year: 2026, stationName: 'Station 1', languages: ['en'], official: 'PO');
    await setup.setFee(id, enabled: true, amount: 500, currency: FeeCurrency.ssp,
        unpaidPolicy: UnpaidPolicy.allowFlagged, official: 'PO');
    final reg = RegistrationService(db, clock: () => DateTime(2026, 11, 1));
    await reg.register(id,
        VoterInput(fullName: 'Mary Achol Deng', memberId: 'M-142', groupName: 'Juba', feePaid: true, receiptNo: 'R-0142',
            photo: Uint8List.fromList(const [0xFF, 0xD8, 0xFF])), official: 'PO');
    await reg.register(id, const VoterInput(fullName: 'مريم أشول', groupName: 'Juba'), official: 'PO');
    for (var i = 3; i <= 12; i++) {
      await reg.register(id, VoterInput(fullName: 'Voter $i', groupName: 'Wau'), official: 'PO');
    }
    cards = CardService(db, station);
  });
  tearDown(() => db.close());

  String fee(FeePayment? p) => p == null ? '' : (p.paid ? 'Paid · ${p.receiptNo}' : 'Not paid');

  Future<List<String>> allIds() async => [for (final v in await db.select(db.voters).get()) v.id];

  test('card data matches mockup E fields; the QR checks with the current card', () async {
    final data = await cards.cardData(await allIds(), feeText: fee);
    final mary = data.first;
    expect(mary.voterNoLabel, '0001');
    expect(mary.fullName, 'Mary Achol Deng');
    expect((mary.idLabel, mary.memberId), ('Member ID', 'M-142'));
    expect((mary.groupLabel, mary.groupName), ('Branch', 'Juba'));
    expect(mary.feeText, 'Paid · R-0142');
    expect(mary.registeredOn, '2026-11-01');
    expect(data[1].feeText, 'Not paid');
    // QR: voter number + signature only.
    expect(mary.qrText.split('.'), hasLength(3));
    expect(mary.qrText, isNot(contains('Mary')));
    expect(
        await VoterCardCode.verify(
            qr: mary.qrText, electionId: id, currentCardIssue: 1, stationPublicKey: station.signingPublic),
        isTrue);
  });

  test('a reprinted card carries the new issue; the old one fails', () async {
    final v = await (db.select(db.voters)..where((x) => x.voterNo.equals(1))).getSingle();
    final before = (await cards.cardData([v.id], feeText: fee)).single.qrText;
    await RegistrationService(db).replaceCard(v.id, official: 'PO', reason: 'Lost');
    final after = (await cards.cardData([v.id], feeText: fee)).single.qrText;
    expect(await VoterCardCode.verify(qr: after, electionId: id, currentCardIssue: 2, stationPublicKey: station.signingPublic), isTrue);
    expect(await VoterCardCode.verify(qr: before, electionId: id, currentCardIssue: 2, stationPublicKey: station.signingPublic), isFalse);
  });

  test('printed status follows the card issue and is logged by number', () async {
    expect(await cards.unprinted(), hasLength(12));
    final first = (await db.select(db.voters).get()).take(2).map((v) => v.id).toList();
    await cards.markPrinted(first, official: 'Registration official');
    expect(await cards.unprinted(), hasLength(10));
    await RegistrationService(db).replaceCard(first.first, official: 'PO', reason: 'Lost');
    expect(await cards.unprinted(), hasLength(11), reason: 'the new card needs printing');
    final log = (await cards.audit.entries()).where((e) => e.action == 'voter.card_printed').single;
    expect(log.payload, '{"voterNos":[1,2]}');
  });

  test('PDF layouts: 10 ID cards per A4 sheet, one per page otherwise', () async {
    final data = await cards.cardData(await allIds(), feeText: fee);
    final sheet = await buildVoterCardsPdf(data, labels: labels, layout: CardLayout.idCardsOnA4);
    expect(latin1.decode(sheet.sublist(0, 5)), '%PDF-');
    expect(pageCount(sheet), 2);
    expect(pageCount(await buildVoterCardsPdf(data.take(3).toList(), labels: labels, layout: CardLayout.idCardSingle)), 3);
    final a6 = await buildVoterCardsPdf(data.take(2).toList(), labels: labels, layout: CardLayout.a6);
    expect(pageCount(a6), 2);
    // ID-1 page size in points: 85.6 mm × 54 mm.
    final single = latin1.decode(await buildVoterCardsPdf(data.take(1).toList(), labels: labels, layout: CardLayout.idCardSingle, compress: false));
    expect(single, contains(RegExp(r"/MediaBox\s*\[0 0 242\.6\d* 153\.0\d*\]")));
  });

  test('register PDF: draft before lock, fingerprint after; no fee or photo data', () async {
    final draft = await cards.register();
    expect(draft.fingerprint, isNull);
    expect(draft.lines.first.fullName, 'Mary Achol Deng');
    final pdf = await buildRegisterPdf(
        orgName: draft.election.orgName, electionName: draft.election.name, year: 2026, stationName: 'Station 1',
        lines: draft.lines, labels: registerLabels, generatedOn: '2026-11-02');
    expect(pageCount(pdf), 1);

    final db2 = memoryRegistry();
    final station2 = await DeviceKeys.generate();
    await buildLockedElection(db2, station2, voters: 120, openPolls: false);
    final locked = await CardService(db2, station2).register();
    expect(locked.fingerprint, matches(RegExp(r'^[0-9A-Z]{4}-[0-9A-Z]{4}$')));
    final big = await buildRegisterPdf(
        orgName: 'CIEC', electionName: 'E', year: 2026, stationName: 'S', lines: locked.lines,
        labels: registerLabels, generatedOn: '2026-11-03', fingerprint: locked.fingerprint);
    expect(pageCount(big), greaterThan(2));
    await db2.close();
  });

  test('cards print without a photo or logo, and with a damaged photo, in every layout', () async {
    final data = await cards.cardData(await allIds(), feeText: fee);
    final one = data.first;
    final damaged = VoterCardData(
        orgName: one.orgName, electionName: one.electionName, year: one.year, stationName: one.stationName,
        voterNoLabel: one.voterNoLabel, fullName: one.fullName, idLabel: one.idLabel, memberId: one.memberId,
        groupLabel: one.groupLabel, groupName: one.groupName, feeText: '', registeredOn: one.registeredOn,
        qrText: one.qrText, photo: Uint8List.fromList([1, 2, 3]), orgLogo: Uint8List.fromList([9, 9]));
    for (final layout in CardLayout.values) {
      expect(pageCount(await buildVoterCardsPdf([one, damaged], labels: labels, layout: layout)), layout == CardLayout.idCardsOnA4 ? 1 : 2);
    }
  });
}

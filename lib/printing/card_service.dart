import 'package:drift/drift.dart';

import '../core/audit/audit_log.dart';
import '../core/crypto/device_keys.dart';
import '../core/crypto/voter_card_code.dart';
import '../core/db/registry_db.dart';
import '../core/format.dart';
import 'register_pdf.dart';
import 'voter_card_pdf.dart';

/// Builds what is printed (voter cards, the register) from the registry and
/// records printing in the audit log by voter number only.
class CardService {
  CardService(this.db, this.stationKeys, {AuditLogService? audit}) : audit = audit ?? AuditLogService(db);

  final RegistryDb db;
  final DeviceKeys stationKeys;
  final AuditLogService audit;

  Future<Election> _election() => (db.select(db.elections)..limit(1)).getSingle();

  /// Card data for the given voters, in voter-number order. [feeText]
  /// turns a fee payment into words such as "Paid · R-0142".
  Future<List<VoterCardData>> cardData(Iterable<String> voterIds,
      {required String Function(FeePayment? payment) feeText}) async {
    final e = await _election();
    final fee = await (db.select(db.feeConfigs)..where((f) => f.electionId.equals(e.id))).getSingleOrNull();
    final voters = await (db.select(db.voters)
          ..where((v) => v.id.isIn(voterIds.toList()) & v.status.equals('active'))
          ..orderBy([(v) => OrderingTerm.asc(v.voterNo)]))
        .get();
    return [
      for (final v in voters)
        VoterCardData(
          orgName: e.orgName,
          electionName: e.name,
          year: e.year,
          stationName: e.stationName,
          voterNoLabel: voterNoLabel(v.voterNo),
          fullName: v.fullName,
          idLabel: e.idLabel,
          memberId: v.memberId,
          groupLabel: e.groupLabel,
          groupName: v.groupName,
          feeText: fee != null && fee.enabled
              ? feeText(await (db.select(db.feePayments)..where((p) => p.voterId.equals(v.id))).getSingleOrNull())
              : '',
          registeredOn: v.registeredOn,
          qrText: await VoterCardCode.create(
              electionId: e.id, voterNo: v.voterNo, cardIssue: v.cardIssue, stationKeys: stationKeys),
          orgLogo: e.orgLogo,
          photo: v.photo,
        ),
    ];
  }

  /// Voters whose current card has not been printed.
  Future<List<Voter>> unprinted() async {
    final e = await _election();
    return (db.select(db.voters)
          ..where((v) =>
              v.electionId.equals(e.id) &
              v.status.equals('active') &
              (v.cardPrintedIssue.isNull() | v.cardPrintedIssue.isSmallerThan(v.cardIssue)))
          ..orderBy([(v) => OrderingTerm.asc(v.voterNo)]))
        .get();
  }

  Future<void> markPrinted(Iterable<String> voterIds, {required String official}) async {
    final voters = await (db.select(db.voters)..where((v) => v.id.isIn(voterIds.toList()))).get();
    await db.transaction(() async {
      for (final v in voters) {
        await (db.update(db.voters)..where((x) => x.id.equals(v.id)))
            .write(VotersCompanion(cardPrintedIssue: Value(v.cardIssue)));
      }
      await audit.append(actor: official, action: AuditAction.voterCardPrinted, payload: {
        'voterNos': [for (final v in voters) v.voterNo]..sort(),
      });
    });
  }

  /// The register lines (active voters by number) and the fingerprint if locked.
  Future<({List<RegisterLine> lines, String? fingerprint, Election election})> register() async {
    final e = await _election();
    final voters = await (db.select(db.voters)
          ..where((v) => v.electionId.equals(e.id) & v.status.equals('active'))
          ..orderBy([(v) => OrderingTerm.asc(v.voterNo)]))
        .get();
    final lock = await (db.select(db.registerLocks)..where((l) => l.electionId.equals(e.id))).getSingleOrNull();
    return (
      lines: [for (final v in voters) RegisterLine(voterNoLabel(v.voterNo), v.fullName, v.memberId, v.groupName)],
      fingerprint: lock?.fingerprint,
      election: e,
    );
  }
}


import 'package:csv/csv.dart';
import 'package:drift/drift.dart';

import '../../core/audit/audit_log.dart';
import '../../core/crypto/bytes.dart';
import '../../core/db/registry_db.dart';
import '../../core/domain/election_state.dart';
import '../../core/domain/templates.dart';
import '../setup/election_service.dart';
import 'duplicates.dart';

enum RegistrationFailure {
  noElection,
  registerLocked,
  consentMissing,
  nameRequired,
  feeUnpaidBlocked,
  receiptRequired,
  currencyNotAccepted,
}

class RegistrationException implements Exception {
  RegistrationException(this.failure, [this.detail = '']);
  final RegistrationFailure failure;
  final String detail;
  @override
  String toString() => 'RegistrationException(${failure.name}: $detail)';
}

/// What an official enters for one voter (mockup B). Only the fields approved
/// in decision D2.
class VoterInput {
  const VoterInput({
    required this.fullName,
    this.memberId = '',
    this.groupName = '',
    this.photo,
    this.feePaid = false,
    this.feeCurrency,
    this.receiptNo,
  });

  final String fullName;
  final String memberId;
  final String groupName;
  final Uint8List? photo;
  final bool feePaid;
  /// 'SSP' or 'USD'; needed when the election accepts either.
  final String? feeCurrency;
  final String? receiptNo;
}

class RegisteredVoter {
  const RegisteredVoter(this.id, this.voterNo, this.duplicates);
  final String id;
  final int voterNo;
  final List<DuplicateMatch> duplicates;
}

class ImportRowProblem {
  const ImportRowProblem(this.line, this.reason);
  /// 1-based line number in the file (header is line 1).
  final int line;
  final String reason;
}

class ImportReport {
  ImportReport();
  final List<int> importedVoterNos = [];
  final List<ImportRowProblem> skipped = [];
  final List<int> possibleDuplicates = [];
}

class FeeTotals {
  const FeeTotals({required this.byCurrency, required this.byOfficial, required this.paidCount,
      required this.unpaidCount, required this.flaggedCount});
  final Map<String, int> byCurrency;
  /// official -> currency -> total
  final Map<String, Map<String, int>> byOfficial;
  final int paidCount;
  final int unpaidCount;
  final int flaggedCount;
}

/// Voter registration on the station laptop.
class RegistrationService {
  RegistrationService(this.db, {AuditLogService? audit, DateTime Function()? clock})
      : audit = audit ?? AuditLogService(db, clock: clock),
        _clock = clock ?? DateTime.now;

  final RegistryDb db;
  final AuditLogService audit;
  final DateTime Function() _clock;

  String _today() {
    final d = _clock();
    return '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }

  Future<Election> _election(String electionId) async {
    final e = await (db.select(db.elections)..where((x) => x.id.equals(electionId))).getSingleOrNull();
    if (e == null) throw RegistrationException(RegistrationFailure.noElection);
    return e;
  }

  /// Checks that registration may happen now. Throws with the reason if not.
  Future<void> ensureCanRegister(String electionId) async {
    final e = await _election(electionId);
    if (ElectionState.fromWire(e.state).index >= ElectionState.locked.index) {
      throw RegistrationException(RegistrationFailure.registerLocked);
    }
    if (ElectionTemplate.fromWire(e.template).requiresConsent && !e.schoolConsentRecorded) {
      throw RegistrationException(RegistrationFailure.consentMissing);
    }
  }

  Future<List<DuplicateMatch>> findDuplicates(String electionId,
      {required String fullName, String memberId = '', String groupName = '', String? excludeVoterId}) async {
    final voters = await (db.select(db.voters)
          ..where((v) => v.electionId.equals(electionId) & v.status.equals('active')))
        .get();
    final out = <DuplicateMatch>[];
    final id = memberId.trim().toLowerCase();
    final group = groupName.trim().toLowerCase();
    for (final v in voters) {
      if (v.id == excludeVoterId) continue;
      if (id.isNotEmpty && v.memberId.trim().toLowerCase() == id) {
        out.add(DuplicateMatch(v.id, v.voterNo, DuplicateReason.sameMemberId));
      } else if (v.groupName.trim().toLowerCase() == group && similarNames(v.fullName, fullName)) {
        out.add(DuplicateMatch(v.id, v.voterNo, DuplicateReason.similarNameSameGroup));
      }
    }
    return out;
  }

  Future<RegisteredVoter> register(String electionId, VoterInput input,
      {required String official, String auditAction = AuditAction.voterRegistered}) async {
    await ensureCanRegister(electionId);
    if (input.fullName.trim().isEmpty) throw RegistrationException(RegistrationFailure.nameRequired);

    final fee = await (db.select(db.feeConfigs)..where((f) => f.electionId.equals(electionId))).getSingleOrNull();
    var unpaidFlag = false;
    String? currency;
    if (fee != null && fee.enabled) {
      if (input.feePaid) {
        if ((input.receiptNo ?? '').trim().isEmpty) {
          throw RegistrationException(RegistrationFailure.receiptRequired);
        }
        currency = fee.currency == 'EITHER' ? input.feeCurrency : fee.currency;
        if (currency != 'SSP' && currency != 'USD' ||
            (fee.currency != 'EITHER' && input.feeCurrency != null && input.feeCurrency != fee.currency)) {
          throw RegistrationException(RegistrationFailure.currencyNotAccepted);
        }
      } else if (UnpaidPolicyWire.parse(fee.unpaidPolicy) == UnpaidPolicy.block) {
        throw RegistrationException(RegistrationFailure.feeUnpaidBlocked);
      } else {
        unpaidFlag = true;
      }
    }

    final dups = await findDuplicates(electionId,
        fullName: input.fullName, memberId: input.memberId, groupName: input.groupName);
    final id = randomId();
    late int voterNo;
    await db.transaction(() async {
      final e = await _election(electionId);
      voterNo = e.lastVoterNo + 1;
      await (db.update(db.elections)..where((x) => x.id.equals(electionId))).write(ElectionsCompanion(
        lastVoterNo: Value(voterNo),
        state: e.state == ElectionState.setup.name ? Value(ElectionState.registration.name) : const Value.absent(),
      ));
      await db.into(db.voters).insert(VotersCompanion.insert(
            id: id,
            electionId: electionId,
            voterNo: voterNo,
            fullName: input.fullName.trim(),
            memberId: Value(input.memberId.trim()),
            groupName: Value(input.groupName.trim()),
            photo: Value(input.photo),
            registeredOn: _today(),
            registeredBy: official,
            unpaidFlag: Value(unpaidFlag),
          ));
      if (fee != null && fee.enabled) {
        await db.into(db.feePayments).insert(FeePaymentsCompanion.insert(
              voterId: id,
              paid: input.feePaid,
              currency: Value(currency),
              amount: Value(input.feePaid ? fee.amount : null),
              receiptNo: Value(input.feePaid ? input.receiptNo!.trim() : null),
              recordedBy: official,
            ));
      }
      // Personal data stays out of the audit log: voter number only.
      await audit.append(actor: official, action: auditAction, payload: {
        'voterNo': voterNo,
        if (fee != null && fee.enabled) 'feePaid': input.feePaid,
        if (unpaidFlag) 'unpaidFlag': true,
        if (dups.isNotEmpty) 'possibleDuplicateOf': [for (final d in dups) d.voterNo],
      });
    });
    return RegisteredVoter(id, voterNo, dups);
  }

  /// Imports a CSV list (for example a party's delegate list). Expected header
  /// (any order, case-insensitive): `full_name`, and optionally `member_id`,
  /// `group`, `fee_paid` (yes/no), `currency`, `receipt_no`. Rows that cannot
  /// be registered are skipped with a reason; nothing is guessed.
  Future<ImportReport> importCsv(String electionId, String csvText, {required String official}) async {
    await ensureCanRegister(electionId);
    final report = ImportReport();
    final rows = Csv().decode(csvText.replaceFirst('﻿', ''));
    if (rows.isEmpty) return report;
    final header = [for (final h in rows.first) '$h'.trim().toLowerCase().replaceAll(' ', '_')];
    int col(List<String> names) => header.indexWhere(names.contains);
    final nameCol = col(['full_name', 'name', 'fullname']);
    final idCol = col(['member_id', 'student_id', 'delegate_id', 'id']);
    final groupCol = col(['group', 'class', 'branch', 'county']);
    final paidCol = col(['fee_paid', 'paid']);
    final currencyCol = col(['currency']);
    final receiptCol = col(['receipt_no', 'receipt']);
    if (nameCol < 0) {
      report.skipped.add(const ImportRowProblem(1, 'No full_name column in the first row.'));
      return report;
    }
    String cell(List<dynamic> r, int c) => c >= 0 && c < r.length ? '${r[c]}'.trim() : '';
    for (var i = 1; i < rows.length; i++) {
      final r = rows[i];
      final name = cell(r, nameCol);
      if (name.isEmpty) {
        report.skipped.add(ImportRowProblem(i + 1, 'Name is empty.'));
        continue;
      }
      final paid = ['yes', 'y', 'true', '1', 'paid'].contains(cell(r, paidCol).toLowerCase());
      try {
        final res = await register(
          electionId,
          VoterInput(
            fullName: name,
            memberId: cell(r, idCol),
            groupName: cell(r, groupCol),
            feePaid: paid,
            feeCurrency: cell(r, currencyCol).isEmpty ? null : cell(r, currencyCol).toUpperCase(),
            receiptNo: cell(r, receiptCol).isEmpty ? null : cell(r, receiptCol),
          ),
          official: official,
          auditAction: AuditAction.voterImported,
        );
        report.importedVoterNos.add(res.voterNo);
        if (res.duplicates.isNotEmpty) report.possibleDuplicates.add(res.voterNo);
      } on RegistrationException catch (e) {
        report.skipped.add(ImportRowProblem(i + 1, e.failure.name));
      }
    }
    return report;
  }

  Stream<List<Voter>> watchVoters(String electionId, {String query = ''}) {
    final q = query.trim().toLowerCase();
    final sel = db.select(db.voters)
      ..where((v) => v.electionId.equals(electionId) & v.status.equals('active'))
      ..orderBy([(v) => OrderingTerm.asc(v.voterNo)]);
    if (q.isNotEmpty) {
      final n = int.tryParse(q);
      sel.where((v) => n != null
          ? v.voterNo.equals(n) | v.fullName.lower().like('%$q%')
          : v.fullName.lower().like('%$q%') | v.memberId.lower().like('%$q%'));
    }
    return sel.watch();
  }

  Future<int> voterCount(String electionId) async {
    final r = await db.customSelect(
        "SELECT COUNT(*) AS n FROM voters WHERE election_id = ? AND status = 'active'",
        variables: [Variable.withString(electionId)]).getSingle();
    return r.read<int>('n');
  }

  Future<FeePayment?> feePayment(String voterId) =>
      (db.select(db.feePayments)..where((f) => f.voterId.equals(voterId))).getSingleOrNull();

  /// Fee summary for the treasurer and auditors: totals by currency and by
  /// official. Registry side only; fee data never reaches the ballot box.
  Future<FeeTotals> feeSummary(String electionId) async {
    final rows = await db.customSelect(
      'SELECT f.paid, f.currency, f.amount, f.recorded_by, v.unpaid_flag FROM fee_payments f '
      "JOIN voters v ON v.id = f.voter_id WHERE v.election_id = ? AND v.status = 'active'",
      variables: [Variable.withString(electionId)],
    ).get();
    final byCurrency = <String, int>{};
    final byOfficial = <String, Map<String, int>>{};
    var paid = 0, unpaid = 0, flagged = 0;
    for (final r in rows) {
      if (r.read<bool>('paid')) {
        paid++;
        final cur = r.read<String>('currency');
        final amt = r.read<int>('amount');
        byCurrency[cur] = (byCurrency[cur] ?? 0) + amt;
        final o = byOfficial.putIfAbsent(r.read<String>('recorded_by'), () => {});
        o[cur] = (o[cur] ?? 0) + amt;
      } else {
        unpaid++;
        if (r.read<bool>('unpaid_flag')) flagged++;
      }
    }
    return FeeTotals(
        byCurrency: byCurrency, byOfficial: byOfficial, paidCount: paid, unpaidCount: unpaid, flaggedCount: flagged);
  }

  /// Lost card: only an official can reprint. The card issue number goes up,
  /// so the old card's QR no longer verifies, and the audit log records it.
  Future<int> replaceCard(String voterId, {required String official, required String reason}) async {
    final v = await (db.select(db.voters)..where((x) => x.id.equals(voterId))).getSingle();
    final issue = v.cardIssue + 1;
    await (db.update(db.voters)..where((x) => x.id.equals(voterId)))
        .write(VotersCompanion(cardIssue: Value(issue)));
    await audit.append(actor: official, action: AuditAction.voterCardReplaced,
        payload: {'voterNo': v.voterNo, 'cardIssue': issue, 'reason': reason});
    return issue;
  }
}

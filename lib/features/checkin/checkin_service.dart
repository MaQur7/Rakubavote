import 'package:drift/drift.dart';

import '../../core/audit/audit_log.dart';
import '../../core/crypto/device_keys.dart';
import '../../core/crypto/voter_card_code.dart';
import '../../core/crypto/voting_token.dart';
import '../../core/db/registry_db.dart';
import '../../core/domain/election_state.dart';

enum CheckInFailure {
  noElection,
  pollsNotOpen,
  voterNotFound,
  voterRemoved,
  alreadyCheckedIn,
  reasonRequired,
  ballotNotSigned,
  registerNotLocked,
}

class CheckInException implements Exception {
  CheckInException(this.failure, [this.detail = '']);
  final CheckInFailure failure;
  final String detail;
  @override
  String toString() => 'CheckInException(${failure.name}: $detail)';
}

/// What reading a voter card QR code found.
enum CardResult {
  /// Signature valid for the voter's current card.
  valid,
  /// Signature valid for an older card of this voter (the card was reprinted).
  replaced,
  /// Not a Rakubavote card, or the signature does not check.
  invalid,
  /// A valid-looking card for a voter number not on this register.
  notOnRegister,
}

class CardLookup {
  const CardLookup(this.result, [this.voter]);
  final CardResult result;
  final Voter? voter;
}

/// Reasons offered for a manual check-in (an official also types details).
enum ManualReason { cardLost, cardUnreadable, photoMissing, deviceProblem, other }

class VoterStatus {
  const VoterStatus(this.voter, this.checkedIn);
  final Voter voter;
  final bool checkedIn;
}

/// Election-day check-in (mockup 1). Records WHO has been checked in and
/// issues a one-time voting code. The code itself is returned once for the
/// slip and never stored; only its hash is kept, in a table with no voter
/// and no time. The check-in row keeps the hour only.
class CheckInService {
  CheckInService(this.db, this.stationKeys, {AuditLogService? audit, DateTime Function()? clock})
      : audit = audit ?? AuditLogService(db, clock: clock),
        _clock = clock ?? DateTime.now;

  final RegistryDb db;
  final DeviceKeys stationKeys;
  final AuditLogService audit;
  final DateTime Function() _clock;

  /// Called with each new code hash, for live activation at the booths
  /// (the station server subscribes in milestone 6).
  final List<void Function(String tokenHash)> activationListeners = [];

  Future<Election> _election() async {
    final e = await (db.select(db.elections)..limit(1)).getSingleOrNull();
    if (e == null) throw CheckInException(CheckInFailure.noElection);
    return e;
  }

  // ---- Polls ----

  /// Opens the polls: the register must be locked and the ballot signed.
  Future<void> openPolls({required String official}) async {
    final e = await _election();
    final state = ElectionState.fromWire(e.state);
    if (state == ElectionState.polling) return;
    if (state != ElectionState.locked) throw CheckInException(CheckInFailure.registerNotLocked);
    if (e.signedBallot == null) throw CheckInException(CheckInFailure.ballotNotSigned);
    await (db.update(db.elections)..where((x) => x.id.equals(e.id)))
        .write(ElectionsCompanion(state: Value(ElectionState.polling.name)));
    await audit.append(actor: official, action: AuditAction.pollsOpened, payload: {'electionId': e.id});
  }

  Future<void> _ensurePolling() async {
    final e = await _election();
    if (e.state != ElectionState.polling.name) throw CheckInException(CheckInFailure.pollsNotOpen);
  }

  // ---- Finding voters ----

  Future<Voter?> _byNumber(String electionId, int n) =>
      (db.select(db.voters)..where((v) => v.electionId.equals(electionId) & v.voterNo.equals(n)))
          .getSingleOrNull();

  Future<bool> isCheckedIn(String voterId) async =>
      await (db.select(db.checkIns)..where((c) => c.voterId.equals(voterId))).getSingleOrNull() != null;

  /// Reads a voter card QR (`RKV1.<voterNo>.<signature>`), from a camera or a
  /// USB scanner that types into the search box.
  Future<CardLookup> lookupCard(String qr) async {
    final e = await _election();
    final parsed = VoterCardCode.parse(qr);
    if (parsed == null) return const CardLookup(CardResult.invalid);
    final v = await _byNumber(e.id, parsed.voterNo);
    if (v == null || v.status != 'active') return const CardLookup(CardResult.notOnRegister);
    Future<bool> check(int issue) => VoterCardCode.verify(
        qr: qr, electionId: e.id, currentCardIssue: issue, stationPublicKey: stationKeys.signingPublic);
    if (await check(v.cardIssue)) return CardLookup(CardResult.valid, v);
    for (var i = v.cardIssue - 1; i >= 1; i--) {
      if (await check(i)) return CardLookup(CardResult.replaced, v);
    }
    return const CardLookup(CardResult.invalid);
  }

  /// Search by voter number or part of the name (active voters only).
  Future<List<VoterStatus>> search(String query, {int limit = 20}) async {
    final e = await _election();
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return const [];
    final n = int.tryParse(q);
    final rows = await (db.select(db.voters)
          ..where((v) =>
              v.electionId.equals(e.id) &
              v.status.equals('active') &
              (n != null ? v.voterNo.equals(n) : v.fullName.lower().like('%$q%')))
          ..orderBy([(v) => OrderingTerm.asc(v.voterNo)])
          ..limit(limit))
        .get();
    return [for (final v in rows) VoterStatus(v, await isCheckedIn(v.id))];
  }

  // ---- Checking in ----

  String _hourBucket(DateTime t) {
    final l = t.toLocal();
    String two(int x) => x.toString().padLeft(2, '0');
    return '${l.year}-${two(l.month)}-${two(l.day)}T${two(l.hour)}';
  }

  /// Checks a voter in and returns the one-time code for the slip. The code
  /// is not stored anywhere; show it and print it, then forget it.
  Future<String> checkIn(String voterId,
      {required String method, required String official, ManualReason? reason, String details = ''}) async {
    await _ensurePolling();
    final e = await _election();
    final v = await (db.select(db.voters)..where((x) => x.id.equals(voterId))).getSingleOrNull();
    if (v == null) throw CheckInException(CheckInFailure.voterNotFound);
    if (v.status != 'active') throw CheckInException(CheckInFailure.voterRemoved);
    final manual = method == 'manual';
    if (manual && reason == null) throw CheckInException(CheckInFailure.reasonRequired);
    if (manual && reason == ManualReason.other && details.trim().isEmpty) {
      throw CheckInException(CheckInFailure.reasonRequired);
    }

    final now = _clock();
    final token = VotingToken.generate();
    final hash = VotingToken.tokenHash(e.id, token);
    await db.transaction(() async {
      if (await isCheckedIn(v.id)) throw CheckInException(CheckInFailure.alreadyCheckedIn);
      await _logFinishedHours(e.id, now, official);
      await db.into(db.checkIns).insert(CheckInsCompanion.insert(
            voterId: v.id,
            electionId: e.id,
            method: method,
            manualReason: Value(manual ? _reasonText(reason!, details) : null),
            official: official,
            hourBucket: _hourBucket(now),
          ));
      await db.into(db.issuedTokens).insert(IssuedTokensCompanion.insert(tokenHash: hash, electionId: e.id));
      // Ordinary check-ins are counted per hour (D7); manual ones are logged
      // one by one because they need an explanation.
      if (manual) {
        await audit.append(actor: official, action: AuditAction.manualCheckin, payload: {
          'voterNo': v.voterNo,
          'reason': reason!.name,
          if (details.trim().isNotEmpty) 'details': details.trim(),
        });
      }
    });
    for (final l in activationListeners) {
      l(hash);
    }
    return token;
  }

  static String _reasonText(ManualReason r, String details) =>
      details.trim().isEmpty ? r.name : '${r.name}: ${details.trim()}';

  /// Manual check-in from the printed register by voter number.
  Future<String> manualCheckIn(int voterNo,
      {required ManualReason reason, String details = '', required String official}) async {
    final e = await _election();
    final v = await _byNumber(e.id, voterNo);
    if (v == null) throw CheckInException(CheckInFailure.voterNotFound);
    return checkIn(v.id, method: 'manual', official: official, reason: reason, details: details);
  }

  /// Writes one audit entry per finished hour that has not been logged yet:
  /// "N voters checked in between 09:00 and 10:00". Never per voter.
  Future<void> _logFinishedHours(String electionId, DateTime now, String official) async {
    final current = _hourBucket(now);
    final logged = <String>{
      for (final r in await db
          .customSelect('SELECT payload FROM audit_log WHERE action = ?',
              variables: [Variable.withString(AuditAction.checkinHourlyCount)])
          .get())
        RegExp(r'"hour":"([^"]+)"').firstMatch(r.read<String>('payload'))?.group(1) ?? '',
    };
    final rows = await db.customSelect(
      'SELECT hour_bucket AS h, COUNT(*) AS n FROM check_ins WHERE election_id = ? AND hour_bucket < ? '
      'GROUP BY hour_bucket ORDER BY hour_bucket',
      variables: [Variable.withString(electionId), Variable.withString(current)],
    ).get();
    for (final r in rows) {
      final h = r.read<String>('h');
      if (logged.contains(h)) continue;
      await audit.append(
          actor: official, action: AuditAction.checkinHourlyCount, payload: {'hour': h, 'count': r.read<int>('n')});
    }
  }

  /// Logs every finished hour up to [now] (call when polls close).
  Future<void> flushHourlyCounts({required String official}) async {
    final e = await _election();
    // Treat the current hour as finished by looking one hour ahead.
    await _logFinishedHours(e.id, _clock().add(const Duration(hours: 1)), official);
  }

  // ---- Counters for the desk ----

  Stream<({int checkedIn, int registered})> watchCounts() => db
      .customSelect(
        "SELECT (SELECT COUNT(*) FROM check_ins) AS c, "
        "(SELECT COUNT(*) FROM voters WHERE status = 'active') AS r",
        readsFrom: {db.checkIns, db.voters},
      )
      .watchSingle()
      .map((r) => (checkedIn: r.read<int>('c'), registered: r.read<int>('r')));
}

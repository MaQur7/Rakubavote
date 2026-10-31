import 'package:drift/drift.dart';

import '../crypto/canonical_json.dart';
import '../crypto/hashing.dart';

/// Hash of "nothing": the previous hash of the first entry.
final genesisHash = '0' * 64;

/// Result of checking the whole chain.
class AuditVerification {
  const AuditVerification.ok(this.entryCount)
      : firstBadSeq = null,
        reason = null;
  const AuditVerification.broken(this.entryCount, this.firstBadSeq, this.reason);

  final int entryCount;
  final int? firstBadSeq;
  final String? reason;
  bool get isValid => firstBadSeq == null;
}

class AuditRecord {
  const AuditRecord({
    required this.seq,
    required this.prevHash,
    required this.ts,
    required this.actor,
    required this.action,
    required this.payload,
    required this.hash,
  });

  final int seq;
  final String prevHash;
  final String ts;
  final String actor;
  final String action;
  final String payload;
  final String hash;
}

/// Append-only, hash-chained log. Each entry's hash covers its sequence
/// number, the previous hash, time, official, action and payload, so editing
/// or removing any entry breaks every hash after it. The database also blocks
/// UPDATE and DELETE with triggers.
///
/// Works on both registry.db and ballotbox.db (both have `audit_log`).
/// Booths must only log counts and device events, never individual votes.
class AuditLogService {
  AuditLogService(this._db, {DateTime Function()? clock})
      : _clock = clock ?? DateTime.now;

  final GeneratedDatabase _db;
  final DateTime Function() _clock;

  static String timestamp(DateTime t) {
    final u = t.toUtc();
    return DateTime.utc(u.year, u.month, u.day, u.hour, u.minute, u.second)
        .toIso8601String();
  }

  static String computeHash({
    required int seq,
    required String prevHash,
    required String ts,
    required String actor,
    required String action,
    required String payload,
  }) =>
      sha256Hex(canonicalJsonBytes({
        'seq': seq,
        'prev': prevHash,
        'ts': ts,
        'actor': actor,
        'action': action,
        'payload': payload,
      }));

  /// Appends one entry and returns it. Runs in a transaction so concurrent
  /// appends cannot fork the chain.
  Future<AuditRecord> append({
    required String actor,
    required String action,
    Map<String, Object?> payload = const {},
  }) {
    return _db.transaction(() async {
      final last = await _db
          .customSelect('SELECT seq, hash FROM audit_log ORDER BY seq DESC LIMIT 1')
          .getSingleOrNull();
      final seq = (last?.read<int>('seq') ?? 0) + 1;
      final prev = last?.read<String>('hash') ?? genesisHash;
      final ts = timestamp(_clock());
      final body = canonicalJson(payload);
      final hash = computeHash(
          seq: seq, prevHash: prev, ts: ts, actor: actor, action: action, payload: body);
      await _db.customInsert(
        'INSERT INTO audit_log (seq, prev_hash, ts, actor, action, payload, hash) '
        'VALUES (?, ?, ?, ?, ?, ?, ?)',
        variables: [
          Variable.withInt(seq),
          Variable.withString(prev),
          Variable.withString(ts),
          Variable.withString(actor),
          Variable.withString(action),
          Variable.withString(body),
          Variable.withString(hash),
        ],
      );
      return AuditRecord(
          seq: seq, prevHash: prev, ts: ts, actor: actor, action: action, payload: body, hash: hash);
    });
  }

  Future<List<AuditRecord>> entries() async {
    final rows = await _db.customSelect('SELECT * FROM audit_log ORDER BY seq').get();
    return [
      for (final r in rows)
        AuditRecord(
          seq: r.read<int>('seq'),
          prevHash: r.read<String>('prev_hash'),
          ts: r.read<String>('ts'),
          actor: r.read<String>('actor'),
          action: r.read<String>('action'),
          payload: r.read<String>('payload'),
          hash: r.read<String>('hash'),
        ),
    ];
  }

  /// Head hash: changes whenever anything is appended. Shown on printed
  /// reports so a later copy of the log can be checked against paper.
  Future<String> headHash() async {
    final last = await _db
        .customSelect('SELECT hash FROM audit_log ORDER BY seq DESC LIMIT 1')
        .getSingleOrNull();
    return last?.read<String>('hash') ?? genesisHash;
  }

  Future<AuditVerification> verify() async => verifyChain(await entries());

  static AuditVerification verifyChain(List<AuditRecord> list) {
    var prev = genesisHash;
    for (var i = 0; i < list.length; i++) {
      final e = list[i];
      if (e.seq != i + 1) {
        return AuditVerification.broken(list.length, e.seq, 'missing or reordered entry');
      }
      if (e.prevHash != prev) {
        return AuditVerification.broken(list.length, e.seq, 'link to previous entry is broken');
      }
      final h = computeHash(
          seq: e.seq,
          prevHash: e.prevHash,
          ts: e.ts,
          actor: e.actor,
          action: e.action,
          payload: e.payload);
      if (h != e.hash) {
        return AuditVerification.broken(list.length, e.seq, 'entry was changed');
      }
      prev = e.hash;
    }
    return AuditVerification.ok(list.length);
  }
}

/// Action names used in the audit log. Keep them stable: auditors read them.
abstract final class AuditAction {
  static const deviceSetup = 'device.setup';
  static const electionCreated = 'election.created';
  static const electionUpdated = 'election.updated';
  static const schoolConsentRecorded = 'election.school_consent';
  static const feeConfigured = 'fee.configured';
  static const positionSaved = 'ballot.position_saved';
  static const candidateSaved = 'ballot.candidate_saved';
  static const ballotSigned = 'ballot.signed';
  static const voterRegistered = 'voter.registered';
  static const voterImported = 'voter.imported';
  static const voterCardPrinted = 'voter.card_printed';
  static const voterCardReplaced = 'voter.card_replaced';
  static const objectionRaised = 'objection.raised';
  static const objectionDecided = 'objection.decided';
  static const registerLocked = 'register.locked';
  static const deviceEnrolled = 'device.enrolled';
  static const pollsOpened = 'polls.opened';
  static const checkinHourlyCount = 'checkin.hourly_count';
  static const manualCheckin = 'checkin.manual';
  static const tokenPoolFallback = 'token.pool_fallback';
  static const pollsClosed = 'polls.closed';
  static const batchExported = 'votes.batch_exported';
  static const batchImported = 'votes.batch_imported';
  static const resultsSigned = 'results.signed';
  static const paperCountEntered = 'results.paper_count';
  static const resultsExported = 'results.exported';
}

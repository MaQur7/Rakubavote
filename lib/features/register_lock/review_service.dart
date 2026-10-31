import 'package:drift/drift.dart';

import '../../core/audit/audit_log.dart';
import '../../core/crypto/bytes.dart';
import '../../core/crypto/device_keys.dart';
import '../../core/crypto/signed_artifact.dart';
import '../../core/db/registry_db.dart';
import '../../core/domain/election_state.dart';
import '../../core/domain/register_snapshot.dart';
import '../registration/duplicates.dart';
import '../registration/registration_service.dart';

enum ObjectionKind { duplicate, missing, other }

/// Decisions per kind:
/// - duplicate: keepBoth, remove (removes the subject voter)
/// - missing: add (registers the claimant), reject
/// - other: upheld, rejected (recorded only; any correction is made separately)
enum ObjectionDecision { keepBoth, remove, add, reject, upheld, rejected }

extension ObjectionDecisionWire on ObjectionDecision {
  String get wire => switch (this) {
        ObjectionDecision.keepBoth => 'keep_both',
        ObjectionDecision.remove => 'remove',
        ObjectionDecision.add => 'add',
        ObjectionDecision.reject => 'reject',
        ObjectionDecision.upheld => 'upheld',
        ObjectionDecision.rejected => 'rejected',
      };
  static ObjectionDecision? parse(String? s) {
    for (final d in ObjectionDecision.values) {
      if (d.wire == s) return d;
    }
    return null;
  }
}

enum ReviewFailure {
  noElection,
  registerLocked,
  openObjections,
  ballotNotSigned,
  emptyRegister,
  voterNotFound,
  decisionNotAllowed,
  alreadyDecided,
  invalidDates,
}

class ReviewException implements Exception {
  ReviewException(this.failure, [this.detail = '']);
  final ReviewFailure failure;
  final String detail;
  @override
  String toString() => 'ReviewException(${failure.name}: $detail)';
}

class DuplicatePair {
  const DuplicatePair(this.a, this.b, this.reason);
  final Voter a;
  final Voter b;
  final DuplicateReason reason;
}

/// An objection with the voter numbers it refers to, for display.
class ObjectionView {
  const ObjectionView(this.objection, this.subjectVoterNo, this.otherVoterNo);
  final Objection objection;
  final int? subjectVoterNo;
  final int? otherVoterNo;
}

/// Result of checking the locked register against its signature and the
/// current database.
enum RegisterCheck { notLocked, valid, badSignature, changedSinceLock }

/// Phase 3: public review, objections and locking the register (mockup C).
class ReviewService {
  ReviewService(this.db, this.stationKeys, {AuditLogService? audit, DateTime Function()? clock})
      : audit = audit ?? AuditLogService(db, clock: clock),
        _clock = clock ?? DateTime.now;

  final RegistryDb db;
  final DeviceKeys stationKeys;
  final AuditLogService audit;
  final DateTime Function() _clock;

  String _today() {
    final d = _clock();
    return '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }

  Future<Election> _election(String id) async {
    final e = await (db.select(db.elections)..where((x) => x.id.equals(id))).getSingleOrNull();
    if (e == null) throw ReviewException(ReviewFailure.noElection);
    return e;
  }

  Future<void> _ensureNotLocked(String electionId) async {
    final e = await _election(electionId);
    if (ElectionState.fromWire(e.state).index >= ElectionState.locked.index) {
      throw ReviewException(ReviewFailure.registerLocked);
    }
  }

  Future<Voter?> voterByNumber(String electionId, int voterNo) =>
      (db.select(db.voters)..where((v) => v.electionId.equals(electionId) & v.voterNo.equals(voterNo)))
          .getSingleOrNull();

  /// Sets the public display period and moves the election into review.
  Future<void> setDisplayPeriod(String electionId,
      {required DateTime start, required DateTime end, required String official}) async {
    await _ensureNotLocked(electionId);
    if (end.isBefore(start)) throw ReviewException(ReviewFailure.invalidDates);
    final e = await _election(electionId);
    await (db.update(db.elections)..where((x) => x.id.equals(electionId))).write(ElectionsCompanion(
      reviewStart: Value(start),
      reviewEnd: Value(end),
      state: ElectionState.fromWire(e.state).index < ElectionState.review.index
          ? Value(ElectionState.review.name)
          : const Value.absent(),
    ));
    await audit.append(actor: official, action: AuditAction.electionUpdated, payload: {
      'electionId': electionId,
      'reviewStart': _date(start),
      'reviewEnd': _date(end),
    });
  }

  static String _date(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  // ---- Objections ----

  Stream<List<Objection>> watchObjections(String electionId) => (db.select(db.objections)
        ..where((o) => o.electionId.equals(electionId))
        ..orderBy([
          (o) => OrderingTerm(expression: o.decision.isNull(), mode: OrderingMode.desc),
          (o) => OrderingTerm.asc(o.raisedOn),
        ]))
      .watch();

  /// Objections (open first) with their voter numbers, updated live.
  Stream<List<ObjectionView>> watchObjectionViews(String electionId) => db
      .customSelect(
        'SELECT o.*, s.voter_no AS subject_no, x.voter_no AS other_no FROM objections o '
        'LEFT JOIN voters s ON s.id = o.subject_voter_id '
        'LEFT JOIN voters x ON x.id = o.other_voter_id '
        'WHERE o.election_id = ? ORDER BY (o.decision IS NULL) DESC, o.raised_on, o.id',
        variables: [Variable.withString(electionId)],
        readsFrom: {db.objections, db.voters},
      )
      .watch()
      .map((rows) => [
            for (final r in rows)
              ObjectionView(db.objections.map(r.data), r.readNullable<int>('subject_no'),
                  r.readNullable<int>('other_no')),
          ]);

  Future<int> openObjectionCount(String electionId) async {
    final r = await db.customSelect(
        'SELECT COUNT(*) AS n FROM objections WHERE election_id = ? AND decision IS NULL',
        variables: [Variable.withString(electionId)]).getSingle();
    return r.read<int>('n');
  }

  Stream<int> watchOpenObjectionCount(String electionId) => db
      .customSelect('SELECT COUNT(*) AS n FROM objections WHERE election_id = ? AND decision IS NULL',
          variables: [Variable.withString(electionId)], readsFrom: {db.objections})
      .watchSingle()
      .map((r) => r.read<int>('n'));

  Future<String> raiseObjection(
    String electionId, {
    required ObjectionKind kind,
    required String raisedByName,
    int? subjectVoterNo,
    int? otherVoterNo,
    String? claimantName,
    String detail = '',
    required String official,
  }) async {
    await _ensureNotLocked(electionId);
    Future<String?> idFor(int? n) async {
      if (n == null) return null;
      final v = await voterByNumber(electionId, n);
      if (v == null || v.status != 'active') throw ReviewException(ReviewFailure.voterNotFound, '$n');
      return v.id;
    }

    final subject = await idFor(subjectVoterNo);
    final other = await idFor(otherVoterNo);
    if (kind == ObjectionKind.duplicate && (subject == null || other == null || subject == other)) {
      throw ReviewException(ReviewFailure.voterNotFound);
    }
    if (kind == ObjectionKind.missing && (claimantName ?? '').trim().isEmpty) {
      throw ReviewException(ReviewFailure.voterNotFound, 'claimant');
    }
    if (kind == ObjectionKind.other && subject == null) {
      throw ReviewException(ReviewFailure.voterNotFound);
    }
    final id = randomId();
    await db.into(db.objections).insert(ObjectionsCompanion.insert(
          id: id,
          electionId: electionId,
          kind: kind.name,
          subjectVoterId: Value(subject),
          otherVoterId: Value(other),
          claimantName: Value(claimantName?.trim()),
          raisedByName: raisedByName.trim().isEmpty ? official : raisedByName.trim(),
          detail: Value(detail.trim()),
          raisedOn: _today(),
        ));
    // Names stay out of the audit log: kind and voter numbers only.
    await audit.append(actor: official, action: AuditAction.objectionRaised, payload: {
      'objection': id,
      'kind': kind.name,
      'subjectVoterNo': ?subjectVoterNo,
      'otherVoterNo': ?otherVoterNo,
    });
    return id;
  }

  static const _allowed = {
    ObjectionKind.duplicate: {ObjectionDecision.keepBoth, ObjectionDecision.remove},
    ObjectionKind.missing: {ObjectionDecision.add, ObjectionDecision.reject},
    ObjectionKind.other: {ObjectionDecision.upheld, ObjectionDecision.rejected},
  };

  /// Records the decision and applies it. For [ObjectionDecision.add],
  /// [newVoter] holds the claimant's details; returns the new voter number.
  Future<int?> decide(String objectionId, ObjectionDecision decision,
      {required String official, VoterInput? newVoter}) async {
    final o = await (db.select(db.objections)..where((x) => x.id.equals(objectionId))).getSingle();
    await _ensureNotLocked(o.electionId);
    if (o.decision != null) throw ReviewException(ReviewFailure.alreadyDecided);
    final kind = ObjectionKind.values.byName(o.kind);
    if (!_allowed[kind]!.contains(decision)) throw ReviewException(ReviewFailure.decisionNotAllowed);

    int? affectedNo;
    await db.transaction(() async {
      if (decision == ObjectionDecision.remove) {
        final v = await (db.select(db.voters)..where((x) => x.id.equals(o.subjectVoterId!))).getSingle();
        await (db.update(db.voters)..where((x) => x.id.equals(v.id)))
            .write(const VotersCompanion(status: Value('removed')));
        affectedNo = v.voterNo;
      } else if (decision == ObjectionDecision.add) {
        final input = newVoter ?? VoterInput(fullName: o.claimantName ?? '');
        final r = await RegistrationService(db, audit: audit, clock: _clock)
            .register(o.electionId, input, official: official);
        affectedNo = r.voterNo;
      }
      await (db.update(db.objections)..where((x) => x.id.equals(objectionId))).write(ObjectionsCompanion(
        decision: Value(decision.wire),
        decidedBy: Value(official),
        decidedOn: Value(_today()),
      ));
      await audit.append(actor: official, action: AuditAction.objectionDecided, payload: {
        'objection': objectionId,
        'kind': kind.name,
        'decision': decision.wire,
        'voterNo': ?affectedNo,
      });
    });
    return affectedNo;
  }

  /// Pairs of active voters that look like duplicates, for officials to
  /// raise as objections. Nothing is changed automatically.
  Future<List<DuplicatePair>> possibleDuplicatePairs(String electionId) async {
    final voters = await (db.select(db.voters)
          ..where((v) => v.electionId.equals(electionId) & v.status.equals('active'))
          ..orderBy([(v) => OrderingTerm.asc(v.voterNo)]))
        .get();
    final pairs = <DuplicatePair>[];
    for (var i = 0; i < voters.length; i++) {
      for (var j = i + 1; j < voters.length; j++) {
        final a = voters[i], b = voters[j];
        final idA = a.memberId.trim().toLowerCase();
        if (idA.isNotEmpty && idA == b.memberId.trim().toLowerCase()) {
          pairs.add(DuplicatePair(a, b, DuplicateReason.sameMemberId));
        } else if (a.groupName.trim().toLowerCase() == b.groupName.trim().toLowerCase() &&
            similarNames(a.fullName, b.fullName)) {
          pairs.add(DuplicatePair(a, b, DuplicateReason.similarNameSameGroup));
        }
      }
    }
    return pairs;
  }

  // ---- Lock ----

  Future<RegisterSnapshot> buildSnapshot(String electionId, String ballotHash) async {
    final voters = await (db.select(db.voters)
          ..where((v) => v.electionId.equals(electionId) & v.status.equals('active')))
        .get();
    return RegisterSnapshot(electionId: electionId, ballotHash: ballotHash, entries: [
      for (final v in voters)
        RegisterEntry(
          voterNo: v.voterNo,
          fullName: v.fullName,
          memberId: v.memberId,
          groupName: v.groupName,
          cardIssue: v.cardIssue,
          photoSha256: RegisterEntry.photoHash(v.photo),
        ),
    ]);
  }

  /// Locks and signs the register. Afterwards no names can be added, changed
  /// or removed (the database enforces this), and the ballot is frozen.
  Future<SignedArtifact> lockRegister(String electionId, {required String official}) async {
    final e = await _election(electionId);
    await _ensureNotLocked(electionId);
    if (await openObjectionCount(electionId) > 0) throw ReviewException(ReviewFailure.openObjections);
    if (e.signedBallot == null) throw ReviewException(ReviewFailure.ballotNotSigned);
    final ballot = SignedArtifact.parse(e.signedBallot);
    final snapshot = await buildSnapshot(electionId, ballot.hashHex);
    if (snapshot.entries.isEmpty) throw ReviewException(ReviewFailure.emptyRegister);
    final signed = await SignedArtifact.sign(ArtifactKind.register, snapshot.toJson(), stationKeys);
    await db.transaction(() async {
      await db.into(db.registerLocks).insert(RegisterLocksCompanion.insert(
            electionId: electionId,
            signedRegister: signed.encode(),
            fingerprint: signed.fingerprint,
            lockedBy: official,
            lockedAt: _clock().toUtc(),
          ));
      await (db.update(db.elections)..where((x) => x.id.equals(electionId)))
          .write(ElectionsCompanion(state: Value(ElectionState.locked.name)));
      await audit.append(actor: official, action: AuditAction.registerLocked, payload: {
        'electionId': electionId,
        'voters': snapshot.entries.length,
        'registerHash': signed.hashHex,
        'fingerprint': signed.fingerprint,
        'ballotHash': ballot.hashHex,
      });
    });
    return signed;
  }

  Future<RegisterLock?> lockRecord(String electionId) =>
      (db.select(db.registerLocks)..where((l) => l.electionId.equals(electionId))).getSingleOrNull();

  Stream<RegisterLock?> watchLock(String electionId) =>
      (db.select(db.registerLocks)..where((l) => l.electionId.equals(electionId))).watchSingleOrNull();

  /// Checks the stored signed register and that the database still matches it.
  Future<RegisterCheck> checkLockedRegister(String electionId) async {
    final lock = await lockRecord(electionId);
    if (lock == null) return RegisterCheck.notLocked;
    final SignedArtifact signed;
    try {
      signed = await SignedArtifact.parseAndVerify(lock.signedRegister,
          expectedKind: ArtifactKind.register, trustedSigners: [stationKeys.signingPublic]);
    } on ArtifactVerificationException {
      return RegisterCheck.badSignature;
    }
    final stored = RegisterSnapshot.fromJson(signed.payload);
    final current = await buildSnapshot(electionId, stored.ballotHash);
    // Card issue may change after locking (reprints); everything else must match.
    List<Map<String, Object?>> comparable(RegisterSnapshot s) =>
        [for (final e in s.entries) e.toJson()..remove('issue')];
    final same = _deepEquals(comparable(stored), comparable(current));
    return same ? RegisterCheck.valid : RegisterCheck.changedSinceLock;
  }

  static bool _deepEquals(List<Map<String, Object?>> a, List<Map<String, Object?>> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i].length != b[i].length) return false;
      for (final k in a[i].keys) {
        if (a[i][k] != b[i][k]) return false;
      }
    }
    return true;
  }
}

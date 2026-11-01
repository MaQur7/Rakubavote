import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';

import '../../core/audit/audit_log.dart';
import '../../core/counting/combine.dart';
import '../../core/counting/reconciliation.dart';
import '../../core/counting/tally.dart';
import '../../core/crypto/device_keys.dart';
import '../../core/crypto/signed_artifact.dart';
import '../../core/db/ballot_box_db.dart';
import '../../core/db/registry_db.dart';
import '../../core/domain/ballot_definition.dart';
import '../../core/domain/election_state.dart';
import '../../core/domain/vote_batch.dart';
import '../../station/enrollment.dart';
import '../checkin/checkin_service.dart';

enum ResultsFailure { noElection, pollsNotOpen, pollsNotClosed, unknownBooth, badBatch, otherElection, olderBatch }

class ResultsException implements Exception {
  ResultsException(this.failure, [this.detail = '']);
  final ResultsFailure failure;
  final String detail;
  @override
  String toString() => 'ResultsException(${failure.name}: $detail)';
}

class BoothBatchStatus {
  const BoothBatchStatus(this.booth, this.ballots, this.batchSeq);
  final DeviceEnrollment booth;
  /// Null until a batch from this booth has been received.
  final int? ballots;
  final int? batchSeq;
  bool get received => ballots != null;
}

/// Everything shown on the results screen, read back from the signed file.
class ResultsView {
  ResultsView(this.signed) : payload = signed.payload;
  final SignedArtifact signed;
  final Map<String, Object?> payload;

  List<Map<String, Object?>> get positions =>
      [for (final p in payload['positions'] as List) (p as Map).cast<String, Object?>()];
  Map<String, Object?> get reconciliation => (payload['reconciliation'] as Map).cast<String, Object?>();
  Map<String, Object?> get integrity => (payload['integrity'] as Map).cast<String, Object?>();
  bool get checkInsMatchVotes => reconciliation['match'] == true;
  bool get clean => integrity.values.every((v) => v == 0);
}

/// Closing the polls, collecting signed vote batches and counting (mockup D).
/// Votes stay in the laptop's ballot box database; only the signed totals are
/// written to the registry.
class ResultsService {
  ResultsService(this.registry, this.ballotBox, this.stationKeys, {AuditLogService? audit, DateTime Function()? clock})
      : audit = audit ?? AuditLogService(registry, clock: clock),
        enrollment = EnrollmentService(registry, clock: clock),
        _clock = clock;

  final RegistryDb registry;
  final BallotBoxDb ballotBox;
  final DeviceKeys stationKeys;
  final AuditLogService audit;
  final EnrollmentService enrollment;
  final DateTime Function()? _clock;

  Future<Election> _election() async {
    final e = await (registry.select(registry.elections)..limit(1)).getSingleOrNull();
    if (e == null) throw ResultsException(ResultsFailure.noElection);
    return e;
  }

  /// Closes the polls: no more check-ins; booths stop and send their votes.
  Future<void> closePolls({required String official}) async {
    final e = await _election();
    if (e.state == ElectionState.closed.name) return;
    if (e.state != ElectionState.polling.name) throw ResultsException(ResultsFailure.pollsNotOpen);
    await CheckInService(registry, stationKeys, audit: audit, clock: _clock).flushHourlyCounts(official: official);
    await (registry.update(registry.elections)..where((x) => x.id.equals(e.id)))
        .write(ElectionsCompanion(state: Value(ElectionState.closed.name)));
    await audit.append(actor: official, action: AuditAction.pollsClosed, payload: {'electionId': e.id});
  }

  /// Verifies and stores a booth's signed batch (from Wi-Fi or USB). A later
  /// batch from the same booth replaces the earlier one (D12).
  Future<VoteBatch> importBatch(String signedJson, {required String official}) async {
    final e = await _election();
    final SignedArtifact artifact;
    try {
      artifact = SignedArtifact.parse(signedJson);
    } on ArtifactVerificationException {
      throw ResultsException(ResultsFailure.badBatch);
    }
    final booth = await enrollment.byId(artifact.signerDeviceId);
    if (booth == null || booth.role != DeviceRole.booth.name) throw ResultsException(ResultsFailure.unknownBooth);
    final VoteBatch batch;
    try {
      batch = await VoteBatch.verifySigned(artifact, electionId: e.id, enrolledBoothKeys: [booth.signingPublic]);
    } on ArtifactVerificationException catch (x) {
      throw ResultsException(
          x.failure == VerificationFailure.wrongKind ? ResultsFailure.otherElection : ResultsFailure.badBatch);
    }
    final existing = await (ballotBox.select(ballotBox.importedBatches)..where((b) => b.boothId.equals(booth.deviceId)))
        .getSingleOrNull();
    if (existing != null && existing.batchSeq > batch.batchSeq) throw ResultsException(ResultsFailure.olderBatch);
    await ballotBox.into(ballotBox.importedBatches).insertOnConflictUpdate(ImportedBatchesCompanion.insert(
          boothId: booth.deviceId,
          batchSeq: batch.batchSeq,
          ballotCount: batch.ballotCount,
          signedBatch: artifact.encode(),
        ));
    await audit.append(actor: official, action: AuditAction.batchImported, payload: {
      'booth': booth.deviceId,
      'seq': batch.batchSeq,
      'ballots': batch.ballotCount,
      'hash': artifact.hashHex,
    });
    return batch;
  }

  Future<List<BoothBatchStatus>> batchStatus() async {
    final booths = await enrollment.active(role: DeviceRole.booth);
    final batches = {for (final b in await ballotBox.select(ballotBox.importedBatches).get()) b.boothId: b};
    return [
      for (final b in booths)
        BoothBatchStatus(b, batches[b.deviceId]?.ballotCount, batches[b.deviceId]?.batchSeq),
    ];
  }

  /// "Show results": verifies every batch again, counts, reconciles and signs.
  /// Can be repeated if a late batch arrives; each run is in the audit log.
  Future<SignedArtifact> computeResults({required String official}) async {
    final e = await _election();
    if (e.state != ElectionState.closed.name) throw ResultsException(ResultsFailure.pollsNotClosed);
    final ballotArtifact = SignedArtifact.parse(e.signedBallot);
    final ballot = BallotDefinition.fromJson(ballotArtifact.payload);
    final lock = await (registry.select(registry.registerLocks)..where((l) => l.electionId.equals(e.id))).getSingle();

    final batches = <VoteBatch>[];
    final batchInfo = <Map<String, Object?>>[];
    for (final row in await ballotBox.select(ballotBox.importedBatches).get()) {
      final booth = await enrollment.byId(row.boothId);
      if (booth == null) continue; // revoked booths are not counted
      final a = SignedArtifact.parse(row.signedBatch);
      batches.add(await VoteBatch.verifySigned(a, electionId: e.id, enrolledBoothKeys: [booth.signingPublic]));
      batchInfo.add({'booth': row.boothId, 'seq': row.batchSeq, 'ballots': row.ballotCount, 'hash': a.hashHex});
    }
    batchInfo.sort((a, b) => (a['booth'] as String).compareTo(b['booth'] as String));

    final issued = {for (final t in await registry.select(registry.issuedTokens).get()) t.tokenHash};
    final combined = combineBatches(batches, issuedTokenHashes: issued);
    final result = tally(ballot, combined.rows);

    Future<int> count(String sql) async =>
        (await registry.customSelect(sql, variables: [Variable.withString(e.id)]).getSingle()).read<int>('n');
    final rec = Reconciliation(
      registered: await count("SELECT COUNT(*) AS n FROM voters WHERE election_id = ? AND status = 'active'"),
      checkedIn: await count('SELECT COUNT(*) AS n FROM check_ins WHERE election_id = ?'),
      manualCheckIns: await count("SELECT COUNT(*) AS n FROM check_ins WHERE election_id = ? AND method = 'manual'"),
      tokensIssued: issued.length,
      tokensUsed: combined.tokensUsed,
      ballots: result.ballotCount,
    );

    final payload = <String, Object?>{
      'electionId': e.id,
      'orgName': e.orgName,
      'electionName': e.name,
      'year': e.year,
      'stationName': e.stationName,
      'ballotHash': ballotArtifact.hashHex,
      'registerFingerprint': lock.fingerprint,
      'positions': [
        for (final p in result.positions)
          {
            'id': p.position.id,
            'titles': p.position.titles,
            'colour': p.position.colour,
            'chooseN': p.position.chooseN,
            'ballots': p.ballots,
            'noChoice': p.noChoice,
            'invalid': p.invalid,
            'candidates': [
              for (final c in p.counts) {'id': c.candidate.id, 'number': c.candidate.number, 'name': c.candidate.name, 'votes': c.votes},
            ],
            'tie': [for (final c in p.tiedAtCutoff) c.id],
          },
      ],
      'reconciliation': rec.toJson(),
      'integrity': {
        'codesUsedAtTwoBooths': combined.codesUsedAtTwoBooths,
        'codesNeverIssued': combined.codesNeverIssued,
        'duplicateBallotIds': combined.duplicateBallotIds,
        'incompleteBallots': result.incompleteBallots,
        'unknownPositionRows': result.unknownPositionRows,
      },
      'batches': batchInfo,
      'auditHead': await audit.headHash(),
    };
    final signed = await SignedArtifact.sign(ArtifactKind.results, payload, stationKeys);
    await registry.into(registry.resultRecords).insertOnConflictUpdate(ResultRecordsCompanion.insert(
        electionId: e.id, signedResults: signed.encode(), fingerprint: signed.fingerprint));
    await audit.append(actor: official, action: AuditAction.resultsSigned, payload: {
      'electionId': e.id,
      'ballots': result.ballotCount,
      'hash': signed.hashHex,
      'fingerprint': signed.fingerprint,
    });
    return signed;
  }

  Future<ResultsView?> currentResults() async {
    final e = await _election();
    final r = await (registry.select(registry.resultRecords)..where((x) => x.electionId.equals(e.id))).getSingleOrNull();
    if (r == null) return null;
    final a = await SignedArtifact.parseAndVerify(r.signedResults,
        expectedKind: ArtifactKind.results, trustedSigners: [stationKeys.signingPublic]);
    return ResultsView(a);
  }

  /// Small signed summary for the results QR code: counts per position in
  /// candidate-number order, bound to the full results by hash.
  Future<SignedArtifact> qrSummary(SignedArtifact full) {
    final v = ResultsView(full);
    return SignedArtifact.sign(ArtifactKind.resultsSummary, {
      'e': v.payload['electionId'],
      'r': full.hashHex,
      'b': (v.reconciliation['ballots']),
      'p': [
        for (final p in v.positions)
          [p['noChoice'], p['invalid'], [for (final c in p['candidates'] as List) (c as Map)['votes']]],
      ],
    }, stationKeys);
  }

  Future<File> exportResults(SignedArtifact full, Directory dir, {required String official}) async {
    final f = File('${dir.path}/rakubavote-results-${full.fingerprint}.json');
    await f.writeAsString(const JsonEncoder.withIndent('  ').convert(full.toJson()), flush: true);
    await audit.append(actor: official, action: AuditAction.resultsExported, payload: {'fingerprint': full.fingerprint});
    return f;
  }
}

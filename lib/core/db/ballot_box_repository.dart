import 'dart:convert';

import 'package:drift/drift.dart';

import '../audit/audit_log.dart';
import '../counting/tally.dart';
import '../crypto/bytes.dart';
import '../crypto/device_keys.dart';
import '../crypto/signed_artifact.dart';
import '../domain/ballot_definition.dart';
import '../domain/vote.dart';
import '../domain/vote_batch.dart';
import 'ballot_box_db.dart';

enum CastFailure { ballotNotLoaded, codeNotActive, codeAlreadyUsed, invalidSelection, otherStation, votesExist }

class CastBallotException implements Exception {
  CastBallotException(this.failure, [this.detail = '']);
  final CastFailure failure;
  final String detail;
  @override
  String toString() => 'CastBallotException(${failure.name}: $detail)';
}

/// The only code path that writes votes. It stores the random ballot id,
/// positions, choices and signatures, and nothing else: no token, no time,
/// no counter. The used code goes to a separate table with no link.
class BallotBoxRepository {
  BallotBoxRepository(this.db, this.boothKeys, {AuditLogService? audit})
      : audit = audit ?? AuditLogService(db);

  final BallotBoxDb db;
  final DeviceKeys boothKeys;
  final AuditLogService audit;

  BallotDefinition? _ballot;
  BallotDefinition? get ballot => _ballot;

  /// The pinned station key, or null before the first ballot is loaded.
  Future<Uint8List?> pinnedStationKey() async =>
      (await (db.select(db.ballotDefinitions)..limit(1)).getSingleOrNull())?.stationPublicKey;

  /// Verifies and stores the signed ballot and its images. The first load
  /// pins the station key; later loads must come from the same laptop, and
  /// a different ballot cannot replace one that already has votes.
  Future<BallotDefinition> loadBallot(String signedBallotJson,
      {required List<int> stationPublicKey, Map<String, Uint8List> media = const {}}) async {
    final pinned = await pinnedStationKey();
    if (pinned != null && !constantTimeEquals(pinned, stationPublicKey)) {
      throw CastBallotException(CastFailure.otherStation);
    }
    final a = await SignedArtifact.parseAndVerify(signedBallotJson,
        expectedKind: ArtifactKind.ballot, trustedSigners: [stationPublicKey]);
    final def = BallotDefinition.fromJson(a.payload);
    final existing = await (db.select(db.ballotDefinitions)..limit(1)).getSingleOrNull();
    if (existing != null && await ballotCount() > 0) {
      final same = SignedArtifact.parse(existing.signedBallot).hashHex == a.hashHex;
      if (!same) throw CastBallotException(CastFailure.votesExist);
    }
    await db.transaction(() async {
      await db.delete(db.ballotDefinitions).go();
      await db.into(db.ballotDefinitions).insert(BallotDefinitionsCompanion.insert(
          electionId: def.electionId,
          signedBallot: a.encode(),
          stationPublicKey: Uint8List.fromList(stationPublicKey)));
      for (final e in media.entries) {
        await db.into(db.ballotMedia).insertOnConflictUpdate(
            BallotMediaCompanion.insert(sha256: e.key, bytes: e.value));
      }
    });
    await audit.append(
        actor: 'booth ${boothKeys.deviceId}',
        action: 'ballot.loaded',
        payload: {'ballotHash': a.hashHex, 'fingerprint': a.fingerprint});
    return _ballot = def;
  }

  /// Re-opens the stored ballot after a restart, checking it again.
  Future<BallotDefinition?> restoreBallot() async {
    final row = await (db.select(db.ballotDefinitions)..limit(1)).getSingleOrNull();
    if (row == null) return null;
    final a = await SignedArtifact.parseAndVerify(row.signedBallot,
        expectedKind: ArtifactKind.ballot, trustedSigners: [row.stationPublicKey]);
    return _ballot = BallotDefinition.fromJson(a.payload);
  }

  Future<SignedArtifact?> signedBallot() async {
    final row = await (db.select(db.ballotDefinitions)..limit(1)).getSingleOrNull();
    return row == null ? null : SignedArtifact.parse(row.signedBallot);
  }

  /// Image bytes by hash (candidate photo, symbol or logo).
  Future<Map<String, Uint8List>> media(Iterable<String> hashes) async {
    final list = hashes.toList();
    if (list.isEmpty) return const {};
    final rows = await (db.select(db.ballotMedia)..where((m) => m.sha256.isIn(list))).get();
    return {for (final r in rows) r.sha256: r.bytes};
  }

  Future<void> activateToken(String tokenHash) async {
    final used = await (db.select(db.usedTokens)..where((t) => t.tokenHash.equals(tokenHash)))
        .getSingleOrNull();
    if (used != null) return;
    await db.into(db.activeTokens).insertOnConflictUpdate(ActiveTokensCompanion.insert(tokenHash: tokenHash));
  }

  /// A code used at another booth: it is no longer accepted here.
  /// (used_tokens only lists codes used at this booth, so each booth's count
  /// matches its own ballots.)
  Future<void> markUsedElsewhere(String tokenHash) =>
      (db.delete(db.activeTokens)..where((t) => t.tokenHash.equals(tokenHash))).go();

  /// Checks a code before the voter starts. Does not use it up.
  Future<CastFailure?> checkToken(String tokenHash) async {
    final used = await (db.select(db.usedTokens)..where((t) => t.tokenHash.equals(tokenHash)))
        .getSingleOrNull();
    if (used != null) return CastFailure.codeAlreadyUsed;
    final active = await (db.select(db.activeTokens)..where((t) => t.tokenHash.equals(tokenHash)))
        .getSingleOrNull();
    return active == null ? CastFailure.codeNotActive : null;
  }

  /// Records one ballot. [selections] maps position id to chosen candidate
  /// ids, or to `[noChoice]`. Returns the random ballot id for the receipt.
  Future<String> castBallot({
    required String tokenHash,
    required Map<String, List<String>> selections,
  }) async {
    final def = _ballot;
    if (def == null) throw CastBallotException(CastFailure.ballotNotLoaded);

    // Validate before touching the database.
    for (final p in def.positions) {
      final c = selections[p.id];
      if (c == null) throw CastBallotException(CastFailure.invalidSelection, 'missing ${p.id}');
      final probe = VoteRow(
          ballotId: '', positionId: p.id, choices: VoteRow.normaliseChoices(c), signature: '');
      if (!isValidChoice(p, probe)) {
        throw CastBallotException(CastFailure.invalidSelection, p.id);
      }
    }
    if (selections.keys.any((k) => def.positionById(k) == null)) {
      throw CastBallotException(CastFailure.invalidSelection, 'unknown position');
    }

    final ballotId = randomId();
    final rows = [
      for (final p in def.positions)
        await VoteRow.create(
          electionId: def.electionId,
          ballotId: ballotId,
          positionId: p.id,
          choices: selections[p.id]!,
          boothKeys: boothKeys,
        ),
    ];

    await db.transaction(() async {
      final problem = await checkToken(tokenHash);
      if (problem != null) throw CastBallotException(problem);
      await (db.delete(db.activeTokens)..where((t) => t.tokenHash.equals(tokenHash))).go();
      await db.into(db.usedTokens).insert(UsedTokensCompanion.insert(tokenHash: tokenHash));
      for (final r in rows) {
        await db.into(db.votes).insert(VotesCompanion.insert(
              ballotId: r.ballotId,
              positionId: r.positionId,
              choice: jsonEncode(r.choices),
              signature: r.signature,
            ));
      }
    });
    return ballotId;
  }

  Future<List<VoteRow>> allVotes() async {
    final rows = await db.select(db.votes).get();
    return [
      for (final r in rows)
        VoteRow(
          ballotId: r.ballotId,
          positionId: r.positionId,
          choices: (jsonDecode(r.choice) as List).cast<String>(),
          signature: r.signature,
        ),
    ];
  }

  Future<int> ballotCount() async {
    final r = await db.customSelect('SELECT COUNT(DISTINCT ballot_id) AS n FROM votes').getSingle();
    return r.read<int>('n');
  }

  Future<int> usedTokenCount() async {
    final r = await db.customSelect('SELECT COUNT(*) AS n FROM used_tokens').getSingle();
    return r.read<int>('n');
  }

  /// Signs all votes held by this booth as one batch (the complete set, so a
  /// later batch supersedes an earlier one). Audit records counts only.
  Future<SignedArtifact> exportBatch() async {
    final def = _ballot;
    if (def == null) throw CastBallotException(CastFailure.ballotNotLoaded);
    final last = await db
        .customSelect('SELECT MAX(batch_seq) AS s FROM batch_exports')
        .getSingle();
    final seq = (last.readNullable<int>('s') ?? 0) + 1;
    final batch = VoteBatch(
      electionId: def.electionId,
      boothDeviceId: boothKeys.deviceId,
      batchSeq: seq,
      usedTokenHashes: [for (final t in await db.select(db.usedTokens).get()) t.tokenHash],
      rows: await allVotes(),
    );
    final signed = await batch.sign(boothKeys);
    await db.into(db.batchExports).insert(BatchExportsCompanion.insert(
        batchSeq: Value(seq), ballotCount: batch.ballotCount, batchHash: signed.hashHex));
    await audit.append(
        actor: 'booth ${boothKeys.deviceId}',
        action: AuditAction.batchExported,
        payload: {'seq': seq, 'ballots': batch.ballotCount, 'hash': signed.hashHex});
    return signed;
  }
}

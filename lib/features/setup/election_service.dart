import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter/painting.dart' show Color;

import '../../core/audit/audit_log.dart';
import '../../core/crypto/bytes.dart';
import '../../core/crypto/device_keys.dart';
import '../../core/crypto/hashing.dart';
import '../../core/crypto/signed_artifact.dart';
import '../../core/db/registry_db.dart';
import '../../core/domain/ballot_definition.dart';
import '../../core/domain/election_state.dart';
import '../../core/domain/templates.dart';
import '../../core/theme.dart';

/// Why a setup action was refused. Screens turn these into plain words.
enum SetupFailure {
  feeLocked,
  ballotFrozen,
  ballotInvalid,
  duplicateCandidateNumber,
  lowContrastColour,
  invalidValue,
}

class SetupException implements Exception {
  SetupException(this.failure, [this.detail = '']);
  final SetupFailure failure;
  final String detail;
  @override
  String toString() => 'SetupException(${failure.name}: $detail)';
}

enum FeeCurrency { ssp, usd, either }

enum UnpaidPolicy { block, allowFlagged }

extension FeeCurrencyWire on FeeCurrency {
  String get wire => switch (this) { FeeCurrency.ssp => 'SSP', FeeCurrency.usd => 'USD', FeeCurrency.either => 'EITHER' };
  static FeeCurrency parse(String s) =>
      FeeCurrency.values.firstWhere((c) => c.wire == s, orElse: () => FeeCurrency.ssp);
}

extension UnpaidPolicyWire on UnpaidPolicy {
  String get wire => this == UnpaidPolicy.block ? 'block' : 'allow_flagged';
  static UnpaidPolicy parse(String s) => s == 'allow_flagged' ? UnpaidPolicy.allowFlagged : UnpaidPolicy.block;
}

/// Election setup on the station laptop (mockup A). Every change is written
/// to the audit log with the official's name.
class ElectionService {
  ElectionService(this.db, this.stationKeys, {AuditLogService? audit, DateTime Function()? clock})
      : audit = audit ?? AuditLogService(db, clock: clock),
        _clock = clock ?? DateTime.now;

  final RegistryDb db;
  final DeviceKeys stationKeys;
  final AuditLogService audit;
  final DateTime Function() _clock;

  Future<Election?> currentElection() =>
      (db.select(db.elections)..limit(1)).getSingleOrNull();

  Stream<Election?> watchElection() =>
      (db.select(db.elections)..limit(1)).watchSingleOrNull();

  Future<String> createElection({
    required ElectionTemplate template,
    required String orgName,
    required String name,
    required int year,
    required String stationName,
    required List<String> languages,
    required String official,
  }) async {
    final id = randomId();
    await db.transaction(() async {
      await db.into(db.elections).insert(ElectionsCompanion.insert(
            id: id,
            orgName: orgName.trim(),
            name: name.trim(),
            year: year,
            template: template.wire,
            languages: jsonEncode(languages),
            idLabel: template.idLabel,
            groupLabel: template.groupLabel,
            stationName: stationName.trim(),
          ));
      await db.into(db.feeConfigs).insert(FeeConfigsCompanion.insert(electionId: id, enabled: false));
      var order = 1;
      for (final p in template.positions) {
        await db.into(db.positions).insert(PositionsCompanion.insert(
              id: randomId(),
              electionId: id,
              sortOrder: order,
              titles: jsonEncode({'en': p.title}),
              colour: defaultPositionColours[(order - 1) % defaultPositionColours.length].toARGB32(),
              chooseN: Value(p.chooseN),
              allowNoChoice: Value(p.allowNoChoice),
            ));
        order++;
      }
      await audit.append(actor: official, action: AuditAction.electionCreated, payload: {
        'electionId': id,
        'template': template.wire,
        'name': name.trim(),
        'org': orgName.trim(),
      });
    });
    return id;
  }

  Future<void> updateDetails(String electionId,
      {String? orgName, String? name, int? year, String? stationName, List<String>? languages,
      Uint8List? orgLogo, String? idLabel, String? groupLabel, required String official}) async {
    await _ensureBallotEditable(electionId);
    await (db.update(db.elections)..where((e) => e.id.equals(electionId))).write(ElectionsCompanion(
      orgName: orgName == null ? const Value.absent() : Value(orgName.trim()),
      name: name == null ? const Value.absent() : Value(name.trim()),
      year: year == null ? const Value.absent() : Value(year),
      stationName: stationName == null ? const Value.absent() : Value(stationName.trim()),
      languages: languages == null ? const Value.absent() : Value(jsonEncode(languages)),
      orgLogo: orgLogo == null ? const Value.absent() : Value(orgLogo),
      idLabel: idLabel == null ? const Value.absent() : Value(idLabel.trim()),
      groupLabel: groupLabel == null ? const Value.absent() : Value(groupLabel.trim()),
    ));
    await _invalidateSignature(electionId);
    await audit.append(actor: official, action: AuditAction.electionUpdated, payload: {
      'electionId': electionId,
      'fields': [
        if (orgName != null) 'orgName',
        if (name != null) 'name',
        if (year != null) 'year',
        if (stationName != null) 'stationName',
        if (languages != null) 'languages',
        if (orgLogo != null) 'orgLogo',
        if (idLabel != null) 'idLabel',
        if (groupLabel != null) 'groupLabel',
      ],
    });
  }

  /// School elections only: the school's consent for registering minors (D2).
  Future<void> recordSchoolConsent(String electionId, {required String official}) async {
    await (db.update(db.elections)..where((e) => e.id.equals(electionId))).write(ElectionsCompanion(
      schoolConsentRecorded: const Value(true),
      schoolConsentBy: Value(official),
      schoolConsentAt: Value(_clock().toUtc()),
    ));
    await audit.append(
        actor: official, action: AuditAction.schoolConsentRecorded, payload: {'electionId': electionId});
  }

  // ---- Fee ----

  Future<FeeConfig> feeConfig(String electionId) =>
      (db.select(db.feeConfigs)..where((f) => f.electionId.equals(electionId))).getSingle();

  Stream<FeeConfig> watchFeeConfig(String electionId) =>
      (db.select(db.feeConfigs)..where((f) => f.electionId.equals(electionId))).watchSingle();

  Future<bool> feeLocked(String electionId) async {
    final r = await db
        .customSelect('SELECT EXISTS(SELECT 1 FROM voters WHERE election_id = ?) AS x',
            variables: [Variable.withString(electionId)])
        .getSingle();
    return r.read<bool>('x');
  }

  Future<void> setFee(String electionId,
      {required bool enabled,
      required int amount,
      required FeeCurrency currency,
      required UnpaidPolicy unpaidPolicy,
      required String official}) async {
    if (await feeLocked(electionId)) throw SetupException(SetupFailure.feeLocked);
    if (enabled && amount <= 0) throw SetupException(SetupFailure.invalidValue, 'amount');
    await (db.update(db.feeConfigs)..where((f) => f.electionId.equals(electionId))).write(FeeConfigsCompanion(
      enabled: Value(enabled),
      amount: Value(enabled ? amount : 0),
      currency: Value(currency.wire),
      unpaidPolicy: Value(unpaidPolicy.wire),
    ));
    await audit.append(actor: official, action: AuditAction.feeConfigured, payload: {
      'electionId': electionId,
      'enabled': enabled,
      'amount': enabled ? amount : 0,
      'currency': currency.wire,
      'unpaidPolicy': unpaidPolicy.wire,
    });
  }

  // ---- Positions and candidates ----

  Future<List<Position>> positions(String electionId) => (db.select(db.positions)
        ..where((p) => p.electionId.equals(electionId))
        ..orderBy([(p) => OrderingTerm.asc(p.sortOrder)]))
      .get();

  Stream<List<Position>> watchPositions(String electionId) => (db.select(db.positions)
        ..where((p) => p.electionId.equals(electionId))
        ..orderBy([(p) => OrderingTerm.asc(p.sortOrder)]))
      .watch();

  Future<List<Candidate>> candidates(String positionId) => (db.select(db.candidates)
        ..where((c) => c.positionId.equals(positionId))
        ..orderBy([(c) => OrderingTerm.asc(c.number)]))
      .get();

  Stream<List<Candidate>> watchCandidates(String positionId) => (db.select(db.candidates)
        ..where((c) => c.positionId.equals(positionId))
        ..orderBy([(c) => OrderingTerm.asc(c.number)]))
      .watch();

  Future<String> addPosition(String electionId, {required Map<String, String> titles, required String official}) async {
    await _ensureBallotEditable(electionId);
    final existing = await positions(electionId);
    final order = existing.isEmpty ? 1 : existing.last.sortOrder + 1;
    final id = randomId();
    await db.into(db.positions).insert(PositionsCompanion.insert(
          id: id,
          electionId: electionId,
          sortOrder: order,
          titles: jsonEncode(_cleanTitles(titles)),
          colour: _nextColour(existing).toARGB32(),
        ));
    await _afterBallotChange(electionId, official, {'position': id, 'change': 'added'});
    return id;
  }

  Future<void> updatePosition(String positionId,
      {Map<String, String>? titles, int? colour, int? chooseN, bool? allowNoChoice, required String official}) async {
    final p = await (db.select(db.positions)..where((p) => p.id.equals(positionId))).getSingle();
    await _ensureBallotEditable(p.electionId);
    if (colour != null && !meetsTextContrast(RakubaColors.white, _colour(colour), largeText: true)) {
      throw SetupException(SetupFailure.lowContrastColour);
    }
    if (chooseN != null && chooseN < 1) throw SetupException(SetupFailure.invalidValue, 'chooseN');
    await (db.update(db.positions)..where((x) => x.id.equals(positionId))).write(PositionsCompanion(
      titles: titles == null ? const Value.absent() : Value(jsonEncode(_cleanTitles(titles))),
      colour: colour == null ? const Value.absent() : Value(colour),
      chooseN: chooseN == null ? const Value.absent() : Value(chooseN),
      allowNoChoice: allowNoChoice == null ? const Value.absent() : Value(allowNoChoice),
    ));
    await _afterBallotChange(p.electionId, official, {'position': positionId, 'change': 'updated'});
  }

  Future<void> movePosition(String positionId, int delta, {required String official}) async {
    final p = await (db.select(db.positions)..where((p) => p.id.equals(positionId))).getSingle();
    await _ensureBallotEditable(p.electionId);
    final list = await positions(p.electionId);
    final i = list.indexWhere((x) => x.id == positionId);
    final j = i + delta;
    if (j < 0 || j >= list.length) return;
    final other = list[j];
    await db.transaction(() async {
      await (db.update(db.positions)..where((x) => x.id.equals(p.id)))
          .write(PositionsCompanion(sortOrder: Value(other.sortOrder)));
      await (db.update(db.positions)..where((x) => x.id.equals(other.id)))
          .write(PositionsCompanion(sortOrder: Value(p.sortOrder)));
    });
    await _afterBallotChange(p.electionId, official, {'position': positionId, 'change': 'moved'});
  }

  Future<void> deletePosition(String positionId, {required String official}) async {
    final p = await (db.select(db.positions)..where((p) => p.id.equals(positionId))).getSingle();
    await _ensureBallotEditable(p.electionId);
    await db.transaction(() async {
      await (db.delete(db.candidates)..where((c) => c.positionId.equals(positionId))).go();
      await (db.delete(db.positions)..where((x) => x.id.equals(positionId))).go();
    });
    await _afterBallotChange(p.electionId, official, {'position': positionId, 'change': 'deleted'});
  }

  /// Next free candidate number for a position.
  Future<int> nextCandidateNumber(String positionId) async {
    final list = await candidates(positionId);
    return list.isEmpty ? 1 : list.map((c) => c.number).reduce((a, b) => a > b ? a : b) + 1;
  }

  Future<String> saveCandidate({
    String? candidateId,
    required String positionId,
    required int number,
    required String name,
    Uint8List? photo,
    Uint8List? symbol,
    bool clearPhoto = false,
    bool clearSymbol = false,
    required String official,
  }) async {
    final p = await (db.select(db.positions)..where((p) => p.id.equals(positionId))).getSingle();
    await _ensureBallotEditable(p.electionId);
    if (name.trim().isEmpty || number < 1) throw SetupException(SetupFailure.invalidValue);
    final clash = await (db.select(db.candidates)
          ..where((c) => c.positionId.equals(positionId) & c.number.equals(number)))
        .getSingleOrNull();
    if (clash != null && clash.id != candidateId) {
      throw SetupException(SetupFailure.duplicateCandidateNumber);
    }
    final id = candidateId ?? randomId();
    if (candidateId == null) {
      await db.into(db.candidates).insert(CandidatesCompanion.insert(
            id: id,
            positionId: positionId,
            number: number,
            name: name.trim(),
            photo: Value(photo),
            symbol: Value(symbol),
            sortOrder: number,
          ));
    } else {
      await (db.update(db.candidates)..where((c) => c.id.equals(candidateId))).write(CandidatesCompanion(
        number: Value(number),
        sortOrder: Value(number),
        name: Value(name.trim()),
        photo: clearPhoto ? const Value(null) : (photo == null ? const Value.absent() : Value(photo)),
        symbol: clearSymbol ? const Value(null) : (symbol == null ? const Value.absent() : Value(symbol)),
      ));
    }
    await _afterBallotChange(p.electionId, official,
        {'candidate': id, 'position': positionId, 'number': number, 'change': candidateId == null ? 'added' : 'updated'},
        action: AuditAction.candidateSaved);
    return id;
  }

  Future<void> deleteCandidate(String candidateId, {required String official}) async {
    final c = await (db.select(db.candidates)..where((c) => c.id.equals(candidateId))).getSingle();
    final p = await (db.select(db.positions)..where((p) => p.id.equals(c.positionId))).getSingle();
    await _ensureBallotEditable(p.electionId);
    await (db.delete(db.candidates)..where((x) => x.id.equals(candidateId))).go();
    await _afterBallotChange(p.electionId, official, {'candidate': candidateId, 'change': 'deleted'},
        action: AuditAction.candidateSaved);
  }

  // ---- Ballot definition and signing ----

  Future<BallotDefinition> buildBallot(String electionId) async {
    final e = await (db.select(db.elections)..where((x) => x.id.equals(electionId))).getSingle();
    final ps = await positions(electionId);
    return BallotDefinition(
      electionId: e.id,
      orgName: e.orgName,
      electionName: e.name,
      year: e.year,
      stationName: e.stationName,
      orgLogoSha256: e.orgLogo == null ? null : sha256Hex(e.orgLogo!),
      languages: (jsonDecode(e.languages) as List).cast<String>(),
      positions: [
        for (final p in ps)
          PositionDef(
            id: p.id,
            order: p.sortOrder,
            titles: (jsonDecode(p.titles) as Map).cast<String, String>(),
            colour: p.colour,
            chooseN: p.chooseN,
            allowNoChoice: p.allowNoChoice,
            candidates: [
              for (final c in await candidates(p.id))
                CandidateDef(
                  id: c.id,
                  number: c.number,
                  name: c.name,
                  photoSha256: c.photo == null ? null : sha256Hex(c.photo!),
                  symbolSha256: c.symbol == null ? null : sha256Hex(c.symbol!),
                ),
            ],
          ),
      ],
    );
  }

  /// "Save and sign ballot". Returns the signed artifact.
  Future<SignedArtifact> signBallot(String electionId, {required String official}) async {
    await _ensureBallotEditable(electionId);
    final def = await buildBallot(electionId);
    final problems = def.validate();
    if (problems.isNotEmpty) throw SetupException(SetupFailure.ballotInvalid, problems.join(' '));
    final signed = await SignedArtifact.sign(ArtifactKind.ballot, def.toJson(), stationKeys);
    await (db.update(db.elections)..where((e) => e.id.equals(electionId)))
        .write(ElectionsCompanion(signedBallot: Value(signed.encode())));
    await audit.append(actor: official, action: AuditAction.ballotSigned, payload: {
      'electionId': electionId,
      'hash': signed.hashHex,
      'fingerprint': signed.fingerprint,
      'positions': def.positions.length,
    });
    return signed;
  }

  /// Image bytes the signed ballot refers to, keyed by SHA-256, for booths.
  Future<Map<String, Uint8List>> ballotMedia(String electionId) async {
    final e = await (db.select(db.elections)..where((x) => x.id.equals(electionId))).getSingle();
    final out = <String, Uint8List>{};
    void add(Uint8List? b) {
      if (b != null) out[sha256Hex(b)] = b;
    }

    add(e.orgLogo);
    for (final p in await positions(electionId)) {
      for (final c in await candidates(p.id)) {
        add(c.photo);
        add(c.symbol);
      }
    }
    return out;
  }

  Future<SignedArtifact?> signedBallot(String electionId) async {
    final e = await (db.select(db.elections)..where((x) => x.id.equals(electionId))).getSingle();
    return e.signedBallot == null ? null : SignedArtifact.parse(e.signedBallot);
  }

  // ---- helpers ----

  Future<void> _ensureBallotEditable(String electionId) async {
    final e = await (db.select(db.elections)..where((x) => x.id.equals(electionId))).getSingle();
    final state = ElectionState.fromWire(e.state);
    if (state.index >= ElectionState.locked.index) throw SetupException(SetupFailure.ballotFrozen);
  }

  Future<void> _invalidateSignature(String electionId) =>
      (db.update(db.elections)..where((e) => e.id.equals(electionId) & e.signedBallot.isNotNull()))
          .write(const ElectionsCompanion(signedBallot: Value(null)));

  Future<void> _afterBallotChange(String electionId, String official, Map<String, Object?> payload,
      {String action = AuditAction.positionSaved}) async {
    await _invalidateSignature(electionId);
    await audit.append(actor: official, action: action, payload: {'electionId': electionId, ...payload});
  }

  static Map<String, String> _cleanTitles(Map<String, String> titles) => {
        for (final e in titles.entries)
          if (e.value.trim().isNotEmpty) e.key: e.value.trim(),
      };

  static Color _colour(int argb) => Color(argb);

  static Color _nextColour(List<Position> existing) {
    final used = existing.map((p) => p.colour).toSet();
    for (final c in defaultPositionColours) {
      if (!used.contains(c.toARGB32())) return c;
    }
    return defaultPositionColours[existing.length % defaultPositionColours.length];
  }
}

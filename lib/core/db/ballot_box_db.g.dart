// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ballot_box_db.dart';

// ignore_for_file: type=lint
class $BallotDefinitionsTable extends BallotDefinitions
    with TableInfo<$BallotDefinitionsTable, StoredBallot> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BallotDefinitionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _electionIdMeta = const VerificationMeta(
    'electionId',
  );
  @override
  late final GeneratedColumn<String> electionId = GeneratedColumn<String>(
    'election_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _signedBallotMeta = const VerificationMeta(
    'signedBallot',
  );
  @override
  late final GeneratedColumn<String> signedBallot = GeneratedColumn<String>(
    'signed_ballot',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stationPublicKeyMeta = const VerificationMeta(
    'stationPublicKey',
  );
  @override
  late final GeneratedColumn<Uint8List> stationPublicKey =
      GeneratedColumn<Uint8List>(
        'station_public_key',
        aliasedName,
        false,
        type: DriftSqlType.blob,
        requiredDuringInsert: true,
      );
  @override
  List<GeneratedColumn> get $columns => [
    electionId,
    signedBallot,
    stationPublicKey,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ballot_definitions';
  @override
  VerificationContext validateIntegrity(
    Insertable<StoredBallot> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('election_id')) {
      context.handle(
        _electionIdMeta,
        electionId.isAcceptableOrUnknown(data['election_id']!, _electionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_electionIdMeta);
    }
    if (data.containsKey('signed_ballot')) {
      context.handle(
        _signedBallotMeta,
        signedBallot.isAcceptableOrUnknown(
          data['signed_ballot']!,
          _signedBallotMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_signedBallotMeta);
    }
    if (data.containsKey('station_public_key')) {
      context.handle(
        _stationPublicKeyMeta,
        stationPublicKey.isAcceptableOrUnknown(
          data['station_public_key']!,
          _stationPublicKeyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_stationPublicKeyMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {electionId};
  @override
  StoredBallot map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StoredBallot(
      electionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}election_id'],
      )!,
      signedBallot: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}signed_ballot'],
      )!,
      stationPublicKey: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}station_public_key'],
      )!,
    );
  }

  @override
  $BallotDefinitionsTable createAlias(String alias) {
    return $BallotDefinitionsTable(attachedDatabase, alias);
  }
}

class StoredBallot extends DataClass implements Insertable<StoredBallot> {
  final String electionId;
  final String signedBallot;

  /// The station laptop's signing key, pinned when the first ballot is loaded.
  final Uint8List stationPublicKey;
  const StoredBallot({
    required this.electionId,
    required this.signedBallot,
    required this.stationPublicKey,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['election_id'] = Variable<String>(electionId);
    map['signed_ballot'] = Variable<String>(signedBallot);
    map['station_public_key'] = Variable<Uint8List>(stationPublicKey);
    return map;
  }

  BallotDefinitionsCompanion toCompanion(bool nullToAbsent) {
    return BallotDefinitionsCompanion(
      electionId: Value(electionId),
      signedBallot: Value(signedBallot),
      stationPublicKey: Value(stationPublicKey),
    );
  }

  factory StoredBallot.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StoredBallot(
      electionId: serializer.fromJson<String>(json['electionId']),
      signedBallot: serializer.fromJson<String>(json['signedBallot']),
      stationPublicKey: serializer.fromJson<Uint8List>(
        json['stationPublicKey'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'electionId': serializer.toJson<String>(electionId),
      'signedBallot': serializer.toJson<String>(signedBallot),
      'stationPublicKey': serializer.toJson<Uint8List>(stationPublicKey),
    };
  }

  StoredBallot copyWith({
    String? electionId,
    String? signedBallot,
    Uint8List? stationPublicKey,
  }) => StoredBallot(
    electionId: electionId ?? this.electionId,
    signedBallot: signedBallot ?? this.signedBallot,
    stationPublicKey: stationPublicKey ?? this.stationPublicKey,
  );
  StoredBallot copyWithCompanion(BallotDefinitionsCompanion data) {
    return StoredBallot(
      electionId: data.electionId.present
          ? data.electionId.value
          : this.electionId,
      signedBallot: data.signedBallot.present
          ? data.signedBallot.value
          : this.signedBallot,
      stationPublicKey: data.stationPublicKey.present
          ? data.stationPublicKey.value
          : this.stationPublicKey,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StoredBallot(')
          ..write('electionId: $electionId, ')
          ..write('signedBallot: $signedBallot, ')
          ..write('stationPublicKey: $stationPublicKey')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    electionId,
    signedBallot,
    $driftBlobEquality.hash(stationPublicKey),
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StoredBallot &&
          other.electionId == this.electionId &&
          other.signedBallot == this.signedBallot &&
          $driftBlobEquality.equals(
            other.stationPublicKey,
            this.stationPublicKey,
          ));
}

class BallotDefinitionsCompanion extends UpdateCompanion<StoredBallot> {
  final Value<String> electionId;
  final Value<String> signedBallot;
  final Value<Uint8List> stationPublicKey;
  final Value<int> rowid;
  const BallotDefinitionsCompanion({
    this.electionId = const Value.absent(),
    this.signedBallot = const Value.absent(),
    this.stationPublicKey = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BallotDefinitionsCompanion.insert({
    required String electionId,
    required String signedBallot,
    required Uint8List stationPublicKey,
    this.rowid = const Value.absent(),
  }) : electionId = Value(electionId),
       signedBallot = Value(signedBallot),
       stationPublicKey = Value(stationPublicKey);
  static Insertable<StoredBallot> custom({
    Expression<String>? electionId,
    Expression<String>? signedBallot,
    Expression<Uint8List>? stationPublicKey,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (electionId != null) 'election_id': electionId,
      if (signedBallot != null) 'signed_ballot': signedBallot,
      if (stationPublicKey != null) 'station_public_key': stationPublicKey,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BallotDefinitionsCompanion copyWith({
    Value<String>? electionId,
    Value<String>? signedBallot,
    Value<Uint8List>? stationPublicKey,
    Value<int>? rowid,
  }) {
    return BallotDefinitionsCompanion(
      electionId: electionId ?? this.electionId,
      signedBallot: signedBallot ?? this.signedBallot,
      stationPublicKey: stationPublicKey ?? this.stationPublicKey,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (electionId.present) {
      map['election_id'] = Variable<String>(electionId.value);
    }
    if (signedBallot.present) {
      map['signed_ballot'] = Variable<String>(signedBallot.value);
    }
    if (stationPublicKey.present) {
      map['station_public_key'] = Variable<Uint8List>(stationPublicKey.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BallotDefinitionsCompanion(')
          ..write('electionId: $electionId, ')
          ..write('signedBallot: $signedBallot, ')
          ..write('stationPublicKey: $stationPublicKey, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BallotMediaTable extends BallotMedia
    with TableInfo<$BallotMediaTable, MediaItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BallotMediaTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _sha256Meta = const VerificationMeta('sha256');
  @override
  late final GeneratedColumn<String> sha256 = GeneratedColumn<String>(
    'sha256',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bytesMeta = const VerificationMeta('bytes');
  @override
  late final GeneratedColumn<Uint8List> bytes = GeneratedColumn<Uint8List>(
    'bytes',
    aliasedName,
    false,
    type: DriftSqlType.blob,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [sha256, bytes];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ballot_media';
  @override
  VerificationContext validateIntegrity(
    Insertable<MediaItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('sha256')) {
      context.handle(
        _sha256Meta,
        sha256.isAcceptableOrUnknown(data['sha256']!, _sha256Meta),
      );
    } else if (isInserting) {
      context.missing(_sha256Meta);
    }
    if (data.containsKey('bytes')) {
      context.handle(
        _bytesMeta,
        bytes.isAcceptableOrUnknown(data['bytes']!, _bytesMeta),
      );
    } else if (isInserting) {
      context.missing(_bytesMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {sha256};
  @override
  MediaItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MediaItem(
      sha256: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sha256'],
      )!,
      bytes: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}bytes'],
      )!,
    );
  }

  @override
  $BallotMediaTable createAlias(String alias) {
    return $BallotMediaTable(attachedDatabase, alias);
  }
}

class MediaItem extends DataClass implements Insertable<MediaItem> {
  final String sha256;
  final Uint8List bytes;
  const MediaItem({required this.sha256, required this.bytes});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['sha256'] = Variable<String>(sha256);
    map['bytes'] = Variable<Uint8List>(bytes);
    return map;
  }

  BallotMediaCompanion toCompanion(bool nullToAbsent) {
    return BallotMediaCompanion(sha256: Value(sha256), bytes: Value(bytes));
  }

  factory MediaItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MediaItem(
      sha256: serializer.fromJson<String>(json['sha256']),
      bytes: serializer.fromJson<Uint8List>(json['bytes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'sha256': serializer.toJson<String>(sha256),
      'bytes': serializer.toJson<Uint8List>(bytes),
    };
  }

  MediaItem copyWith({String? sha256, Uint8List? bytes}) =>
      MediaItem(sha256: sha256 ?? this.sha256, bytes: bytes ?? this.bytes);
  MediaItem copyWithCompanion(BallotMediaCompanion data) {
    return MediaItem(
      sha256: data.sha256.present ? data.sha256.value : this.sha256,
      bytes: data.bytes.present ? data.bytes.value : this.bytes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MediaItem(')
          ..write('sha256: $sha256, ')
          ..write('bytes: $bytes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(sha256, $driftBlobEquality.hash(bytes));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MediaItem &&
          other.sha256 == this.sha256 &&
          $driftBlobEquality.equals(other.bytes, this.bytes));
}

class BallotMediaCompanion extends UpdateCompanion<MediaItem> {
  final Value<String> sha256;
  final Value<Uint8List> bytes;
  final Value<int> rowid;
  const BallotMediaCompanion({
    this.sha256 = const Value.absent(),
    this.bytes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BallotMediaCompanion.insert({
    required String sha256,
    required Uint8List bytes,
    this.rowid = const Value.absent(),
  }) : sha256 = Value(sha256),
       bytes = Value(bytes);
  static Insertable<MediaItem> custom({
    Expression<String>? sha256,
    Expression<Uint8List>? bytes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (sha256 != null) 'sha256': sha256,
      if (bytes != null) 'bytes': bytes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BallotMediaCompanion copyWith({
    Value<String>? sha256,
    Value<Uint8List>? bytes,
    Value<int>? rowid,
  }) {
    return BallotMediaCompanion(
      sha256: sha256 ?? this.sha256,
      bytes: bytes ?? this.bytes,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (sha256.present) {
      map['sha256'] = Variable<String>(sha256.value);
    }
    if (bytes.present) {
      map['bytes'] = Variable<Uint8List>(bytes.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BallotMediaCompanion(')
          ..write('sha256: $sha256, ')
          ..write('bytes: $bytes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $VotesTable extends Votes with TableInfo<$VotesTable, VoteRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VotesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _ballotIdMeta = const VerificationMeta(
    'ballotId',
  );
  @override
  late final GeneratedColumn<String> ballotId = GeneratedColumn<String>(
    'ballot_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _positionIdMeta = const VerificationMeta(
    'positionId',
  );
  @override
  late final GeneratedColumn<String> positionId = GeneratedColumn<String>(
    'position_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _choiceMeta = const VerificationMeta('choice');
  @override
  late final GeneratedColumn<String> choice = GeneratedColumn<String>(
    'choice',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _signatureMeta = const VerificationMeta(
    'signature',
  );
  @override
  late final GeneratedColumn<String> signature = GeneratedColumn<String>(
    'signature',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    ballotId,
    positionId,
    choice,
    signature,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'votes';
  @override
  VerificationContext validateIntegrity(
    Insertable<VoteRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('ballot_id')) {
      context.handle(
        _ballotIdMeta,
        ballotId.isAcceptableOrUnknown(data['ballot_id']!, _ballotIdMeta),
      );
    } else if (isInserting) {
      context.missing(_ballotIdMeta);
    }
    if (data.containsKey('position_id')) {
      context.handle(
        _positionIdMeta,
        positionId.isAcceptableOrUnknown(data['position_id']!, _positionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_positionIdMeta);
    }
    if (data.containsKey('choice')) {
      context.handle(
        _choiceMeta,
        choice.isAcceptableOrUnknown(data['choice']!, _choiceMeta),
      );
    } else if (isInserting) {
      context.missing(_choiceMeta);
    }
    if (data.containsKey('signature')) {
      context.handle(
        _signatureMeta,
        signature.isAcceptableOrUnknown(data['signature']!, _signatureMeta),
      );
    } else if (isInserting) {
      context.missing(_signatureMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {ballotId, positionId};
  @override
  VoteRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VoteRecord(
      ballotId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ballot_id'],
      )!,
      positionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}position_id'],
      )!,
      choice: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}choice'],
      )!,
      signature: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}signature'],
      )!,
    );
  }

  @override
  $VotesTable createAlias(String alias) {
    return $VotesTable(attachedDatabase, alias);
  }

  @override
  bool get withoutRowId => true;
}

class VoteRecord extends DataClass implements Insertable<VoteRecord> {
  /// Random 128-bit id shared by the rows of one ballot; printed on the receipt.
  final String ballotId;
  final String positionId;

  /// JSON list of candidate ids (sorted), or ["NO_CHOICE"].
  final String choice;

  /// Ed25519 signature of the booth device over the row (base64url).
  final String signature;
  const VoteRecord({
    required this.ballotId,
    required this.positionId,
    required this.choice,
    required this.signature,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['ballot_id'] = Variable<String>(ballotId);
    map['position_id'] = Variable<String>(positionId);
    map['choice'] = Variable<String>(choice);
    map['signature'] = Variable<String>(signature);
    return map;
  }

  VotesCompanion toCompanion(bool nullToAbsent) {
    return VotesCompanion(
      ballotId: Value(ballotId),
      positionId: Value(positionId),
      choice: Value(choice),
      signature: Value(signature),
    );
  }

  factory VoteRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VoteRecord(
      ballotId: serializer.fromJson<String>(json['ballotId']),
      positionId: serializer.fromJson<String>(json['positionId']),
      choice: serializer.fromJson<String>(json['choice']),
      signature: serializer.fromJson<String>(json['signature']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'ballotId': serializer.toJson<String>(ballotId),
      'positionId': serializer.toJson<String>(positionId),
      'choice': serializer.toJson<String>(choice),
      'signature': serializer.toJson<String>(signature),
    };
  }

  VoteRecord copyWith({
    String? ballotId,
    String? positionId,
    String? choice,
    String? signature,
  }) => VoteRecord(
    ballotId: ballotId ?? this.ballotId,
    positionId: positionId ?? this.positionId,
    choice: choice ?? this.choice,
    signature: signature ?? this.signature,
  );
  VoteRecord copyWithCompanion(VotesCompanion data) {
    return VoteRecord(
      ballotId: data.ballotId.present ? data.ballotId.value : this.ballotId,
      positionId: data.positionId.present
          ? data.positionId.value
          : this.positionId,
      choice: data.choice.present ? data.choice.value : this.choice,
      signature: data.signature.present ? data.signature.value : this.signature,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VoteRecord(')
          ..write('ballotId: $ballotId, ')
          ..write('positionId: $positionId, ')
          ..write('choice: $choice, ')
          ..write('signature: $signature')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(ballotId, positionId, choice, signature);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VoteRecord &&
          other.ballotId == this.ballotId &&
          other.positionId == this.positionId &&
          other.choice == this.choice &&
          other.signature == this.signature);
}

class VotesCompanion extends UpdateCompanion<VoteRecord> {
  final Value<String> ballotId;
  final Value<String> positionId;
  final Value<String> choice;
  final Value<String> signature;
  const VotesCompanion({
    this.ballotId = const Value.absent(),
    this.positionId = const Value.absent(),
    this.choice = const Value.absent(),
    this.signature = const Value.absent(),
  });
  VotesCompanion.insert({
    required String ballotId,
    required String positionId,
    required String choice,
    required String signature,
  }) : ballotId = Value(ballotId),
       positionId = Value(positionId),
       choice = Value(choice),
       signature = Value(signature);
  static Insertable<VoteRecord> custom({
    Expression<String>? ballotId,
    Expression<String>? positionId,
    Expression<String>? choice,
    Expression<String>? signature,
  }) {
    return RawValuesInsertable({
      if (ballotId != null) 'ballot_id': ballotId,
      if (positionId != null) 'position_id': positionId,
      if (choice != null) 'choice': choice,
      if (signature != null) 'signature': signature,
    });
  }

  VotesCompanion copyWith({
    Value<String>? ballotId,
    Value<String>? positionId,
    Value<String>? choice,
    Value<String>? signature,
  }) {
    return VotesCompanion(
      ballotId: ballotId ?? this.ballotId,
      positionId: positionId ?? this.positionId,
      choice: choice ?? this.choice,
      signature: signature ?? this.signature,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (ballotId.present) {
      map['ballot_id'] = Variable<String>(ballotId.value);
    }
    if (positionId.present) {
      map['position_id'] = Variable<String>(positionId.value);
    }
    if (choice.present) {
      map['choice'] = Variable<String>(choice.value);
    }
    if (signature.present) {
      map['signature'] = Variable<String>(signature.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VotesCompanion(')
          ..write('ballotId: $ballotId, ')
          ..write('positionId: $positionId, ')
          ..write('choice: $choice, ')
          ..write('signature: $signature')
          ..write(')'))
        .toString();
  }
}

class $ActiveTokensTable extends ActiveTokens
    with TableInfo<$ActiveTokensTable, ActiveToken> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ActiveTokensTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _tokenHashMeta = const VerificationMeta(
    'tokenHash',
  );
  @override
  late final GeneratedColumn<String> tokenHash = GeneratedColumn<String>(
    'token_hash',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [tokenHash];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'active_tokens';
  @override
  VerificationContext validateIntegrity(
    Insertable<ActiveToken> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('token_hash')) {
      context.handle(
        _tokenHashMeta,
        tokenHash.isAcceptableOrUnknown(data['token_hash']!, _tokenHashMeta),
      );
    } else if (isInserting) {
      context.missing(_tokenHashMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {tokenHash};
  @override
  ActiveToken map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ActiveToken(
      tokenHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}token_hash'],
      )!,
    );
  }

  @override
  $ActiveTokensTable createAlias(String alias) {
    return $ActiveTokensTable(attachedDatabase, alias);
  }

  @override
  bool get withoutRowId => true;
}

class ActiveToken extends DataClass implements Insertable<ActiveToken> {
  final String tokenHash;
  const ActiveToken({required this.tokenHash});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['token_hash'] = Variable<String>(tokenHash);
    return map;
  }

  ActiveTokensCompanion toCompanion(bool nullToAbsent) {
    return ActiveTokensCompanion(tokenHash: Value(tokenHash));
  }

  factory ActiveToken.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ActiveToken(
      tokenHash: serializer.fromJson<String>(json['tokenHash']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{'tokenHash': serializer.toJson<String>(tokenHash)};
  }

  ActiveToken copyWith({String? tokenHash}) =>
      ActiveToken(tokenHash: tokenHash ?? this.tokenHash);
  ActiveToken copyWithCompanion(ActiveTokensCompanion data) {
    return ActiveToken(
      tokenHash: data.tokenHash.present ? data.tokenHash.value : this.tokenHash,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ActiveToken(')
          ..write('tokenHash: $tokenHash')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => tokenHash.hashCode;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ActiveToken && other.tokenHash == this.tokenHash);
}

class ActiveTokensCompanion extends UpdateCompanion<ActiveToken> {
  final Value<String> tokenHash;
  const ActiveTokensCompanion({this.tokenHash = const Value.absent()});
  ActiveTokensCompanion.insert({required String tokenHash})
    : tokenHash = Value(tokenHash);
  static Insertable<ActiveToken> custom({Expression<String>? tokenHash}) {
    return RawValuesInsertable({
      if (tokenHash != null) 'token_hash': tokenHash,
    });
  }

  ActiveTokensCompanion copyWith({Value<String>? tokenHash}) {
    return ActiveTokensCompanion(tokenHash: tokenHash ?? this.tokenHash);
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (tokenHash.present) {
      map['token_hash'] = Variable<String>(tokenHash.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ActiveTokensCompanion(')
          ..write('tokenHash: $tokenHash')
          ..write(')'))
        .toString();
  }
}

class $UsedTokensTable extends UsedTokens
    with TableInfo<$UsedTokensTable, UsedToken> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsedTokensTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _tokenHashMeta = const VerificationMeta(
    'tokenHash',
  );
  @override
  late final GeneratedColumn<String> tokenHash = GeneratedColumn<String>(
    'token_hash',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [tokenHash];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'used_tokens';
  @override
  VerificationContext validateIntegrity(
    Insertable<UsedToken> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('token_hash')) {
      context.handle(
        _tokenHashMeta,
        tokenHash.isAcceptableOrUnknown(data['token_hash']!, _tokenHashMeta),
      );
    } else if (isInserting) {
      context.missing(_tokenHashMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {tokenHash};
  @override
  UsedToken map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UsedToken(
      tokenHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}token_hash'],
      )!,
    );
  }

  @override
  $UsedTokensTable createAlias(String alias) {
    return $UsedTokensTable(attachedDatabase, alias);
  }

  @override
  bool get withoutRowId => true;
}

class UsedToken extends DataClass implements Insertable<UsedToken> {
  final String tokenHash;
  const UsedToken({required this.tokenHash});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['token_hash'] = Variable<String>(tokenHash);
    return map;
  }

  UsedTokensCompanion toCompanion(bool nullToAbsent) {
    return UsedTokensCompanion(tokenHash: Value(tokenHash));
  }

  factory UsedToken.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UsedToken(tokenHash: serializer.fromJson<String>(json['tokenHash']));
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{'tokenHash': serializer.toJson<String>(tokenHash)};
  }

  UsedToken copyWith({String? tokenHash}) =>
      UsedToken(tokenHash: tokenHash ?? this.tokenHash);
  UsedToken copyWithCompanion(UsedTokensCompanion data) {
    return UsedToken(
      tokenHash: data.tokenHash.present ? data.tokenHash.value : this.tokenHash,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UsedToken(')
          ..write('tokenHash: $tokenHash')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => tokenHash.hashCode;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UsedToken && other.tokenHash == this.tokenHash);
}

class UsedTokensCompanion extends UpdateCompanion<UsedToken> {
  final Value<String> tokenHash;
  const UsedTokensCompanion({this.tokenHash = const Value.absent()});
  UsedTokensCompanion.insert({required String tokenHash})
    : tokenHash = Value(tokenHash);
  static Insertable<UsedToken> custom({Expression<String>? tokenHash}) {
    return RawValuesInsertable({
      if (tokenHash != null) 'token_hash': tokenHash,
    });
  }

  UsedTokensCompanion copyWith({Value<String>? tokenHash}) {
    return UsedTokensCompanion(tokenHash: tokenHash ?? this.tokenHash);
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (tokenHash.present) {
      map['token_hash'] = Variable<String>(tokenHash.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsedTokensCompanion(')
          ..write('tokenHash: $tokenHash')
          ..write(')'))
        .toString();
  }
}

class $BatchExportsTable extends BatchExports
    with TableInfo<$BatchExportsTable, BatchExport> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BatchExportsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _batchSeqMeta = const VerificationMeta(
    'batchSeq',
  );
  @override
  late final GeneratedColumn<int> batchSeq = GeneratedColumn<int>(
    'batch_seq',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ballotCountMeta = const VerificationMeta(
    'ballotCount',
  );
  @override
  late final GeneratedColumn<int> ballotCount = GeneratedColumn<int>(
    'ballot_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _batchHashMeta = const VerificationMeta(
    'batchHash',
  );
  @override
  late final GeneratedColumn<String> batchHash = GeneratedColumn<String>(
    'batch_hash',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [batchSeq, ballotCount, batchHash];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'batch_exports';
  @override
  VerificationContext validateIntegrity(
    Insertable<BatchExport> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('batch_seq')) {
      context.handle(
        _batchSeqMeta,
        batchSeq.isAcceptableOrUnknown(data['batch_seq']!, _batchSeqMeta),
      );
    }
    if (data.containsKey('ballot_count')) {
      context.handle(
        _ballotCountMeta,
        ballotCount.isAcceptableOrUnknown(
          data['ballot_count']!,
          _ballotCountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_ballotCountMeta);
    }
    if (data.containsKey('batch_hash')) {
      context.handle(
        _batchHashMeta,
        batchHash.isAcceptableOrUnknown(data['batch_hash']!, _batchHashMeta),
      );
    } else if (isInserting) {
      context.missing(_batchHashMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {batchSeq};
  @override
  BatchExport map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BatchExport(
      batchSeq: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}batch_seq'],
      )!,
      ballotCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ballot_count'],
      )!,
      batchHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}batch_hash'],
      )!,
    );
  }

  @override
  $BatchExportsTable createAlias(String alias) {
    return $BatchExportsTable(attachedDatabase, alias);
  }
}

class BatchExport extends DataClass implements Insertable<BatchExport> {
  final int batchSeq;
  final int ballotCount;
  final String batchHash;
  const BatchExport({
    required this.batchSeq,
    required this.ballotCount,
    required this.batchHash,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['batch_seq'] = Variable<int>(batchSeq);
    map['ballot_count'] = Variable<int>(ballotCount);
    map['batch_hash'] = Variable<String>(batchHash);
    return map;
  }

  BatchExportsCompanion toCompanion(bool nullToAbsent) {
    return BatchExportsCompanion(
      batchSeq: Value(batchSeq),
      ballotCount: Value(ballotCount),
      batchHash: Value(batchHash),
    );
  }

  factory BatchExport.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BatchExport(
      batchSeq: serializer.fromJson<int>(json['batchSeq']),
      ballotCount: serializer.fromJson<int>(json['ballotCount']),
      batchHash: serializer.fromJson<String>(json['batchHash']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'batchSeq': serializer.toJson<int>(batchSeq),
      'ballotCount': serializer.toJson<int>(ballotCount),
      'batchHash': serializer.toJson<String>(batchHash),
    };
  }

  BatchExport copyWith({int? batchSeq, int? ballotCount, String? batchHash}) =>
      BatchExport(
        batchSeq: batchSeq ?? this.batchSeq,
        ballotCount: ballotCount ?? this.ballotCount,
        batchHash: batchHash ?? this.batchHash,
      );
  BatchExport copyWithCompanion(BatchExportsCompanion data) {
    return BatchExport(
      batchSeq: data.batchSeq.present ? data.batchSeq.value : this.batchSeq,
      ballotCount: data.ballotCount.present
          ? data.ballotCount.value
          : this.ballotCount,
      batchHash: data.batchHash.present ? data.batchHash.value : this.batchHash,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BatchExport(')
          ..write('batchSeq: $batchSeq, ')
          ..write('ballotCount: $ballotCount, ')
          ..write('batchHash: $batchHash')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(batchSeq, ballotCount, batchHash);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BatchExport &&
          other.batchSeq == this.batchSeq &&
          other.ballotCount == this.ballotCount &&
          other.batchHash == this.batchHash);
}

class BatchExportsCompanion extends UpdateCompanion<BatchExport> {
  final Value<int> batchSeq;
  final Value<int> ballotCount;
  final Value<String> batchHash;
  const BatchExportsCompanion({
    this.batchSeq = const Value.absent(),
    this.ballotCount = const Value.absent(),
    this.batchHash = const Value.absent(),
  });
  BatchExportsCompanion.insert({
    this.batchSeq = const Value.absent(),
    required int ballotCount,
    required String batchHash,
  }) : ballotCount = Value(ballotCount),
       batchHash = Value(batchHash);
  static Insertable<BatchExport> custom({
    Expression<int>? batchSeq,
    Expression<int>? ballotCount,
    Expression<String>? batchHash,
  }) {
    return RawValuesInsertable({
      if (batchSeq != null) 'batch_seq': batchSeq,
      if (ballotCount != null) 'ballot_count': ballotCount,
      if (batchHash != null) 'batch_hash': batchHash,
    });
  }

  BatchExportsCompanion copyWith({
    Value<int>? batchSeq,
    Value<int>? ballotCount,
    Value<String>? batchHash,
  }) {
    return BatchExportsCompanion(
      batchSeq: batchSeq ?? this.batchSeq,
      ballotCount: ballotCount ?? this.ballotCount,
      batchHash: batchHash ?? this.batchHash,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (batchSeq.present) {
      map['batch_seq'] = Variable<int>(batchSeq.value);
    }
    if (ballotCount.present) {
      map['ballot_count'] = Variable<int>(ballotCount.value);
    }
    if (batchHash.present) {
      map['batch_hash'] = Variable<String>(batchHash.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BatchExportsCompanion(')
          ..write('batchSeq: $batchSeq, ')
          ..write('ballotCount: $ballotCount, ')
          ..write('batchHash: $batchHash')
          ..write(')'))
        .toString();
  }
}

class $AuditLogTable extends AuditLog
    with TableInfo<$AuditLogTable, AuditEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AuditLogTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _seqMeta = const VerificationMeta('seq');
  @override
  late final GeneratedColumn<int> seq = GeneratedColumn<int>(
    'seq',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _prevHashMeta = const VerificationMeta(
    'prevHash',
  );
  @override
  late final GeneratedColumn<String> prevHash = GeneratedColumn<String>(
    'prev_hash',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tsMeta = const VerificationMeta('ts');
  @override
  late final GeneratedColumn<String> ts = GeneratedColumn<String>(
    'ts',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _actorMeta = const VerificationMeta('actor');
  @override
  late final GeneratedColumn<String> actor = GeneratedColumn<String>(
    'actor',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _actionMeta = const VerificationMeta('action');
  @override
  late final GeneratedColumn<String> action = GeneratedColumn<String>(
    'action',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hashMeta = const VerificationMeta('hash');
  @override
  late final GeneratedColumn<String> hash = GeneratedColumn<String>(
    'hash',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    seq,
    prevHash,
    ts,
    actor,
    action,
    payload,
    hash,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'audit_log';
  @override
  VerificationContext validateIntegrity(
    Insertable<AuditEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('seq')) {
      context.handle(
        _seqMeta,
        seq.isAcceptableOrUnknown(data['seq']!, _seqMeta),
      );
    }
    if (data.containsKey('prev_hash')) {
      context.handle(
        _prevHashMeta,
        prevHash.isAcceptableOrUnknown(data['prev_hash']!, _prevHashMeta),
      );
    } else if (isInserting) {
      context.missing(_prevHashMeta);
    }
    if (data.containsKey('ts')) {
      context.handle(_tsMeta, ts.isAcceptableOrUnknown(data['ts']!, _tsMeta));
    } else if (isInserting) {
      context.missing(_tsMeta);
    }
    if (data.containsKey('actor')) {
      context.handle(
        _actorMeta,
        actor.isAcceptableOrUnknown(data['actor']!, _actorMeta),
      );
    } else if (isInserting) {
      context.missing(_actorMeta);
    }
    if (data.containsKey('action')) {
      context.handle(
        _actionMeta,
        action.isAcceptableOrUnknown(data['action']!, _actionMeta),
      );
    } else if (isInserting) {
      context.missing(_actionMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('hash')) {
      context.handle(
        _hashMeta,
        hash.isAcceptableOrUnknown(data['hash']!, _hashMeta),
      );
    } else if (isInserting) {
      context.missing(_hashMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {seq};
  @override
  AuditEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AuditEntry(
      seq: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}seq'],
      )!,
      prevHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}prev_hash'],
      )!,
      ts: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ts'],
      )!,
      actor: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}actor'],
      )!,
      action: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}action'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
      hash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hash'],
      )!,
    );
  }

  @override
  $AuditLogTable createAlias(String alias) {
    return $AuditLogTable(attachedDatabase, alias);
  }
}

class AuditEntry extends DataClass implements Insertable<AuditEntry> {
  final int seq;
  final String prevHash;

  /// UTC, to the second, ISO-8601.
  final String ts;
  final String actor;
  final String action;

  /// Canonical JSON.
  final String payload;
  final String hash;
  const AuditEntry({
    required this.seq,
    required this.prevHash,
    required this.ts,
    required this.actor,
    required this.action,
    required this.payload,
    required this.hash,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['seq'] = Variable<int>(seq);
    map['prev_hash'] = Variable<String>(prevHash);
    map['ts'] = Variable<String>(ts);
    map['actor'] = Variable<String>(actor);
    map['action'] = Variable<String>(action);
    map['payload'] = Variable<String>(payload);
    map['hash'] = Variable<String>(hash);
    return map;
  }

  AuditLogCompanion toCompanion(bool nullToAbsent) {
    return AuditLogCompanion(
      seq: Value(seq),
      prevHash: Value(prevHash),
      ts: Value(ts),
      actor: Value(actor),
      action: Value(action),
      payload: Value(payload),
      hash: Value(hash),
    );
  }

  factory AuditEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AuditEntry(
      seq: serializer.fromJson<int>(json['seq']),
      prevHash: serializer.fromJson<String>(json['prevHash']),
      ts: serializer.fromJson<String>(json['ts']),
      actor: serializer.fromJson<String>(json['actor']),
      action: serializer.fromJson<String>(json['action']),
      payload: serializer.fromJson<String>(json['payload']),
      hash: serializer.fromJson<String>(json['hash']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'seq': serializer.toJson<int>(seq),
      'prevHash': serializer.toJson<String>(prevHash),
      'ts': serializer.toJson<String>(ts),
      'actor': serializer.toJson<String>(actor),
      'action': serializer.toJson<String>(action),
      'payload': serializer.toJson<String>(payload),
      'hash': serializer.toJson<String>(hash),
    };
  }

  AuditEntry copyWith({
    int? seq,
    String? prevHash,
    String? ts,
    String? actor,
    String? action,
    String? payload,
    String? hash,
  }) => AuditEntry(
    seq: seq ?? this.seq,
    prevHash: prevHash ?? this.prevHash,
    ts: ts ?? this.ts,
    actor: actor ?? this.actor,
    action: action ?? this.action,
    payload: payload ?? this.payload,
    hash: hash ?? this.hash,
  );
  AuditEntry copyWithCompanion(AuditLogCompanion data) {
    return AuditEntry(
      seq: data.seq.present ? data.seq.value : this.seq,
      prevHash: data.prevHash.present ? data.prevHash.value : this.prevHash,
      ts: data.ts.present ? data.ts.value : this.ts,
      actor: data.actor.present ? data.actor.value : this.actor,
      action: data.action.present ? data.action.value : this.action,
      payload: data.payload.present ? data.payload.value : this.payload,
      hash: data.hash.present ? data.hash.value : this.hash,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AuditEntry(')
          ..write('seq: $seq, ')
          ..write('prevHash: $prevHash, ')
          ..write('ts: $ts, ')
          ..write('actor: $actor, ')
          ..write('action: $action, ')
          ..write('payload: $payload, ')
          ..write('hash: $hash')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(seq, prevHash, ts, actor, action, payload, hash);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AuditEntry &&
          other.seq == this.seq &&
          other.prevHash == this.prevHash &&
          other.ts == this.ts &&
          other.actor == this.actor &&
          other.action == this.action &&
          other.payload == this.payload &&
          other.hash == this.hash);
}

class AuditLogCompanion extends UpdateCompanion<AuditEntry> {
  final Value<int> seq;
  final Value<String> prevHash;
  final Value<String> ts;
  final Value<String> actor;
  final Value<String> action;
  final Value<String> payload;
  final Value<String> hash;
  const AuditLogCompanion({
    this.seq = const Value.absent(),
    this.prevHash = const Value.absent(),
    this.ts = const Value.absent(),
    this.actor = const Value.absent(),
    this.action = const Value.absent(),
    this.payload = const Value.absent(),
    this.hash = const Value.absent(),
  });
  AuditLogCompanion.insert({
    this.seq = const Value.absent(),
    required String prevHash,
    required String ts,
    required String actor,
    required String action,
    required String payload,
    required String hash,
  }) : prevHash = Value(prevHash),
       ts = Value(ts),
       actor = Value(actor),
       action = Value(action),
       payload = Value(payload),
       hash = Value(hash);
  static Insertable<AuditEntry> custom({
    Expression<int>? seq,
    Expression<String>? prevHash,
    Expression<String>? ts,
    Expression<String>? actor,
    Expression<String>? action,
    Expression<String>? payload,
    Expression<String>? hash,
  }) {
    return RawValuesInsertable({
      if (seq != null) 'seq': seq,
      if (prevHash != null) 'prev_hash': prevHash,
      if (ts != null) 'ts': ts,
      if (actor != null) 'actor': actor,
      if (action != null) 'action': action,
      if (payload != null) 'payload': payload,
      if (hash != null) 'hash': hash,
    });
  }

  AuditLogCompanion copyWith({
    Value<int>? seq,
    Value<String>? prevHash,
    Value<String>? ts,
    Value<String>? actor,
    Value<String>? action,
    Value<String>? payload,
    Value<String>? hash,
  }) {
    return AuditLogCompanion(
      seq: seq ?? this.seq,
      prevHash: prevHash ?? this.prevHash,
      ts: ts ?? this.ts,
      actor: actor ?? this.actor,
      action: action ?? this.action,
      payload: payload ?? this.payload,
      hash: hash ?? this.hash,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (seq.present) {
      map['seq'] = Variable<int>(seq.value);
    }
    if (prevHash.present) {
      map['prev_hash'] = Variable<String>(prevHash.value);
    }
    if (ts.present) {
      map['ts'] = Variable<String>(ts.value);
    }
    if (actor.present) {
      map['actor'] = Variable<String>(actor.value);
    }
    if (action.present) {
      map['action'] = Variable<String>(action.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (hash.present) {
      map['hash'] = Variable<String>(hash.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AuditLogCompanion(')
          ..write('seq: $seq, ')
          ..write('prevHash: $prevHash, ')
          ..write('ts: $ts, ')
          ..write('actor: $actor, ')
          ..write('action: $action, ')
          ..write('payload: $payload, ')
          ..write('hash: $hash')
          ..write(')'))
        .toString();
  }
}

abstract class _$BallotBoxDb extends GeneratedDatabase {
  _$BallotBoxDb(QueryExecutor e) : super(e);
  $BallotBoxDbManager get managers => $BallotBoxDbManager(this);
  late final $BallotDefinitionsTable ballotDefinitions =
      $BallotDefinitionsTable(this);
  late final $BallotMediaTable ballotMedia = $BallotMediaTable(this);
  late final $VotesTable votes = $VotesTable(this);
  late final $ActiveTokensTable activeTokens = $ActiveTokensTable(this);
  late final $UsedTokensTable usedTokens = $UsedTokensTable(this);
  late final $BatchExportsTable batchExports = $BatchExportsTable(this);
  late final $AuditLogTable auditLog = $AuditLogTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    ballotDefinitions,
    ballotMedia,
    votes,
    activeTokens,
    usedTokens,
    batchExports,
    auditLog,
  ];
}

typedef $$BallotDefinitionsTableCreateCompanionBuilder =
    BallotDefinitionsCompanion Function({
      required String electionId,
      required String signedBallot,
      required Uint8List stationPublicKey,
      Value<int> rowid,
    });
typedef $$BallotDefinitionsTableUpdateCompanionBuilder =
    BallotDefinitionsCompanion Function({
      Value<String> electionId,
      Value<String> signedBallot,
      Value<Uint8List> stationPublicKey,
      Value<int> rowid,
    });

class $$BallotDefinitionsTableFilterComposer
    extends Composer<_$BallotBoxDb, $BallotDefinitionsTable> {
  $$BallotDefinitionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get electionId => $composableBuilder(
    column: $table.electionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get signedBallot => $composableBuilder(
    column: $table.signedBallot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<Uint8List> get stationPublicKey => $composableBuilder(
    column: $table.stationPublicKey,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BallotDefinitionsTableOrderingComposer
    extends Composer<_$BallotBoxDb, $BallotDefinitionsTable> {
  $$BallotDefinitionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get electionId => $composableBuilder(
    column: $table.electionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get signedBallot => $composableBuilder(
    column: $table.signedBallot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<Uint8List> get stationPublicKey => $composableBuilder(
    column: $table.stationPublicKey,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BallotDefinitionsTableAnnotationComposer
    extends Composer<_$BallotBoxDb, $BallotDefinitionsTable> {
  $$BallotDefinitionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get electionId => $composableBuilder(
    column: $table.electionId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get signedBallot => $composableBuilder(
    column: $table.signedBallot,
    builder: (column) => column,
  );

  GeneratedColumn<Uint8List> get stationPublicKey => $composableBuilder(
    column: $table.stationPublicKey,
    builder: (column) => column,
  );
}

class $$BallotDefinitionsTableTableManager
    extends
        RootTableManager<
          _$BallotBoxDb,
          $BallotDefinitionsTable,
          StoredBallot,
          $$BallotDefinitionsTableFilterComposer,
          $$BallotDefinitionsTableOrderingComposer,
          $$BallotDefinitionsTableAnnotationComposer,
          $$BallotDefinitionsTableCreateCompanionBuilder,
          $$BallotDefinitionsTableUpdateCompanionBuilder,
          (
            StoredBallot,
            BaseReferences<
              _$BallotBoxDb,
              $BallotDefinitionsTable,
              StoredBallot
            >,
          ),
          StoredBallot,
          PrefetchHooks Function()
        > {
  $$BallotDefinitionsTableTableManager(
    _$BallotBoxDb db,
    $BallotDefinitionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BallotDefinitionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BallotDefinitionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BallotDefinitionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> electionId = const Value.absent(),
                Value<String> signedBallot = const Value.absent(),
                Value<Uint8List> stationPublicKey = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BallotDefinitionsCompanion(
                electionId: electionId,
                signedBallot: signedBallot,
                stationPublicKey: stationPublicKey,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String electionId,
                required String signedBallot,
                required Uint8List stationPublicKey,
                Value<int> rowid = const Value.absent(),
              }) => BallotDefinitionsCompanion.insert(
                electionId: electionId,
                signedBallot: signedBallot,
                stationPublicKey: stationPublicKey,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$BallotDefinitionsTable, StoredBallot>(table),
                  BaseReferences<
                    _$BallotBoxDb,
                    $BallotDefinitionsTable,
                    StoredBallot
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BallotDefinitionsTableProcessedTableManager =
    ProcessedTableManager<
      _$BallotBoxDb,
      $BallotDefinitionsTable,
      StoredBallot,
      $$BallotDefinitionsTableFilterComposer,
      $$BallotDefinitionsTableOrderingComposer,
      $$BallotDefinitionsTableAnnotationComposer,
      $$BallotDefinitionsTableCreateCompanionBuilder,
      $$BallotDefinitionsTableUpdateCompanionBuilder,
      (
        StoredBallot,
        BaseReferences<_$BallotBoxDb, $BallotDefinitionsTable, StoredBallot>,
      ),
      StoredBallot,
      PrefetchHooks Function()
    >;
typedef $$BallotMediaTableCreateCompanionBuilder =
    BallotMediaCompanion Function({
      required String sha256,
      required Uint8List bytes,
      Value<int> rowid,
    });
typedef $$BallotMediaTableUpdateCompanionBuilder =
    BallotMediaCompanion Function({
      Value<String> sha256,
      Value<Uint8List> bytes,
      Value<int> rowid,
    });

class $$BallotMediaTableFilterComposer
    extends Composer<_$BallotBoxDb, $BallotMediaTable> {
  $$BallotMediaTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get sha256 => $composableBuilder(
    column: $table.sha256,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<Uint8List> get bytes => $composableBuilder(
    column: $table.bytes,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BallotMediaTableOrderingComposer
    extends Composer<_$BallotBoxDb, $BallotMediaTable> {
  $$BallotMediaTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get sha256 => $composableBuilder(
    column: $table.sha256,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<Uint8List> get bytes => $composableBuilder(
    column: $table.bytes,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BallotMediaTableAnnotationComposer
    extends Composer<_$BallotBoxDb, $BallotMediaTable> {
  $$BallotMediaTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get sha256 =>
      $composableBuilder(column: $table.sha256, builder: (column) => column);

  GeneratedColumn<Uint8List> get bytes =>
      $composableBuilder(column: $table.bytes, builder: (column) => column);
}

class $$BallotMediaTableTableManager
    extends
        RootTableManager<
          _$BallotBoxDb,
          $BallotMediaTable,
          MediaItem,
          $$BallotMediaTableFilterComposer,
          $$BallotMediaTableOrderingComposer,
          $$BallotMediaTableAnnotationComposer,
          $$BallotMediaTableCreateCompanionBuilder,
          $$BallotMediaTableUpdateCompanionBuilder,
          (
            MediaItem,
            BaseReferences<_$BallotBoxDb, $BallotMediaTable, MediaItem>,
          ),
          MediaItem,
          PrefetchHooks Function()
        > {
  $$BallotMediaTableTableManager(_$BallotBoxDb db, $BallotMediaTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BallotMediaTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BallotMediaTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BallotMediaTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> sha256 = const Value.absent(),
                Value<Uint8List> bytes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BallotMediaCompanion(
                sha256: sha256,
                bytes: bytes,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String sha256,
                required Uint8List bytes,
                Value<int> rowid = const Value.absent(),
              }) => BallotMediaCompanion.insert(
                sha256: sha256,
                bytes: bytes,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$BallotMediaTable, MediaItem>(table),
                  BaseReferences<_$BallotBoxDb, $BallotMediaTable, MediaItem>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BallotMediaTableProcessedTableManager =
    ProcessedTableManager<
      _$BallotBoxDb,
      $BallotMediaTable,
      MediaItem,
      $$BallotMediaTableFilterComposer,
      $$BallotMediaTableOrderingComposer,
      $$BallotMediaTableAnnotationComposer,
      $$BallotMediaTableCreateCompanionBuilder,
      $$BallotMediaTableUpdateCompanionBuilder,
      (MediaItem, BaseReferences<_$BallotBoxDb, $BallotMediaTable, MediaItem>),
      MediaItem,
      PrefetchHooks Function()
    >;
typedef $$VotesTableCreateCompanionBuilder = VotesCompanion Function({
  required String ballotId,
  required String positionId,
  required String choice,
  required String signature,
});
typedef $$VotesTableUpdateCompanionBuilder = VotesCompanion Function({
  Value<String> ballotId,
  Value<String> positionId,
  Value<String> choice,
  Value<String> signature,
});

class $$VotesTableFilterComposer extends Composer<_$BallotBoxDb, $VotesTable> {
  $$VotesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get ballotId => $composableBuilder(
    column: $table.ballotId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get positionId => $composableBuilder(
    column: $table.positionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get choice => $composableBuilder(
    column: $table.choice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get signature => $composableBuilder(
    column: $table.signature,
    builder: (column) => ColumnFilters(column),
  );
}

class $$VotesTableOrderingComposer
    extends Composer<_$BallotBoxDb, $VotesTable> {
  $$VotesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get ballotId => $composableBuilder(
    column: $table.ballotId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get positionId => $composableBuilder(
    column: $table.positionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get choice => $composableBuilder(
    column: $table.choice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get signature => $composableBuilder(
    column: $table.signature,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$VotesTableAnnotationComposer
    extends Composer<_$BallotBoxDb, $VotesTable> {
  $$VotesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get ballotId =>
      $composableBuilder(column: $table.ballotId, builder: (column) => column);

  GeneratedColumn<String> get positionId => $composableBuilder(
    column: $table.positionId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get choice =>
      $composableBuilder(column: $table.choice, builder: (column) => column);

  GeneratedColumn<String> get signature =>
      $composableBuilder(column: $table.signature, builder: (column) => column);
}

class $$VotesTableTableManager
    extends
        RootTableManager<
          _$BallotBoxDb,
          $VotesTable,
          VoteRecord,
          $$VotesTableFilterComposer,
          $$VotesTableOrderingComposer,
          $$VotesTableAnnotationComposer,
          $$VotesTableCreateCompanionBuilder,
          $$VotesTableUpdateCompanionBuilder,
          (VoteRecord, BaseReferences<_$BallotBoxDb, $VotesTable, VoteRecord>),
          VoteRecord,
          PrefetchHooks Function()
        > {
  $$VotesTableTableManager(_$BallotBoxDb db, $VotesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VotesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VotesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VotesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> ballotId = const Value.absent(),
                Value<String> positionId = const Value.absent(),
                Value<String> choice = const Value.absent(),
                Value<String> signature = const Value.absent(),
              }) => VotesCompanion(
                ballotId: ballotId,
                positionId: positionId,
                choice: choice,
                signature: signature,
              ),
          createCompanionCallback:
              ({
                required String ballotId,
                required String positionId,
                required String choice,
                required String signature,
              }) => VotesCompanion.insert(
                ballotId: ballotId,
                positionId: positionId,
                choice: choice,
                signature: signature,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$VotesTable, VoteRecord>(table),
                  BaseReferences<_$BallotBoxDb, $VotesTable, VoteRecord>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$VotesTableProcessedTableManager =
    ProcessedTableManager<
      _$BallotBoxDb,
      $VotesTable,
      VoteRecord,
      $$VotesTableFilterComposer,
      $$VotesTableOrderingComposer,
      $$VotesTableAnnotationComposer,
      $$VotesTableCreateCompanionBuilder,
      $$VotesTableUpdateCompanionBuilder,
      (VoteRecord, BaseReferences<_$BallotBoxDb, $VotesTable, VoteRecord>),
      VoteRecord,
      PrefetchHooks Function()
    >;
typedef $$ActiveTokensTableCreateCompanionBuilder =
    ActiveTokensCompanion Function({required String tokenHash});
typedef $$ActiveTokensTableUpdateCompanionBuilder =
    ActiveTokensCompanion Function({Value<String> tokenHash});

class $$ActiveTokensTableFilterComposer
    extends Composer<_$BallotBoxDb, $ActiveTokensTable> {
  $$ActiveTokensTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get tokenHash => $composableBuilder(
    column: $table.tokenHash,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ActiveTokensTableOrderingComposer
    extends Composer<_$BallotBoxDb, $ActiveTokensTable> {
  $$ActiveTokensTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get tokenHash => $composableBuilder(
    column: $table.tokenHash,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ActiveTokensTableAnnotationComposer
    extends Composer<_$BallotBoxDb, $ActiveTokensTable> {
  $$ActiveTokensTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get tokenHash =>
      $composableBuilder(column: $table.tokenHash, builder: (column) => column);
}

class $$ActiveTokensTableTableManager
    extends
        RootTableManager<
          _$BallotBoxDb,
          $ActiveTokensTable,
          ActiveToken,
          $$ActiveTokensTableFilterComposer,
          $$ActiveTokensTableOrderingComposer,
          $$ActiveTokensTableAnnotationComposer,
          $$ActiveTokensTableCreateCompanionBuilder,
          $$ActiveTokensTableUpdateCompanionBuilder,
          (
            ActiveToken,
            BaseReferences<_$BallotBoxDb, $ActiveTokensTable, ActiveToken>,
          ),
          ActiveToken,
          PrefetchHooks Function()
        > {
  $$ActiveTokensTableTableManager(_$BallotBoxDb db, $ActiveTokensTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ActiveTokensTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ActiveTokensTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ActiveTokensTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> tokenHash = const Value.absent(),
          }) => ActiveTokensCompanion(tokenHash: tokenHash),
          createCompanionCallback: ({required String tokenHash}) =>
              ActiveTokensCompanion.insert(tokenHash: tokenHash),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ActiveTokensTable, ActiveToken>(table),
                  BaseReferences<
                    _$BallotBoxDb,
                    $ActiveTokensTable,
                    ActiveToken
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ActiveTokensTableProcessedTableManager =
    ProcessedTableManager<
      _$BallotBoxDb,
      $ActiveTokensTable,
      ActiveToken,
      $$ActiveTokensTableFilterComposer,
      $$ActiveTokensTableOrderingComposer,
      $$ActiveTokensTableAnnotationComposer,
      $$ActiveTokensTableCreateCompanionBuilder,
      $$ActiveTokensTableUpdateCompanionBuilder,
      (
        ActiveToken,
        BaseReferences<_$BallotBoxDb, $ActiveTokensTable, ActiveToken>,
      ),
      ActiveToken,
      PrefetchHooks Function()
    >;
typedef $$UsedTokensTableCreateCompanionBuilder = UsedTokensCompanion Function({
  required String tokenHash,
});
typedef $$UsedTokensTableUpdateCompanionBuilder = UsedTokensCompanion Function({
  Value<String> tokenHash,
});

class $$UsedTokensTableFilterComposer
    extends Composer<_$BallotBoxDb, $UsedTokensTable> {
  $$UsedTokensTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get tokenHash => $composableBuilder(
    column: $table.tokenHash,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UsedTokensTableOrderingComposer
    extends Composer<_$BallotBoxDb, $UsedTokensTable> {
  $$UsedTokensTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get tokenHash => $composableBuilder(
    column: $table.tokenHash,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UsedTokensTableAnnotationComposer
    extends Composer<_$BallotBoxDb, $UsedTokensTable> {
  $$UsedTokensTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get tokenHash =>
      $composableBuilder(column: $table.tokenHash, builder: (column) => column);
}

class $$UsedTokensTableTableManager
    extends
        RootTableManager<
          _$BallotBoxDb,
          $UsedTokensTable,
          UsedToken,
          $$UsedTokensTableFilterComposer,
          $$UsedTokensTableOrderingComposer,
          $$UsedTokensTableAnnotationComposer,
          $$UsedTokensTableCreateCompanionBuilder,
          $$UsedTokensTableUpdateCompanionBuilder,
          (
            UsedToken,
            BaseReferences<_$BallotBoxDb, $UsedTokensTable, UsedToken>,
          ),
          UsedToken,
          PrefetchHooks Function()
        > {
  $$UsedTokensTableTableManager(_$BallotBoxDb db, $UsedTokensTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsedTokensTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsedTokensTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsedTokensTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> tokenHash = const Value.absent(),
          }) => UsedTokensCompanion(tokenHash: tokenHash),
          createCompanionCallback: ({required String tokenHash}) =>
              UsedTokensCompanion.insert(tokenHash: tokenHash),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$UsedTokensTable, UsedToken>(table),
                  BaseReferences<_$BallotBoxDb, $UsedTokensTable, UsedToken>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UsedTokensTableProcessedTableManager =
    ProcessedTableManager<
      _$BallotBoxDb,
      $UsedTokensTable,
      UsedToken,
      $$UsedTokensTableFilterComposer,
      $$UsedTokensTableOrderingComposer,
      $$UsedTokensTableAnnotationComposer,
      $$UsedTokensTableCreateCompanionBuilder,
      $$UsedTokensTableUpdateCompanionBuilder,
      (UsedToken, BaseReferences<_$BallotBoxDb, $UsedTokensTable, UsedToken>),
      UsedToken,
      PrefetchHooks Function()
    >;
typedef $$BatchExportsTableCreateCompanionBuilder =
    BatchExportsCompanion Function({
      Value<int> batchSeq,
      required int ballotCount,
      required String batchHash,
    });
typedef $$BatchExportsTableUpdateCompanionBuilder =
    BatchExportsCompanion Function({
      Value<int> batchSeq,
      Value<int> ballotCount,
      Value<String> batchHash,
    });

class $$BatchExportsTableFilterComposer
    extends Composer<_$BallotBoxDb, $BatchExportsTable> {
  $$BatchExportsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get batchSeq => $composableBuilder(
    column: $table.batchSeq,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ballotCount => $composableBuilder(
    column: $table.ballotCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get batchHash => $composableBuilder(
    column: $table.batchHash,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BatchExportsTableOrderingComposer
    extends Composer<_$BallotBoxDb, $BatchExportsTable> {
  $$BatchExportsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get batchSeq => $composableBuilder(
    column: $table.batchSeq,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ballotCount => $composableBuilder(
    column: $table.ballotCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get batchHash => $composableBuilder(
    column: $table.batchHash,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BatchExportsTableAnnotationComposer
    extends Composer<_$BallotBoxDb, $BatchExportsTable> {
  $$BatchExportsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get batchSeq =>
      $composableBuilder(column: $table.batchSeq, builder: (column) => column);

  GeneratedColumn<int> get ballotCount => $composableBuilder(
    column: $table.ballotCount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get batchHash =>
      $composableBuilder(column: $table.batchHash, builder: (column) => column);
}

class $$BatchExportsTableTableManager
    extends
        RootTableManager<
          _$BallotBoxDb,
          $BatchExportsTable,
          BatchExport,
          $$BatchExportsTableFilterComposer,
          $$BatchExportsTableOrderingComposer,
          $$BatchExportsTableAnnotationComposer,
          $$BatchExportsTableCreateCompanionBuilder,
          $$BatchExportsTableUpdateCompanionBuilder,
          (
            BatchExport,
            BaseReferences<_$BallotBoxDb, $BatchExportsTable, BatchExport>,
          ),
          BatchExport,
          PrefetchHooks Function()
        > {
  $$BatchExportsTableTableManager(_$BallotBoxDb db, $BatchExportsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BatchExportsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BatchExportsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BatchExportsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> batchSeq = const Value.absent(),
                Value<int> ballotCount = const Value.absent(),
                Value<String> batchHash = const Value.absent(),
              }) => BatchExportsCompanion(
                batchSeq: batchSeq,
                ballotCount: ballotCount,
                batchHash: batchHash,
              ),
          createCompanionCallback:
              ({
                Value<int> batchSeq = const Value.absent(),
                required int ballotCount,
                required String batchHash,
              }) => BatchExportsCompanion.insert(
                batchSeq: batchSeq,
                ballotCount: ballotCount,
                batchHash: batchHash,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$BatchExportsTable, BatchExport>(table),
                  BaseReferences<
                    _$BallotBoxDb,
                    $BatchExportsTable,
                    BatchExport
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BatchExportsTableProcessedTableManager =
    ProcessedTableManager<
      _$BallotBoxDb,
      $BatchExportsTable,
      BatchExport,
      $$BatchExportsTableFilterComposer,
      $$BatchExportsTableOrderingComposer,
      $$BatchExportsTableAnnotationComposer,
      $$BatchExportsTableCreateCompanionBuilder,
      $$BatchExportsTableUpdateCompanionBuilder,
      (
        BatchExport,
        BaseReferences<_$BallotBoxDb, $BatchExportsTable, BatchExport>,
      ),
      BatchExport,
      PrefetchHooks Function()
    >;
typedef $$AuditLogTableCreateCompanionBuilder = AuditLogCompanion Function({
  Value<int> seq,
  required String prevHash,
  required String ts,
  required String actor,
  required String action,
  required String payload,
  required String hash,
});
typedef $$AuditLogTableUpdateCompanionBuilder = AuditLogCompanion Function({
  Value<int> seq,
  Value<String> prevHash,
  Value<String> ts,
  Value<String> actor,
  Value<String> action,
  Value<String> payload,
  Value<String> hash,
});

class $$AuditLogTableFilterComposer
    extends Composer<_$BallotBoxDb, $AuditLogTable> {
  $$AuditLogTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get seq => $composableBuilder(
    column: $table.seq,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get prevHash => $composableBuilder(
    column: $table.prevHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ts => $composableBuilder(
    column: $table.ts,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get actor => $composableBuilder(
    column: $table.actor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hash => $composableBuilder(
    column: $table.hash,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AuditLogTableOrderingComposer
    extends Composer<_$BallotBoxDb, $AuditLogTable> {
  $$AuditLogTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get seq => $composableBuilder(
    column: $table.seq,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get prevHash => $composableBuilder(
    column: $table.prevHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ts => $composableBuilder(
    column: $table.ts,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get actor => $composableBuilder(
    column: $table.actor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hash => $composableBuilder(
    column: $table.hash,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AuditLogTableAnnotationComposer
    extends Composer<_$BallotBoxDb, $AuditLogTable> {
  $$AuditLogTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get seq =>
      $composableBuilder(column: $table.seq, builder: (column) => column);

  GeneratedColumn<String> get prevHash =>
      $composableBuilder(column: $table.prevHash, builder: (column) => column);

  GeneratedColumn<String> get ts =>
      $composableBuilder(column: $table.ts, builder: (column) => column);

  GeneratedColumn<String> get actor =>
      $composableBuilder(column: $table.actor, builder: (column) => column);

  GeneratedColumn<String> get action =>
      $composableBuilder(column: $table.action, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<String> get hash =>
      $composableBuilder(column: $table.hash, builder: (column) => column);
}

class $$AuditLogTableTableManager
    extends
        RootTableManager<
          _$BallotBoxDb,
          $AuditLogTable,
          AuditEntry,
          $$AuditLogTableFilterComposer,
          $$AuditLogTableOrderingComposer,
          $$AuditLogTableAnnotationComposer,
          $$AuditLogTableCreateCompanionBuilder,
          $$AuditLogTableUpdateCompanionBuilder,
          (
            AuditEntry,
            BaseReferences<_$BallotBoxDb, $AuditLogTable, AuditEntry>,
          ),
          AuditEntry,
          PrefetchHooks Function()
        > {
  $$AuditLogTableTableManager(_$BallotBoxDb db, $AuditLogTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AuditLogTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AuditLogTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AuditLogTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> seq = const Value.absent(),
                Value<String> prevHash = const Value.absent(),
                Value<String> ts = const Value.absent(),
                Value<String> actor = const Value.absent(),
                Value<String> action = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<String> hash = const Value.absent(),
              }) => AuditLogCompanion(
                seq: seq,
                prevHash: prevHash,
                ts: ts,
                actor: actor,
                action: action,
                payload: payload,
                hash: hash,
              ),
          createCompanionCallback:
              ({
                Value<int> seq = const Value.absent(),
                required String prevHash,
                required String ts,
                required String actor,
                required String action,
                required String payload,
                required String hash,
              }) => AuditLogCompanion.insert(
                seq: seq,
                prevHash: prevHash,
                ts: ts,
                actor: actor,
                action: action,
                payload: payload,
                hash: hash,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AuditLogTable, AuditEntry>(table),
                  BaseReferences<_$BallotBoxDb, $AuditLogTable, AuditEntry>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AuditLogTableProcessedTableManager =
    ProcessedTableManager<
      _$BallotBoxDb,
      $AuditLogTable,
      AuditEntry,
      $$AuditLogTableFilterComposer,
      $$AuditLogTableOrderingComposer,
      $$AuditLogTableAnnotationComposer,
      $$AuditLogTableCreateCompanionBuilder,
      $$AuditLogTableUpdateCompanionBuilder,
      (AuditEntry, BaseReferences<_$BallotBoxDb, $AuditLogTable, AuditEntry>),
      AuditEntry,
      PrefetchHooks Function()
    >;

class $BallotBoxDbManager {
  final _$BallotBoxDb _db;
  $BallotBoxDbManager(this._db);
  $$BallotDefinitionsTableTableManager get ballotDefinitions =>
      $$BallotDefinitionsTableTableManager(_db, _db.ballotDefinitions);
  $$BallotMediaTableTableManager get ballotMedia =>
      $$BallotMediaTableTableManager(_db, _db.ballotMedia);
  $$VotesTableTableManager get votes =>
      $$VotesTableTableManager(_db, _db.votes);
  $$ActiveTokensTableTableManager get activeTokens =>
      $$ActiveTokensTableTableManager(_db, _db.activeTokens);
  $$UsedTokensTableTableManager get usedTokens =>
      $$UsedTokensTableTableManager(_db, _db.usedTokens);
  $$BatchExportsTableTableManager get batchExports =>
      $$BatchExportsTableTableManager(_db, _db.batchExports);
  $$AuditLogTableTableManager get auditLog =>
      $$AuditLogTableTableManager(_db, _db.auditLog);
}

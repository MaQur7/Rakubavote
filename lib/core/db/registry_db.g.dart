// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'registry_db.dart';

// ignore_for_file: type=lint
class $ElectionsTable extends Elections
    with TableInfo<$ElectionsTable, Election> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ElectionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _orgNameMeta = const VerificationMeta(
    'orgName',
  );
  @override
  late final GeneratedColumn<String> orgName = GeneratedColumn<String>(
    'org_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _orgLogoMeta = const VerificationMeta(
    'orgLogo',
  );
  @override
  late final GeneratedColumn<Uint8List> orgLogo = GeneratedColumn<Uint8List>(
    'org_logo',
    aliasedName,
    true,
    type: DriftSqlType.blob,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _yearMeta = const VerificationMeta('year');
  @override
  late final GeneratedColumn<int> year = GeneratedColumn<int>(
    'year',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _templateMeta = const VerificationMeta(
    'template',
  );
  @override
  late final GeneratedColumn<String> template = GeneratedColumn<String>(
    'template',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _languagesMeta = const VerificationMeta(
    'languages',
  );
  @override
  late final GeneratedColumn<String> languages = GeneratedColumn<String>(
    'languages',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _idLabelMeta = const VerificationMeta(
    'idLabel',
  );
  @override
  late final GeneratedColumn<String> idLabel = GeneratedColumn<String>(
    'id_label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _groupLabelMeta = const VerificationMeta(
    'groupLabel',
  );
  @override
  late final GeneratedColumn<String> groupLabel = GeneratedColumn<String>(
    'group_label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stationNameMeta = const VerificationMeta(
    'stationName',
  );
  @override
  late final GeneratedColumn<String> stationName = GeneratedColumn<String>(
    'station_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stateMeta = const VerificationMeta('state');
  @override
  late final GeneratedColumn<String> state = GeneratedColumn<String>(
    'state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('setup'),
  );
  static const VerificationMeta _reviewStartMeta = const VerificationMeta(
    'reviewStart',
  );
  @override
  late final GeneratedColumn<DateTime> reviewStart = GeneratedColumn<DateTime>(
    'review_start',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _reviewEndMeta = const VerificationMeta(
    'reviewEnd',
  );
  @override
  late final GeneratedColumn<DateTime> reviewEnd = GeneratedColumn<DateTime>(
    'review_end',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _schoolConsentRecordedMeta =
      const VerificationMeta('schoolConsentRecorded');
  @override
  late final GeneratedColumn<bool> schoolConsentRecorded =
      GeneratedColumn<bool>(
        'school_consent_recorded',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("school_consent_recorded" IN (0, 1))',
        ),
        defaultValue: const Constant(false),
      );
  static const VerificationMeta _schoolConsentByMeta = const VerificationMeta(
    'schoolConsentBy',
  );
  @override
  late final GeneratedColumn<String> schoolConsentBy = GeneratedColumn<String>(
    'school_consent_by',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _schoolConsentAtMeta = const VerificationMeta(
    'schoolConsentAt',
  );
  @override
  late final GeneratedColumn<DateTime> schoolConsentAt =
      GeneratedColumn<DateTime>(
        'school_consent_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _signedBallotMeta = const VerificationMeta(
    'signedBallot',
  );
  @override
  late final GeneratedColumn<String> signedBallot = GeneratedColumn<String>(
    'signed_ballot',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastVoterNoMeta = const VerificationMeta(
    'lastVoterNo',
  );
  @override
  late final GeneratedColumn<int> lastVoterNo = GeneratedColumn<int>(
    'last_voter_no',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    orgName,
    orgLogo,
    name,
    year,
    template,
    languages,
    idLabel,
    groupLabel,
    stationName,
    state,
    reviewStart,
    reviewEnd,
    schoolConsentRecorded,
    schoolConsentBy,
    schoolConsentAt,
    signedBallot,
    lastVoterNo,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'elections';
  @override
  VerificationContext validateIntegrity(
    Insertable<Election> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('org_name')) {
      context.handle(
        _orgNameMeta,
        orgName.isAcceptableOrUnknown(data['org_name']!, _orgNameMeta),
      );
    } else if (isInserting) {
      context.missing(_orgNameMeta);
    }
    if (data.containsKey('org_logo')) {
      context.handle(
        _orgLogoMeta,
        orgLogo.isAcceptableOrUnknown(data['org_logo']!, _orgLogoMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('year')) {
      context.handle(
        _yearMeta,
        year.isAcceptableOrUnknown(data['year']!, _yearMeta),
      );
    } else if (isInserting) {
      context.missing(_yearMeta);
    }
    if (data.containsKey('template')) {
      context.handle(
        _templateMeta,
        template.isAcceptableOrUnknown(data['template']!, _templateMeta),
      );
    } else if (isInserting) {
      context.missing(_templateMeta);
    }
    if (data.containsKey('languages')) {
      context.handle(
        _languagesMeta,
        languages.isAcceptableOrUnknown(data['languages']!, _languagesMeta),
      );
    } else if (isInserting) {
      context.missing(_languagesMeta);
    }
    if (data.containsKey('id_label')) {
      context.handle(
        _idLabelMeta,
        idLabel.isAcceptableOrUnknown(data['id_label']!, _idLabelMeta),
      );
    } else if (isInserting) {
      context.missing(_idLabelMeta);
    }
    if (data.containsKey('group_label')) {
      context.handle(
        _groupLabelMeta,
        groupLabel.isAcceptableOrUnknown(data['group_label']!, _groupLabelMeta),
      );
    } else if (isInserting) {
      context.missing(_groupLabelMeta);
    }
    if (data.containsKey('station_name')) {
      context.handle(
        _stationNameMeta,
        stationName.isAcceptableOrUnknown(
          data['station_name']!,
          _stationNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_stationNameMeta);
    }
    if (data.containsKey('state')) {
      context.handle(
        _stateMeta,
        state.isAcceptableOrUnknown(data['state']!, _stateMeta),
      );
    }
    if (data.containsKey('review_start')) {
      context.handle(
        _reviewStartMeta,
        reviewStart.isAcceptableOrUnknown(
          data['review_start']!,
          _reviewStartMeta,
        ),
      );
    }
    if (data.containsKey('review_end')) {
      context.handle(
        _reviewEndMeta,
        reviewEnd.isAcceptableOrUnknown(data['review_end']!, _reviewEndMeta),
      );
    }
    if (data.containsKey('school_consent_recorded')) {
      context.handle(
        _schoolConsentRecordedMeta,
        schoolConsentRecorded.isAcceptableOrUnknown(
          data['school_consent_recorded']!,
          _schoolConsentRecordedMeta,
        ),
      );
    }
    if (data.containsKey('school_consent_by')) {
      context.handle(
        _schoolConsentByMeta,
        schoolConsentBy.isAcceptableOrUnknown(
          data['school_consent_by']!,
          _schoolConsentByMeta,
        ),
      );
    }
    if (data.containsKey('school_consent_at')) {
      context.handle(
        _schoolConsentAtMeta,
        schoolConsentAt.isAcceptableOrUnknown(
          data['school_consent_at']!,
          _schoolConsentAtMeta,
        ),
      );
    }
    if (data.containsKey('signed_ballot')) {
      context.handle(
        _signedBallotMeta,
        signedBallot.isAcceptableOrUnknown(
          data['signed_ballot']!,
          _signedBallotMeta,
        ),
      );
    }
    if (data.containsKey('last_voter_no')) {
      context.handle(
        _lastVoterNoMeta,
        lastVoterNo.isAcceptableOrUnknown(
          data['last_voter_no']!,
          _lastVoterNoMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Election map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Election(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      orgName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}org_name'],
      )!,
      orgLogo: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}org_logo'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      year: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}year'],
      )!,
      template: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}template'],
      )!,
      languages: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}languages'],
      )!,
      idLabel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id_label'],
      )!,
      groupLabel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}group_label'],
      )!,
      stationName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}station_name'],
      )!,
      state: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}state'],
      )!,
      reviewStart: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}review_start'],
      ),
      reviewEnd: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}review_end'],
      ),
      schoolConsentRecorded: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}school_consent_recorded'],
      )!,
      schoolConsentBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}school_consent_by'],
      ),
      schoolConsentAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}school_consent_at'],
      ),
      signedBallot: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}signed_ballot'],
      ),
      lastVoterNo: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_voter_no'],
      )!,
    );
  }

  @override
  $ElectionsTable createAlias(String alias) {
    return $ElectionsTable(attachedDatabase, alias);
  }
}

class Election extends DataClass implements Insertable<Election> {
  final String id;
  final String orgName;
  final Uint8List? orgLogo;
  final String name;
  final int year;

  /// school | association | party_primary | blank
  final String template;

  /// JSON list of locale codes, e.g. ["en","ar","din"].
  final String languages;
  final String idLabel;
  final String groupLabel;
  final String stationName;

  /// setup | registration | review | locked | polling | closed
  final String state;
  final DateTime? reviewStart;
  final DateTime? reviewEnd;
  final bool schoolConsentRecorded;
  final String? schoolConsentBy;
  final DateTime? schoolConsentAt;

  /// Signed ballot definition (SignedArtifact JSON), set by "Save and sign ballot".
  final String? signedBallot;

  /// Last voter number handed out; numbers are never reused.
  final int lastVoterNo;
  const Election({
    required this.id,
    required this.orgName,
    this.orgLogo,
    required this.name,
    required this.year,
    required this.template,
    required this.languages,
    required this.idLabel,
    required this.groupLabel,
    required this.stationName,
    required this.state,
    this.reviewStart,
    this.reviewEnd,
    required this.schoolConsentRecorded,
    this.schoolConsentBy,
    this.schoolConsentAt,
    this.signedBallot,
    required this.lastVoterNo,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['org_name'] = Variable<String>(orgName);
    if (!nullToAbsent || orgLogo != null) {
      map['org_logo'] = Variable<Uint8List>(orgLogo);
    }
    map['name'] = Variable<String>(name);
    map['year'] = Variable<int>(year);
    map['template'] = Variable<String>(template);
    map['languages'] = Variable<String>(languages);
    map['id_label'] = Variable<String>(idLabel);
    map['group_label'] = Variable<String>(groupLabel);
    map['station_name'] = Variable<String>(stationName);
    map['state'] = Variable<String>(state);
    if (!nullToAbsent || reviewStart != null) {
      map['review_start'] = Variable<DateTime>(reviewStart);
    }
    if (!nullToAbsent || reviewEnd != null) {
      map['review_end'] = Variable<DateTime>(reviewEnd);
    }
    map['school_consent_recorded'] = Variable<bool>(schoolConsentRecorded);
    if (!nullToAbsent || schoolConsentBy != null) {
      map['school_consent_by'] = Variable<String>(schoolConsentBy);
    }
    if (!nullToAbsent || schoolConsentAt != null) {
      map['school_consent_at'] = Variable<DateTime>(schoolConsentAt);
    }
    if (!nullToAbsent || signedBallot != null) {
      map['signed_ballot'] = Variable<String>(signedBallot);
    }
    map['last_voter_no'] = Variable<int>(lastVoterNo);
    return map;
  }

  ElectionsCompanion toCompanion(bool nullToAbsent) {
    return ElectionsCompanion(
      id: Value(id),
      orgName: Value(orgName),
      orgLogo: orgLogo == null && nullToAbsent
          ? const Value.absent()
          : Value(orgLogo),
      name: Value(name),
      year: Value(year),
      template: Value(template),
      languages: Value(languages),
      idLabel: Value(idLabel),
      groupLabel: Value(groupLabel),
      stationName: Value(stationName),
      state: Value(state),
      reviewStart: reviewStart == null && nullToAbsent
          ? const Value.absent()
          : Value(reviewStart),
      reviewEnd: reviewEnd == null && nullToAbsent
          ? const Value.absent()
          : Value(reviewEnd),
      schoolConsentRecorded: Value(schoolConsentRecorded),
      schoolConsentBy: schoolConsentBy == null && nullToAbsent
          ? const Value.absent()
          : Value(schoolConsentBy),
      schoolConsentAt: schoolConsentAt == null && nullToAbsent
          ? const Value.absent()
          : Value(schoolConsentAt),
      signedBallot: signedBallot == null && nullToAbsent
          ? const Value.absent()
          : Value(signedBallot),
      lastVoterNo: Value(lastVoterNo),
    );
  }

  factory Election.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Election(
      id: serializer.fromJson<String>(json['id']),
      orgName: serializer.fromJson<String>(json['orgName']),
      orgLogo: serializer.fromJson<Uint8List?>(json['orgLogo']),
      name: serializer.fromJson<String>(json['name']),
      year: serializer.fromJson<int>(json['year']),
      template: serializer.fromJson<String>(json['template']),
      languages: serializer.fromJson<String>(json['languages']),
      idLabel: serializer.fromJson<String>(json['idLabel']),
      groupLabel: serializer.fromJson<String>(json['groupLabel']),
      stationName: serializer.fromJson<String>(json['stationName']),
      state: serializer.fromJson<String>(json['state']),
      reviewStart: serializer.fromJson<DateTime?>(json['reviewStart']),
      reviewEnd: serializer.fromJson<DateTime?>(json['reviewEnd']),
      schoolConsentRecorded: serializer.fromJson<bool>(
        json['schoolConsentRecorded'],
      ),
      schoolConsentBy: serializer.fromJson<String?>(json['schoolConsentBy']),
      schoolConsentAt: serializer.fromJson<DateTime?>(json['schoolConsentAt']),
      signedBallot: serializer.fromJson<String?>(json['signedBallot']),
      lastVoterNo: serializer.fromJson<int>(json['lastVoterNo']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'orgName': serializer.toJson<String>(orgName),
      'orgLogo': serializer.toJson<Uint8List?>(orgLogo),
      'name': serializer.toJson<String>(name),
      'year': serializer.toJson<int>(year),
      'template': serializer.toJson<String>(template),
      'languages': serializer.toJson<String>(languages),
      'idLabel': serializer.toJson<String>(idLabel),
      'groupLabel': serializer.toJson<String>(groupLabel),
      'stationName': serializer.toJson<String>(stationName),
      'state': serializer.toJson<String>(state),
      'reviewStart': serializer.toJson<DateTime?>(reviewStart),
      'reviewEnd': serializer.toJson<DateTime?>(reviewEnd),
      'schoolConsentRecorded': serializer.toJson<bool>(schoolConsentRecorded),
      'schoolConsentBy': serializer.toJson<String?>(schoolConsentBy),
      'schoolConsentAt': serializer.toJson<DateTime?>(schoolConsentAt),
      'signedBallot': serializer.toJson<String?>(signedBallot),
      'lastVoterNo': serializer.toJson<int>(lastVoterNo),
    };
  }

  Election copyWith({
    String? id,
    String? orgName,
    Value<Uint8List?> orgLogo = const Value.absent(),
    String? name,
    int? year,
    String? template,
    String? languages,
    String? idLabel,
    String? groupLabel,
    String? stationName,
    String? state,
    Value<DateTime?> reviewStart = const Value.absent(),
    Value<DateTime?> reviewEnd = const Value.absent(),
    bool? schoolConsentRecorded,
    Value<String?> schoolConsentBy = const Value.absent(),
    Value<DateTime?> schoolConsentAt = const Value.absent(),
    Value<String?> signedBallot = const Value.absent(),
    int? lastVoterNo,
  }) => Election(
    id: id ?? this.id,
    orgName: orgName ?? this.orgName,
    orgLogo: orgLogo.present ? orgLogo.value : this.orgLogo,
    name: name ?? this.name,
    year: year ?? this.year,
    template: template ?? this.template,
    languages: languages ?? this.languages,
    idLabel: idLabel ?? this.idLabel,
    groupLabel: groupLabel ?? this.groupLabel,
    stationName: stationName ?? this.stationName,
    state: state ?? this.state,
    reviewStart: reviewStart.present ? reviewStart.value : this.reviewStart,
    reviewEnd: reviewEnd.present ? reviewEnd.value : this.reviewEnd,
    schoolConsentRecorded: schoolConsentRecorded ?? this.schoolConsentRecorded,
    schoolConsentBy: schoolConsentBy.present
        ? schoolConsentBy.value
        : this.schoolConsentBy,
    schoolConsentAt: schoolConsentAt.present
        ? schoolConsentAt.value
        : this.schoolConsentAt,
    signedBallot: signedBallot.present ? signedBallot.value : this.signedBallot,
    lastVoterNo: lastVoterNo ?? this.lastVoterNo,
  );
  Election copyWithCompanion(ElectionsCompanion data) {
    return Election(
      id: data.id.present ? data.id.value : this.id,
      orgName: data.orgName.present ? data.orgName.value : this.orgName,
      orgLogo: data.orgLogo.present ? data.orgLogo.value : this.orgLogo,
      name: data.name.present ? data.name.value : this.name,
      year: data.year.present ? data.year.value : this.year,
      template: data.template.present ? data.template.value : this.template,
      languages: data.languages.present ? data.languages.value : this.languages,
      idLabel: data.idLabel.present ? data.idLabel.value : this.idLabel,
      groupLabel: data.groupLabel.present
          ? data.groupLabel.value
          : this.groupLabel,
      stationName: data.stationName.present
          ? data.stationName.value
          : this.stationName,
      state: data.state.present ? data.state.value : this.state,
      reviewStart: data.reviewStart.present
          ? data.reviewStart.value
          : this.reviewStart,
      reviewEnd: data.reviewEnd.present ? data.reviewEnd.value : this.reviewEnd,
      schoolConsentRecorded: data.schoolConsentRecorded.present
          ? data.schoolConsentRecorded.value
          : this.schoolConsentRecorded,
      schoolConsentBy: data.schoolConsentBy.present
          ? data.schoolConsentBy.value
          : this.schoolConsentBy,
      schoolConsentAt: data.schoolConsentAt.present
          ? data.schoolConsentAt.value
          : this.schoolConsentAt,
      signedBallot: data.signedBallot.present
          ? data.signedBallot.value
          : this.signedBallot,
      lastVoterNo: data.lastVoterNo.present
          ? data.lastVoterNo.value
          : this.lastVoterNo,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Election(')
          ..write('id: $id, ')
          ..write('orgName: $orgName, ')
          ..write('orgLogo: $orgLogo, ')
          ..write('name: $name, ')
          ..write('year: $year, ')
          ..write('template: $template, ')
          ..write('languages: $languages, ')
          ..write('idLabel: $idLabel, ')
          ..write('groupLabel: $groupLabel, ')
          ..write('stationName: $stationName, ')
          ..write('state: $state, ')
          ..write('reviewStart: $reviewStart, ')
          ..write('reviewEnd: $reviewEnd, ')
          ..write('schoolConsentRecorded: $schoolConsentRecorded, ')
          ..write('schoolConsentBy: $schoolConsentBy, ')
          ..write('schoolConsentAt: $schoolConsentAt, ')
          ..write('signedBallot: $signedBallot, ')
          ..write('lastVoterNo: $lastVoterNo')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    orgName,
    $driftBlobEquality.hash(orgLogo),
    name,
    year,
    template,
    languages,
    idLabel,
    groupLabel,
    stationName,
    state,
    reviewStart,
    reviewEnd,
    schoolConsentRecorded,
    schoolConsentBy,
    schoolConsentAt,
    signedBallot,
    lastVoterNo,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Election &&
          other.id == this.id &&
          other.orgName == this.orgName &&
          $driftBlobEquality.equals(other.orgLogo, this.orgLogo) &&
          other.name == this.name &&
          other.year == this.year &&
          other.template == this.template &&
          other.languages == this.languages &&
          other.idLabel == this.idLabel &&
          other.groupLabel == this.groupLabel &&
          other.stationName == this.stationName &&
          other.state == this.state &&
          other.reviewStart == this.reviewStart &&
          other.reviewEnd == this.reviewEnd &&
          other.schoolConsentRecorded == this.schoolConsentRecorded &&
          other.schoolConsentBy == this.schoolConsentBy &&
          other.schoolConsentAt == this.schoolConsentAt &&
          other.signedBallot == this.signedBallot &&
          other.lastVoterNo == this.lastVoterNo);
}

class ElectionsCompanion extends UpdateCompanion<Election> {
  final Value<String> id;
  final Value<String> orgName;
  final Value<Uint8List?> orgLogo;
  final Value<String> name;
  final Value<int> year;
  final Value<String> template;
  final Value<String> languages;
  final Value<String> idLabel;
  final Value<String> groupLabel;
  final Value<String> stationName;
  final Value<String> state;
  final Value<DateTime?> reviewStart;
  final Value<DateTime?> reviewEnd;
  final Value<bool> schoolConsentRecorded;
  final Value<String?> schoolConsentBy;
  final Value<DateTime?> schoolConsentAt;
  final Value<String?> signedBallot;
  final Value<int> lastVoterNo;
  final Value<int> rowid;
  const ElectionsCompanion({
    this.id = const Value.absent(),
    this.orgName = const Value.absent(),
    this.orgLogo = const Value.absent(),
    this.name = const Value.absent(),
    this.year = const Value.absent(),
    this.template = const Value.absent(),
    this.languages = const Value.absent(),
    this.idLabel = const Value.absent(),
    this.groupLabel = const Value.absent(),
    this.stationName = const Value.absent(),
    this.state = const Value.absent(),
    this.reviewStart = const Value.absent(),
    this.reviewEnd = const Value.absent(),
    this.schoolConsentRecorded = const Value.absent(),
    this.schoolConsentBy = const Value.absent(),
    this.schoolConsentAt = const Value.absent(),
    this.signedBallot = const Value.absent(),
    this.lastVoterNo = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ElectionsCompanion.insert({
    required String id,
    required String orgName,
    this.orgLogo = const Value.absent(),
    required String name,
    required int year,
    required String template,
    required String languages,
    required String idLabel,
    required String groupLabel,
    required String stationName,
    this.state = const Value.absent(),
    this.reviewStart = const Value.absent(),
    this.reviewEnd = const Value.absent(),
    this.schoolConsentRecorded = const Value.absent(),
    this.schoolConsentBy = const Value.absent(),
    this.schoolConsentAt = const Value.absent(),
    this.signedBallot = const Value.absent(),
    this.lastVoterNo = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       orgName = Value(orgName),
       name = Value(name),
       year = Value(year),
       template = Value(template),
       languages = Value(languages),
       idLabel = Value(idLabel),
       groupLabel = Value(groupLabel),
       stationName = Value(stationName);
  static Insertable<Election> custom({
    Expression<String>? id,
    Expression<String>? orgName,
    Expression<Uint8List>? orgLogo,
    Expression<String>? name,
    Expression<int>? year,
    Expression<String>? template,
    Expression<String>? languages,
    Expression<String>? idLabel,
    Expression<String>? groupLabel,
    Expression<String>? stationName,
    Expression<String>? state,
    Expression<DateTime>? reviewStart,
    Expression<DateTime>? reviewEnd,
    Expression<bool>? schoolConsentRecorded,
    Expression<String>? schoolConsentBy,
    Expression<DateTime>? schoolConsentAt,
    Expression<String>? signedBallot,
    Expression<int>? lastVoterNo,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (orgName != null) 'org_name': orgName,
      if (orgLogo != null) 'org_logo': orgLogo,
      if (name != null) 'name': name,
      if (year != null) 'year': year,
      if (template != null) 'template': template,
      if (languages != null) 'languages': languages,
      if (idLabel != null) 'id_label': idLabel,
      if (groupLabel != null) 'group_label': groupLabel,
      if (stationName != null) 'station_name': stationName,
      if (state != null) 'state': state,
      if (reviewStart != null) 'review_start': reviewStart,
      if (reviewEnd != null) 'review_end': reviewEnd,
      if (schoolConsentRecorded != null)
        'school_consent_recorded': schoolConsentRecorded,
      if (schoolConsentBy != null) 'school_consent_by': schoolConsentBy,
      if (schoolConsentAt != null) 'school_consent_at': schoolConsentAt,
      if (signedBallot != null) 'signed_ballot': signedBallot,
      if (lastVoterNo != null) 'last_voter_no': lastVoterNo,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ElectionsCompanion copyWith({
    Value<String>? id,
    Value<String>? orgName,
    Value<Uint8List?>? orgLogo,
    Value<String>? name,
    Value<int>? year,
    Value<String>? template,
    Value<String>? languages,
    Value<String>? idLabel,
    Value<String>? groupLabel,
    Value<String>? stationName,
    Value<String>? state,
    Value<DateTime?>? reviewStart,
    Value<DateTime?>? reviewEnd,
    Value<bool>? schoolConsentRecorded,
    Value<String?>? schoolConsentBy,
    Value<DateTime?>? schoolConsentAt,
    Value<String?>? signedBallot,
    Value<int>? lastVoterNo,
    Value<int>? rowid,
  }) {
    return ElectionsCompanion(
      id: id ?? this.id,
      orgName: orgName ?? this.orgName,
      orgLogo: orgLogo ?? this.orgLogo,
      name: name ?? this.name,
      year: year ?? this.year,
      template: template ?? this.template,
      languages: languages ?? this.languages,
      idLabel: idLabel ?? this.idLabel,
      groupLabel: groupLabel ?? this.groupLabel,
      stationName: stationName ?? this.stationName,
      state: state ?? this.state,
      reviewStart: reviewStart ?? this.reviewStart,
      reviewEnd: reviewEnd ?? this.reviewEnd,
      schoolConsentRecorded:
          schoolConsentRecorded ?? this.schoolConsentRecorded,
      schoolConsentBy: schoolConsentBy ?? this.schoolConsentBy,
      schoolConsentAt: schoolConsentAt ?? this.schoolConsentAt,
      signedBallot: signedBallot ?? this.signedBallot,
      lastVoterNo: lastVoterNo ?? this.lastVoterNo,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (orgName.present) {
      map['org_name'] = Variable<String>(orgName.value);
    }
    if (orgLogo.present) {
      map['org_logo'] = Variable<Uint8List>(orgLogo.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (year.present) {
      map['year'] = Variable<int>(year.value);
    }
    if (template.present) {
      map['template'] = Variable<String>(template.value);
    }
    if (languages.present) {
      map['languages'] = Variable<String>(languages.value);
    }
    if (idLabel.present) {
      map['id_label'] = Variable<String>(idLabel.value);
    }
    if (groupLabel.present) {
      map['group_label'] = Variable<String>(groupLabel.value);
    }
    if (stationName.present) {
      map['station_name'] = Variable<String>(stationName.value);
    }
    if (state.present) {
      map['state'] = Variable<String>(state.value);
    }
    if (reviewStart.present) {
      map['review_start'] = Variable<DateTime>(reviewStart.value);
    }
    if (reviewEnd.present) {
      map['review_end'] = Variable<DateTime>(reviewEnd.value);
    }
    if (schoolConsentRecorded.present) {
      map['school_consent_recorded'] = Variable<bool>(
        schoolConsentRecorded.value,
      );
    }
    if (schoolConsentBy.present) {
      map['school_consent_by'] = Variable<String>(schoolConsentBy.value);
    }
    if (schoolConsentAt.present) {
      map['school_consent_at'] = Variable<DateTime>(schoolConsentAt.value);
    }
    if (signedBallot.present) {
      map['signed_ballot'] = Variable<String>(signedBallot.value);
    }
    if (lastVoterNo.present) {
      map['last_voter_no'] = Variable<int>(lastVoterNo.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ElectionsCompanion(')
          ..write('id: $id, ')
          ..write('orgName: $orgName, ')
          ..write('orgLogo: $orgLogo, ')
          ..write('name: $name, ')
          ..write('year: $year, ')
          ..write('template: $template, ')
          ..write('languages: $languages, ')
          ..write('idLabel: $idLabel, ')
          ..write('groupLabel: $groupLabel, ')
          ..write('stationName: $stationName, ')
          ..write('state: $state, ')
          ..write('reviewStart: $reviewStart, ')
          ..write('reviewEnd: $reviewEnd, ')
          ..write('schoolConsentRecorded: $schoolConsentRecorded, ')
          ..write('schoolConsentBy: $schoolConsentBy, ')
          ..write('schoolConsentAt: $schoolConsentAt, ')
          ..write('signedBallot: $signedBallot, ')
          ..write('lastVoterNo: $lastVoterNo, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FeeConfigsTable extends FeeConfigs
    with TableInfo<$FeeConfigsTable, FeeConfig> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FeeConfigsTable(this.attachedDatabase, [this._alias]);
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
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES elections (id)',
    ),
  );
  static const VerificationMeta _enabledMeta = const VerificationMeta(
    'enabled',
  );
  @override
  late final GeneratedColumn<bool> enabled = GeneratedColumn<bool>(
    'enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("enabled" IN (0, 1))',
    ),
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('SSP'),
  );
  static const VerificationMeta _unpaidPolicyMeta = const VerificationMeta(
    'unpaidPolicy',
  );
  @override
  late final GeneratedColumn<String> unpaidPolicy = GeneratedColumn<String>(
    'unpaid_policy',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('block'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    electionId,
    enabled,
    amount,
    currency,
    unpaidPolicy,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'fee_configs';
  @override
  VerificationContext validateIntegrity(
    Insertable<FeeConfig> instance, {
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
    if (data.containsKey('enabled')) {
      context.handle(
        _enabledMeta,
        enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta),
      );
    } else if (isInserting) {
      context.missing(_enabledMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    }
    if (data.containsKey('unpaid_policy')) {
      context.handle(
        _unpaidPolicyMeta,
        unpaidPolicy.isAcceptableOrUnknown(
          data['unpaid_policy']!,
          _unpaidPolicyMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {electionId};
  @override
  FeeConfig map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FeeConfig(
      electionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}election_id'],
      )!,
      enabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}enabled'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount'],
      )!,
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      unpaidPolicy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unpaid_policy'],
      )!,
    );
  }

  @override
  $FeeConfigsTable createAlias(String alias) {
    return $FeeConfigsTable(attachedDatabase, alias);
  }
}

class FeeConfig extends DataClass implements Insertable<FeeConfig> {
  final String electionId;
  final bool enabled;

  /// Whole currency units (SSP and USD fees are whole numbers in practice).
  final int amount;

  /// SSP | USD | EITHER
  final String currency;

  /// block | allow_flagged
  final String unpaidPolicy;
  const FeeConfig({
    required this.electionId,
    required this.enabled,
    required this.amount,
    required this.currency,
    required this.unpaidPolicy,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['election_id'] = Variable<String>(electionId);
    map['enabled'] = Variable<bool>(enabled);
    map['amount'] = Variable<int>(amount);
    map['currency'] = Variable<String>(currency);
    map['unpaid_policy'] = Variable<String>(unpaidPolicy);
    return map;
  }

  FeeConfigsCompanion toCompanion(bool nullToAbsent) {
    return FeeConfigsCompanion(
      electionId: Value(electionId),
      enabled: Value(enabled),
      amount: Value(amount),
      currency: Value(currency),
      unpaidPolicy: Value(unpaidPolicy),
    );
  }

  factory FeeConfig.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FeeConfig(
      electionId: serializer.fromJson<String>(json['electionId']),
      enabled: serializer.fromJson<bool>(json['enabled']),
      amount: serializer.fromJson<int>(json['amount']),
      currency: serializer.fromJson<String>(json['currency']),
      unpaidPolicy: serializer.fromJson<String>(json['unpaidPolicy']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'electionId': serializer.toJson<String>(electionId),
      'enabled': serializer.toJson<bool>(enabled),
      'amount': serializer.toJson<int>(amount),
      'currency': serializer.toJson<String>(currency),
      'unpaidPolicy': serializer.toJson<String>(unpaidPolicy),
    };
  }

  FeeConfig copyWith({
    String? electionId,
    bool? enabled,
    int? amount,
    String? currency,
    String? unpaidPolicy,
  }) => FeeConfig(
    electionId: electionId ?? this.electionId,
    enabled: enabled ?? this.enabled,
    amount: amount ?? this.amount,
    currency: currency ?? this.currency,
    unpaidPolicy: unpaidPolicy ?? this.unpaidPolicy,
  );
  FeeConfig copyWithCompanion(FeeConfigsCompanion data) {
    return FeeConfig(
      electionId: data.electionId.present
          ? data.electionId.value
          : this.electionId,
      enabled: data.enabled.present ? data.enabled.value : this.enabled,
      amount: data.amount.present ? data.amount.value : this.amount,
      currency: data.currency.present ? data.currency.value : this.currency,
      unpaidPolicy: data.unpaidPolicy.present
          ? data.unpaidPolicy.value
          : this.unpaidPolicy,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FeeConfig(')
          ..write('electionId: $electionId, ')
          ..write('enabled: $enabled, ')
          ..write('amount: $amount, ')
          ..write('currency: $currency, ')
          ..write('unpaidPolicy: $unpaidPolicy')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(electionId, enabled, amount, currency, unpaidPolicy);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FeeConfig &&
          other.electionId == this.electionId &&
          other.enabled == this.enabled &&
          other.amount == this.amount &&
          other.currency == this.currency &&
          other.unpaidPolicy == this.unpaidPolicy);
}

class FeeConfigsCompanion extends UpdateCompanion<FeeConfig> {
  final Value<String> electionId;
  final Value<bool> enabled;
  final Value<int> amount;
  final Value<String> currency;
  final Value<String> unpaidPolicy;
  final Value<int> rowid;
  const FeeConfigsCompanion({
    this.electionId = const Value.absent(),
    this.enabled = const Value.absent(),
    this.amount = const Value.absent(),
    this.currency = const Value.absent(),
    this.unpaidPolicy = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FeeConfigsCompanion.insert({
    required String electionId,
    required bool enabled,
    this.amount = const Value.absent(),
    this.currency = const Value.absent(),
    this.unpaidPolicy = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : electionId = Value(electionId),
       enabled = Value(enabled);
  static Insertable<FeeConfig> custom({
    Expression<String>? electionId,
    Expression<bool>? enabled,
    Expression<int>? amount,
    Expression<String>? currency,
    Expression<String>? unpaidPolicy,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (electionId != null) 'election_id': electionId,
      if (enabled != null) 'enabled': enabled,
      if (amount != null) 'amount': amount,
      if (currency != null) 'currency': currency,
      if (unpaidPolicy != null) 'unpaid_policy': unpaidPolicy,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FeeConfigsCompanion copyWith({
    Value<String>? electionId,
    Value<bool>? enabled,
    Value<int>? amount,
    Value<String>? currency,
    Value<String>? unpaidPolicy,
    Value<int>? rowid,
  }) {
    return FeeConfigsCompanion(
      electionId: electionId ?? this.electionId,
      enabled: enabled ?? this.enabled,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      unpaidPolicy: unpaidPolicy ?? this.unpaidPolicy,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (electionId.present) {
      map['election_id'] = Variable<String>(electionId.value);
    }
    if (enabled.present) {
      map['enabled'] = Variable<bool>(enabled.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (unpaidPolicy.present) {
      map['unpaid_policy'] = Variable<String>(unpaidPolicy.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FeeConfigsCompanion(')
          ..write('electionId: $electionId, ')
          ..write('enabled: $enabled, ')
          ..write('amount: $amount, ')
          ..write('currency: $currency, ')
          ..write('unpaidPolicy: $unpaidPolicy, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PositionsTable extends Positions
    with TableInfo<$PositionsTable, Position> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PositionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
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
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES elections (id)',
    ),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titlesMeta = const VerificationMeta('titles');
  @override
  late final GeneratedColumn<String> titles = GeneratedColumn<String>(
    'titles',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colourMeta = const VerificationMeta('colour');
  @override
  late final GeneratedColumn<int> colour = GeneratedColumn<int>(
    'colour',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _chooseNMeta = const VerificationMeta(
    'chooseN',
  );
  @override
  late final GeneratedColumn<int> chooseN = GeneratedColumn<int>(
    'choose_n',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _allowNoChoiceMeta = const VerificationMeta(
    'allowNoChoice',
  );
  @override
  late final GeneratedColumn<bool> allowNoChoice = GeneratedColumn<bool>(
    'allow_no_choice',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("allow_no_choice" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    electionId,
    sortOrder,
    titles,
    colour,
    chooseN,
    allowNoChoice,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'positions';
  @override
  VerificationContext validateIntegrity(
    Insertable<Position> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('election_id')) {
      context.handle(
        _electionIdMeta,
        electionId.isAcceptableOrUnknown(data['election_id']!, _electionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_electionIdMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    if (data.containsKey('titles')) {
      context.handle(
        _titlesMeta,
        titles.isAcceptableOrUnknown(data['titles']!, _titlesMeta),
      );
    } else if (isInserting) {
      context.missing(_titlesMeta);
    }
    if (data.containsKey('colour')) {
      context.handle(
        _colourMeta,
        colour.isAcceptableOrUnknown(data['colour']!, _colourMeta),
      );
    } else if (isInserting) {
      context.missing(_colourMeta);
    }
    if (data.containsKey('choose_n')) {
      context.handle(
        _chooseNMeta,
        chooseN.isAcceptableOrUnknown(data['choose_n']!, _chooseNMeta),
      );
    }
    if (data.containsKey('allow_no_choice')) {
      context.handle(
        _allowNoChoiceMeta,
        allowNoChoice.isAcceptableOrUnknown(
          data['allow_no_choice']!,
          _allowNoChoiceMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Position map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Position(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      electionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}election_id'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      titles: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}titles'],
      )!,
      colour: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}colour'],
      )!,
      chooseN: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}choose_n'],
      )!,
      allowNoChoice: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}allow_no_choice'],
      )!,
    );
  }

  @override
  $PositionsTable createAlias(String alias) {
    return $PositionsTable(attachedDatabase, alias);
  }
}

class Position extends DataClass implements Insertable<Position> {
  final String id;
  final String electionId;
  final int sortOrder;

  /// JSON map locale -> title, e.g. {"en":"Chairman","ar":"الرئيس"}.
  final String titles;

  /// ARGB colour chosen in setup (contrast-checked).
  final int colour;
  final int chooseN;
  final bool allowNoChoice;
  const Position({
    required this.id,
    required this.electionId,
    required this.sortOrder,
    required this.titles,
    required this.colour,
    required this.chooseN,
    required this.allowNoChoice,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['election_id'] = Variable<String>(electionId);
    map['sort_order'] = Variable<int>(sortOrder);
    map['titles'] = Variable<String>(titles);
    map['colour'] = Variable<int>(colour);
    map['choose_n'] = Variable<int>(chooseN);
    map['allow_no_choice'] = Variable<bool>(allowNoChoice);
    return map;
  }

  PositionsCompanion toCompanion(bool nullToAbsent) {
    return PositionsCompanion(
      id: Value(id),
      electionId: Value(electionId),
      sortOrder: Value(sortOrder),
      titles: Value(titles),
      colour: Value(colour),
      chooseN: Value(chooseN),
      allowNoChoice: Value(allowNoChoice),
    );
  }

  factory Position.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Position(
      id: serializer.fromJson<String>(json['id']),
      electionId: serializer.fromJson<String>(json['electionId']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      titles: serializer.fromJson<String>(json['titles']),
      colour: serializer.fromJson<int>(json['colour']),
      chooseN: serializer.fromJson<int>(json['chooseN']),
      allowNoChoice: serializer.fromJson<bool>(json['allowNoChoice']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'electionId': serializer.toJson<String>(electionId),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'titles': serializer.toJson<String>(titles),
      'colour': serializer.toJson<int>(colour),
      'chooseN': serializer.toJson<int>(chooseN),
      'allowNoChoice': serializer.toJson<bool>(allowNoChoice),
    };
  }

  Position copyWith({
    String? id,
    String? electionId,
    int? sortOrder,
    String? titles,
    int? colour,
    int? chooseN,
    bool? allowNoChoice,
  }) => Position(
    id: id ?? this.id,
    electionId: electionId ?? this.electionId,
    sortOrder: sortOrder ?? this.sortOrder,
    titles: titles ?? this.titles,
    colour: colour ?? this.colour,
    chooseN: chooseN ?? this.chooseN,
    allowNoChoice: allowNoChoice ?? this.allowNoChoice,
  );
  Position copyWithCompanion(PositionsCompanion data) {
    return Position(
      id: data.id.present ? data.id.value : this.id,
      electionId: data.electionId.present
          ? data.electionId.value
          : this.electionId,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      titles: data.titles.present ? data.titles.value : this.titles,
      colour: data.colour.present ? data.colour.value : this.colour,
      chooseN: data.chooseN.present ? data.chooseN.value : this.chooseN,
      allowNoChoice: data.allowNoChoice.present
          ? data.allowNoChoice.value
          : this.allowNoChoice,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Position(')
          ..write('id: $id, ')
          ..write('electionId: $electionId, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('titles: $titles, ')
          ..write('colour: $colour, ')
          ..write('chooseN: $chooseN, ')
          ..write('allowNoChoice: $allowNoChoice')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    electionId,
    sortOrder,
    titles,
    colour,
    chooseN,
    allowNoChoice,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Position &&
          other.id == this.id &&
          other.electionId == this.electionId &&
          other.sortOrder == this.sortOrder &&
          other.titles == this.titles &&
          other.colour == this.colour &&
          other.chooseN == this.chooseN &&
          other.allowNoChoice == this.allowNoChoice);
}

class PositionsCompanion extends UpdateCompanion<Position> {
  final Value<String> id;
  final Value<String> electionId;
  final Value<int> sortOrder;
  final Value<String> titles;
  final Value<int> colour;
  final Value<int> chooseN;
  final Value<bool> allowNoChoice;
  final Value<int> rowid;
  const PositionsCompanion({
    this.id = const Value.absent(),
    this.electionId = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.titles = const Value.absent(),
    this.colour = const Value.absent(),
    this.chooseN = const Value.absent(),
    this.allowNoChoice = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PositionsCompanion.insert({
    required String id,
    required String electionId,
    required int sortOrder,
    required String titles,
    required int colour,
    this.chooseN = const Value.absent(),
    this.allowNoChoice = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       electionId = Value(electionId),
       sortOrder = Value(sortOrder),
       titles = Value(titles),
       colour = Value(colour);
  static Insertable<Position> custom({
    Expression<String>? id,
    Expression<String>? electionId,
    Expression<int>? sortOrder,
    Expression<String>? titles,
    Expression<int>? colour,
    Expression<int>? chooseN,
    Expression<bool>? allowNoChoice,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (electionId != null) 'election_id': electionId,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (titles != null) 'titles': titles,
      if (colour != null) 'colour': colour,
      if (chooseN != null) 'choose_n': chooseN,
      if (allowNoChoice != null) 'allow_no_choice': allowNoChoice,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PositionsCompanion copyWith({
    Value<String>? id,
    Value<String>? electionId,
    Value<int>? sortOrder,
    Value<String>? titles,
    Value<int>? colour,
    Value<int>? chooseN,
    Value<bool>? allowNoChoice,
    Value<int>? rowid,
  }) {
    return PositionsCompanion(
      id: id ?? this.id,
      electionId: electionId ?? this.electionId,
      sortOrder: sortOrder ?? this.sortOrder,
      titles: titles ?? this.titles,
      colour: colour ?? this.colour,
      chooseN: chooseN ?? this.chooseN,
      allowNoChoice: allowNoChoice ?? this.allowNoChoice,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (electionId.present) {
      map['election_id'] = Variable<String>(electionId.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (titles.present) {
      map['titles'] = Variable<String>(titles.value);
    }
    if (colour.present) {
      map['colour'] = Variable<int>(colour.value);
    }
    if (chooseN.present) {
      map['choose_n'] = Variable<int>(chooseN.value);
    }
    if (allowNoChoice.present) {
      map['allow_no_choice'] = Variable<bool>(allowNoChoice.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PositionsCompanion(')
          ..write('id: $id, ')
          ..write('electionId: $electionId, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('titles: $titles, ')
          ..write('colour: $colour, ')
          ..write('chooseN: $chooseN, ')
          ..write('allowNoChoice: $allowNoChoice, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CandidatesTable extends Candidates
    with TableInfo<$CandidatesTable, Candidate> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CandidatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
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
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES positions (id)',
    ),
  );
  static const VerificationMeta _numberMeta = const VerificationMeta('number');
  @override
  late final GeneratedColumn<int> number = GeneratedColumn<int>(
    'number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _photoMeta = const VerificationMeta('photo');
  @override
  late final GeneratedColumn<Uint8List> photo = GeneratedColumn<Uint8List>(
    'photo',
    aliasedName,
    true,
    type: DriftSqlType.blob,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _symbolMeta = const VerificationMeta('symbol');
  @override
  late final GeneratedColumn<Uint8List> symbol = GeneratedColumn<Uint8List>(
    'symbol',
    aliasedName,
    true,
    type: DriftSqlType.blob,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    positionId,
    number,
    name,
    photo,
    symbol,
    sortOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'candidates';
  @override
  VerificationContext validateIntegrity(
    Insertable<Candidate> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('position_id')) {
      context.handle(
        _positionIdMeta,
        positionId.isAcceptableOrUnknown(data['position_id']!, _positionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_positionIdMeta);
    }
    if (data.containsKey('number')) {
      context.handle(
        _numberMeta,
        number.isAcceptableOrUnknown(data['number']!, _numberMeta),
      );
    } else if (isInserting) {
      context.missing(_numberMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('photo')) {
      context.handle(
        _photoMeta,
        photo.isAcceptableOrUnknown(data['photo']!, _photoMeta),
      );
    }
    if (data.containsKey('symbol')) {
      context.handle(
        _symbolMeta,
        symbol.isAcceptableOrUnknown(data['symbol']!, _symbolMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {positionId, number},
  ];
  @override
  Candidate map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Candidate(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      positionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}position_id'],
      )!,
      number: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}number'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      photo: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}photo'],
      ),
      symbol: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}symbol'],
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $CandidatesTable createAlias(String alias) {
    return $CandidatesTable(attachedDatabase, alias);
  }
}

class Candidate extends DataClass implements Insertable<Candidate> {
  final String id;
  final String positionId;
  final int number;
  final String name;
  final Uint8List? photo;
  final Uint8List? symbol;
  final int sortOrder;
  const Candidate({
    required this.id,
    required this.positionId,
    required this.number,
    required this.name,
    this.photo,
    this.symbol,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['position_id'] = Variable<String>(positionId);
    map['number'] = Variable<int>(number);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || photo != null) {
      map['photo'] = Variable<Uint8List>(photo);
    }
    if (!nullToAbsent || symbol != null) {
      map['symbol'] = Variable<Uint8List>(symbol);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  CandidatesCompanion toCompanion(bool nullToAbsent) {
    return CandidatesCompanion(
      id: Value(id),
      positionId: Value(positionId),
      number: Value(number),
      name: Value(name),
      photo: photo == null && nullToAbsent
          ? const Value.absent()
          : Value(photo),
      symbol: symbol == null && nullToAbsent
          ? const Value.absent()
          : Value(symbol),
      sortOrder: Value(sortOrder),
    );
  }

  factory Candidate.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Candidate(
      id: serializer.fromJson<String>(json['id']),
      positionId: serializer.fromJson<String>(json['positionId']),
      number: serializer.fromJson<int>(json['number']),
      name: serializer.fromJson<String>(json['name']),
      photo: serializer.fromJson<Uint8List?>(json['photo']),
      symbol: serializer.fromJson<Uint8List?>(json['symbol']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'positionId': serializer.toJson<String>(positionId),
      'number': serializer.toJson<int>(number),
      'name': serializer.toJson<String>(name),
      'photo': serializer.toJson<Uint8List?>(photo),
      'symbol': serializer.toJson<Uint8List?>(symbol),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  Candidate copyWith({
    String? id,
    String? positionId,
    int? number,
    String? name,
    Value<Uint8List?> photo = const Value.absent(),
    Value<Uint8List?> symbol = const Value.absent(),
    int? sortOrder,
  }) => Candidate(
    id: id ?? this.id,
    positionId: positionId ?? this.positionId,
    number: number ?? this.number,
    name: name ?? this.name,
    photo: photo.present ? photo.value : this.photo,
    symbol: symbol.present ? symbol.value : this.symbol,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  Candidate copyWithCompanion(CandidatesCompanion data) {
    return Candidate(
      id: data.id.present ? data.id.value : this.id,
      positionId: data.positionId.present
          ? data.positionId.value
          : this.positionId,
      number: data.number.present ? data.number.value : this.number,
      name: data.name.present ? data.name.value : this.name,
      photo: data.photo.present ? data.photo.value : this.photo,
      symbol: data.symbol.present ? data.symbol.value : this.symbol,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Candidate(')
          ..write('id: $id, ')
          ..write('positionId: $positionId, ')
          ..write('number: $number, ')
          ..write('name: $name, ')
          ..write('photo: $photo, ')
          ..write('symbol: $symbol, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    positionId,
    number,
    name,
    $driftBlobEquality.hash(photo),
    $driftBlobEquality.hash(symbol),
    sortOrder,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Candidate &&
          other.id == this.id &&
          other.positionId == this.positionId &&
          other.number == this.number &&
          other.name == this.name &&
          $driftBlobEquality.equals(other.photo, this.photo) &&
          $driftBlobEquality.equals(other.symbol, this.symbol) &&
          other.sortOrder == this.sortOrder);
}

class CandidatesCompanion extends UpdateCompanion<Candidate> {
  final Value<String> id;
  final Value<String> positionId;
  final Value<int> number;
  final Value<String> name;
  final Value<Uint8List?> photo;
  final Value<Uint8List?> symbol;
  final Value<int> sortOrder;
  final Value<int> rowid;
  const CandidatesCompanion({
    this.id = const Value.absent(),
    this.positionId = const Value.absent(),
    this.number = const Value.absent(),
    this.name = const Value.absent(),
    this.photo = const Value.absent(),
    this.symbol = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CandidatesCompanion.insert({
    required String id,
    required String positionId,
    required int number,
    required String name,
    this.photo = const Value.absent(),
    this.symbol = const Value.absent(),
    required int sortOrder,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       positionId = Value(positionId),
       number = Value(number),
       name = Value(name),
       sortOrder = Value(sortOrder);
  static Insertable<Candidate> custom({
    Expression<String>? id,
    Expression<String>? positionId,
    Expression<int>? number,
    Expression<String>? name,
    Expression<Uint8List>? photo,
    Expression<Uint8List>? symbol,
    Expression<int>? sortOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (positionId != null) 'position_id': positionId,
      if (number != null) 'number': number,
      if (name != null) 'name': name,
      if (photo != null) 'photo': photo,
      if (symbol != null) 'symbol': symbol,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CandidatesCompanion copyWith({
    Value<String>? id,
    Value<String>? positionId,
    Value<int>? number,
    Value<String>? name,
    Value<Uint8List?>? photo,
    Value<Uint8List?>? symbol,
    Value<int>? sortOrder,
    Value<int>? rowid,
  }) {
    return CandidatesCompanion(
      id: id ?? this.id,
      positionId: positionId ?? this.positionId,
      number: number ?? this.number,
      name: name ?? this.name,
      photo: photo ?? this.photo,
      symbol: symbol ?? this.symbol,
      sortOrder: sortOrder ?? this.sortOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (positionId.present) {
      map['position_id'] = Variable<String>(positionId.value);
    }
    if (number.present) {
      map['number'] = Variable<int>(number.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (photo.present) {
      map['photo'] = Variable<Uint8List>(photo.value);
    }
    if (symbol.present) {
      map['symbol'] = Variable<Uint8List>(symbol.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CandidatesCompanion(')
          ..write('id: $id, ')
          ..write('positionId: $positionId, ')
          ..write('number: $number, ')
          ..write('name: $name, ')
          ..write('photo: $photo, ')
          ..write('symbol: $symbol, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $VotersTable extends Voters with TableInfo<$VotersTable, Voter> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VotersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
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
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES elections (id)',
    ),
  );
  static const VerificationMeta _voterNoMeta = const VerificationMeta(
    'voterNo',
  );
  @override
  late final GeneratedColumn<int> voterNo = GeneratedColumn<int>(
    'voter_no',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fullNameMeta = const VerificationMeta(
    'fullName',
  );
  @override
  late final GeneratedColumn<String> fullName = GeneratedColumn<String>(
    'full_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _memberIdMeta = const VerificationMeta(
    'memberId',
  );
  @override
  late final GeneratedColumn<String> memberId = GeneratedColumn<String>(
    'member_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _groupNameMeta = const VerificationMeta(
    'groupName',
  );
  @override
  late final GeneratedColumn<String> groupName = GeneratedColumn<String>(
    'group_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _photoMeta = const VerificationMeta('photo');
  @override
  late final GeneratedColumn<Uint8List> photo = GeneratedColumn<Uint8List>(
    'photo',
    aliasedName,
    true,
    type: DriftSqlType.blob,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cardIssueMeta = const VerificationMeta(
    'cardIssue',
  );
  @override
  late final GeneratedColumn<int> cardIssue = GeneratedColumn<int>(
    'card_issue',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _registeredOnMeta = const VerificationMeta(
    'registeredOn',
  );
  @override
  late final GeneratedColumn<String> registeredOn = GeneratedColumn<String>(
    'registered_on',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _registeredByMeta = const VerificationMeta(
    'registeredBy',
  );
  @override
  late final GeneratedColumn<String> registeredBy = GeneratedColumn<String>(
    'registered_by',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('active'),
  );
  static const VerificationMeta _unpaidFlagMeta = const VerificationMeta(
    'unpaidFlag',
  );
  @override
  late final GeneratedColumn<bool> unpaidFlag = GeneratedColumn<bool>(
    'unpaid_flag',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("unpaid_flag" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    electionId,
    voterNo,
    fullName,
    memberId,
    groupName,
    photo,
    cardIssue,
    registeredOn,
    registeredBy,
    status,
    unpaidFlag,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'voters';
  @override
  VerificationContext validateIntegrity(
    Insertable<Voter> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('election_id')) {
      context.handle(
        _electionIdMeta,
        electionId.isAcceptableOrUnknown(data['election_id']!, _electionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_electionIdMeta);
    }
    if (data.containsKey('voter_no')) {
      context.handle(
        _voterNoMeta,
        voterNo.isAcceptableOrUnknown(data['voter_no']!, _voterNoMeta),
      );
    } else if (isInserting) {
      context.missing(_voterNoMeta);
    }
    if (data.containsKey('full_name')) {
      context.handle(
        _fullNameMeta,
        fullName.isAcceptableOrUnknown(data['full_name']!, _fullNameMeta),
      );
    } else if (isInserting) {
      context.missing(_fullNameMeta);
    }
    if (data.containsKey('member_id')) {
      context.handle(
        _memberIdMeta,
        memberId.isAcceptableOrUnknown(data['member_id']!, _memberIdMeta),
      );
    }
    if (data.containsKey('group_name')) {
      context.handle(
        _groupNameMeta,
        groupName.isAcceptableOrUnknown(data['group_name']!, _groupNameMeta),
      );
    }
    if (data.containsKey('photo')) {
      context.handle(
        _photoMeta,
        photo.isAcceptableOrUnknown(data['photo']!, _photoMeta),
      );
    }
    if (data.containsKey('card_issue')) {
      context.handle(
        _cardIssueMeta,
        cardIssue.isAcceptableOrUnknown(data['card_issue']!, _cardIssueMeta),
      );
    }
    if (data.containsKey('registered_on')) {
      context.handle(
        _registeredOnMeta,
        registeredOn.isAcceptableOrUnknown(
          data['registered_on']!,
          _registeredOnMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_registeredOnMeta);
    }
    if (data.containsKey('registered_by')) {
      context.handle(
        _registeredByMeta,
        registeredBy.isAcceptableOrUnknown(
          data['registered_by']!,
          _registeredByMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_registeredByMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('unpaid_flag')) {
      context.handle(
        _unpaidFlagMeta,
        unpaidFlag.isAcceptableOrUnknown(data['unpaid_flag']!, _unpaidFlagMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {electionId, voterNo},
  ];
  @override
  Voter map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Voter(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      electionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}election_id'],
      )!,
      voterNo: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}voter_no'],
      )!,
      fullName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}full_name'],
      )!,
      memberId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}member_id'],
      )!,
      groupName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}group_name'],
      )!,
      photo: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}photo'],
      ),
      cardIssue: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}card_issue'],
      )!,
      registeredOn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}registered_on'],
      )!,
      registeredBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}registered_by'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      unpaidFlag: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}unpaid_flag'],
      )!,
    );
  }

  @override
  $VotersTable createAlias(String alias) {
    return $VotersTable(attachedDatabase, alias);
  }
}

class Voter extends DataClass implements Insertable<Voter> {
  final String id;
  final String electionId;
  final int voterNo;
  final String fullName;
  final String memberId;
  final String groupName;
  final Uint8List? photo;

  /// Increases on every reprint; old cards then fail verification.
  final int cardIssue;

  /// Registration date only (YYYY-MM-DD), as printed on the card.
  final String registeredOn;
  final String registeredBy;

  /// active | removed
  final String status;

  /// Registered without paying under the allow_flagged policy.
  final bool unpaidFlag;
  const Voter({
    required this.id,
    required this.electionId,
    required this.voterNo,
    required this.fullName,
    required this.memberId,
    required this.groupName,
    this.photo,
    required this.cardIssue,
    required this.registeredOn,
    required this.registeredBy,
    required this.status,
    required this.unpaidFlag,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['election_id'] = Variable<String>(electionId);
    map['voter_no'] = Variable<int>(voterNo);
    map['full_name'] = Variable<String>(fullName);
    map['member_id'] = Variable<String>(memberId);
    map['group_name'] = Variable<String>(groupName);
    if (!nullToAbsent || photo != null) {
      map['photo'] = Variable<Uint8List>(photo);
    }
    map['card_issue'] = Variable<int>(cardIssue);
    map['registered_on'] = Variable<String>(registeredOn);
    map['registered_by'] = Variable<String>(registeredBy);
    map['status'] = Variable<String>(status);
    map['unpaid_flag'] = Variable<bool>(unpaidFlag);
    return map;
  }

  VotersCompanion toCompanion(bool nullToAbsent) {
    return VotersCompanion(
      id: Value(id),
      electionId: Value(electionId),
      voterNo: Value(voterNo),
      fullName: Value(fullName),
      memberId: Value(memberId),
      groupName: Value(groupName),
      photo: photo == null && nullToAbsent
          ? const Value.absent()
          : Value(photo),
      cardIssue: Value(cardIssue),
      registeredOn: Value(registeredOn),
      registeredBy: Value(registeredBy),
      status: Value(status),
      unpaidFlag: Value(unpaidFlag),
    );
  }

  factory Voter.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Voter(
      id: serializer.fromJson<String>(json['id']),
      electionId: serializer.fromJson<String>(json['electionId']),
      voterNo: serializer.fromJson<int>(json['voterNo']),
      fullName: serializer.fromJson<String>(json['fullName']),
      memberId: serializer.fromJson<String>(json['memberId']),
      groupName: serializer.fromJson<String>(json['groupName']),
      photo: serializer.fromJson<Uint8List?>(json['photo']),
      cardIssue: serializer.fromJson<int>(json['cardIssue']),
      registeredOn: serializer.fromJson<String>(json['registeredOn']),
      registeredBy: serializer.fromJson<String>(json['registeredBy']),
      status: serializer.fromJson<String>(json['status']),
      unpaidFlag: serializer.fromJson<bool>(json['unpaidFlag']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'electionId': serializer.toJson<String>(electionId),
      'voterNo': serializer.toJson<int>(voterNo),
      'fullName': serializer.toJson<String>(fullName),
      'memberId': serializer.toJson<String>(memberId),
      'groupName': serializer.toJson<String>(groupName),
      'photo': serializer.toJson<Uint8List?>(photo),
      'cardIssue': serializer.toJson<int>(cardIssue),
      'registeredOn': serializer.toJson<String>(registeredOn),
      'registeredBy': serializer.toJson<String>(registeredBy),
      'status': serializer.toJson<String>(status),
      'unpaidFlag': serializer.toJson<bool>(unpaidFlag),
    };
  }

  Voter copyWith({
    String? id,
    String? electionId,
    int? voterNo,
    String? fullName,
    String? memberId,
    String? groupName,
    Value<Uint8List?> photo = const Value.absent(),
    int? cardIssue,
    String? registeredOn,
    String? registeredBy,
    String? status,
    bool? unpaidFlag,
  }) => Voter(
    id: id ?? this.id,
    electionId: electionId ?? this.electionId,
    voterNo: voterNo ?? this.voterNo,
    fullName: fullName ?? this.fullName,
    memberId: memberId ?? this.memberId,
    groupName: groupName ?? this.groupName,
    photo: photo.present ? photo.value : this.photo,
    cardIssue: cardIssue ?? this.cardIssue,
    registeredOn: registeredOn ?? this.registeredOn,
    registeredBy: registeredBy ?? this.registeredBy,
    status: status ?? this.status,
    unpaidFlag: unpaidFlag ?? this.unpaidFlag,
  );
  Voter copyWithCompanion(VotersCompanion data) {
    return Voter(
      id: data.id.present ? data.id.value : this.id,
      electionId: data.electionId.present
          ? data.electionId.value
          : this.electionId,
      voterNo: data.voterNo.present ? data.voterNo.value : this.voterNo,
      fullName: data.fullName.present ? data.fullName.value : this.fullName,
      memberId: data.memberId.present ? data.memberId.value : this.memberId,
      groupName: data.groupName.present ? data.groupName.value : this.groupName,
      photo: data.photo.present ? data.photo.value : this.photo,
      cardIssue: data.cardIssue.present ? data.cardIssue.value : this.cardIssue,
      registeredOn: data.registeredOn.present
          ? data.registeredOn.value
          : this.registeredOn,
      registeredBy: data.registeredBy.present
          ? data.registeredBy.value
          : this.registeredBy,
      status: data.status.present ? data.status.value : this.status,
      unpaidFlag: data.unpaidFlag.present
          ? data.unpaidFlag.value
          : this.unpaidFlag,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Voter(')
          ..write('id: $id, ')
          ..write('electionId: $electionId, ')
          ..write('voterNo: $voterNo, ')
          ..write('fullName: $fullName, ')
          ..write('memberId: $memberId, ')
          ..write('groupName: $groupName, ')
          ..write('photo: $photo, ')
          ..write('cardIssue: $cardIssue, ')
          ..write('registeredOn: $registeredOn, ')
          ..write('registeredBy: $registeredBy, ')
          ..write('status: $status, ')
          ..write('unpaidFlag: $unpaidFlag')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    electionId,
    voterNo,
    fullName,
    memberId,
    groupName,
    $driftBlobEquality.hash(photo),
    cardIssue,
    registeredOn,
    registeredBy,
    status,
    unpaidFlag,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Voter &&
          other.id == this.id &&
          other.electionId == this.electionId &&
          other.voterNo == this.voterNo &&
          other.fullName == this.fullName &&
          other.memberId == this.memberId &&
          other.groupName == this.groupName &&
          $driftBlobEquality.equals(other.photo, this.photo) &&
          other.cardIssue == this.cardIssue &&
          other.registeredOn == this.registeredOn &&
          other.registeredBy == this.registeredBy &&
          other.status == this.status &&
          other.unpaidFlag == this.unpaidFlag);
}

class VotersCompanion extends UpdateCompanion<Voter> {
  final Value<String> id;
  final Value<String> electionId;
  final Value<int> voterNo;
  final Value<String> fullName;
  final Value<String> memberId;
  final Value<String> groupName;
  final Value<Uint8List?> photo;
  final Value<int> cardIssue;
  final Value<String> registeredOn;
  final Value<String> registeredBy;
  final Value<String> status;
  final Value<bool> unpaidFlag;
  final Value<int> rowid;
  const VotersCompanion({
    this.id = const Value.absent(),
    this.electionId = const Value.absent(),
    this.voterNo = const Value.absent(),
    this.fullName = const Value.absent(),
    this.memberId = const Value.absent(),
    this.groupName = const Value.absent(),
    this.photo = const Value.absent(),
    this.cardIssue = const Value.absent(),
    this.registeredOn = const Value.absent(),
    this.registeredBy = const Value.absent(),
    this.status = const Value.absent(),
    this.unpaidFlag = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  VotersCompanion.insert({
    required String id,
    required String electionId,
    required int voterNo,
    required String fullName,
    this.memberId = const Value.absent(),
    this.groupName = const Value.absent(),
    this.photo = const Value.absent(),
    this.cardIssue = const Value.absent(),
    required String registeredOn,
    required String registeredBy,
    this.status = const Value.absent(),
    this.unpaidFlag = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       electionId = Value(electionId),
       voterNo = Value(voterNo),
       fullName = Value(fullName),
       registeredOn = Value(registeredOn),
       registeredBy = Value(registeredBy);
  static Insertable<Voter> custom({
    Expression<String>? id,
    Expression<String>? electionId,
    Expression<int>? voterNo,
    Expression<String>? fullName,
    Expression<String>? memberId,
    Expression<String>? groupName,
    Expression<Uint8List>? photo,
    Expression<int>? cardIssue,
    Expression<String>? registeredOn,
    Expression<String>? registeredBy,
    Expression<String>? status,
    Expression<bool>? unpaidFlag,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (electionId != null) 'election_id': electionId,
      if (voterNo != null) 'voter_no': voterNo,
      if (fullName != null) 'full_name': fullName,
      if (memberId != null) 'member_id': memberId,
      if (groupName != null) 'group_name': groupName,
      if (photo != null) 'photo': photo,
      if (cardIssue != null) 'card_issue': cardIssue,
      if (registeredOn != null) 'registered_on': registeredOn,
      if (registeredBy != null) 'registered_by': registeredBy,
      if (status != null) 'status': status,
      if (unpaidFlag != null) 'unpaid_flag': unpaidFlag,
      if (rowid != null) 'rowid': rowid,
    });
  }

  VotersCompanion copyWith({
    Value<String>? id,
    Value<String>? electionId,
    Value<int>? voterNo,
    Value<String>? fullName,
    Value<String>? memberId,
    Value<String>? groupName,
    Value<Uint8List?>? photo,
    Value<int>? cardIssue,
    Value<String>? registeredOn,
    Value<String>? registeredBy,
    Value<String>? status,
    Value<bool>? unpaidFlag,
    Value<int>? rowid,
  }) {
    return VotersCompanion(
      id: id ?? this.id,
      electionId: electionId ?? this.electionId,
      voterNo: voterNo ?? this.voterNo,
      fullName: fullName ?? this.fullName,
      memberId: memberId ?? this.memberId,
      groupName: groupName ?? this.groupName,
      photo: photo ?? this.photo,
      cardIssue: cardIssue ?? this.cardIssue,
      registeredOn: registeredOn ?? this.registeredOn,
      registeredBy: registeredBy ?? this.registeredBy,
      status: status ?? this.status,
      unpaidFlag: unpaidFlag ?? this.unpaidFlag,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (electionId.present) {
      map['election_id'] = Variable<String>(electionId.value);
    }
    if (voterNo.present) {
      map['voter_no'] = Variable<int>(voterNo.value);
    }
    if (fullName.present) {
      map['full_name'] = Variable<String>(fullName.value);
    }
    if (memberId.present) {
      map['member_id'] = Variable<String>(memberId.value);
    }
    if (groupName.present) {
      map['group_name'] = Variable<String>(groupName.value);
    }
    if (photo.present) {
      map['photo'] = Variable<Uint8List>(photo.value);
    }
    if (cardIssue.present) {
      map['card_issue'] = Variable<int>(cardIssue.value);
    }
    if (registeredOn.present) {
      map['registered_on'] = Variable<String>(registeredOn.value);
    }
    if (registeredBy.present) {
      map['registered_by'] = Variable<String>(registeredBy.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (unpaidFlag.present) {
      map['unpaid_flag'] = Variable<bool>(unpaidFlag.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VotersCompanion(')
          ..write('id: $id, ')
          ..write('electionId: $electionId, ')
          ..write('voterNo: $voterNo, ')
          ..write('fullName: $fullName, ')
          ..write('memberId: $memberId, ')
          ..write('groupName: $groupName, ')
          ..write('photo: $photo, ')
          ..write('cardIssue: $cardIssue, ')
          ..write('registeredOn: $registeredOn, ')
          ..write('registeredBy: $registeredBy, ')
          ..write('status: $status, ')
          ..write('unpaidFlag: $unpaidFlag, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FeePaymentsTable extends FeePayments
    with TableInfo<$FeePaymentsTable, FeePayment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FeePaymentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _voterIdMeta = const VerificationMeta(
    'voterId',
  );
  @override
  late final GeneratedColumn<String> voterId = GeneratedColumn<String>(
    'voter_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES voters (id)',
    ),
  );
  static const VerificationMeta _paidMeta = const VerificationMeta('paid');
  @override
  late final GeneratedColumn<bool> paid = GeneratedColumn<bool>(
    'paid',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("paid" IN (0, 1))',
    ),
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
    'amount',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _receiptNoMeta = const VerificationMeta(
    'receiptNo',
  );
  @override
  late final GeneratedColumn<String> receiptNo = GeneratedColumn<String>(
    'receipt_no',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _recordedByMeta = const VerificationMeta(
    'recordedBy',
  );
  @override
  late final GeneratedColumn<String> recordedBy = GeneratedColumn<String>(
    'recorded_by',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    voterId,
    paid,
    currency,
    amount,
    receiptNo,
    recordedBy,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'fee_payments';
  @override
  VerificationContext validateIntegrity(
    Insertable<FeePayment> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('voter_id')) {
      context.handle(
        _voterIdMeta,
        voterId.isAcceptableOrUnknown(data['voter_id']!, _voterIdMeta),
      );
    } else if (isInserting) {
      context.missing(_voterIdMeta);
    }
    if (data.containsKey('paid')) {
      context.handle(
        _paidMeta,
        paid.isAcceptableOrUnknown(data['paid']!, _paidMeta),
      );
    } else if (isInserting) {
      context.missing(_paidMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    }
    if (data.containsKey('receipt_no')) {
      context.handle(
        _receiptNoMeta,
        receiptNo.isAcceptableOrUnknown(data['receipt_no']!, _receiptNoMeta),
      );
    }
    if (data.containsKey('recorded_by')) {
      context.handle(
        _recordedByMeta,
        recordedBy.isAcceptableOrUnknown(data['recorded_by']!, _recordedByMeta),
      );
    } else if (isInserting) {
      context.missing(_recordedByMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {voterId};
  @override
  FeePayment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FeePayment(
      voterId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}voter_id'],
      )!,
      paid: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}paid'],
      )!,
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      ),
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount'],
      ),
      receiptNo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}receipt_no'],
      ),
      recordedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recorded_by'],
      )!,
    );
  }

  @override
  $FeePaymentsTable createAlias(String alias) {
    return $FeePaymentsTable(attachedDatabase, alias);
  }
}

class FeePayment extends DataClass implements Insertable<FeePayment> {
  final String voterId;
  final bool paid;
  final String? currency;
  final int? amount;
  final String? receiptNo;
  final String recordedBy;
  const FeePayment({
    required this.voterId,
    required this.paid,
    this.currency,
    this.amount,
    this.receiptNo,
    required this.recordedBy,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['voter_id'] = Variable<String>(voterId);
    map['paid'] = Variable<bool>(paid);
    if (!nullToAbsent || currency != null) {
      map['currency'] = Variable<String>(currency);
    }
    if (!nullToAbsent || amount != null) {
      map['amount'] = Variable<int>(amount);
    }
    if (!nullToAbsent || receiptNo != null) {
      map['receipt_no'] = Variable<String>(receiptNo);
    }
    map['recorded_by'] = Variable<String>(recordedBy);
    return map;
  }

  FeePaymentsCompanion toCompanion(bool nullToAbsent) {
    return FeePaymentsCompanion(
      voterId: Value(voterId),
      paid: Value(paid),
      currency: currency == null && nullToAbsent
          ? const Value.absent()
          : Value(currency),
      amount: amount == null && nullToAbsent
          ? const Value.absent()
          : Value(amount),
      receiptNo: receiptNo == null && nullToAbsent
          ? const Value.absent()
          : Value(receiptNo),
      recordedBy: Value(recordedBy),
    );
  }

  factory FeePayment.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FeePayment(
      voterId: serializer.fromJson<String>(json['voterId']),
      paid: serializer.fromJson<bool>(json['paid']),
      currency: serializer.fromJson<String?>(json['currency']),
      amount: serializer.fromJson<int?>(json['amount']),
      receiptNo: serializer.fromJson<String?>(json['receiptNo']),
      recordedBy: serializer.fromJson<String>(json['recordedBy']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'voterId': serializer.toJson<String>(voterId),
      'paid': serializer.toJson<bool>(paid),
      'currency': serializer.toJson<String?>(currency),
      'amount': serializer.toJson<int?>(amount),
      'receiptNo': serializer.toJson<String?>(receiptNo),
      'recordedBy': serializer.toJson<String>(recordedBy),
    };
  }

  FeePayment copyWith({
    String? voterId,
    bool? paid,
    Value<String?> currency = const Value.absent(),
    Value<int?> amount = const Value.absent(),
    Value<String?> receiptNo = const Value.absent(),
    String? recordedBy,
  }) => FeePayment(
    voterId: voterId ?? this.voterId,
    paid: paid ?? this.paid,
    currency: currency.present ? currency.value : this.currency,
    amount: amount.present ? amount.value : this.amount,
    receiptNo: receiptNo.present ? receiptNo.value : this.receiptNo,
    recordedBy: recordedBy ?? this.recordedBy,
  );
  FeePayment copyWithCompanion(FeePaymentsCompanion data) {
    return FeePayment(
      voterId: data.voterId.present ? data.voterId.value : this.voterId,
      paid: data.paid.present ? data.paid.value : this.paid,
      currency: data.currency.present ? data.currency.value : this.currency,
      amount: data.amount.present ? data.amount.value : this.amount,
      receiptNo: data.receiptNo.present ? data.receiptNo.value : this.receiptNo,
      recordedBy: data.recordedBy.present
          ? data.recordedBy.value
          : this.recordedBy,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FeePayment(')
          ..write('voterId: $voterId, ')
          ..write('paid: $paid, ')
          ..write('currency: $currency, ')
          ..write('amount: $amount, ')
          ..write('receiptNo: $receiptNo, ')
          ..write('recordedBy: $recordedBy')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(voterId, paid, currency, amount, receiptNo, recordedBy);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FeePayment &&
          other.voterId == this.voterId &&
          other.paid == this.paid &&
          other.currency == this.currency &&
          other.amount == this.amount &&
          other.receiptNo == this.receiptNo &&
          other.recordedBy == this.recordedBy);
}

class FeePaymentsCompanion extends UpdateCompanion<FeePayment> {
  final Value<String> voterId;
  final Value<bool> paid;
  final Value<String?> currency;
  final Value<int?> amount;
  final Value<String?> receiptNo;
  final Value<String> recordedBy;
  final Value<int> rowid;
  const FeePaymentsCompanion({
    this.voterId = const Value.absent(),
    this.paid = const Value.absent(),
    this.currency = const Value.absent(),
    this.amount = const Value.absent(),
    this.receiptNo = const Value.absent(),
    this.recordedBy = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FeePaymentsCompanion.insert({
    required String voterId,
    required bool paid,
    this.currency = const Value.absent(),
    this.amount = const Value.absent(),
    this.receiptNo = const Value.absent(),
    required String recordedBy,
    this.rowid = const Value.absent(),
  }) : voterId = Value(voterId),
       paid = Value(paid),
       recordedBy = Value(recordedBy);
  static Insertable<FeePayment> custom({
    Expression<String>? voterId,
    Expression<bool>? paid,
    Expression<String>? currency,
    Expression<int>? amount,
    Expression<String>? receiptNo,
    Expression<String>? recordedBy,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (voterId != null) 'voter_id': voterId,
      if (paid != null) 'paid': paid,
      if (currency != null) 'currency': currency,
      if (amount != null) 'amount': amount,
      if (receiptNo != null) 'receipt_no': receiptNo,
      if (recordedBy != null) 'recorded_by': recordedBy,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FeePaymentsCompanion copyWith({
    Value<String>? voterId,
    Value<bool>? paid,
    Value<String?>? currency,
    Value<int?>? amount,
    Value<String?>? receiptNo,
    Value<String>? recordedBy,
    Value<int>? rowid,
  }) {
    return FeePaymentsCompanion(
      voterId: voterId ?? this.voterId,
      paid: paid ?? this.paid,
      currency: currency ?? this.currency,
      amount: amount ?? this.amount,
      receiptNo: receiptNo ?? this.receiptNo,
      recordedBy: recordedBy ?? this.recordedBy,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (voterId.present) {
      map['voter_id'] = Variable<String>(voterId.value);
    }
    if (paid.present) {
      map['paid'] = Variable<bool>(paid.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (receiptNo.present) {
      map['receipt_no'] = Variable<String>(receiptNo.value);
    }
    if (recordedBy.present) {
      map['recorded_by'] = Variable<String>(recordedBy.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FeePaymentsCompanion(')
          ..write('voterId: $voterId, ')
          ..write('paid: $paid, ')
          ..write('currency: $currency, ')
          ..write('amount: $amount, ')
          ..write('receiptNo: $receiptNo, ')
          ..write('recordedBy: $recordedBy, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ObjectionsTable extends Objections
    with TableInfo<$ObjectionsTable, Objection> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ObjectionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
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
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES elections (id)',
    ),
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _subjectVoterIdMeta = const VerificationMeta(
    'subjectVoterId',
  );
  @override
  late final GeneratedColumn<String> subjectVoterId = GeneratedColumn<String>(
    'subject_voter_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _otherVoterIdMeta = const VerificationMeta(
    'otherVoterId',
  );
  @override
  late final GeneratedColumn<String> otherVoterId = GeneratedColumn<String>(
    'other_voter_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _claimantNameMeta = const VerificationMeta(
    'claimantName',
  );
  @override
  late final GeneratedColumn<String> claimantName = GeneratedColumn<String>(
    'claimant_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _raisedByNameMeta = const VerificationMeta(
    'raisedByName',
  );
  @override
  late final GeneratedColumn<String> raisedByName = GeneratedColumn<String>(
    'raised_by_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _detailMeta = const VerificationMeta('detail');
  @override
  late final GeneratedColumn<String> detail = GeneratedColumn<String>(
    'detail',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _raisedOnMeta = const VerificationMeta(
    'raisedOn',
  );
  @override
  late final GeneratedColumn<String> raisedOn = GeneratedColumn<String>(
    'raised_on',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _decisionMeta = const VerificationMeta(
    'decision',
  );
  @override
  late final GeneratedColumn<String> decision = GeneratedColumn<String>(
    'decision',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _decidedByMeta = const VerificationMeta(
    'decidedBy',
  );
  @override
  late final GeneratedColumn<String> decidedBy = GeneratedColumn<String>(
    'decided_by',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _decidedOnMeta = const VerificationMeta(
    'decidedOn',
  );
  @override
  late final GeneratedColumn<String> decidedOn = GeneratedColumn<String>(
    'decided_on',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    electionId,
    kind,
    subjectVoterId,
    otherVoterId,
    claimantName,
    raisedByName,
    detail,
    raisedOn,
    decision,
    decidedBy,
    decidedOn,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'objections';
  @override
  VerificationContext validateIntegrity(
    Insertable<Objection> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('election_id')) {
      context.handle(
        _electionIdMeta,
        electionId.isAcceptableOrUnknown(data['election_id']!, _electionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_electionIdMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('subject_voter_id')) {
      context.handle(
        _subjectVoterIdMeta,
        subjectVoterId.isAcceptableOrUnknown(
          data['subject_voter_id']!,
          _subjectVoterIdMeta,
        ),
      );
    }
    if (data.containsKey('other_voter_id')) {
      context.handle(
        _otherVoterIdMeta,
        otherVoterId.isAcceptableOrUnknown(
          data['other_voter_id']!,
          _otherVoterIdMeta,
        ),
      );
    }
    if (data.containsKey('claimant_name')) {
      context.handle(
        _claimantNameMeta,
        claimantName.isAcceptableOrUnknown(
          data['claimant_name']!,
          _claimantNameMeta,
        ),
      );
    }
    if (data.containsKey('raised_by_name')) {
      context.handle(
        _raisedByNameMeta,
        raisedByName.isAcceptableOrUnknown(
          data['raised_by_name']!,
          _raisedByNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_raisedByNameMeta);
    }
    if (data.containsKey('detail')) {
      context.handle(
        _detailMeta,
        detail.isAcceptableOrUnknown(data['detail']!, _detailMeta),
      );
    }
    if (data.containsKey('raised_on')) {
      context.handle(
        _raisedOnMeta,
        raisedOn.isAcceptableOrUnknown(data['raised_on']!, _raisedOnMeta),
      );
    } else if (isInserting) {
      context.missing(_raisedOnMeta);
    }
    if (data.containsKey('decision')) {
      context.handle(
        _decisionMeta,
        decision.isAcceptableOrUnknown(data['decision']!, _decisionMeta),
      );
    }
    if (data.containsKey('decided_by')) {
      context.handle(
        _decidedByMeta,
        decidedBy.isAcceptableOrUnknown(data['decided_by']!, _decidedByMeta),
      );
    }
    if (data.containsKey('decided_on')) {
      context.handle(
        _decidedOnMeta,
        decidedOn.isAcceptableOrUnknown(data['decided_on']!, _decidedOnMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Objection map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Objection(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      electionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}election_id'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      subjectVoterId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subject_voter_id'],
      ),
      otherVoterId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}other_voter_id'],
      ),
      claimantName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}claimant_name'],
      ),
      raisedByName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}raised_by_name'],
      )!,
      detail: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}detail'],
      )!,
      raisedOn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}raised_on'],
      )!,
      decision: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}decision'],
      ),
      decidedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}decided_by'],
      ),
      decidedOn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}decided_on'],
      ),
    );
  }

  @override
  $ObjectionsTable createAlias(String alias) {
    return $ObjectionsTable(attachedDatabase, alias);
  }
}

class Objection extends DataClass implements Insertable<Objection> {
  final String id;
  final String electionId;

  /// duplicate | missing | other
  final String kind;
  final String? subjectVoterId;
  final String? otherVoterId;

  /// For "missing name" objections: the person who says they registered.
  final String? claimantName;
  final String raisedByName;
  final String detail;
  final String raisedOn;

  /// null while open; otherwise keep_both | remove | add | reject | upheld
  final String? decision;
  final String? decidedBy;
  final String? decidedOn;
  const Objection({
    required this.id,
    required this.electionId,
    required this.kind,
    this.subjectVoterId,
    this.otherVoterId,
    this.claimantName,
    required this.raisedByName,
    required this.detail,
    required this.raisedOn,
    this.decision,
    this.decidedBy,
    this.decidedOn,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['election_id'] = Variable<String>(electionId);
    map['kind'] = Variable<String>(kind);
    if (!nullToAbsent || subjectVoterId != null) {
      map['subject_voter_id'] = Variable<String>(subjectVoterId);
    }
    if (!nullToAbsent || otherVoterId != null) {
      map['other_voter_id'] = Variable<String>(otherVoterId);
    }
    if (!nullToAbsent || claimantName != null) {
      map['claimant_name'] = Variable<String>(claimantName);
    }
    map['raised_by_name'] = Variable<String>(raisedByName);
    map['detail'] = Variable<String>(detail);
    map['raised_on'] = Variable<String>(raisedOn);
    if (!nullToAbsent || decision != null) {
      map['decision'] = Variable<String>(decision);
    }
    if (!nullToAbsent || decidedBy != null) {
      map['decided_by'] = Variable<String>(decidedBy);
    }
    if (!nullToAbsent || decidedOn != null) {
      map['decided_on'] = Variable<String>(decidedOn);
    }
    return map;
  }

  ObjectionsCompanion toCompanion(bool nullToAbsent) {
    return ObjectionsCompanion(
      id: Value(id),
      electionId: Value(electionId),
      kind: Value(kind),
      subjectVoterId: subjectVoterId == null && nullToAbsent
          ? const Value.absent()
          : Value(subjectVoterId),
      otherVoterId: otherVoterId == null && nullToAbsent
          ? const Value.absent()
          : Value(otherVoterId),
      claimantName: claimantName == null && nullToAbsent
          ? const Value.absent()
          : Value(claimantName),
      raisedByName: Value(raisedByName),
      detail: Value(detail),
      raisedOn: Value(raisedOn),
      decision: decision == null && nullToAbsent
          ? const Value.absent()
          : Value(decision),
      decidedBy: decidedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(decidedBy),
      decidedOn: decidedOn == null && nullToAbsent
          ? const Value.absent()
          : Value(decidedOn),
    );
  }

  factory Objection.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Objection(
      id: serializer.fromJson<String>(json['id']),
      electionId: serializer.fromJson<String>(json['electionId']),
      kind: serializer.fromJson<String>(json['kind']),
      subjectVoterId: serializer.fromJson<String?>(json['subjectVoterId']),
      otherVoterId: serializer.fromJson<String?>(json['otherVoterId']),
      claimantName: serializer.fromJson<String?>(json['claimantName']),
      raisedByName: serializer.fromJson<String>(json['raisedByName']),
      detail: serializer.fromJson<String>(json['detail']),
      raisedOn: serializer.fromJson<String>(json['raisedOn']),
      decision: serializer.fromJson<String?>(json['decision']),
      decidedBy: serializer.fromJson<String?>(json['decidedBy']),
      decidedOn: serializer.fromJson<String?>(json['decidedOn']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'electionId': serializer.toJson<String>(electionId),
      'kind': serializer.toJson<String>(kind),
      'subjectVoterId': serializer.toJson<String?>(subjectVoterId),
      'otherVoterId': serializer.toJson<String?>(otherVoterId),
      'claimantName': serializer.toJson<String?>(claimantName),
      'raisedByName': serializer.toJson<String>(raisedByName),
      'detail': serializer.toJson<String>(detail),
      'raisedOn': serializer.toJson<String>(raisedOn),
      'decision': serializer.toJson<String?>(decision),
      'decidedBy': serializer.toJson<String?>(decidedBy),
      'decidedOn': serializer.toJson<String?>(decidedOn),
    };
  }

  Objection copyWith({
    String? id,
    String? electionId,
    String? kind,
    Value<String?> subjectVoterId = const Value.absent(),
    Value<String?> otherVoterId = const Value.absent(),
    Value<String?> claimantName = const Value.absent(),
    String? raisedByName,
    String? detail,
    String? raisedOn,
    Value<String?> decision = const Value.absent(),
    Value<String?> decidedBy = const Value.absent(),
    Value<String?> decidedOn = const Value.absent(),
  }) => Objection(
    id: id ?? this.id,
    electionId: electionId ?? this.electionId,
    kind: kind ?? this.kind,
    subjectVoterId: subjectVoterId.present
        ? subjectVoterId.value
        : this.subjectVoterId,
    otherVoterId: otherVoterId.present ? otherVoterId.value : this.otherVoterId,
    claimantName: claimantName.present ? claimantName.value : this.claimantName,
    raisedByName: raisedByName ?? this.raisedByName,
    detail: detail ?? this.detail,
    raisedOn: raisedOn ?? this.raisedOn,
    decision: decision.present ? decision.value : this.decision,
    decidedBy: decidedBy.present ? decidedBy.value : this.decidedBy,
    decidedOn: decidedOn.present ? decidedOn.value : this.decidedOn,
  );
  Objection copyWithCompanion(ObjectionsCompanion data) {
    return Objection(
      id: data.id.present ? data.id.value : this.id,
      electionId: data.electionId.present
          ? data.electionId.value
          : this.electionId,
      kind: data.kind.present ? data.kind.value : this.kind,
      subjectVoterId: data.subjectVoterId.present
          ? data.subjectVoterId.value
          : this.subjectVoterId,
      otherVoterId: data.otherVoterId.present
          ? data.otherVoterId.value
          : this.otherVoterId,
      claimantName: data.claimantName.present
          ? data.claimantName.value
          : this.claimantName,
      raisedByName: data.raisedByName.present
          ? data.raisedByName.value
          : this.raisedByName,
      detail: data.detail.present ? data.detail.value : this.detail,
      raisedOn: data.raisedOn.present ? data.raisedOn.value : this.raisedOn,
      decision: data.decision.present ? data.decision.value : this.decision,
      decidedBy: data.decidedBy.present ? data.decidedBy.value : this.decidedBy,
      decidedOn: data.decidedOn.present ? data.decidedOn.value : this.decidedOn,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Objection(')
          ..write('id: $id, ')
          ..write('electionId: $electionId, ')
          ..write('kind: $kind, ')
          ..write('subjectVoterId: $subjectVoterId, ')
          ..write('otherVoterId: $otherVoterId, ')
          ..write('claimantName: $claimantName, ')
          ..write('raisedByName: $raisedByName, ')
          ..write('detail: $detail, ')
          ..write('raisedOn: $raisedOn, ')
          ..write('decision: $decision, ')
          ..write('decidedBy: $decidedBy, ')
          ..write('decidedOn: $decidedOn')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    electionId,
    kind,
    subjectVoterId,
    otherVoterId,
    claimantName,
    raisedByName,
    detail,
    raisedOn,
    decision,
    decidedBy,
    decidedOn,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Objection &&
          other.id == this.id &&
          other.electionId == this.electionId &&
          other.kind == this.kind &&
          other.subjectVoterId == this.subjectVoterId &&
          other.otherVoterId == this.otherVoterId &&
          other.claimantName == this.claimantName &&
          other.raisedByName == this.raisedByName &&
          other.detail == this.detail &&
          other.raisedOn == this.raisedOn &&
          other.decision == this.decision &&
          other.decidedBy == this.decidedBy &&
          other.decidedOn == this.decidedOn);
}

class ObjectionsCompanion extends UpdateCompanion<Objection> {
  final Value<String> id;
  final Value<String> electionId;
  final Value<String> kind;
  final Value<String?> subjectVoterId;
  final Value<String?> otherVoterId;
  final Value<String?> claimantName;
  final Value<String> raisedByName;
  final Value<String> detail;
  final Value<String> raisedOn;
  final Value<String?> decision;
  final Value<String?> decidedBy;
  final Value<String?> decidedOn;
  final Value<int> rowid;
  const ObjectionsCompanion({
    this.id = const Value.absent(),
    this.electionId = const Value.absent(),
    this.kind = const Value.absent(),
    this.subjectVoterId = const Value.absent(),
    this.otherVoterId = const Value.absent(),
    this.claimantName = const Value.absent(),
    this.raisedByName = const Value.absent(),
    this.detail = const Value.absent(),
    this.raisedOn = const Value.absent(),
    this.decision = const Value.absent(),
    this.decidedBy = const Value.absent(),
    this.decidedOn = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ObjectionsCompanion.insert({
    required String id,
    required String electionId,
    required String kind,
    this.subjectVoterId = const Value.absent(),
    this.otherVoterId = const Value.absent(),
    this.claimantName = const Value.absent(),
    required String raisedByName,
    this.detail = const Value.absent(),
    required String raisedOn,
    this.decision = const Value.absent(),
    this.decidedBy = const Value.absent(),
    this.decidedOn = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       electionId = Value(electionId),
       kind = Value(kind),
       raisedByName = Value(raisedByName),
       raisedOn = Value(raisedOn);
  static Insertable<Objection> custom({
    Expression<String>? id,
    Expression<String>? electionId,
    Expression<String>? kind,
    Expression<String>? subjectVoterId,
    Expression<String>? otherVoterId,
    Expression<String>? claimantName,
    Expression<String>? raisedByName,
    Expression<String>? detail,
    Expression<String>? raisedOn,
    Expression<String>? decision,
    Expression<String>? decidedBy,
    Expression<String>? decidedOn,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (electionId != null) 'election_id': electionId,
      if (kind != null) 'kind': kind,
      if (subjectVoterId != null) 'subject_voter_id': subjectVoterId,
      if (otherVoterId != null) 'other_voter_id': otherVoterId,
      if (claimantName != null) 'claimant_name': claimantName,
      if (raisedByName != null) 'raised_by_name': raisedByName,
      if (detail != null) 'detail': detail,
      if (raisedOn != null) 'raised_on': raisedOn,
      if (decision != null) 'decision': decision,
      if (decidedBy != null) 'decided_by': decidedBy,
      if (decidedOn != null) 'decided_on': decidedOn,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ObjectionsCompanion copyWith({
    Value<String>? id,
    Value<String>? electionId,
    Value<String>? kind,
    Value<String?>? subjectVoterId,
    Value<String?>? otherVoterId,
    Value<String?>? claimantName,
    Value<String>? raisedByName,
    Value<String>? detail,
    Value<String>? raisedOn,
    Value<String?>? decision,
    Value<String?>? decidedBy,
    Value<String?>? decidedOn,
    Value<int>? rowid,
  }) {
    return ObjectionsCompanion(
      id: id ?? this.id,
      electionId: electionId ?? this.electionId,
      kind: kind ?? this.kind,
      subjectVoterId: subjectVoterId ?? this.subjectVoterId,
      otherVoterId: otherVoterId ?? this.otherVoterId,
      claimantName: claimantName ?? this.claimantName,
      raisedByName: raisedByName ?? this.raisedByName,
      detail: detail ?? this.detail,
      raisedOn: raisedOn ?? this.raisedOn,
      decision: decision ?? this.decision,
      decidedBy: decidedBy ?? this.decidedBy,
      decidedOn: decidedOn ?? this.decidedOn,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (electionId.present) {
      map['election_id'] = Variable<String>(electionId.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (subjectVoterId.present) {
      map['subject_voter_id'] = Variable<String>(subjectVoterId.value);
    }
    if (otherVoterId.present) {
      map['other_voter_id'] = Variable<String>(otherVoterId.value);
    }
    if (claimantName.present) {
      map['claimant_name'] = Variable<String>(claimantName.value);
    }
    if (raisedByName.present) {
      map['raised_by_name'] = Variable<String>(raisedByName.value);
    }
    if (detail.present) {
      map['detail'] = Variable<String>(detail.value);
    }
    if (raisedOn.present) {
      map['raised_on'] = Variable<String>(raisedOn.value);
    }
    if (decision.present) {
      map['decision'] = Variable<String>(decision.value);
    }
    if (decidedBy.present) {
      map['decided_by'] = Variable<String>(decidedBy.value);
    }
    if (decidedOn.present) {
      map['decided_on'] = Variable<String>(decidedOn.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ObjectionsCompanion(')
          ..write('id: $id, ')
          ..write('electionId: $electionId, ')
          ..write('kind: $kind, ')
          ..write('subjectVoterId: $subjectVoterId, ')
          ..write('otherVoterId: $otherVoterId, ')
          ..write('claimantName: $claimantName, ')
          ..write('raisedByName: $raisedByName, ')
          ..write('detail: $detail, ')
          ..write('raisedOn: $raisedOn, ')
          ..write('decision: $decision, ')
          ..write('decidedBy: $decidedBy, ')
          ..write('decidedOn: $decidedOn, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RegisterLocksTable extends RegisterLocks
    with TableInfo<$RegisterLocksTable, RegisterLock> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RegisterLocksTable(this.attachedDatabase, [this._alias]);
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
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES elections (id)',
    ),
  );
  static const VerificationMeta _signedRegisterMeta = const VerificationMeta(
    'signedRegister',
  );
  @override
  late final GeneratedColumn<String> signedRegister = GeneratedColumn<String>(
    'signed_register',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fingerprintMeta = const VerificationMeta(
    'fingerprint',
  );
  @override
  late final GeneratedColumn<String> fingerprint = GeneratedColumn<String>(
    'fingerprint',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lockedByMeta = const VerificationMeta(
    'lockedBy',
  );
  @override
  late final GeneratedColumn<String> lockedBy = GeneratedColumn<String>(
    'locked_by',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lockedAtMeta = const VerificationMeta(
    'lockedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lockedAt = GeneratedColumn<DateTime>(
    'locked_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    electionId,
    signedRegister,
    fingerprint,
    lockedBy,
    lockedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'register_locks';
  @override
  VerificationContext validateIntegrity(
    Insertable<RegisterLock> instance, {
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
    if (data.containsKey('signed_register')) {
      context.handle(
        _signedRegisterMeta,
        signedRegister.isAcceptableOrUnknown(
          data['signed_register']!,
          _signedRegisterMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_signedRegisterMeta);
    }
    if (data.containsKey('fingerprint')) {
      context.handle(
        _fingerprintMeta,
        fingerprint.isAcceptableOrUnknown(
          data['fingerprint']!,
          _fingerprintMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fingerprintMeta);
    }
    if (data.containsKey('locked_by')) {
      context.handle(
        _lockedByMeta,
        lockedBy.isAcceptableOrUnknown(data['locked_by']!, _lockedByMeta),
      );
    } else if (isInserting) {
      context.missing(_lockedByMeta);
    }
    if (data.containsKey('locked_at')) {
      context.handle(
        _lockedAtMeta,
        lockedAt.isAcceptableOrUnknown(data['locked_at']!, _lockedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_lockedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {electionId};
  @override
  RegisterLock map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RegisterLock(
      electionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}election_id'],
      )!,
      signedRegister: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}signed_register'],
      )!,
      fingerprint: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fingerprint'],
      )!,
      lockedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}locked_by'],
      )!,
      lockedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}locked_at'],
      )!,
    );
  }

  @override
  $RegisterLocksTable createAlias(String alias) {
    return $RegisterLocksTable(attachedDatabase, alias);
  }
}

class RegisterLock extends DataClass implements Insertable<RegisterLock> {
  final String electionId;

  /// Signed register (SignedArtifact JSON).
  final String signedRegister;
  final String fingerprint;
  final String lockedBy;
  final DateTime lockedAt;
  const RegisterLock({
    required this.electionId,
    required this.signedRegister,
    required this.fingerprint,
    required this.lockedBy,
    required this.lockedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['election_id'] = Variable<String>(electionId);
    map['signed_register'] = Variable<String>(signedRegister);
    map['fingerprint'] = Variable<String>(fingerprint);
    map['locked_by'] = Variable<String>(lockedBy);
    map['locked_at'] = Variable<DateTime>(lockedAt);
    return map;
  }

  RegisterLocksCompanion toCompanion(bool nullToAbsent) {
    return RegisterLocksCompanion(
      electionId: Value(electionId),
      signedRegister: Value(signedRegister),
      fingerprint: Value(fingerprint),
      lockedBy: Value(lockedBy),
      lockedAt: Value(lockedAt),
    );
  }

  factory RegisterLock.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RegisterLock(
      electionId: serializer.fromJson<String>(json['electionId']),
      signedRegister: serializer.fromJson<String>(json['signedRegister']),
      fingerprint: serializer.fromJson<String>(json['fingerprint']),
      lockedBy: serializer.fromJson<String>(json['lockedBy']),
      lockedAt: serializer.fromJson<DateTime>(json['lockedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'electionId': serializer.toJson<String>(electionId),
      'signedRegister': serializer.toJson<String>(signedRegister),
      'fingerprint': serializer.toJson<String>(fingerprint),
      'lockedBy': serializer.toJson<String>(lockedBy),
      'lockedAt': serializer.toJson<DateTime>(lockedAt),
    };
  }

  RegisterLock copyWith({
    String? electionId,
    String? signedRegister,
    String? fingerprint,
    String? lockedBy,
    DateTime? lockedAt,
  }) => RegisterLock(
    electionId: electionId ?? this.electionId,
    signedRegister: signedRegister ?? this.signedRegister,
    fingerprint: fingerprint ?? this.fingerprint,
    lockedBy: lockedBy ?? this.lockedBy,
    lockedAt: lockedAt ?? this.lockedAt,
  );
  RegisterLock copyWithCompanion(RegisterLocksCompanion data) {
    return RegisterLock(
      electionId: data.electionId.present
          ? data.electionId.value
          : this.electionId,
      signedRegister: data.signedRegister.present
          ? data.signedRegister.value
          : this.signedRegister,
      fingerprint: data.fingerprint.present
          ? data.fingerprint.value
          : this.fingerprint,
      lockedBy: data.lockedBy.present ? data.lockedBy.value : this.lockedBy,
      lockedAt: data.lockedAt.present ? data.lockedAt.value : this.lockedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RegisterLock(')
          ..write('electionId: $electionId, ')
          ..write('signedRegister: $signedRegister, ')
          ..write('fingerprint: $fingerprint, ')
          ..write('lockedBy: $lockedBy, ')
          ..write('lockedAt: $lockedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(electionId, signedRegister, fingerprint, lockedBy, lockedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RegisterLock &&
          other.electionId == this.electionId &&
          other.signedRegister == this.signedRegister &&
          other.fingerprint == this.fingerprint &&
          other.lockedBy == this.lockedBy &&
          other.lockedAt == this.lockedAt);
}

class RegisterLocksCompanion extends UpdateCompanion<RegisterLock> {
  final Value<String> electionId;
  final Value<String> signedRegister;
  final Value<String> fingerprint;
  final Value<String> lockedBy;
  final Value<DateTime> lockedAt;
  final Value<int> rowid;
  const RegisterLocksCompanion({
    this.electionId = const Value.absent(),
    this.signedRegister = const Value.absent(),
    this.fingerprint = const Value.absent(),
    this.lockedBy = const Value.absent(),
    this.lockedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RegisterLocksCompanion.insert({
    required String electionId,
    required String signedRegister,
    required String fingerprint,
    required String lockedBy,
    required DateTime lockedAt,
    this.rowid = const Value.absent(),
  }) : electionId = Value(electionId),
       signedRegister = Value(signedRegister),
       fingerprint = Value(fingerprint),
       lockedBy = Value(lockedBy),
       lockedAt = Value(lockedAt);
  static Insertable<RegisterLock> custom({
    Expression<String>? electionId,
    Expression<String>? signedRegister,
    Expression<String>? fingerprint,
    Expression<String>? lockedBy,
    Expression<DateTime>? lockedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (electionId != null) 'election_id': electionId,
      if (signedRegister != null) 'signed_register': signedRegister,
      if (fingerprint != null) 'fingerprint': fingerprint,
      if (lockedBy != null) 'locked_by': lockedBy,
      if (lockedAt != null) 'locked_at': lockedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RegisterLocksCompanion copyWith({
    Value<String>? electionId,
    Value<String>? signedRegister,
    Value<String>? fingerprint,
    Value<String>? lockedBy,
    Value<DateTime>? lockedAt,
    Value<int>? rowid,
  }) {
    return RegisterLocksCompanion(
      electionId: electionId ?? this.electionId,
      signedRegister: signedRegister ?? this.signedRegister,
      fingerprint: fingerprint ?? this.fingerprint,
      lockedBy: lockedBy ?? this.lockedBy,
      lockedAt: lockedAt ?? this.lockedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (electionId.present) {
      map['election_id'] = Variable<String>(electionId.value);
    }
    if (signedRegister.present) {
      map['signed_register'] = Variable<String>(signedRegister.value);
    }
    if (fingerprint.present) {
      map['fingerprint'] = Variable<String>(fingerprint.value);
    }
    if (lockedBy.present) {
      map['locked_by'] = Variable<String>(lockedBy.value);
    }
    if (lockedAt.present) {
      map['locked_at'] = Variable<DateTime>(lockedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RegisterLocksCompanion(')
          ..write('electionId: $electionId, ')
          ..write('signedRegister: $signedRegister, ')
          ..write('fingerprint: $fingerprint, ')
          ..write('lockedBy: $lockedBy, ')
          ..write('lockedAt: $lockedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CheckInsTable extends CheckIns with TableInfo<$CheckInsTable, CheckIn> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CheckInsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _voterIdMeta = const VerificationMeta(
    'voterId',
  );
  @override
  late final GeneratedColumn<String> voterId = GeneratedColumn<String>(
    'voter_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES voters (id)',
    ),
  );
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
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES elections (id)',
    ),
  );
  static const VerificationMeta _methodMeta = const VerificationMeta('method');
  @override
  late final GeneratedColumn<String> method = GeneratedColumn<String>(
    'method',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _manualReasonMeta = const VerificationMeta(
    'manualReason',
  );
  @override
  late final GeneratedColumn<String> manualReason = GeneratedColumn<String>(
    'manual_reason',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _officialMeta = const VerificationMeta(
    'official',
  );
  @override
  late final GeneratedColumn<String> official = GeneratedColumn<String>(
    'official',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hourBucketMeta = const VerificationMeta(
    'hourBucket',
  );
  @override
  late final GeneratedColumn<String> hourBucket = GeneratedColumn<String>(
    'hour_bucket',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    voterId,
    electionId,
    method,
    manualReason,
    official,
    hourBucket,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'check_ins';
  @override
  VerificationContext validateIntegrity(
    Insertable<CheckIn> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('voter_id')) {
      context.handle(
        _voterIdMeta,
        voterId.isAcceptableOrUnknown(data['voter_id']!, _voterIdMeta),
      );
    } else if (isInserting) {
      context.missing(_voterIdMeta);
    }
    if (data.containsKey('election_id')) {
      context.handle(
        _electionIdMeta,
        electionId.isAcceptableOrUnknown(data['election_id']!, _electionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_electionIdMeta);
    }
    if (data.containsKey('method')) {
      context.handle(
        _methodMeta,
        method.isAcceptableOrUnknown(data['method']!, _methodMeta),
      );
    } else if (isInserting) {
      context.missing(_methodMeta);
    }
    if (data.containsKey('manual_reason')) {
      context.handle(
        _manualReasonMeta,
        manualReason.isAcceptableOrUnknown(
          data['manual_reason']!,
          _manualReasonMeta,
        ),
      );
    }
    if (data.containsKey('official')) {
      context.handle(
        _officialMeta,
        official.isAcceptableOrUnknown(data['official']!, _officialMeta),
      );
    } else if (isInserting) {
      context.missing(_officialMeta);
    }
    if (data.containsKey('hour_bucket')) {
      context.handle(
        _hourBucketMeta,
        hourBucket.isAcceptableOrUnknown(data['hour_bucket']!, _hourBucketMeta),
      );
    } else if (isInserting) {
      context.missing(_hourBucketMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {voterId};
  @override
  CheckIn map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CheckIn(
      voterId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}voter_id'],
      )!,
      electionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}election_id'],
      )!,
      method: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}method'],
      )!,
      manualReason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}manual_reason'],
      ),
      official: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}official'],
      )!,
      hourBucket: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hour_bucket'],
      )!,
    );
  }

  @override
  $CheckInsTable createAlias(String alias) {
    return $CheckInsTable(attachedDatabase, alias);
  }
}

class CheckIn extends DataClass implements Insertable<CheckIn> {
  final String voterId;
  final String electionId;

  /// qr | name | manual
  final String method;
  final String? manualReason;
  final String official;

  /// Hour only, e.g. 2026-11-05T09, for turnout per hour.
  final String hourBucket;
  const CheckIn({
    required this.voterId,
    required this.electionId,
    required this.method,
    this.manualReason,
    required this.official,
    required this.hourBucket,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['voter_id'] = Variable<String>(voterId);
    map['election_id'] = Variable<String>(electionId);
    map['method'] = Variable<String>(method);
    if (!nullToAbsent || manualReason != null) {
      map['manual_reason'] = Variable<String>(manualReason);
    }
    map['official'] = Variable<String>(official);
    map['hour_bucket'] = Variable<String>(hourBucket);
    return map;
  }

  CheckInsCompanion toCompanion(bool nullToAbsent) {
    return CheckInsCompanion(
      voterId: Value(voterId),
      electionId: Value(electionId),
      method: Value(method),
      manualReason: manualReason == null && nullToAbsent
          ? const Value.absent()
          : Value(manualReason),
      official: Value(official),
      hourBucket: Value(hourBucket),
    );
  }

  factory CheckIn.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CheckIn(
      voterId: serializer.fromJson<String>(json['voterId']),
      electionId: serializer.fromJson<String>(json['electionId']),
      method: serializer.fromJson<String>(json['method']),
      manualReason: serializer.fromJson<String?>(json['manualReason']),
      official: serializer.fromJson<String>(json['official']),
      hourBucket: serializer.fromJson<String>(json['hourBucket']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'voterId': serializer.toJson<String>(voterId),
      'electionId': serializer.toJson<String>(electionId),
      'method': serializer.toJson<String>(method),
      'manualReason': serializer.toJson<String?>(manualReason),
      'official': serializer.toJson<String>(official),
      'hourBucket': serializer.toJson<String>(hourBucket),
    };
  }

  CheckIn copyWith({
    String? voterId,
    String? electionId,
    String? method,
    Value<String?> manualReason = const Value.absent(),
    String? official,
    String? hourBucket,
  }) => CheckIn(
    voterId: voterId ?? this.voterId,
    electionId: electionId ?? this.electionId,
    method: method ?? this.method,
    manualReason: manualReason.present ? manualReason.value : this.manualReason,
    official: official ?? this.official,
    hourBucket: hourBucket ?? this.hourBucket,
  );
  CheckIn copyWithCompanion(CheckInsCompanion data) {
    return CheckIn(
      voterId: data.voterId.present ? data.voterId.value : this.voterId,
      electionId: data.electionId.present
          ? data.electionId.value
          : this.electionId,
      method: data.method.present ? data.method.value : this.method,
      manualReason: data.manualReason.present
          ? data.manualReason.value
          : this.manualReason,
      official: data.official.present ? data.official.value : this.official,
      hourBucket: data.hourBucket.present
          ? data.hourBucket.value
          : this.hourBucket,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CheckIn(')
          ..write('voterId: $voterId, ')
          ..write('electionId: $electionId, ')
          ..write('method: $method, ')
          ..write('manualReason: $manualReason, ')
          ..write('official: $official, ')
          ..write('hourBucket: $hourBucket')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    voterId,
    electionId,
    method,
    manualReason,
    official,
    hourBucket,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CheckIn &&
          other.voterId == this.voterId &&
          other.electionId == this.electionId &&
          other.method == this.method &&
          other.manualReason == this.manualReason &&
          other.official == this.official &&
          other.hourBucket == this.hourBucket);
}

class CheckInsCompanion extends UpdateCompanion<CheckIn> {
  final Value<String> voterId;
  final Value<String> electionId;
  final Value<String> method;
  final Value<String?> manualReason;
  final Value<String> official;
  final Value<String> hourBucket;
  final Value<int> rowid;
  const CheckInsCompanion({
    this.voterId = const Value.absent(),
    this.electionId = const Value.absent(),
    this.method = const Value.absent(),
    this.manualReason = const Value.absent(),
    this.official = const Value.absent(),
    this.hourBucket = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CheckInsCompanion.insert({
    required String voterId,
    required String electionId,
    required String method,
    this.manualReason = const Value.absent(),
    required String official,
    required String hourBucket,
    this.rowid = const Value.absent(),
  }) : voterId = Value(voterId),
       electionId = Value(electionId),
       method = Value(method),
       official = Value(official),
       hourBucket = Value(hourBucket);
  static Insertable<CheckIn> custom({
    Expression<String>? voterId,
    Expression<String>? electionId,
    Expression<String>? method,
    Expression<String>? manualReason,
    Expression<String>? official,
    Expression<String>? hourBucket,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (voterId != null) 'voter_id': voterId,
      if (electionId != null) 'election_id': electionId,
      if (method != null) 'method': method,
      if (manualReason != null) 'manual_reason': manualReason,
      if (official != null) 'official': official,
      if (hourBucket != null) 'hour_bucket': hourBucket,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CheckInsCompanion copyWith({
    Value<String>? voterId,
    Value<String>? electionId,
    Value<String>? method,
    Value<String?>? manualReason,
    Value<String>? official,
    Value<String>? hourBucket,
    Value<int>? rowid,
  }) {
    return CheckInsCompanion(
      voterId: voterId ?? this.voterId,
      electionId: electionId ?? this.electionId,
      method: method ?? this.method,
      manualReason: manualReason ?? this.manualReason,
      official: official ?? this.official,
      hourBucket: hourBucket ?? this.hourBucket,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (voterId.present) {
      map['voter_id'] = Variable<String>(voterId.value);
    }
    if (electionId.present) {
      map['election_id'] = Variable<String>(electionId.value);
    }
    if (method.present) {
      map['method'] = Variable<String>(method.value);
    }
    if (manualReason.present) {
      map['manual_reason'] = Variable<String>(manualReason.value);
    }
    if (official.present) {
      map['official'] = Variable<String>(official.value);
    }
    if (hourBucket.present) {
      map['hour_bucket'] = Variable<String>(hourBucket.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CheckInsCompanion(')
          ..write('voterId: $voterId, ')
          ..write('electionId: $electionId, ')
          ..write('method: $method, ')
          ..write('manualReason: $manualReason, ')
          ..write('official: $official, ')
          ..write('hourBucket: $hourBucket, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $IssuedTokensTable extends IssuedTokens
    with TableInfo<$IssuedTokensTable, IssuedToken> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $IssuedTokensTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _stateMeta = const VerificationMeta('state');
  @override
  late final GeneratedColumn<String> state = GeneratedColumn<String>(
    'state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('active'),
  );
  @override
  List<GeneratedColumn> get $columns => [tokenHash, electionId, state];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'issued_tokens';
  @override
  VerificationContext validateIntegrity(
    Insertable<IssuedToken> instance, {
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
    if (data.containsKey('election_id')) {
      context.handle(
        _electionIdMeta,
        electionId.isAcceptableOrUnknown(data['election_id']!, _electionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_electionIdMeta);
    }
    if (data.containsKey('state')) {
      context.handle(
        _stateMeta,
        state.isAcceptableOrUnknown(data['state']!, _stateMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {tokenHash};
  @override
  IssuedToken map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return IssuedToken(
      tokenHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}token_hash'],
      )!,
      electionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}election_id'],
      )!,
      state: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}state'],
      )!,
    );
  }

  @override
  $IssuedTokensTable createAlias(String alias) {
    return $IssuedTokensTable(attachedDatabase, alias);
  }

  @override
  bool get withoutRowId => true;
}

class IssuedToken extends DataClass implements Insertable<IssuedToken> {
  final String tokenHash;
  final String electionId;

  /// active | used
  final String state;
  const IssuedToken({
    required this.tokenHash,
    required this.electionId,
    required this.state,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['token_hash'] = Variable<String>(tokenHash);
    map['election_id'] = Variable<String>(electionId);
    map['state'] = Variable<String>(state);
    return map;
  }

  IssuedTokensCompanion toCompanion(bool nullToAbsent) {
    return IssuedTokensCompanion(
      tokenHash: Value(tokenHash),
      electionId: Value(electionId),
      state: Value(state),
    );
  }

  factory IssuedToken.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return IssuedToken(
      tokenHash: serializer.fromJson<String>(json['tokenHash']),
      electionId: serializer.fromJson<String>(json['electionId']),
      state: serializer.fromJson<String>(json['state']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'tokenHash': serializer.toJson<String>(tokenHash),
      'electionId': serializer.toJson<String>(electionId),
      'state': serializer.toJson<String>(state),
    };
  }

  IssuedToken copyWith({
    String? tokenHash,
    String? electionId,
    String? state,
  }) => IssuedToken(
    tokenHash: tokenHash ?? this.tokenHash,
    electionId: electionId ?? this.electionId,
    state: state ?? this.state,
  );
  IssuedToken copyWithCompanion(IssuedTokensCompanion data) {
    return IssuedToken(
      tokenHash: data.tokenHash.present ? data.tokenHash.value : this.tokenHash,
      electionId: data.electionId.present
          ? data.electionId.value
          : this.electionId,
      state: data.state.present ? data.state.value : this.state,
    );
  }

  @override
  String toString() {
    return (StringBuffer('IssuedToken(')
          ..write('tokenHash: $tokenHash, ')
          ..write('electionId: $electionId, ')
          ..write('state: $state')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(tokenHash, electionId, state);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is IssuedToken &&
          other.tokenHash == this.tokenHash &&
          other.electionId == this.electionId &&
          other.state == this.state);
}

class IssuedTokensCompanion extends UpdateCompanion<IssuedToken> {
  final Value<String> tokenHash;
  final Value<String> electionId;
  final Value<String> state;
  const IssuedTokensCompanion({
    this.tokenHash = const Value.absent(),
    this.electionId = const Value.absent(),
    this.state = const Value.absent(),
  });
  IssuedTokensCompanion.insert({
    required String tokenHash,
    required String electionId,
    this.state = const Value.absent(),
  }) : tokenHash = Value(tokenHash),
       electionId = Value(electionId);
  static Insertable<IssuedToken> custom({
    Expression<String>? tokenHash,
    Expression<String>? electionId,
    Expression<String>? state,
  }) {
    return RawValuesInsertable({
      if (tokenHash != null) 'token_hash': tokenHash,
      if (electionId != null) 'election_id': electionId,
      if (state != null) 'state': state,
    });
  }

  IssuedTokensCompanion copyWith({
    Value<String>? tokenHash,
    Value<String>? electionId,
    Value<String>? state,
  }) {
    return IssuedTokensCompanion(
      tokenHash: tokenHash ?? this.tokenHash,
      electionId: electionId ?? this.electionId,
      state: state ?? this.state,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (tokenHash.present) {
      map['token_hash'] = Variable<String>(tokenHash.value);
    }
    if (electionId.present) {
      map['election_id'] = Variable<String>(electionId.value);
    }
    if (state.present) {
      map['state'] = Variable<String>(state.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IssuedTokensCompanion(')
          ..write('tokenHash: $tokenHash, ')
          ..write('electionId: $electionId, ')
          ..write('state: $state')
          ..write(')'))
        .toString();
  }
}

class $DeviceEnrollmentsTable extends DeviceEnrollments
    with TableInfo<$DeviceEnrollmentsTable, DeviceEnrollment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DeviceEnrollmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _signingPublicMeta = const VerificationMeta(
    'signingPublic',
  );
  @override
  late final GeneratedColumn<Uint8List> signingPublic =
      GeneratedColumn<Uint8List>(
        'signing_public',
        aliasedName,
        false,
        type: DriftSqlType.blob,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _exchangePublicMeta = const VerificationMeta(
    'exchangePublic',
  );
  @override
  late final GeneratedColumn<Uint8List> exchangePublic =
      GeneratedColumn<Uint8List>(
        'exchange_public',
        aliasedName,
        false,
        type: DriftSqlType.blob,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _enrolledByMeta = const VerificationMeta(
    'enrolledBy',
  );
  @override
  late final GeneratedColumn<String> enrolledBy = GeneratedColumn<String>(
    'enrolled_by',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _enrolledAtMeta = const VerificationMeta(
    'enrolledAt',
  );
  @override
  late final GeneratedColumn<DateTime> enrolledAt = GeneratedColumn<DateTime>(
    'enrolled_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _revokedMeta = const VerificationMeta(
    'revoked',
  );
  @override
  late final GeneratedColumn<bool> revoked = GeneratedColumn<bool>(
    'revoked',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("revoked" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    deviceId,
    role,
    signingPublic,
    exchangePublic,
    label,
    enrolledBy,
    enrolledAt,
    revoked,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'device_enrollments';
  @override
  VerificationContext validateIntegrity(
    Insertable<DeviceEnrollment> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
      );
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    if (data.containsKey('signing_public')) {
      context.handle(
        _signingPublicMeta,
        signingPublic.isAcceptableOrUnknown(
          data['signing_public']!,
          _signingPublicMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_signingPublicMeta);
    }
    if (data.containsKey('exchange_public')) {
      context.handle(
        _exchangePublicMeta,
        exchangePublic.isAcceptableOrUnknown(
          data['exchange_public']!,
          _exchangePublicMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_exchangePublicMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('enrolled_by')) {
      context.handle(
        _enrolledByMeta,
        enrolledBy.isAcceptableOrUnknown(data['enrolled_by']!, _enrolledByMeta),
      );
    } else if (isInserting) {
      context.missing(_enrolledByMeta);
    }
    if (data.containsKey('enrolled_at')) {
      context.handle(
        _enrolledAtMeta,
        enrolledAt.isAcceptableOrUnknown(data['enrolled_at']!, _enrolledAtMeta),
      );
    } else if (isInserting) {
      context.missing(_enrolledAtMeta);
    }
    if (data.containsKey('revoked')) {
      context.handle(
        _revokedMeta,
        revoked.isAcceptableOrUnknown(data['revoked']!, _revokedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {deviceId};
  @override
  DeviceEnrollment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DeviceEnrollment(
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role'],
      )!,
      signingPublic: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}signing_public'],
      )!,
      exchangePublic: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}exchange_public'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      enrolledBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}enrolled_by'],
      )!,
      enrolledAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}enrolled_at'],
      )!,
      revoked: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}revoked'],
      )!,
    );
  }

  @override
  $DeviceEnrollmentsTable createAlias(String alias) {
    return $DeviceEnrollmentsTable(attachedDatabase, alias);
  }
}

class DeviceEnrollment extends DataClass
    implements Insertable<DeviceEnrollment> {
  final String deviceId;

  /// admin | checkin | booth
  final String role;
  final Uint8List signingPublic;
  final Uint8List exchangePublic;
  final String label;
  final String enrolledBy;
  final DateTime enrolledAt;
  final bool revoked;
  const DeviceEnrollment({
    required this.deviceId,
    required this.role,
    required this.signingPublic,
    required this.exchangePublic,
    required this.label,
    required this.enrolledBy,
    required this.enrolledAt,
    required this.revoked,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['device_id'] = Variable<String>(deviceId);
    map['role'] = Variable<String>(role);
    map['signing_public'] = Variable<Uint8List>(signingPublic);
    map['exchange_public'] = Variable<Uint8List>(exchangePublic);
    map['label'] = Variable<String>(label);
    map['enrolled_by'] = Variable<String>(enrolledBy);
    map['enrolled_at'] = Variable<DateTime>(enrolledAt);
    map['revoked'] = Variable<bool>(revoked);
    return map;
  }

  DeviceEnrollmentsCompanion toCompanion(bool nullToAbsent) {
    return DeviceEnrollmentsCompanion(
      deviceId: Value(deviceId),
      role: Value(role),
      signingPublic: Value(signingPublic),
      exchangePublic: Value(exchangePublic),
      label: Value(label),
      enrolledBy: Value(enrolledBy),
      enrolledAt: Value(enrolledAt),
      revoked: Value(revoked),
    );
  }

  factory DeviceEnrollment.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DeviceEnrollment(
      deviceId: serializer.fromJson<String>(json['deviceId']),
      role: serializer.fromJson<String>(json['role']),
      signingPublic: serializer.fromJson<Uint8List>(json['signingPublic']),
      exchangePublic: serializer.fromJson<Uint8List>(json['exchangePublic']),
      label: serializer.fromJson<String>(json['label']),
      enrolledBy: serializer.fromJson<String>(json['enrolledBy']),
      enrolledAt: serializer.fromJson<DateTime>(json['enrolledAt']),
      revoked: serializer.fromJson<bool>(json['revoked']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'deviceId': serializer.toJson<String>(deviceId),
      'role': serializer.toJson<String>(role),
      'signingPublic': serializer.toJson<Uint8List>(signingPublic),
      'exchangePublic': serializer.toJson<Uint8List>(exchangePublic),
      'label': serializer.toJson<String>(label),
      'enrolledBy': serializer.toJson<String>(enrolledBy),
      'enrolledAt': serializer.toJson<DateTime>(enrolledAt),
      'revoked': serializer.toJson<bool>(revoked),
    };
  }

  DeviceEnrollment copyWith({
    String? deviceId,
    String? role,
    Uint8List? signingPublic,
    Uint8List? exchangePublic,
    String? label,
    String? enrolledBy,
    DateTime? enrolledAt,
    bool? revoked,
  }) => DeviceEnrollment(
    deviceId: deviceId ?? this.deviceId,
    role: role ?? this.role,
    signingPublic: signingPublic ?? this.signingPublic,
    exchangePublic: exchangePublic ?? this.exchangePublic,
    label: label ?? this.label,
    enrolledBy: enrolledBy ?? this.enrolledBy,
    enrolledAt: enrolledAt ?? this.enrolledAt,
    revoked: revoked ?? this.revoked,
  );
  DeviceEnrollment copyWithCompanion(DeviceEnrollmentsCompanion data) {
    return DeviceEnrollment(
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      role: data.role.present ? data.role.value : this.role,
      signingPublic: data.signingPublic.present
          ? data.signingPublic.value
          : this.signingPublic,
      exchangePublic: data.exchangePublic.present
          ? data.exchangePublic.value
          : this.exchangePublic,
      label: data.label.present ? data.label.value : this.label,
      enrolledBy: data.enrolledBy.present
          ? data.enrolledBy.value
          : this.enrolledBy,
      enrolledAt: data.enrolledAt.present
          ? data.enrolledAt.value
          : this.enrolledAt,
      revoked: data.revoked.present ? data.revoked.value : this.revoked,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DeviceEnrollment(')
          ..write('deviceId: $deviceId, ')
          ..write('role: $role, ')
          ..write('signingPublic: $signingPublic, ')
          ..write('exchangePublic: $exchangePublic, ')
          ..write('label: $label, ')
          ..write('enrolledBy: $enrolledBy, ')
          ..write('enrolledAt: $enrolledAt, ')
          ..write('revoked: $revoked')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    deviceId,
    role,
    $driftBlobEquality.hash(signingPublic),
    $driftBlobEquality.hash(exchangePublic),
    label,
    enrolledBy,
    enrolledAt,
    revoked,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DeviceEnrollment &&
          other.deviceId == this.deviceId &&
          other.role == this.role &&
          $driftBlobEquality.equals(other.signingPublic, this.signingPublic) &&
          $driftBlobEquality.equals(
            other.exchangePublic,
            this.exchangePublic,
          ) &&
          other.label == this.label &&
          other.enrolledBy == this.enrolledBy &&
          other.enrolledAt == this.enrolledAt &&
          other.revoked == this.revoked);
}

class DeviceEnrollmentsCompanion extends UpdateCompanion<DeviceEnrollment> {
  final Value<String> deviceId;
  final Value<String> role;
  final Value<Uint8List> signingPublic;
  final Value<Uint8List> exchangePublic;
  final Value<String> label;
  final Value<String> enrolledBy;
  final Value<DateTime> enrolledAt;
  final Value<bool> revoked;
  final Value<int> rowid;
  const DeviceEnrollmentsCompanion({
    this.deviceId = const Value.absent(),
    this.role = const Value.absent(),
    this.signingPublic = const Value.absent(),
    this.exchangePublic = const Value.absent(),
    this.label = const Value.absent(),
    this.enrolledBy = const Value.absent(),
    this.enrolledAt = const Value.absent(),
    this.revoked = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DeviceEnrollmentsCompanion.insert({
    required String deviceId,
    required String role,
    required Uint8List signingPublic,
    required Uint8List exchangePublic,
    required String label,
    required String enrolledBy,
    required DateTime enrolledAt,
    this.revoked = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : deviceId = Value(deviceId),
       role = Value(role),
       signingPublic = Value(signingPublic),
       exchangePublic = Value(exchangePublic),
       label = Value(label),
       enrolledBy = Value(enrolledBy),
       enrolledAt = Value(enrolledAt);
  static Insertable<DeviceEnrollment> custom({
    Expression<String>? deviceId,
    Expression<String>? role,
    Expression<Uint8List>? signingPublic,
    Expression<Uint8List>? exchangePublic,
    Expression<String>? label,
    Expression<String>? enrolledBy,
    Expression<DateTime>? enrolledAt,
    Expression<bool>? revoked,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (deviceId != null) 'device_id': deviceId,
      if (role != null) 'role': role,
      if (signingPublic != null) 'signing_public': signingPublic,
      if (exchangePublic != null) 'exchange_public': exchangePublic,
      if (label != null) 'label': label,
      if (enrolledBy != null) 'enrolled_by': enrolledBy,
      if (enrolledAt != null) 'enrolled_at': enrolledAt,
      if (revoked != null) 'revoked': revoked,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DeviceEnrollmentsCompanion copyWith({
    Value<String>? deviceId,
    Value<String>? role,
    Value<Uint8List>? signingPublic,
    Value<Uint8List>? exchangePublic,
    Value<String>? label,
    Value<String>? enrolledBy,
    Value<DateTime>? enrolledAt,
    Value<bool>? revoked,
    Value<int>? rowid,
  }) {
    return DeviceEnrollmentsCompanion(
      deviceId: deviceId ?? this.deviceId,
      role: role ?? this.role,
      signingPublic: signingPublic ?? this.signingPublic,
      exchangePublic: exchangePublic ?? this.exchangePublic,
      label: label ?? this.label,
      enrolledBy: enrolledBy ?? this.enrolledBy,
      enrolledAt: enrolledAt ?? this.enrolledAt,
      revoked: revoked ?? this.revoked,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (signingPublic.present) {
      map['signing_public'] = Variable<Uint8List>(signingPublic.value);
    }
    if (exchangePublic.present) {
      map['exchange_public'] = Variable<Uint8List>(exchangePublic.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (enrolledBy.present) {
      map['enrolled_by'] = Variable<String>(enrolledBy.value);
    }
    if (enrolledAt.present) {
      map['enrolled_at'] = Variable<DateTime>(enrolledAt.value);
    }
    if (revoked.present) {
      map['revoked'] = Variable<bool>(revoked.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DeviceEnrollmentsCompanion(')
          ..write('deviceId: $deviceId, ')
          ..write('role: $role, ')
          ..write('signingPublic: $signingPublic, ')
          ..write('exchangePublic: $exchangePublic, ')
          ..write('label: $label, ')
          ..write('enrolledBy: $enrolledBy, ')
          ..write('enrolledAt: $enrolledAt, ')
          ..write('revoked: $revoked, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ResultRecordsTable extends ResultRecords
    with TableInfo<$ResultRecordsTable, ResultRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ResultRecordsTable(this.attachedDatabase, [this._alias]);
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
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES elections (id)',
    ),
  );
  static const VerificationMeta _signedResultsMeta = const VerificationMeta(
    'signedResults',
  );
  @override
  late final GeneratedColumn<String> signedResults = GeneratedColumn<String>(
    'signed_results',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fingerprintMeta = const VerificationMeta(
    'fingerprint',
  );
  @override
  late final GeneratedColumn<String> fingerprint = GeneratedColumn<String>(
    'fingerprint',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _paperCountsMeta = const VerificationMeta(
    'paperCounts',
  );
  @override
  late final GeneratedColumn<String> paperCounts = GeneratedColumn<String>(
    'paper_counts',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    electionId,
    signedResults,
    fingerprint,
    paperCounts,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'result_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<ResultRecord> instance, {
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
    if (data.containsKey('signed_results')) {
      context.handle(
        _signedResultsMeta,
        signedResults.isAcceptableOrUnknown(
          data['signed_results']!,
          _signedResultsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_signedResultsMeta);
    }
    if (data.containsKey('fingerprint')) {
      context.handle(
        _fingerprintMeta,
        fingerprint.isAcceptableOrUnknown(
          data['fingerprint']!,
          _fingerprintMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fingerprintMeta);
    }
    if (data.containsKey('paper_counts')) {
      context.handle(
        _paperCountsMeta,
        paperCounts.isAcceptableOrUnknown(
          data['paper_counts']!,
          _paperCountsMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {electionId};
  @override
  ResultRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ResultRecord(
      electionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}election_id'],
      )!,
      signedResults: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}signed_results'],
      )!,
      fingerprint: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fingerprint'],
      )!,
      paperCounts: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}paper_counts'],
      ),
    );
  }

  @override
  $ResultRecordsTable createAlias(String alias) {
    return $ResultRecordsTable(attachedDatabase, alias);
  }
}

class ResultRecord extends DataClass implements Insertable<ResultRecord> {
  final String electionId;

  /// Signed results (SignedArtifact JSON).
  final String signedResults;
  final String fingerprint;

  /// JSON of hand-counted receipt totals, entered after the paper recount.
  final String? paperCounts;
  const ResultRecord({
    required this.electionId,
    required this.signedResults,
    required this.fingerprint,
    this.paperCounts,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['election_id'] = Variable<String>(electionId);
    map['signed_results'] = Variable<String>(signedResults);
    map['fingerprint'] = Variable<String>(fingerprint);
    if (!nullToAbsent || paperCounts != null) {
      map['paper_counts'] = Variable<String>(paperCounts);
    }
    return map;
  }

  ResultRecordsCompanion toCompanion(bool nullToAbsent) {
    return ResultRecordsCompanion(
      electionId: Value(electionId),
      signedResults: Value(signedResults),
      fingerprint: Value(fingerprint),
      paperCounts: paperCounts == null && nullToAbsent
          ? const Value.absent()
          : Value(paperCounts),
    );
  }

  factory ResultRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ResultRecord(
      electionId: serializer.fromJson<String>(json['electionId']),
      signedResults: serializer.fromJson<String>(json['signedResults']),
      fingerprint: serializer.fromJson<String>(json['fingerprint']),
      paperCounts: serializer.fromJson<String?>(json['paperCounts']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'electionId': serializer.toJson<String>(electionId),
      'signedResults': serializer.toJson<String>(signedResults),
      'fingerprint': serializer.toJson<String>(fingerprint),
      'paperCounts': serializer.toJson<String?>(paperCounts),
    };
  }

  ResultRecord copyWith({
    String? electionId,
    String? signedResults,
    String? fingerprint,
    Value<String?> paperCounts = const Value.absent(),
  }) => ResultRecord(
    electionId: electionId ?? this.electionId,
    signedResults: signedResults ?? this.signedResults,
    fingerprint: fingerprint ?? this.fingerprint,
    paperCounts: paperCounts.present ? paperCounts.value : this.paperCounts,
  );
  ResultRecord copyWithCompanion(ResultRecordsCompanion data) {
    return ResultRecord(
      electionId: data.electionId.present
          ? data.electionId.value
          : this.electionId,
      signedResults: data.signedResults.present
          ? data.signedResults.value
          : this.signedResults,
      fingerprint: data.fingerprint.present
          ? data.fingerprint.value
          : this.fingerprint,
      paperCounts: data.paperCounts.present
          ? data.paperCounts.value
          : this.paperCounts,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ResultRecord(')
          ..write('electionId: $electionId, ')
          ..write('signedResults: $signedResults, ')
          ..write('fingerprint: $fingerprint, ')
          ..write('paperCounts: $paperCounts')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(electionId, signedResults, fingerprint, paperCounts);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ResultRecord &&
          other.electionId == this.electionId &&
          other.signedResults == this.signedResults &&
          other.fingerprint == this.fingerprint &&
          other.paperCounts == this.paperCounts);
}

class ResultRecordsCompanion extends UpdateCompanion<ResultRecord> {
  final Value<String> electionId;
  final Value<String> signedResults;
  final Value<String> fingerprint;
  final Value<String?> paperCounts;
  final Value<int> rowid;
  const ResultRecordsCompanion({
    this.electionId = const Value.absent(),
    this.signedResults = const Value.absent(),
    this.fingerprint = const Value.absent(),
    this.paperCounts = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ResultRecordsCompanion.insert({
    required String electionId,
    required String signedResults,
    required String fingerprint,
    this.paperCounts = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : electionId = Value(electionId),
       signedResults = Value(signedResults),
       fingerprint = Value(fingerprint);
  static Insertable<ResultRecord> custom({
    Expression<String>? electionId,
    Expression<String>? signedResults,
    Expression<String>? fingerprint,
    Expression<String>? paperCounts,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (electionId != null) 'election_id': electionId,
      if (signedResults != null) 'signed_results': signedResults,
      if (fingerprint != null) 'fingerprint': fingerprint,
      if (paperCounts != null) 'paper_counts': paperCounts,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ResultRecordsCompanion copyWith({
    Value<String>? electionId,
    Value<String>? signedResults,
    Value<String>? fingerprint,
    Value<String?>? paperCounts,
    Value<int>? rowid,
  }) {
    return ResultRecordsCompanion(
      electionId: electionId ?? this.electionId,
      signedResults: signedResults ?? this.signedResults,
      fingerprint: fingerprint ?? this.fingerprint,
      paperCounts: paperCounts ?? this.paperCounts,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (electionId.present) {
      map['election_id'] = Variable<String>(electionId.value);
    }
    if (signedResults.present) {
      map['signed_results'] = Variable<String>(signedResults.value);
    }
    if (fingerprint.present) {
      map['fingerprint'] = Variable<String>(fingerprint.value);
    }
    if (paperCounts.present) {
      map['paper_counts'] = Variable<String>(paperCounts.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ResultRecordsCompanion(')
          ..write('electionId: $electionId, ')
          ..write('signedResults: $signedResults, ')
          ..write('fingerprint: $fingerprint, ')
          ..write('paperCounts: $paperCounts, ')
          ..write('rowid: $rowid')
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

abstract class _$RegistryDb extends GeneratedDatabase {
  _$RegistryDb(QueryExecutor e) : super(e);
  $RegistryDbManager get managers => $RegistryDbManager(this);
  late final $ElectionsTable elections = $ElectionsTable(this);
  late final $FeeConfigsTable feeConfigs = $FeeConfigsTable(this);
  late final $PositionsTable positions = $PositionsTable(this);
  late final $CandidatesTable candidates = $CandidatesTable(this);
  late final $VotersTable voters = $VotersTable(this);
  late final $FeePaymentsTable feePayments = $FeePaymentsTable(this);
  late final $ObjectionsTable objections = $ObjectionsTable(this);
  late final $RegisterLocksTable registerLocks = $RegisterLocksTable(this);
  late final $CheckInsTable checkIns = $CheckInsTable(this);
  late final $IssuedTokensTable issuedTokens = $IssuedTokensTable(this);
  late final $DeviceEnrollmentsTable deviceEnrollments =
      $DeviceEnrollmentsTable(this);
  late final $ResultRecordsTable resultRecords = $ResultRecordsTable(this);
  late final $AuditLogTable auditLog = $AuditLogTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    elections,
    feeConfigs,
    positions,
    candidates,
    voters,
    feePayments,
    objections,
    registerLocks,
    checkIns,
    issuedTokens,
    deviceEnrollments,
    resultRecords,
    auditLog,
  ];
}

typedef $$ElectionsTableCreateCompanionBuilder = ElectionsCompanion Function({
  required String id,
  required String orgName,
  Value<Uint8List?> orgLogo,
  required String name,
  required int year,
  required String template,
  required String languages,
  required String idLabel,
  required String groupLabel,
  required String stationName,
  Value<String> state,
  Value<DateTime?> reviewStart,
  Value<DateTime?> reviewEnd,
  Value<bool> schoolConsentRecorded,
  Value<String?> schoolConsentBy,
  Value<DateTime?> schoolConsentAt,
  Value<String?> signedBallot,
  Value<int> lastVoterNo,
  Value<int> rowid,
});
typedef $$ElectionsTableUpdateCompanionBuilder = ElectionsCompanion Function({
  Value<String> id,
  Value<String> orgName,
  Value<Uint8List?> orgLogo,
  Value<String> name,
  Value<int> year,
  Value<String> template,
  Value<String> languages,
  Value<String> idLabel,
  Value<String> groupLabel,
  Value<String> stationName,
  Value<String> state,
  Value<DateTime?> reviewStart,
  Value<DateTime?> reviewEnd,
  Value<bool> schoolConsentRecorded,
  Value<String?> schoolConsentBy,
  Value<DateTime?> schoolConsentAt,
  Value<String?> signedBallot,
  Value<int> lastVoterNo,
  Value<int> rowid,
});

final class $$ElectionsTableReferences
    extends BaseReferences<_$RegistryDb, $ElectionsTable, Election> {
  $$ElectionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$FeeConfigsTable, List<FeeConfig>>
  _feeConfigsRefsTable(_$RegistryDb db) => MultiTypedResultKey.fromTable(
    db.feeConfigs,
    aliasName: 'elections__id__fee_configs__election_id',
  );

  $$FeeConfigsTableProcessedTableManager get feeConfigsRefs {
    final manager = $$FeeConfigsTableTableManager(
      $_db,
      $_db.feeConfigs,
    ).filter((f) => f.electionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_feeConfigsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PositionsTable, List<Position>>
  _positionsRefsTable(_$RegistryDb db) => MultiTypedResultKey.fromTable(
    db.positions,
    aliasName: 'elections__id__positions__election_id',
  );

  $$PositionsTableProcessedTableManager get positionsRefs {
    final manager = $$PositionsTableTableManager(
      $_db,
      $_db.positions,
    ).filter((f) => f.electionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_positionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$VotersTable, List<Voter>> _votersRefsTable(
    _$RegistryDb db,
  ) => MultiTypedResultKey.fromTable(
    db.voters,
    aliasName: 'elections__id__voters__election_id',
  );

  $$VotersTableProcessedTableManager get votersRefs {
    final manager = $$VotersTableTableManager(
      $_db,
      $_db.voters,
    ).filter((f) => f.electionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_votersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ObjectionsTable, List<Objection>>
  _objectionsRefsTable(_$RegistryDb db) => MultiTypedResultKey.fromTable(
    db.objections,
    aliasName: 'elections__id__objections__election_id',
  );

  $$ObjectionsTableProcessedTableManager get objectionsRefs {
    final manager = $$ObjectionsTableTableManager(
      $_db,
      $_db.objections,
    ).filter((f) => f.electionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_objectionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$RegisterLocksTable, List<RegisterLock>>
  _registerLocksRefsTable(_$RegistryDb db) => MultiTypedResultKey.fromTable(
    db.registerLocks,
    aliasName: 'elections__id__register_locks__election_id',
  );

  $$RegisterLocksTableProcessedTableManager get registerLocksRefs {
    final manager = $$RegisterLocksTableTableManager(
      $_db,
      $_db.registerLocks,
    ).filter((f) => f.electionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_registerLocksRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$CheckInsTable, List<CheckIn>> _checkInsRefsTable(
    _$RegistryDb db,
  ) => MultiTypedResultKey.fromTable(
    db.checkIns,
    aliasName: 'elections__id__check_ins__election_id',
  );

  $$CheckInsTableProcessedTableManager get checkInsRefs {
    final manager = $$CheckInsTableTableManager(
      $_db,
      $_db.checkIns,
    ).filter((f) => f.electionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_checkInsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ResultRecordsTable, List<ResultRecord>>
  _resultRecordsRefsTable(_$RegistryDb db) => MultiTypedResultKey.fromTable(
    db.resultRecords,
    aliasName: 'elections__id__result_records__election_id',
  );

  $$ResultRecordsTableProcessedTableManager get resultRecordsRefs {
    final manager = $$ResultRecordsTableTableManager(
      $_db,
      $_db.resultRecords,
    ).filter((f) => f.electionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_resultRecordsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ElectionsTableFilterComposer
    extends Composer<_$RegistryDb, $ElectionsTable> {
  $$ElectionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get orgName => $composableBuilder(
    column: $table.orgName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<Uint8List> get orgLogo => $composableBuilder(
    column: $table.orgLogo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get template => $composableBuilder(
    column: $table.template,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get languages => $composableBuilder(
    column: $table.languages,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get idLabel => $composableBuilder(
    column: $table.idLabel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get groupLabel => $composableBuilder(
    column: $table.groupLabel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get stationName => $composableBuilder(
    column: $table.stationName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get reviewStart => $composableBuilder(
    column: $table.reviewStart,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get reviewEnd => $composableBuilder(
    column: $table.reviewEnd,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get schoolConsentRecorded => $composableBuilder(
    column: $table.schoolConsentRecorded,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get schoolConsentBy => $composableBuilder(
    column: $table.schoolConsentBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get schoolConsentAt => $composableBuilder(
    column: $table.schoolConsentAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get signedBallot => $composableBuilder(
    column: $table.signedBallot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastVoterNo => $composableBuilder(
    column: $table.lastVoterNo,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> feeConfigsRefs(
    Expression<bool> Function($$FeeConfigsTableFilterComposer f) f,
  ) {
    final $$FeeConfigsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.feeConfigs,
      getReferencedColumn: (t) => t.electionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FeeConfigsTableFilterComposer(
            $db: $db,
            $table: $db.feeConfigs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> positionsRefs(
    Expression<bool> Function($$PositionsTableFilterComposer f) f,
  ) {
    final $$PositionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.positions,
      getReferencedColumn: (t) => t.electionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PositionsTableFilterComposer(
            $db: $db,
            $table: $db.positions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> votersRefs(
    Expression<bool> Function($$VotersTableFilterComposer f) f,
  ) {
    final $$VotersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.voters,
      getReferencedColumn: (t) => t.electionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VotersTableFilterComposer(
            $db: $db,
            $table: $db.voters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> objectionsRefs(
    Expression<bool> Function($$ObjectionsTableFilterComposer f) f,
  ) {
    final $$ObjectionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.objections,
      getReferencedColumn: (t) => t.electionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ObjectionsTableFilterComposer(
            $db: $db,
            $table: $db.objections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> registerLocksRefs(
    Expression<bool> Function($$RegisterLocksTableFilterComposer f) f,
  ) {
    final $$RegisterLocksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.registerLocks,
      getReferencedColumn: (t) => t.electionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RegisterLocksTableFilterComposer(
            $db: $db,
            $table: $db.registerLocks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> checkInsRefs(
    Expression<bool> Function($$CheckInsTableFilterComposer f) f,
  ) {
    final $$CheckInsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.checkIns,
      getReferencedColumn: (t) => t.electionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CheckInsTableFilterComposer(
            $db: $db,
            $table: $db.checkIns,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> resultRecordsRefs(
    Expression<bool> Function($$ResultRecordsTableFilterComposer f) f,
  ) {
    final $$ResultRecordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.resultRecords,
      getReferencedColumn: (t) => t.electionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ResultRecordsTableFilterComposer(
            $db: $db,
            $table: $db.resultRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ElectionsTableOrderingComposer
    extends Composer<_$RegistryDb, $ElectionsTable> {
  $$ElectionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get orgName => $composableBuilder(
    column: $table.orgName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<Uint8List> get orgLogo => $composableBuilder(
    column: $table.orgLogo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get template => $composableBuilder(
    column: $table.template,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get languages => $composableBuilder(
    column: $table.languages,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get idLabel => $composableBuilder(
    column: $table.idLabel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get groupLabel => $composableBuilder(
    column: $table.groupLabel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get stationName => $composableBuilder(
    column: $table.stationName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get reviewStart => $composableBuilder(
    column: $table.reviewStart,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get reviewEnd => $composableBuilder(
    column: $table.reviewEnd,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get schoolConsentRecorded => $composableBuilder(
    column: $table.schoolConsentRecorded,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get schoolConsentBy => $composableBuilder(
    column: $table.schoolConsentBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get schoolConsentAt => $composableBuilder(
    column: $table.schoolConsentAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get signedBallot => $composableBuilder(
    column: $table.signedBallot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastVoterNo => $composableBuilder(
    column: $table.lastVoterNo,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ElectionsTableAnnotationComposer
    extends Composer<_$RegistryDb, $ElectionsTable> {
  $$ElectionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get orgName =>
      $composableBuilder(column: $table.orgName, builder: (column) => column);

  GeneratedColumn<Uint8List> get orgLogo =>
      $composableBuilder(column: $table.orgLogo, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get year =>
      $composableBuilder(column: $table.year, builder: (column) => column);

  GeneratedColumn<String> get template =>
      $composableBuilder(column: $table.template, builder: (column) => column);

  GeneratedColumn<String> get languages =>
      $composableBuilder(column: $table.languages, builder: (column) => column);

  GeneratedColumn<String> get idLabel =>
      $composableBuilder(column: $table.idLabel, builder: (column) => column);

  GeneratedColumn<String> get groupLabel => $composableBuilder(
    column: $table.groupLabel,
    builder: (column) => column,
  );

  GeneratedColumn<String> get stationName => $composableBuilder(
    column: $table.stationName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get state =>
      $composableBuilder(column: $table.state, builder: (column) => column);

  GeneratedColumn<DateTime> get reviewStart => $composableBuilder(
    column: $table.reviewStart,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get reviewEnd =>
      $composableBuilder(column: $table.reviewEnd, builder: (column) => column);

  GeneratedColumn<bool> get schoolConsentRecorded => $composableBuilder(
    column: $table.schoolConsentRecorded,
    builder: (column) => column,
  );

  GeneratedColumn<String> get schoolConsentBy => $composableBuilder(
    column: $table.schoolConsentBy,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get schoolConsentAt => $composableBuilder(
    column: $table.schoolConsentAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get signedBallot => $composableBuilder(
    column: $table.signedBallot,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lastVoterNo => $composableBuilder(
    column: $table.lastVoterNo,
    builder: (column) => column,
  );

  Expression<T> feeConfigsRefs<T extends Object>(
    Expression<T> Function($$FeeConfigsTableAnnotationComposer a) f,
  ) {
    final $$FeeConfigsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.feeConfigs,
      getReferencedColumn: (t) => t.electionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FeeConfigsTableAnnotationComposer(
            $db: $db,
            $table: $db.feeConfigs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> positionsRefs<T extends Object>(
    Expression<T> Function($$PositionsTableAnnotationComposer a) f,
  ) {
    final $$PositionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.positions,
      getReferencedColumn: (t) => t.electionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PositionsTableAnnotationComposer(
            $db: $db,
            $table: $db.positions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> votersRefs<T extends Object>(
    Expression<T> Function($$VotersTableAnnotationComposer a) f,
  ) {
    final $$VotersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.voters,
      getReferencedColumn: (t) => t.electionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VotersTableAnnotationComposer(
            $db: $db,
            $table: $db.voters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> objectionsRefs<T extends Object>(
    Expression<T> Function($$ObjectionsTableAnnotationComposer a) f,
  ) {
    final $$ObjectionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.objections,
      getReferencedColumn: (t) => t.electionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ObjectionsTableAnnotationComposer(
            $db: $db,
            $table: $db.objections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> registerLocksRefs<T extends Object>(
    Expression<T> Function($$RegisterLocksTableAnnotationComposer a) f,
  ) {
    final $$RegisterLocksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.registerLocks,
      getReferencedColumn: (t) => t.electionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RegisterLocksTableAnnotationComposer(
            $db: $db,
            $table: $db.registerLocks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> checkInsRefs<T extends Object>(
    Expression<T> Function($$CheckInsTableAnnotationComposer a) f,
  ) {
    final $$CheckInsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.checkIns,
      getReferencedColumn: (t) => t.electionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CheckInsTableAnnotationComposer(
            $db: $db,
            $table: $db.checkIns,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> resultRecordsRefs<T extends Object>(
    Expression<T> Function($$ResultRecordsTableAnnotationComposer a) f,
  ) {
    final $$ResultRecordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.resultRecords,
      getReferencedColumn: (t) => t.electionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ResultRecordsTableAnnotationComposer(
            $db: $db,
            $table: $db.resultRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ElectionsTableTableManager
    extends
        RootTableManager<
          _$RegistryDb,
          $ElectionsTable,
          Election,
          $$ElectionsTableFilterComposer,
          $$ElectionsTableOrderingComposer,
          $$ElectionsTableAnnotationComposer,
          $$ElectionsTableCreateCompanionBuilder,
          $$ElectionsTableUpdateCompanionBuilder,
          (Election, $$ElectionsTableReferences),
          Election,
          PrefetchHooks Function({
            bool feeConfigsRefs,
            bool positionsRefs,
            bool votersRefs,
            bool objectionsRefs,
            bool registerLocksRefs,
            bool checkInsRefs,
            bool resultRecordsRefs,
          })
        > {
  $$ElectionsTableTableManager(_$RegistryDb db, $ElectionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ElectionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ElectionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ElectionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> orgName = const Value.absent(),
                Value<Uint8List?> orgLogo = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> year = const Value.absent(),
                Value<String> template = const Value.absent(),
                Value<String> languages = const Value.absent(),
                Value<String> idLabel = const Value.absent(),
                Value<String> groupLabel = const Value.absent(),
                Value<String> stationName = const Value.absent(),
                Value<String> state = const Value.absent(),
                Value<DateTime?> reviewStart = const Value.absent(),
                Value<DateTime?> reviewEnd = const Value.absent(),
                Value<bool> schoolConsentRecorded = const Value.absent(),
                Value<String?> schoolConsentBy = const Value.absent(),
                Value<DateTime?> schoolConsentAt = const Value.absent(),
                Value<String?> signedBallot = const Value.absent(),
                Value<int> lastVoterNo = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ElectionsCompanion(
                id: id,
                orgName: orgName,
                orgLogo: orgLogo,
                name: name,
                year: year,
                template: template,
                languages: languages,
                idLabel: idLabel,
                groupLabel: groupLabel,
                stationName: stationName,
                state: state,
                reviewStart: reviewStart,
                reviewEnd: reviewEnd,
                schoolConsentRecorded: schoolConsentRecorded,
                schoolConsentBy: schoolConsentBy,
                schoolConsentAt: schoolConsentAt,
                signedBallot: signedBallot,
                lastVoterNo: lastVoterNo,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String orgName,
                Value<Uint8List?> orgLogo = const Value.absent(),
                required String name,
                required int year,
                required String template,
                required String languages,
                required String idLabel,
                required String groupLabel,
                required String stationName,
                Value<String> state = const Value.absent(),
                Value<DateTime?> reviewStart = const Value.absent(),
                Value<DateTime?> reviewEnd = const Value.absent(),
                Value<bool> schoolConsentRecorded = const Value.absent(),
                Value<String?> schoolConsentBy = const Value.absent(),
                Value<DateTime?> schoolConsentAt = const Value.absent(),
                Value<String?> signedBallot = const Value.absent(),
                Value<int> lastVoterNo = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ElectionsCompanion.insert(
                id: id,
                orgName: orgName,
                orgLogo: orgLogo,
                name: name,
                year: year,
                template: template,
                languages: languages,
                idLabel: idLabel,
                groupLabel: groupLabel,
                stationName: stationName,
                state: state,
                reviewStart: reviewStart,
                reviewEnd: reviewEnd,
                schoolConsentRecorded: schoolConsentRecorded,
                schoolConsentBy: schoolConsentBy,
                schoolConsentAt: schoolConsentAt,
                signedBallot: signedBallot,
                lastVoterNo: lastVoterNo,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ElectionsTable, Election>(table),
                  $$ElectionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                feeConfigsRefs = false,
                positionsRefs = false,
                votersRefs = false,
                objectionsRefs = false,
                registerLocksRefs = false,
                checkInsRefs = false,
                resultRecordsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (feeConfigsRefs) db.feeConfigs,
                    if (positionsRefs) db.positions,
                    if (votersRefs) db.voters,
                    if (objectionsRefs) db.objections,
                    if (registerLocksRefs) db.registerLocks,
                    if (checkInsRefs) db.checkIns,
                    if (resultRecordsRefs) db.resultRecords,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (feeConfigsRefs)
                        await $_getPrefetchedDataByColumns<
                          Election,
                          $ElectionsTable,
                          FeeConfig,
                          $FeeConfigsTable
                        >(
                          currentTable: table,
                          referencedTable: $$ElectionsTableReferences
                              ._feeConfigsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ElectionsTableReferences(
                                db,
                                table,
                                p0,
                              ).feeConfigsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'election_id',
                          typedResults: items,
                        ),
                      if (positionsRefs)
                        await $_getPrefetchedDataByColumns<
                          Election,
                          $ElectionsTable,
                          Position,
                          $PositionsTable
                        >(
                          currentTable: table,
                          referencedTable: $$ElectionsTableReferences
                              ._positionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ElectionsTableReferences(
                                db,
                                table,
                                p0,
                              ).positionsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'election_id',
                          typedResults: items,
                        ),
                      if (votersRefs)
                        await $_getPrefetchedDataByColumns<
                          Election,
                          $ElectionsTable,
                          Voter,
                          $VotersTable
                        >(
                          currentTable: table,
                          referencedTable: $$ElectionsTableReferences
                              ._votersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ElectionsTableReferences(
                                db,
                                table,
                                p0,
                              ).votersRefs,
                          currentColumn: 'id',
                          referencedColumn: 'election_id',
                          typedResults: items,
                        ),
                      if (objectionsRefs)
                        await $_getPrefetchedDataByColumns<
                          Election,
                          $ElectionsTable,
                          Objection,
                          $ObjectionsTable
                        >(
                          currentTable: table,
                          referencedTable: $$ElectionsTableReferences
                              ._objectionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ElectionsTableReferences(
                                db,
                                table,
                                p0,
                              ).objectionsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'election_id',
                          typedResults: items,
                        ),
                      if (registerLocksRefs)
                        await $_getPrefetchedDataByColumns<
                          Election,
                          $ElectionsTable,
                          RegisterLock,
                          $RegisterLocksTable
                        >(
                          currentTable: table,
                          referencedTable: $$ElectionsTableReferences
                              ._registerLocksRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ElectionsTableReferences(
                                db,
                                table,
                                p0,
                              ).registerLocksRefs,
                          currentColumn: 'id',
                          referencedColumn: 'election_id',
                          typedResults: items,
                        ),
                      if (checkInsRefs)
                        await $_getPrefetchedDataByColumns<
                          Election,
                          $ElectionsTable,
                          CheckIn,
                          $CheckInsTable
                        >(
                          currentTable: table,
                          referencedTable: $$ElectionsTableReferences
                              ._checkInsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ElectionsTableReferences(
                                db,
                                table,
                                p0,
                              ).checkInsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'election_id',
                          typedResults: items,
                        ),
                      if (resultRecordsRefs)
                        await $_getPrefetchedDataByColumns<
                          Election,
                          $ElectionsTable,
                          ResultRecord,
                          $ResultRecordsTable
                        >(
                          currentTable: table,
                          referencedTable: $$ElectionsTableReferences
                              ._resultRecordsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ElectionsTableReferences(
                                db,
                                table,
                                p0,
                              ).resultRecordsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'election_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ElectionsTableProcessedTableManager =
    ProcessedTableManager<
      _$RegistryDb,
      $ElectionsTable,
      Election,
      $$ElectionsTableFilterComposer,
      $$ElectionsTableOrderingComposer,
      $$ElectionsTableAnnotationComposer,
      $$ElectionsTableCreateCompanionBuilder,
      $$ElectionsTableUpdateCompanionBuilder,
      (Election, $$ElectionsTableReferences),
      Election,
      PrefetchHooks Function({
        bool feeConfigsRefs,
        bool positionsRefs,
        bool votersRefs,
        bool objectionsRefs,
        bool registerLocksRefs,
        bool checkInsRefs,
        bool resultRecordsRefs,
      })
    >;
typedef $$FeeConfigsTableCreateCompanionBuilder = FeeConfigsCompanion Function({
  required String electionId,
  required bool enabled,
  Value<int> amount,
  Value<String> currency,
  Value<String> unpaidPolicy,
  Value<int> rowid,
});
typedef $$FeeConfigsTableUpdateCompanionBuilder = FeeConfigsCompanion Function({
  Value<String> electionId,
  Value<bool> enabled,
  Value<int> amount,
  Value<String> currency,
  Value<String> unpaidPolicy,
  Value<int> rowid,
});

final class $$FeeConfigsTableReferences
    extends BaseReferences<_$RegistryDb, $FeeConfigsTable, FeeConfig> {
  $$FeeConfigsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ElectionsTable _electionIdTable(_$RegistryDb db) =>
      db.elections.createAlias('fee_configs__election_id__elections__id');

  $$ElectionsTableProcessedTableManager get electionId {
    final $_column = $_itemColumn<String>('election_id')!;

    final manager = $$ElectionsTableTableManager(
      $_db,
      $_db.elections,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_electionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$FeeConfigsTableFilterComposer
    extends Composer<_$RegistryDb, $FeeConfigsTable> {
  $$FeeConfigsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unpaidPolicy => $composableBuilder(
    column: $table.unpaidPolicy,
    builder: (column) => ColumnFilters(column),
  );

  $$ElectionsTableFilterComposer get electionId {
    final $$ElectionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.electionId,
      referencedTable: $db.elections,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ElectionsTableFilterComposer(
            $db: $db,
            $table: $db.elections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FeeConfigsTableOrderingComposer
    extends Composer<_$RegistryDb, $FeeConfigsTable> {
  $$FeeConfigsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unpaidPolicy => $composableBuilder(
    column: $table.unpaidPolicy,
    builder: (column) => ColumnOrderings(column),
  );

  $$ElectionsTableOrderingComposer get electionId {
    final $$ElectionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.electionId,
      referencedTable: $db.elections,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ElectionsTableOrderingComposer(
            $db: $db,
            $table: $db.elections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FeeConfigsTableAnnotationComposer
    extends Composer<_$RegistryDb, $FeeConfigsTable> {
  $$FeeConfigsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => column);

  GeneratedColumn<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<String> get unpaidPolicy => $composableBuilder(
    column: $table.unpaidPolicy,
    builder: (column) => column,
  );

  $$ElectionsTableAnnotationComposer get electionId {
    final $$ElectionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.electionId,
      referencedTable: $db.elections,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ElectionsTableAnnotationComposer(
            $db: $db,
            $table: $db.elections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FeeConfigsTableTableManager
    extends
        RootTableManager<
          _$RegistryDb,
          $FeeConfigsTable,
          FeeConfig,
          $$FeeConfigsTableFilterComposer,
          $$FeeConfigsTableOrderingComposer,
          $$FeeConfigsTableAnnotationComposer,
          $$FeeConfigsTableCreateCompanionBuilder,
          $$FeeConfigsTableUpdateCompanionBuilder,
          (FeeConfig, $$FeeConfigsTableReferences),
          FeeConfig,
          PrefetchHooks Function({bool electionId})
        > {
  $$FeeConfigsTableTableManager(_$RegistryDb db, $FeeConfigsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FeeConfigsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FeeConfigsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FeeConfigsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> electionId = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
                Value<int> amount = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<String> unpaidPolicy = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FeeConfigsCompanion(
                electionId: electionId,
                enabled: enabled,
                amount: amount,
                currency: currency,
                unpaidPolicy: unpaidPolicy,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String electionId,
                required bool enabled,
                Value<int> amount = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<String> unpaidPolicy = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FeeConfigsCompanion.insert(
                electionId: electionId,
                enabled: enabled,
                amount: amount,
                currency: currency,
                unpaidPolicy: unpaidPolicy,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$FeeConfigsTable, FeeConfig>(table),
                  $$FeeConfigsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({electionId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (electionId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.electionId,
                        referencedTable: $$FeeConfigsTableReferences
                            ._electionIdTable(db),
                        referencedColumn: $$FeeConfigsTableReferences
                            ._electionIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$FeeConfigsTableProcessedTableManager =
    ProcessedTableManager<
      _$RegistryDb,
      $FeeConfigsTable,
      FeeConfig,
      $$FeeConfigsTableFilterComposer,
      $$FeeConfigsTableOrderingComposer,
      $$FeeConfigsTableAnnotationComposer,
      $$FeeConfigsTableCreateCompanionBuilder,
      $$FeeConfigsTableUpdateCompanionBuilder,
      (FeeConfig, $$FeeConfigsTableReferences),
      FeeConfig,
      PrefetchHooks Function({bool electionId})
    >;
typedef $$PositionsTableCreateCompanionBuilder = PositionsCompanion Function({
  required String id,
  required String electionId,
  required int sortOrder,
  required String titles,
  required int colour,
  Value<int> chooseN,
  Value<bool> allowNoChoice,
  Value<int> rowid,
});
typedef $$PositionsTableUpdateCompanionBuilder = PositionsCompanion Function({
  Value<String> id,
  Value<String> electionId,
  Value<int> sortOrder,
  Value<String> titles,
  Value<int> colour,
  Value<int> chooseN,
  Value<bool> allowNoChoice,
  Value<int> rowid,
});

final class $$PositionsTableReferences
    extends BaseReferences<_$RegistryDb, $PositionsTable, Position> {
  $$PositionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ElectionsTable _electionIdTable(_$RegistryDb db) =>
      db.elections.createAlias('positions__election_id__elections__id');

  $$ElectionsTableProcessedTableManager get electionId {
    final $_column = $_itemColumn<String>('election_id')!;

    final manager = $$ElectionsTableTableManager(
      $_db,
      $_db.elections,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_electionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$CandidatesTable, List<Candidate>>
  _candidatesRefsTable(_$RegistryDb db) => MultiTypedResultKey.fromTable(
    db.candidates,
    aliasName: 'positions__id__candidates__position_id',
  );

  $$CandidatesTableProcessedTableManager get candidatesRefs {
    final manager = $$CandidatesTableTableManager(
      $_db,
      $_db.candidates,
    ).filter((f) => f.positionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_candidatesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PositionsTableFilterComposer
    extends Composer<_$RegistryDb, $PositionsTable> {
  $$PositionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get titles => $composableBuilder(
    column: $table.titles,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get colour => $composableBuilder(
    column: $table.colour,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get chooseN => $composableBuilder(
    column: $table.chooseN,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get allowNoChoice => $composableBuilder(
    column: $table.allowNoChoice,
    builder: (column) => ColumnFilters(column),
  );

  $$ElectionsTableFilterComposer get electionId {
    final $$ElectionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.electionId,
      referencedTable: $db.elections,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ElectionsTableFilterComposer(
            $db: $db,
            $table: $db.elections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> candidatesRefs(
    Expression<bool> Function($$CandidatesTableFilterComposer f) f,
  ) {
    final $$CandidatesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.candidates,
      getReferencedColumn: (t) => t.positionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CandidatesTableFilterComposer(
            $db: $db,
            $table: $db.candidates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PositionsTableOrderingComposer
    extends Composer<_$RegistryDb, $PositionsTable> {
  $$PositionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get titles => $composableBuilder(
    column: $table.titles,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get colour => $composableBuilder(
    column: $table.colour,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get chooseN => $composableBuilder(
    column: $table.chooseN,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get allowNoChoice => $composableBuilder(
    column: $table.allowNoChoice,
    builder: (column) => ColumnOrderings(column),
  );

  $$ElectionsTableOrderingComposer get electionId {
    final $$ElectionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.electionId,
      referencedTable: $db.elections,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ElectionsTableOrderingComposer(
            $db: $db,
            $table: $db.elections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PositionsTableAnnotationComposer
    extends Composer<_$RegistryDb, $PositionsTable> {
  $$PositionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<String> get titles =>
      $composableBuilder(column: $table.titles, builder: (column) => column);

  GeneratedColumn<int> get colour =>
      $composableBuilder(column: $table.colour, builder: (column) => column);

  GeneratedColumn<int> get chooseN =>
      $composableBuilder(column: $table.chooseN, builder: (column) => column);

  GeneratedColumn<bool> get allowNoChoice => $composableBuilder(
    column: $table.allowNoChoice,
    builder: (column) => column,
  );

  $$ElectionsTableAnnotationComposer get electionId {
    final $$ElectionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.electionId,
      referencedTable: $db.elections,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ElectionsTableAnnotationComposer(
            $db: $db,
            $table: $db.elections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> candidatesRefs<T extends Object>(
    Expression<T> Function($$CandidatesTableAnnotationComposer a) f,
  ) {
    final $$CandidatesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.candidates,
      getReferencedColumn: (t) => t.positionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CandidatesTableAnnotationComposer(
            $db: $db,
            $table: $db.candidates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PositionsTableTableManager
    extends
        RootTableManager<
          _$RegistryDb,
          $PositionsTable,
          Position,
          $$PositionsTableFilterComposer,
          $$PositionsTableOrderingComposer,
          $$PositionsTableAnnotationComposer,
          $$PositionsTableCreateCompanionBuilder,
          $$PositionsTableUpdateCompanionBuilder,
          (Position, $$PositionsTableReferences),
          Position,
          PrefetchHooks Function({bool electionId, bool candidatesRefs})
        > {
  $$PositionsTableTableManager(_$RegistryDb db, $PositionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PositionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PositionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PositionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> electionId = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<String> titles = const Value.absent(),
                Value<int> colour = const Value.absent(),
                Value<int> chooseN = const Value.absent(),
                Value<bool> allowNoChoice = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PositionsCompanion(
                id: id,
                electionId: electionId,
                sortOrder: sortOrder,
                titles: titles,
                colour: colour,
                chooseN: chooseN,
                allowNoChoice: allowNoChoice,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String electionId,
                required int sortOrder,
                required String titles,
                required int colour,
                Value<int> chooseN = const Value.absent(),
                Value<bool> allowNoChoice = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PositionsCompanion.insert(
                id: id,
                electionId: electionId,
                sortOrder: sortOrder,
                titles: titles,
                colour: colour,
                chooseN: chooseN,
                allowNoChoice: allowNoChoice,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PositionsTable, Position>(table),
                  $$PositionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({electionId = false, candidatesRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [if (candidatesRefs) db.candidates],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (electionId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.electionId,
                            referencedTable: $$PositionsTableReferences
                                ._electionIdTable(db),
                            referencedColumn: $$PositionsTableReferences
                                ._electionIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (candidatesRefs)
                        await $_getPrefetchedDataByColumns<
                          Position,
                          $PositionsTable,
                          Candidate,
                          $CandidatesTable
                        >(
                          currentTable: table,
                          referencedTable: $$PositionsTableReferences
                              ._candidatesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PositionsTableReferences(
                                db,
                                table,
                                p0,
                              ).candidatesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'position_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$PositionsTableProcessedTableManager =
    ProcessedTableManager<
      _$RegistryDb,
      $PositionsTable,
      Position,
      $$PositionsTableFilterComposer,
      $$PositionsTableOrderingComposer,
      $$PositionsTableAnnotationComposer,
      $$PositionsTableCreateCompanionBuilder,
      $$PositionsTableUpdateCompanionBuilder,
      (Position, $$PositionsTableReferences),
      Position,
      PrefetchHooks Function({bool electionId, bool candidatesRefs})
    >;
typedef $$CandidatesTableCreateCompanionBuilder = CandidatesCompanion Function({
  required String id,
  required String positionId,
  required int number,
  required String name,
  Value<Uint8List?> photo,
  Value<Uint8List?> symbol,
  required int sortOrder,
  Value<int> rowid,
});
typedef $$CandidatesTableUpdateCompanionBuilder = CandidatesCompanion Function({
  Value<String> id,
  Value<String> positionId,
  Value<int> number,
  Value<String> name,
  Value<Uint8List?> photo,
  Value<Uint8List?> symbol,
  Value<int> sortOrder,
  Value<int> rowid,
});

final class $$CandidatesTableReferences
    extends BaseReferences<_$RegistryDb, $CandidatesTable, Candidate> {
  $$CandidatesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PositionsTable _positionIdTable(_$RegistryDb db) =>
      db.positions.createAlias('candidates__position_id__positions__id');

  $$PositionsTableProcessedTableManager get positionId {
    final $_column = $_itemColumn<String>('position_id')!;

    final manager = $$PositionsTableTableManager(
      $_db,
      $_db.positions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_positionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CandidatesTableFilterComposer
    extends Composer<_$RegistryDb, $CandidatesTable> {
  $$CandidatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get number => $composableBuilder(
    column: $table.number,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<Uint8List> get photo => $composableBuilder(
    column: $table.photo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<Uint8List> get symbol => $composableBuilder(
    column: $table.symbol,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  $$PositionsTableFilterComposer get positionId {
    final $$PositionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.positionId,
      referencedTable: $db.positions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PositionsTableFilterComposer(
            $db: $db,
            $table: $db.positions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CandidatesTableOrderingComposer
    extends Composer<_$RegistryDb, $CandidatesTable> {
  $$CandidatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get number => $composableBuilder(
    column: $table.number,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<Uint8List> get photo => $composableBuilder(
    column: $table.photo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<Uint8List> get symbol => $composableBuilder(
    column: $table.symbol,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  $$PositionsTableOrderingComposer get positionId {
    final $$PositionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.positionId,
      referencedTable: $db.positions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PositionsTableOrderingComposer(
            $db: $db,
            $table: $db.positions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CandidatesTableAnnotationComposer
    extends Composer<_$RegistryDb, $CandidatesTable> {
  $$CandidatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get number =>
      $composableBuilder(column: $table.number, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<Uint8List> get photo =>
      $composableBuilder(column: $table.photo, builder: (column) => column);

  GeneratedColumn<Uint8List> get symbol =>
      $composableBuilder(column: $table.symbol, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  $$PositionsTableAnnotationComposer get positionId {
    final $$PositionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.positionId,
      referencedTable: $db.positions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PositionsTableAnnotationComposer(
            $db: $db,
            $table: $db.positions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CandidatesTableTableManager
    extends
        RootTableManager<
          _$RegistryDb,
          $CandidatesTable,
          Candidate,
          $$CandidatesTableFilterComposer,
          $$CandidatesTableOrderingComposer,
          $$CandidatesTableAnnotationComposer,
          $$CandidatesTableCreateCompanionBuilder,
          $$CandidatesTableUpdateCompanionBuilder,
          (Candidate, $$CandidatesTableReferences),
          Candidate,
          PrefetchHooks Function({bool positionId})
        > {
  $$CandidatesTableTableManager(_$RegistryDb db, $CandidatesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CandidatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CandidatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CandidatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> positionId = const Value.absent(),
                Value<int> number = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<Uint8List?> photo = const Value.absent(),
                Value<Uint8List?> symbol = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CandidatesCompanion(
                id: id,
                positionId: positionId,
                number: number,
                name: name,
                photo: photo,
                symbol: symbol,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String positionId,
                required int number,
                required String name,
                Value<Uint8List?> photo = const Value.absent(),
                Value<Uint8List?> symbol = const Value.absent(),
                required int sortOrder,
                Value<int> rowid = const Value.absent(),
              }) => CandidatesCompanion.insert(
                id: id,
                positionId: positionId,
                number: number,
                name: name,
                photo: photo,
                symbol: symbol,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CandidatesTable, Candidate>(table),
                  $$CandidatesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({positionId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (positionId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.positionId,
                        referencedTable: $$CandidatesTableReferences
                            ._positionIdTable(db),
                        referencedColumn: $$CandidatesTableReferences
                            ._positionIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$CandidatesTableProcessedTableManager =
    ProcessedTableManager<
      _$RegistryDb,
      $CandidatesTable,
      Candidate,
      $$CandidatesTableFilterComposer,
      $$CandidatesTableOrderingComposer,
      $$CandidatesTableAnnotationComposer,
      $$CandidatesTableCreateCompanionBuilder,
      $$CandidatesTableUpdateCompanionBuilder,
      (Candidate, $$CandidatesTableReferences),
      Candidate,
      PrefetchHooks Function({bool positionId})
    >;
typedef $$VotersTableCreateCompanionBuilder = VotersCompanion Function({
  required String id,
  required String electionId,
  required int voterNo,
  required String fullName,
  Value<String> memberId,
  Value<String> groupName,
  Value<Uint8List?> photo,
  Value<int> cardIssue,
  required String registeredOn,
  required String registeredBy,
  Value<String> status,
  Value<bool> unpaidFlag,
  Value<int> rowid,
});
typedef $$VotersTableUpdateCompanionBuilder = VotersCompanion Function({
  Value<String> id,
  Value<String> electionId,
  Value<int> voterNo,
  Value<String> fullName,
  Value<String> memberId,
  Value<String> groupName,
  Value<Uint8List?> photo,
  Value<int> cardIssue,
  Value<String> registeredOn,
  Value<String> registeredBy,
  Value<String> status,
  Value<bool> unpaidFlag,
  Value<int> rowid,
});

final class $$VotersTableReferences
    extends BaseReferences<_$RegistryDb, $VotersTable, Voter> {
  $$VotersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ElectionsTable _electionIdTable(_$RegistryDb db) =>
      db.elections.createAlias('voters__election_id__elections__id');

  $$ElectionsTableProcessedTableManager get electionId {
    final $_column = $_itemColumn<String>('election_id')!;

    final manager = $$ElectionsTableTableManager(
      $_db,
      $_db.elections,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_electionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$FeePaymentsTable, List<FeePayment>>
  _feePaymentsRefsTable(_$RegistryDb db) => MultiTypedResultKey.fromTable(
    db.feePayments,
    aliasName: 'voters__id__fee_payments__voter_id',
  );

  $$FeePaymentsTableProcessedTableManager get feePaymentsRefs {
    final manager = $$FeePaymentsTableTableManager(
      $_db,
      $_db.feePayments,
    ).filter((f) => f.voterId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_feePaymentsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$CheckInsTable, List<CheckIn>> _checkInsRefsTable(
    _$RegistryDb db,
  ) => MultiTypedResultKey.fromTable(
    db.checkIns,
    aliasName: 'voters__id__check_ins__voter_id',
  );

  $$CheckInsTableProcessedTableManager get checkInsRefs {
    final manager = $$CheckInsTableTableManager(
      $_db,
      $_db.checkIns,
    ).filter((f) => f.voterId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_checkInsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$VotersTableFilterComposer extends Composer<_$RegistryDb, $VotersTable> {
  $$VotersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get voterNo => $composableBuilder(
    column: $table.voterNo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fullName => $composableBuilder(
    column: $table.fullName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get memberId => $composableBuilder(
    column: $table.memberId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get groupName => $composableBuilder(
    column: $table.groupName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<Uint8List> get photo => $composableBuilder(
    column: $table.photo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cardIssue => $composableBuilder(
    column: $table.cardIssue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get registeredOn => $composableBuilder(
    column: $table.registeredOn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get registeredBy => $composableBuilder(
    column: $table.registeredBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get unpaidFlag => $composableBuilder(
    column: $table.unpaidFlag,
    builder: (column) => ColumnFilters(column),
  );

  $$ElectionsTableFilterComposer get electionId {
    final $$ElectionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.electionId,
      referencedTable: $db.elections,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ElectionsTableFilterComposer(
            $db: $db,
            $table: $db.elections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> feePaymentsRefs(
    Expression<bool> Function($$FeePaymentsTableFilterComposer f) f,
  ) {
    final $$FeePaymentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.feePayments,
      getReferencedColumn: (t) => t.voterId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FeePaymentsTableFilterComposer(
            $db: $db,
            $table: $db.feePayments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> checkInsRefs(
    Expression<bool> Function($$CheckInsTableFilterComposer f) f,
  ) {
    final $$CheckInsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.checkIns,
      getReferencedColumn: (t) => t.voterId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CheckInsTableFilterComposer(
            $db: $db,
            $table: $db.checkIns,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$VotersTableOrderingComposer
    extends Composer<_$RegistryDb, $VotersTable> {
  $$VotersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get voterNo => $composableBuilder(
    column: $table.voterNo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fullName => $composableBuilder(
    column: $table.fullName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get memberId => $composableBuilder(
    column: $table.memberId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get groupName => $composableBuilder(
    column: $table.groupName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<Uint8List> get photo => $composableBuilder(
    column: $table.photo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cardIssue => $composableBuilder(
    column: $table.cardIssue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get registeredOn => $composableBuilder(
    column: $table.registeredOn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get registeredBy => $composableBuilder(
    column: $table.registeredBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get unpaidFlag => $composableBuilder(
    column: $table.unpaidFlag,
    builder: (column) => ColumnOrderings(column),
  );

  $$ElectionsTableOrderingComposer get electionId {
    final $$ElectionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.electionId,
      referencedTable: $db.elections,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ElectionsTableOrderingComposer(
            $db: $db,
            $table: $db.elections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$VotersTableAnnotationComposer
    extends Composer<_$RegistryDb, $VotersTable> {
  $$VotersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get voterNo =>
      $composableBuilder(column: $table.voterNo, builder: (column) => column);

  GeneratedColumn<String> get fullName =>
      $composableBuilder(column: $table.fullName, builder: (column) => column);

  GeneratedColumn<String> get memberId =>
      $composableBuilder(column: $table.memberId, builder: (column) => column);

  GeneratedColumn<String> get groupName =>
      $composableBuilder(column: $table.groupName, builder: (column) => column);

  GeneratedColumn<Uint8List> get photo =>
      $composableBuilder(column: $table.photo, builder: (column) => column);

  GeneratedColumn<int> get cardIssue =>
      $composableBuilder(column: $table.cardIssue, builder: (column) => column);

  GeneratedColumn<String> get registeredOn => $composableBuilder(
    column: $table.registeredOn,
    builder: (column) => column,
  );

  GeneratedColumn<String> get registeredBy => $composableBuilder(
    column: $table.registeredBy,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<bool> get unpaidFlag => $composableBuilder(
    column: $table.unpaidFlag,
    builder: (column) => column,
  );

  $$ElectionsTableAnnotationComposer get electionId {
    final $$ElectionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.electionId,
      referencedTable: $db.elections,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ElectionsTableAnnotationComposer(
            $db: $db,
            $table: $db.elections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> feePaymentsRefs<T extends Object>(
    Expression<T> Function($$FeePaymentsTableAnnotationComposer a) f,
  ) {
    final $$FeePaymentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.feePayments,
      getReferencedColumn: (t) => t.voterId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FeePaymentsTableAnnotationComposer(
            $db: $db,
            $table: $db.feePayments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> checkInsRefs<T extends Object>(
    Expression<T> Function($$CheckInsTableAnnotationComposer a) f,
  ) {
    final $$CheckInsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.checkIns,
      getReferencedColumn: (t) => t.voterId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CheckInsTableAnnotationComposer(
            $db: $db,
            $table: $db.checkIns,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$VotersTableTableManager
    extends
        RootTableManager<
          _$RegistryDb,
          $VotersTable,
          Voter,
          $$VotersTableFilterComposer,
          $$VotersTableOrderingComposer,
          $$VotersTableAnnotationComposer,
          $$VotersTableCreateCompanionBuilder,
          $$VotersTableUpdateCompanionBuilder,
          (Voter, $$VotersTableReferences),
          Voter,
          PrefetchHooks Function({
            bool electionId,
            bool feePaymentsRefs,
            bool checkInsRefs,
          })
        > {
  $$VotersTableTableManager(_$RegistryDb db, $VotersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VotersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VotersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VotersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> electionId = const Value.absent(),
                Value<int> voterNo = const Value.absent(),
                Value<String> fullName = const Value.absent(),
                Value<String> memberId = const Value.absent(),
                Value<String> groupName = const Value.absent(),
                Value<Uint8List?> photo = const Value.absent(),
                Value<int> cardIssue = const Value.absent(),
                Value<String> registeredOn = const Value.absent(),
                Value<String> registeredBy = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<bool> unpaidFlag = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VotersCompanion(
                id: id,
                electionId: electionId,
                voterNo: voterNo,
                fullName: fullName,
                memberId: memberId,
                groupName: groupName,
                photo: photo,
                cardIssue: cardIssue,
                registeredOn: registeredOn,
                registeredBy: registeredBy,
                status: status,
                unpaidFlag: unpaidFlag,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String electionId,
                required int voterNo,
                required String fullName,
                Value<String> memberId = const Value.absent(),
                Value<String> groupName = const Value.absent(),
                Value<Uint8List?> photo = const Value.absent(),
                Value<int> cardIssue = const Value.absent(),
                required String registeredOn,
                required String registeredBy,
                Value<String> status = const Value.absent(),
                Value<bool> unpaidFlag = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VotersCompanion.insert(
                id: id,
                electionId: electionId,
                voterNo: voterNo,
                fullName: fullName,
                memberId: memberId,
                groupName: groupName,
                photo: photo,
                cardIssue: cardIssue,
                registeredOn: registeredOn,
                registeredBy: registeredBy,
                status: status,
                unpaidFlag: unpaidFlag,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$VotersTable, Voter>(table),
                  $$VotersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                electionId = false,
                feePaymentsRefs = false,
                checkInsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (feePaymentsRefs) db.feePayments,
                    if (checkInsRefs) db.checkIns,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (electionId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.electionId,
                            referencedTable: $$VotersTableReferences
                                ._electionIdTable(db),
                            referencedColumn: $$VotersTableReferences
                                ._electionIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (feePaymentsRefs)
                        await $_getPrefetchedDataByColumns<
                          Voter,
                          $VotersTable,
                          FeePayment,
                          $FeePaymentsTable
                        >(
                          currentTable: table,
                          referencedTable: $$VotersTableReferences
                              ._feePaymentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$VotersTableReferences(
                                db,
                                table,
                                p0,
                              ).feePaymentsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'voter_id',
                          typedResults: items,
                        ),
                      if (checkInsRefs)
                        await $_getPrefetchedDataByColumns<
                          Voter,
                          $VotersTable,
                          CheckIn,
                          $CheckInsTable
                        >(
                          currentTable: table,
                          referencedTable: $$VotersTableReferences
                              ._checkInsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$VotersTableReferences(
                                db,
                                table,
                                p0,
                              ).checkInsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'voter_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$VotersTableProcessedTableManager =
    ProcessedTableManager<
      _$RegistryDb,
      $VotersTable,
      Voter,
      $$VotersTableFilterComposer,
      $$VotersTableOrderingComposer,
      $$VotersTableAnnotationComposer,
      $$VotersTableCreateCompanionBuilder,
      $$VotersTableUpdateCompanionBuilder,
      (Voter, $$VotersTableReferences),
      Voter,
      PrefetchHooks Function({
        bool electionId,
        bool feePaymentsRefs,
        bool checkInsRefs,
      })
    >;
typedef $$FeePaymentsTableCreateCompanionBuilder =
    FeePaymentsCompanion Function({
      required String voterId,
      required bool paid,
      Value<String?> currency,
      Value<int?> amount,
      Value<String?> receiptNo,
      required String recordedBy,
      Value<int> rowid,
    });
typedef $$FeePaymentsTableUpdateCompanionBuilder =
    FeePaymentsCompanion Function({
      Value<String> voterId,
      Value<bool> paid,
      Value<String?> currency,
      Value<int?> amount,
      Value<String?> receiptNo,
      Value<String> recordedBy,
      Value<int> rowid,
    });

final class $$FeePaymentsTableReferences
    extends BaseReferences<_$RegistryDb, $FeePaymentsTable, FeePayment> {
  $$FeePaymentsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $VotersTable _voterIdTable(_$RegistryDb db) =>
      db.voters.createAlias('fee_payments__voter_id__voters__id');

  $$VotersTableProcessedTableManager get voterId {
    final $_column = $_itemColumn<String>('voter_id')!;

    final manager = $$VotersTableTableManager(
      $_db,
      $_db.voters,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_voterIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$FeePaymentsTableFilterComposer
    extends Composer<_$RegistryDb, $FeePaymentsTable> {
  $$FeePaymentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<bool> get paid => $composableBuilder(
    column: $table.paid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get receiptNo => $composableBuilder(
    column: $table.receiptNo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recordedBy => $composableBuilder(
    column: $table.recordedBy,
    builder: (column) => ColumnFilters(column),
  );

  $$VotersTableFilterComposer get voterId {
    final $$VotersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.voterId,
      referencedTable: $db.voters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VotersTableFilterComposer(
            $db: $db,
            $table: $db.voters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FeePaymentsTableOrderingComposer
    extends Composer<_$RegistryDb, $FeePaymentsTable> {
  $$FeePaymentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<bool> get paid => $composableBuilder(
    column: $table.paid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get receiptNo => $composableBuilder(
    column: $table.receiptNo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recordedBy => $composableBuilder(
    column: $table.recordedBy,
    builder: (column) => ColumnOrderings(column),
  );

  $$VotersTableOrderingComposer get voterId {
    final $$VotersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.voterId,
      referencedTable: $db.voters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VotersTableOrderingComposer(
            $db: $db,
            $table: $db.voters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FeePaymentsTableAnnotationComposer
    extends Composer<_$RegistryDb, $FeePaymentsTable> {
  $$FeePaymentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<bool> get paid =>
      $composableBuilder(column: $table.paid, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get receiptNo =>
      $composableBuilder(column: $table.receiptNo, builder: (column) => column);

  GeneratedColumn<String> get recordedBy => $composableBuilder(
    column: $table.recordedBy,
    builder: (column) => column,
  );

  $$VotersTableAnnotationComposer get voterId {
    final $$VotersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.voterId,
      referencedTable: $db.voters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VotersTableAnnotationComposer(
            $db: $db,
            $table: $db.voters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FeePaymentsTableTableManager
    extends
        RootTableManager<
          _$RegistryDb,
          $FeePaymentsTable,
          FeePayment,
          $$FeePaymentsTableFilterComposer,
          $$FeePaymentsTableOrderingComposer,
          $$FeePaymentsTableAnnotationComposer,
          $$FeePaymentsTableCreateCompanionBuilder,
          $$FeePaymentsTableUpdateCompanionBuilder,
          (FeePayment, $$FeePaymentsTableReferences),
          FeePayment,
          PrefetchHooks Function({bool voterId})
        > {
  $$FeePaymentsTableTableManager(_$RegistryDb db, $FeePaymentsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FeePaymentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FeePaymentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FeePaymentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> voterId = const Value.absent(),
                Value<bool> paid = const Value.absent(),
                Value<String?> currency = const Value.absent(),
                Value<int?> amount = const Value.absent(),
                Value<String?> receiptNo = const Value.absent(),
                Value<String> recordedBy = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FeePaymentsCompanion(
                voterId: voterId,
                paid: paid,
                currency: currency,
                amount: amount,
                receiptNo: receiptNo,
                recordedBy: recordedBy,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String voterId,
                required bool paid,
                Value<String?> currency = const Value.absent(),
                Value<int?> amount = const Value.absent(),
                Value<String?> receiptNo = const Value.absent(),
                required String recordedBy,
                Value<int> rowid = const Value.absent(),
              }) => FeePaymentsCompanion.insert(
                voterId: voterId,
                paid: paid,
                currency: currency,
                amount: amount,
                receiptNo: receiptNo,
                recordedBy: recordedBy,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$FeePaymentsTable, FeePayment>(table),
                  $$FeePaymentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({voterId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (voterId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.voterId,
                        referencedTable: $$FeePaymentsTableReferences
                            ._voterIdTable(db),
                        referencedColumn: $$FeePaymentsTableReferences
                            ._voterIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$FeePaymentsTableProcessedTableManager =
    ProcessedTableManager<
      _$RegistryDb,
      $FeePaymentsTable,
      FeePayment,
      $$FeePaymentsTableFilterComposer,
      $$FeePaymentsTableOrderingComposer,
      $$FeePaymentsTableAnnotationComposer,
      $$FeePaymentsTableCreateCompanionBuilder,
      $$FeePaymentsTableUpdateCompanionBuilder,
      (FeePayment, $$FeePaymentsTableReferences),
      FeePayment,
      PrefetchHooks Function({bool voterId})
    >;
typedef $$ObjectionsTableCreateCompanionBuilder = ObjectionsCompanion Function({
  required String id,
  required String electionId,
  required String kind,
  Value<String?> subjectVoterId,
  Value<String?> otherVoterId,
  Value<String?> claimantName,
  required String raisedByName,
  Value<String> detail,
  required String raisedOn,
  Value<String?> decision,
  Value<String?> decidedBy,
  Value<String?> decidedOn,
  Value<int> rowid,
});
typedef $$ObjectionsTableUpdateCompanionBuilder = ObjectionsCompanion Function({
  Value<String> id,
  Value<String> electionId,
  Value<String> kind,
  Value<String?> subjectVoterId,
  Value<String?> otherVoterId,
  Value<String?> claimantName,
  Value<String> raisedByName,
  Value<String> detail,
  Value<String> raisedOn,
  Value<String?> decision,
  Value<String?> decidedBy,
  Value<String?> decidedOn,
  Value<int> rowid,
});

final class $$ObjectionsTableReferences
    extends BaseReferences<_$RegistryDb, $ObjectionsTable, Objection> {
  $$ObjectionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ElectionsTable _electionIdTable(_$RegistryDb db) =>
      db.elections.createAlias('objections__election_id__elections__id');

  $$ElectionsTableProcessedTableManager get electionId {
    final $_column = $_itemColumn<String>('election_id')!;

    final manager = $$ElectionsTableTableManager(
      $_db,
      $_db.elections,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_electionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ObjectionsTableFilterComposer
    extends Composer<_$RegistryDb, $ObjectionsTable> {
  $$ObjectionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get subjectVoterId => $composableBuilder(
    column: $table.subjectVoterId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get otherVoterId => $composableBuilder(
    column: $table.otherVoterId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get claimantName => $composableBuilder(
    column: $table.claimantName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get raisedByName => $composableBuilder(
    column: $table.raisedByName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get detail => $composableBuilder(
    column: $table.detail,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get raisedOn => $composableBuilder(
    column: $table.raisedOn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get decision => $composableBuilder(
    column: $table.decision,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get decidedBy => $composableBuilder(
    column: $table.decidedBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get decidedOn => $composableBuilder(
    column: $table.decidedOn,
    builder: (column) => ColumnFilters(column),
  );

  $$ElectionsTableFilterComposer get electionId {
    final $$ElectionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.electionId,
      referencedTable: $db.elections,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ElectionsTableFilterComposer(
            $db: $db,
            $table: $db.elections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ObjectionsTableOrderingComposer
    extends Composer<_$RegistryDb, $ObjectionsTable> {
  $$ObjectionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subjectVoterId => $composableBuilder(
    column: $table.subjectVoterId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get otherVoterId => $composableBuilder(
    column: $table.otherVoterId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get claimantName => $composableBuilder(
    column: $table.claimantName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get raisedByName => $composableBuilder(
    column: $table.raisedByName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get detail => $composableBuilder(
    column: $table.detail,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get raisedOn => $composableBuilder(
    column: $table.raisedOn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get decision => $composableBuilder(
    column: $table.decision,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get decidedBy => $composableBuilder(
    column: $table.decidedBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get decidedOn => $composableBuilder(
    column: $table.decidedOn,
    builder: (column) => ColumnOrderings(column),
  );

  $$ElectionsTableOrderingComposer get electionId {
    final $$ElectionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.electionId,
      referencedTable: $db.elections,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ElectionsTableOrderingComposer(
            $db: $db,
            $table: $db.elections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ObjectionsTableAnnotationComposer
    extends Composer<_$RegistryDb, $ObjectionsTable> {
  $$ObjectionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get subjectVoterId => $composableBuilder(
    column: $table.subjectVoterId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get otherVoterId => $composableBuilder(
    column: $table.otherVoterId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get claimantName => $composableBuilder(
    column: $table.claimantName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get raisedByName => $composableBuilder(
    column: $table.raisedByName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get detail =>
      $composableBuilder(column: $table.detail, builder: (column) => column);

  GeneratedColumn<String> get raisedOn =>
      $composableBuilder(column: $table.raisedOn, builder: (column) => column);

  GeneratedColumn<String> get decision =>
      $composableBuilder(column: $table.decision, builder: (column) => column);

  GeneratedColumn<String> get decidedBy =>
      $composableBuilder(column: $table.decidedBy, builder: (column) => column);

  GeneratedColumn<String> get decidedOn =>
      $composableBuilder(column: $table.decidedOn, builder: (column) => column);

  $$ElectionsTableAnnotationComposer get electionId {
    final $$ElectionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.electionId,
      referencedTable: $db.elections,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ElectionsTableAnnotationComposer(
            $db: $db,
            $table: $db.elections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ObjectionsTableTableManager
    extends
        RootTableManager<
          _$RegistryDb,
          $ObjectionsTable,
          Objection,
          $$ObjectionsTableFilterComposer,
          $$ObjectionsTableOrderingComposer,
          $$ObjectionsTableAnnotationComposer,
          $$ObjectionsTableCreateCompanionBuilder,
          $$ObjectionsTableUpdateCompanionBuilder,
          (Objection, $$ObjectionsTableReferences),
          Objection,
          PrefetchHooks Function({bool electionId})
        > {
  $$ObjectionsTableTableManager(_$RegistryDb db, $ObjectionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ObjectionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ObjectionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ObjectionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> electionId = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<String?> subjectVoterId = const Value.absent(),
                Value<String?> otherVoterId = const Value.absent(),
                Value<String?> claimantName = const Value.absent(),
                Value<String> raisedByName = const Value.absent(),
                Value<String> detail = const Value.absent(),
                Value<String> raisedOn = const Value.absent(),
                Value<String?> decision = const Value.absent(),
                Value<String?> decidedBy = const Value.absent(),
                Value<String?> decidedOn = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ObjectionsCompanion(
                id: id,
                electionId: electionId,
                kind: kind,
                subjectVoterId: subjectVoterId,
                otherVoterId: otherVoterId,
                claimantName: claimantName,
                raisedByName: raisedByName,
                detail: detail,
                raisedOn: raisedOn,
                decision: decision,
                decidedBy: decidedBy,
                decidedOn: decidedOn,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String electionId,
                required String kind,
                Value<String?> subjectVoterId = const Value.absent(),
                Value<String?> otherVoterId = const Value.absent(),
                Value<String?> claimantName = const Value.absent(),
                required String raisedByName,
                Value<String> detail = const Value.absent(),
                required String raisedOn,
                Value<String?> decision = const Value.absent(),
                Value<String?> decidedBy = const Value.absent(),
                Value<String?> decidedOn = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ObjectionsCompanion.insert(
                id: id,
                electionId: electionId,
                kind: kind,
                subjectVoterId: subjectVoterId,
                otherVoterId: otherVoterId,
                claimantName: claimantName,
                raisedByName: raisedByName,
                detail: detail,
                raisedOn: raisedOn,
                decision: decision,
                decidedBy: decidedBy,
                decidedOn: decidedOn,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ObjectionsTable, Objection>(table),
                  $$ObjectionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({electionId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (electionId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.electionId,
                        referencedTable: $$ObjectionsTableReferences
                            ._electionIdTable(db),
                        referencedColumn: $$ObjectionsTableReferences
                            ._electionIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ObjectionsTableProcessedTableManager =
    ProcessedTableManager<
      _$RegistryDb,
      $ObjectionsTable,
      Objection,
      $$ObjectionsTableFilterComposer,
      $$ObjectionsTableOrderingComposer,
      $$ObjectionsTableAnnotationComposer,
      $$ObjectionsTableCreateCompanionBuilder,
      $$ObjectionsTableUpdateCompanionBuilder,
      (Objection, $$ObjectionsTableReferences),
      Objection,
      PrefetchHooks Function({bool electionId})
    >;
typedef $$RegisterLocksTableCreateCompanionBuilder =
    RegisterLocksCompanion Function({
      required String electionId,
      required String signedRegister,
      required String fingerprint,
      required String lockedBy,
      required DateTime lockedAt,
      Value<int> rowid,
    });
typedef $$RegisterLocksTableUpdateCompanionBuilder =
    RegisterLocksCompanion Function({
      Value<String> electionId,
      Value<String> signedRegister,
      Value<String> fingerprint,
      Value<String> lockedBy,
      Value<DateTime> lockedAt,
      Value<int> rowid,
    });

final class $$RegisterLocksTableReferences
    extends BaseReferences<_$RegistryDb, $RegisterLocksTable, RegisterLock> {
  $$RegisterLocksTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ElectionsTable _electionIdTable(_$RegistryDb db) =>
      db.elections.createAlias('register_locks__election_id__elections__id');

  $$ElectionsTableProcessedTableManager get electionId {
    final $_column = $_itemColumn<String>('election_id')!;

    final manager = $$ElectionsTableTableManager(
      $_db,
      $_db.elections,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_electionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RegisterLocksTableFilterComposer
    extends Composer<_$RegistryDb, $RegisterLocksTable> {
  $$RegisterLocksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get signedRegister => $composableBuilder(
    column: $table.signedRegister,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fingerprint => $composableBuilder(
    column: $table.fingerprint,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lockedBy => $composableBuilder(
    column: $table.lockedBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lockedAt => $composableBuilder(
    column: $table.lockedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ElectionsTableFilterComposer get electionId {
    final $$ElectionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.electionId,
      referencedTable: $db.elections,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ElectionsTableFilterComposer(
            $db: $db,
            $table: $db.elections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RegisterLocksTableOrderingComposer
    extends Composer<_$RegistryDb, $RegisterLocksTable> {
  $$RegisterLocksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get signedRegister => $composableBuilder(
    column: $table.signedRegister,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fingerprint => $composableBuilder(
    column: $table.fingerprint,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lockedBy => $composableBuilder(
    column: $table.lockedBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lockedAt => $composableBuilder(
    column: $table.lockedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ElectionsTableOrderingComposer get electionId {
    final $$ElectionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.electionId,
      referencedTable: $db.elections,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ElectionsTableOrderingComposer(
            $db: $db,
            $table: $db.elections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RegisterLocksTableAnnotationComposer
    extends Composer<_$RegistryDb, $RegisterLocksTable> {
  $$RegisterLocksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get signedRegister => $composableBuilder(
    column: $table.signedRegister,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fingerprint => $composableBuilder(
    column: $table.fingerprint,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lockedBy =>
      $composableBuilder(column: $table.lockedBy, builder: (column) => column);

  GeneratedColumn<DateTime> get lockedAt =>
      $composableBuilder(column: $table.lockedAt, builder: (column) => column);

  $$ElectionsTableAnnotationComposer get electionId {
    final $$ElectionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.electionId,
      referencedTable: $db.elections,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ElectionsTableAnnotationComposer(
            $db: $db,
            $table: $db.elections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RegisterLocksTableTableManager
    extends
        RootTableManager<
          _$RegistryDb,
          $RegisterLocksTable,
          RegisterLock,
          $$RegisterLocksTableFilterComposer,
          $$RegisterLocksTableOrderingComposer,
          $$RegisterLocksTableAnnotationComposer,
          $$RegisterLocksTableCreateCompanionBuilder,
          $$RegisterLocksTableUpdateCompanionBuilder,
          (RegisterLock, $$RegisterLocksTableReferences),
          RegisterLock,
          PrefetchHooks Function({bool electionId})
        > {
  $$RegisterLocksTableTableManager(_$RegistryDb db, $RegisterLocksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RegisterLocksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RegisterLocksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RegisterLocksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> electionId = const Value.absent(),
                Value<String> signedRegister = const Value.absent(),
                Value<String> fingerprint = const Value.absent(),
                Value<String> lockedBy = const Value.absent(),
                Value<DateTime> lockedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RegisterLocksCompanion(
                electionId: electionId,
                signedRegister: signedRegister,
                fingerprint: fingerprint,
                lockedBy: lockedBy,
                lockedAt: lockedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String electionId,
                required String signedRegister,
                required String fingerprint,
                required String lockedBy,
                required DateTime lockedAt,
                Value<int> rowid = const Value.absent(),
              }) => RegisterLocksCompanion.insert(
                electionId: electionId,
                signedRegister: signedRegister,
                fingerprint: fingerprint,
                lockedBy: lockedBy,
                lockedAt: lockedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RegisterLocksTable, RegisterLock>(table),
                  $$RegisterLocksTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({electionId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (electionId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.electionId,
                        referencedTable: $$RegisterLocksTableReferences
                            ._electionIdTable(db),
                        referencedColumn: $$RegisterLocksTableReferences
                            ._electionIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$RegisterLocksTableProcessedTableManager =
    ProcessedTableManager<
      _$RegistryDb,
      $RegisterLocksTable,
      RegisterLock,
      $$RegisterLocksTableFilterComposer,
      $$RegisterLocksTableOrderingComposer,
      $$RegisterLocksTableAnnotationComposer,
      $$RegisterLocksTableCreateCompanionBuilder,
      $$RegisterLocksTableUpdateCompanionBuilder,
      (RegisterLock, $$RegisterLocksTableReferences),
      RegisterLock,
      PrefetchHooks Function({bool electionId})
    >;
typedef $$CheckInsTableCreateCompanionBuilder = CheckInsCompanion Function({
  required String voterId,
  required String electionId,
  required String method,
  Value<String?> manualReason,
  required String official,
  required String hourBucket,
  Value<int> rowid,
});
typedef $$CheckInsTableUpdateCompanionBuilder = CheckInsCompanion Function({
  Value<String> voterId,
  Value<String> electionId,
  Value<String> method,
  Value<String?> manualReason,
  Value<String> official,
  Value<String> hourBucket,
  Value<int> rowid,
});

final class $$CheckInsTableReferences
    extends BaseReferences<_$RegistryDb, $CheckInsTable, CheckIn> {
  $$CheckInsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $VotersTable _voterIdTable(_$RegistryDb db) =>
      db.voters.createAlias('check_ins__voter_id__voters__id');

  $$VotersTableProcessedTableManager get voterId {
    final $_column = $_itemColumn<String>('voter_id')!;

    final manager = $$VotersTableTableManager(
      $_db,
      $_db.voters,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_voterIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ElectionsTable _electionIdTable(_$RegistryDb db) =>
      db.elections.createAlias('check_ins__election_id__elections__id');

  $$ElectionsTableProcessedTableManager get electionId {
    final $_column = $_itemColumn<String>('election_id')!;

    final manager = $$ElectionsTableTableManager(
      $_db,
      $_db.elections,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_electionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CheckInsTableFilterComposer
    extends Composer<_$RegistryDb, $CheckInsTable> {
  $$CheckInsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get method => $composableBuilder(
    column: $table.method,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get manualReason => $composableBuilder(
    column: $table.manualReason,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get official => $composableBuilder(
    column: $table.official,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hourBucket => $composableBuilder(
    column: $table.hourBucket,
    builder: (column) => ColumnFilters(column),
  );

  $$VotersTableFilterComposer get voterId {
    final $$VotersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.voterId,
      referencedTable: $db.voters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VotersTableFilterComposer(
            $db: $db,
            $table: $db.voters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ElectionsTableFilterComposer get electionId {
    final $$ElectionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.electionId,
      referencedTable: $db.elections,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ElectionsTableFilterComposer(
            $db: $db,
            $table: $db.elections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CheckInsTableOrderingComposer
    extends Composer<_$RegistryDb, $CheckInsTable> {
  $$CheckInsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get method => $composableBuilder(
    column: $table.method,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get manualReason => $composableBuilder(
    column: $table.manualReason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get official => $composableBuilder(
    column: $table.official,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hourBucket => $composableBuilder(
    column: $table.hourBucket,
    builder: (column) => ColumnOrderings(column),
  );

  $$VotersTableOrderingComposer get voterId {
    final $$VotersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.voterId,
      referencedTable: $db.voters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VotersTableOrderingComposer(
            $db: $db,
            $table: $db.voters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ElectionsTableOrderingComposer get electionId {
    final $$ElectionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.electionId,
      referencedTable: $db.elections,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ElectionsTableOrderingComposer(
            $db: $db,
            $table: $db.elections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CheckInsTableAnnotationComposer
    extends Composer<_$RegistryDb, $CheckInsTable> {
  $$CheckInsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get method =>
      $composableBuilder(column: $table.method, builder: (column) => column);

  GeneratedColumn<String> get manualReason => $composableBuilder(
    column: $table.manualReason,
    builder: (column) => column,
  );

  GeneratedColumn<String> get official =>
      $composableBuilder(column: $table.official, builder: (column) => column);

  GeneratedColumn<String> get hourBucket => $composableBuilder(
    column: $table.hourBucket,
    builder: (column) => column,
  );

  $$VotersTableAnnotationComposer get voterId {
    final $$VotersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.voterId,
      referencedTable: $db.voters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VotersTableAnnotationComposer(
            $db: $db,
            $table: $db.voters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ElectionsTableAnnotationComposer get electionId {
    final $$ElectionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.electionId,
      referencedTable: $db.elections,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ElectionsTableAnnotationComposer(
            $db: $db,
            $table: $db.elections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CheckInsTableTableManager
    extends
        RootTableManager<
          _$RegistryDb,
          $CheckInsTable,
          CheckIn,
          $$CheckInsTableFilterComposer,
          $$CheckInsTableOrderingComposer,
          $$CheckInsTableAnnotationComposer,
          $$CheckInsTableCreateCompanionBuilder,
          $$CheckInsTableUpdateCompanionBuilder,
          (CheckIn, $$CheckInsTableReferences),
          CheckIn,
          PrefetchHooks Function({bool voterId, bool electionId})
        > {
  $$CheckInsTableTableManager(_$RegistryDb db, $CheckInsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CheckInsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CheckInsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CheckInsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> voterId = const Value.absent(),
                Value<String> electionId = const Value.absent(),
                Value<String> method = const Value.absent(),
                Value<String?> manualReason = const Value.absent(),
                Value<String> official = const Value.absent(),
                Value<String> hourBucket = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CheckInsCompanion(
                voterId: voterId,
                electionId: electionId,
                method: method,
                manualReason: manualReason,
                official: official,
                hourBucket: hourBucket,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String voterId,
                required String electionId,
                required String method,
                Value<String?> manualReason = const Value.absent(),
                required String official,
                required String hourBucket,
                Value<int> rowid = const Value.absent(),
              }) => CheckInsCompanion.insert(
                voterId: voterId,
                electionId: electionId,
                method: method,
                manualReason: manualReason,
                official: official,
                hourBucket: hourBucket,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CheckInsTable, CheckIn>(table),
                  $$CheckInsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({voterId = false, electionId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (voterId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.voterId,
                        referencedTable: $$CheckInsTableReferences
                            ._voterIdTable(db),
                        referencedColumn: $$CheckInsTableReferences
                            ._voterIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (electionId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.electionId,
                        referencedTable: $$CheckInsTableReferences
                            ._electionIdTable(db),
                        referencedColumn: $$CheckInsTableReferences
                            ._electionIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$CheckInsTableProcessedTableManager =
    ProcessedTableManager<
      _$RegistryDb,
      $CheckInsTable,
      CheckIn,
      $$CheckInsTableFilterComposer,
      $$CheckInsTableOrderingComposer,
      $$CheckInsTableAnnotationComposer,
      $$CheckInsTableCreateCompanionBuilder,
      $$CheckInsTableUpdateCompanionBuilder,
      (CheckIn, $$CheckInsTableReferences),
      CheckIn,
      PrefetchHooks Function({bool voterId, bool electionId})
    >;
typedef $$IssuedTokensTableCreateCompanionBuilder =
    IssuedTokensCompanion Function({
      required String tokenHash,
      required String electionId,
      Value<String> state,
    });
typedef $$IssuedTokensTableUpdateCompanionBuilder =
    IssuedTokensCompanion Function({
      Value<String> tokenHash,
      Value<String> electionId,
      Value<String> state,
    });

class $$IssuedTokensTableFilterComposer
    extends Composer<_$RegistryDb, $IssuedTokensTable> {
  $$IssuedTokensTableFilterComposer({
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

  ColumnFilters<String> get electionId => $composableBuilder(
    column: $table.electionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnFilters(column),
  );
}

class $$IssuedTokensTableOrderingComposer
    extends Composer<_$RegistryDb, $IssuedTokensTable> {
  $$IssuedTokensTableOrderingComposer({
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

  ColumnOrderings<String> get electionId => $composableBuilder(
    column: $table.electionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$IssuedTokensTableAnnotationComposer
    extends Composer<_$RegistryDb, $IssuedTokensTable> {
  $$IssuedTokensTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get tokenHash =>
      $composableBuilder(column: $table.tokenHash, builder: (column) => column);

  GeneratedColumn<String> get electionId => $composableBuilder(
    column: $table.electionId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get state =>
      $composableBuilder(column: $table.state, builder: (column) => column);
}

class $$IssuedTokensTableTableManager
    extends
        RootTableManager<
          _$RegistryDb,
          $IssuedTokensTable,
          IssuedToken,
          $$IssuedTokensTableFilterComposer,
          $$IssuedTokensTableOrderingComposer,
          $$IssuedTokensTableAnnotationComposer,
          $$IssuedTokensTableCreateCompanionBuilder,
          $$IssuedTokensTableUpdateCompanionBuilder,
          (
            IssuedToken,
            BaseReferences<_$RegistryDb, $IssuedTokensTable, IssuedToken>,
          ),
          IssuedToken,
          PrefetchHooks Function()
        > {
  $$IssuedTokensTableTableManager(_$RegistryDb db, $IssuedTokensTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$IssuedTokensTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$IssuedTokensTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$IssuedTokensTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> tokenHash = const Value.absent(),
                Value<String> electionId = const Value.absent(),
                Value<String> state = const Value.absent(),
              }) => IssuedTokensCompanion(
                tokenHash: tokenHash,
                electionId: electionId,
                state: state,
              ),
          createCompanionCallback:
              ({
                required String tokenHash,
                required String electionId,
                Value<String> state = const Value.absent(),
              }) => IssuedTokensCompanion.insert(
                tokenHash: tokenHash,
                electionId: electionId,
                state: state,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$IssuedTokensTable, IssuedToken>(table),
                  BaseReferences<_$RegistryDb, $IssuedTokensTable, IssuedToken>(
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

typedef $$IssuedTokensTableProcessedTableManager =
    ProcessedTableManager<
      _$RegistryDb,
      $IssuedTokensTable,
      IssuedToken,
      $$IssuedTokensTableFilterComposer,
      $$IssuedTokensTableOrderingComposer,
      $$IssuedTokensTableAnnotationComposer,
      $$IssuedTokensTableCreateCompanionBuilder,
      $$IssuedTokensTableUpdateCompanionBuilder,
      (
        IssuedToken,
        BaseReferences<_$RegistryDb, $IssuedTokensTable, IssuedToken>,
      ),
      IssuedToken,
      PrefetchHooks Function()
    >;
typedef $$DeviceEnrollmentsTableCreateCompanionBuilder =
    DeviceEnrollmentsCompanion Function({
      required String deviceId,
      required String role,
      required Uint8List signingPublic,
      required Uint8List exchangePublic,
      required String label,
      required String enrolledBy,
      required DateTime enrolledAt,
      Value<bool> revoked,
      Value<int> rowid,
    });
typedef $$DeviceEnrollmentsTableUpdateCompanionBuilder =
    DeviceEnrollmentsCompanion Function({
      Value<String> deviceId,
      Value<String> role,
      Value<Uint8List> signingPublic,
      Value<Uint8List> exchangePublic,
      Value<String> label,
      Value<String> enrolledBy,
      Value<DateTime> enrolledAt,
      Value<bool> revoked,
      Value<int> rowid,
    });

class $$DeviceEnrollmentsTableFilterComposer
    extends Composer<_$RegistryDb, $DeviceEnrollmentsTable> {
  $$DeviceEnrollmentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<Uint8List> get signingPublic => $composableBuilder(
    column: $table.signingPublic,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<Uint8List> get exchangePublic => $composableBuilder(
    column: $table.exchangePublic,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get enrolledBy => $composableBuilder(
    column: $table.enrolledBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get enrolledAt => $composableBuilder(
    column: $table.enrolledAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get revoked => $composableBuilder(
    column: $table.revoked,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DeviceEnrollmentsTableOrderingComposer
    extends Composer<_$RegistryDb, $DeviceEnrollmentsTable> {
  $$DeviceEnrollmentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<Uint8List> get signingPublic => $composableBuilder(
    column: $table.signingPublic,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<Uint8List> get exchangePublic => $composableBuilder(
    column: $table.exchangePublic,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get enrolledBy => $composableBuilder(
    column: $table.enrolledBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get enrolledAt => $composableBuilder(
    column: $table.enrolledAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get revoked => $composableBuilder(
    column: $table.revoked,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DeviceEnrollmentsTableAnnotationComposer
    extends Composer<_$RegistryDb, $DeviceEnrollmentsTable> {
  $$DeviceEnrollmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<Uint8List> get signingPublic => $composableBuilder(
    column: $table.signingPublic,
    builder: (column) => column,
  );

  GeneratedColumn<Uint8List> get exchangePublic => $composableBuilder(
    column: $table.exchangePublic,
    builder: (column) => column,
  );

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<String> get enrolledBy => $composableBuilder(
    column: $table.enrolledBy,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get enrolledAt => $composableBuilder(
    column: $table.enrolledAt,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get revoked =>
      $composableBuilder(column: $table.revoked, builder: (column) => column);
}

class $$DeviceEnrollmentsTableTableManager
    extends
        RootTableManager<
          _$RegistryDb,
          $DeviceEnrollmentsTable,
          DeviceEnrollment,
          $$DeviceEnrollmentsTableFilterComposer,
          $$DeviceEnrollmentsTableOrderingComposer,
          $$DeviceEnrollmentsTableAnnotationComposer,
          $$DeviceEnrollmentsTableCreateCompanionBuilder,
          $$DeviceEnrollmentsTableUpdateCompanionBuilder,
          (
            DeviceEnrollment,
            BaseReferences<
              _$RegistryDb,
              $DeviceEnrollmentsTable,
              DeviceEnrollment
            >,
          ),
          DeviceEnrollment,
          PrefetchHooks Function()
        > {
  $$DeviceEnrollmentsTableTableManager(
    _$RegistryDb db,
    $DeviceEnrollmentsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DeviceEnrollmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DeviceEnrollmentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DeviceEnrollmentsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> deviceId = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<Uint8List> signingPublic = const Value.absent(),
                Value<Uint8List> exchangePublic = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<String> enrolledBy = const Value.absent(),
                Value<DateTime> enrolledAt = const Value.absent(),
                Value<bool> revoked = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DeviceEnrollmentsCompanion(
                deviceId: deviceId,
                role: role,
                signingPublic: signingPublic,
                exchangePublic: exchangePublic,
                label: label,
                enrolledBy: enrolledBy,
                enrolledAt: enrolledAt,
                revoked: revoked,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String deviceId,
                required String role,
                required Uint8List signingPublic,
                required Uint8List exchangePublic,
                required String label,
                required String enrolledBy,
                required DateTime enrolledAt,
                Value<bool> revoked = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DeviceEnrollmentsCompanion.insert(
                deviceId: deviceId,
                role: role,
                signingPublic: signingPublic,
                exchangePublic: exchangePublic,
                label: label,
                enrolledBy: enrolledBy,
                enrolledAt: enrolledAt,
                revoked: revoked,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DeviceEnrollmentsTable, DeviceEnrollment>(table),
                  BaseReferences<
                    _$RegistryDb,
                    $DeviceEnrollmentsTable,
                    DeviceEnrollment
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DeviceEnrollmentsTableProcessedTableManager =
    ProcessedTableManager<
      _$RegistryDb,
      $DeviceEnrollmentsTable,
      DeviceEnrollment,
      $$DeviceEnrollmentsTableFilterComposer,
      $$DeviceEnrollmentsTableOrderingComposer,
      $$DeviceEnrollmentsTableAnnotationComposer,
      $$DeviceEnrollmentsTableCreateCompanionBuilder,
      $$DeviceEnrollmentsTableUpdateCompanionBuilder,
      (
        DeviceEnrollment,
        BaseReferences<_$RegistryDb, $DeviceEnrollmentsTable, DeviceEnrollment>,
      ),
      DeviceEnrollment,
      PrefetchHooks Function()
    >;
typedef $$ResultRecordsTableCreateCompanionBuilder =
    ResultRecordsCompanion Function({
      required String electionId,
      required String signedResults,
      required String fingerprint,
      Value<String?> paperCounts,
      Value<int> rowid,
    });
typedef $$ResultRecordsTableUpdateCompanionBuilder =
    ResultRecordsCompanion Function({
      Value<String> electionId,
      Value<String> signedResults,
      Value<String> fingerprint,
      Value<String?> paperCounts,
      Value<int> rowid,
    });

final class $$ResultRecordsTableReferences
    extends BaseReferences<_$RegistryDb, $ResultRecordsTable, ResultRecord> {
  $$ResultRecordsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ElectionsTable _electionIdTable(_$RegistryDb db) =>
      db.elections.createAlias('result_records__election_id__elections__id');

  $$ElectionsTableProcessedTableManager get electionId {
    final $_column = $_itemColumn<String>('election_id')!;

    final manager = $$ElectionsTableTableManager(
      $_db,
      $_db.elections,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_electionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ResultRecordsTableFilterComposer
    extends Composer<_$RegistryDb, $ResultRecordsTable> {
  $$ResultRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get signedResults => $composableBuilder(
    column: $table.signedResults,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fingerprint => $composableBuilder(
    column: $table.fingerprint,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get paperCounts => $composableBuilder(
    column: $table.paperCounts,
    builder: (column) => ColumnFilters(column),
  );

  $$ElectionsTableFilterComposer get electionId {
    final $$ElectionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.electionId,
      referencedTable: $db.elections,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ElectionsTableFilterComposer(
            $db: $db,
            $table: $db.elections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ResultRecordsTableOrderingComposer
    extends Composer<_$RegistryDb, $ResultRecordsTable> {
  $$ResultRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get signedResults => $composableBuilder(
    column: $table.signedResults,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fingerprint => $composableBuilder(
    column: $table.fingerprint,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paperCounts => $composableBuilder(
    column: $table.paperCounts,
    builder: (column) => ColumnOrderings(column),
  );

  $$ElectionsTableOrderingComposer get electionId {
    final $$ElectionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.electionId,
      referencedTable: $db.elections,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ElectionsTableOrderingComposer(
            $db: $db,
            $table: $db.elections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ResultRecordsTableAnnotationComposer
    extends Composer<_$RegistryDb, $ResultRecordsTable> {
  $$ResultRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get signedResults => $composableBuilder(
    column: $table.signedResults,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fingerprint => $composableBuilder(
    column: $table.fingerprint,
    builder: (column) => column,
  );

  GeneratedColumn<String> get paperCounts => $composableBuilder(
    column: $table.paperCounts,
    builder: (column) => column,
  );

  $$ElectionsTableAnnotationComposer get electionId {
    final $$ElectionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.electionId,
      referencedTable: $db.elections,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ElectionsTableAnnotationComposer(
            $db: $db,
            $table: $db.elections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ResultRecordsTableTableManager
    extends
        RootTableManager<
          _$RegistryDb,
          $ResultRecordsTable,
          ResultRecord,
          $$ResultRecordsTableFilterComposer,
          $$ResultRecordsTableOrderingComposer,
          $$ResultRecordsTableAnnotationComposer,
          $$ResultRecordsTableCreateCompanionBuilder,
          $$ResultRecordsTableUpdateCompanionBuilder,
          (ResultRecord, $$ResultRecordsTableReferences),
          ResultRecord,
          PrefetchHooks Function({bool electionId})
        > {
  $$ResultRecordsTableTableManager(_$RegistryDb db, $ResultRecordsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ResultRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ResultRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ResultRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> electionId = const Value.absent(),
                Value<String> signedResults = const Value.absent(),
                Value<String> fingerprint = const Value.absent(),
                Value<String?> paperCounts = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ResultRecordsCompanion(
                electionId: electionId,
                signedResults: signedResults,
                fingerprint: fingerprint,
                paperCounts: paperCounts,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String electionId,
                required String signedResults,
                required String fingerprint,
                Value<String?> paperCounts = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ResultRecordsCompanion.insert(
                electionId: electionId,
                signedResults: signedResults,
                fingerprint: fingerprint,
                paperCounts: paperCounts,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ResultRecordsTable, ResultRecord>(table),
                  $$ResultRecordsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({electionId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (electionId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.electionId,
                        referencedTable: $$ResultRecordsTableReferences
                            ._electionIdTable(db),
                        referencedColumn: $$ResultRecordsTableReferences
                            ._electionIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ResultRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$RegistryDb,
      $ResultRecordsTable,
      ResultRecord,
      $$ResultRecordsTableFilterComposer,
      $$ResultRecordsTableOrderingComposer,
      $$ResultRecordsTableAnnotationComposer,
      $$ResultRecordsTableCreateCompanionBuilder,
      $$ResultRecordsTableUpdateCompanionBuilder,
      (ResultRecord, $$ResultRecordsTableReferences),
      ResultRecord,
      PrefetchHooks Function({bool electionId})
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
    extends Composer<_$RegistryDb, $AuditLogTable> {
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
    extends Composer<_$RegistryDb, $AuditLogTable> {
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
    extends Composer<_$RegistryDb, $AuditLogTable> {
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
          _$RegistryDb,
          $AuditLogTable,
          AuditEntry,
          $$AuditLogTableFilterComposer,
          $$AuditLogTableOrderingComposer,
          $$AuditLogTableAnnotationComposer,
          $$AuditLogTableCreateCompanionBuilder,
          $$AuditLogTableUpdateCompanionBuilder,
          (
            AuditEntry,
            BaseReferences<_$RegistryDb, $AuditLogTable, AuditEntry>,
          ),
          AuditEntry,
          PrefetchHooks Function()
        > {
  $$AuditLogTableTableManager(_$RegistryDb db, $AuditLogTable table)
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
                  BaseReferences<_$RegistryDb, $AuditLogTable, AuditEntry>(
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
      _$RegistryDb,
      $AuditLogTable,
      AuditEntry,
      $$AuditLogTableFilterComposer,
      $$AuditLogTableOrderingComposer,
      $$AuditLogTableAnnotationComposer,
      $$AuditLogTableCreateCompanionBuilder,
      $$AuditLogTableUpdateCompanionBuilder,
      (AuditEntry, BaseReferences<_$RegistryDb, $AuditLogTable, AuditEntry>),
      AuditEntry,
      PrefetchHooks Function()
    >;

class $RegistryDbManager {
  final _$RegistryDb _db;
  $RegistryDbManager(this._db);
  $$ElectionsTableTableManager get elections =>
      $$ElectionsTableTableManager(_db, _db.elections);
  $$FeeConfigsTableTableManager get feeConfigs =>
      $$FeeConfigsTableTableManager(_db, _db.feeConfigs);
  $$PositionsTableTableManager get positions =>
      $$PositionsTableTableManager(_db, _db.positions);
  $$CandidatesTableTableManager get candidates =>
      $$CandidatesTableTableManager(_db, _db.candidates);
  $$VotersTableTableManager get voters =>
      $$VotersTableTableManager(_db, _db.voters);
  $$FeePaymentsTableTableManager get feePayments =>
      $$FeePaymentsTableTableManager(_db, _db.feePayments);
  $$ObjectionsTableTableManager get objections =>
      $$ObjectionsTableTableManager(_db, _db.objections);
  $$RegisterLocksTableTableManager get registerLocks =>
      $$RegisterLocksTableTableManager(_db, _db.registerLocks);
  $$CheckInsTableTableManager get checkIns =>
      $$CheckInsTableTableManager(_db, _db.checkIns);
  $$IssuedTokensTableTableManager get issuedTokens =>
      $$IssuedTokensTableTableManager(_db, _db.issuedTokens);
  $$DeviceEnrollmentsTableTableManager get deviceEnrollments =>
      $$DeviceEnrollmentsTableTableManager(_db, _db.deviceEnrollments);
  $$ResultRecordsTableTableManager get resultRecords =>
      $$ResultRecordsTableTableManager(_db, _db.resultRecords);
  $$AuditLogTableTableManager get auditLog =>
      $$AuditLogTableTableManager(_db, _db.auditLog);
}

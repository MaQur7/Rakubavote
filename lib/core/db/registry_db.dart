import 'package:drift/drift.dart';

import 'audit_table.dart';

part 'registry_db.g.dart';

// registry.db holds WHO: the election, the register, check-ins, fees and the
// audit log. It must never hold anything about how anyone voted (see SECURITY.md).

class Elections extends Table {
  TextColumn get id => text()();
  TextColumn get orgName => text()();
  BlobColumn get orgLogo => blob().nullable()();
  TextColumn get name => text()();
  IntColumn get year => integer()();
  /// school | association | party_primary | blank
  TextColumn get template => text()();
  /// JSON list of locale codes, e.g. ["en","ar","din"].
  TextColumn get languages => text()();
  TextColumn get idLabel => text()();
  TextColumn get groupLabel => text()();
  TextColumn get stationName => text()();
  /// setup | registration | review | locked | polling | closed
  TextColumn get state => text().withDefault(const Constant('setup'))();
  DateTimeColumn get reviewStart => dateTime().nullable()();
  DateTimeColumn get reviewEnd => dateTime().nullable()();
  BoolColumn get schoolConsentRecorded => boolean().withDefault(const Constant(false))();
  TextColumn get schoolConsentBy => text().nullable()();
  DateTimeColumn get schoolConsentAt => dateTime().nullable()();
  /// Signed ballot definition (SignedArtifact JSON), set by "Save and sign ballot".
  TextColumn get signedBallot => text().nullable()();
  /// Last voter number handed out; numbers are never reused.
  IntColumn get lastVoterNo => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

class FeeConfigs extends Table {
  TextColumn get electionId => text().references(Elections, #id)();
  BoolColumn get enabled => boolean()();
  /// Whole currency units (SSP and USD fees are whole numbers in practice).
  IntColumn get amount => integer().withDefault(const Constant(0))();
  /// SSP | USD | EITHER
  TextColumn get currency => text().withDefault(const Constant('SSP'))();
  /// block | allow_flagged
  TextColumn get unpaidPolicy => text().withDefault(const Constant('block'))();

  @override
  Set<Column> get primaryKey => {electionId};
}

class Positions extends Table {
  TextColumn get id => text()();
  TextColumn get electionId => text().references(Elections, #id)();
  IntColumn get sortOrder => integer()();
  /// JSON map locale -> title, e.g. {"en":"Chairman","ar":"الرئيس"}.
  TextColumn get titles => text()();
  /// ARGB colour chosen in setup (contrast-checked).
  IntColumn get colour => integer()();
  IntColumn get chooseN => integer().withDefault(const Constant(1))();
  BoolColumn get allowNoChoice => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}

class Candidates extends Table {
  TextColumn get id => text()();
  TextColumn get positionId => text().references(Positions, #id)();
  IntColumn get number => integer()();
  TextColumn get name => text()();
  BlobColumn get photo => blob().nullable()();
  BlobColumn get symbol => blob().nullable()();
  IntColumn get sortOrder => integer()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
        {positionId, number},
      ];
}

class Voters extends Table {
  TextColumn get id => text()();
  TextColumn get electionId => text().references(Elections, #id)();
  IntColumn get voterNo => integer()();
  TextColumn get fullName => text()();
  TextColumn get memberId => text().withDefault(const Constant(''))();
  TextColumn get groupName => text().withDefault(const Constant(''))();
  BlobColumn get photo => blob().nullable()();
  /// Increases on every reprint; old cards then fail verification.
  IntColumn get cardIssue => integer().withDefault(const Constant(1))();
  /// Registration date only (YYYY-MM-DD), as printed on the card.
  TextColumn get registeredOn => text()();
  TextColumn get registeredBy => text()();
  /// active | removed
  TextColumn get status => text().withDefault(const Constant('active'))();
  /// Registered without paying under the allow_flagged policy.
  BoolColumn get unpaidFlag => boolean().withDefault(const Constant(false))();
  /// The card issue last printed (null: never printed). Not personal data.
  IntColumn get cardPrintedIssue => integer().nullable()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
        {electionId, voterNo},
      ];
}

class FeePayments extends Table {
  TextColumn get voterId => text().references(Voters, #id)();
  BoolColumn get paid => boolean()();
  TextColumn get currency => text().nullable()();
  IntColumn get amount => integer().nullable()();
  TextColumn get receiptNo => text().nullable()();
  TextColumn get recordedBy => text()();

  @override
  Set<Column> get primaryKey => {voterId};
}

class Objections extends Table {
  TextColumn get id => text()();
  TextColumn get electionId => text().references(Elections, #id)();
  /// duplicate | missing | other
  TextColumn get kind => text()();
  TextColumn get subjectVoterId => text().nullable()();
  TextColumn get otherVoterId => text().nullable()();
  /// For "missing name" objections: the person who says they registered.
  TextColumn get claimantName => text().nullable()();
  TextColumn get raisedByName => text()();
  TextColumn get detail => text().withDefault(const Constant(''))();
  TextColumn get raisedOn => text()();
  /// null while open; otherwise keep_both | remove | add | reject | upheld
  TextColumn get decision => text().nullable()();
  TextColumn get decidedBy => text().nullable()();
  TextColumn get decidedOn => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class RegisterLocks extends Table {
  TextColumn get electionId => text().references(Elections, #id)();
  /// Signed register (SignedArtifact JSON).
  TextColumn get signedRegister => text()();
  TextColumn get fingerprint => text()();
  TextColumn get lockedBy => text()();
  DateTimeColumn get lockedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {electionId};
}

/// Who has been checked in. Holds no token and no precise time.
class CheckIns extends Table {
  TextColumn get voterId => text().references(Voters, #id)();
  TextColumn get electionId => text().references(Elections, #id)();
  /// qr | name | manual
  TextColumn get method => text()();
  TextColumn get manualReason => text().nullable()();
  TextColumn get official => text()();
  /// Hour only, e.g. 2026-11-05T09, for turnout per hour.
  TextColumn get hourBucket => text()();

  @override
  Set<Column> get primaryKey => {voterId};
}

/// Hashes of issued voting codes. No voter link, no time; random primary key
/// and WITHOUT ROWID so storage order is not issue order.
class IssuedTokens extends Table {
  TextColumn get tokenHash => text()();
  TextColumn get electionId => text()();
  /// active | used
  TextColumn get state => text().withDefault(const Constant('active'))();

  @override
  Set<Column> get primaryKey => {tokenHash};

  @override
  bool get withoutRowId => true;
}

class DeviceEnrollments extends Table {
  TextColumn get deviceId => text()();
  /// admin | checkin | booth
  TextColumn get role => text()();
  BlobColumn get signingPublic => blob()();
  BlobColumn get exchangePublic => blob()();
  TextColumn get label => text()();
  TextColumn get enrolledBy => text()();
  DateTimeColumn get enrolledAt => dateTime()();
  BoolColumn get revoked => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {deviceId};
}

class ResultRecords extends Table {
  TextColumn get electionId => text().references(Elections, #id)();
  /// Signed results (SignedArtifact JSON).
  TextColumn get signedResults => text()();
  TextColumn get fingerprint => text()();
  /// JSON of hand-counted receipt totals, entered after the paper recount.
  TextColumn get paperCounts => text().nullable()();

  @override
  Set<Column> get primaryKey => {electionId};
}

@DriftDatabase(tables: [
  Elections,
  FeeConfigs,
  Positions,
  Candidates,
  Voters,
  FeePayments,
  Objections,
  RegisterLocks,
  CheckIns,
  IssuedTokens,
  DeviceEnrollments,
  ResultRecords,
  AuditLog,
])
class RegistryDb extends _$RegistryDb {
  RegistryDb(super.e);

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          for (final t in [...auditTriggers, ...registryTriggers]) {
            await customStatement(t);
          }
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) await m.addColumn(voters, voters.cardPrintedIssue);
        },
      );
}

/// Database-level guards for rules that must hold whatever the UI does.
const registryTriggers = [
  // Fee settings are locked once the first voter of the election is registered.
  '''CREATE TRIGGER IF NOT EXISTS fee_locked_after_first_voter
     BEFORE UPDATE ON fee_configs
     WHEN EXISTS (SELECT 1 FROM voters WHERE election_id = OLD.election_id)
     BEGIN SELECT RAISE(ABORT, 'fee settings are locked after the first voter'); END''',
  '''CREATE TRIGGER IF NOT EXISTS fee_no_delete_after_first_voter
     BEFORE DELETE ON fee_configs
     WHEN EXISTS (SELECT 1 FROM voters WHERE election_id = OLD.election_id)
     BEGIN SELECT RAISE(ABORT, 'fee settings are locked after the first voter'); END''',
  '''CREATE TRIGGER IF NOT EXISTS fee_no_insert_after_first_voter
     BEFORE INSERT ON fee_configs
     WHEN EXISTS (SELECT 1 FROM voters WHERE election_id = NEW.election_id)
     BEGIN SELECT RAISE(ABORT, 'fee settings are locked after the first voter'); END''',
  // The register cannot change once it is locked.
  '''CREATE TRIGGER IF NOT EXISTS register_locked_insert
     BEFORE INSERT ON voters
     WHEN EXISTS (SELECT 1 FROM register_locks WHERE election_id = NEW.election_id)
     BEGIN SELECT RAISE(ABORT, 'the register is locked'); END''',
  '''CREATE TRIGGER IF NOT EXISTS register_locked_update
     BEFORE UPDATE OF voter_no, full_name, member_id, group_name, photo, status ON voters
     WHEN EXISTS (SELECT 1 FROM register_locks WHERE election_id = OLD.election_id)
     BEGIN SELECT RAISE(ABORT, 'the register is locked'); END''',
  '''CREATE TRIGGER IF NOT EXISTS register_locked_delete
     BEFORE DELETE ON voters
     WHEN EXISTS (SELECT 1 FROM register_locks WHERE election_id = OLD.election_id)
     BEGIN SELECT RAISE(ABORT, 'the register is locked'); END''',
  // The ballot cannot change once the register is locked (it is already signed and copied).
  '''CREATE TRIGGER IF NOT EXISTS ballot_frozen_positions
     BEFORE UPDATE ON positions
     WHEN EXISTS (SELECT 1 FROM register_locks WHERE election_id = OLD.election_id)
     BEGIN SELECT RAISE(ABORT, 'the ballot is frozen'); END''',
];

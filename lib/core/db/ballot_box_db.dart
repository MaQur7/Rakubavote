import 'package:drift/drift.dart';

import 'audit_table.dart';

part 'ballot_box_db.g.dart';

// ballotbox.db holds HOW people voted and nothing about WHO they are.
// Allowed in a vote row: random ballot id, position id, choice, device signature.
// Never add a voter id, token, fee field, timestamp or sequence number here.
// Every table uses a random primary key and WITHOUT ROWID, so rows are stored
// in key order, not arrival order. SECURITY.md explains why.

/// The signed ballot this box accepts votes for.
@DataClassName('StoredBallot')
class BallotDefinitions extends Table {
  TextColumn get electionId => text()();
  TextColumn get signedBallot => text()();
  /// The station laptop's signing key, pinned when the first ballot is loaded.
  BlobColumn get stationPublicKey => blob()();

  @override
  Set<Column> get primaryKey => {electionId};
}

/// Candidate photos, symbols and the organization logo, keyed by SHA-256
/// (the signed ballot refers to them by hash).
@DataClassName('MediaItem')
class BallotMedia extends Table {
  TextColumn get sha256 => text()();
  BlobColumn get bytes => blob()();

  @override
  Set<Column> get primaryKey => {sha256};
}

@DataClassName('VoteRecord')
class Votes extends Table {
  /// Random 128-bit id shared by the rows of one ballot; printed on the receipt.
  TextColumn get ballotId => text()();
  TextColumn get positionId => text()();
  /// JSON list of candidate ids (sorted), or ["NO_CHOICE"].
  TextColumn get choice => text()();
  /// Ed25519 signature of the booth device over the row (base64url).
  TextColumn get signature => text()();

  @override
  Set<Column> get primaryKey => {ballotId, positionId};

  @override
  bool get withoutRowId => true;
}

/// Codes activated by the laptop and not yet used at this booth.
class ActiveTokens extends Table {
  TextColumn get tokenHash => text()();

  @override
  Set<Column> get primaryKey => {tokenHash};

  @override
  bool get withoutRowId => true;
}

/// Codes already used, so they can never be used twice. No link to any vote.
class UsedTokens extends Table {
  TextColumn get tokenHash => text()();

  @override
  Set<Column> get primaryKey => {tokenHash};

  @override
  bool get withoutRowId => true;
}

/// One row per exported batch (counts only).
class BatchExports extends Table {
  IntColumn get batchSeq => integer()();
  IntColumn get ballotCount => integer()();
  TextColumn get batchHash => text()();

  @override
  Set<Column> get primaryKey => {batchSeq};
}

/// On the station laptop: the latest signed vote batch from each booth.
/// Holds the booth's id and its signed batch only.
class ImportedBatches extends Table {
  TextColumn get boothId => text()();
  IntColumn get batchSeq => integer()();
  IntColumn get ballotCount => integer()();
  TextColumn get signedBatch => text()();

  @override
  Set<Column> get primaryKey => {boothId};
}

@DriftDatabase(tables: [BallotDefinitions, BallotMedia, ImportedBatches, Votes, ActiveTokens, UsedTokens, BatchExports, AuditLog])
class BallotBoxDb extends _$BallotBoxDb {
  BallotBoxDb(super.e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          for (final t in auditTriggers) {
            await customStatement(t);
          }
          // Votes are final once cast.
          await customStatement('''CREATE TRIGGER IF NOT EXISTS votes_no_update
              BEFORE UPDATE ON votes BEGIN SELECT RAISE(ABORT, 'votes are final'); END''');
          await customStatement('''CREATE TRIGGER IF NOT EXISTS votes_no_delete
              BEFORE DELETE ON votes BEGIN SELECT RAISE(ABORT, 'votes are final'); END''');
        },
      );
}

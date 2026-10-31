import 'package:drift/drift.dart';

/// Append-only, hash-chained audit log. Present in both databases.
/// UPDATE and DELETE are blocked by triggers created in [auditTriggers].
@DataClassName('AuditEntry')
class AuditLog extends Table {
  @override
  String get tableName => 'audit_log';

  IntColumn get seq => integer()();
  TextColumn get prevHash => text()();
  /// UTC, to the second, ISO-8601.
  TextColumn get ts => text()();
  TextColumn get actor => text()();
  TextColumn get action => text()();
  /// Canonical JSON.
  TextColumn get payload => text()();
  TextColumn get hash => text()();

  @override
  Set<Column> get primaryKey => {seq};
}

const auditTriggers = [
  '''CREATE TRIGGER IF NOT EXISTS audit_log_no_update BEFORE UPDATE ON audit_log
     BEGIN SELECT RAISE(ABORT, 'audit log is append-only'); END''',
  '''CREATE TRIGGER IF NOT EXISTS audit_log_no_delete BEFORE DELETE ON audit_log
     BEGIN SELECT RAISE(ABORT, 'audit log is append-only'); END''',
];

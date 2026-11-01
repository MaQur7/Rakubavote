import 'package:drift/drift.dart';

import '../core/audit/audit_log.dart';
import '../core/crypto/device_keys.dart';
import '../core/db/registry_db.dart';

enum DeviceRole { checkin, booth }

/// Devices the station laptop trusts (paired tablets).
class EnrollmentService {
  EnrollmentService(this.db, {AuditLogService? audit, DateTime Function()? clock})
      : audit = audit ?? AuditLogService(db, clock: clock),
        _clock = clock ?? DateTime.now;

  final RegistryDb db;
  final AuditLogService audit;
  final DateTime Function() _clock;

  Future<DeviceEnrollment> enroll({
    required DeviceRole role,
    required Uint8List signingPublic,
    required Uint8List exchangePublic,
    required String label,
    required String official,
  }) async {
    final id = deviceIdFor(signingPublic);
    await db.into(db.deviceEnrollments).insertOnConflictUpdate(DeviceEnrollmentsCompanion.insert(
          deviceId: id,
          role: role.name,
          signingPublic: signingPublic,
          exchangePublic: exchangePublic,
          label: label,
          enrolledBy: official,
          enrolledAt: _clock().toUtc(),
          revoked: const Value(false),
        ));
    await audit.append(
        actor: official, action: AuditAction.deviceEnrolled, payload: {'device': id, 'role': role.name, 'label': label});
    return (await byId(id))!;
  }

  Future<void> revoke(String deviceId, {required String official}) async {
    await (db.update(db.deviceEnrollments)..where((d) => d.deviceId.equals(deviceId)))
        .write(const DeviceEnrollmentsCompanion(revoked: Value(true)));
    await audit.append(actor: official, action: 'device.revoked', payload: {'device': deviceId});
  }

  Future<DeviceEnrollment?> byId(String deviceId) => (db.select(db.deviceEnrollments)
        ..where((d) => d.deviceId.equals(deviceId) & d.revoked.equals(false)))
      .getSingleOrNull();

  Future<List<DeviceEnrollment>> active({DeviceRole? role}) => (db.select(db.deviceEnrollments)
        ..where((d) => d.revoked.equals(false) & (role == null ? const Constant(true) : d.role.equals(role.name)))
        ..orderBy([(d) => OrderingTerm.asc(d.enrolledAt)]))
      .get();

  Stream<List<DeviceEnrollment>> watchActive() => (db.select(db.deviceEnrollments)
        ..where((d) => d.revoked.equals(false))
        ..orderBy([(d) => OrderingTerm.asc(d.enrolledAt)]))
      .watch();
}

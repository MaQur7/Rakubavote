import 'dart:convert';
import 'dart:io';

import '../core/audit/audit_log.dart';
import '../core/crypto/device_keys.dart';
import '../core/crypto/key_vault.dart';
import '../core/db/backup.dart';
import '../core/db/ballot_box_db.dart';
import '../core/db/open_encrypted.dart';
import '../core/db/registry_db.dart';

enum DeviceMode {
  admin,
  checkin,
  booth;

  /// Booth tablets never hold the register; check-in devices never hold votes.
  bool get usesRegistry => this != booth;
  bool get usesBallotBox => this != checkin;
}

class DeviceInfo {
  const DeviceInfo({required this.mode, required this.deviceId});
  final DeviceMode mode;
  final String deviceId;

  Map<String, Object?> toJson() => {'v': 1, 'mode': mode.name, 'deviceId': deviceId};
  static DeviceInfo fromJson(Map m) =>
      DeviceInfo(mode: DeviceMode.values.byName(m['mode'] as String), deviceId: m['deviceId'] as String);
}

/// PIN rules: at least 6 digits, so it cannot be guessed in a few tries.
bool isAcceptablePin(String pin) => RegExp(r'^\d{6,12}$').hasMatch(pin);

/// An unlocked device: keys and open databases. Created by [DeviceStore].
class DeviceSession {
  DeviceSession({
    required this.info,
    required this.keys,
    required this.secrets,
    required this.official,
    this.registry,
    this.ballotBox,
  });

  final DeviceInfo info;
  final DeviceKeys keys;
  final DeviceSecrets secrets;
  /// Name of the official using the device; written to the audit log.
  final String official;
  final RegistryDb? registry;
  final BallotBoxDb? ballotBox;

  Future<void> close() async {
    await registry?.close();
    await ballotBox?.close();
  }
}

/// Files of one device in its private app folder:
/// `device.json` (mode), `vault.json` (keys under the PIN), and the
/// encrypted `registry.db` / `ballotbox.db`.
class DeviceStore {
  DeviceStore(this.dir, {this.kdf = KdfParams.standard});

  final Directory dir;
  final KdfParams kdf;

  File get _infoFile => File('${dir.path}/device.json');
  File get _vaultFile => File('${dir.path}/vault.json');
  File get registryFile => File('${dir.path}/registry.db');
  File get ballotBoxFile => File('${dir.path}/ballotbox.db');

  Future<DeviceInfo?> readInfo() async {
    if (!await _infoFile.exists() || !await _vaultFile.exists()) return null;
    return DeviceInfo.fromJson(jsonDecode(await _infoFile.readAsString()) as Map);
  }

  Future<DeviceSession> setUp({required DeviceMode mode, required String pin, required String official}) async {
    if (!isAcceptablePin(pin)) throw ArgumentError('PIN must be 6 to 12 digits');
    if (await readInfo() != null) throw StateError('This device is already set up');
    await dir.create(recursive: true);
    final secrets = DeviceSecrets.generate();
    final keys = await DeviceKeys.fromSeeds(secrets.signingSeed, secrets.exchangeSeed);
    final info = DeviceInfo(mode: mode, deviceId: keys.deviceId);
    await _vaultFile.writeAsString(await KeyVault.seal(secrets, pin, params: kdf), flush: true);
    await _infoFile.writeAsString(jsonEncode(info.toJson()), flush: true);
    final session = _open(info, keys, secrets, official);
    final log = session.registry ?? session.ballotBox!;
    await AuditLogService(log).append(
        actor: official, action: AuditAction.deviceSetup, payload: {'mode': mode.name, 'deviceId': keys.deviceId});
    return session;
  }

  /// Throws [WrongPinException] for a wrong PIN.
  Future<DeviceSession> unlock({required String pin, required String official}) async {
    final info = await readInfo();
    if (info == null) throw StateError('This device is not set up');
    final secrets = await KeyVault.open(await _vaultFile.readAsString(), pin);
    final keys = await DeviceKeys.fromSeeds(secrets.signingSeed, secrets.exchangeSeed);
    return _open(info, keys, secrets, official);
  }

  /// True if [pin] opens this device's vault (used to leave the booth screen).
  Future<bool> verifyPin(String pin) async {
    try {
      await KeyVault.open(await _vaultFile.readAsString(), pin);
      return true;
    } on WrongPinException {
      return false;
    }
  }

  Future<void> changePin(String oldPin, String newPin) async {
    if (!isAcceptablePin(newPin)) throw ArgumentError('PIN must be 6 to 12 digits');
    final v = await KeyVault.changePin(await _vaultFile.readAsString(), oldPin, newPin, params: kdf);
    await _vaultFile.writeAsString(v, flush: true);
  }

  DeviceSession _open(DeviceInfo info, DeviceKeys keys, DeviceSecrets secrets, String official) =>
      DeviceSession(
        info: info,
        keys: keys,
        secrets: secrets,
        official: official,
        registry: info.mode.usesRegistry
            ? RegistryDb(openEncrypted(file: registryFile, key: secrets.registryDbKey))
            : null,
        ballotBox: info.mode.usesBallotBox
            ? BallotBoxDb(openEncrypted(file: ballotBoxFile, key: secrets.ballotBoxDbKey))
            : null,
      );

  /// "Back up to USB": an encrypted copy of the register plus the vault, in a
  /// new dated folder under [target]. Restoring needs the officer PIN.
  Future<Directory> backup(DeviceSession s, Directory target, {DateTime? now}) async {
    final t = (now ?? DateTime.now()).toLocal();
    String two(int n) => n.toString().padLeft(2, '0');
    final out = Directory('${target.path}/rakubavote-backup-${t.year}${two(t.month)}${two(t.day)}-'
        '${two(t.hour)}${two(t.minute)}');
    await out.create(recursive: true);
    await _vaultFile.copy('${out.path}/vault.json');
    await _infoFile.copy('${out.path}/device.json');
    if (s.registry != null) {
      await exportEncryptedCopy(s.registry!, File('${out.path}/registry.db'), s.secrets.registryDbKey);
    }
    if (s.ballotBox != null) {
      await exportEncryptedCopy(s.ballotBox!, File('${out.path}/ballotbox.db'), s.secrets.ballotBoxDbKey);
    }
    return out;
  }
}

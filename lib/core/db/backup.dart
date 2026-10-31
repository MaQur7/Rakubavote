import 'dart:io';

import 'package:drift/drift.dart';

import '../crypto/bytes.dart';

/// Writes an encrypted copy of a live database to [target] (for example a
/// USB drive). The copy is encrypted with [backupKey], so it is useless
/// without the device vault and officer PIN. Uses SQLCipher's
/// `sqlcipher_export`, which copies schema, triggers and data consistently.
Future<void> exportEncryptedCopy(GeneratedDatabase db, File target, Uint8List backupKey) async {
  if (await target.exists()) await target.delete();
  final path = target.path.replaceAll("'", "''");
  await db.customStatement("ATTACH DATABASE '$path' AS backup KEY \"x'${hexEncode(backupKey)}'\"");
  try {
    await db.customSelect("SELECT sqlcipher_export('backup')").get();
  } finally {
    await db.customStatement('DETACH DATABASE backup');
  }
}

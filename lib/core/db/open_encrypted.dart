import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:sqlite3/sqlite3.dart';

import '../crypto/bytes.dart';

class DatabaseKeyException implements Exception {
  @override
  String toString() => 'DatabaseKeyException: wrong key or not a Rakubavote database';
}

/// Opens a SQLCipher database with a raw 256-bit key. With [file] null the
/// database lives in memory (tests). `secure_delete` overwrites deleted rows.
QueryExecutor openEncrypted({File? file, required Uint8List key, bool logStatements = false}) {
  if (key.length != 32) throw ArgumentError('Database key must be 32 bytes');
  final hexKey = hexEncode(key);
  void setup(Database db) {
    final cipher = db.select('PRAGMA cipher_version');
    if (cipher.isEmpty) {
      throw StateError('SQLCipher is not available; refusing to open an unencrypted database');
    }
    db.execute("PRAGMA key = \"x'$hexKey'\"");
    try {
      db.select('SELECT count(*) FROM sqlite_master');
    } on SqliteException {
      throw DatabaseKeyException();
    }
    db.execute('PRAGMA secure_delete = ON');
    db.execute('PRAGMA foreign_keys = ON');
  }

  if (file == null) {
    return NativeDatabase.memory(setup: setup, logStatements: logStatements);
  }
  return NativeDatabase(file, setup: setup, logStatements: logStatements);
}

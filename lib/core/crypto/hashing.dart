import 'dart:convert';
import 'dart:typed_data';

import 'package:cryptography/dart.dart';

import 'bytes.dart';

const _sha256 = DartSha256();

Uint8List sha256(List<int> data) =>
    Uint8List.fromList(_sha256.hashSync(data).bytes);

String sha256Hex(List<int> data) => hexEncode(sha256(data));

String sha256HexOfString(String s) => sha256Hex(utf8.encode(s));

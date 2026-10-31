import 'dart:convert';
import 'dart:typed_data';

/// Deterministic JSON used for everything that is hashed or signed:
/// object keys sorted by code unit, no whitespace, integers only (no floats),
/// UTF-8 output. Two equal values always give identical bytes.
String canonicalJson(Object? value) {
  final sb = StringBuffer();
  _write(sb, value);
  return sb.toString();
}

Uint8List canonicalJsonBytes(Object? value) =>
    Uint8List.fromList(utf8.encode(canonicalJson(value)));

void _write(StringBuffer sb, Object? v) {
  if (v == null || v is bool || v is String) {
    sb.write(jsonEncode(v));
  } else if (v is int) {
    sb.write(v.toString());
  } else if (v is num) {
    throw ArgumentError('Canonical JSON allows integers only, got $v');
  } else if (v is List) {
    sb.write('[');
    for (var i = 0; i < v.length; i++) {
      if (i > 0) sb.write(',');
      _write(sb, v[i]);
    }
    sb.write(']');
  } else if (v is Map) {
    final keys = v.keys.map((k) {
      if (k is! String) throw ArgumentError('Canonical JSON keys must be strings');
      return k;
    }).toList()
      ..sort();
    sb.write('{');
    for (var i = 0; i < keys.length; i++) {
      if (i > 0) sb.write(',');
      sb.write(jsonEncode(keys[i]));
      sb.write(':');
      _write(sb, v[keys[i]]);
    }
    sb.write('}');
  } else {
    throw ArgumentError('Type ${v.runtimeType} is not allowed in canonical JSON');
  }
}

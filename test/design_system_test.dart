import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:rakubavote/core/theme.dart';

/// Guards docs/design-system.md (D25): screens use only the tokens and scales
/// in lib/core/theme.dart. If this fails, use a token, or add the case to the
/// design system first.
void main() {
  // PDF layouts work in printer points, not screen pixels; generated files are
  // not hand-written.
  bool skipped(String path) =>
      path.endsWith('lib/core/theme.dart') ||
      // The mark's own geometry (unit 4 on a 120 square), checked by brand_test.dart.
      path.endsWith('lib/core/brand/brand.dart') ||
      path.endsWith('_pdf.dart') ||
      path.endsWith('pdf_fonts.dart') ||
      path.contains('lib/l10n/') ||
      path.endsWith('.g.dart');

  final files = Directory('lib')
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('.dart') && !skipped(f.path.replaceAll(r'\', '/')))
      .toList();

  List<String> scan(RegExp pattern, bool Function(RegExpMatch m) bad) {
    final hits = <String>[];
    for (final f in files) {
      final lines = f.readAsLinesSync();
      for (var i = 0; i < lines.length; i++) {
        if (lines[i].trimLeft().startsWith('//')) continue;
        for (final m in pattern.allMatches(lines[i])) {
          if (bad(m)) hits.add('${f.path}:${i + 1}: ${lines[i].trim()}');
        }
      }
    }
    return hits;
  }

  bool notIn(String? n, List<double> scale) {
    final v = double.tryParse(n ?? '');
    return v != null && v != 0 && !scale.contains(v);
  }

  test('no hard-coded colours outside the theme', () {
    expect(scan(RegExp(r'Color\(0x'), (_) => true), isEmpty);
  });

  test('font sizes come from the type scale', () {
    expect(scan(RegExp(r'fontSize: (\d+(?:\.\d+)?)'), (m) => notIn(m[1], RakubaType.all)), isEmpty);
  });

  test('corner radii come from the radius scale', () {
    expect(scan(RegExp(r'(?:BorderRadius|Radius)\.circular\((\d+(?:\.\d+)?)\)'),
        (m) => notIn(m[1], RakubaRadius.all)), isEmpty);
  });

  test('spacing comes from the spacing scale', () {
    final number = RegExp(r'(?<![\w.])(\d+(?:\.\d+)?)(?![\w.])');
    final hits = scan(RegExp(r'(?:EdgeInsets(?:Directional)?\.\w+\(([^()]*)\)|SizedBox\((?:height|width): ([\d.]+)\)|(?:spacing|runSpacing|mainAxisSpacing|crossAxisSpacing): ([\d.]+))'),
        (m) {
      final args = m[1] ?? m[2] ?? m[3] ?? '';
      return number.allMatches(args).any((n) => notIn(n[1], RakubaSpace.all));
    });
    expect(hits, isEmpty);
  });

  test('banned defaults are not used', () {
    final banned = RegExp(
        r'ColorScheme\.fromSeed|BoxShadow|LinearGradient|RadialGradient|SweepGradient|BackdropFilter|CircularProgressIndicator|elevation: [1-9]');
    expect(scan(banned, (_) => true), isEmpty);
  });
}

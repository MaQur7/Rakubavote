import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rakubavote/core/brand/brand.dart';
import 'package:rakubavote/core/theme.dart';

/// The logo is fixed (D26). These tests fail if its numbers drift, in code or
/// in the files under brand/.
void main() {
  const u = MarkGeometry.unit;

  test('the mark keeps its construction: roof 26u x 4u, posts 3u x 16u, bay 14u x 16u', () {
    expect(MarkGeometry.roof.size, const Size(26 * u, 4 * u));
    expect(MarkGeometry.postLeft.size, const Size(3 * u, 16 * u));
    expect(MarkGeometry.postRight.size, MarkGeometry.postLeft.size);
    expect(MarkGeometry.bay.size, const Size(14 * u, 16 * u));
    // Posts stand directly under the roof, 3u in from each end.
    expect(MarkGeometry.postLeft.top, MarkGeometry.roof.bottom);
    expect(MarkGeometry.postLeft.left - MarkGeometry.roof.left, 3 * u);
    expect(MarkGeometry.roof.right - MarkGeometry.postRight.right, 3 * u);
    expect(MarkGeometry.bay.left, MarkGeometry.postLeft.right);
    expect(MarkGeometry.bay.right, MarkGeometry.postRight.left);
    expect(MarkGeometry.stroke, MarkGeometry.postLeft.width);
  });

  test('the tick is at 45 degrees with arms 1 : 2, centred in the bay', () {
    final [a, v, b] = MarkGeometry.tick;
    final short = v - a;
    final long = b - v;
    expect(short.dx, short.dy, reason: 'short arm falls at 45 degrees');
    expect(long.dx, -long.dy, reason: 'long arm rises at 45 degrees');
    expect(long.dx, 2 * short.dx);
    expect((a.dx + b.dx) / 2, MarkGeometry.bay.center.dx);
  });

  test('the files in brand/ are drawn from the same numbers', () {
    final svg = File('brand/rakubavote-mark.svg').readAsStringSync();
    expect(svg, contains('viewBox="0 0 120 120"'));
    expect(svg, contains('<rect x="8" y="20" width="104" height="16" rx="4" fill="#C8963E"/>'));
    expect(svg, contains('<rect x="20" y="36" width="12" height="64" fill="#1B1B1B"/>'));
    expect(svg, contains('<rect x="88" y="36" width="12" height="64" fill="#1B1B1B"/>'));
    expect(svg, contains('d="M42 72 L54 84 L78 60"'));
    expect(svg, contains('stroke="#1D4E89" stroke-width="12"'));
  });

  testWidgets('logo: the name is Latin and left to right in Arabic, the role is plain text', (tester) async {
    await tester.pumpWidget(MaterialApp(
      theme: buildRakubaTheme(arabic: true),
      home: const Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(body: RakubaLogo(onDark: true, role: 'مكتب التحقق')),
      ),
    ));
    final name = tester.widget<Text>(find.byWidgetPredicate((w) => w is Text && w.textSpan != null));
    expect(name.textSpan!.toPlainText(), 'Rakubavote');
    expect(name.textDirection, TextDirection.ltr);
    expect(find.text('مكتب التحقق'), findsOneWidget);
    expect(find.byType(RakubaMark), findsOneWidget);
  });

  testWidgets('the drawn tick is complete at once when animations are off', (tester) async {
    await tester.pumpWidget(const MediaQuery(
      data: MediaQueryData(disableAnimations: true),
      child: Center(child: DrawnTick(size: 96, colour: RakubaColors.acaciaGreen)),
    ));
    expect(tester.widget<BrandTick>(find.byType(BrandTick)).progress, 1);
    expect(tester.hasRunningAnimations, isFalse);
  });

  testWidgets('the shelter frame keeps the bay proportion 7 : 8', (tester) async {
    await tester.pumpWidget(MaterialApp(
      theme: buildRakubaTheme(arabic: false),
      home: const Scaffold(body: Center(child: ShelterFrame(width: 208, label: 'Photo'))),
    ));
    final hatch = tester.getSize(find.byType(ThatchHatch));
    expect(hatch.width / hatch.height, closeTo(MarkGeometry.bayAspect, 0.001));
    expect(find.text('Photo'), findsOneWidget);
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rakubavote/app/app.dart';
import 'package:rakubavote/core/theme.dart';

void main() {
  for (final code in ['en', 'ar', 'din']) {
    testWidgets('device mode screen renders in $code', (tester) async {
      await tester.pumpWidget(RakubavoteApp(initialLocale: Locale(code)));
      await tester.pumpAndSettle();
      expect(find.text('Rakubavote'), findsOneWidget);
      final dir = Directionality.of(tester.element(find.byType(DeviceModeScreen)));
      expect(dir, code == 'ar' ? TextDirection.rtl : TextDirection.ltr);
    });
  }

  test('brand colours meet the contrast rules in the guidelines', () {
    expect(meetsTextContrast(RakubaColors.white, RakubaColors.nileBlue), isTrue);
    expect(meetsTextContrast(RakubaColors.white, RakubaColors.acaciaGreen), isTrue);
    expect(meetsTextContrast(RakubaColors.white, RakubaColors.clay), isTrue);
    expect(meetsTextContrast(RakubaColors.ink, RakubaColors.thatchGold), isTrue);
    expect(meetsTextContrast(RakubaColors.white, RakubaColors.thatchGold), isFalse);
    expect(meetsTextContrast(RakubaColors.lightThatch, RakubaColors.ink), isTrue);
  });

  test('default position colours all carry white heading text', () {
    for (final c in defaultPositionColours) {
      expect(meetsTextContrast(RakubaColors.white, c), isTrue, reason: '$c');
    }
  });
}

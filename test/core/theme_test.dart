import 'package:flutter_test/flutter_test.dart';
import 'package:rakubavote/core/theme.dart';

void main() {
  test('brand colours meet the contrast rules in the guidelines', () {
    expect(meetsTextContrast(RakubaColors.white, RakubaColors.nileBlue), isTrue);
    expect(meetsTextContrast(RakubaColors.white, RakubaColors.acaciaGreen), isTrue);
    expect(meetsTextContrast(RakubaColors.white, RakubaColors.clay), isTrue);
    expect(meetsTextContrast(RakubaColors.ink, RakubaColors.thatchGold), isTrue);
    expect(meetsTextContrast(RakubaColors.white, RakubaColors.thatchGold), isFalse);
    expect(meetsTextContrast(RakubaColors.lightThatch, RakubaColors.ink), isTrue);
    expect(meetsTextContrast(RakubaColors.white, RakubaColors.disabled), isTrue);
  });

  test('default position colours all carry white heading text', () {
    for (final c in defaultPositionColours) {
      expect(meetsTextContrast(RakubaColors.white, c), isTrue, reason: '$c');
    }
  });
}

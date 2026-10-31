import 'package:flutter/material.dart';

/// Brand colour tokens. Defined once here and nowhere else (see CLAUDE.md).
/// Never put white text on [thatchGold] or [lightThatch].
abstract final class RakubaColors {
  static const nileBlue = Color(0xFF1D4E89);
  static const acaciaGreen = Color(0xFF1F5E3A);
  static const clay = Color(0xFFA9521A);
  static const thatchGold = Color(0xFFC8963E);
  static const lightThatch = Color(0xFFE6C27A);
  static const ink = Color(0xFF1B1B1B);
  static const paper = Color(0xFFF4F1EA);

  /// Neutral surfaces derived from the palette (cards, photo placeholders, borders).
  static const card = Color(0xFFFFFFFF);
  static const placeholder = Color(0xFFDDD6C6);
  static const border = Color(0xFF8A8577);
  static const warningTint = Color(0xFFFFF6E3);
  static const successTint = Color(0xFFE7F2EA);
  static const white = Color(0xFFFFFFFF);
}

/// Default palette offered for ballot positions, in order. Position colours are
/// election data and can be changed in setup; each must pass [meetsTextContrast]
/// against white heading text.
const List<Color> defaultPositionColours = [
  RakubaColors.nileBlue,
  Color(0xFF2E7D4F),
  RakubaColors.clay,
  Color(0xFF5B3A8C),
  Color(0xFF8C2F39),
  Color(0xFF155E63),
  RakubaColors.ink,
];

abstract final class RakubaFonts {
  static const latin = 'AtkinsonHyperlegible';
  static const arabic = 'NotoSansArabic';
}

/// Sizes from the brand guidelines (logical pixels).
abstract final class RakubaSizes {
  static const minTouch = 64.0;
  static const positionHeading = 32.0;
  static const candidateName = 26.0;
  static const body = 17.0;
  static const label = 14.0;
  static const cardRadius = 14.0;
}

/// WCAG relative luminance contrast ratio between two colours.
double contrastRatio(Color a, Color b) {
  final la = a.computeLuminance();
  final lb = b.computeLuminance();
  final hi = la > lb ? la : lb;
  final lo = la > lb ? lb : la;
  return (hi + 0.05) / (lo + 0.05);
}

/// True when [fg] text on [bg] reaches WCAG AA (4.5:1, or 3:1 for large text).
bool meetsTextContrast(Color fg, Color bg, {bool largeText = false}) =>
    contrastRatio(fg, bg) >= (largeText ? 3.0 : 4.5);

ThemeData buildRakubaTheme({required bool arabic}) {
  final family = arabic ? RakubaFonts.arabic : RakubaFonts.latin;
  final fallback = arabic ? [RakubaFonts.latin] : [RakubaFonts.arabic];
  final scheme = ColorScheme.fromSeed(
    seedColor: RakubaColors.nileBlue,
    primary: RakubaColors.nileBlue,
    onPrimary: RakubaColors.white,
    secondary: RakubaColors.acaciaGreen,
    onSecondary: RakubaColors.white,
    error: RakubaColors.clay,
    onError: RakubaColors.white,
    surface: RakubaColors.paper,
    onSurface: RakubaColors.ink,
  );
  final base = ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: RakubaColors.paper,
    fontFamily: family,
    fontFamilyFallback: fallback,
  );
  const minSize = Size(RakubaSizes.minTouch, RakubaSizes.minTouch);
  final shape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(12));
  const btnText = TextStyle(fontSize: 18, fontWeight: FontWeight.w700);
  return base.copyWith(
    textTheme: base.textTheme.apply(bodyColor: RakubaColors.ink, displayColor: RakubaColors.ink),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(minimumSize: minSize, shape: shape, textStyle: btnText),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: minSize,
        shape: shape,
        textStyle: btnText,
        side: const BorderSide(color: RakubaColors.ink, width: 2),
      ),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      filled: true,
      fillColor: RakubaColors.card,
      border: OutlineInputBorder(),
    ),
    cardTheme: CardThemeData(
      color: RakubaColors.card,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(RakubaSizes.cardRadius),
        side: const BorderSide(color: RakubaColors.placeholder),
      ),
    ),
  );
}

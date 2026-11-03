import 'package:flutter/material.dart';

// Tokens and component styles from docs/design-system.md (D25). Every colour,
// size, space and radius used on screens comes from here; a test
// (test/design_system_test.dart) fails on values that are not on these scales.

/// Brand colour tokens and their roles. Defined once here and nowhere else.
/// Never put white text on [thatchGold] or [lightThatch].
abstract final class RakubaColors {
  static const nileBlue = Color(0xFF1D4E89);
  static const acaciaGreen = Color(0xFF1F5E3A);
  static const clay = Color(0xFFA9521A);
  static const thatchGold = Color(0xFFC8963E);
  static const lightThatch = Color(0xFFE6C27A);
  static const ink = Color(0xFF1B1B1B);
  static const paper = Color(0xFFF4F1EA);

  /// The one surface level: panels, ballot rows, dialogs.
  static const card = Color(0xFFFFFFFF);
  /// Secondary text: hints, small print, table notes. At least 6:1 on paper and white.
  static const inkMuted = Color(0xFF57524A);
  /// 1 px dividers and panel edges; photo placeholders.
  static const rule = Color(0xFFDDD6C6);
  static const placeholder = rule;
  /// Borders of inputs, tick boxes and unselected rows (3:1 against white).
  static const border = Color(0xFF8A8577);
  /// Wash behind a clay notice bar.
  static const warningTint = Color(0xFFFFF6E3);
  /// Wash of the End screen.
  static const successTint = Color(0xFFE7F2EA);
  static const white = Color(0xFFFFFFFF);
  /// Disabled fill (white text 5.3:1) or disabled text and border on paper (4.9:1).
  static const disabled = Color(0xFF6E6A60);
  static const transparent = Color(0x00000000);

  /// Interaction layers over any surface.
  static const hoverLayer = Color(0x141B1B1B); // Ink 8 %
  static const focusLayer = Color(0x1F1B1B1B); // Ink 12 %
  static const pressedLayer = Color(0x291B1B1B); // Ink 16 %
  static const hoverLayerOnDark = Color(0x29FFFFFF);
  static const pressedLayerOnDark = Color(0x47FFFFFF);
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
  /// Covers letters Atkinson Hyperlegible lacks, such as Dinka ɛ, ɔ, ŋ.
  static const latinExtended = 'NotoSans';

  static String familyFor({required bool arabic}) => arabic ? RakubaFonts.arabic : latin;

  static List<String> fallbackFor({required bool arabic}) =>
      arabic ? const [latin, latinExtended] : const [latinExtended, RakubaFonts.arabic];
}

/// The seven type sizes (logical pixels). Weights are 400 and 700 only.
abstract final class RakubaType {
  /// Voting code at check-in, "End".
  static const display = 48.0;
  /// Position heading, booth screen titles, fingerprint codes.
  static const title = 32.0;
  /// Candidate names, voter name at check-in.
  static const name = 26.0;
  /// Admin section headings, dialog titles.
  static const heading = 22.0;
  /// Booth body text, buttons.
  static const bodyLarge = 18.0;
  /// Admin body, table cells, form fields.
  static const body = 16.0;
  /// Field labels, table headers, small notes. Minimum size.
  static const label = 14.0;

  static const all = [display, title, name, heading, bodyLarge, body, label];

  static double lineHeightFor(double size) => switch (size) {
        display => 56 / 48,
        title => 40 / 32,
        name => 32 / 26,
        heading => 28 / 22,
        bodyLarge => 26 / 18,
        body => 24 / 16,
        _ => 20 / 14,
      };
}

/// Spacing scale (logical pixels).
abstract final class RakubaSpace {
  static const xxs = 4.0;
  static const xs = 8.0;
  static const s = 16.0;
  static const m = 24.0;
  static const l = 32.0;
  static const xl = 48.0;
  static const xxl = 64.0;

  static const all = [xxs, xs, s, m, l, xl, xxl];
}

/// Corner radius scale.
abstract final class RakubaRadius {
  /// Small admin tick box only.
  static const tick = 4.0;
  /// Inputs, booth tick boxes, number boxes, photos.
  static const input = 8.0;
  /// Buttons and ballot rows.
  static const control = 12.0;
  /// Panels and dialogs.
  static const panel = 16.0;
  /// Status pills and the Help button only.
  static const pill = 999.0;

  static const all = [tick, input, control, panel, pill];
}

/// Line widths.
abstract final class RakubaLine {
  static const hairline = 1.0;
  static const strong = 2.0;
  static const selected = 3.0;
}

/// Kept for existing call sites; values come from the scales above.
abstract final class RakubaSizes {
  static const minTouch = RakubaSpace.xxl;
  static const positionHeading = RakubaType.title;
  static const candidateName = RakubaType.name;
  static const body = RakubaType.bodyLarge;
  static const label = RakubaType.label;
  static const cardRadius = RakubaRadius.panel;
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

/// A text style on the type scale in the current theme's fonts, with the
/// fallback list (so Arabic and Dinka letters never show as empty boxes).
TextStyle rakubaText(BuildContext context, double size, {bool bold = false, Color? colour}) {
  final base = Theme.of(context).textTheme.bodyLarge!;
  return TextStyle(
    fontSize: size,
    height: RakubaType.lineHeightFor(size),
    fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
    fontFamily: base.fontFamily,
    fontFamilyFallback: base.fontFamilyFallback,
    color: colour,
  );
}

/// Bold button text of a given size with the theme's fonts and fallbacks.
TextStyle buttonTextStyle(BuildContext context, double size) => rakubaText(context, size, bold: true);

/// Focus ring: 3 px Ink outside the shape, on every focusable control.
const _focusRing = BorderSide(
    color: RakubaColors.ink, width: RakubaLine.selected, strokeAlign: BorderSide.strokeAlignOutside);

WidgetStateProperty<Color?> _layers({bool onDark = false}) => WidgetStateProperty.resolveWith((s) {
      if (s.contains(WidgetState.disabled)) return null;
      if (s.contains(WidgetState.pressed)) {
        return onDark ? RakubaColors.pressedLayerOnDark : RakubaColors.pressedLayer;
      }
      if (s.contains(WidgetState.hovered)) return onDark ? RakubaColors.hoverLayerOnDark : RakubaColors.hoverLayer;
      if (s.contains(WidgetState.focused)) return onDark ? RakubaColors.hoverLayerOnDark : RakubaColors.focusLayer;
      return null;
    });

final _controlShape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(RakubaRadius.control));

/// Outlined button used on voter screens: white fill, 2 px Ink border.
ButtonStyle boothOutlinedStyle() => ButtonStyle(
      backgroundColor: const WidgetStatePropertyAll(RakubaColors.card),
      foregroundColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.disabled) ? RakubaColors.disabled : RakubaColors.nileBlue),
      side: WidgetStateProperty.resolveWith((s) {
        if (s.contains(WidgetState.focused)) return _focusRing;
        return BorderSide(
            color: s.contains(WidgetState.disabled) ? RakubaColors.disabled : RakubaColors.ink,
            width: RakubaLine.strong);
      }),
    );

/// Destructive secondary action (Remove, Delete): clay text and border.
ButtonStyle destructiveOutlinedStyle() => ButtonStyle(
      foregroundColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.disabled) ? RakubaColors.disabled : RakubaColors.clay),
      side: WidgetStateProperty.resolveWith((s) {
        if (s.contains(WidgetState.focused)) return _focusRing;
        return BorderSide(
            color: s.contains(WidgetState.disabled) ? RakubaColors.disabled : RakubaColors.clay);
      }),
    );

/// Filled button in a colour other than Nile Blue (Acacia Green for confirm and
/// save, or a ballot position colour).
ButtonStyle filledColourStyle(Color colour) => ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.disabled) ? RakubaColors.disabled : colour),
    );

ThemeData buildRakubaTheme({required bool arabic}) {
  final family = RakubaFonts.familyFor(arabic: arabic);
  final fallback = RakubaFonts.fallbackFor(arabic: arabic);

  // Explicit scheme: no seed, so Material invents no tints of its own.
  const scheme = ColorScheme(
    brightness: Brightness.light,
    primary: RakubaColors.nileBlue,
    onPrimary: RakubaColors.white,
    primaryContainer: RakubaColors.paper,
    onPrimaryContainer: RakubaColors.ink,
    primaryFixed: RakubaColors.paper,
    primaryFixedDim: RakubaColors.rule,
    onPrimaryFixed: RakubaColors.ink,
    onPrimaryFixedVariant: RakubaColors.ink,
    secondary: RakubaColors.acaciaGreen,
    onSecondary: RakubaColors.white,
    secondaryContainer: RakubaColors.paper,
    onSecondaryContainer: RakubaColors.ink,
    secondaryFixed: RakubaColors.paper,
    secondaryFixedDim: RakubaColors.rule,
    onSecondaryFixed: RakubaColors.ink,
    onSecondaryFixedVariant: RakubaColors.ink,
    tertiary: RakubaColors.clay,
    onTertiary: RakubaColors.white,
    tertiaryContainer: RakubaColors.warningTint,
    onTertiaryContainer: RakubaColors.ink,
    tertiaryFixed: RakubaColors.warningTint,
    tertiaryFixedDim: RakubaColors.rule,
    onTertiaryFixed: RakubaColors.ink,
    onTertiaryFixedVariant: RakubaColors.ink,
    error: RakubaColors.clay,
    onError: RakubaColors.white,
    errorContainer: RakubaColors.warningTint,
    onErrorContainer: RakubaColors.ink,
    surface: RakubaColors.paper,
    onSurface: RakubaColors.ink,
    surfaceDim: RakubaColors.paper,
    surfaceBright: RakubaColors.card,
    surfaceContainerLowest: RakubaColors.card,
    surfaceContainerLow: RakubaColors.card,
    surfaceContainer: RakubaColors.card,
    surfaceContainerHigh: RakubaColors.card,
    surfaceContainerHighest: RakubaColors.paper,
    onSurfaceVariant: RakubaColors.inkMuted,
    outline: RakubaColors.border,
    outlineVariant: RakubaColors.rule,
    shadow: RakubaColors.transparent,
    scrim: RakubaColors.pressedLayer,
    inverseSurface: RakubaColors.ink,
    onInverseSurface: RakubaColors.paper,
    inversePrimary: RakubaColors.lightThatch,
    surfaceTint: RakubaColors.transparent,
  );

  TextStyle t(double size, {bool bold = false, Color colour = RakubaColors.ink}) => TextStyle(
        fontSize: size,
        height: RakubaType.lineHeightFor(size),
        fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
        fontFamily: family,
        fontFamilyFallback: fallback,
        color: colour,
        letterSpacing: 0,
      );

  final textTheme = TextTheme(
    displayLarge: t(RakubaType.display, bold: true),
    displayMedium: t(RakubaType.display, bold: true),
    displaySmall: t(RakubaType.title, bold: true),
    headlineLarge: t(RakubaType.title, bold: true),
    headlineMedium: t(RakubaType.name, bold: true),
    headlineSmall: t(RakubaType.heading, bold: true),
    titleLarge: t(RakubaType.heading, bold: true),
    titleMedium: t(RakubaType.body, bold: true),
    titleSmall: t(RakubaType.label, bold: true),
    bodyLarge: t(RakubaType.body),
    bodyMedium: t(RakubaType.body),
    bodySmall: t(RakubaType.label, colour: RakubaColors.inkMuted),
    labelLarge: t(RakubaType.body, bold: true),
    labelMedium: t(RakubaType.label, bold: true),
    labelSmall: t(RakubaType.label),
  );

  final btnText = t(RakubaType.bodyLarge, bold: true);
  const minSize = Size(RakubaSizes.minTouch, RakubaSizes.minTouch);
  const pad = EdgeInsets.symmetric(horizontal: RakubaSpace.m, vertical: RakubaSpace.s);

  OutlineInputBorder inputBorder(Color c, double w) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(RakubaRadius.input), borderSide: BorderSide(color: c, width: w));

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: RakubaColors.paper,
    canvasColor: RakubaColors.paper,
    fontFamily: family,
    fontFamilyFallback: fallback,
    textTheme: textTheme,
    // No ripple spreading across the screen; states are flat layers.
    splashFactory: NoSplash.splashFactory,
    splashColor: RakubaColors.transparent,
    hoverColor: RakubaColors.hoverLayer,
    focusColor: RakubaColors.focusLayer,
    highlightColor: RakubaColors.pressedLayer,
    dividerColor: RakubaColors.rule,
    disabledColor: RakubaColors.disabled,
    shadowColor: RakubaColors.transparent,
    visualDensity: VisualDensity.standard,
    materialTapTargetSize: MaterialTapTargetSize.padded,
    iconTheme: const IconThemeData(color: RakubaColors.ink, size: 24),
    dividerTheme: const DividerThemeData(color: RakubaColors.rule, thickness: RakubaLine.hairline, space: RakubaSpace.m),
    textSelectionTheme: const TextSelectionThemeData(
        cursorColor: RakubaColors.nileBlue,
        selectionColor: RakubaColors.lightThatch,
        selectionHandleColor: RakubaColors.nileBlue),
    filledButtonTheme: FilledButtonThemeData(
      style: ButtonStyle(
        minimumSize: const WidgetStatePropertyAll(minSize),
        padding: const WidgetStatePropertyAll(pad),
        shape: WidgetStatePropertyAll(_controlShape),
        textStyle: WidgetStatePropertyAll(btnText),
        elevation: const WidgetStatePropertyAll(0),
        backgroundColor: WidgetStateProperty.resolveWith(
            (s) => s.contains(WidgetState.disabled) ? RakubaColors.disabled : RakubaColors.nileBlue),
        foregroundColor: const WidgetStatePropertyAll(RakubaColors.white),
        overlayColor: _layers(onDark: true),
        side: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.focused) ? _focusRing : null),
        mouseCursor: WidgetStateProperty.resolveWith(
            (s) => s.contains(WidgetState.disabled) ? SystemMouseCursors.basic : SystemMouseCursors.click),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        minimumSize: const WidgetStatePropertyAll(minSize),
        padding: const WidgetStatePropertyAll(pad),
        shape: WidgetStatePropertyAll(_controlShape),
        textStyle: WidgetStatePropertyAll(btnText),
        elevation: const WidgetStatePropertyAll(0),
        backgroundColor: const WidgetStatePropertyAll(RakubaColors.card),
        foregroundColor: WidgetStateProperty.resolveWith(
            (s) => s.contains(WidgetState.disabled) ? RakubaColors.disabled : RakubaColors.nileBlue),
        overlayColor: _layers(),
        side: WidgetStateProperty.resolveWith((s) {
          if (s.contains(WidgetState.focused)) return _focusRing;
          return BorderSide(color: s.contains(WidgetState.disabled) ? RakubaColors.rule : RakubaColors.border);
        }),
        mouseCursor: WidgetStateProperty.resolveWith(
            (s) => s.contains(WidgetState.disabled) ? SystemMouseCursors.basic : SystemMouseCursors.click),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        minimumSize: const WidgetStatePropertyAll(Size(RakubaSpace.xl, RakubaSpace.xl)),
        padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: RakubaSpace.s)),
        shape: WidgetStatePropertyAll(_controlShape),
        textStyle: WidgetStateProperty.resolveWith((s) => t(RakubaType.body, bold: true).copyWith(
            decoration: s.contains(WidgetState.hovered) ? TextDecoration.underline : TextDecoration.none)),
        foregroundColor: WidgetStateProperty.resolveWith(
            (s) => s.contains(WidgetState.disabled) ? RakubaColors.disabled : RakubaColors.nileBlue),
        overlayColor: _layers(),
        side: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.focused) ? _focusRing : null),
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        minimumSize: const WidgetStatePropertyAll(Size(RakubaSpace.xl, RakubaSpace.xl)),
        overlayColor: _layers(),
        side: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.focused) ? _focusRing : null),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: RakubaColors.card,
      hoverColor: RakubaColors.card,
      contentPadding: const EdgeInsets.all(RakubaSpace.s),
      hintStyle: t(RakubaType.body, colour: RakubaColors.inkMuted),
      helperStyle: t(RakubaType.label, colour: RakubaColors.inkMuted),
      errorStyle: t(RakubaType.label, bold: true, colour: RakubaColors.clay),
      errorMaxLines: 3,
      helperMaxLines: 3,
      border: inputBorder(RakubaColors.border, RakubaLine.hairline),
      enabledBorder: inputBorder(RakubaColors.border, RakubaLine.hairline),
      disabledBorder: inputBorder(RakubaColors.rule, RakubaLine.hairline),
      focusedBorder: inputBorder(RakubaColors.nileBlue, RakubaLine.strong),
      errorBorder: inputBorder(RakubaColors.clay, RakubaLine.strong),
      focusedErrorBorder: inputBorder(RakubaColors.clay, RakubaLine.strong),
    ),
    checkboxTheme: CheckboxThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(RakubaRadius.tick)),
      side: WidgetStateBorderSide.resolveWith((s) => BorderSide(
          color: s.contains(WidgetState.disabled) ? RakubaColors.rule : RakubaColors.border,
          width: RakubaLine.strong)),
      fillColor: WidgetStateProperty.resolveWith((s) {
        if (!s.contains(WidgetState.selected)) return RakubaColors.card;
        return s.contains(WidgetState.disabled) ? RakubaColors.disabled : RakubaColors.nileBlue;
      }),
      checkColor: const WidgetStatePropertyAll(RakubaColors.white),
      overlayColor: _layers(),
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((s) {
        if (s.contains(WidgetState.disabled)) return RakubaColors.disabled;
        return s.contains(WidgetState.selected) ? RakubaColors.nileBlue : RakubaColors.border;
      }),
      overlayColor: _layers(),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? RakubaColors.white : RakubaColors.border),
      trackColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? RakubaColors.nileBlue : RakubaColors.card),
      trackOutlineColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? RakubaColors.nileBlue : RakubaColors.border),
    ),
    cardTheme: CardThemeData(
      color: RakubaColors.card,
      surfaceTintColor: RakubaColors.transparent,
      shadowColor: RakubaColors.transparent,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(RakubaRadius.panel),
        side: const BorderSide(color: RakubaColors.rule),
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: RakubaColors.card,
      surfaceTintColor: RakubaColors.transparent,
      shadowColor: RakubaColors.transparent,
      elevation: 0,
      barrierColor: RakubaColors.pressedLayer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(RakubaRadius.panel),
        side: const BorderSide(color: RakubaColors.border),
      ),
      titleTextStyle: t(RakubaType.heading, bold: true),
      contentTextStyle: t(RakubaType.body),
      insetPadding: const EdgeInsets.all(RakubaSpace.m),
      actionsPadding: const EdgeInsets.fromLTRB(RakubaSpace.l, 0, RakubaSpace.l, RakubaSpace.l),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: RakubaColors.ink,
      contentTextStyle: t(RakubaType.body, colour: RakubaColors.paper),
      actionTextColor: RakubaColors.lightThatch,
      behavior: SnackBarBehavior.fixed,
      elevation: 0,
      shape: const RoundedRectangleBorder(),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: RakubaColors.nileBlue,
      linearTrackColor: RakubaColors.rule,
      circularTrackColor: RakubaColors.rule,
      linearMinHeight: 2,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: RakubaColors.ink,
      foregroundColor: RakubaColors.white,
      surfaceTintColor: RakubaColors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleTextStyle: t(RakubaType.heading, bold: true, colour: RakubaColors.white),
    ),
    popupMenuTheme: PopupMenuThemeData(
      color: RakubaColors.card,
      surfaceTintColor: RakubaColors.transparent,
      elevation: 0,
      textStyle: t(RakubaType.body),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(RakubaRadius.input),
        side: const BorderSide(color: RakubaColors.border),
      ),
    ),
    dropdownMenuTheme: DropdownMenuThemeData(
      textStyle: t(RakubaType.body),
      menuStyle: MenuStyle(
        backgroundColor: const WidgetStatePropertyAll(RakubaColors.card),
        surfaceTintColor: const WidgetStatePropertyAll(RakubaColors.transparent),
        elevation: const WidgetStatePropertyAll(0),
        side: const WidgetStatePropertyAll(BorderSide(color: RakubaColors.border)),
        shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(RakubaRadius.input))),
      ),
    ),
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(color: RakubaColors.ink, borderRadius: BorderRadius.circular(RakubaRadius.input)),
      textStyle: t(RakubaType.label, colour: RakubaColors.paper),
    ),
    listTileTheme: ListTileThemeData(
      titleTextStyle: t(RakubaType.body, bold: true),
      subtitleTextStyle: t(RakubaType.label, colour: RakubaColors.inkMuted),
      iconColor: RakubaColors.ink,
      selectedColor: RakubaColors.nileBlue,
      contentPadding: const EdgeInsets.symmetric(horizontal: RakubaSpace.s),
    ),
    scrollbarTheme: const ScrollbarThemeData(thumbColor: WidgetStatePropertyAll(RakubaColors.border)),
  );
}

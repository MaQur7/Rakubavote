import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;

/// The brand fonts embedded in every PDF (stations are offline), with the
/// same fallbacks as the app: Noto Sans for letters Atkinson lacks and
/// Noto Sans Arabic for Arabic names.
class PdfFonts {
  PdfFonts._(this.regular, this.bold, this.latinExtended, this.arabic);

  final pw.Font regular;
  final pw.Font bold;
  final pw.Font latinExtended;
  final pw.Font arabic;

  static PdfFonts? _cached;

  static Future<PdfFonts> load([AssetBundle? bundle]) async {
    if (_cached != null) return _cached!;
    final b = bundle ?? rootBundle;
    Future<pw.Font> f(String name) async => pw.Font.ttf(await b.load('assets/fonts/$name'));
    return _cached = PdfFonts._(
      await f('AtkinsonHyperlegible-Regular.ttf'),
      await f('AtkinsonHyperlegible-Bold.ttf'),
      await f('NotoSans.ttf'),
      await f('NotoSansArabic.ttf'),
    );
  }

  List<pw.Font> get fallback => [latinExtended, arabic];

  pw.ThemeData theme() => pw.ThemeData.withFont(base: regular, bold: bold, fontFallback: fallback);
}

/// True if [text] contains Arabic letters (printed right to left).
bool hasArabic(String text) => RegExp(r'[؀-ۿݐ-ݿ]').hasMatch(text);

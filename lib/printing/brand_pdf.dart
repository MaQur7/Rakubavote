import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

// The Rakubavote mark and the brand elements derived from it, for print
// (D26, D27; docs/design-system.md section 11). The same numbers as
// lib/core/brand/brand.dart and brand/: a 120 unit square, unit 4.
// Sizes here are printer points, not screen pixels.

const pdfInk = PdfColor.fromInt(0xFF1B1B1B);
const pdfNile = PdfColor.fromInt(0xFF1D4E89);
const pdfThatch = PdfColor.fromInt(0xFFC8963E);
const pdfLightThatch = PdfColor.fromInt(0xFFE6C27A);
const pdfPaper = PdfColor.fromInt(0xFFF4F1EA);
const pdfClay = PdfColor.fromInt(0xFFA9521A);
const pdfAcacia = PdfColor.fromInt(0xFF1F5E3A);
const pdfMuted = PdfColor.fromInt(0xFF57524A);
const pdfRule = PdfColor.fromInt(0xFFDDD6C6);

enum PdfMarkScheme { colour, onDark, oneColour }

({PdfColor roof, PdfColor post, PdfColor tick}) _scheme(PdfMarkScheme s) => switch (s) {
      PdfMarkScheme.colour => (roof: pdfThatch, post: pdfInk, tick: pdfNile),
      PdfMarkScheme.onDark => (roof: pdfLightThatch, post: pdfPaper, tick: pdfPaper),
      PdfMarkScheme.oneColour => (roof: pdfInk, post: pdfInk, tick: pdfInk),
    };

/// The mark: roof 104 x 16 (corner 4), posts 12 x 64, tick at 45 degrees.
pw.Widget pdfMark(double size, {PdfMarkScheme scheme = PdfMarkScheme.colour}) => pw.CustomPaint(
      size: PdfPoint(size, size),
      painter: (canvas, s) {
        final c = _scheme(scheme);
        final k = s.x / 120;
        // PDF y runs upward.
        double y(double v) => (120 - v) * k;
        canvas
          ..setFillColor(c.roof)
          ..drawRRect(8 * k, y(36), 104 * k, 16 * k, 4 * k, 4 * k)
          ..fillPath()
          ..setFillColor(c.post)
          ..drawRect(20 * k, y(100), 12 * k, 64 * k)
          ..drawRect(88 * k, y(100), 12 * k, 64 * k)
          ..fillPath()
          ..setStrokeColor(c.tick)
          ..setLineWidth(12 * k)
          ..setLineCap(PdfLineCap.round)
          ..setLineJoin(PdfLineJoin.round)
          ..moveTo(42 * k, y(72))
          ..lineTo(54 * k, y(84))
          ..lineTo(78 * k, y(60))
          ..strokePath();
      },
    );

/// The mark with the name; [size] is the height of the letters.
pw.Widget pdfLogo(double size, {bool onDark = false}) => pw.Row(mainAxisSize: pw.MainAxisSize.min, children: [
      pdfMark(size * 1.6, scheme: onDark ? PdfMarkScheme.onDark : PdfMarkScheme.colour),
      pw.SizedBox(width: size * 0.3),
      pw.RichText(
        textDirection: pw.TextDirection.ltr,
        text: pw.TextSpan(
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: size, color: onDark ? pdfPaper : pdfInk),
          children: [
            const pw.TextSpan(text: 'Rakuba'),
            pw.TextSpan(text: 'vote', style: pw.TextStyle(color: onDark ? pdfLightThatch : pdfNile)),
          ],
        ),
      ),
    ]);

/// The tick alone (icon "Vote" on the 120 square).
pw.Widget pdfTick(double size, PdfColor colour) => pw.CustomPaint(
      size: PdfPoint(size, size),
      painter: (canvas, s) {
        final k = s.x / 120;
        double y(double v) => (120 - v) * k;
        canvas
          ..setStrokeColor(colour)
          ..setLineWidth(12 * k)
          ..setLineCap(PdfLineCap.round)
          ..setLineJoin(PdfLineJoin.round)
          ..moveTo(28 * k, y(62))
          ..lineTo(50 * k, y(84))
          ..lineTo(92 * k, y(42))
          ..strokePath();
      },
    );

/// Roof line: a bar with corners a quarter of its height.
pw.Widget pdfRoofLine({double? width, double height = 4, PdfColor colour = pdfThatch}) => pw.Container(
      width: width,
      height: height,
      decoration: pw.BoxDecoration(color: colour, borderRadius: pw.BorderRadius.circular(height / 4)),
    );

/// Tick end: a rule that ends in the tick. Closes something finished.
pw.Widget pdfTickEnd({PdfColor colour = pdfAcacia, double size = 14}) => pw.Row(children: [
      pw.Expanded(child: pw.Container(height: 1, color: pdfInk)),
      pw.SizedBox(width: size / 4),
      pdfTick(size, colour),
    ]);

/// Thatch hatch: fine lines at the tick angle, for empty image areas.
pw.Widget pdfHatch(double width, double height, {PdfColor colour = pdfThatch, PdfColor background = PdfColors.white, double step = 3}) =>
    pw.CustomPaint(
      size: PdfPoint(width, height),
      painter: (canvas, s) {
        canvas
          ..setFillColor(background)
          ..drawRect(0, 0, s.x, s.y)
          ..fillPath()
          ..saveContext()
          ..drawRect(0, 0, s.x, s.y)
          ..clipPath()
          ..setStrokeColor(colour)
          ..setLineWidth(0.5);
        // 45 degrees: each line runs from the bottom edge up to the right.
        for (var x = -s.y; x < s.x; x += step * 1.4142) {
          canvas
            ..moveTo(x, 0)
            ..lineTo(x + s.y, s.y);
        }
        canvas
          ..strokePath()
          ..restoreContext();
      },
    );

/// An image for the PDF, or null if the bytes are not a readable image
/// (a damaged photo prints as the hatch instead of failing the batch).
pw.ImageProvider? pdfImage(Uint8List? bytes) {
  if (bytes == null) return null;
  try {
    return pw.MemoryImage(bytes);
  } catch (_) {
    return null;
  }
}

pw.Widget _window(Uint8List? bytes, double w, double h) {
  final image = pdfImage(bytes);
  return pw.SizedBox(
    width: w,
    height: h,
    child: image == null ? pdfHatch(w, h, background: pdfPaper) : pw.Image(image, fit: pw.BoxFit.cover),
  );
}

/// Shelter frame: the photo in the bay (7 : 8) under the roof, between the
/// posts. [width] is the roof width; use it from about 40 mm wide.
pw.Widget pdfShelterFrame(double width, Uint8List? bytes) {
  final k = width / 104;
  return pw.SizedBox(
    width: width,
    child: pw.Column(mainAxisSize: pw.MainAxisSize.min, children: [
      pdfRoofLine(width: width, height: 16 * k),
      pw.Row(mainAxisAlignment: pw.MainAxisAlignment.center, children: [
        pw.Container(width: 12 * k, height: 64 * k, color: pdfInk),
        _window(bytes, 56 * k, 64 * k),
        pw.Container(width: 12 * k, height: 64 * k, color: pdfInk),
      ]),
    ]),
  );
}

/// Band over a photo: a roof bar directly on a 7 : 8 window. For print too
/// small for the shelter frame (ID cards).
pw.Widget pdfPhotoBand(double width, Uint8List? bytes) => pw.Column(mainAxisSize: pw.MainAxisSize.min, children: [
      pdfRoofLine(width: width, height: width / 8),
      _window(bytes, width, width * 8 / 7),
    ]);

/// Colonnade: posts repeating every bay under one long roof. Closes a sheet.
pw.Widget pdfColonnade({double height = 12}) => pw.CustomPaint(
      size: PdfPoint(double.infinity, height),
      painter: (canvas, s) {
        // Quarter-size mark: roof 4 high, posts 3 wide, one every 17.
        canvas
          ..setFillColor(pdfThatch)
          ..drawRRect(0, s.y - 4, s.x, 4, 1, 1)
          ..fillPath()
          ..setFillColor(pdfInk);
        for (var x = 3.0; x < s.x - 3; x += 17) {
          canvas.drawRect(x, 0, 3, s.y - 4);
        }
        canvas.fillPath();
      },
    );

/// The place for a rubber stamp: an empty area in the hatch, with its label.
pw.Widget pdfSealBox(String text, double width, double height, double fontSize) => pw.Stack(
      alignment: pw.Alignment.center,
      children: [
        pdfHatch(width, height, colour: pdfClay, background: PdfColors.white, step: 2.4),
        pw.Container(
          color: PdfColors.white,
          padding: const pw.EdgeInsets.symmetric(horizontal: 2, vertical: 1),
          child: pw.Text(text, style: pw.TextStyle(color: pdfClay, fontSize: fontSize, fontWeight: pw.FontWeight.bold)),
        ),
      ],
    );

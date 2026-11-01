import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'pdf_fonts.dart';

/// Card sizes from the brief: ID card (85.6 × 54 mm) or A6.
enum CardLayout {
  /// ID cards on A4 paper, 10 per sheet with cut marks (any office printer).
  idCardsOnA4,
  /// One ID card per page (card printers).
  idCardSingle,
  /// One A6 card per page.
  a6,
}

/// Printed text on the card, in the official's language.
class CardLabels {
  const CardLabels({
    required this.cardTitle,
    required this.fullName,
    required this.voterNo,
    required this.fee,
    required this.registeredLine,
    required this.qrNote,
    required this.officialSignature,
    required this.officialSeal,
  });

  final String cardTitle;
  final String fullName;
  final String voterNo;
  final String fee;
  /// Already filled in, e.g. "Registered 2026-11-01 at Station 1. Not transferable."
  final String Function(String date, String station) registeredLine;
  final String qrNote;
  final String officialSignature;
  final String officialSeal;
}

/// Everything printed on one card. The QR text holds only the voter number
/// and the laptop's signature (VoterCardCode).
class VoterCardData {
  const VoterCardData({
    required this.orgName,
    required this.electionName,
    required this.year,
    required this.stationName,
    required this.voterNoLabel,
    required this.fullName,
    required this.idLabel,
    required this.memberId,
    required this.groupLabel,
    required this.groupName,
    required this.feeText,
    required this.registeredOn,
    required this.qrText,
    this.orgLogo,
    this.photo,
  });

  final String orgName;
  final String electionName;
  final int year;
  final String stationName;
  final String voterNoLabel;
  final String fullName;
  final String idLabel;
  final String memberId;
  final String groupLabel;
  final String groupName;
  /// Empty when the election has no fee.
  final String feeText;
  final String registeredOn;
  final String qrText;
  final Uint8List? orgLogo;
  final Uint8List? photo;
}

// Brand colours (lib/core/theme.dart), as PDF colours.
const _ink = PdfColor.fromInt(0xFF1B1B1B);
const _lightThatch = PdfColor.fromInt(0xFFE6C27A);
const _thatchGold = PdfColor.fromInt(0xFFC8963E);
const _clay = PdfColor.fromInt(0xFFA9521A);
const _cardPaper = PdfColor.fromInt(0xFFFBF9F4);
const _placeholder = PdfColor.fromInt(0xFFDDD6C6);
const _muted = PdfColor.fromInt(0xFF4A4740);

const _idWidth = 85.6 * PdfPageFormat.mm;
const _idHeight = 54 * PdfPageFormat.mm;

Future<Uint8List> buildVoterCardsPdf(
  List<VoterCardData> cards, {
  required CardLabels labels,
  CardLayout layout = CardLayout.idCardsOnA4,
  bool compress = true,
}) async {
  final fonts = await PdfFonts.load();
  final doc = pw.Document(theme: fonts.theme(), compress: compress, title: labels.cardTitle, creator: 'Rakubavote');
  switch (layout) {
    case CardLayout.idCardSingle:
      for (final c in cards) {
        doc.addPage(pw.Page(
          pageFormat: const PdfPageFormat(_idWidth, _idHeight),
          build: (_) => _idCard(c, labels),
        ));
      }
    case CardLayout.a6:
      for (final c in cards) {
        doc.addPage(pw.Page(
          pageFormat: PdfPageFormat.a6.copyWith(
              marginLeft: 6 * PdfPageFormat.mm,
              marginRight: 6 * PdfPageFormat.mm,
              marginTop: 6 * PdfPageFormat.mm,
              marginBottom: 6 * PdfPageFormat.mm),
          build: (_) => _a6Card(c, labels),
        ));
      }
    case CardLayout.idCardsOnA4:
      for (var i = 0; i < cards.length; i += 10) {
        final page = cards.sublist(i, i + 10 > cards.length ? cards.length : i + 10);
        doc.addPage(pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(12 * PdfPageFormat.mm),
          build: (_) => pw.Wrap(
            spacing: 6 * PdfPageFormat.mm,
            runSpacing: 4 * PdfPageFormat.mm,
            children: [
              for (final c in page)
                pw.Container(
                  decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey400, width: 0.3)),
                  child: _idCard(c, labels),
                ),
            ],
          ),
        ));
      }
  }
  return doc.save();
}

/// An image for the PDF, or null if the bytes are not a readable image
/// (a damaged photo prints as the grey placeholder instead of failing).
pw.ImageProvider? _image(Uint8List? bytes) {
  if (bytes == null) return null;
  try {
    return pw.MemoryImage(bytes);
  } catch (_) {
    return null;
  }
}

pw.TextDirection _dir(String s) => hasArabic(s) ? pw.TextDirection.rtl : pw.TextDirection.ltr;

pw.Widget _logo(Uint8List? bytes, double size) => pw.Container(
      width: size,
      height: size,
      decoration: pw.BoxDecoration(shape: pw.BoxShape.circle, border: pw.Border.all(color: _lightThatch, width: 1)),
      child: _image(bytes) == null ? null : pw.ClipOval(child: pw.Image(_image(bytes)!, fit: pw.BoxFit.cover)),
    );

pw.Widget _wordmark(double size) => pw.RichText(
      text: pw.TextSpan(
        style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: size, color: PdfColors.white),
        children: [
          const pw.TextSpan(text: 'Rakuba'),
          pw.TextSpan(text: 'vote', style: const pw.TextStyle(color: _lightThatch)),
        ],
      ),
    );

pw.Widget _photo(Uint8List? bytes, double w, double h) => pw.Container(
      width: w,
      height: h,
      decoration: pw.BoxDecoration(color: _placeholder, borderRadius: pw.BorderRadius.circular(3)),
      child: _image(bytes) == null
          ? null
          : pw.ClipRRect(horizontalRadius: 3, verticalRadius: 3, child: pw.Image(_image(bytes)!, fit: pw.BoxFit.cover)),
    );

pw.Widget _field(String label, String value, {double labelSize = 5, double valueSize = 8}) => pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(label, style: pw.TextStyle(fontSize: labelSize, color: _muted)),
        pw.Text(value.isEmpty ? '—' : value,
            textDirection: _dir(value), style: pw.TextStyle(fontSize: valueSize, fontWeight: pw.FontWeight.bold)),
      ],
    );

pw.Widget _seal(String text, double size) => pw.Container(
      width: size * 1.6,
      height: size,
      alignment: pw.Alignment.center,
      decoration: pw.BoxDecoration(
        borderRadius: pw.BorderRadius.circular(size),
        border: pw.Border.all(color: _clay, width: 0.8, style: pw.BorderStyle.dotted),
      ),
      child: pw.Text(text, style: pw.TextStyle(color: _clay, fontSize: size * 0.22, fontWeight: pw.FontWeight.bold)),
    );

/// Mockup E at ID-1 size.
pw.Widget _idCard(VoterCardData c, CardLabels l) => pw.Container(
      width: _idWidth,
      height: _idHeight,
      decoration: pw.BoxDecoration(color: _cardPaper, borderRadius: pw.BorderRadius.circular(6)),
      child: pw.Column(children: [
        pw.Container(
          height: 12 * PdfPageFormat.mm,
          padding: const pw.EdgeInsets.symmetric(horizontal: 6),
          decoration: const pw.BoxDecoration(
            color: _ink,
            borderRadius: pw.BorderRadius.only(topLeft: pw.Radius.circular(6), topRight: pw.Radius.circular(6)),
          ),
          child: pw.Row(children: [
            _logo(c.orgLogo, 8 * PdfPageFormat.mm),
            pw.SizedBox(width: 5),
            pw.Expanded(
              child: pw.Column(mainAxisAlignment: pw.MainAxisAlignment.center, crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                // Long organization names shrink to fit instead of being cut.
                pw.FittedBox(
                  fit: pw.BoxFit.scaleDown,
                  alignment: pw.Alignment.centerLeft,
                  child: pw.Text(c.orgName,
                      textDirection: _dir(c.orgName),
                      style: pw.TextStyle(color: PdfColors.white, fontSize: 7.5, fontWeight: pw.FontWeight.bold)),
                ),
                pw.Text('${l.cardTitle} · ${c.electionName}, ${c.year}',
                    maxLines: 1, style: const pw.TextStyle(color: _lightThatch, fontSize: 5)),
              ]),
            ),
            _wordmark(6),
          ]),
        ),
        pw.Expanded(
          child: pw.Padding(
            padding: const pw.EdgeInsets.fromLTRB(5, 4, 5, 2),
            child: pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
              _photo(c.photo, 17 * PdfPageFormat.mm, 21 * PdfPageFormat.mm),
              pw.SizedBox(width: 5),
              pw.Expanded(
                child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                  _field(l.fullName, c.fullName, valueSize: 8.5),
                  pw.SizedBox(height: 2),
                  pw.Row(children: [
                    pw.Expanded(child: _field(l.voterNo, c.voterNoLabel, valueSize: 9)),
                    pw.Expanded(child: _field(c.idLabel, c.memberId)),
                  ]),
                  pw.SizedBox(height: 2),
                  pw.Row(children: [
                    pw.Expanded(child: _field(c.groupLabel, c.groupName)),
                    if (c.feeText.isNotEmpty) pw.Expanded(child: _field(l.fee, c.feeText)),
                  ]),
                  pw.SizedBox(height: 2),
                  pw.Text(l.registeredLine(c.registeredOn, c.stationName), style: const pw.TextStyle(fontSize: 4.5)),
                ]),
              ),
              pw.SizedBox(width: 4),
              pw.Column(children: [
                pw.BarcodeWidget(
                    barcode: pw.Barcode.qrCode(), data: c.qrText, width: 19 * PdfPageFormat.mm, height: 19 * PdfPageFormat.mm),
                pw.SizedBox(height: 1),
                pw.SizedBox(
                  width: 20 * PdfPageFormat.mm,
                  child: pw.Text(l.qrNote, textAlign: pw.TextAlign.center, style: const pw.TextStyle(fontSize: 3.6)),
                ),
              ]),
            ]),
          ),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.fromLTRB(5, 0, 5, 3),
          child: pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.end, children: [
            pw.Expanded(
              child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                pw.Container(height: 0.6, color: _ink),
                pw.SizedBox(height: 1),
                pw.Text(l.officialSignature, style: const pw.TextStyle(fontSize: 4)),
              ]),
            ),
            pw.SizedBox(width: 6),
            _seal(l.officialSeal, 7 * PdfPageFormat.mm),
          ]),
        ),
      ]),
    );

/// The same card laid out on A6 (portrait), larger for low vision.
pw.Widget _a6Card(VoterCardData c, CardLabels l) => pw.Container(
      decoration: pw.BoxDecoration(
          color: _cardPaper, borderRadius: pw.BorderRadius.circular(8), border: pw.Border.all(color: _thatchGold, width: 0.5)),
      child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.stretch, children: [
        pw.Container(
          padding: const pw.EdgeInsets.all(8),
          decoration: const pw.BoxDecoration(
              color: _ink, borderRadius: pw.BorderRadius.only(topLeft: pw.Radius.circular(8), topRight: pw.Radius.circular(8))),
          child: pw.Row(children: [
            _logo(c.orgLogo, 14 * PdfPageFormat.mm),
            pw.SizedBox(width: 8),
            pw.Expanded(
              child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                pw.Text(c.orgName,
                    textDirection: _dir(c.orgName),
                    style: pw.TextStyle(color: PdfColors.white, fontSize: 11, fontWeight: pw.FontWeight.bold)),
                pw.Text('${l.cardTitle} · ${c.electionName}, ${c.year}', style: const pw.TextStyle(color: _lightThatch, fontSize: 7)),
              ]),
            ),
            _wordmark(8),
          ]),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(10),
          child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
            pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
              _photo(c.photo, 30 * PdfPageFormat.mm, 38 * PdfPageFormat.mm),
              pw.Spacer(),
              pw.Column(children: [
                pw.BarcodeWidget(
                    barcode: pw.Barcode.qrCode(), data: c.qrText, width: 34 * PdfPageFormat.mm, height: 34 * PdfPageFormat.mm),
                pw.SizedBox(
                    width: 36 * PdfPageFormat.mm,
                    child: pw.Text(l.qrNote, textAlign: pw.TextAlign.center, style: const pw.TextStyle(fontSize: 6))),
              ]),
            ]),
            pw.SizedBox(height: 8),
            _field(l.fullName, c.fullName, labelSize: 7, valueSize: 14),
            pw.SizedBox(height: 6),
            pw.Row(children: [
              pw.Expanded(child: _field(l.voterNo, c.voterNoLabel, labelSize: 7, valueSize: 14)),
              pw.Expanded(child: _field(c.idLabel, c.memberId, labelSize: 7, valueSize: 11)),
            ]),
            pw.SizedBox(height: 6),
            pw.Row(children: [
              pw.Expanded(child: _field(c.groupLabel, c.groupName, labelSize: 7, valueSize: 11)),
              if (c.feeText.isNotEmpty) pw.Expanded(child: _field(l.fee, c.feeText, labelSize: 7, valueSize: 11)),
            ]),
            pw.SizedBox(height: 6),
            pw.Text(l.registeredLine(c.registeredOn, c.stationName), style: const pw.TextStyle(fontSize: 7)),
          ]),
        ),
        pw.Spacer(),
        pw.Padding(
          padding: const pw.EdgeInsets.fromLTRB(10, 0, 10, 10),
          child: pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.end, children: [
            pw.Expanded(
              child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                pw.Container(height: 0.8, color: _ink),
                pw.SizedBox(height: 2),
                pw.Text(l.officialSignature, style: const pw.TextStyle(fontSize: 7)),
              ]),
            ),
            pw.SizedBox(width: 10),
            _seal(l.officialSeal, 14 * PdfPageFormat.mm),
          ]),
        ),
      ]),
    );

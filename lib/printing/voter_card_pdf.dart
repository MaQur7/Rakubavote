import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'brand_pdf.dart';
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

// Card stock: slightly warmer than white so the Ink strip and hatch read in print.
const _cardPaper = PdfColor.fromInt(0xFFFBF9F4);

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
                  // Cut line.
                  decoration: pw.BoxDecoration(border: pw.Border.all(color: pdfRule, width: 0.4)),
                  child: _idCard(c, labels),
                ),
            ],
          ),
        ));
      }
  }
  return doc.save();
}

pw.TextDirection _dir(String s) => hasArabic(s) ? pw.TextDirection.rtl : pw.TextDirection.ltr;

/// The organisation's logo, only when it has one (never an empty holder).
pw.Widget? _orgLogo(Uint8List? bytes, double size) {
  final image = pdfImage(bytes);
  if (image == null) return null;
  return pw.ClipRRect(
    horizontalRadius: size / 8,
    verticalRadius: size / 8,
    child: pw.Image(image, width: size, height: size, fit: pw.BoxFit.cover),
  );
}

pw.Widget _field(String label, String value, {double labelSize = 5, double valueSize = 8}) => pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(label, style: pw.TextStyle(fontSize: labelSize, color: pdfMuted)),
        // Long values shrink to fit instead of running into the next column.
        pw.FittedBox(
          fit: pw.BoxFit.scaleDown,
          alignment: pw.Alignment.centerLeft,
          child: pw.Text(value.isEmpty ? '—' : value,
              textDirection: _dir(value), style: pw.TextStyle(fontSize: valueSize, fontWeight: pw.FontWeight.bold)),
        ),
      ],
    );

/// The Ink strip is the roof of the card: organisation first, Rakubavote small.
pw.Widget _strip(VoterCardData c, CardLabels l,
    {required double height, required double pad, required double logo, required double name, required double sub, required double mark}) {
  final org = _orgLogo(c.orgLogo, logo);
  return pw.Container(
    height: height,
    padding: pw.EdgeInsets.symmetric(horizontal: pad),
    color: pdfInk,
    child: pw.Row(children: [
      if (org != null) ...[org, pw.SizedBox(width: pad)],
      pw.Expanded(
        child: pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.FittedBox(
                fit: pw.BoxFit.scaleDown,
                alignment: pw.Alignment.centerLeft,
                child: pw.Text(c.orgName,
                    textDirection: _dir(c.orgName),
                    style: pw.TextStyle(color: PdfColors.white, fontSize: name, fontWeight: pw.FontWeight.bold)),
              ),
              // Shrinks to fit, so the year is never cut off.
              pw.FittedBox(
                fit: pw.BoxFit.scaleDown,
                alignment: pw.Alignment.centerLeft,
                child: pw.Text('${l.cardTitle} · ${c.electionName}, ${c.year}',
                    style: pw.TextStyle(color: pdfLightThatch, fontSize: sub)),
              ),
            ]),
      ),
      pw.SizedBox(width: pad),
      pdfLogo(mark, onDark: true),
    ]),
  );
}

pw.Widget _signAndSeal(CardLabels l, {required double text, required double sealW, required double sealH, required double gap}) =>
    pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.end, children: [
      pw.Expanded(
        child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
          pw.Container(height: 0.7, color: pdfInk),
          pw.SizedBox(height: 1),
          pw.Text(l.officialSignature, style: pw.TextStyle(fontSize: text, color: pdfMuted)),
        ]),
      ),
      pw.SizedBox(width: gap),
      pdfSealBox(l.officialSeal, sealW, sealH, text),
    ]);

pw.Widget _qr(VoterCardData c, CardLabels l, double size, double note) => pw.Column(children: [
      pw.BarcodeWidget(barcode: pw.Barcode.qrCode(), data: c.qrText, width: size, height: size),
      pw.SizedBox(height: 1),
      pw.SizedBox(
        width: size,
        child: pw.Text(l.qrNote, textAlign: pw.TextAlign.center, style: pw.TextStyle(fontSize: note, color: pdfMuted)),
      ),
    ]);

/// ID-1 size (85.6 x 54 mm). Too small for the shelter frame, so the photo
/// takes the band: a roof bar on a 7 : 8 window.
pw.Widget _idCard(VoterCardData c, CardLabels l) => pw.Container(
      width: _idWidth,
      height: _idHeight,
      color: _cardPaper,
      child: pw.Column(children: [
        _strip(c, l, height: 11 * PdfPageFormat.mm, pad: 5, logo: 7.5 * PdfPageFormat.mm, name: 7.5, sub: 5, mark: 5.5),
        pw.Expanded(
          child: pw.Padding(
            padding: const pw.EdgeInsets.fromLTRB(5, 5, 5, 2),
            child: pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
              pdfPhotoBand(16.5 * PdfPageFormat.mm, c.photo),
              pw.SizedBox(width: 5),
              pw.Expanded(
                child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                  _field(l.fullName, c.fullName, valueSize: 8.5),
                  pw.SizedBox(height: 2),
                  pw.Row(children: [
                    pw.Expanded(child: _field(l.voterNo, c.voterNoLabel, valueSize: 9)),
                    pw.SizedBox(width: 3),
                    pw.Expanded(child: _field(c.idLabel, c.memberId)),
                  ]),
                  pw.SizedBox(height: 2),
                  pw.Row(children: [
                    pw.Expanded(child: _field(c.groupLabel, c.groupName)),
                    pw.SizedBox(width: 3),
                    if (c.feeText.isNotEmpty) pw.Expanded(child: _field(l.fee, c.feeText)) else pw.Spacer(),
                  ]),
                  pw.SizedBox(height: 2),
                  pw.Text(l.registeredLine(c.registeredOn, c.stationName),
                      style: const pw.TextStyle(fontSize: 4.5, color: pdfMuted)),
                ]),
              ),
              pw.SizedBox(width: 4),
              _qr(c, l, 19 * PdfPageFormat.mm, 3.6),
            ]),
          ),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.fromLTRB(5, 0, 5, 3),
          child: _signAndSeal(l, text: 4, sealW: 15 * PdfPageFormat.mm, sealH: 6.5 * PdfPageFormat.mm, gap: 6),
        ),
      ]),
    );

/// A6 (portrait), larger for low vision: the photo stands in the shelter frame.
pw.Widget _a6Card(VoterCardData c, CardLabels l) => pw.Container(
      color: _cardPaper,
      child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.stretch, children: [
        _strip(c, l, height: 20 * PdfPageFormat.mm, pad: 8, logo: 13 * PdfPageFormat.mm, name: 11, sub: 7, mark: 7.5),
        pw.Padding(
          padding: const pw.EdgeInsets.all(10),
          child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
            pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
              pdfShelterFrame(46 * PdfPageFormat.mm, c.photo),
              pw.Spacer(),
              _qr(c, l, 34 * PdfPageFormat.mm, 6),
            ]),
            pw.SizedBox(height: 10),
            _field(l.fullName, c.fullName, labelSize: 7, valueSize: 14),
            pw.SizedBox(height: 6),
            pw.Row(children: [
              pw.Expanded(child: _field(l.voterNo, c.voterNoLabel, labelSize: 7, valueSize: 14)),
              pw.SizedBox(width: 6),
              pw.Expanded(child: _field(c.idLabel, c.memberId, labelSize: 7, valueSize: 11)),
            ]),
            pw.SizedBox(height: 6),
            pw.Row(children: [
              pw.Expanded(child: _field(c.groupLabel, c.groupName, labelSize: 7, valueSize: 11)),
              pw.SizedBox(width: 6),
              if (c.feeText.isNotEmpty)
                pw.Expanded(child: _field(l.fee, c.feeText, labelSize: 7, valueSize: 11))
              else
                pw.Spacer(),
            ]),
            pw.SizedBox(height: 6),
            pw.Text(l.registeredLine(c.registeredOn, c.stationName), style: const pw.TextStyle(fontSize: 7, color: pdfMuted)),
          ]),
        ),
        pw.Spacer(),
        pw.Padding(
          padding: const pw.EdgeInsets.fromLTRB(10, 0, 10, 10),
          child: _signAndSeal(l, text: 7, sealW: 30 * PdfPageFormat.mm, sealH: 14 * PdfPageFormat.mm, gap: 10),
        ),
      ]),
    );

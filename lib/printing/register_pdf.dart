import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'pdf_fonts.dart';

/// One line of the printed register. Deliberately without photo and fee:
/// the register is posted publicly (D20).
class RegisterLine {
  const RegisterLine(this.voterNoLabel, this.fullName, this.memberId, this.groupName);
  final String voterNoLabel;
  final String fullName;
  final String memberId;
  final String groupName;
}

class RegisterLabels {
  const RegisterLabels({
    required this.title,
    required this.voterNo,
    required this.name,
    required this.idLabel,
    required this.groupLabel,
    required this.draftNote,
    required this.lockedNote,
    required this.generatedOn,
    required this.pageOf,
    required this.total,
  });

  final String title;
  final String voterNo;
  final String name;
  final String idLabel;
  final String groupLabel;
  final String draftNote;
  /// Filled in with the fingerprint code.
  final String Function(String fingerprint) lockedNote;
  final String Function(String date) generatedOn;
  final String Function(int page, int pages) pageOf;
  final String Function(int count) total;
}

const _ink = PdfColor.fromInt(0xFF1B1B1B);
const _lightThatch = PdfColor.fromInt(0xFFE6C27A);
const _paper = PdfColor.fromInt(0xFFF4F1EA);
const _clay = PdfColor.fromInt(0xFFA9521A);

/// The public register for the notice board and as a backup for manual
/// check-in. Shows the fingerprint when the register is locked.
Future<Uint8List> buildRegisterPdf({
  required String orgName,
  required String electionName,
  required int year,
  required String stationName,
  required List<RegisterLine> lines,
  required RegisterLabels labels,
  required String generatedOn,
  String? fingerprint,
  bool compress = true,
}) async {
  final fonts = await PdfFonts.load();
  final doc = pw.Document(theme: fonts.theme(), compress: compress, title: labels.title, creator: 'Rakubavote');
  pw.TextDirection dir(String s) => hasArabic(s) ? pw.TextDirection.rtl : pw.TextDirection.ltr;
  doc.addPage(pw.MultiPage(
    pageFormat: PdfPageFormat.a4,
    margin: const pw.EdgeInsets.all(15 * PdfPageFormat.mm),
    header: (ctx) => pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 8),
      padding: const pw.EdgeInsets.all(8),
      color: _ink,
      child: pw.Row(children: [
        pw.Expanded(
          child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
            pw.Text(orgName,
                textDirection: dir(orgName),
                style: pw.TextStyle(color: PdfColors.white, fontSize: 13, fontWeight: pw.FontWeight.bold)),
            pw.Text('${labels.title} · $electionName, $year · $stationName',
                style: const pw.TextStyle(color: _lightThatch, fontSize: 9)),
          ]),
        ),
        pw.RichText(
          text: pw.TextSpan(
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9, color: PdfColors.white),
            children: [const pw.TextSpan(text: 'Rakuba'), pw.TextSpan(text: 'vote', style: const pw.TextStyle(color: _lightThatch))],
          ),
        ),
      ]),
    ),
    footer: (ctx) => pw.Row(children: [
      pw.Expanded(
        child: pw.Text(
          fingerprint == null ? labels.draftNote : labels.lockedNote(fingerprint),
          style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold, color: fingerprint == null ? _clay : _ink),
        ),
      ),
      pw.Text('${labels.generatedOn(generatedOn)} · ${labels.pageOf(ctx.pageNumber, ctx.pagesCount)}',
          style: const pw.TextStyle(fontSize: 8)),
    ]),
    build: (ctx) {
      pw.Widget cell(String text, {bool bold = false}) => pw.Padding(
            padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 5),
            child: pw.Text(text,
                textDirection: dir(text),
                style: pw.TextStyle(fontSize: 10, fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal)),
          );
      return [
        pw.Table(
          columnWidths: const {
            0: pw.FixedColumnWidth(55),
            1: pw.FlexColumnWidth(3),
            2: pw.FlexColumnWidth(1.4),
            3: pw.FlexColumnWidth(1.6),
          },
          border: const pw.TableBorder(horizontalInside: pw.BorderSide(color: PdfColors.grey400, width: 0.4)),
          children: [
            pw.TableRow(
              repeat: true,
              decoration: const pw.BoxDecoration(color: _paper),
              children: [
                for (final h in [labels.voterNo, labels.name, labels.idLabel, labels.groupLabel]) cell(h, bold: true),
              ],
            ),
            for (final l in lines)
              pw.TableRow(children: [
                cell(l.voterNoLabel, bold: true),
                cell(l.fullName),
                cell(l.memberId),
                cell(l.groupName),
              ]),
          ],
        ),
        pw.SizedBox(height: 8),
        pw.Text(labels.total(lines.length), style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
      ];
    },
  ));
  return doc.save();
}

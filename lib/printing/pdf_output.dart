import 'dart:io';
import 'dart:typed_data';

import 'package:printing/printing.dart';

import '../platform/photo_capture.dart';

/// Where a PDF goes: the system print dialog (with preview) or a folder,
/// for example a USB drive to print elsewhere. Replaced in tests.
abstract class PdfOutput {
  /// Returns true if the document was sent to a printer.
  Future<bool> printPdf(Uint8List bytes, {required String name});

  /// Returns the saved file path, or null if cancelled.
  Future<String?> savePdf(Uint8List bytes, {required String name});
}

class SystemPdfOutput implements PdfOutput {
  @override
  Future<bool> printPdf(Uint8List bytes, {required String name}) =>
      Printing.layoutPdf(onLayout: (_) async => bytes, name: name);

  @override
  Future<String?> savePdf(Uint8List bytes, {required String name}) async {
    final dir = await pickFolder();
    if (dir == null) return null;
    final f = File('$dir/$name.pdf');
    await f.writeAsBytes(bytes, flush: true);
    return f.path;
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../core/theme.dart';

/// Camera QR scanning works on Android tablets. Laptops use a USB scanner
/// that types into a text box instead.
bool get canScanWithCamera => Platform.isAndroid;

/// Opens the camera and returns the first QR code read, or null.
Future<String?> scanQrWithCamera(BuildContext context, {required String title}) =>
    Navigator.of(context).push<String>(MaterialPageRoute(builder: (_) => _ScanPage(title: title)));

class _ScanPage extends StatefulWidget {
  const _ScanPage({required this.title});
  final String title;
  @override
  State<_ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<_ScanPage> {
  bool _done = false;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
            title: Text(widget.title), backgroundColor: RakubaColors.ink, foregroundColor: RakubaColors.white),
        body: MobileScanner(
          onDetect: (capture) {
            final value = capture.barcodes.map((b) => b.rawValue).whereType<String>().firstOrNull;
            if (value == null || _done) return;
            _done = true;
            Navigator.of(context).pop(value);
          },
        ),
      );
}

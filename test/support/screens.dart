import 'dart:io';

import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// Screen captures for design review (docs/design-system.md). Off unless the
/// RAKUBA_SCREENS environment variable is set; `tool/screens.sh` sets it and
/// writes the images to build/screens/.
final bool screensEnabled = Platform.environment.containsKey('RAKUBA_SCREENS');

bool _fontsLoaded = false;

String _materialFonts() {
  final root = Platform.environment['FLUTTER_ROOT'] ??
      File(Platform.resolvedExecutable).parent.parent.parent.parent.parent.path;
  return '$root/bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf';
}

Future<void> _loadFonts() async {
  if (_fontsLoaded) return;
  _fontsLoaded = true;
  Future<void> load(String family, List<String> files) async {
    final loader = FontLoader(family);
    for (final f in files) {
      if (File(f).existsSync()) loader.addFont(Future.value(ByteData.sublistView(File(f).readAsBytesSync())));
    }
    await loader.load();
  }

  await load('AtkinsonHyperlegible',
      ['assets/fonts/AtkinsonHyperlegible-Regular.ttf', 'assets/fonts/AtkinsonHyperlegible-Bold.ttf']);
  await load('NotoSansArabic', ['assets/fonts/NotoSansArabic.ttf']);
  await load('NotoSans', ['assets/fonts/NotoSans.ttf']);
  await load('MaterialIcons', [_materialFonts()]);
}

/// Captures the whole window (including dialogs) as build/screens/[name].png
/// when enabled.
Future<void> screen(WidgetTester tester, String name) async {
  if (!screensEnabled) return;
  await tester.runAsync(_loadFonts);
  // Finish route and fade animations (the harness's settle() pumps frames
  // without moving the clock, so a dialog would still be transparent).
  await tester.pump(const Duration(milliseconds: 400));
  final view = tester.binding.renderViews.first;
  // The root layer holds every route and overlay, unlike a widget finder.
  // ignore: invalid_use_of_protected_member
  final layer = view.debugLayer! as OffsetLayer;
  final size = view.size;
  await tester.runAsync(() async {
    final image = await layer.toImage(Offset.zero & size, pixelRatio: tester.view.devicePixelRatio);
    final png = await image.toByteData(format: ui.ImageByteFormat.png);
    final file = File('build/screens/$name.png')..createSync(recursive: true);
    file.writeAsBytesSync(png!.buffer.asUint8List());
  });
}

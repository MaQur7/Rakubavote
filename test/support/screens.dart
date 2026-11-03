import 'dart:io';

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

/// Captures the current app screen as build/screens/[name].png when enabled.
Future<void> screen(WidgetTester tester, String name) async {
  if (!screensEnabled) return;
  await tester.runAsync(_loadFonts);
  await tester.pump();
  await expectLater(find.byWidgetPredicate((w) => w is WidgetsApp).first,
      matchesGoldenFile('../../build/screens/$name.png'));
}

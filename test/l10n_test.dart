import 'package:flutter_test/flutter_test.dart';
import 'package:rakubavote/l10n/app_localizations.dart';
import 'package:flutter/widgets.dart';

/// Arguments must land where the English sentence puts them (gen-l10n would
/// otherwise sort placeholders alphabetically; see tool/declare_placeholders.py).
void main() {
  final t = lookupAppLocalizations(const Locale('en'));

  test('placeholders keep sentence order', () {
    expect(t.raisedByLine('Agent', '2026-11-03'), 'Raised by Agent on 2026-11-03');
    expect(t.duplicateTitle('0003', '0001'), 'Voter No. 0003 · possible duplicate of 0001');
    expect(t.displayPeriodRange('2026-11-02', '2026-11-09'), '2026-11-02 to 2026-11-09');
    expect(t.decidedLine('PO', '2026-11-03', 'removed'), 'Decided by PO on 2026-11-03: removed');
    expect(t.importDone('5', '1', '2'), 'Imported 5. Skipped 1. Possible duplicates: 2.');
    expect(t.feeLine('500', 'SSP'), 'Registration fee: 500 SSP');
    expect(t.otherTitle('0007', 'Moved away'), 'Voter No. 0007: Moved away');
  });

  test('every language has every key', () {
    for (final l in AppLocalizations.supportedLocales) {
      final x = lookupAppLocalizations(l);
      expect(x.appName, 'Rakubavote', reason: 'the product name is never translated');
      expect(x.raisedByLine('A', 'B'), allOf(contains('A'), contains('B')));
    }
  });
}

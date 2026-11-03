import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rakubavote/app/localization.dart';
import 'package:rakubavote/core/theme.dart';
import 'package:rakubavote/core/widgets/common.dart';
import 'package:rakubavote/l10n/app_localizations.dart';

import '../support/screens.dart';

/// Every shared component in every state (docs/design-system.md, section 6).
/// Checked here first, before any screen uses them.
Widget _sheet() {
  // Still images show focus, disabled and hover text styles; the hover and
  // pressed ink layers react only to live pointers and are tested below.
  WidgetStatesController states(Set<WidgetState> s) => WidgetStatesController(s);
  Widget row(String label, List<Widget> items) => Padding(
        padding: const EdgeInsets.only(bottom: RakubaSpace.m),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          FieldLabel(label),
          Wrap(spacing: RakubaSpace.s, runSpacing: RakubaSpace.s, children: items),
        ]),
      );
  const variants = <(String, Set<WidgetState>)>[
    ('Default', {}),
    ('Hover', {WidgetState.hovered}),
    ('Focus', {WidgetState.focused}),
    ('Pressed', {WidgetState.pressed}),
  ];
  return Builder(builder: (context) {
    return ListView(padding: const EdgeInsets.all(RakubaSpace.l), children: [
      Text('Components', style: rakubaText(context, RakubaType.title, bold: true)),
      const SizedBox(height: RakubaSpace.m),
      row('Primary', [
        for (final v in variants)
          FilledButton(key: ValueKey('filled-${v.$1}'), statesController: states(v.$2), onPressed: () {}, child: Text(v.$1)),
        const FilledButton(key: ValueKey('filled-disabled'), onPressed: null, child: Text('Disabled')),
        FilledButton(style: filledColourStyle(RakubaColors.acaciaGreen), onPressed: () {}, child: const Text('Confirm my vote')),
      ]),
      row('Secondary (admin)', [
        for (final v in variants)
          OutlinedButton(key: ValueKey('outlined-${v.$1}'), statesController: states(v.$2), onPressed: () {}, child: Text(v.$1)),
        const OutlinedButton(key: ValueKey('outlined-disabled'), onPressed: null, child: Text('Disabled')),
        OutlinedButton(style: destructiveOutlinedStyle(), onPressed: () {}, child: const Text('Remove 0003')),
      ]),
      row('Secondary (booth)', [
        for (final v in variants)
          OutlinedButton(style: boothOutlinedStyle(), statesController: states(v.$2), onPressed: () {}, child: Text(v.$1)),
        OutlinedButton(style: boothOutlinedStyle(), onPressed: null, child: const Text('Disabled')),
      ]),
      row('Text action', [
        for (final v in variants)
          TextButton(statesController: states(v.$2), onPressed: () {}, child: Text('Move up · ${v.$1}')),
        const TextButton(onPressed: null, child: Text('Disabled')),
      ]),
      row('Inputs', [
        const SizedBox(width: 280, child: TextField(decoration: InputDecoration(hintText: 'Search name or number'))),
        const SizedBox(
            width: 280,
            child: TextField(decoration: InputDecoration(errorText: 'The PIN must be 6 to 12 digits.'))),
        const SizedBox(width: 280, child: TextField(enabled: false, decoration: InputDecoration(hintText: 'Locked'))),
      ]),
      row('Tick boxes', [
        Checkbox(value: false, onChanged: (_) {}),
        Checkbox(value: true, onChanged: (_) {}),
        const Checkbox(value: true, onChanged: null),
      ]),
      row('Status', const [
        StatusPill('Offline · saved on this laptop'),
        StatusPill('Wi-Fi is down', colour: RakubaColors.clay),
      ]),
      const NoticeBox(child: Text('Possible duplicate: a voter with a similar name exists (Voter No. 0001).')),
      const SizedBox(height: RakubaSpace.s),
      const NoticeBox(kind: NoticeKind.success, child: Text('Checked: the signed register matches.')),
      const SizedBox(height: RakubaSpace.s),
      const NoticeBox(kind: NoticeKind.info, child: Text('Waiting for the laptop to approve this tablet.')),
      const SizedBox(height: RakubaSpace.m),
      const SectionCard(
        title: 'Ledger',
        child: Column(children: [
          LedgerRow(label: 'Registered', value: '412'),
          LedgerRow(label: 'Checked in', value: '388'),
          LedgerRow(label: 'Votes on tablets', value: '387', attention: true, note: '1 checked-in voter did not vote.'),
        ]),
      ),
      const SectionCard(title: 'Loading', child: LoadingLine('Opening the register…')),
      SectionCard(
        title: 'Empty',
        child: EmptyState('No voters yet. Register the first voter on the left.',
            action: OutlinedButton(onPressed: () {}, child: const Text('Import list (CSV)'))),
      ),
    ]);
  });
}

Widget _app(Locale locale) => MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: locale,
      theme: buildRakubaTheme(arabic: locale.languageCode == 'ar'),
      localizationsDelegates: rakubaLocalizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: _sheet()),
    );

void main() {
  testWidgets('component sheet renders every state from the design system', (tester) async {
    tester.view.physicalSize = const Size(1280, 2000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(_app(const Locale('en')));
    await tester.pump(const Duration(milliseconds: 400));
    await screen(tester, 'components-en');
    await tester.pumpWidget(_app(const Locale('ar')));
    await tester.pump(const Duration(milliseconds: 400));
    await screen(tester, 'components-ar');
    expect(find.text('Components'), findsOneWidget);
  });

  testWidgets('a real mouse hover and a press draw the Ink layers', (tester) async {
    await tester.pumpWidget(MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: buildRakubaTheme(arabic: false),
      home: Scaffold(
        body: Center(child: OutlinedButton(key: const ValueKey('b'), onPressed: () {}, child: const Text('Edit'))),
      ),
    ));
    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(location: Offset.zero);
    await mouse.moveTo(tester.getCenter(find.byKey(const ValueKey('b'))));
    await tester.pump(const Duration(milliseconds: 400));
    final material = Material.of(tester.element(find.text('Edit')));
    // ignore: invalid_use_of_protected_member
    final features = (material as dynamic).debugInkFeatures as List;
    expect(features.length, 1);
    expect((features.single as InkHighlight).color, RakubaColors.hoverLayer);
    await mouse.removePointer();
  });

  test('theme states resolve to the design system values', () {
    final theme = buildRakubaTheme(arabic: false);
    final filled = theme.filledButtonTheme.style!;
    expect(filled.overlayColor!.resolve({WidgetState.hovered}), RakubaColors.hoverLayerOnDark);
    expect(filled.overlayColor!.resolve({WidgetState.pressed}), RakubaColors.pressedLayerOnDark);
    expect(filled.side!.resolve({WidgetState.focused})!.width, RakubaLine.selected);
    expect(filled.backgroundColor!.resolve({WidgetState.disabled}), RakubaColors.disabled);
    final outlined = theme.outlinedButtonTheme.style!;
    expect(outlined.overlayColor!.resolve({WidgetState.hovered}), RakubaColors.hoverLayer);
    expect(outlined.side!.resolve({WidgetState.focused})!.color, RakubaColors.ink);
    expect(theme.splashFactory, NoSplash.splashFactory);
    expect(theme.dialogTheme.shape, isA<RoundedRectangleBorder>());
    expect((theme.dialogTheme.shape! as RoundedRectangleBorder).borderRadius,
        BorderRadius.circular(RakubaRadius.panel));
    expect(theme.colorScheme.surfaceTint, RakubaColors.transparent);
  });

  test('text colours on their backgrounds pass WCAG AA', () {
    expect(meetsTextContrast(RakubaColors.inkMuted, RakubaColors.paper), isTrue);
    expect(meetsTextContrast(RakubaColors.inkMuted, RakubaColors.card), isTrue);
    expect(meetsTextContrast(RakubaColors.inkMuted, RakubaColors.warningTint), isTrue);
    expect(meetsTextContrast(RakubaColors.disabled, RakubaColors.card), isTrue);
    expect(meetsTextContrast(RakubaColors.white, RakubaColors.disabled), isTrue);
    expect(meetsTextContrast(RakubaColors.paper, RakubaColors.ink), isTrue);
    expect(meetsTextContrast(RakubaColors.ink, RakubaColors.lightThatch), isTrue);
    expect(meetsTextContrast(RakubaColors.clay, RakubaColors.warningTint), isTrue);
  });
}

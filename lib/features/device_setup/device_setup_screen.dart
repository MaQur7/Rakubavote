import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/device_store.dart';
import '../../app/providers.dart';
import '../../core/theme.dart';
import '../../core/widgets/common.dart';
import '../../l10n/app_localizations.dart';

String modeTitle(AppLocalizations t, DeviceMode m) => switch (m) {
  DeviceMode.admin => t.modeAdmin,
  DeviceMode.checkin => t.modeCheckin,
  DeviceMode.booth => t.modeBooth,
};

String modeHint(AppLocalizations t, DeviceMode m) => switch (m) {
  DeviceMode.admin => t.modeAdminHint,
  DeviceMode.checkin => t.modeCheckinHint,
  DeviceMode.booth => t.modeBoothHint,
};

class LanguageButtons extends ConsumerWidget {
  const LanguageButtons({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(localeProvider);
    return Wrap(
      spacing: RakubaSpace.s,
      runSpacing: RakubaSpace.s,
      children: [
        for (final l in AppLocalizations.supportedLocales)
          // Chosen language: 3 px Nile Blue border and a tick (design system).
          l == current
              ? OutlinedButton.icon(
                  style: const ButtonStyle(
                    side: WidgetStatePropertyAll(
                        BorderSide(color: RakubaColors.nileBlue, width: RakubaLine.selected)),
                  ),
                  onPressed: () => ref.read(localeProvider.notifier).set(l),
                  icon: const Icon(Icons.check),
                  label: Text(lookupAppLocalizations(l).languageName),
                )
              : OutlinedButton(
                  onPressed: () => ref.read(localeProvider.notifier).set(l),
                  child: Text(lookupAppLocalizations(l).languageName),
                ),
      ],
    );
  }
}

/// First run: choose what the device is for, the official's name and a PIN.
class DeviceSetupScreen extends ConsumerStatefulWidget {
  const DeviceSetupScreen({super.key, required this.store});
  final DeviceStore store;

  @override
  ConsumerState<DeviceSetupScreen> createState() => _DeviceSetupScreenState();
}

class _DeviceSetupScreenState extends ConsumerState<DeviceSetupScreen> {
  DeviceMode? _mode;
  final _name = TextEditingController();
  final _pin = TextEditingController();
  final _pin2 = TextEditingController();
  String? _error;
  bool _busy = false;

  @override
  void dispose() {
    _name.dispose();
    _pin.dispose();
    _pin2.dispose();
    super.dispose();
  }

  Future<void> _submit(AppLocalizations t) async {
    setState(() => _error = null);
    final problem = _name.text.trim().isEmpty
        ? t.nameRequired
        : !isAcceptablePin(_pin.text)
            ? t.pinRule
            : _pin.text != _pin2.text
                ? t.pinsDoNotMatch
                : null;
    if (problem != null) {
      setState(() => _error = problem);
      return;
    }
    setState(() => _busy = true);
    try {
      final s = await widget.store.setUp(
        mode: _mode!,
        pin: _pin.text,
        official: _name.text.trim(),
      );
      ref.read(sessionProvider.notifier).unlocked(s);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(RakubaSpace.m),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Wordmark(size: 36),
                  Text(
                    t.tagline,
                    style: rakubaText(context, RakubaType.bodyLarge),
                  ),
                  const SizedBox(height: RakubaSpace.s),
                  const LanguageButtons(),
                  const SizedBox(height: RakubaSpace.m),
                  Text(
                    t.chooseDeviceMode,
                    style: rakubaText(context, RakubaType.heading, bold: true),
                  ),
                  const SizedBox(height: RakubaSpace.s),
                  for (final m in DeviceMode.values)
                    Card(
                      margin: const EdgeInsets.only(bottom: RakubaSpace.xs),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(RakubaRadius.panel),
                        side: _mode == m
                            ? const BorderSide(color: RakubaColors.nileBlue, width: RakubaLine.selected)
                            : const BorderSide(color: RakubaColors.border),
                      ),
                      child: ListTile(
                        key: ValueKey('mode-${m.name}'),
                        minTileHeight: RakubaSizes.minTouch + 16,
                        title: Text(
                          modeTitle(t, m),
                          style: rakubaText(context, RakubaType.heading, bold: true),
                        ),
                        subtitle: Text(
                          modeHint(t, m),
                          style: rakubaText(context, RakubaType.bodyLarge),
                        ),
                        trailing: _mode == m
                            ? const Icon(
                                Icons.check_circle,
                                color: RakubaColors.nileBlue,
                              )
                            : null,
                        onTap: () => setState(() => _mode = m),
                      ),
                    ),
                  if (_mode != null) ...[
                    const SizedBox(height: RakubaSpace.s),
                    Text(
                      t.setupDeviceTitle,
                      style: rakubaText(context, RakubaType.heading, bold: true),
                    ),
                    FieldLabel(t.yourName),
                    TextField(
                      key: const ValueKey('setup-name'),
                      controller: _name,
                      decoration: InputDecoration(hintText: t.yourNameHint),
                    ),
                    FieldLabel(t.choosePin),
                    TextField(
                      key: const ValueKey('setup-pin'),
                      controller: _pin,
                      obscureText: true,
                      keyboardType: TextInputType.number,
                    ),
                    FieldLabel(t.confirmPin),
                    TextField(
                      key: const ValueKey('setup-pin2'),
                      controller: _pin2,
                      obscureText: true,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: RakubaSpace.s),
                    NoticeBox(child: Text(t.pinWarning)),
                    if (_error != null)
                      Padding(
                        padding: const EdgeInsets.only(top: RakubaSpace.s),
                        child: Text(
                          _error!,
                          style: rakubaText(context, RakubaType.body, bold: true, colour: RakubaColors.clay),
                        ),
                      ),
                    const SizedBox(height: RakubaSpace.s),
                    FilledButton(
                      key: const ValueKey('setup-submit'),
                      onPressed: _busy ? null : () => _submit(t),
                      child: Text(t.setUpButton),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

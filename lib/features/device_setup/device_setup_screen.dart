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
      spacing: 12,
      runSpacing: 12,
      children: [
        for (final l in AppLocalizations.supportedLocales)
          OutlinedButton(
            style: l == current
                ? OutlinedButton.styleFrom(
                    backgroundColor: RakubaColors.nileBlue.withValues(
                      alpha: 0.1,
                    ),
                    side: const BorderSide(
                      color: RakubaColors.nileBlue,
                      width: 3,
                    ),
                  )
                : null,
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
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Wordmark(size: 36),
                  Text(
                    t.tagline,
                    style: const TextStyle(fontSize: RakubaSizes.body),
                  ),
                  const SizedBox(height: 16),
                  const LanguageButtons(),
                  const SizedBox(height: 24),
                  Text(
                    t.chooseDeviceMode,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  for (final m in DeviceMode.values)
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          RakubaSizes.cardRadius,
                        ),
                        side: BorderSide(
                          color: _mode == m
                              ? RakubaColors.nileBlue
                              : RakubaColors.placeholder,
                          width: _mode == m ? 3 : 1,
                        ),
                      ),
                      child: ListTile(
                        key: ValueKey('mode-${m.name}'),
                        minTileHeight: RakubaSizes.minTouch + 16,
                        title: Text(
                          modeTitle(t, m),
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        subtitle: Text(
                          modeHint(t, m),
                          style: const TextStyle(fontSize: RakubaSizes.body),
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
                    const SizedBox(height: 16),
                    Text(
                      t.setupDeviceTitle,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
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
                    const SizedBox(height: 12),
                    NoticeBox(child: Text(t.pinWarning)),
                    if (_error != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Text(
                          _error!,
                          style: const TextStyle(
                            color: RakubaColors.clay,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    const SizedBox(height: 16),
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

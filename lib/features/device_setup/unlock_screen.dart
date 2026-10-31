import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/device_store.dart';
import '../../app/providers.dart';
import '../../core/crypto/key_vault.dart';
import '../../core/theme.dart';
import '../../core/widgets/common.dart';
import '../../l10n/app_localizations.dart';
import 'device_setup_screen.dart';

/// Asks for the official's name and the officer PIN each time the app opens.
class UnlockScreen extends ConsumerStatefulWidget {
  const UnlockScreen({super.key, required this.store, required this.info});
  final DeviceStore store;
  final DeviceInfo info;

  @override
  ConsumerState<UnlockScreen> createState() => _UnlockScreenState();
}

class _UnlockScreenState extends ConsumerState<UnlockScreen> {
  final _name = TextEditingController();
  final _pin = TextEditingController();
  String? _error;
  bool _busy = false;

  @override
  void dispose() {
    _name.dispose();
    _pin.dispose();
    super.dispose();
  }

  Future<void> _unlock(AppLocalizations t) async {
    if (_name.text.trim().isEmpty) return setState(() => _error = t.nameRequired);
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final s = await widget.store.unlock(pin: _pin.text, official: _name.text.trim());
      ref.read(sessionProvider.notifier).unlocked(s);
    } on WrongPinException {
      _pin.clear();
      setState(() => _error = t.wrongPin);
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
            constraints: const BoxConstraints(maxWidth: 520),
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.all(24),
              children: [
                const Wordmark(size: 32),
                const SizedBox(height: 16),
                const LanguageButtons(),
                const SizedBox(height: 24),
                Text(t.unlockTitle(modeTitle(t, widget.info.mode)),
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
                FieldLabel(t.yourName),
                TextField(key: const ValueKey('unlock-name'), controller: _name),
                FieldLabel(t.officerPin),
                TextField(
                  key: const ValueKey('unlock-pin'),
                  controller: _pin,
                  obscureText: true,
                  keyboardType: TextInputType.number,
                  onSubmitted: (_) => _unlock(t),
                ),
                if (_error != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(_error!, style: const TextStyle(color: RakubaColors.clay, fontSize: 16)),
                  ),
                const SizedBox(height: 16),
                FilledButton(
                  key: const ValueKey('unlock-submit'),
                  onPressed: _busy ? null : () => _unlock(t),
                  child: Text(t.unlockButton),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

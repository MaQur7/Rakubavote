import 'package:flutter/material.dart';

import '../core/theme.dart';
import '../l10n/app_localizations.dart';
import 'localization.dart';

class RakubavoteApp extends StatefulWidget {
  const RakubavoteApp({super.key, this.initialLocale = const Locale('en')});

  final Locale initialLocale;

  @override
  State<RakubavoteApp> createState() => _RakubavoteAppState();
}

class _RakubavoteAppState extends State<RakubavoteApp> {
  late Locale _locale = widget.initialLocale;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rakubavote',
      debugShowCheckedModeBanner: false,
      locale: _locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: rakubaLocalizationsDelegates,
      theme: buildRakubaTheme(arabic: _locale.languageCode == 'ar'),
      home: DeviceModeScreen(onLocale: (l) => setState(() => _locale = l)),
    );
  }
}

/// First-run screen: the device mode is chosen once at setup (milestone 2 stores it).
class DeviceModeScreen extends StatelessWidget {
  const DeviceModeScreen({super.key, required this.onLocale});

  final ValueChanged<Locale> onLocale;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                Text(t.appName,
                    style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w700)),
                Text(t.tagline, style: const TextStyle(fontSize: RakubaSizes.body)),
                const SizedBox(height: 16),
                Wrap(spacing: 12, runSpacing: 12, children: [
                  for (final l in AppLocalizations.supportedLocales)
                    OutlinedButton(
                      onPressed: () => onLocale(l),
                      child: Text(lookupAppLocalizations(l).languageName),
                    ),
                ]),
                const SizedBox(height: 24),
                Text(t.chooseDeviceMode,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),
                _ModeCard(title: t.modeAdmin, hint: t.modeAdminHint),
                _ModeCard(title: t.modeCheckin, hint: t.modeCheckinHint),
                _ModeCard(title: t.modeBooth, hint: t.modeBoothHint),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ModeCard extends StatelessWidget {
  const _ModeCard({required this.title, required this.hint});
  final String title;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        minTileHeight: RakubaSizes.minTouch + 16,
        title: Text(title,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
        subtitle: Text(hint, style: const TextStyle(fontSize: RakubaSizes.body)),
        onTap: () {},
      ),
    );
  }
}

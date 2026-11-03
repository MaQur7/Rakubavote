import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme.dart';
import '../core/widgets/common.dart';
import '../features/admin/admin_shell.dart';
import '../features/booth/booth_home.dart';
import '../features/checkin/checkin_tablet_home.dart';
import '../features/device_setup/device_setup_screen.dart';
import '../features/device_setup/unlock_screen.dart';
import '../l10n/app_localizations.dart';
import 'device_store.dart';
import 'localization.dart';
import 'providers.dart';

class RakubavoteApp extends ConsumerWidget {
  const RakubavoteApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    return MaterialApp(
      title: 'Rakubavote',
      debugShowCheckedModeBanner: false,
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: rakubaLocalizationsDelegates,
      theme: buildRakubaTheme(arabic: locale.languageCode == 'ar'),
      home: const AppRoot(),
    );
  }
}

/// Decides what to show: first-run setup, the PIN screen, or the mode's home.
class AppRoot extends ConsumerStatefulWidget {
  const AppRoot({super.key});
  @override
  ConsumerState<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends ConsumerState<AppRoot> {
  @override
  Widget build(BuildContext context) {
    final session = ref.watch(sessionProvider);
    if (session != null) {
      return switch (session.info.mode) {
        DeviceMode.admin => const AdminShell(),
        DeviceMode.booth => const BoothHome(),
        DeviceMode.checkin => const CheckInTabletHome(),
      };
    }
    final store = ref.watch(deviceStoreProvider);
    return store.when(
      loading: () => const _Opening(),
      error: (e, _) => const _OpenFailed(),
      data: (store) => FutureBuilder<DeviceInfo?>(
        // Re-read after locking or setting up.
        key: ValueKey(session),
        future: store.readInfo(),
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const _Opening();
          }
          final info = snap.data;
          return info == null ? DeviceSetupScreen(store: store) : UnlockScreen(store: store, info: info);
        },
      ),
    );
  }
}


/// Loading state while the device store opens (design system, section 8).
class _Opening extends StatelessWidget {
  const _Opening();
  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Padding(
              padding: const EdgeInsets.all(RakubaSpace.l),
              child: LoadingLine(AppLocalizations.of(context).loadingDevice),
            ),
          ),
        ),
      );
}

/// Error state: what happened and what to do, never an exception text.
class _OpenFailed extends StatelessWidget {
  const _OpenFailed();
  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Padding(
              padding: const EdgeInsets.all(RakubaSpace.l),
              child: NoticeBox(child: Text(AppLocalizations.of(context).deviceOpenFailed)),
            ),
          ),
        ),
      );
}

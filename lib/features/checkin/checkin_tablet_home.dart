import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../core/theme.dart';
import '../../core/widgets/common.dart';
import '../../l10n/app_localizations.dart';
import '../../station/enrollment.dart';
import '../device_setup/pair_screen.dart';
import 'checkin_screen.dart';

/// Check-in tablet: pair with the laptop once, then run the desk through it.
class CheckInTabletHome extends ConsumerWidget {
  const CheckInTabletHome({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context);
    final link = ref.watch(stationLinkProvider);
    return link.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text('$e'))),
      data: (l) {
        if (l == null) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: RakubaColors.ink,
              foregroundColor: RakubaColors.white,
              title: Wordmark(onDark: true, suffix: t.modeCheckin),
              actions: [
                IconButton(
                  tooltip: t.lockDevice,
                  icon: const Icon(Icons.lock_outline),
                  onPressed: () => ref.read(sessionProvider.notifier).lock(),
                ),
              ],
            ),
            body: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: ListView(padding: const EdgeInsets.all(24), children: const [PairCard(role: DeviceRole.checkin)]),
              ),
            ),
          );
        }
        return CheckInScreen(
          stationName: l.stationName,
          onBack: () => ref.read(sessionProvider.notifier).lock(),
        );
      },
    );
  }
}

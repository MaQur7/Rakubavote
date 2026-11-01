import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../core/theme.dart';
import '../../core/widgets/common.dart';
import '../../l10n/app_localizations.dart';
import '../register_lock/review_screen.dart';
import '../../core/db/registry_db.dart';
import '../checkin/checkin_screen.dart';
import '../registration/registration_screen.dart';
import '../results/results_screen.dart';
import '../station_admin/devices_screen.dart';
import '../setup/setup_screen.dart';

/// Station admin: black top bar with the four phases (mockups A–D).
class AdminShell extends ConsumerStatefulWidget {
  const AdminShell({super.key});

  @override
  ConsumerState<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends ConsumerState<AdminShell> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final tabs = [t.tabSetup, t.tabRegistration, t.tabReview, t.tabResults];
    return Scaffold(
      body: Column(
        children: [
          Material(
            color: RakubaColors.ink,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    Wordmark(onDark: true, size: 20, suffix: t.adminSuffix),
                    const SizedBox(width: 16),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            for (var i = 0; i < tabs.length; i++)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                child: TextButton(
                                  key: ValueKey('admin-tab-$i'),
                                  style: TextButton.styleFrom(
                                    minimumSize: const Size(64, 48),
                                    backgroundColor: i == _tab
                                        ? RakubaColors.lightThatch
                                        : null,
                                    foregroundColor: i == _tab
                                        ? RakubaColors.ink
                                        : RakubaColors.white,
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                          fontSize: 16,
                                          fontWeight: i == _tab
                                              ? FontWeight.w700
                                              : FontWeight.w400,
                                        ),
                                  ),
                                  onPressed: () => setState(() => _tab = i),
                                  child: Text(tabs[i]),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    StreamBuilder<Election?>(
                      stream: ref
                          .watch(electionServiceProvider)
                          .watchElection(),
                      builder: (context, snap) {
                        final e = snap.data;
                        if (e == null || e.state != 'polling') {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: const EdgeInsetsDirectional.only(end: 12),
                          child: FilledButton.icon(
                            key: const ValueKey('open-checkin-desk'),
                            style: FilledButton.styleFrom(
                              backgroundColor: RakubaColors.lightThatch,
                              foregroundColor: RakubaColors.ink,
                              minimumSize: const Size(64, 48),
                            ),
                            icon: const Icon(Icons.how_to_reg_outlined),
                            label: Text(t.openCheckinDesk),
                            onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (c) => CheckInScreen(
                                  stationName: e.stationName,
                                  onBack: () => Navigator.of(c).pop(),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      key: const ValueKey('open-devices'),
                      tooltip: t.devicesTitle,
                      color: RakubaColors.white,
                      icon: const Icon(Icons.devices_other),
                      onPressed: () => Navigator.of(context)
                          .push(MaterialPageRoute<void>(builder: (_) => const DevicesScreen())),
                    ),
                    StatusPill(t.offlineSavedLaptop),
                    const SizedBox(width: 8),
                    IconButton(
                      tooltip: t.lockDevice,
                      color: RakubaColors.white,
                      icon: const Icon(Icons.lock_outline),
                      onPressed: () =>
                          ref.read(sessionProvider.notifier).lock(),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: switch (_tab) {
              0 => const SetupScreen(),
              1 => const RegistrationScreen(),
              2 => const ReviewScreen(),
              3 => const ResultsScreen(),
              _ => Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    t.comingLater,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
            },
          ),
        ],
      ),
    );
  }
}

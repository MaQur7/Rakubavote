import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import '../core/db/ballot_box_repository.dart';
import '../features/checkin/checkin_backend.dart';
import '../features/checkin/checkin_service.dart';
import '../features/results/results_service.dart';
import '../station/booth_link.dart';
import '../station/station_client.dart';
import '../station/station_server.dart';
import '../features/register_lock/review_service.dart';
import '../features/registration/registration_service.dart';
import '../features/setup/election_service.dart';
import 'device_store.dart';

/// Where this device keeps its files. Overridden in tests.
final deviceStoreProvider = FutureProvider<DeviceStore>((ref) async {
  final base = await getApplicationSupportDirectory();
  return DeviceStore(Directory('${base.path}/rakubavote'));
});

class SessionNotifier extends Notifier<DeviceSession?> {
  @override
  DeviceSession? build() => null;

  void unlocked(DeviceSession s) => state = s;

  Future<void> lock() async {
    final s = state;
    state = null;
    ref.invalidate(stationServerProvider);
    await s?.close();
  }
}

/// The unlocked device, or null when locked.
final sessionProvider = NotifierProvider<SessionNotifier, DeviceSession?>(SessionNotifier.new);

class LocaleNotifier extends Notifier<Locale> {
  @override
  Locale build() => const Locale('en');
  void set(Locale l) => state = l;
}

final localeProvider = NotifierProvider<LocaleNotifier, Locale>(LocaleNotifier.new);

/// The most recent unlocked session. Services follow this rather than
/// [sessionProvider], so screens being removed during "Lock" never see a
/// missing session; the next unlock replaces it.
class _LastSessionNotifier extends Notifier<DeviceSession?> {
  @override
  DeviceSession? build() {
    ref.listen(sessionProvider, (_, next) {
      if (next != null) state = next;
    });
    return ref.read(sessionProvider);
  }
}

final _lastSessionProvider = NotifierProvider<_LastSessionNotifier, DeviceSession?>(_LastSessionNotifier.new);

DeviceSession _requireSession(Ref ref) {
  final s = ref.watch(_lastSessionProvider);
  if (s == null) throw StateError('Device is locked');
  return s;
}

final electionServiceProvider = Provider<ElectionService>((ref) {
  final s = _requireSession(ref);
  return ElectionService(s.registry!, s.keys);
});

final registrationServiceProvider = Provider<RegistrationService>((ref) {
  final s = _requireSession(ref);
  return RegistrationService(s.registry!);
});

/// Name of the official using the device, for the audit log.
final officialProvider = Provider<String>((ref) => _requireSession(ref).official);

final reviewServiceProvider = Provider<ReviewService>((ref) {
  final s = _requireSession(ref);
  return ReviewService(s.registry!, s.keys);
});

/// One instance per session, so activation listeners stay attached.
final checkInServiceProvider = Provider<CheckInService>((ref) {
  final s = _requireSession(ref);
  return CheckInService(s.registry!, s.keys);
});

/// The booth's ballot box (booth tablets only).
final boothRepositoryProvider = Provider<BallotBoxRepository>((ref) {
  final s = _requireSession(ref);
  return BallotBoxRepository(s.ballotBox!, s.keys);
});

/// The laptop this tablet is paired with (null until paired).
class StationLinkNotifier extends AsyncNotifier<StationLink?> {
  @override
  Future<StationLink?> build() async => (await ref.watch(deviceStoreProvider.future)).readLink();

  Future<void> save(StationLink link) async {
    await (await ref.read(deviceStoreProvider.future)).writeLink(link);
    state = AsyncData(link);
  }

  Future<void> forget() async {
    await (await ref.read(deviceStoreProvider.future)).forgetLink();
    state = const AsyncData(null);
  }
}

final stationLinkProvider = AsyncNotifierProvider<StationLinkNotifier, StationLink?>(StationLinkNotifier.new);

final stationClientProvider = Provider<StationClient?>((ref) {
  final link = ref.watch(stationLinkProvider).value;
  final s = ref.watch(_lastSessionProvider);
  if (link == null || s == null) return null;
  return StationClient(link, s.keys);
});

/// The check-in desk: local on the laptop, through the laptop on a tablet.
final checkInBackendProvider = Provider<CheckInBackend>((ref) {
  final s = _requireSession(ref);
  if (s.info.mode == DeviceMode.checkin) {
    final client = ref.watch(stationClientProvider);
    if (client == null) throw StateError('Not paired');
    return RemoteCheckInBackend(client, official: s.official);
  }
  return LocalCheckInBackend(ref.watch(checkInServiceProvider), official: s.official);
});

final resultsServiceProvider = Provider<ResultsService>((ref) {
  final s = _requireSession(ref);
  return ResultsService(s.registry!, s.ballotBox!, s.keys);
});

/// The laptop's station server (admin laptop only). Stopped when the
/// laptop is locked.
final stationServerProvider = Provider<StationServer>((ref) {
  final s = _requireSession(ref);
  final server = StationServer(
    registry: s.registry!,
    ballotBox: s.ballotBox!,
    keys: s.keys,
    checkIn: ref.watch(checkInServiceProvider),
    official: () => s.official,
  );
  ref.onDispose(server.stop);
  return server;
});

/// A booth's live link to the laptop (null until paired). Started by the
/// booth panel; stopped when the tablet is locked.
final boothLinkProvider = Provider<BoothLink?>((ref) {
  final client = ref.watch(stationClientProvider);
  final s = ref.watch(_lastSessionProvider);
  if (client == null || s == null || s.info.mode != DeviceMode.booth) return null;
  final link = BoothLink(client, ref.watch(boothRepositoryProvider));
  ref.onDispose(link.stop);
  return link;
});

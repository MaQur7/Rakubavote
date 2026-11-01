import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import '../features/checkin/checkin_service.dart';
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

import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../core/crypto/device_keys.dart';
import '../../core/crypto/signed_artifact.dart';
import '../../core/db/ballot_box_repository.dart';
import '../../core/theme.dart';
import '../../core/widgets/common.dart';
import '../../l10n/app_localizations.dart';
import '../../platform/beep.dart';
import '../../station/ballot_package.dart';
import '../../station/booth_link.dart';
import '../../station/enrollment.dart';
import '../../platform/photo_capture.dart';
import '../device_setup/pair_screen.dart';
import 'booth_controller.dart';
import 'booth_screen.dart';

String packageFailureText(AppLocalizations t, Object e) {
  if (e is PackageException) {
    return switch (e.failure) {
      PackageFailure.malformed => t.errPackageMalformed,
      PackageFailure.badSignature => t.errPackageSignature,
      PackageFailure.wrongStation => t.errPackageWrongStation,
      PackageFailure.missingImage || PackageFailure.imageChanged => t.errPackageImage,
    };
  }
  if (e is CastBallotException) {
    return e.failure == CastFailure.otherStation ? t.errPackageWrongStation : t.errVotesExist;
  }
  return t.errPackageMalformed;
}

/// Officer panel on a booth tablet: load the signed ballot, compare its
/// fingerprint with the laptop, then start the voter screen.
class BoothHome extends ConsumerStatefulWidget {
  const BoothHome({super.key, this.pickPackage});

  /// Returns the text of a ballot package file (overridable in tests).
  final Future<String?> Function()? pickPackage;

  @override
  ConsumerState<BoothHome> createState() => _BoothHomeState();
}

class _BoothHomeState extends ConsumerState<BoothHome> {
  SignedArtifact? _signed;
  String? _stationId;
  int _votes = 0;
  String? _error;

  BallotBoxRepository get _repo => ref.read(boothRepositoryProvider);
  final _pollsClosed = ValueNotifier<bool>(false);
  StreamSubscription<void>? _closedSub;
  StreamSubscription<BoothLinkState>? _stateSub;

  @override
  void initState() {
    super.initState();
    _refresh().then((_) => _startLink());
  }

  @override
  void dispose() {
    _closedSub?.cancel();
    _stateSub?.cancel();
    _pollsClosed.dispose();
    super.dispose();
  }

  /// Connects to the laptop if paired: fetches the ballot and keeps codes in step.
  Future<void> _startLink() async {
    final link = ref.read(boothLinkProvider);
    if (link == null) return;
    try {
      await link.fetchBallot();
    } catch (err) {
      if (mounted) setState(() => _error = err is PackageException ? packageFailureText(AppLocalizations.of(context), err) : null);
    }
    _closedSub ??= link.pollsClosed.listen((_) => _pollsClosed.value = true);
    _stateSub ??= link.states.listen((_) {
      if (mounted) setState(() {});
      _refresh();
    });
    await link.start();
    await _refresh();
  }

  Future<void> _saveVotesUsb() async {
    final t = AppLocalizations.of(context);
    final dir = await pickFolder();
    if (dir == null) return;
    final batch = await _repo.exportBatch();
    final f = File('$dir/rakubavote-votes-${_repo.boothKeys.deviceId}-${batch.fingerprint}.json');
    await f.writeAsString(batch.encode(), flush: true);
    if (mounted) showMessage(context, t.votesSavedIn(f.path));
  }

  Future<void> _refresh() async {
    final def = await _repo.restoreBallot();
    final signed = await _repo.signedBallot();
    final key = await _repo.pinnedStationKey();
    final votes = await _repo.ballotCount();
    if (!mounted) return;
    setState(() {
      _signed = def == null ? null : signed;
      _stationId = key == null ? null : deviceIdFor(key);
      _votes = votes;
    });
  }

  Future<String?> _pick() async {
    final f = await FilePicker.pickFile();
    if (f == null) return null;
    final path = f.path;
    return path == null ? String.fromCharCodes(await f.readAsBytes()) : File(path).readAsString();
  }

  Future<void> _load() async {
    final t = AppLocalizations.of(context);
    final text = await (widget.pickPackage ?? _pick)();
    if (text == null) return;
    try {
      final pkg = await BallotPackage.decodeAndVerify(text, pinnedStationKey: await _repo.pinnedStationKey());
      await _repo.loadBallot(pkg.signedBallot.encode(),
          stationPublicKey: pkg.stationPublicKey, media: pkg.media);
      setState(() => _error = null);
      await _refresh();
    } catch (e) {
      setState(() => _error = packageFailureText(t, e));
    }
  }

  Future<void> _start() async {
    final controller = BoothController(_repo);
    await Navigator.of(context).push(MaterialPageRoute<void>(
      fullscreenDialog: true,
      builder: (c) => PopScope(
        canPop: false,
        child: BoothScreen(
          controller: controller,
          beep: AssetBeep(),
          pollsClosed: _pollsClosed,
          onOfficerExit: () async {
            if (await _askPin(c) && c.mounted) Navigator.of(c).pop();
          },
        ),
      ),
    ));
    await _refresh();
  }

  Future<bool> _askPin(BuildContext context) async {
    final t = AppLocalizations.of(context);
    final pin = TextEditingController();
    final entered = await showDialog<String>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(t.leaveBoothTitle),
        content: TextField(
            key: const ValueKey('leave-pin'),
            controller: pin,
            obscureText: true,
            autofocus: true,
            keyboardType: TextInputType.number),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c), child: Text(t.cancel)),
          FilledButton(
              key: const ValueKey('leave-confirm'),
              onPressed: () => Navigator.pop(c, pin.text),
              child: Text(t.leaveBooth)),
        ],
      ),
    );
    pin.dispose();
    if (entered == null) return false;
    final store = await ref.read(deviceStoreProvider.future);
    return store.verifyPin(entered);
  }

  Widget _linkCard(AppLocalizations t) {
    final linkInfo = ref.watch(stationLinkProvider).value;
    if (linkInfo == null) {
      return PairCard(role: DeviceRole.booth, onPaired: (_) => _startLink());
    }
    final link = ref.watch(boothLinkProvider);
    final state = link?.state ?? BoothLinkState.disconnected;
    final ok = state == BoothLinkState.connected;
    return SectionCard(
      title: t.stationLinkTitle(linkInfo.stationName),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Row(children: [
          Icon(ok ? Icons.wifi : Icons.wifi_off, color: ok ? RakubaColors.acaciaGreen : RakubaColors.clay),
          const SizedBox(width: 8),
          Expanded(
            child: Text(ok ? t.connectedToLaptop : t.reconnecting,
                key: const ValueKey('booth-link-state'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          ),
        ]),
        Text(t.laptopIdLine(linkInfo.stationId)),
        if (link?.submittedBallots != null)
          Text(t.votesSentToLaptop('${link!.submittedBallots}'),
              style: const TextStyle(color: RakubaColors.acaciaGreen, fontWeight: FontWeight.w700)),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final signed = _signed;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: RakubaColors.ink,
        foregroundColor: RakubaColors.white,
        title: Wordmark(onDark: true, suffix: t.boothSetupTitle),
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
          constraints: const BoxConstraints(maxWidth: 640),
          child: ListView(padding: const EdgeInsets.all(24), children: [
            SectionCard(
              title: signed == null ? t.noBallotYet : t.ballotLoadedTitle,
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                if (signed != null) ...[
                  Text(t.ballotFingerprintCheck, style: const TextStyle(fontSize: 16)),
                  Text(signed.fingerprint,
                      key: const ValueKey('booth-ballot-fingerprint'),
                      style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w700, letterSpacing: 2)),
                  if (_stationId != null) Text(t.stationIdLine(_stationId!)),
                  const SizedBox(height: 8),
                  Text(t.votesOnBooth('$_votes'), key: const ValueKey('booth-votes')),
                  const SizedBox(height: 16),
                ],
                OutlinedButton.icon(
                  key: const ValueKey('load-ballot'),
                  icon: const Icon(Icons.usb),
                  label: Text(t.loadBallot),
                  onPressed: _load,
                ),
                if (_error != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(_error!,
                        key: const ValueKey('booth-load-error'),
                        style: const TextStyle(color: RakubaColors.clay, fontSize: 16)),
                  ),
              ]),
            ),
            _linkCard(t),
            if (signed != null) ...[
              NoticeBox(child: Text(t.codesNote)),
              const SizedBox(height: 16),
              FilledButton(
                key: const ValueKey('start-booth'),
                style: FilledButton.styleFrom(backgroundColor: RakubaColors.acaciaGreen),
                onPressed: _start,
                child: Text(t.startBooth),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                key: const ValueKey('save-votes-usb'),
                icon: const Icon(Icons.usb),
                label: Text(t.saveVotesUsb),
                onPressed: _saveVotesUsb,
              ),
            ],
          ]),
        ),
      ),
    );
  }
}

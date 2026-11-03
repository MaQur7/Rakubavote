import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../app/providers.dart';
import '../../core/db/registry_db.dart';
import '../../core/theme.dart';
import '../../core/widgets/common.dart';
import '../../l10n/app_localizations.dart';
import '../../station/enrollment.dart';
import '../../station/pairing.dart';
import '../../station/station_server.dart';

String roleName(AppLocalizations t, String role) => role == DeviceRole.booth.name ? t.modeBooth : t.modeCheckin;

/// The station network on the laptop: start it, pair tablets, see who is
/// connected. Everything stays on the local Wi-Fi.
class DevicesScreen extends ConsumerStatefulWidget {
  const DevicesScreen({super.key});
  @override
  ConsumerState<DevicesScreen> createState() => _DevicesScreenState();
}

class _DevicesScreenState extends ConsumerState<DevicesScreen> {
  StreamSubscription<void>? _sub;
  List<String> _addresses = const [];
  String? _error;

  StationServer get _server => ref.read(stationServerProvider);

  @override
  void initState() {
    super.initState();
    _sub = _server.changes.listen((_) {
      if (mounted) setState(() {});
    });
    StationServer.localAddresses().then((a) {
      if (mounted) setState(() => _addresses = a);
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  Future<void> _start() async {
    try {
      await _server.start();
      setState(() => _error = null);
    } catch (_) {
      setState(() => _error = AppLocalizations.of(context).errStartNetwork);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final server = ref.watch(stationServerProvider);
    final code = server.pairingCode;
    final host = _addresses.isEmpty ? '' : _addresses.first;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: RakubaColors.ink,
        foregroundColor: RakubaColors.white,
        title: Text(t.devicesTitle),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: ListView(padding: const EdgeInsets.all(RakubaSpace.m), children: [
            SectionCard(
              title: t.stationNetwork,
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Text(t.stationNetworkNote, style: rakubaText(context, RakubaType.body)),
                const SizedBox(height: RakubaSpace.s),
                if (!server.running)
                  FilledButton.icon(
                    key: const ValueKey('start-network'),
                    icon: const Icon(Icons.wifi_tethering),
                    label: Text(t.startNetwork),
                    onPressed: _start,
                  )
                else ...[
                  Text(t.networkRunning, style: rakubaText(context, RakubaType.bodyLarge, bold: true, colour: RakubaColors.acaciaGreen)),
                  const SizedBox(height: RakubaSpace.xs),
                  for (final a in _addresses)
                    SelectableText(t.laptopAddress('$a:${server.port}'), style: rakubaText(context, RakubaType.bodyLarge)),
                  if (_addresses.isEmpty) NoticeBox(child: Text(t.noWifiAddress)),
                ],
                if (_error != null)
                  Padding(
                    padding: const EdgeInsets.only(top: RakubaSpace.xs),
                    child: Text(_error!, style: const TextStyle(color: RakubaColors.clay)),
                  ),
              ]),
            ),
            if (server.running)
              SectionCard(
                title: t.addDevice,
                child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                  Text(t.addDeviceNote, style: rakubaText(context, RakubaType.body)),
                  const SizedBox(height: RakubaSpace.s),
                  if (code == null)
                    OutlinedButton(
                      key: const ValueKey('new-pairing-code'),
                      onPressed: () => setState(() => server.newPairingCode()),
                      child: Text(t.showPairingCode),
                    )
                  else
                    Wrap(spacing: RakubaSpace.m, runSpacing: RakubaSpace.s, crossAxisAlignment: WrapCrossAlignment.center, children: [
                      Container(
                        color: RakubaColors.white,
                        padding: const EdgeInsets.all(RakubaSpace.xs),
                        child: QrImageView(
                          data: Pairing.qrText(host: host, port: server.port!, code: code, stationId: server.keys.deviceId),
                          size: 200,
                        ),
                      ),
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(t.pairingCode, style: rakubaText(context, RakubaType.body)),
                        SelectableText(Pairing.formatCode(code),
                            key: const ValueKey('pairing-code'),
                            style: rakubaText(context, RakubaType.title, bold: true).copyWith(letterSpacing: 2)),
                        Text(t.laptopIdLine(server.keys.deviceId)),
                        Text(t.pairingCodeValid),
                      ]),
                    ]),
                  for (final r in server.pendingRequests) ...[
                    const SizedBox(height: RakubaSpace.s),
                    NoticeBox(
                      child: Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: RakubaSpace.s,
                        runSpacing: RakubaSpace.xs,
                        children: [
                          Text(t.pairRequestLine(r.label, roleName(t, r.role.name), r.deviceId),
                              style: rakubaText(context, RakubaType.body, bold: true)),
                          Wrap(spacing: RakubaSpace.xs, children: [
                            OutlinedButton(onPressed: () => server.reject(r.id), child: Text(t.reject)),
                            FilledButton(
                              key: ValueKey('approve-${r.deviceId}'),
                              onPressed: () async {
                                await server.approve(r.id);
                                if (mounted) setState(() {});
                              },
                              child: Text(t.approve),
                            ),
                          ]),
                        ],
                      ),
                    ),
                  ],
                ]),
              ),
            SectionCard(
              title: t.poolTitle,
              child: StreamBuilder<({int total, int remaining})>(
                stream: ref.watch(checkInServiceProvider).watchPoolStatus(),
                builder: (context, snap) {
                  final p = snap.data;
                  return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                    Text(t.poolLaptopNote, style: rakubaText(context, RakubaType.body)),
                    const SizedBox(height: RakubaSpace.xs),
                    if (p != null && p.total > 0)
                      Text(t.poolLaptopStatus('${p.remaining}', '${p.total - p.remaining}'),
                          key: const ValueKey('pool-status'), style: rakubaText(context, RakubaType.bodyLarge, bold: true)),
                    const SizedBox(height: RakubaSpace.xs),
                    OutlinedButton(
                      key: const ValueKey('prepare-pool'),
                      onPressed: () async {
                        await ref.read(checkInServiceProvider).preparePool(official: ref.read(officialProvider));
                      },
                      child: Text(t.poolPrepare),
                    ),
                  ]);
                },
              ),
            ),
            SectionCard(
              title: t.pairedDevices,
              child: StreamBuilder<List<DeviceEnrollment>>(
                stream: server.enrollment.watchActive(),
                builder: (context, snap) {
                  final list = snap.data ?? const <DeviceEnrollment>[];
                  if (list.isEmpty) return EmptyState(t.noPairedDevices);
                  return Column(children: [
                    for (final d in list)
                      ListTile(
                        minTileHeight: RakubaSizes.minTouch,
                        leading: Icon(
                          server.connectedDevices.contains(d.deviceId) ? Icons.wifi : Icons.wifi_off,
                          color: server.connectedDevices.contains(d.deviceId) ? RakubaColors.acaciaGreen : RakubaColors.border,
                        ),
                        title: Text('${d.label} · ${roleName(t, d.role)}', style: const TextStyle(fontWeight: FontWeight.w700)),
                        subtitle: Text('${t.deviceIdLine(d.deviceId)} · '
                            '${server.connectedDevices.contains(d.deviceId) ? t.connected : t.notConnected}'),
                        trailing: TextButton(
                          style: TextButton.styleFrom(foregroundColor: RakubaColors.clay),
                          onPressed: () async {
                            final ok = await showDialog<bool>(
                              context: context,
                              builder: (c) => AlertDialog(
                                content: Text(t.removeDeviceConfirm(d.label)),
                                actions: [
                                  TextButton(onPressed: () => Navigator.pop(c, false), child: Text(t.cancel)),
                                  FilledButton(onPressed: () => Navigator.pop(c, true), child: Text(t.removeDevice)),
                                ],
                              ),
                            );
                            if (ok == true) await server.enrollment.revoke(d.deviceId, official: ref.read(officialProvider));
                          },
                          child: Text(t.removeDevice),
                        ),
                      ),
                  ]);
                },
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

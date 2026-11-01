import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../core/theme.dart';
import '../../core/widgets/common.dart';
import '../../l10n/app_localizations.dart';
import '../../platform/qr_scan.dart';
import '../../station/enrollment.dart';
import '../../station/pairing.dart';
import '../../station/station_client.dart';
import '../common_errors.dart';

/// Connects a booth or check-in tablet to the station laptop.
class PairCard extends ConsumerStatefulWidget {
  const PairCard({super.key, required this.role, this.onPaired});
  final DeviceRole role;
  final Future<void> Function(StationLink link)? onPaired;

  @override
  ConsumerState<PairCard> createState() => _PairCardState();
}

class _PairCardState extends ConsumerState<PairCard> {
  final _address = TextEditingController();
  final _code = TextEditingController();
  String? _expectedStation;
  String? _waitingId;
  String? _error;
  bool _busy = false;

  @override
  void dispose() {
    _address.dispose();
    _code.dispose();
    super.dispose();
  }

  Future<void> _scan() async {
    final t = AppLocalizations.of(context);
    final text = await scanQrWithCamera(context, title: t.scanLaptopQr);
    final p = text == null ? null : Pairing.parseQr(text);
    if (p == null) return;
    _address.text = '${p.host}:${p.port}';
    _code.text = Pairing.formatCode(p.code);
    _expectedStation = p.stationId;
    await _connect();
  }

  Future<void> _connect() async {
    final t = AppLocalizations.of(context);
    final parts = _address.text.trim().split(':');
    final code = Pairing.normaliseCode(_code.text);
    if (parts.first.isEmpty || code == null) {
      setState(() => _error = t.errPairingCode);
      return;
    }
    final session = ref.read(sessionProvider)!;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final link = await pairWithStation(
        host: parts.first,
        port: parts.length > 1 ? int.tryParse(parts[1]) ?? 47800 : 47800,
        code: code,
        role: widget.role,
        label: '${widget.role == DeviceRole.booth ? t.modeBooth : t.modeCheckin} · ${session.official}',
        keys: session.keys,
        expectedStationId: _expectedStation,
        onWaiting: (id) {
          if (mounted) setState(() => _waitingId = id);
        },
      );
      await ref.read(stationLinkProvider.notifier).save(link);
      await widget.onPaired?.call(link);
    } catch (err) {
      if (mounted) setState(() => _error = describeError(t, err));
    } finally {
      if (mounted) {
        setState(() {
          _busy = false;
          _waitingId = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return SectionCard(
      title: t.connectToLaptop,
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Text(t.connectToLaptopNote, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 12),
        if (canScanWithCamera) ...[
          FilledButton.icon(
            key: const ValueKey('scan-laptop-qr'),
            icon: const Icon(Icons.qr_code_scanner),
            label: Text(t.scanLaptopQr),
            onPressed: _busy ? null : _scan,
          ),
          const SizedBox(height: 8),
        ],
        FieldLabel(t.laptopAddressField),
        TextField(
          key: const ValueKey('pair-address'),
          controller: _address,
          keyboardType: TextInputType.url,
          decoration: const InputDecoration(hintText: '192.168.8.10:47800'),
        ),
        FieldLabel(t.pairingCode),
        TextField(key: const ValueKey('pair-code'), controller: _code, textCapitalization: TextCapitalization.characters),
        const SizedBox(height: 12),
        OutlinedButton(key: const ValueKey('pair-connect'), onPressed: _busy ? null : _connect, child: Text(t.connect)),
        if (_waitingId != null) ...[
          const SizedBox(height: 12),
          NoticeBox(child: Text(t.waitingApproval(_waitingId!), key: const ValueKey('pair-waiting'))),
        ],
        if (_error != null)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Text(_error!, style: const TextStyle(color: RakubaColors.clay, fontSize: 16)),
          ),
      ]),
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../core/crypto/voter_card_code.dart';
import '../../core/crypto/voting_token.dart';
import '../../core/format.dart';
import '../../core/theme.dart';
import '../../core/widgets/common.dart';
import '../../l10n/app_localizations.dart';
import '../common_errors.dart';
import '../../platform/qr_scan.dart';
import 'checkin_backend.dart';
import 'checkin_service.dart';

/// Mockup 1: the check-in desk. Find the voter by card or name, compare
/// the photo, confirm, and give the one-time code.
class CheckInScreen extends ConsumerStatefulWidget {
  const CheckInScreen({super.key, required this.stationName, this.onBack});
  final String stationName;
  final VoidCallback? onBack;

  @override
  ConsumerState<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends ConsumerState<CheckInScreen> {
  final _query = TextEditingController();
  final _focus = FocusNode();
  Timer? _debounce;
  List<VoterView> _results = const [];
  VoterView? _selected;
  String? _method;
  String? _notice;
  String? _token;
  bool _busy = false;

  @override
  void dispose() {
    _debounce?.cancel();
    _query.dispose();
    _focus.dispose();
    super.dispose();
  }

  CheckInBackend get _svc => ref.read(checkInBackendProvider);

  void _reset() {
    _debounce?.cancel();
    _query.clear();
    setState(() {
      _results = const [];
      _selected = null;
      _method = null;
      _notice = null;
      _token = null;
    });
    _focus.requestFocus();
  }

  void _onChanged(String text) {
    _debounce?.cancel();
    if (text.trim().startsWith('${VoterCardCode.prefix}.')) return; // wait for Enter from the scanner
    _debounce = Timer(const Duration(milliseconds: 250), () => _search(text));
  }

  Future<void> _search(String text) async {
    final List<VoterView> r;
    try {
      r = await _svc.search(text);
    } catch (err) {
      if (mounted) setState(() => _notice = describeError(AppLocalizations.of(context), err));
      return;
    }
    if (!mounted) return;
    setState(() {
      _token = null;
      _results = r;
      _notice = r.isEmpty && text.trim().isNotEmpty ? AppLocalizations.of(context).noVotersFound : null;
      _selected = r.length == 1 ? r.first : null;
      _method = 'name';
    });
  }

  Future<void> _onSubmitted(String text) async {
    final t = AppLocalizations.of(context);
    if (!text.trim().startsWith('${VoterCardCode.prefix}.')) return _search(text);
    final CardView r;
    try {
      r = await _svc.lookupCard(text.trim());
    } catch (err) {
      if (mounted) setState(() => _notice = describeError(t, err));
      return;
    }
    if (!mounted) return;
    setState(() {
      _token = null;
      _results = const [];
      _method = 'qr';
      _selected = null;
      _notice = switch (r.result) {
        CardResult.valid => null,
        CardResult.replaced => t.cardReplaced,
        CardResult.invalid => t.cardInvalid,
        CardResult.notOnRegister => t.cardNotOnRegister,
      };
    });
    if (r.result == CardResult.valid) setState(() => _selected = r.voter);
  }

  Future<void> _issue() async {
    final t = AppLocalizations.of(context);
    final v = _selected!;
    setState(() => _busy = true);
    try {
      final token = await _svc.checkIn(v.id, method: _method ?? 'name');
      setState(() {
        _token = token;
        _selected = v.withCheckedIn(true);
      });
      // Printing the slip comes in milestone 7.
    } catch (err) {
      if (mounted) showMessage(context, describeError(t, err));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _manual() async {
    final token = await showDialog<String>(context: context, builder: (_) => const _ManualCheckInDialog());
    if (token != null && mounted) {
      setState(() {
        _token = token;
        _selected = null;
        _results = const [];
        _notice = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return Scaffold(
      body: Column(children: [
        Material(
          color: RakubaColors.ink,
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(RakubaSpace.s, RakubaSpace.s, RakubaSpace.s, RakubaSpace.s),
              child: Row(children: [
                if (widget.onBack != null)
                  IconButton(
                    tooltip: t.backToAdmin,
                    style: onDarkStyle(),
                    icon: const BackButtonIcon(),
                    onPressed: widget.onBack,
                  ),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(t.officialUseOnly, style: rakubaText(context, RakubaType.label, colour: RakubaColors.lightThatch)),
                    Text(t.checkinDeskTitle(widget.stationName),
                        style: rakubaText(context, RakubaType.heading, bold: true, colour: RakubaColors.white)),
                  ]),
                ),
                StatusPill(t.offlineSavedLaptop),
              ]),
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 680),
              child: ListView(padding: const EdgeInsets.all(RakubaSpace.m), children: [
                StreamBuilder<({int checkedIn, int registered})>(
                  stream: ref.watch(checkInBackendProvider).counts(),
                  builder: (context, s) => Text(
                    s.data == null ? '' : t.checkedInCount('${s.data!.checkedIn}', '${s.data!.registered}'),
                    key: const ValueKey('checkin-count'),
                    style: rakubaText(context, RakubaType.body),
                  ),
                ),
                FieldLabel(t.findVoter),
                if (canScanWithCamera)
                  Padding(
                    padding: const EdgeInsets.only(bottom: RakubaSpace.xs),
                    child: OutlinedButton.icon(
                      key: const ValueKey('scan-card'),
                      icon: const Icon(Icons.qr_code_scanner),
                      label: Text(t.scanQrCard),
                      onPressed: () async {
                        final text = await scanQrWithCamera(context, title: t.scanQrCard);
                        if (text != null) {
                          _query.text = text;
                          await _onSubmitted(text);
                        }
                      },
                    ),
                  ),
                TextField(
                  key: const ValueKey('checkin-query'),
                  controller: _query,
                  focusNode: _focus,
                  autofocus: true,
                  style: rakubaText(context, RakubaType.heading),
                  decoration: InputDecoration(hintText: t.nameOrVoterNumber),
                  onChanged: _onChanged,
                  onSubmitted: _onSubmitted,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: RakubaSpace.xs),
                  child: MutedText(t.scanHint),
                ),
                if (_notice != null) ...[
                  const SizedBox(height: RakubaSpace.s),
                  NoticeBox(child: Text(_notice!, key: const ValueKey('checkin-notice'), style: rakubaText(context, RakubaType.body))),
                ],
                if (_results.length > 1)
                  Padding(
                    padding: const EdgeInsets.only(top: RakubaSpace.s),
                    child: Card(
                      child: Column(children: [
                        for (final r in _results)
                          ListTile(
                            minTileHeight: RakubaSizes.minTouch,
                            leading: PhotoBox(bytes: r.photo, size: 44),
                            title: Text(r.fullName),
                            subtitle: Text('${t.voterNoLine(voterNoLabel(r.voterNo))} · ${r.groupName}'),
                            trailing: r.checkedIn
                                ? Text(t.statusCheckedIn, style: rakubaText(context, RakubaType.label, bold: true, colour: RakubaColors.clay))
                                : null,
                            selected: _selected?.id == r.id,
                            onTap: () => setState(() {
                              _selected = r;
                              _token = null;
                            }),
                          ),
                      ]),
                    ),
                  ),
                if (_selected != null) ...[
                  const SizedBox(height: RakubaSpace.s),
                  _VoterCard(
                    status: _selected!,
                    busy: _busy,
                    issued: _token != null,
                    onIssue: _issue,
                  ),
                ],
                if (_token != null) ...[
                  const SizedBox(height: RakubaSpace.s),
                  _TokenBox(token: _token!),
                  const SizedBox(height: RakubaSpace.s),
                  FilledButton(key: const ValueKey('next-voter'), onPressed: _reset, child: Text(t.nextVoter)),
                ],
                const SizedBox(height: RakubaSpace.s),
                SectionCard(
                  child: Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: RakubaSpace.s,
                    runSpacing: RakubaSpace.s,
                    children: [
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 420),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(t.manualTitle, style: rakubaText(context, RakubaType.bodyLarge, bold: true)),
                          Text(t.manualText, style: rakubaText(context, RakubaType.body)),
                        ]),
                      ),
                      OutlinedButton(
                        key: const ValueKey('manual-checkin'),
                        style: destructiveOutlinedStyle(),
                        onPressed: _manual,
                        child: Text(t.manualCheckin),
                      ),
                    ],
                  ),
                ),
              ]),
            ),
          ),
        ),
      ]),
    );
  }
}

class _VoterCard extends StatelessWidget {
  const _VoterCard({required this.status, required this.busy, required this.issued, required this.onIssue});
  final VoterView status;
  final bool busy;
  final bool issued;
  final VoidCallback onIssue;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final v = status;
    return SectionCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          PhotoBox(bytes: v.photo, size: 140, label: t.photoFromRegistration),
          const SizedBox(width: RakubaSpace.m),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(v.fullName,
                  key: const ValueKey('checkin-voter-name'),
                  style: rakubaText(context, RakubaType.name, bold: true)),
              const SizedBox(height: RakubaSpace.xs),
              Text(t.voterNoLine(voterNoLabel(v.voterNo)), style: rakubaText(context, RakubaType.bodyLarge)),
              if (v.groupName.isNotEmpty) Text(v.groupName, style: rakubaText(context, RakubaType.body)),
              const SizedBox(height: RakubaSpace.xs),
              Text(
                issued
                    ? t.statusJustCheckedIn
                    : (status.checkedIn ? t.statusCheckedIn : t.statusNotVoted),
                key: const ValueKey('checkin-status'),
                style: rakubaText(context, RakubaType.body, bold: true, colour: status.checkedIn && !issued ? RakubaColors.clay : RakubaColors.acaciaGreen),
              ),
            ]),
          ),
        ]),
        if (!status.checkedIn) ...[
          const SizedBox(height: RakubaSpace.s),
          Text(t.comparePhoto, style: rakubaText(context, RakubaType.body)),
          const SizedBox(height: RakubaSpace.s),
          FilledButton(
            key: const ValueKey('issue-token'),
            onPressed: busy ? null : onIssue,
            child: Text(t.confirmIssueToken),
          ),
        ] else if (!issued) ...[
          const SizedBox(height: RakubaSpace.s),
          NoticeBox(child: Text(t.alreadyHasToken, style: rakubaText(context, RakubaType.body))),
        ],
      ]),
    );
  }
}

class _TokenBox extends StatelessWidget {
  const _TokenBox({required this.token});
  final String token;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    // Like a paper slip: white with an Ink edge. The code is the result of
    // check-in, not a warning.
    return Container(
      padding: const EdgeInsets.all(RakubaSpace.m),
      decoration: BoxDecoration(
        color: RakubaColors.card,
        borderRadius: BorderRadius.circular(RakubaRadius.panel),
        border: Border.all(color: RakubaColors.ink, width: RakubaLine.strong),
      ),
      child: Column(children: [
        Text(t.tokenTitle, style: rakubaText(context, RakubaType.body, bold: true)),
        const SizedBox(height: RakubaSpace.xs),
        Text(
          VotingToken.format(token),
          key: const ValueKey('issued-token'),
          // Codes are Latin letters and digits in every language.
          textDirection: TextDirection.ltr,
          style: rakubaText(context, RakubaType.display, bold: true)
              .copyWith(letterSpacing: RakubaSpace.xs, fontFeatures: const [FontFeature.tabularFigures()]),
        ),
        const SizedBox(height: RakubaSpace.xs),
        Text(t.tokenNote, textAlign: TextAlign.center, style: rakubaText(context, RakubaType.body)),
      ]),
    );
  }
}

class _ManualCheckInDialog extends ConsumerStatefulWidget {
  const _ManualCheckInDialog();
  @override
  ConsumerState<_ManualCheckInDialog> createState() => _ManualCheckInDialogState();
}

class _ManualCheckInDialogState extends ConsumerState<_ManualCheckInDialog> {
  final _number = TextEditingController();
  final _details = TextEditingController();
  ManualReason? _reason;
  String? _error;
  VoterView? _found;

  @override
  void dispose() {
    _number.dispose();
    _details.dispose();
    super.dispose();
  }

  String _reasonText(AppLocalizations t, ManualReason r) => switch (r) {
        ManualReason.cardLost => t.reasonCardLost,
        ManualReason.cardUnreadable => t.reasonCardUnreadable,
        ManualReason.photoMissing => t.reasonPhotoMissing,
        ManualReason.deviceProblem => t.reasonDeviceProblem,
        ManualReason.other => t.reasonOther,
      };

  Future<void> _lookup(String text) async {
    final n = int.tryParse(text.trim());
    List<VoterView> r = const [];
    if (n != null) {
      try {
        r = await ref.read(checkInBackendProvider).search('$n');
      } catch (_) {
        r = const [];
      }
    }
    if (mounted) setState(() => _found = r.where((v) => v.voterNo == n).firstOrNull);
  }

  Future<void> _submit() async {
    final t = AppLocalizations.of(context);
    final n = int.tryParse(_number.text.trim());
    if (n == null || _reason == null) {
      setState(() => _error = t.errReasonRequired);
      return;
    }
    try {
      final token = await ref.read(checkInBackendProvider).manualCheckIn(n, reason: _reason!, details: _details.text);
      if (mounted) Navigator.pop(context, token);
    } catch (err) {
      setState(() => _error = describeError(t, err));
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(t.manualCheckin),
      content: SizedBox(
        width: 460,
        child: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            FieldLabel(t.manualVoterNo),
            TextField(
              key: const ValueKey('manual-number'),
              controller: _number,
              keyboardType: TextInputType.number,
              onChanged: _lookup,
            ),
            if (_found != null)
              Padding(
                padding: const EdgeInsets.only(top: RakubaSpace.xs),
                child: Row(children: [
                  PhotoBox(bytes: _found!.photo, size: 56),
                  const SizedBox(width: RakubaSpace.s),
                  Expanded(
                      child: Text(_found!.fullName,
                          style: rakubaText(context, RakubaType.bodyLarge, bold: true))),
                ]),
              ),
            FieldLabel(t.manualReason),
            RadioGroup<ManualReason>(
              groupValue: _reason,
              onChanged: (v) => setState(() => _reason = v),
              child: Column(children: [
                for (final r in ManualReason.values)
                  RadioListTile<ManualReason>(
                    key: ValueKey('reason-${r.name}'),
                    contentPadding: EdgeInsets.zero,
                    value: r,
                    title: Text(_reasonText(t, r)),
                  ),
              ]),
            ),
            FieldLabel(t.manualDetails),
            TextField(key: const ValueKey('manual-details'), controller: _details, maxLines: 2),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(top: RakubaSpace.s),
                child: Text(_error!, style: rakubaText(context, RakubaType.body, bold: true, colour: RakubaColors.clay)),
              ),
          ]),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text(t.cancel)),
        FilledButton(key: const ValueKey('manual-submit'), onPressed: _submit, child: Text(t.confirmIssueToken)),
      ],
    );
  }
}

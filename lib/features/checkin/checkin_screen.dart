import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../core/crypto/voter_card_code.dart';
import '../../core/crypto/voting_token.dart';
import '../../core/db/registry_db.dart';
import '../../core/format.dart';
import '../../core/theme.dart';
import '../../core/widgets/common.dart';
import '../../l10n/app_localizations.dart';
import '../common_errors.dart';
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
  List<VoterStatus> _results = const [];
  VoterStatus? _selected;
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

  CheckInService get _svc => ref.read(checkInServiceProvider);

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
    final r = await _svc.search(text);
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
    final r = await _svc.lookupCard(text.trim());
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
    if (r.result == CardResult.valid) {
      final checked = await _svc.isCheckedIn(r.voter!.id);
      if (mounted) setState(() => _selected = VoterStatus(r.voter!, checked));
    }
  }

  Future<void> _issue() async {
    final t = AppLocalizations.of(context);
    final v = _selected!;
    setState(() => _busy = true);
    try {
      final token = await _svc.checkIn(v.voter.id, method: _method ?? 'name', official: ref.read(officialProvider));
      setState(() {
        _token = token;
        _selected = VoterStatus(v.voter, true);
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
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Row(children: [
                if (widget.onBack != null)
                  IconButton(
                    tooltip: t.backToAdmin,
                    color: RakubaColors.white,
                    icon: const BackButtonIcon(),
                    onPressed: widget.onBack,
                  ),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(t.officialUseOnly, style: const TextStyle(color: RakubaColors.lightThatch, fontSize: 14)),
                    Text(t.checkinDeskTitle(widget.stationName),
                        style: const TextStyle(color: RakubaColors.white, fontSize: 22, fontWeight: FontWeight.w700)),
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
              child: ListView(padding: const EdgeInsets.all(24), children: [
                StreamBuilder<({int checkedIn, int registered})>(
                  stream: ref.watch(checkInServiceProvider).watchCounts(),
                  builder: (context, s) => Text(
                    s.data == null ? '' : t.checkedInCount('${s.data!.checkedIn}', '${s.data!.registered}'),
                    key: const ValueKey('checkin-count'),
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                FieldLabel(t.findVoter),
                TextField(
                  key: const ValueKey('checkin-query'),
                  controller: _query,
                  focusNode: _focus,
                  autofocus: true,
                  style: const TextStyle(fontSize: 20),
                  decoration: InputDecoration(hintText: t.nameOrVoterNumber),
                  onChanged: _onChanged,
                  onSubmitted: _onSubmitted,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(t.scanHint, style: const TextStyle(fontSize: RakubaSizes.label)),
                ),
                if (_notice != null) ...[
                  const SizedBox(height: 12),
                  NoticeBox(child: Text(_notice!, key: const ValueKey('checkin-notice'), style: const TextStyle(fontSize: 16))),
                ],
                if (_results.length > 1)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Card(
                      child: Column(children: [
                        for (final r in _results)
                          ListTile(
                            minTileHeight: RakubaSizes.minTouch,
                            leading: PhotoBox(bytes: r.voter.photo, size: 44),
                            title: Text(r.voter.fullName, style: const TextStyle(fontWeight: FontWeight.w700)),
                            subtitle: Text('${t.voterNoLine(voterNoLabel(r.voter.voterNo))} · ${r.voter.groupName}'),
                            trailing: r.checkedIn
                                ? Text(t.statusCheckedIn, style: const TextStyle(color: RakubaColors.clay))
                                : null,
                            selected: _selected?.voter.id == r.voter.id,
                            onTap: () => setState(() {
                              _selected = r;
                              _token = null;
                            }),
                          ),
                      ]),
                    ),
                  ),
                if (_selected != null) ...[
                  const SizedBox(height: 16),
                  _VoterCard(
                    status: _selected!,
                    busy: _busy,
                    issued: _token != null,
                    onIssue: _issue,
                  ),
                ],
                if (_token != null) ...[
                  const SizedBox(height: 16),
                  _TokenBox(token: _token!),
                  const SizedBox(height: 12),
                  FilledButton(key: const ValueKey('next-voter'), onPressed: _reset, child: Text(t.nextVoter)),
                ],
                const SizedBox(height: 16),
                SectionCard(
                  child: Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 420),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(t.manualTitle, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                          Text(t.manualText, style: const TextStyle(fontSize: 16)),
                        ]),
                      ),
                      OutlinedButton(
                        key: const ValueKey('manual-checkin'),
                        style: OutlinedButton.styleFrom(
                            foregroundColor: RakubaColors.clay,
                            side: const BorderSide(color: RakubaColors.clay, width: 2)),
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
  final VoterStatus status;
  final bool busy;
  final bool issued;
  final VoidCallback onIssue;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final v = status.voter;
    return SectionCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          PhotoBox(bytes: v.photo, size: 140, label: t.photoFromRegistration),
          const SizedBox(width: 20),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(v.fullName,
                  key: const ValueKey('checkin-voter-name'),
                  style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              Text(t.voterNoLine(voterNoLabel(v.voterNo)), style: const TextStyle(fontSize: 18)),
              if (v.groupName.isNotEmpty) Text(v.groupName, style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 6),
              Text(
                issued
                    ? t.statusJustCheckedIn
                    : (status.checkedIn ? t.statusCheckedIn : t.statusNotVoted),
                key: const ValueKey('checkin-status'),
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: status.checkedIn && !issued ? RakubaColors.clay : RakubaColors.acaciaGreen),
              ),
            ]),
          ),
        ]),
        if (!status.checkedIn) ...[
          const SizedBox(height: 16),
          Text(t.comparePhoto, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 12),
          FilledButton(
            key: const ValueKey('issue-token'),
            onPressed: busy ? null : onIssue,
            child: Text(t.confirmIssueToken),
          ),
        ] else if (!issued) ...[
          const SizedBox(height: 12),
          NoticeBox(child: Text(t.alreadyHasToken, style: const TextStyle(fontSize: 16))),
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
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: RakubaColors.warningTint,
        borderRadius: BorderRadius.circular(RakubaSizes.cardRadius),
        border: Border.all(color: RakubaColors.thatchGold, width: 2),
      ),
      child: Column(children: [
        Text(t.tokenTitle, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        Text(
          VotingToken.format(token),
          key: const ValueKey('issued-token'),
          // Codes are Latin letters and digits in every language.
          textDirection: TextDirection.ltr,
          style: const TextStyle(fontSize: 52, fontWeight: FontWeight.w700, letterSpacing: 6),
        ),
        const SizedBox(height: 8),
        Text(t.tokenNote, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16)),
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
  Voter? _found;

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
    final r = n == null ? const <VoterStatus>[] : await ref.read(checkInServiceProvider).search('$n');
    if (mounted) setState(() => _found = r.isEmpty ? null : r.first.voter);
  }

  Future<void> _submit() async {
    final t = AppLocalizations.of(context);
    final n = int.tryParse(_number.text.trim());
    if (n == null || _reason == null) {
      setState(() => _error = t.errReasonRequired);
      return;
    }
    try {
      final token = await ref.read(checkInServiceProvider).manualCheckIn(n,
          reason: _reason!, details: _details.text, official: ref.read(officialProvider));
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
                padding: const EdgeInsets.only(top: 8),
                child: Row(children: [
                  PhotoBox(bytes: _found!.photo, size: 56),
                  const SizedBox(width: 12),
                  Expanded(
                      child: Text(_found!.fullName,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700))),
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
                padding: const EdgeInsets.only(top: 12),
                child: Text(_error!, style: const TextStyle(color: RakubaColors.clay, fontSize: 16)),
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

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../core/db/registry_db.dart';
import '../../core/format.dart';
import '../../core/theme.dart';
import '../../core/widgets/common.dart';
import '../../l10n/app_localizations.dart';
import '../../platform/photo_capture.dart';
import '../../printing/print_dialogs.dart';
import '../common_errors.dart';
import 'duplicates.dart';
import 'registration_service.dart';

/// Mockup B: register a voter on the left, the register on the right.
class RegistrationScreen extends ConsumerWidget {
  const RegistrationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context);
    return StreamBuilder<Election?>(
      stream: ref.watch(electionServiceProvider).watchElection(),
      builder: (context, snap) {
        final e = snap.data;
        if (e == null) {
          return Center(
            child: Text(t.errNoElection, style: rakubaText(context, RakubaType.bodyLarge)),
          );
        }
        return LayoutBuilder(
          builder: (context, c) {
            final form = RegisterVoterForm(election: e);
            final list = VoterList(election: e);
            if (c.maxWidth >= 900) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 380,
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(RakubaSpace.m, RakubaSpace.s, RakubaSpace.xs, RakubaSpace.m),
                      children: [form],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(RakubaSpace.xs, RakubaSpace.s, RakubaSpace.m, RakubaSpace.m),
                      child: list,
                    ),
                  ),
                ],
              );
            }
            return ListView(
              padding: const EdgeInsets.all(RakubaSpace.s),
              children: [
                form,
                SizedBox(height: 600, child: list),
              ],
            );
          },
        );
      },
    );
  }
}

class RegisterVoterForm extends ConsumerStatefulWidget {
  const RegisterVoterForm({super.key, required this.election});
  final Election election;
  @override
  ConsumerState<RegisterVoterForm> createState() => _RegisterVoterFormState();
}

class _RegisterVoterFormState extends ConsumerState<RegisterVoterForm> {
  final _name = TextEditingController();
  final _memberId = TextEditingController();
  final _group = TextEditingController();
  final _receipt = TextEditingController();
  Uint8List? _photo;
  bool _paid = false;
  String _currency = 'SSP';
  List<DuplicateMatch> _dups = const [];
  Timer? _debounce;
  String? _error;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    for (final c in [_name, _memberId, _group]) {
      c.addListener(_scheduleDuplicateCheck);
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    for (final c in [_name, _memberId, _group, _receipt]) {
      c.dispose();
    }
    super.dispose();
  }

  void _scheduleDuplicateCheck() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () async {
      if (_name.text.trim().isEmpty && _memberId.text.trim().isEmpty) {
        if (mounted) setState(() => _dups = const []);
        return;
      }
      final d = await ref
          .read(registrationServiceProvider)
          .findDuplicates(
            widget.election.id,
            fullName: _name.text,
            memberId: _memberId.text,
            groupName: _group.text,
          );
      if (mounted) setState(() => _dups = d);
    });
  }

  void _clear() {
    _debounce?.cancel();
    for (final c in [_name, _memberId, _group, _receipt]) {
      c.clear();
    }
    setState(() {
      _photo = null;
      _paid = false;
      _dups = const [];
      _error = null;
    });
  }

  Future<void> _save(FeeConfig? fee) async {
    final t = AppLocalizations.of(context);
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final r = await ref
          .read(registrationServiceProvider)
          .register(
            widget.election.id,
            VoterInput(
              fullName: _name.text,
              memberId: _memberId.text,
              groupName: _group.text,
              photo: _photo,
              feePaid: _paid,
              feeCurrency: fee?.currency == 'EITHER' ? _currency : null,
              receiptNo: _receipt.text,
            ),
            official: ref.read(officialProvider),
          );
      _clear();
      if (mounted) showMessage(context, t.voterSaved(voterNoLabel(r.voterNo)));
      if (mounted) await printVoterCards(context, ref, [r.id]);
    } on RegistrationException catch (e) {
      setState(() => _error = registrationFailureText(t, e.failure));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final e = widget.election;
    return StreamBuilder<FeeConfig>(
      stream: ref.watch(electionServiceProvider).watchFeeConfig(e.id),
      builder: (context, feeSnap) {
        final fee = feeSnap.data;
        return SectionCard(
          title: t.registerAVoter,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PhotoBox(bytes: _photo, size: 110, label: t.photo),
                  const SizedBox(width: RakubaSpace.s),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        FilledButton(
                          key: const ValueKey('reg-photo'),
                          onPressed: () async {
                            try {
                              final b = await capturePhoto();
                              if (b != null) setState(() => _photo = b);
                            } catch (_) {
                              if (context.mounted) {
                                showMessage(context, t.photoFailed);
                              }
                            }
                          },
                          child: Text(t.takePhoto),
                        ),
                        const SizedBox(height: RakubaSpace.xs),
                        Text(
                          t.photoUse,
                          style: rakubaText(context, RakubaType.label),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              FieldLabel(t.fullName),
              TextField(
                key: const ValueKey('reg-name'),
                controller: _name,
                decoration: InputDecoration(hintText: t.fullNameHint),
              ),
              FieldLabel(e.idLabel),
              TextField(key: const ValueKey('reg-id'), controller: _memberId),
              FieldLabel(e.groupLabel),
              TextField(key: const ValueKey('reg-group'), controller: _group),
              if (fee != null && fee.enabled) ...[
                const SizedBox(height: RakubaSpace.s),
                Container(
                  padding: const EdgeInsets.all(RakubaSpace.s),
                  decoration: BoxDecoration(
                    color: RakubaColors.paper,
                    borderRadius: BorderRadius.circular(RakubaRadius.control),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              t.feeLine(
                                '${fee.amount}',
                                fee.currency == 'EITHER'
                                    ? t.currencyEither
                                    : fee.currency,
                              ),
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Checkbox(
                            key: const ValueKey('reg-paid'),
                            value: _paid,
                            onChanged: (v) =>
                                setState(() => _paid = v ?? false),
                          ),
                          Text(t.paid),
                        ],
                      ),
                      if (_paid) ...[
                        if (fee.currency == 'EITHER')
                          SegmentedButton<String>(
                            segments: const [
                              ButtonSegment(value: 'SSP', label: Text('SSP')),
                              ButtonSegment(value: 'USD', label: Text('USD')),
                            ],
                            selected: {_currency},
                            onSelectionChanged: (s) =>
                                setState(() => _currency = s.first),
                          ),
                        FieldLabel(t.receiptNo),
                        TextField(
                          key: const ValueKey('reg-receipt'),
                          controller: _receipt,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
              if (_dups.isNotEmpty) ...[
                const SizedBox(height: RakubaSpace.s),
                NoticeBox(
                  key: const ValueKey('reg-duplicate'),
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '${t.possibleDuplicate} ',
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        TextSpan(
                          text:
                              _dups.first.reason == DuplicateReason.sameMemberId
                              ? t.duplicateIdText(
                                  voterNoLabel(_dups.first.voterNo),
                                )
                              : t.duplicateNameText(
                                  voterNoLabel(_dups.first.voterNo),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.only(top: RakubaSpace.s),
                  child: Text(
                    _error!,
                    key: const ValueKey('reg-error'),
                    style: rakubaText(context, RakubaType.body, colour: RakubaColors.clay),
                  ),
                ),
              const SizedBox(height: RakubaSpace.s),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(onPressed: _clear, child: Text(t.clear)),
                  const SizedBox(width: RakubaSpace.s),
                  Flexible(
                    child: FilledButton(
                      key: const ValueKey('reg-save'),
                      style: FilledButton.styleFrom(
                        backgroundColor: RakubaColors.acaciaGreen,
                      ),
                      onPressed: _busy ? null : () => _save(fee),
                      child: Text(t.saveAndPrintCard),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class VoterList extends ConsumerStatefulWidget {
  const VoterList({super.key, required this.election});
  final Election election;
  @override
  ConsumerState<VoterList> createState() => _VoterListState();
}

class _VoterListState extends ConsumerState<VoterList> {
  String _query = '';

  Future<void> _import() async {
    final t = AppLocalizations.of(context);
    final text = await pickCsvText();
    if (text == null) return;
    try {
      final r = await ref
          .read(registrationServiceProvider)
          .importCsv(
            widget.election.id,
            text,
            official: ref.read(officialProvider),
          );
      if (!mounted) return;
      await showDialog<void>(
        context: context,
        builder: (c) => AlertDialog(
          title: Text(t.importCsv),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t.importDone(
                    '${r.importedVoterNos.length}',
                    '${r.skipped.length}',
                    '${r.possibleDuplicates.length}',
                  ),
                ),
                for (final s in r.skipped)
                  Text(
                    t.importSkippedLine('${s.line}', _skipReason(t, s.reason)),
                  ),
              ],
            ),
          ),
          actions: [
            FilledButton(onPressed: () => Navigator.pop(c), child: Text(t.ok)),
          ],
        ),
      );
    } on RegistrationException catch (e) {
      if (mounted) showMessage(context, registrationFailureText(t, e.failure));
    }
  }

  String _skipReason(AppLocalizations t, String code) {
    for (final f in RegistrationFailure.values) {
      if (f.name == code) return registrationFailureText(t, f);
    }
    return code == 'Name is empty.' ? t.errNameRequired : code;
  }

  Future<void> _backup() async {
    final t = AppLocalizations.of(context);
    final path = await pickFolder();
    if (path == null) return;
    try {
      final store = await ref.read(deviceStoreProvider.future);
      final out = await store.backup(
        ref.read(sessionProvider)!,
        Directory(path),
      );
      if (mounted) showMessage(context, t.backupDone(out.path));
    } catch (_) {
      if (mounted) showMessage(context, t.backupFailed);
    }
  }

  Future<void> _feeSummary() async {
    final t = AppLocalizations.of(context);
    final fee = await ref
        .read(electionServiceProvider)
        .feeConfig(widget.election.id);
    final s = await ref
        .read(registrationServiceProvider)
        .feeSummary(widget.election.id);
    if (!mounted) return;
    await showDialog<void>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(t.feeSummary),
        content: !fee.enabled
            ? Text(t.noFee)
            : Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    t.totalsByCurrency,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  for (final e in s.byCurrency.entries)
                    Text('${e.key}: ${e.value}'),
                  const SizedBox(height: RakubaSpace.s),
                  Text(
                    t.totalsByOfficial,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  for (final o in s.byOfficial.entries)
                    Text(
                      '${o.key}: ${o.value.entries.map((e) => '${e.value} ${e.key}').join(', ')}',
                    ),
                  const SizedBox(height: RakubaSpace.s),
                  Text(t.paidCount('${s.paidCount}')),
                  Text(t.unpaidCount('${s.unpaidCount}')),
                  Text(t.flaggedCount('${s.flaggedCount}')),
                ],
              ),
        actions: [
          FilledButton(onPressed: () => Navigator.pop(c), child: Text(t.close)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final reg = ref.watch(registrationServiceProvider);
    final e = widget.election;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(RakubaSpace.s),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    t.registeredVoters,
                    style: rakubaText(context, RakubaType.heading, bold: true),
                  ),
                ),
                SizedBox(
                  width: 240,
                  child: TextField(
                    key: const ValueKey('voter-search'),
                    decoration: InputDecoration(
                      hintText: t.searchNameOrNumber,
                      isDense: true,
                    ),
                    onChanged: (v) => setState(() => _query = v),
                  ),
                ),
              ],
            ),
            const SizedBox(height: RakubaSpace.s),
            Expanded(
              child: StreamBuilder<List<Voter>>(
                stream: reg.watchVoters(e.id, query: _query),
                builder: (context, snap) {
                  final voters = snap.data ?? const <Voter>[];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _header(t),
                      Expanded(
                        child: ListView.builder(
                          itemCount: voters.length,
                          itemBuilder: (context, i) =>
                              _VoterRow(voter: voters[i]),
                        ),
                      ),
                      const SizedBox(height: RakubaSpace.xs),
                      FutureBuilder<int>(
                        future: reg.voterCount(e.id),
                        builder: (context, c) => Text(
                          t.showingVoters(
                            '${voters.length}',
                            '${c.data ?? voters.length}',
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            const Divider(height: 24),
            Wrap(
              alignment: WrapAlignment.end,
              spacing: RakubaSpace.s,
              runSpacing: RakubaSpace.s,
              children: [
                FutureBuilder<int>(
                  // Rebuilt with the voter list, so the count stays current.
                  future: ref
                      .read(cardServiceProvider)
                      .unprinted()
                      .then((l) => l.length),
                  builder: (context, s) => OutlinedButton.icon(
                    key: const ValueKey('print-unprinted'),
                    icon: const Icon(Icons.print_outlined),
                    label: Text(t.printUnprinted('${s.data ?? 0}')),
                    onPressed: (s.data ?? 0) == 0
                        ? null
                        : () async {
                            final ids = [
                              for (final v
                                  in await ref
                                      .read(cardServiceProvider)
                                      .unprinted())
                                v.id,
                            ];
                            if (context.mounted) {
                              await printVoterCards(context, ref, ids);
                            }
                            setState(() {});
                          },
                  ),
                ),
                OutlinedButton(
                  onPressed: _feeSummary,
                  child: Text(t.feeSummary),
                ),
                OutlinedButton(onPressed: _import, child: Text(t.importCsv)),
                OutlinedButton(onPressed: _backup, child: Text(t.backupUsb)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _header(AppLocalizations t) => Container(
    padding: const EdgeInsets.symmetric(vertical: RakubaSpace.xs),
    decoration: const BoxDecoration(
      border: Border(bottom: BorderSide(color: RakubaColors.ink, width: 2)),
    ),
    child: Row(
      children: [
        SizedBox(
          width: 90,
          child: Text(
            t.colVoterNo,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        SizedBox(
          width: 64,
          child: Text(
            t.colPhoto,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            t.colName,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            t.colGroup,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        SizedBox(
          width: 90,
          child: Text(
            t.colFee,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        SizedBox(
          width: 130,
          child: Text(
            t.colCard,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
      ],
    ),
  );
}

class _VoterRow extends ConsumerWidget {
  const _VoterRow({required this.voter});
  final Voter voter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context);
    return InkWell(
      key: ValueKey('voter-row-${voter.voterNo}'),
      onTap: () => showDialog<void>(
        context: context,
        builder: (_) => VoterDetailsDialog(voter: voter),
      ),
      child: Container(
        constraints: const BoxConstraints(minHeight: 56),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: RakubaColors.rule)),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 90,
              child: Text(
                voterNoLabel(voter.voterNo),
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
            SizedBox(
              width: 64,
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: PhotoBox(bytes: voter.photo, size: 36),
              ),
            ),
            Expanded(flex: 3, child: Text(voter.fullName)),
            Expanded(flex: 2, child: Text(voter.groupName)),
            SizedBox(
              width: 90,
              child: FutureBuilder<FeePayment?>(
                future: ref
                    .read(registrationServiceProvider)
                    .feePayment(voter.id),
                builder: (context, s) {
                  final f = s.data;
                  if (f == null) return const Text('—');
                  return Text(
                    f.paid ? t.paid : t.feeNotPaid,
                    style: TextStyle(
                      color: f.paid ? RakubaColors.ink : RakubaColors.clay,
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              width: 130,
              child: cardStatus(
                t,
                cardIssue: voter.cardIssue,
                printedIssue: voter.cardPrintedIssue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Voter details with card actions (print, replace a lost card).
class VoterDetailsDialog extends ConsumerStatefulWidget {
  const VoterDetailsDialog({super.key, required this.voter});
  final Voter voter;
  @override
  ConsumerState<VoterDetailsDialog> createState() => _VoterDetailsDialogState();
}

class _VoterDetailsDialogState extends ConsumerState<VoterDetailsDialog> {
  late Voter _v = widget.voter;

  Future<void> _reload() async {
    final db = ref.read(sessionProvider)!.registry!;
    final v = await (db.select(
      db.voters,
    )..where((x) => x.id.equals(_v.id))).getSingle();
    if (mounted) setState(() => _v = v);
  }

  Future<void> _replace() async {
    final t = AppLocalizations.of(context);
    final reason = await showDialog<String>(
      context: context,
      builder: (c) => SimpleDialog(
        title: Text(t.replaceReason),
        children: [
          SimpleDialogOption(
            key: const ValueKey('reason-lost'),
            onPressed: () => Navigator.pop(c, 'lost'),
            child: Text(t.replaceReasonLost),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(c, 'damaged'),
            child: Text(t.replaceReasonDamaged),
          ),
        ],
      ),
    );
    if (reason == null) return;
    await ref
        .read(registrationServiceProvider)
        .replaceCard(
          _v.id,
          official: ref.read(officialProvider),
          reason: reason,
        );
    await _reload();
    if (mounted) showMessage(context, t.replaceCardDone);
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(t.voterDetails(voterNoLabel(_v.voterNo))),
      content: SizedBox(
        width: 460,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PhotoBox(bytes: _v.photo, size: 110, label: t.photo),
            const SizedBox(width: RakubaSpace.s),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _v.fullName,
                    style: rakubaText(context, RakubaType.heading, bold: true),
                  ),
                  if (_v.memberId.isNotEmpty) Text(_v.memberId),
                  if (_v.groupName.isNotEmpty) Text(_v.groupName),
                  const SizedBox(height: RakubaSpace.xs),
                  Text(t.cardIssueLine('${_v.cardIssue}')),
                  cardStatus(
                    t,
                    cardIssue: _v.cardIssue,
                    printedIssue: _v.cardPrintedIssue,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          key: const ValueKey('replace-card'),
          style: const ButtonStyle(foregroundColor: WidgetStatePropertyAll(RakubaColors.clay)),
          onPressed: _replace,
          child: Text(t.replaceCard),
        ),
        OutlinedButton(
          onPressed: () => Navigator.pop(context),
          child: Text(t.close),
        ),
        FilledButton(
          key: const ValueKey('print-card'),
          onPressed: () async {
            await printVoterCards(context, ref, [_v.id]);
            await _reload();
          },
          child: Text(t.printCard),
        ),
      ],
    );
  }
}

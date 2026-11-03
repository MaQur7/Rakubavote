import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../core/db/registry_db.dart';
import '../../core/domain/election_state.dart';
import '../../core/format.dart';
import '../../core/theme.dart';
import '../../core/widgets/common.dart';
import '../../l10n/app_localizations.dart';
import '../common_errors.dart';
import '../../printing/print_dialogs.dart';
import '../registration/registration_service.dart';
import 'review_service.dart';

String _date(DateTime? d) => d == null
    ? ''
    : '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

/// Mockup C: public review, objections and locking the register.
class ReviewScreen extends ConsumerWidget {
  const ReviewScreen({super.key});

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
        final stats = _StatsRow(election: e);
        final objections = _ObjectionsCard(election: e);
        final lock = _LockCard(election: e);
        return LayoutBuilder(
          builder: (context, c) {
            if (c.maxWidth >= 900) {
              return ListView(
                padding: const EdgeInsets.all(RakubaSpace.m),
                children: [
                  stats,
                  const SizedBox(height: RakubaSpace.s),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 2, child: objections),
                      const SizedBox(width: RakubaSpace.s),
                      Expanded(child: lock),
                    ],
                  ),
                ],
              );
            }
            return ListView(
              padding: const EdgeInsets.all(RakubaSpace.s),
              children: [stats, objections, lock],
            );
          },
        );
      },
    );
  }
}

class _StatsRow extends ConsumerWidget {
  const _StatsRow({required this.election});
  final Election election;

  Future<void> _setDates(BuildContext context, WidgetRef ref) async {
    final t = AppLocalizations.of(context);
    final now = DateTime.now();
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 2),
      initialDateRange: election.reviewStart == null
          ? null
          : DateTimeRange(
              start: election.reviewStart!,
              end: election.reviewEnd!,
            ),
      helpText: t.displayPeriod,
    );
    if (range == null) return;
    try {
      await ref
          .read(reviewServiceProvider)
          .setDisplayPeriod(
            election.id,
            start: range.start,
            end: range.end,
            official: ref.read(officialProvider),
          );
    } catch (err) {
      if (context.mounted) showMessage(context, describeError(t, err));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context);
    final locked =
        ElectionState.fromWire(election.state).index >=
        ElectionState.locked.index;
    // A ledger, not stat tiles (design system, section 7).
    return SectionCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        StreamBuilder<List<Voter>>(
          stream: ref.watch(registrationServiceProvider).watchVoters(election.id),
          builder: (context, s) =>
              LedgerRow(label: t.registeredVotersStat, value: '${s.data?.length ?? ''}'),
        ),
        LedgerRow(
          label: t.displayPeriod,
          value: election.reviewStart == null
              ? t.displayPeriodNotSet
              : t.displayPeriodRange(_date(election.reviewStart), _date(election.reviewEnd)),
        ),
        StreamBuilder<int>(
          stream: ref.watch(reviewServiceProvider).watchOpenObjectionCount(election.id),
          builder: (context, s) =>
              LedgerRow(label: t.openObjections, value: '${s.data ?? 0}', attention: (s.data ?? 0) > 0),
        ),
        if (!locked) ...[
          const SizedBox(height: RakubaSpace.s),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: OutlinedButton(
              key: const ValueKey('set-dates'),
              onPressed: () => _setDates(context, ref),
              child: Text(t.setDates),
            ),
          ),
        ],
      ]),
    );
  }
}

class _ObjectionsCard extends ConsumerWidget {
  const _ObjectionsCard({required this.election});
  final Election election;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context);
    final svc = ref.watch(reviewServiceProvider);
    final locked =
        ElectionState.fromWire(election.state).index >=
        ElectionState.locked.index;
    return SectionCard(
      title: t.objectionsTitle,
      child: StreamBuilder<List<ObjectionView>>(
        stream: svc.watchObjectionViews(election.id),
        builder: (context, snap) {
          final list = snap.data ?? const <ObjectionView>[];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (!locked)
                Wrap(
                  spacing: RakubaSpace.s,
                  runSpacing: RakubaSpace.s,
                  children: [
                    OutlinedButton.icon(
                      key: const ValueKey('raise-objection'),
                      icon: const Icon(Icons.add),
                      label: Text(t.raiseObjection),
                      onPressed: () => showDialog<void>(
                        context: context,
                        builder: (_) =>
                            _RaiseObjectionDialog(electionId: election.id),
                      ),
                    ),
                    OutlinedButton.icon(
                      key: const ValueKey('check-duplicates'),
                      icon: const Icon(Icons.people_outline),
                      label: Text(t.checkDuplicates),
                      onPressed: () => showDialog<void>(
                        context: context,
                        builder: (_) =>
                            _DuplicatePairsDialog(electionId: election.id),
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: RakubaSpace.s),
              if (list.isEmpty)
                Text(t.noObjections, style: rakubaText(context, RakubaType.body)),
              for (final o in list)
                _ObjectionTile(
                  key: ValueKey(o.objection.id),
                  view: o,
                  election: election,
                  locked: locked,
                ),
              const SizedBox(height: RakubaSpace.xs),
              Text(t.objectionsNote, style: rakubaText(context, RakubaType.label)),
            ],
          );
        },
      ),
    );
  }
}

class _ObjectionTile extends ConsumerWidget {
  const _ObjectionTile({
    super.key,
    required this.view,
    required this.election,
    required this.locked,
  });
  final ObjectionView view;
  final Election election;
  final bool locked;

  Objection get objection => view.objection;

  String _decisionText(AppLocalizations t, String wire) =>
      switch (ObjectionDecisionWire.parse(wire)) {
        ObjectionDecision.keepBoth => t.decisionKeepBoth,
        ObjectionDecision.remove => t.decisionRemove,
        ObjectionDecision.add => t.decisionAdd,
        ObjectionDecision.reject => t.decisionReject,
        ObjectionDecision.upheld => t.decisionUpheld,
        ObjectionDecision.rejected => t.decisionRejected,
        null => wire,
      };

  Future<void> _decide(
    BuildContext context,
    WidgetRef ref,
    ObjectionDecision d,
  ) async {
    final t = AppLocalizations.of(context);
    VoterInput? input;
    if (d == ObjectionDecision.add) {
      input = await showDialog<VoterInput>(
        context: context,
        builder: (_) => _AddClaimantDialog(
          name: objection.claimantName ?? '',
          idLabel: election.idLabel,
          groupLabel: election.groupLabel,
        ),
      );
      if (input == null) return;
    }
    try {
      await ref
          .read(reviewServiceProvider)
          .decide(
            objection.id,
            d,
            official: ref.read(officialProvider),
            newVoter: input,
          );
    } catch (err) {
      if (context.mounted) showMessage(context, describeError(t, err));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context);
    final o = objection;
    final kind = ObjectionKind.values.byName(o.kind);
    final sNo = view.subjectVoterNo == null
        ? ''
        : voterNoLabel(view.subjectVoterNo!);
    final oNo = view.otherVoterNo == null
        ? ''
        : voterNoLabel(view.otherVoterNo!);
    final title = switch (kind) {
      ObjectionKind.duplicate => t.duplicateTitle(sNo, oNo),
      ObjectionKind.missing => t.missingTitle(o.claimantName ?? ''),
      ObjectionKind.other => t.otherTitle(sNo, o.detail),
    };
    final open = o.decision == null;
    final actions = <Widget>[
      if (open && !locked)
        ...switch (kind) {
          ObjectionKind.duplicate => [
            OutlinedButton(
              key: ValueKey('keep-${o.id}'),
              onPressed: () =>
                  _decide(context, ref, ObjectionDecision.keepBoth),
              child: Text(t.keepBoth),
            ),
            OutlinedButton(
              key: ValueKey('remove-${o.id}'),
              style: OutlinedButton.styleFrom(
                foregroundColor: RakubaColors.clay,
                side: const BorderSide(color: RakubaColors.clay, width: 2),
              ),
              onPressed: () => _decide(context, ref, ObjectionDecision.remove),
              child: Text(t.removeVoter(sNo)),
            ),
          ],
          ObjectionKind.missing => [
            OutlinedButton(
              key: ValueKey('reject-${o.id}'),
              onPressed: () => _decide(context, ref, ObjectionDecision.reject),
              child: Text(t.reject),
            ),
            FilledButton(
              key: ValueKey('add-${o.id}'),
              onPressed: () => _decide(context, ref, ObjectionDecision.add),
              child: Text(t.addVoter),
            ),
          ],
          ObjectionKind.other => [
            OutlinedButton(
              onPressed: () =>
                  _decide(context, ref, ObjectionDecision.rejected),
              child: Text(t.rejected),
            ),
            FilledButton(
              onPressed: () => _decide(context, ref, ObjectionDecision.upheld),
              child: Text(t.upheld),
            ),
          ],
        },
    ];
    return Container(
      margin: const EdgeInsets.only(bottom: RakubaSpace.s),
      padding: const EdgeInsets.all(RakubaSpace.s),
      decoration: BoxDecoration(
        color: open ? RakubaColors.card : RakubaColors.paper,
        borderRadius: BorderRadius.circular(RakubaRadius.control),
        border: Border.all(color: RakubaColors.rule),
      ),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: RakubaSpace.s,
        runSpacing: RakubaSpace.xs,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: rakubaText(context, RakubaType.bodyLarge, bold: true),
                ),
                if (kind == ObjectionKind.missing && o.detail.isNotEmpty)
                  Text(o.detail, style: rakubaText(context, RakubaType.body)),
                Text(
                  t.raisedByLine(o.raisedByName, o.raisedOn),
                  style: rakubaText(context, RakubaType.body),
                ),
                if (!open)
                  Text(
                    t.decidedLine(
                      o.decidedBy ?? '',
                      o.decidedOn ?? '',
                      _decisionText(t, o.decision!),
                    ),
                    style: rakubaText(context, RakubaType.body, colour: RakubaColors.acaciaGreen),
                  ),
              ],
            ),
          ),
          if (actions.isNotEmpty) Wrap(spacing: RakubaSpace.xs, children: actions),
        ],
      ),
    );
  }
}

class _RaiseObjectionDialog extends ConsumerStatefulWidget {
  const _RaiseObjectionDialog({
    required this.electionId,
    this.subjectNo,
    this.otherNo,
  });
  final String electionId;
  final int? subjectNo;
  final int? otherNo;
  @override
  ConsumerState<_RaiseObjectionDialog> createState() =>
      _RaiseObjectionDialogState();
}

class _RaiseObjectionDialogState extends ConsumerState<_RaiseObjectionDialog> {
  ObjectionKind _kind = ObjectionKind.duplicate;
  late final _subject = TextEditingController(
    text: widget.subjectNo?.toString() ?? '',
  );
  late final _other = TextEditingController(
    text: widget.otherNo?.toString() ?? '',
  );
  final _claimant = TextEditingController();
  final _raisedBy = TextEditingController();
  final _detail = TextEditingController();
  String? _error;

  @override
  void dispose() {
    for (final c in [_subject, _other, _claimant, _raisedBy, _detail]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    final t = AppLocalizations.of(context);
    try {
      await ref
          .read(reviewServiceProvider)
          .raiseObjection(
            widget.electionId,
            kind: _kind,
            subjectVoterNo: int.tryParse(_subject.text.trim()),
            otherVoterNo: int.tryParse(_other.text.trim()),
            claimantName: _claimant.text,
            raisedByName: _raisedBy.text,
            detail: _detail.text,
            official: ref.read(officialProvider),
          );
      if (mounted) Navigator.pop(context);
    } catch (err) {
      setState(() => _error = describeError(t, err));
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(t.raiseObjection),
      content: SizedBox(
        width: 460,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FieldLabel(t.objectionKind),
              SegmentedButton<ObjectionKind>(
                segments: [
                  ButtonSegment(
                    value: ObjectionKind.duplicate,
                    label: Text(t.kindDuplicate),
                  ),
                  ButtonSegment(
                    value: ObjectionKind.missing,
                    label: Text(t.kindMissing),
                  ),
                  ButtonSegment(
                    value: ObjectionKind.other,
                    label: Text(t.kindOther),
                  ),
                ],
                selected: {_kind},
                onSelectionChanged: (s) => setState(() => _kind = s.first),
              ),
              if (_kind != ObjectionKind.missing) ...[
                FieldLabel(t.voterNumberField),
                TextField(
                  key: const ValueKey('obj-subject'),
                  controller: _subject,
                  keyboardType: TextInputType.number,
                ),
              ],
              if (_kind == ObjectionKind.duplicate) ...[
                FieldLabel(t.otherVoterNumberField),
                TextField(
                  key: const ValueKey('obj-other'),
                  controller: _other,
                  keyboardType: TextInputType.number,
                ),
              ],
              if (_kind == ObjectionKind.missing) ...[
                FieldLabel(t.claimantNameField),
                TextField(
                  key: const ValueKey('obj-claimant'),
                  controller: _claimant,
                ),
              ],
              FieldLabel(t.raisedByField),
              TextField(
                key: const ValueKey('obj-raised-by'),
                controller: _raisedBy,
              ),
              FieldLabel(t.detailField),
              TextField(controller: _detail, maxLines: 2),
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.only(top: RakubaSpace.s),
                  child: Text(
                    _error!,
                    style: rakubaText(context, RakubaType.body, colour: RakubaColors.clay),
                  ),
                ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(t.cancel),
        ),
        FilledButton(
          key: const ValueKey('obj-save'),
          onPressed: _save,
          child: Text(t.save),
        ),
      ],
    );
  }
}

class _DuplicatePairsDialog extends ConsumerWidget {
  const _DuplicatePairsDialog({required this.electionId});
  final String electionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(t.duplicatePairsTitle),
      content: SizedBox(
        width: 520,
        child: FutureBuilder<List<DuplicatePair>>(
          future: ref
              .read(reviewServiceProvider)
              .possibleDuplicatePairs(electionId),
          builder: (context, snap) {
            if (!snap.hasData) {
              return const SizedBox(
                height: 80,
                child: Center(child: CircularProgressIndicator()),
              );
            }
            final pairs = snap.data!;
            if (pairs.isEmpty) return Text(t.noDuplicatesFound);
            return ListView(
              shrinkWrap: true,
              children: [
                for (final p in pairs)
                  ListTile(
                    minTileHeight: RakubaSizes.minTouch,
                    title: Text(
                      t.duplicatePairLine(
                        '${voterNoLabel(p.a.voterNo)} · ${p.a.fullName}',
                        '${voterNoLabel(p.b.voterNo)} · ${p.b.fullName}',
                      ),
                    ),
                    trailing: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        showDialog<void>(
                          context: context,
                          builder: (_) => _RaiseObjectionDialog(
                            electionId: electionId,
                            subjectNo: p.b.voterNo,
                            otherNo: p.a.voterNo,
                          ),
                        );
                      },
                      child: Text(t.raiseThis),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(t.close),
        ),
      ],
    );
  }
}

/// Details for a voter added because of a "missing name" objection.
class _AddClaimantDialog extends ConsumerStatefulWidget {
  const _AddClaimantDialog({
    required this.name,
    required this.idLabel,
    required this.groupLabel,
  });
  final String name;
  final String idLabel;
  final String groupLabel;
  @override
  ConsumerState<_AddClaimantDialog> createState() => _AddClaimantDialogState();
}

class _AddClaimantDialogState extends ConsumerState<_AddClaimantDialog> {
  late final _name = TextEditingController(text: widget.name);
  final _id = TextEditingController();
  final _group = TextEditingController();
  final _receipt = TextEditingController();
  bool _paid = false;

  @override
  void dispose() {
    for (final c in [_name, _id, _group, _receipt]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(t.addVoter),
      content: SizedBox(
        width: 420,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FieldLabel(t.fullName),
            TextField(key: const ValueKey('claimant-name'), controller: _name),
            FieldLabel(widget.idLabel),
            TextField(controller: _id),
            FieldLabel(widget.groupLabel),
            TextField(controller: _group),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              value: _paid,
              title: Text(t.paid),
              onChanged: (v) => setState(() => _paid = v ?? false),
            ),
            if (_paid) ...[
              FieldLabel(t.receiptNo),
              TextField(controller: _receipt),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(t.cancel),
        ),
        FilledButton(
          key: const ValueKey('claimant-save'),
          onPressed: () => Navigator.pop(
            context,
            VoterInput(
              fullName: _name.text,
              memberId: _id.text,
              groupName: _group.text,
              feePaid: _paid,
              receiptNo: _receipt.text,
            ),
          ),
          child: Text(t.save),
        ),
      ],
    );
  }
}

class _LockCard extends ConsumerWidget {
  const _LockCard({required this.election});
  final Election election;

  Future<void> _lock(BuildContext context, WidgetRef ref) async {
    final t = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        content: Text(t.lockConfirm, style: rakubaText(context, RakubaType.bodyLarge)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c, false),
            child: Text(t.cancel),
          ),
          FilledButton(
            key: const ValueKey('lock-confirm'),
            onPressed: () => Navigator.pop(c, true),
            child: Text(t.lockButton),
          ),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await ref
          .read(reviewServiceProvider)
          .lockRegister(election.id, official: ref.read(officialProvider));
    } catch (err) {
      if (context.mounted) showMessage(context, describeError(t, err));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context);
    final svc = ref.watch(reviewServiceProvider);
    return Container(
      padding: const EdgeInsets.all(RakubaSpace.s),
      decoration: BoxDecoration(
        color: RakubaColors.card,
        borderRadius: BorderRadius.circular(RakubaSizes.cardRadius),
        border: Border.all(color: RakubaColors.ink, width: 2),
      ),
      child: StreamBuilder<RegisterLock?>(
        stream: svc.watchLock(election.id),
        builder: (context, lockSnap) {
          final lock = lockSnap.data;
          final common = <Widget>[
            Text(
              lock == null ? t.lockTitle : t.registerLocked,
              style: rakubaText(context, RakubaType.heading, bold: true),
            ),
            const SizedBox(height: RakubaSpace.xs),
          ];
          if (lock != null) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ...common,
                Text(
                  t.registerFingerprint,
                  style: rakubaText(context, RakubaType.body),
                ),
                SelectableText(
                  lock.fingerprint,
                  key: const ValueKey('register-fingerprint'),
                  style: rakubaText(context, RakubaType.title, bold: true).copyWith(letterSpacing: 2),
                ),
                Text(
                  t.lockedByLine(lock.lockedBy, _date(lock.lockedAt.toLocal())),
                ),
                const SizedBox(height: RakubaSpace.s),
                FutureBuilder<RegisterCheck>(
                  future: svc.checkLockedRegister(election.id),
                  builder: (context, s) {
                    final r = s.data;
                    if (r == null) return const SizedBox.shrink();
                    final ok = r == RegisterCheck.valid;
                    return NoticeBox(
                      kind: ok ? NoticeKind.success : NoticeKind.warning,
                      child: Text(switch (r) {
                        RegisterCheck.valid => t.registerCheckValid,
                        RegisterCheck.badSignature => t.registerCheckBad,
                        _ => t.registerCheckChanged,
                      }, key: const ValueKey('register-check')),
                    );
                  },
                ),
                const SizedBox(height: RakubaSpace.s),
                if (election.state == ElectionState.locked.name)
                  FilledButton(
                    key: const ValueKey('open-polls'),
                    style: FilledButton.styleFrom(
                      backgroundColor: RakubaColors.acaciaGreen,
                    ),
                    onPressed: () => _openPolls(context, ref),
                    child: Text(t.openPolls),
                  )
                else if (election.state == ElectionState.polling.name)
                  Text(
                    t.pollsOpen,
                    key: const ValueKey('polls-open'),
                    style: rakubaText(context, RakubaType.bodyLarge, bold: true, colour: RakubaColors.acaciaGreen),
                  ),
                const SizedBox(height: RakubaSpace.s),
                OutlinedButton(
                  key: const ValueKey('print-register'),
                  onPressed: () => printRegister(context, ref),
                  child: Text(t.printRegister),
                ),
                const SizedBox(height: RakubaSpace.s),
                _afterLocking(t),
              ],
            );
          }
          return StreamBuilder<int>(
            stream: svc.watchOpenObjectionCount(election.id),
            builder: (context, s) {
              final open = s.data ?? 0;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ...common,
                  Text(t.lockText, style: rakubaText(context, RakubaType.body)),
                  const SizedBox(height: RakubaSpace.s),
                  OutlinedButton(
                    key: const ValueKey('print-register'),
                    onPressed: () => printRegister(context, ref),
                    child: Text(t.printRegister),
                  ),
                  const SizedBox(height: RakubaSpace.s),
                  FilledButton(
                    key: const ValueKey('lock-register'),
                    onPressed: open > 0 ? null : () => _lock(context, ref),
                    child: Text(
                      open > 0 ? t.lockButtonBlocked(open) : t.lockButton,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: RakubaSpace.s),
                  _afterLocking(t),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _openPolls(BuildContext context, WidgetRef ref) async {
    final t = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        content: Text(t.openPollsConfirm, style: rakubaText(context, RakubaType.bodyLarge)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c, false),
            child: Text(t.cancel),
          ),
          FilledButton(
            key: const ValueKey('open-polls-confirm'),
            onPressed: () => Navigator.pop(c, true),
            child: Text(t.openPolls),
          ),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await ref
          .read(checkInServiceProvider)
          .openPolls(official: ref.read(officialProvider));
    } catch (err) {
      if (context.mounted) showMessage(context, describeError(t, err));
    }
  }

  Widget _afterLocking(AppLocalizations t) => NoticeBox(
    kind: NoticeKind.info,
    child: Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: '${t.afterLockingTitle} ',
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          TextSpan(text: t.afterLockingText),
        ],
      ),
    ),
  );
}

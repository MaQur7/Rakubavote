import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../app/providers.dart';
import '../../core/crypto/signed_artifact.dart';
import '../../core/db/registry_db.dart';
import '../../core/domain/election_state.dart';
import '../../core/format.dart';
import '../../core/theme.dart';
import '../../core/widgets/common.dart';
import '../../l10n/app_localizations.dart';
import '../../platform/photo_capture.dart';
import '../common_errors.dart';
import 'results_service.dart';

/// Mockup D: close the polls, collect votes, show results.
class ResultsScreen extends ConsumerStatefulWidget {
  const ResultsScreen({super.key});
  @override
  ConsumerState<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends ConsumerState<ResultsScreen> {
  ResultsView? _results;
  List<BoothBatchStatus> _booths = const [];
  bool _busy = false;

  ResultsService get _svc => ref.read(resultsServiceProvider);

  @override
  void initState() {
    super.initState();
    _refresh();
    ref.read(stationServerProvider).changes.listen((_) => _refresh());
  }

  Future<void> _refresh() async {
    final booths = await _svc.batchStatus();
    ResultsView? r;
    try {
      r = await _svc.currentResults();
    } catch (_) {
      r = null;
    }
    if (mounted) {
      setState(() {
        _booths = booths;
        _results = r;
      });
    }
  }

  Future<bool> _confirm(String text, String button) async =>
      await showDialog<bool>(
        context: context,
        builder: (c) => AlertDialog(
          content: Text(text, style: const TextStyle(fontSize: 18)),
          actions: [
            TextButton(onPressed: () => Navigator.pop(c, false), child: Text(AppLocalizations.of(c).cancel)),
            FilledButton(key: const ValueKey('confirm-dialog'), onPressed: () => Navigator.pop(c, true), child: Text(button)),
          ],
        ),
      ) ==
      true;

  Future<void> _run(Future<void> Function() action) async {
    final t = AppLocalizations.of(context);
    setState(() => _busy = true);
    try {
      await action();
      await _refresh();
    } catch (err) {
      if (mounted) showMessage(context, describeError(t, err));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _show() async {
    final t = AppLocalizations.of(context);
    final missing = _booths.where((b) => !b.received).length;
    if (missing > 0 && !await _confirm(t.boothsMissingConfirm('$missing'), t.showResults)) return;
    await _run(() => _svc.computeResults(official: ref.read(officialProvider)));
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return StreamBuilder<Election?>(
      stream: ref.watch(electionServiceProvider).watchElection(),
      builder: (context, snap) {
        final e = snap.data;
        if (e == null) return Center(child: Text(t.errNoElection, style: const TextStyle(fontSize: 18)));
        final state = ElectionState.fromWire(e.state);
        final r = _results;
        return ListView(padding: const EdgeInsets.all(24), children: [
          if (state.index < ElectionState.polling.index)
            SectionCard(child: Text(t.resultsAfterClosing, style: const TextStyle(fontSize: 18))),
          if (state == ElectionState.polling)
            SectionCard(
              title: t.closePolls,
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Text(t.closePollsNote, style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 12),
                FilledButton(
                  key: const ValueKey('close-polls'),
                  style: FilledButton.styleFrom(backgroundColor: RakubaColors.clay),
                  onPressed: _busy
                      ? null
                      : () async {
                          if (await _confirm(t.closePollsConfirm, t.closePolls)) {
                            await _run(() => _svc.closePolls(official: ref.read(officialProvider)));
                          }
                        },
                  child: Text(t.closePolls),
                ),
              ]),
            ),
          if (state.index >= ElectionState.polling.index) _boothCard(t, state),
          if (r != null) ...[
            _StatsRow(view: r),
            const SizedBox(height: 16),
            LayoutBuilder(builder: (context, c) {
              final positions = Column(children: [for (final p in r.positions) _PositionResult(p: p)]);
              final share = _ShareCard(view: r, onSave: () => _save(r.signed));
              if (c.maxWidth < 900) return Column(children: [positions, share]);
              return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Expanded(flex: 2, child: positions),
                const SizedBox(width: 16),
                Expanded(child: share),
              ]);
            }),
          ],
        ]);
      },
    );
  }

  Future<void> _save(SignedArtifact signed) async {
    final t = AppLocalizations.of(context);
    final dir = await pickFolder();
    if (dir == null) return;
    await _run(() async {
      final f = await _svc.exportResults(signed, Directory(dir), official: ref.read(officialProvider));
      if (mounted) showMessage(context, t.resultsSavedIn(f.path));
    });
  }

  Widget _boothCard(AppLocalizations t, ElectionState state) => SectionCard(
        title: t.boothVotesTitle,
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          if (_booths.isEmpty) Text(t.noPairedBooths),
          for (final b in _booths)
            ListTile(
              minTileHeight: RakubaSizes.minTouch,
              leading: Icon(b.received ? Icons.check_circle : Icons.hourglass_empty,
                  color: b.received ? RakubaColors.acaciaGreen : RakubaColors.clay),
              title: Text(b.booth.label, style: const TextStyle(fontWeight: FontWeight.w700)),
              subtitle: Text(b.received ? t.boothVotesReceived('${b.ballots}') : t.boothVotesWaiting),
            ),
          const SizedBox(height: 8),
          Wrap(spacing: 12, runSpacing: 12, children: [
            if (state == ElectionState.closed)
              FilledButton(
                key: const ValueKey('show-results'),
                onPressed: _busy ? null : _show,
                child: Text(_results == null ? t.showResults : t.countAgain),
              ),
          ]),
        ]),
      );
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.view});
  final ResultsView view;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final r = view.reconciliation;
    final ok = view.checkInsMatchVotes && view.clean;
    Widget stat(String label, String value, {Color? border, Color? fill, Color? text}) => Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: fill ?? RakubaColors.card,
            borderRadius: BorderRadius.circular(RakubaSizes.cardRadius),
            border: Border.all(color: border ?? RakubaColors.placeholder, width: border == null ? 1 : 2),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label, style: const TextStyle(fontSize: 15)),
            Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: text ?? RakubaColors.ink)),
          ]),
        );
    final cards = [
      stat(t.statRegistered, '${r['registered']}'),
      stat(t.statCheckedIn, '${r['checkedIn']}'),
      stat(t.statVotes, '${r['ballots']}'),
      stat(t.statCheck, ok ? t.checkMatch : t.checkDiffer,
          border: ok ? RakubaColors.acaciaGreen : RakubaColors.clay,
          fill: ok ? RakubaColors.successTint : RakubaColors.warningTint,
          text: ok ? RakubaColors.acaciaGreen : RakubaColors.clay),
    ];
    final issues = _issues(t, view);
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Wrap(spacing: 12, runSpacing: 12, children: [for (final c in cards) SizedBox(width: 220, child: c)]),
      if (issues.isNotEmpty) ...[
        const SizedBox(height: 12),
        NoticeBox(
          key: const ValueKey('results-issues'),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            for (final i in issues) Text('• $i', style: const TextStyle(fontSize: 16)),
          ]),
        ),
      ],
      const SizedBox(height: 12),
      Text(t.resultsFingerprint(view.signed.fingerprint),
          key: const ValueKey('results-fingerprint'), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
    ]);
  }

  static List<String> _issues(AppLocalizations t, ResultsView v) {
    final r = v.reconciliation;
    final i = v.integrity;
    int n(Object? x) => x as int;
    return [
      if (n(r['tokensUsed']) < n(r['checkedIn'])) t.issueUnusedCodes('${n(r['checkedIn']) - n(r['tokensUsed'])}'),
      if (n(r['ballots']) != n(r['tokensUsed'])) t.issueBallotsVsCodes('${r['ballots']}', '${r['tokensUsed']}'),
      if (n(i['codesUsedAtTwoBooths']) > 0) t.issueTwoBooths('${i['codesUsedAtTwoBooths']}'),
      if (n(i['codesNeverIssued']) > 0) t.issueNeverIssued('${i['codesNeverIssued']}'),
      if (n(i['duplicateBallotIds']) + n(i['incompleteBallots']) + n(i['unknownPositionRows']) > 0) t.issueDamagedBallots,
      if (n(r['manualCheckIns']) > 0) t.issueManual('${r['manualCheckIns']}'),
    ];
  }
}

class _PositionResult extends StatelessWidget {
  const _PositionResult({required this.p});
  final Map<String, Object?> p;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final colour = Color(p['colour'] as int);
    final titles = (p['titles'] as Map).cast<String, String>();
    final locale = Localizations.localeOf(context).languageCode;
    final cands = [for (final c in p['candidates'] as List) (c as Map).cast<String, Object?>()];
    final max = cands.fold<int>(1, (m, c) => (c['votes'] as int) > m ? c['votes'] as int : m);
    final tie = (p['tie'] as List).cast<String>();
    final tied = cands.where((c) => tie.contains(c['id'])).toList();
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: RakubaColors.card,
        borderRadius: BorderRadius.circular(RakubaSizes.cardRadius),
        border: Border.all(color: colour, width: 2),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Container(
          color: colour,
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Text(titles[locale] ?? titles['en'] ?? titles.values.first,
              style: const TextStyle(color: RakubaColors.white, fontSize: 22, fontWeight: FontWeight.w700)),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            if (tied.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: NoticeBox(
                  child: Text(t.tieNotice('${tied.length}', '${tied.first['votes']}'),
                      key: ValueKey('tie-${p['id']}'), style: const TextStyle(fontWeight: FontWeight.w700)),
                ),
              ),
            for (final c in cands) ...[
              Row(children: [
                Expanded(
                  child: Text(
                      '${candidateNoLabel(c['number'] as int, candidateCount: cands.length)} · ${c['name']}',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                ),
                Text('${c['votes']}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              ]),
              const SizedBox(height: 4),
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  value: (c['votes'] as int) / max,
                  minHeight: 10,
                  color: colour,
                  backgroundColor: tintOf(colour),
                ),
              ),
              const SizedBox(height: 10),
            ],
            Row(children: [
              Expanded(child: Text(t.noChoiceForPosition)),
              Text('${p['noChoice']}'),
            ]),
            if ((p['invalid'] as int) > 0)
              Row(children: [
                Expanded(child: Text(t.invalidVotes, style: const TextStyle(color: RakubaColors.clay))),
                Text('${p['invalid']}', style: const TextStyle(color: RakubaColors.clay)),
              ]),
          ]),
        ),
      ]),
    );
  }
}

Color tintOf(Color c) => Color.alphaBlend(c.withValues(alpha: 0.12), RakubaColors.white);

class _ShareCard extends ConsumerWidget {
  const _ShareCard({required this.view, required this.onSave});
  final ResultsView view;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context);
    return SectionCard(
      title: t.shareResults,
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Text(t.shareResultsNote, style: const TextStyle(fontSize: 15)),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          key: const ValueKey('results-qr'),
          icon: const Icon(Icons.qr_code_2),
          label: Text(t.showSignedQr),
          onPressed: () async {
            final qr = await ref.read(resultsServiceProvider).qrSummary(view.signed);
            if (!context.mounted) return;
            await showDialog<void>(
              context: context,
              builder: (c) => AlertDialog(
                title: Text(t.resultsFingerprint(view.signed.fingerprint)),
                content: SizedBox(
                  width: 360,
                  height: 360,
                  child: Container(color: RakubaColors.white, child: QrImageView(data: qr.encode(), size: 360)),
                ),
                actions: [FilledButton(onPressed: () => Navigator.pop(c), child: Text(t.close))],
              ),
            );
          },
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          key: const ValueKey('save-results'),
          icon: const Icon(Icons.usb),
          label: Text(t.saveSignedFile),
          onPressed: onSave,
        ),
        const SizedBox(height: 12),
        Tooltip(
          message: t.sendOnlineOff,
          child: OutlinedButton(onPressed: null, child: Text(t.sendOnline)),
        ),
      ]),
    );
  }
}

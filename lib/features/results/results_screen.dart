import 'dart:io';

import 'package:flutter/material.dart';

import '../../core/brand/brand.dart';
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
          content: Text(text, style: rakubaText(context, RakubaType.bodyLarge)),
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
        if (e == null) return Center(child: Text(t.errNoElection, style: rakubaText(context, RakubaType.bodyLarge)));
        final state = ElectionState.fromWire(e.state);
        final r = _results;
        return ListView(padding: const EdgeInsets.all(RakubaSpace.m), children: [
          if (state.index < ElectionState.polling.index)
            SectionCard(child: Text(t.resultsAfterClosing, style: rakubaText(context, RakubaType.bodyLarge))),
          if (state == ElectionState.polling)
            SectionCard(
              title: t.closePolls,
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Text(t.closePollsNote, style: rakubaText(context, RakubaType.body)),
                const SizedBox(height: RakubaSpace.s),
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
            const SizedBox(height: RakubaSpace.s),
            LayoutBuilder(builder: (context, c) {
              final positions = Column(children: [for (final p in r.positions) _PositionResult(p: p)]);
              final share = _ShareCard(view: r, onSave: () => _save(r.signed));
              if (c.maxWidth < 900) return Column(children: [positions, share]);
              return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Expanded(flex: 2, child: positions),
                const SizedBox(width: RakubaSpace.s),
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
          if (_booths.isEmpty) EmptyState(t.noPairedBooths),
          for (final b in _booths)
            ListTile(
              minTileHeight: RakubaSizes.minTouch,
              leading: TickBox(checked: b.received, colour: RakubaColors.acaciaGreen, size: RakubaSpace.l),
              title: Text(b.booth.label),
              subtitle: Text(b.received ? t.boothVotesReceived('${b.ballots}') : t.boothVotesWaiting),
            ),
          const SizedBox(height: RakubaSpace.xs),
          Wrap(spacing: RakubaSpace.s, runSpacing: RakubaSpace.s, children: [
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
    final issues = _issues(t, view);
    // A ledger, like the tally sheet: no stat tiles (design system, section 7).
    return SectionCard(
      title: ok ? t.checkMatch : t.checkDiffer,
      trailing: ok ? const BrandTick(size: RakubaSpace.l, colour: RakubaColors.acaciaGreen) : null,
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        LedgerRow(label: t.statRegistered, value: '${r['registered']}'),
        LedgerRow(label: t.statCheckedIn, value: '${r['checkedIn']}'),
        LedgerRow(label: t.statVotes, value: '${r['ballots']}', attention: !ok),
        if (issues.isNotEmpty) ...[
          const SizedBox(height: RakubaSpace.s),
          NoticeBox(
            key: const ValueKey('results-issues'),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              for (final i in issues) Text('• $i'),
            ]),
          ),
        ],
        const SizedBox(height: RakubaSpace.m),
        Text(t.resultsFingerprint(view.signed.fingerprint),
            key: const ValueKey('results-fingerprint'),
            style: rakubaText(context, RakubaType.title, bold: true)
                .copyWith(fontFeatures: const [FontFeature.tabularFigures()])),
      ]),
    );
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
      margin: const EdgeInsets.only(bottom: RakubaSpace.s),
      decoration: BoxDecoration(
        color: RakubaColors.card,
        borderRadius: BorderRadius.circular(RakubaSizes.cardRadius),
        border: Border.all(color: colour, width: 2),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Container(
          color: colour,
          padding: const EdgeInsets.symmetric(horizontal: RakubaSpace.m, vertical: RakubaSpace.s),
          child: Text(titles[locale] ?? titles['en'] ?? titles.values.first,
              style: rakubaText(context, RakubaType.heading, bold: true, colour: RakubaColors.white)),
        ),
        Padding(
          padding: const EdgeInsets.all(RakubaSpace.m),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            if (tied.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: RakubaSpace.s),
                child: NoticeBox(
                  child: Text(t.tieNotice('${tied.length}', '${tied.first['votes']}'),
                      key: ValueKey('tie-${p['id']}'), style: rakubaText(context, RakubaType.body, bold: true)),
                ),
              ),
            for (final c in cands) ...[
              Row(children: [
                Expanded(
                  child: Text(
                      '${candidateNoLabel(c['number'] as int, candidateCount: cands.length)} · ${c['name']}',
                      style: rakubaText(context, RakubaType.body, bold: true)),
                ),
                Text('${c['votes']}', style: rakubaText(context, RakubaType.bodyLarge, bold: true)),
              ]),
              const SizedBox(height: RakubaSpace.xxs),
              ClipRRect(
                borderRadius: BorderRadius.circular(RakubaRadius.pill),
                child: LinearProgressIndicator(
                  value: (c['votes'] as int) / max,
                  minHeight: RakubaSpace.xs,
                  color: colour,
                  backgroundColor: tintOf(colour),
                ),
              ),
              const SizedBox(height: RakubaSpace.xs),
            ],
            Row(children: [
              Expanded(child: MutedText(t.noChoiceForPosition, size: RakubaType.body)),
              Text('${p['noChoice']}', style: rakubaText(context, RakubaType.bodyLarge, bold: true)),
            ]),
            if ((p['invalid'] as int) > 0)
              Row(children: [
                Expanded(
                    child: Text(t.invalidVotes,
                        style: rakubaText(context, RakubaType.body, bold: true, colour: RakubaColors.clay))),
                Text('${p['invalid']}', style: rakubaText(context, RakubaType.body, bold: true, colour: RakubaColors.clay)),
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
        MutedText(t.shareResultsNote, size: RakubaType.body),
        const SizedBox(height: RakubaSpace.s),
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
        const SizedBox(height: RakubaSpace.s),
        OutlinedButton.icon(
          key: const ValueKey('save-results'),
          icon: const Icon(Icons.usb),
          label: Text(t.saveSignedFile),
          onPressed: onSave,
        ),
        const SizedBox(height: RakubaSpace.s),
        Tooltip(
          message: t.sendOnlineOff,
          child: OutlinedButton(onPressed: null, child: Text(t.sendOnline)),
        ),
      ]),
    );
  }
}

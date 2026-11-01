import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app/providers.dart';
import '../core/theme.dart';
import '../core/widgets/common.dart';
import '../l10n/app_localizations.dart';
import 'register_pdf.dart';
import 'voter_card_pdf.dart';

CardLabels cardLabelsOf(AppLocalizations t) => CardLabels(
      cardTitle: t.cardTitle,
      fullName: t.cardFullName,
      voterNo: t.cardVoterNo,
      fee: t.cardFee,
      registeredLine: (d, s) => t.cardRegisteredLine(d, s),
      qrNote: t.cardQrNote,
      officialSignature: t.cardOfficialSignature,
      officialSeal: t.cardOfficialSeal,
    );

RegisterLabels registerLabelsOf(AppLocalizations t, {required String idLabel, required String groupLabel}) =>
    RegisterLabels(
      title: t.registerTitle,
      voterNo: t.colVoterNo,
      name: t.colName,
      idLabel: idLabel,
      groupLabel: groupLabel,
      draftNote: t.registerDraftNote,
      lockedNote: (f) => t.registerLockedNote(f),
      generatedOn: (d) => t.printedOn(d),
      pageOf: (p, n) => t.pageOf('$p', '$n'),
      total: (n) => t.registerTotal('$n'),
    );

String _today() {
  final d = DateTime.now();
  return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}

CardLayout _lastLayout = CardLayout.idCardsOnA4;

/// Lets the official choose a card size, then print or save the cards.
/// Cards count as printed once sent to a printer or saved as a PDF.
Future<void> printVoterCards(BuildContext context, WidgetRef ref, List<String> voterIds) async {
  if (voterIds.isEmpty) return;
  await showDialog<void>(context: context, builder: (_) => _PrintCardsDialog(voterIds: voterIds));
}

class _PrintCardsDialog extends ConsumerStatefulWidget {
  const _PrintCardsDialog({required this.voterIds});
  final List<String> voterIds;
  @override
  ConsumerState<_PrintCardsDialog> createState() => _PrintCardsDialogState();
}

class _PrintCardsDialogState extends ConsumerState<_PrintCardsDialog> {
  CardLayout _layout = _lastLayout;
  bool _busy = false;

  Future<void> _go({required bool save}) async {
    final t = AppLocalizations.of(context);
    setState(() => _busy = true);
    _lastLayout = _layout;
    try {
      final cards = ref.read(cardServiceProvider);
      final data = await cards.cardData(widget.voterIds,
          feeText: (p) => p == null ? '' : (p.paid ? t.feePaidReceipt(p.receiptNo ?? '') : t.feeNotPaid));
      final pdf = await buildVoterCardsPdf(data, labels: cardLabelsOf(t), layout: _layout);
      final name = 'rakubavote-cards-${data.first.voterNoLabel}${data.length > 1 ? '-${data.last.voterNoLabel}' : ''}';
      final out = ref.read(pdfOutputProvider);
      var done = false;
      if (save) {
        final path = await out.savePdf(pdf, name: name);
        done = path != null;
        if (done && mounted) showMessage(context, t.pdfSavedIn(path));
      } else {
        done = await out.printPdf(pdf, name: name);
      }
      if (done) {
        await cards.markPrinted(widget.voterIds, official: ref.read(officialProvider));
        if (mounted) Navigator.pop(context);
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(t.printCardsTitle),
      content: SizedBox(
        width: 460,
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          FieldLabel(t.cardLayout),
          RadioGroup<CardLayout>(
            groupValue: _layout,
            onChanged: (v) => setState(() => _layout = v!),
            child: Column(children: [
              for (final (l, text) in [
                (CardLayout.idCardsOnA4, t.cardLayoutIdA4),
                (CardLayout.idCardSingle, t.cardLayoutIdSingle),
                (CardLayout.a6, t.cardLayoutA6),
              ])
                RadioListTile<CardLayout>(
                    key: ValueKey('layout-${l.name}'), contentPadding: EdgeInsets.zero, value: l, title: Text(text)),
            ]),
          ),
        ]),
      ),
      actions: [
        TextButton(onPressed: _busy ? null : () => Navigator.pop(context), child: Text(t.cancel)),
        OutlinedButton(
            key: const ValueKey('cards-save-pdf'), onPressed: _busy ? null : () => _go(save: true), child: Text(t.savePdf)),
        FilledButton(
            key: const ValueKey('cards-print'), onPressed: _busy ? null : () => _go(save: false), child: Text(t.printButton)),
      ],
    );
  }
}

/// The public register as a PDF to print or save (D20).
Future<void> printRegister(BuildContext context, WidgetRef ref) async {
  final t = AppLocalizations.of(context);
  final save = await showDialog<bool>(
    context: context,
    builder: (c) => AlertDialog(
      title: Text(t.printRegisterTitle),
      content: SizedBox(width: 420, child: Text(t.printRegisterNote, style: const TextStyle(fontSize: 16))),
      actions: [
        TextButton(onPressed: () => Navigator.pop(c), child: Text(t.cancel)),
        OutlinedButton(key: const ValueKey('register-save-pdf'), onPressed: () => Navigator.pop(c, true), child: Text(t.savePdf)),
        FilledButton(key: const ValueKey('register-print'), onPressed: () => Navigator.pop(c, false), child: Text(t.printButton)),
      ],
    ),
  );
  if (save == null) return;
  final r = await ref.read(cardServiceProvider).register();
  final e = r.election;
  final pdf = await buildRegisterPdf(
    orgName: e.orgName,
    electionName: e.name,
    year: e.year,
    stationName: e.stationName,
    lines: r.lines,
    labels: registerLabelsOf(t, idLabel: e.idLabel, groupLabel: e.groupLabel),
    generatedOn: _today(),
    fingerprint: r.fingerprint,
  );
  final out = ref.read(pdfOutputProvider);
  final name = 'rakubavote-register${r.fingerprint == null ? '-draft' : '-${r.fingerprint}'}';
  if (save) {
    final path = await out.savePdf(pdf, name: name);
    if (path != null && context.mounted) showMessage(context, t.pdfSavedIn(path));
  } else {
    await out.printPdf(pdf, name: name);
  }
}

/// Card status shown in the register list.
Widget cardStatus(AppLocalizations t, {required int cardIssue, required int? printedIssue}) {
  final printed = printedIssue != null && printedIssue >= cardIssue;
  return Text(
    printed ? t.cardPrinted : (printedIssue == null ? t.cardNotPrinted : t.cardNeedsReprint),
    style: TextStyle(color: printed ? RakubaColors.acaciaGreen : RakubaColors.clay, fontWeight: FontWeight.w700),
  );
}

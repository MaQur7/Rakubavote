import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/db/ballot_box_repository.dart';
import '../../core/domain/ballot_definition.dart';
import '../../core/domain/vote.dart';
import '../../core/format.dart';
import '../../core/theme.dart';
import '../../l10n/app_localizations.dart';
import '../../platform/beep.dart';
import 'booth_controller.dart';
import 'booth_widgets.dart';

/// The voter-facing booth (mockups 2, 3, 3b, 4, 5). The chosen ballot
/// language applies to this screen only, including right-to-left Arabic.
class BoothScreen extends StatefulWidget {
  const BoothScreen({
    super.key,
    required this.controller,
    this.onOfficerExit,
    this.beep,
    this.clearAfter = const Duration(seconds: 10),
  });

  final BoothController controller;
  /// Called after a long press on the top corner (the officer leaves).
  final VoidCallback? onOfficerExit;
  final Beep? beep;
  final Duration clearAfter;

  @override
  State<BoothScreen> createState() => _BoothScreenState();
}

class _BoothScreenState extends State<BoothScreen> {
  Map<String, Uint8List> _media = const {};

  BoothController get c => widget.controller;

  @override
  void initState() {
    super.initState();
    c.addListener(_changed);
    c.repo.media(c.ballot.mediaHashes).then((m) {
      if (mounted) setState(() => _media = m);
    });
  }

  @override
  void dispose() {
    c.removeListener(_changed);
    super.dispose();
  }

  void _changed() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final locale = Locale(c.locale);
    final arabic = c.locale == 'ar';
    return Localizations.override(
      context: context,
      locale: locale,
      child: Theme(
        data: buildRakubaTheme(arabic: arabic),
        child: Builder(builder: (context) {
          final page = switch (c.stage) {
            BoothStage.welcome => _WelcomePage(c: c, media: _media),
            BoothStage.position => c.position.candidates.length >= 13
                ? _LongListPage(key: ValueKey('long-${c.index}'), c: c, media: _media)
                : _PositionPage(key: ValueKey('pos-${c.index}'), c: c, media: _media),
            BoothStage.review => _ReviewPage(c: c, media: _media),
            BoothStage.end => _EndPage(c: c, beep: widget.beep, clearAfter: widget.clearAfter),
          };
          return Scaffold(
            backgroundColor: RakubaColors.white,
            body: Stack(children: [
              SafeArea(child: page),
              // Officer exit: long press on the top start corner.
              PositionedDirectional(
                top: 0,
                start: 0,
                width: 72,
                height: 72,
                child: GestureDetector(
                  key: const ValueKey('officer-corner'),
                  behavior: HitTestBehavior.translucent,
                  onLongPress: widget.onOfficerExit,
                ),
              ),
            ]),
          );
        }),
      ),
    );
  }
}

// ---------------------------------------------------------------- welcome (2)

class _WelcomePage extends StatefulWidget {
  const _WelcomePage({required this.c, required this.media});
  final BoothController c;
  final Map<String, Uint8List> media;
  @override
  State<_WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<_WelcomePage> {
  final _code = TextEditingController();
  String? _problem;
  bool _busy = false;

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  Future<void> _start() async {
    final t = AppLocalizations.of(context);
    setState(() => _busy = true);
    final p = await widget.c.submitCode(_code.text);
    if (!mounted) return;
    setState(() {
      _busy = false;
      _problem = switch (p) {
        null => null,
        CodeProblem.notFound => t.codeNotFound,
        CodeProblem.alreadyUsed => t.codeUsed,
        CodeProblem.tooManyTries => t.tooManyTries,
      };
      if (p != null) _code.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final b = widget.c.ballot;
    final logo = b.orgLogoSha256 == null ? null : widget.media[b.orgLogoSha256];
    return LayoutBuilder(builder: (context, box) {
      return SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(32, 16, 32, 32),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: box.maxHeight - 48),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            const Align(alignment: AlignmentDirectional.centerEnd, child: HelpButton()),
            const SizedBox(height: 8),
            Center(
              child: Container(
                width: 132,
                height: 132,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: RakubaColors.thatchGold, width: 3),
                ),
                clipBehavior: Clip.antiAlias,
                child: logo == null ? null : Image.memory(logo, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 20),
            Text(b.orgName,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w700, color: RakubaColors.ink)),
            Text('${b.electionName} ${b.year}',
                textAlign: TextAlign.center, style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 10),
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                color: RakubaColors.ink,
                child: Text(t.officialBallot,
                    style: const TextStyle(color: RakubaColors.white, fontSize: 18, fontWeight: FontWeight.w700)),
              ),
            ),
            const SizedBox(height: 24),
            Wrap(alignment: WrapAlignment.center, spacing: 12, runSpacing: 12, children: [
              for (final code in b.languages)
                OutlinedButton(
                  key: ValueKey('lang-$code'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(110, RakubaSizes.minTouch),
                    backgroundColor: code == widget.c.locale ? tintOf(RakubaColors.nileBlue, 0.12) : null,
                    side: BorderSide(
                        color: code == widget.c.locale ? RakubaColors.nileBlue : RakubaColors.border,
                        width: code == widget.c.locale ? 3 : 2),
                  ),
                  onPressed: () => widget.c.setLanguage(code),
                  child: Text(languageDisplayName(code), style: const TextStyle(fontSize: 20)),
                ),
            ]),
            const SizedBox(height: 28),
            Text(t.typeCode, textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            TextField(
              key: const ValueKey('booth-code'),
              controller: _code,
              textAlign: TextAlign.center,
              textDirection: TextDirection.ltr,
              textCapitalization: TextCapitalization.characters,
              autocorrect: false,
              enableSuggestions: false,
              maxLength: 7,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9\- ]'))],
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w700, letterSpacing: 10),
              decoration: const InputDecoration(counterText: '', hintText: '___-___'),
              onSubmitted: (_) => _start(),
            ),
            const SizedBox(height: 8),
            if (_problem != null)
              Text(_problem!,
                  key: const ValueKey('booth-code-problem'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 20, color: RakubaColors.clay, fontWeight: FontWeight.w700))
            else
              Text(t.askAnOfficial, textAlign: TextAlign.center, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            FilledButton(
              key: const ValueKey('start-voting'),
              style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(80),
                  textStyle: buttonTextStyle(context, 26)),
              onPressed: _busy ? null : _start,
              child: Text(t.startVoting),
            ),
            const SizedBox(height: 32),
            Text(t.secrecyFooter, textAlign: TextAlign.center, style: const TextStyle(fontSize: 18)),
            Text(t.numbersHelp, textAlign: TextAlign.center, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 4),
            Text(t.poweredBy,
                textAlign: TextAlign.center,
                textDirection: TextDirection.ltr,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          ]),
        ),
      );
    });
  }
}

// ------------------------------------------------------ shared position parts

String _instruction(AppLocalizations t, PositionDef p) => p.chooseN == 1
    ? (p.allowNoChoice ? t.tapOneOrNoChoice : t.tapOne)
    : (p.allowNoChoice ? t.tapUpToOrNoChoice('${p.chooseN}') : t.tapUpTo('${p.chooseN}'));

class _TopBar extends StatelessWidget {
  const _TopBar({required this.c});
  final BoothController c;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final colour = Color(c.position.colour);
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 12, 24, 12),
      child: Column(children: [
        Row(children: [
          Expanded(
            child: Text(t.positionOf('${c.index + 1}', '${c.positionCount}'),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          ),
          const HelpButton(),
        ]),
        const SizedBox(height: 12),
        Row(children: [
          for (var i = 0; i < c.positionCount; i++) ...[
            if (i > 0) const SizedBox(width: 8),
            Expanded(
              child: Container(
                height: 10,
                decoration: BoxDecoration(
                  color: i <= c.index ? colour : RakubaColors.placeholder,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
          ],
        ]),
      ]),
    );
  }
}

class _Band extends StatelessWidget {
  const _Band({required this.c, this.subtitle});
  final BoothController c;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final p = c.position;
    return Container(
      width: double.infinity,
      color: Color(p.colour),
      padding: const EdgeInsets.fromLTRB(32, 18, 32, 18),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(p.title(c.locale),
            key: const ValueKey('position-title'),
            style: const TextStyle(color: RakubaColors.white, fontSize: 34, fontWeight: FontWeight.w700)),
        Text(subtitle ?? _instruction(t, p), style: const TextStyle(color: RakubaColors.white, fontSize: 18)),
      ]),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.c, this.leading});
  final BoothController c;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final colour = Color(c.position.colour);
    final next = c.nextPosition;
    return Container(
      decoration: const BoxDecoration(border: Border(top: BorderSide(color: RakubaColors.placeholder))),
      padding: const EdgeInsets.fromLTRB(32, 14, 32, 14),
      child: Row(children: [
        if (leading != null) Expanded(child: leading!) else ...[
          OutlinedButton(
            key: const ValueKey('booth-back'),
            style: OutlinedButton.styleFrom(minimumSize: const Size(120, 72)),
            onPressed: c.back,
            child: Text(t.back),
          ),
          const SizedBox(width: 16),
        ],
        Expanded(
          flex: leading == null ? 1 : 0,
          child: FilledButton(
            key: const ValueKey('booth-next'),
            style: FilledButton.styleFrom(
              minimumSize: const Size(160, 72),
              backgroundColor: colour,
              textStyle: buttonTextStyle(context, 22),
            ),
            onPressed: c.canContinue ? c.next : null,
            child: Text(next == null ? t.reviewButton : t.nextPosition(next.title(c.locale)),
                textAlign: TextAlign.center),
          ),
        ),
      ]),
    );
  }
}

class _NoChoiceRow extends StatelessWidget {
  const _NoChoiceRow({required this.c, this.compact = false});
  final BoothController c;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final p = c.position;
    final selected = c.isNoChoice(p.id);
    final colour = Color(p.colour);
    return Semantics(
      button: true,
      selected: selected,
      label: t.noChoiceForPosition,
      child: InkWell(
        key: const ValueKey('no-choice'),
        onTap: c.tapNoChoice,
        borderRadius: BorderRadius.circular(12),
        child: CustomPaint(
          foregroundPainter:
              DashedBorderPainter(color: selected ? colour : RakubaColors.border, width: selected ? 3 : 2),
          child: Container(
            constraints: BoxConstraints(minHeight: compact ? 72 : 100),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: selected ? tintOf(colour, 0.15) : RakubaColors.paper,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(children: [
              if (!compact) ...[
                const Icon(Icons.block, size: 40, color: RakubaColors.ink),
                const SizedBox(width: 16),
              ],
              Expanded(
                child: Text(t.noChoiceForPosition,
                    style: TextStyle(fontSize: compact ? 18 : 24, fontWeight: FontWeight.w700)),
              ),
              if (compact)
                (selected ? Icon(Icons.check, color: colour, size: 32) : const SizedBox.shrink())
              else
                TickBox(checked: selected, colour: colour),
            ]),
          ),
        ),
      ),
    );
  }
}

// ----------------------------------------------------- position, up to 12 (3)

class _PositionPage extends StatelessWidget {
  const _PositionPage({super.key, required this.c, required this.media});
  final BoothController c;
  final Map<String, Uint8List> media;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final p = c.position;
    final colour = Color(p.colour);
    return Column(children: [
      _TopBar(c: c),
      _Band(c: c),
      Expanded(
        child: Container(
          color: tintOf(colour),
          child: ListView(padding: const EdgeInsets.fromLTRB(32, 20, 32, 20), children: [
            for (final cand in p.candidates) ...[
              _CandidateRow(c: c, cand: cand, media: media),
              const SizedBox(height: 14),
            ],
            if (p.allowNoChoice) _NoChoiceRow(c: c),
            const SizedBox(height: 16),
            Text(t.changeNote, style: const TextStyle(fontSize: 18)),
            if (p.chooseN > 1)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(t.chosenCount('${c.selectionFor(p.id).where((x) => x != noChoice).length}', '${p.chooseN}'),
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              ),
          ]),
        ),
      ),
      _BottomBar(c: c),
    ]);
  }
}

class _CandidateRow extends StatelessWidget {
  const _CandidateRow({required this.c, required this.cand, required this.media});
  final BoothController c;
  final CandidateDef cand;
  final Map<String, Uint8List> media;

  @override
  Widget build(BuildContext context) {
    final p = c.position;
    final selected = c.isSelected(p.id, cand.id);
    final colour = Color(p.colour);
    return Semantics(
      button: true,
      selected: selected,
      label: '${cand.number} ${cand.name}',
      child: Material(
        color: RakubaColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: selected ? colour : RakubaColors.border, width: selected ? 4 : 2),
        ),
        child: InkWell(
          key: ValueKey('cand-${cand.number}'),
          borderRadius: BorderRadius.circular(12),
          onTap: () => c.tapCandidate(cand.id),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(children: [
              CircleImage(media[cand.photoSha256], size: 96),
              const SizedBox(width: 18),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    NumberBox(candidateNoLabel(cand.number, candidateCount: p.candidates.length)),
                    const SizedBox(width: 10),
                    SymbolImage(media[cand.symbolSha256]),
                  ]),
                  const SizedBox(height: 8),
                  Text(cand.name, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w700)),
                ]),
              ),
              TickBox(checked: selected, colour: colour, size: 72),
            ]),
          ),
        ),
      ),
    );
  }
}

// -------------------------------------------------- position, 13 or more (3b)

class _LongListPage extends StatefulWidget {
  const _LongListPage({super.key, required this.c, required this.media});
  final BoothController c;
  final Map<String, Uint8List> media;
  @override
  State<_LongListPage> createState() => _LongListPageState();
}

class _LongListPageState extends State<_LongListPage> {
  final _number = TextEditingController();
  bool _unknown = false;

  @override
  void dispose() {
    _number.dispose();
    super.dispose();
  }

  void _typed(String text) {
    final n = int.tryParse(text.trim());
    if (n == null) {
      setState(() => _unknown = false);
      return;
    }
    final ok = widget.c.chooseByNumber(n);
    setState(() => _unknown = !ok && text.trim().length >= 2);
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final c = widget.c;
    final p = c.position;
    final colour = Color(p.colour);
    final chosen = [for (final id in c.selectionFor(p.id)) if (id != noChoice) p.candidateById(id)!];
    final choiceText = c.isNoChoice(p.id)
        ? t.noChoiceForPosition
        : chosen.map((x) => '${candidateNoLabel(x.number, candidateCount: p.candidates.length)} · ${x.name}').join(', ');
    final cells = <Widget>[
      for (final cand in p.candidates) _CompactRow(c: c, cand: cand, media: widget.media),
      if (p.allowNoChoice) _NoChoiceRow(c: c, compact: true),
    ];
    return Column(children: [
      _TopBar(c: c),
      _Band(c: c, subtitle: t.bigListHeader('${p.candidates.length}')),
      Container(
        color: tintOf(colour, 0.12),
        padding: const EdgeInsets.fromLTRB(32, 12, 32, 12),
        child: Row(children: [
          Text(t.candidateNumberLabel, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
          const SizedBox(width: 16),
          SizedBox(
            width: 130,
            child: TextField(
              key: const ValueKey('candidate-number'),
              controller: _number,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              textDirection: TextDirection.ltr,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(3)],
              style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w700),
              onChanged: _typed,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(_unknown ? t.noCandidateWithNumber : t.showsMatching,
                style: TextStyle(fontSize: 16, color: _unknown ? RakubaColors.clay : RakubaColors.ink)),
          ),
        ]),
      ),
      Expanded(
        child: LayoutBuilder(builder: (context, box) {
          final columns = box.maxWidth >= 560 ? 2 : 1;
          return GridView.count(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
            crossAxisCount: columns,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: (box.maxWidth - 48 - (columns - 1) * 12) / columns / 84,
            children: cells,
          );
        }),
      ),
      _BottomBar(
        c: c,
        leading: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(t.yourChoice, style: const TextStyle(fontSize: 16)),
          Text(choiceText.isEmpty ? '—' : choiceText,
              key: const ValueKey('your-choice'),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
        ]),
      ),
    ]);
  }
}

class _CompactRow extends StatelessWidget {
  const _CompactRow({required this.c, required this.cand, required this.media});
  final BoothController c;
  final CandidateDef cand;
  final Map<String, Uint8List> media;

  @override
  Widget build(BuildContext context) {
    final p = c.position;
    final selected = c.isSelected(p.id, cand.id);
    final colour = Color(p.colour);
    return Semantics(
      button: true,
      selected: selected,
      label: '${cand.number} ${cand.name}',
      child: Material(
        color: selected ? tintOf(colour, 0.15) : RakubaColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: selected ? colour : RakubaColors.border, width: selected ? 4 : 2),
        ),
        child: InkWell(
          key: ValueKey('cand-${cand.number}'),
          borderRadius: BorderRadius.circular(12),
          onTap: () => c.tapCandidate(cand.id),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(children: [
              NumberBox(candidateNoLabel(cand.number, candidateCount: p.candidates.length), size: 48),
              const SizedBox(width: 10),
              CircleImage(media[cand.photoSha256], size: 52),
              const SizedBox(width: 10),
              Expanded(
                child: Text(cand.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
              ),
              if (selected) Icon(Icons.check, color: colour, size: 32),
            ]),
          ),
        ),
      ),
    );
  }
}

// --------------------------------------------------------------- review (4)

class _ReviewPage extends StatefulWidget {
  const _ReviewPage({required this.c, required this.media});
  final BoothController c;
  final Map<String, Uint8List> media;
  @override
  State<_ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<_ReviewPage> {
  bool _busy = false;
  String? _problem;

  Future<void> _confirm() async {
    final t = AppLocalizations.of(context);
    setState(() => _busy = true);
    try {
      await widget.c.confirm();
    } on CastBallotException {
      // The code was used at another booth meanwhile; nothing was saved here.
      setState(() => _problem = t.codeUsedElsewhere);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final c = widget.c;
    return Column(children: [
      Expanded(
        child: ListView(padding: const EdgeInsets.fromLTRB(32, 24, 32, 16), children: [
          Row(children: [
            Expanded(
                child: Text(t.checkChoices, style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w700))),
            const HelpButton(),
          ]),
          const SizedBox(height: 6),
          Text(t.notSavedUntil, style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 20),
          for (var i = 0; i < c.positionCount; i++) ...[
            _ReviewCard(c: c, index: i, media: widget.media),
            const SizedBox(height: 16),
          ],
        ]),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(32, 8, 32, 20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          if (_problem != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(_problem!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 20, color: RakubaColors.clay, fontWeight: FontWeight.w700)),
            ),
          FilledButton(
            key: const ValueKey('confirm-vote'),
            style: FilledButton.styleFrom(
              backgroundColor: RakubaColors.acaciaGreen,
              minimumSize: const Size.fromHeight(84),
              textStyle: buttonTextStyle(context, 28),
            ),
            onPressed: _busy || _problem != null ? null : _confirm,
            child: Text(t.confirmMyVote),
          ),
          const SizedBox(height: 10),
          Text(t.cannotChangeAfter, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16)),
        ]),
      ),
    ]);
  }
}

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({required this.c, required this.index, required this.media});
  final BoothController c;
  final int index;
  final Map<String, Uint8List> media;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final p = c.ballot.positions[index];
    final colour = Color(p.colour);
    final sel = c.selectionFor(p.id);
    final none = sel.contains(noChoice);
    final rows = none ? <CandidateDef?>[null] : [for (final id in sel) p.candidateById(id)];
    return Container(
      key: ValueKey('review-${p.id}'),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colour, width: 2),
        color: tintOf(colour),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Container(
          color: colour,
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
          child: Text(p.title(c.locale),
              style: const TextStyle(color: RakubaColors.white, fontSize: 22, fontWeight: FontWeight.w700)),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
          child: Row(children: [
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                for (final cand in rows)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(children: [
                      CircleImage(cand == null ? null : media[cand.photoSha256], size: 64, dashed: cand == null),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          cand == null
                              ? t.noChoiceForPosition
                              : '${candidateNoLabel(cand.number, candidateCount: p.candidates.length)} · ${cand.name}',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: cand == null ? colour : RakubaColors.ink),
                        ),
                      ),
                    ]),
                  ),
              ]),
            ),
            OutlinedButton(
              key: ValueKey('change-$index'),
              style: OutlinedButton.styleFrom(
                foregroundColor: colour,
                side: BorderSide(color: colour, width: 2),
                backgroundColor: RakubaColors.white,
                minimumSize: const Size(110, RakubaSizes.minTouch),
              ),
              onPressed: () => c.change(index),
              child: Text(t.change),
            ),
          ]),
        ),
      ]),
    );
  }
}

// ------------------------------------------------------------------ end (5)

class _EndPage extends StatefulWidget {
  const _EndPage({required this.c, required this.clearAfter, this.beep});
  final BoothController c;
  final Duration clearAfter;
  final Beep? beep;
  @override
  State<_EndPage> createState() => _EndPageState();
}

class _EndPageState extends State<_EndPage> {
  Timer? _timer;
  late int _left = widget.clearAfter.inSeconds;

  @override
  void initState() {
    super.initState();
    widget.beep?.play();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      if (_left <= 1) {
        t.cancel();
        widget.c.reset();
      } else {
        setState(() => _left--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return Container(
      color: RakubaColors.successTint,
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
          width: 168,
          height: 168,
          decoration: const BoxDecoration(color: RakubaColors.acaciaGreen, shape: BoxShape.circle),
          child: const Icon(Icons.check, color: RakubaColors.white, size: 120),
        ),
        const SizedBox(height: 24),
        Text(t.endTitle,
            key: const ValueKey('end-title'),
            style: const TextStyle(fontSize: 72, fontWeight: FontWeight.w700, color: RakubaColors.acaciaGreen)),
        const SizedBox(height: 16),
        Text(t.thankYou,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w700, color: RakubaColors.acaciaGreen)),
        const SizedBox(height: 16),
        Text(t.beepNote, textAlign: TextAlign.center, style: const TextStyle(fontSize: 18)),
        const SizedBox(height: 28),
        Text(t.secrecyFooter,
            textAlign: TextAlign.center, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
        const SizedBox(height: 28),
        Text(t.clearsIn('$_left'), textAlign: TextAlign.center, style: const TextStyle(fontSize: 20)),
      ]),
    );
  }
}

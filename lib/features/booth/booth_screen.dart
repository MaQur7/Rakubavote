import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../core/brand/brand.dart';
import 'package:flutter/services.dart';

import '../../core/db/ballot_box_repository.dart';
import '../../core/domain/ballot_definition.dart';
import '../../core/domain/vote.dart';
import '../../core/format.dart';
import '../../core/theme.dart';
import '../../core/widgets/common.dart';
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
    this.pollsClosed,
  });

  /// Becomes true when the laptop closes the polls; the booth then stops.
  final ValueListenable<bool>? pollsClosed;

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
    widget.pollsClosed?.addListener(_changed);
    c.repo.media(c.ballot.mediaHashes).then((m) {
      if (mounted) setState(() => _media = m);
    });
  }

  @override
  void dispose() {
    c.removeListener(_changed);
    widget.pollsClosed?.removeListener(_changed);
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
          final closed = widget.pollsClosed?.value ?? false;
          final page = switch (c.stage) {
            BoothStage.welcome when closed => const _ClosedPage(),
            BoothStage.welcome => _WelcomePage(c: c, media: _media),
            BoothStage.position => c.position.candidates.length >= 13
                ? _LongListPage(key: ValueKey('long-${c.index}'), c: c, media: _media)
                : _PositionPage(key: ValueKey('pos-${c.index}'), c: c, media: _media),
            BoothStage.review => _ReviewPage(c: c, media: _media),
            BoothStage.end => _EndPage(c: c, beep: widget.beep, clearAfter: widget.clearAfter),
          };
          return Scaffold(
            backgroundColor: RakubaColors.card,
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
        padding: const EdgeInsets.fromLTRB(RakubaSpace.l, RakubaSpace.s, RakubaSpace.l, RakubaSpace.l),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: box.maxHeight - RakubaSpace.xl),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            const Align(alignment: AlignmentDirectional.centerEnd, child: HelpButton()),
            const SizedBox(height: RakubaSpace.xs),
            // The organisation's logo only when it has one; never an empty shape.
            if (logo != null) ...[
              Center(
                child: ClipOval(child: Image.memory(logo, width: 128, height: 128, fit: BoxFit.cover)),
              ),
              const SizedBox(height: RakubaSpace.m),
            ] else
              const SizedBox(height: RakubaSpace.l),
            Text(b.orgName, textAlign: TextAlign.center, style: rakubaText(context, RakubaType.title, bold: true)),
            Text('${b.electionName} ${b.year}',
                textAlign: TextAlign.center, style: rakubaText(context, RakubaType.bodyLarge)),
            const SizedBox(height: RakubaSpace.s),
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: RakubaSpace.s, vertical: RakubaSpace.xs),
                color: RakubaColors.ink,
                child: Text(t.officialBallot,
                    style: rakubaText(context, RakubaType.bodyLarge, bold: true, colour: RakubaColors.white)),
              ),
            ),
            const SizedBox(height: RakubaSpace.l),
            Wrap(alignment: WrapAlignment.center, spacing: RakubaSpace.s, runSpacing: RakubaSpace.s, children: [
              for (final code in b.languages) _LanguageButton(c: widget.c, code: code),
            ]),
            const SizedBox(height: RakubaSpace.l),
            Text(t.typeCode, textAlign: TextAlign.center, style: rakubaText(context, RakubaType.name, bold: true)),
            const SizedBox(height: RakubaSpace.s),
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
              style: rakubaText(context, RakubaType.display, bold: true).copyWith(letterSpacing: RakubaSpace.xs),
              decoration: InputDecoration(
                counterText: '',
                hintText: '___-___',
                hintStyle: rakubaText(context, RakubaType.display, colour: RakubaColors.inkMuted)
                    .copyWith(letterSpacing: RakubaSpace.xs),
              ),
              onSubmitted: (_) => _start(),
            ),
            const SizedBox(height: RakubaSpace.xs),
            if (_problem != null)
              NoticeBox(
                child: Text(_problem!,
                    key: const ValueKey('booth-code-problem'),
                    style: rakubaText(context, RakubaType.bodyLarge, bold: true)),
              )
            else
              Text(t.askAnOfficial, textAlign: TextAlign.center, style: rakubaText(context, RakubaType.bodyLarge)),
            const SizedBox(height: RakubaSpace.m),
            FilledButton(
              key: const ValueKey('start-voting'),
              style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(RakubaSpace.xxl + RakubaSpace.s),
                  textStyle: buttonTextStyle(context, RakubaType.name)),
              onPressed: _busy ? null : _start,
              child: Text(t.startVoting),
            ),
            const SizedBox(height: RakubaSpace.l),
            Text(t.secrecyFooter, textAlign: TextAlign.center, style: rakubaText(context, RakubaType.bodyLarge, bold: true)),
            Text(t.numbersHelp, textAlign: TextAlign.center, style: rakubaText(context, RakubaType.bodyLarge)),
            const SizedBox(height: RakubaSpace.m),
            Text(t.poweredBy,
                textAlign: TextAlign.center,
                textDirection: TextDirection.ltr,
                style: rakubaText(context, RakubaType.label, bold: true, colour: RakubaColors.inkMuted)),
          ]),
        ),
      );
    });
  }
}

/// Ballot language choice: the chosen one has a 3 px Nile Blue border and a tick.
class _LanguageButton extends StatelessWidget {
  const _LanguageButton({required this.c, required this.code});
  final BoothController c;
  final String code;

  @override
  Widget build(BuildContext context) {
    final chosen = code == c.locale;
    final label = Text(languageDisplayName(code), style: rakubaText(context, RakubaType.bodyLarge, bold: true));
    final style = boothOutlinedStyle().copyWith(
      minimumSize: const WidgetStatePropertyAll(Size(RakubaSpace.xxl + RakubaSpace.xl, RakubaSizes.minTouch)),
      side: chosen
          ? const WidgetStatePropertyAll(BorderSide(color: RakubaColors.nileBlue, width: RakubaLine.selected))
          : null,
    );
    return Semantics(
      selected: chosen,
      child: chosen
          ? OutlinedButton.icon(
              key: ValueKey('lang-$code'),
              style: style,
              onPressed: () => c.setLanguage(code),
              icon: const BrandIcon(BrandIconKind.vote),
              label: label)
          : OutlinedButton(key: ValueKey('lang-$code'), style: style, onPressed: () => c.setLanguage(code), child: label),
    );
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
      padding: const EdgeInsets.fromLTRB(RakubaSpace.l, RakubaSpace.s, RakubaSpace.m, RakubaSpace.s),
      child: Column(children: [
        Row(children: [
          Expanded(
            child: Text(t.positionOf('${c.index + 1}', '${c.positionCount}'),
                style: rakubaText(context, RakubaType.bodyLarge, bold: true)),
          ),
          const HelpButton(),
        ]),
        const SizedBox(height: RakubaSpace.s),
        Row(children: [
          for (var i = 0; i < c.positionCount; i++) ...[
            if (i > 0) const SizedBox(width: RakubaSpace.xs),
            Expanded(
              child: Container(
                height: RakubaSpace.xs,
                // Progress segments are small roof bars.
                decoration: BoxDecoration(
                  color: i <= c.index ? colour : RakubaColors.rule,
                  borderRadius: BorderRadius.circular(RakubaSpace.xs / 4),
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
      padding: const EdgeInsets.symmetric(horizontal: RakubaSpace.l, vertical: RakubaSpace.s),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(p.title(c.locale),
            key: const ValueKey('position-title'),
            style: rakubaText(context, RakubaType.title, bold: true, colour: RakubaColors.white)),
        Text(subtitle ?? _instruction(t, p),
            style: rakubaText(context, RakubaType.bodyLarge, colour: RakubaColors.white)),
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
      decoration: const BoxDecoration(border: Border(top: BorderSide(color: RakubaColors.rule))),
      padding: const EdgeInsets.symmetric(horizontal: RakubaSpace.l, vertical: RakubaSpace.s),
      child: Row(children: [
        if (leading != null) Expanded(child: leading!) else ...[
          OutlinedButton(
            key: const ValueKey('booth-back'),
            style: boothOutlinedStyle().copyWith(
                minimumSize: const WidgetStatePropertyAll(Size(RakubaSpace.xxl * 2, RakubaSpace.xxl + RakubaSpace.xs))),
            onPressed: c.back,
            child: Text(t.back),
          ),
          const SizedBox(width: RakubaSpace.s),
        ],
        Expanded(
          flex: leading == null ? 1 : 0,
          child: FilledButton(
            key: const ValueKey('booth-next'),
            style: filledColourStyle(colour).copyWith(
              minimumSize: const WidgetStatePropertyAll(Size(RakubaSpace.xxl * 2, RakubaSpace.xxl + RakubaSpace.xs)),
              textStyle: WidgetStatePropertyAll(buttonTextStyle(context, RakubaType.heading)),
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
        borderRadius: BorderRadius.circular(RakubaRadius.control),
        child: CustomPaint(
          foregroundPainter: DashedBorderPainter(
              color: selected ? colour : RakubaColors.border,
              width: selected ? RakubaLine.selected : RakubaLine.strong),
          child: Container(
            constraints: BoxConstraints(minHeight: compact ? RakubaSpace.xxl : RakubaSpace.xxl + RakubaSpace.l),
            padding: EdgeInsets.symmetric(
                horizontal: compact ? RakubaSpace.xs : RakubaSpace.s, vertical: RakubaSpace.xs),
            decoration: BoxDecoration(
              color: RakubaColors.paper,
              borderRadius: BorderRadius.circular(RakubaRadius.control),
            ),
            child: Row(children: [
              if (!compact) ...[
                const Icon(Icons.block, size: RakubaSpace.xl, color: RakubaColors.ink),
                const SizedBox(width: RakubaSpace.s),
              ],
              Expanded(
                child: Text(t.noChoiceForPosition,
                    style: rakubaText(context, compact ? RakubaType.bodyLarge : RakubaType.name, bold: true)),
              ),
              TickBox(checked: selected, colour: colour, size: compact ? RakubaSpace.xl : RakubaSpace.xxl + RakubaSpace.xs),
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
          child: ListView(padding: const EdgeInsets.symmetric(horizontal: RakubaSpace.l, vertical: RakubaSpace.m), children: [
            for (final cand in p.candidates) ...[
              _CandidateRow(c: c, cand: cand, media: media),
              const SizedBox(height: RakubaSpace.s),
            ],
            if (p.allowNoChoice) _NoChoiceRow(c: c),
            const SizedBox(height: RakubaSpace.s),
            Text(t.changeNote, style: rakubaText(context, RakubaType.bodyLarge)),
            if (p.chooseN > 1)
              Padding(
                padding: const EdgeInsets.only(top: RakubaSpace.xs),
                child: Text(t.chosenCount('${c.selectionFor(p.id).where((x) => x != noChoice).length}', '${p.chooseN}'),
                    style: rakubaText(context, RakubaType.bodyLarge, bold: true)),
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
      child: _BallotRowShape(
        selected: selected,
        colour: colour,
        child: InkWell(
          key: ValueKey('cand-${cand.number}'),
          borderRadius: BorderRadius.circular(RakubaRadius.control),
          onTap: () => c.tapCandidate(cand.id),
          child: Padding(
            padding: const EdgeInsets.all(RakubaSpace.s),
            child: Row(children: [
              CircleImage(media[cand.photoSha256], size: RakubaSpace.xxl + RakubaSpace.l),
              const SizedBox(width: RakubaSpace.s),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    NumberBox(candidateNoLabel(cand.number, candidateCount: p.candidates.length)),
                    const SizedBox(width: RakubaSpace.xs),
                    SymbolImage(media[cand.symbolSha256]),
                  ]),
                  const SizedBox(height: RakubaSpace.xs),
                  Text(cand.name, style: rakubaText(context, RakubaType.name, bold: true)),
                ]),
              ),
              TickBox(checked: selected, colour: colour, size: RakubaSpace.xxl + RakubaSpace.xs),
            ]),
          ),
        ),
      ),
    );
  }
}

/// White row with a 2 px border; when chosen, a 3 px border in the position
/// colour (same on the two-candidate list and the 13-candidate grid).
class _BallotRowShape extends StatelessWidget {
  const _BallotRowShape({required this.selected, required this.colour, required this.child});
  final bool selected;
  final Color colour;
  final Widget child;

  @override
  Widget build(BuildContext context) => Material(
        color: RakubaColors.card,
        // The chosen border appears at once, never fading in.
        animationDuration: Duration.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(RakubaRadius.control),
          side: selected
              ? BorderSide(color: colour, width: RakubaLine.selected)
              : const BorderSide(color: RakubaColors.border, width: RakubaLine.strong),
        ),
        child: child,
      );
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
        padding: const EdgeInsets.symmetric(horizontal: RakubaSpace.l, vertical: RakubaSpace.s),
        child: Row(children: [
          Text(t.candidateNumberLabel, style: rakubaText(context, RakubaType.bodyLarge, bold: true)),
          const SizedBox(width: RakubaSpace.s),
          SizedBox(
            width: RakubaSpace.xxl * 2,
            child: TextField(
              key: const ValueKey('candidate-number'),
              controller: _number,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              textDirection: TextDirection.ltr,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(3)],
              style: rakubaText(context, RakubaType.title, bold: true),
              onChanged: _typed,
            ),
          ),
          const SizedBox(width: RakubaSpace.s),
          Expanded(
            child: Text(_unknown ? t.noCandidateWithNumber : t.showsMatching,
                style: rakubaText(context, RakubaType.body,
                    bold: _unknown, colour: _unknown ? RakubaColors.clay : RakubaColors.inkMuted)),
          ),
        ]),
      ),
      Expanded(
        child: LayoutBuilder(builder: (context, box) {
          final columns = box.maxWidth >= 560 ? 2 : 1;
          return GridView.count(
            padding: const EdgeInsets.symmetric(horizontal: RakubaSpace.m, vertical: RakubaSpace.s),
            crossAxisCount: columns,
            mainAxisSpacing: RakubaSpace.s,
            crossAxisSpacing: RakubaSpace.s,
            childAspectRatio:
                (box.maxWidth - RakubaSpace.xl - (columns - 1) * RakubaSpace.s) / columns / (RakubaSpace.xxl + RakubaSpace.s),
            children: cells,
          );
        }),
      ),
      _BottomBar(
        c: c,
        leading: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(t.yourChoice, style: rakubaText(context, RakubaType.body, colour: RakubaColors.inkMuted)),
          Text(choiceText.isEmpty ? '—' : choiceText,
              key: const ValueKey('your-choice'),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: rakubaText(context, RakubaType.heading, bold: true)),
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
      child: _BallotRowShape(
        selected: selected,
        colour: colour,
        child: InkWell(
          key: ValueKey('cand-${cand.number}'),
          borderRadius: BorderRadius.circular(RakubaRadius.control),
          onTap: () => c.tapCandidate(cand.id),
          child: Padding(
            padding: const EdgeInsets.all(RakubaSpace.xs),
            child: Row(children: [
              NumberBox(candidateNoLabel(cand.number, candidateCount: p.candidates.length), size: RakubaSpace.xl),
              const SizedBox(width: RakubaSpace.xs),
              CircleImage(media[cand.photoSha256], size: RakubaSpace.xl),
              const SizedBox(width: RakubaSpace.xs),
              Expanded(
                child: Text(cand.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: rakubaText(context, RakubaType.heading, bold: true)),
              ),
              TickBox(checked: selected, colour: colour, size: RakubaSpace.xl),
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
        child: ListView(padding: const EdgeInsets.fromLTRB(RakubaSpace.l, RakubaSpace.m, RakubaSpace.l, RakubaSpace.s), children: [
          Row(children: [
            Expanded(child: Text(t.checkChoices, style: rakubaText(context, RakubaType.title, bold: true))),
            const HelpButton(),
          ]),
          const SizedBox(height: RakubaSpace.xs),
          Text(t.notSavedUntil, style: rakubaText(context, RakubaType.bodyLarge)),
          const SizedBox(height: RakubaSpace.m),
          for (var i = 0; i < c.positionCount; i++) ...[
            _ReviewCard(c: c, index: i, media: widget.media),
            const SizedBox(height: RakubaSpace.s),
          ],
        ]),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(RakubaSpace.l, RakubaSpace.xs, RakubaSpace.l, RakubaSpace.m),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          if (_problem != null)
            Padding(
              padding: const EdgeInsets.only(bottom: RakubaSpace.s),
              child: NoticeBox(
                  child: Text(_problem!, style: rakubaText(context, RakubaType.bodyLarge, bold: true))),
            ),
          FilledButton(
            key: const ValueKey('confirm-vote'),
            style: filledColourStyle(RakubaColors.acaciaGreen).copyWith(
              minimumSize: const WidgetStatePropertyAll(Size.fromHeight(RakubaSpace.xxl + RakubaSpace.s)),
              textStyle: WidgetStatePropertyAll(buttonTextStyle(context, RakubaType.name)),
            ),
            onPressed: _busy || _problem != null ? null : _confirm,
            child: Text(t.confirmMyVote),
          ),
          const SizedBox(height: RakubaSpace.xs),
          Text(t.cannotChangeAfter,
              textAlign: TextAlign.center, style: rakubaText(context, RakubaType.body, colour: RakubaColors.inkMuted)),
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
        borderRadius: BorderRadius.circular(RakubaRadius.panel),
        border: Border.all(color: colour, width: RakubaLine.strong),
        color: tintOf(colour),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Container(
          color: colour,
          padding: const EdgeInsets.symmetric(horizontal: RakubaSpace.m, vertical: RakubaSpace.s),
          child: Text(p.title(c.locale),
              style: rakubaText(context, RakubaType.heading, bold: true, colour: RakubaColors.white)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: RakubaSpace.m, vertical: RakubaSpace.s),
          child: Row(children: [
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                for (final cand in rows)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: RakubaSpace.xxs),
                    child: Row(children: [
                      CircleImage(cand == null ? null : media[cand.photoSha256],
                          size: RakubaSpace.xxl, dashed: cand == null),
                      const SizedBox(width: RakubaSpace.s),
                      Expanded(
                        child: Text(
                          cand == null
                              ? t.noChoiceForPosition
                              : '${candidateNoLabel(cand.number, candidateCount: p.candidates.length)} · ${cand.name}',
                          style: rakubaText(context, RakubaType.name,
                              bold: true, colour: cand == null ? colour : RakubaColors.ink),
                        ),
                      ),
                    ]),
                  ),
              ]),
            ),
            OutlinedButton(
              key: ValueKey('change-$index'),
              style: colourOutlinedStyle(colour),
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
      padding: const EdgeInsets.all(RakubaSpace.l),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        // The mark's own tick, drawn short arm then long arm.
        const DrawnTick(size: RakubaSpace.xxl * 2 + RakubaSpace.l, colour: RakubaColors.acaciaGreen),
        const SizedBox(height: RakubaSpace.m),
        Text(t.endTitle,
            key: const ValueKey('end-title'),
            style: rakubaText(context, RakubaType.display, bold: true, colour: RakubaColors.acaciaGreen)),
        const SizedBox(height: RakubaSpace.s),
        Text(t.thankYou,
            textAlign: TextAlign.center,
            style: rakubaText(context, RakubaType.title, bold: true, colour: RakubaColors.acaciaGreen)),
        const SizedBox(height: RakubaSpace.s),
        Text(t.beepNote, textAlign: TextAlign.center, style: rakubaText(context, RakubaType.bodyLarge)),
        const SizedBox(height: RakubaSpace.l),
        Text(t.secrecyFooter,
            textAlign: TextAlign.center, style: rakubaText(context, RakubaType.heading, bold: true)),
        const SizedBox(height: RakubaSpace.l),
        Text(t.clearsIn('$_left'),
            textAlign: TextAlign.center, style: rakubaText(context, RakubaType.bodyLarge, colour: RakubaColors.inkMuted)),
      ]),
    );
  }
}

class _ClosedPage extends StatelessWidget {
  const _ClosedPage();

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(RakubaSpace.l),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const RakubaMark(size: RakubaSpace.xxl + RakubaSpace.l, scheme: MarkScheme.oneColour),
          const SizedBox(height: RakubaSpace.s),
          Text(t.pollsClosedTitle,
              key: const ValueKey('polls-closed'),
              textAlign: TextAlign.center,
              style: rakubaText(context, RakubaType.title, bold: true)),
          const SizedBox(height: RakubaSpace.s),
          Text(t.pollsClosedNote, textAlign: TextAlign.center, style: rakubaText(context, RakubaType.bodyLarge)),
        ]),
      ),
    );
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../core/db/registry_db.dart';
import '../../core/domain/templates.dart';
import '../../core/format.dart';
import '../../core/theme.dart';
import '../../core/widgets/common.dart';
import '../../l10n/app_localizations.dart';
import '../common_errors.dart';


import 'candidate_dialog.dart';
import 'election_service.dart';

String templateName(AppLocalizations t, ElectionTemplate tpl) => switch (tpl) {
  ElectionTemplate.school => t.templateSchool,
  ElectionTemplate.association => t.templateAssociation,
  ElectionTemplate.partyPrimary => t.templatePartyPrimary,
  ElectionTemplate.blank => t.templateBlank,
};

const ballotLanguageCodes = ['en', 'ar', 'din'];

/// Mockup A: election details, fee, positions and candidates, sign ballot.
class SetupScreen extends ConsumerWidget {
  const SetupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final svc = ref.watch(electionServiceProvider);
    return StreamBuilder<Election?>(
      stream: svc.watchElection(),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting && !snap.hasData) {
          return Padding(
            padding: const EdgeInsets.all(RakubaSpace.l),
            child: LoadingLine(AppLocalizations.of(context).loadingElection),
          );
        }
        final e = snap.data;
        return e == null
            ? const CreateElectionForm()
            : ElectionSetup(election: e);
      },
    );
  }
}

class CreateElectionForm extends ConsumerStatefulWidget {
  const CreateElectionForm({super.key});
  @override
  ConsumerState<CreateElectionForm> createState() => _CreateElectionFormState();
}

class _CreateElectionFormState extends ConsumerState<CreateElectionForm> {
  final _form = GlobalKey<FormState>();
  ElectionTemplate _template = ElectionTemplate.association;
  final _org = TextEditingController();
  final _name = TextEditingController();
  final _year = TextEditingController(text: '${DateTime.now().year}');
  final _station = TextEditingController(text: 'Station 1');
  final _languages = <String>{'en', 'ar'};

  @override
  void dispose() {
    for (final c in [_org, _name, _year, _station]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _create() async {
    if (!_form.currentState!.validate()) return;
    await ref
        .read(electionServiceProvider)
        .createElection(
          template: _template,
          orgName: _org.text,
          name: _name.text,
          year: int.parse(_year.text),
          stationName: _station.text,
          languages: [
            for (final c in ballotLanguageCodes)
              if (_languages.contains(c)) c,
          ],
          official: ref.read(officialProvider),
        );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    String? required(String? v) =>
        (v ?? '').trim().isEmpty ? t.fieldRequired : null;
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 620),
        child: Form(
          key: _form,
          child: ListView(
            padding: const EdgeInsets.all(RakubaSpace.m),
            children: [
              SectionCard(
                title: t.newElection,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    FieldLabel(t.template),
                    DropdownButtonFormField<ElectionTemplate>(
                      key: const ValueKey('create-template'),
                      isExpanded: true,
                      initialValue: _template,
                      items: [
                        for (final tpl in ElectionTemplate.values)
                          DropdownMenuItem(
                            value: tpl,
                            child: Text(templateName(t, tpl)),
                          ),
                      ],
                      onChanged: (v) => setState(() => _template = v!),
                    ),
                    FieldLabel(t.orgName),
                    TextFormField(
                      key: const ValueKey('create-org'),
                      controller: _org,
                      validator: required,
                    ),
                    FieldLabel(t.electionName),
                    TextFormField(
                      key: const ValueKey('create-name'),
                      controller: _name,
                      validator: required,
                    ),
                    FieldLabel(t.year),
                    TextFormField(
                      controller: _year,
                      keyboardType: TextInputType.number,
                      validator: (v) => int.tryParse(v ?? '') == null
                          ? t.fieldRequired
                          : null,
                    ),
                    FieldLabel(t.stationName),
                    TextFormField(controller: _station, validator: required),
                    FieldLabel(t.ballotLanguages),
                    Wrap(
                      spacing: RakubaSpace.xs,
                      children: [
                        for (final c in ballotLanguageCodes)
                          FilterChip(
                            label: Text(languageDisplayName(c)),
                            selected: _languages.contains(c),
                            onSelected: c == 'en'
                                ? null
                                : (s) => setState(
                                    () => s
                                        ? _languages.add(c)
                                        : _languages.remove(c),
                                  ),
                          ),
                      ],
                    ),
                    const SizedBox(height: RakubaSpace.m),
                    FilledButton(
                      key: const ValueKey('create-submit'),
                      onPressed: _create,
                      child: Text(t.createElection),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ElectionSetup extends ConsumerStatefulWidget {
  const ElectionSetup({super.key, required this.election});
  final Election election;
  @override
  ConsumerState<ElectionSetup> createState() => _ElectionSetupState();
}

class _ElectionSetupState extends ConsumerState<ElectionSetup> {
  String? _selectedPositionId;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final svc = ref.watch(electionServiceProvider);
    final e = widget.election;
    return StreamBuilder<List<Position>>(
      stream: svc.watchPositions(e.id),
      builder: (context, snap) {
        final positions = snap.data ?? const <Position>[];
        final selected =
            positions.where((p) => p.id == _selectedPositionId).firstOrNull ??
            positions.firstOrNull;
        final left = Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _DetailsCard(election: e),
            if (ElectionTemplate.fromWire(e.template).requiresConsent)
              _ConsentCard(election: e),
            _FeeCard(electionId: e.id),
            SectionCard(
              title: t.positions,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final p in positions)
                    _PositionTile(
                      position: p,
                      selected: p.id == selected?.id,
                      onTap: () => setState(() => _selectedPositionId = p.id),
                    ),
                  const SizedBox(height: RakubaSpace.xs),
                  OutlinedButton.icon(
                    key: const ValueKey('add-position'),
                    icon: const Icon(Icons.add),
                    label: Text(t.addPosition),
                    onPressed: () async {
                      try {
                        final id = await svc.addPosition(
                          e.id,
                          titles: {'en': t.newPositionTitle},
                          official: ref.read(officialProvider),
                        );
                        setState(() => _selectedPositionId = id);
                      } catch (err) {
                        if (context.mounted) {
                          showMessage(context, describeError(t, err));
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        );
        final right = selected == null
            ? SectionCard(
                child: Padding(
                  padding: const EdgeInsets.all(RakubaSpace.m),
                  child: Text(t.noPositionSelected),
                ),
              )
            : PositionEditor(
                key: ValueKey(selected.id),
                election: e,
                position: selected,
              );
        return LayoutBuilder(
          builder: (context, c) {
            if (c.maxWidth >= 900) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 320,
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(RakubaSpace.m, RakubaSpace.s, RakubaSpace.xs, RakubaSpace.m),
                      children: [left],
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(RakubaSpace.xs, RakubaSpace.s, RakubaSpace.m, RakubaSpace.m),
                      children: [
                        right,
                        _SignBar(election: e),
                      ],
                    ),
                  ),
                ],
              );
            }
            return ListView(
              padding: const EdgeInsets.all(RakubaSpace.s),
              children: [
                left,
                right,
                _SignBar(election: e),
              ],
            );
          },
        );
      },
    );
  }
}

class _PositionTile extends ConsumerWidget {
  const _PositionTile({
    required this.position,
    required this.selected,
    required this.onTap,
  });
  final Position position;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context);
    final titles = (jsonDecode(position.titles) as Map).cast<String, String>();
    return Padding(
      padding: const EdgeInsets.only(bottom: RakubaSpace.xs),
      child: Material(
        color: RakubaColors.card,
        animationDuration: Duration.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(RakubaRadius.control),
          side: selected
              ? const BorderSide(color: RakubaColors.nileBlue, width: RakubaLine.selected)
              : const BorderSide(color: RakubaColors.rule),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(RakubaRadius.control),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: RakubaSizes.minTouch),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: RakubaSpace.s, vertical: RakubaSpace.xs),
              child: Row(
                children: [
                  Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      color: Color(position.colour),
                      borderRadius: BorderRadius.circular(RakubaRadius.input),
                    ),
                  ),
                  const SizedBox(width: RakubaSpace.xs),
                  Expanded(
                    child: Text(
                      '${position.sortOrder} · ${titles['en'] ?? titles.values.firstOrNull ?? ''}',
                      style: rakubaText(context, RakubaType.body, bold: true),
                    ),
                  ),
                  StreamBuilder<List<Candidate>>(
                    stream: ref
                        .watch(electionServiceProvider)
                        .watchCandidates(position.id),
                    builder: (context, s) => Text(
                      t.candidatesCount(s.data?.length ?? 0),
                      style: rakubaText(context, RakubaType.label),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DetailsCard extends ConsumerStatefulWidget {
  const _DetailsCard({required this.election});
  final Election election;
  @override
  ConsumerState<_DetailsCard> createState() => _DetailsCardState();
}

class _DetailsCardState extends ConsumerState<_DetailsCard> {
  late final _org = TextEditingController(text: widget.election.orgName);
  late final _name = TextEditingController(text: widget.election.name);
  late final _station = TextEditingController(
    text: widget.election.stationName,
  );
  late final _idLabel = TextEditingController(text: widget.election.idLabel);
  late final _groupLabel = TextEditingController(
    text: widget.election.groupLabel,
  );

  @override
  void dispose() {
    for (final c in [_org, _name, _station, _idLabel, _groupLabel]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    final t = AppLocalizations.of(context);
    final e = widget.election;
    try {
      await ref
          .read(electionServiceProvider)
          .updateDetails(
            e.id,
            orgName: _org.text != e.orgName ? _org.text : null,
            name: _name.text != e.name ? _name.text : null,
            stationName: _station.text != e.stationName ? _station.text : null,
            idLabel: _idLabel.text != e.idLabel ? _idLabel.text : null,
            groupLabel: _groupLabel.text != e.groupLabel
                ? _groupLabel.text
                : null,
            official: ref.read(officialProvider),
          );
    } catch (err) {
      if (mounted) showMessage(context, describeError(t, err));
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final e = widget.election;
    final langs = (jsonDecode(e.languages) as List).cast<String>();
    Widget field(String label, TextEditingController c) => Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FieldLabel(label),
        Focus(
          onFocusChange: (has) {
            if (!has) _save();
          },
          child: TextField(controller: c, onSubmitted: (_) => _save()),
        ),
      ],
    );
    return SectionCard(
      title: t.electionDetails,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          field(t.electionName, _name),
          field(t.orgName, _org),
          FieldLabel(t.template),
          Text(
            templateName(t, ElectionTemplate.fromWire(e.template)),
            style: rakubaText(context, RakubaType.body),
          ),
          FieldLabel(t.ballotLanguages),
          Text(
            langs.map(languageDisplayName).join(', '),
            style: rakubaText(context, RakubaType.body),
          ),
          field(t.stationName, _station),
          field(t.idLabelField, _idLabel),
          field(t.groupLabelField, _groupLabel),
        ],
      ),
    );
  }
}

class _ConsentCard extends ConsumerWidget {
  const _ConsentCard({required this.election});
  final Election election;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context);
    return SectionCard(
      title: t.schoolConsent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CheckboxListTile(
            key: const ValueKey('school-consent'),
            contentPadding: EdgeInsets.zero,
            value: election.schoolConsentRecorded,
            title: Text(t.schoolConsentText),
            onChanged: election.schoolConsentRecorded
                ? null
                : (v) {
                    if (v == true) {
                      ref
                          .read(electionServiceProvider)
                          .recordSchoolConsent(
                            election.id,
                            official: ref.read(officialProvider),
                          );
                    }
                  },
          ),
          if (election.schoolConsentBy != null)
            Text(t.schoolConsentRecordedBy(election.schoolConsentBy!)),
        ],
      ),
    );
  }
}

class _FeeCard extends ConsumerStatefulWidget {
  const _FeeCard({required this.electionId});
  final String electionId;
  @override
  ConsumerState<_FeeCard> createState() => _FeeCardState();
}

class _FeeCardState extends ConsumerState<_FeeCard> {
  bool? _enabled;
  FeeCurrency? _currency;
  UnpaidPolicy? _policy;
  final _amount = TextEditingController();

  @override
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final svc = ref.watch(electionServiceProvider);
    return StreamBuilder<FeeConfig>(
      stream: svc.watchFeeConfig(widget.electionId),
      builder: (context, snap) {
        final f = snap.data;
        if (f == null) return const SizedBox.shrink();
        if (_enabled == null) {
          _enabled = f.enabled;
          _currency = FeeCurrencyWire.parse(f.currency);
          _policy = UnpaidPolicyWire.parse(f.unpaidPolicy);
          _amount.text = f.amount == 0 ? '' : '${f.amount}';
        }
        return FutureBuilder<bool>(
          future: svc.feeLocked(widget.electionId),
          builder: (context, lockedSnap) {
            final locked = lockedSnap.data ?? true;
            return SectionCard(
              title: t.registrationFee,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Under the heading, so the heading never breaks mid-word
                  // in the narrow column.
                  Row(
                    children: [
                      Checkbox(
                        key: const ValueKey('fee-enabled'),
                        value: _enabled,
                        onChanged: locked
                            ? null
                            : (v) => setState(() => _enabled = v),
                      ),
                      Expanded(child: Text(t.chargeFee)),
                    ],
                  ),
                  if (_enabled!) ...[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              FieldLabel(t.amount),
                              TextField(
                                key: const ValueKey('fee-amount'),
                                controller: _amount,
                                enabled: !locked,
                                keyboardType: TextInputType.number,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: RakubaSpace.xs),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              FieldLabel(t.currency),
                              DropdownButtonFormField<FeeCurrency>(
                                isExpanded: true,
                                initialValue: _currency,
                                items: [
                                  const DropdownMenuItem(
                                    value: FeeCurrency.ssp,
                                    child: Text('SSP'),
                                  ),
                                  const DropdownMenuItem(
                                    value: FeeCurrency.usd,
                                    child: Text('USD'),
                                  ),
                                  DropdownMenuItem(
                                    value: FeeCurrency.either,
                                    child: Text(t.currencyEither),
                                  ),
                                ],
                                onChanged: locked
                                    ? null
                                    : (v) => setState(() => _currency = v),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    FieldLabel(t.unpaidPolicy),
                    RadioGroup<UnpaidPolicy>(
                      groupValue: _policy,
                      onChanged: (v) {
                        if (!locked) setState(() => _policy = v);
                      },
                      child: Column(
                        children: [
                          RadioListTile(
                            contentPadding: EdgeInsets.zero,
                            enabled: !locked,
                            value: UnpaidPolicy.block,
                            title: Text(t.unpaidBlock),
                          ),
                          RadioListTile(
                            contentPadding: EdgeInsets.zero,
                            enabled: !locked,
                            value: UnpaidPolicy.allowFlagged,
                            title: Text(t.unpaidAllow),
                          ),
                        ],
                      ),
                    ),
                  ],
                  Text(
                    locked ? t.feeLockedNote : t.feeNote,
                    style: rakubaText(context, RakubaType.label),
                  ),
                  if (!locked) ...[
                    const SizedBox(height: RakubaSpace.xs),
                    OutlinedButton(
                      key: const ValueKey('fee-save'),
                      onPressed: () async {
                        try {
                          await svc.setFee(
                            widget.electionId,
                            enabled: _enabled!,
                            amount: int.tryParse(_amount.text.trim()) ?? 0,
                            currency: _currency!,
                            unpaidPolicy: _policy!,
                            official: ref.read(officialProvider),
                          );
                          if (context.mounted) showMessage(context, t.feeSaved);
                        } catch (err) {
                          if (context.mounted) {
                            showMessage(context, describeError(t, err));
                          }
                        }
                      },
                      child: Text(t.saveFee),
                    ),
                  ],
                ],
              ),
            );
          },
        );
      },
    );
  }
}

/// Right-hand panel: one position's rules, colour and candidates.
class PositionEditor extends ConsumerStatefulWidget {
  const PositionEditor({
    super.key,
    required this.election,
    required this.position,
  });
  final Election election;
  final Position position;
  @override
  ConsumerState<PositionEditor> createState() => _PositionEditorState();
}

class _PositionEditorState extends ConsumerState<PositionEditor> {
  late final Map<String, TextEditingController> _titles;
  late final _chooseN = TextEditingController(
    text: '${widget.position.chooseN}',
  );

  @override
  void initState() {
    super.initState();
    final titles = (jsonDecode(widget.position.titles) as Map)
        .cast<String, String>();
    final langs = (jsonDecode(widget.election.languages) as List)
        .cast<String>();
    _titles = {
      for (final l in langs) l: TextEditingController(text: titles[l] ?? ''),
    };
  }

  @override
  void dispose() {
    for (final c in _titles.values) {
      c.dispose();
    }
    _chooseN.dispose();
    super.dispose();
  }

  Future<void> _update({
    bool? allowNoChoice,
    int? colour,
    bool saveTitles = false,
    bool saveChooseN = false,
  }) async {
    final t = AppLocalizations.of(context);
    try {
      await ref
          .read(electionServiceProvider)
          .updatePosition(
            widget.position.id,
            titles: saveTitles
                ? {for (final e in _titles.entries) e.key: e.value.text}
                : null,
            chooseN: saveChooseN ? int.tryParse(_chooseN.text) : null,
            allowNoChoice: allowNoChoice,
            colour: colour,
            official: ref.read(officialProvider),
          );
    } catch (err) {
      if (mounted) showMessage(context, describeError(t, err));
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final p = widget.position;
    final svc = ref.watch(electionServiceProvider);
    final official = ref.read(officialProvider);
    final enTitle = _titles['en']?.text ?? '';
    return SectionCard(
      title: enTitle,
      trailing: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: RakubaSpace.xxs,
        children: [
          Checkbox(
            key: const ValueKey('allow-no-choice'),
            value: p.allowNoChoice,
            onChanged: (v) => _update(allowNoChoice: v),
          ),
          Text(t.allowNoChoice),
          const SizedBox(width: RakubaSpace.s),
          Text(t.chooseLabel),
          SizedBox(
            width: 64,
            child: Focus(
              onFocusChange: (has) {
                if (!has) _update(saveChooseN: true);
              },
              child: TextField(
                key: const ValueKey('choose-n'),
                controller: _chooseN,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                onSubmitted: (_) => _update(saveChooseN: true),
              ),
            ),
          ),
          Text(t.candidatesSuffix),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: RakubaSpace.s,
            runSpacing: RakubaSpace.xs,
            children: [
              for (final e in _titles.entries)
                SizedBox(
                  width: 260,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      FieldLabel(t.positionTitleIn(languageDisplayName(e.key))),
                      Focus(
                        onFocusChange: (has) {
                          if (!has) _update(saveTitles: true);
                        },
                        child: TextField(
                          key: ValueKey('title-${e.key}'),
                          controller: e.value,
                          textDirection: e.key == 'ar'
                              ? TextDirection.rtl
                              : TextDirection.ltr,
                          onSubmitted: (_) => _update(saveTitles: true),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          FieldLabel(t.colour),
          Wrap(
            spacing: RakubaSpace.xs,
            children: [
              for (final c in defaultPositionColours)
                InkWell(
                  onTap: () => _update(colour: c.toARGB32()),
                  customBorder: const CircleBorder(),
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: c,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: p.colour == c.toARGB32()
                            ? RakubaColors.thatchGold
                            : RakubaColors.white,
                        width: 4,
                      ),
                    ),
                    child: p.colour == c.toARGB32()
                        ? const Icon(Icons.check, color: RakubaColors.white)
                        : null,
                  ),
                ),
            ],
          ),
          const SizedBox(height: RakubaSpace.xs),
          Wrap(
            spacing: RakubaSpace.xs,
            children: [
              TextButton.icon(
                onPressed: () => svc.movePosition(p.id, -1, official: official),
                icon: const Icon(Icons.arrow_upward),
                label: Text(t.moveUp),
              ),
              TextButton.icon(
                onPressed: () => svc.movePosition(p.id, 1, official: official),
                icon: const Icon(Icons.arrow_downward),
                label: Text(t.moveDown),
              ),
              TextButton.icon(
                style: TextButton.styleFrom(foregroundColor: RakubaColors.clay),
                onPressed: () async {
                  final ok = await showDialog<bool>(
                    context: context,
                    builder: (c) => AlertDialog(
                      content: Text(t.deletePositionConfirm(enTitle)),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(c, false),
                          child: Text(t.cancel),
                        ),
                        FilledButton(
                          onPressed: () => Navigator.pop(c, true),
                          child: Text(t.delete),
                        ),
                      ],
                    ),
                  );
                  if (ok == true) {
                    try {
                      await svc.deletePosition(p.id, official: official);
                    } catch (err) {
                      if (context.mounted) {
                        showMessage(context, describeError(t, err));
                      }
                    }
                  }
                },
                icon: const Icon(Icons.delete_outline),
                label: Text(t.deletePosition),
              ),
            ],
          ),
          const Divider(height: 32),
          StreamBuilder<List<Candidate>>(
            stream: svc.watchCandidates(p.id),
            builder: (context, snap) {
              final list = snap.data ?? const <Candidate>[];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Table(
                    columnWidths: const {
                      0: FixedColumnWidth(60),
                      1: FixedColumnWidth(72),
                      2: FlexColumnWidth(),
                      3: FixedColumnWidth(72),
                      4: FixedColumnWidth(96),
                    },
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: [
                      TableRow(
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: RakubaColors.ink,
                              width: 2,
                            ),
                          ),
                        ),
                        children: [
                          for (final h in [
                            t.colNo,
                            t.colPhoto,
                            t.colName,
                            t.colSymbol,
                            '',
                          ])
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: RakubaSpace.xs),
                              child: Text(
                                h,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                        ],
                      ),
                      for (final c in list)
                        TableRow(
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: RakubaColors.rule,
                              ),
                            ),
                          ),
                          children: [
                            Text(
                              candidateNoLabel(
                                c.number,
                                candidateCount: list.length,
                              ),
                              style: rakubaText(context, RakubaType.body, bold: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: RakubaSpace.xs),
                              child: Align(
                                alignment: AlignmentDirectional.centerStart,
                                child: PhotoBox(
                                  bytes: c.photo,
                                  size: 48,
                                  circle: true,
                                ),
                              ),
                            ),
                            Text(c.name, style: rakubaText(context, RakubaType.body)),
                            Align(
                              alignment: AlignmentDirectional.centerStart,
                              child: PhotoBox(bytes: c.symbol, size: 36),
                            ),
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                minimumSize: const Size(64, 48),
                              ),
                              onPressed: () => showCandidateDialog(
                                context,
                                ref,
                                positionId: p.id,
                                candidate: c,
                              ),
                              child: Text(t.edit),
                            ),
                          ],
                        ),
                    ],
                  ),
                  const SizedBox(height: RakubaSpace.s),
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: OutlinedButton.icon(
                      key: const ValueKey('add-candidate'),
                      icon: const Icon(Icons.add_a_photo_outlined),
                      label: Text(t.addCandidate),
                      onPressed: () =>
                          showCandidateDialog(context, ref, positionId: p.id),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _SignBar extends ConsumerWidget {
  const _SignBar({required this.election});
  final Election election;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context);
    final signed = election.signedBallot != null;
    return SectionCard(
      child: Wrap(
        alignment: WrapAlignment.end,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: RakubaSpace.s,
        runSpacing: RakubaSpace.s,
        children: [
          Text(
            signed ? t.ballotSignedNote : t.ballotNotSigned,
            style: rakubaText(context, RakubaType.body, colour: signed ? RakubaColors.acaciaGreen : RakubaColors.clay),
          ),
          FilledButton(
            key: const ValueKey('sign-ballot'),
            onPressed: () async {
              try {
                final a = await ref
                    .read(electionServiceProvider)
                    .signBallot(
                      election.id,
                      official: ref.read(officialProvider),
                    );
                if (!context.mounted) return;
                await showDialog<void>(
                  context: context,
                  builder: (c) => AlertDialog(
                    title: Text(t.ballotSigned),
                    content: Text(
                      t.ballotFingerprint(a.fingerprint),
                      style: rakubaText(context, RakubaType.name, bold: true),
                    ),
                    actions: [
                      FilledButton(
                        onPressed: () => Navigator.pop(c),
                        child: Text(t.ok),
                      ),
                    ],
                  ),
                );
              } catch (err) {
                if (context.mounted) {
                  showMessage(context, describeError(t, err));
                }
              }
            },
            child: Text(t.saveAndSignBallot),
          ),
        ],
      ),
    );
  }
}

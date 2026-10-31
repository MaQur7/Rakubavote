import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../core/db/registry_db.dart';
import '../../core/theme.dart';
import '../../core/widgets/common.dart';
import '../../l10n/app_localizations.dart';
import '../../platform/photo_capture.dart';
import '../common_errors.dart';

Future<void> showCandidateDialog(BuildContext context, WidgetRef ref,
    {required String positionId, Candidate? candidate}) async {
  final svc = ref.read(electionServiceProvider);
  final next = candidate?.number ?? await svc.nextCandidateNumber(positionId);
  if (!context.mounted) return;
  await showDialog<void>(
    context: context,
    builder: (_) => _CandidateDialog(positionId: positionId, candidate: candidate, initialNumber: next),
  );
}

class _CandidateDialog extends ConsumerStatefulWidget {
  const _CandidateDialog({required this.positionId, required this.initialNumber, this.candidate});
  final String positionId;
  final int initialNumber;
  final Candidate? candidate;

  @override
  ConsumerState<_CandidateDialog> createState() => _CandidateDialogState();
}

class _CandidateDialogState extends ConsumerState<_CandidateDialog> {
  late final _number = TextEditingController(text: '${widget.initialNumber}');
  late final _name = TextEditingController(text: widget.candidate?.name ?? '');
  late Uint8List? _photo = widget.candidate?.photo;
  late Uint8List? _symbol = widget.candidate?.symbol;
  String? _error;

  @override
  void dispose() {
    _number.dispose();
    _name.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final t = AppLocalizations.of(context);
    try {
      await ref.read(electionServiceProvider).saveCandidate(
            candidateId: widget.candidate?.id,
            positionId: widget.positionId,
            number: int.tryParse(_number.text.trim()) ?? 0,
            name: _name.text,
            photo: _photo,
            symbol: _symbol,
            clearPhoto: _photo == null,
            clearSymbol: _symbol == null,
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
      title: Text(widget.candidate == null ? t.addCandidate : t.editCandidate),
      content: SizedBox(
        width: 420,
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          FieldLabel(t.candidateNumber),
          TextField(key: const ValueKey('cand-number'), controller: _number, keyboardType: TextInputType.number),
          FieldLabel(t.candidateName),
          TextField(key: const ValueKey('cand-name'), controller: _name, autofocus: true),
          const SizedBox(height: 16),
          Row(children: [
            PhotoBox(bytes: _photo, size: 72, circle: true, label: t.photo),
            const SizedBox(width: 12),
            Expanded(
              child: Wrap(spacing: 8, runSpacing: 8, children: [
                OutlinedButton(
                  onPressed: () async {
                    final b = await capturePhoto();
                    if (b != null) setState(() => _photo = b);
                  },
                  child: Text(t.takePhoto),
                ),
                if (_photo != null)
                  TextButton(onPressed: () => setState(() => _photo = null), child: Text(t.removeImage)),
              ]),
            ),
          ]),
          const SizedBox(height: 12),
          Row(children: [
            PhotoBox(bytes: _symbol, size: 72, label: t.colSymbol),
            const SizedBox(width: 12),
            Expanded(
              child: Wrap(spacing: 8, runSpacing: 8, children: [
                OutlinedButton(
                  onPressed: () async {
                    final b = await pickImageFile();
                    if (b != null) setState(() => _symbol = b);
                  },
                  child: Text(t.chooseSymbol),
                ),
                if (_symbol != null)
                  TextButton(onPressed: () => setState(() => _symbol = null), child: Text(t.removeImage)),
              ]),
            ),
          ]),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(_error!, style: const TextStyle(color: RakubaColors.clay, fontSize: 16)),
            ),
        ]),
      ),
      actions: [
        if (widget.candidate != null)
          TextButton(
            style: TextButton.styleFrom(foregroundColor: RakubaColors.clay),
            onPressed: () async {
              await ref
                  .read(electionServiceProvider)
                  .deleteCandidate(widget.candidate!.id, official: ref.read(officialProvider));
              if (context.mounted) Navigator.pop(context);
            },
            child: Text(t.deleteCandidate),
          ),
        TextButton(onPressed: () => Navigator.pop(context), child: Text(t.cancel)),
        FilledButton(key: const ValueKey('cand-save'), onPressed: _save, child: Text(t.save)),
      ],
    );
  }
}

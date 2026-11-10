import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../brand/brand.dart';
import '../theme.dart';

/// Rounded status pill, e.g. "Offline · saved on this laptop".
class StatusPill extends StatelessWidget {
  const StatusPill(this.text, {super.key, this.colour = RakubaColors.acaciaGreen});
  final String text;
  final Color colour;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: RakubaSpace.s, vertical: RakubaSpace.xxs),
        decoration: BoxDecoration(color: colour, borderRadius: BorderRadius.circular(RakubaRadius.pill)),
        child: Text(text, style: rakubaText(context, RakubaType.label, bold: true, colour: RakubaColors.white)),
      );
}

/// A white panel with a heading: the one surface level on admin screens.
/// Groups inside a panel are separated by space and rules, never by boxes.
class SectionCard extends StatelessWidget {
  const SectionCard({super.key, this.title, this.trailing, required this.child, this.padding = RakubaSpace.m});
  final String? title;
  final Widget? trailing;
  final Widget child;
  final double padding;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: RakubaSpace.m),
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (title != null) ...[
                  Row(children: [
                    Expanded(child: Text(title!, style: rakubaText(context, RakubaType.heading, bold: true))),
                    ?trailing,
                  ]),
                  // The heading stands on a post rule, as the roof stands on its posts.
                  const Padding(
                    padding: EdgeInsets.only(top: RakubaSpace.xs, bottom: RakubaSpace.s),
                    child: PostRule(),
                  ),
                ],
                child,
              ],
            ),
          ),
        ),
      );
}

/// A photo, or a neutral placeholder with a label when there is none.
class PhotoBox extends StatelessWidget {
  const PhotoBox({super.key, this.bytes, this.size = 48, this.label, this.circle = false});
  final Uint8List? bytes;
  final double size;
  final String? label;
  final bool circle;

  @override
  Widget build(BuildContext context) {
    final radius = circle ? BorderRadius.circular(RakubaRadius.pill) : BorderRadius.circular(RakubaRadius.input);
    return ClipRRect(
      borderRadius: radius,
      child: SizedBox(
        width: size,
        height: size,
        child: bytes != null
            ? Image.memory(bytes!, width: size, height: size, fit: BoxFit.cover, gaplessPlayback: true)
            // No photo: the thatch hatch, never a flat grey box.
            : ThatchHatch(
                background: RakubaColors.paper,
                child: label == null
                    ? null
                    : Center(
                        child: ColoredBox(
                          color: RakubaColors.paper,
                          child: Padding(
                            padding: const EdgeInsets.all(RakubaSpace.xxs),
                            child: Text(label!,
                                textAlign: TextAlign.center,
                                style: rakubaText(context, RakubaType.label, colour: RakubaColors.inkMuted)),
                          ),
                        ),
                      ),
              ),
      ),
    );
  }
}

/// Small bold label above a field.
class FieldLabel extends StatelessWidget {
  const FieldLabel(this.text, {super.key});
  final String text;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: RakubaSpace.xs, top: RakubaSpace.s),
        child: Text(text, style: rakubaText(context, RakubaType.label, bold: true)),
      );
}

/// Secondary text: hints and small print, in [RakubaColors.inkMuted].
class MutedText extends StatelessWidget {
  const MutedText(this.text, {super.key, this.size = RakubaType.label, this.textAlign});
  final String text;
  final double size;
  final TextAlign? textAlign;
  @override
  Widget build(BuildContext context) =>
      Text(text, textAlign: textAlign, style: rakubaText(context, size, colour: RakubaColors.inkMuted));
}

enum NoticeKind { warning, success, info }

Color _noticeBar(NoticeKind k) => switch (k) {
      NoticeKind.warning => RakubaColors.clay,
      NoticeKind.success => RakubaColors.acaciaGreen,
      NoticeKind.info => RakubaColors.nileBlue,
    };

/// Inline notice: a 4 px coloured bar at the start, then text. No box, no border.
/// Warnings sit on the warning wash so they stand out in a list.
class NoticeBox extends StatelessWidget {
  const NoticeBox({super.key, required this.child, this.kind = NoticeKind.warning});
  final Widget child;
  final NoticeKind kind;

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: kind == NoticeKind.warning ? RakubaColors.warningTint : null,
          border: BorderDirectional(start: BorderSide(color: _noticeBar(kind), width: RakubaSpace.xxs)),
        ),
        padding: const EdgeInsetsDirectional.fromSTEB(RakubaSpace.s, RakubaSpace.xs, RakubaSpace.s, RakubaSpace.xs),
        child: DefaultTextStyle.merge(style: rakubaText(context, RakubaType.body), child: child),
      );
}

/// Loading state: a sentence of what is happening and a 2 px progress line.
class LoadingLine extends StatelessWidget {
  const LoadingLine(this.text, {super.key});
  final String text;
  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          const LinearProgressIndicator(),
          const SizedBox(height: RakubaSpace.s),
          MutedText(text, size: RakubaType.body),
        ],
      );
}

/// Empty state: what will appear here, and the action that fills it.
class EmptyState extends StatelessWidget {
  const EmptyState(this.text, {super.key, this.action});
  final String text;
  final Widget? action;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: RakubaSpace.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            MutedText(text, size: RakubaType.body),
            if (action != null) ...[const SizedBox(height: RakubaSpace.s), action!],
          ],
        ),
      );
}

/// One row of a ledger: label at the start, value at the end, a rule below.
/// Replaces stat tiles. A row that needs attention gets a clay bar.
class LedgerRow extends StatelessWidget {
  const LedgerRow({super.key, required this.label, required this.value, this.attention = false, this.note});
  final String label;
  final String value;
  final bool attention;
  final String? note;

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          border: BorderDirectional(
            bottom: const BorderSide(color: RakubaColors.rule),
            start: BorderSide(
                color: attention ? RakubaColors.clay : RakubaColors.transparent, width: RakubaSpace.xxs),
          ),
        ),
        padding: const EdgeInsetsDirectional.fromSTEB(RakubaSpace.s, RakubaSpace.xs, 0, RakubaSpace.xs),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Row(children: [
            Expanded(child: Text(label, style: rakubaText(context, RakubaType.body))),
            Text(value,
                style: rakubaText(context, RakubaType.bodyLarge, bold: true,
                        colour: attention ? RakubaColors.clay : RakubaColors.ink)
                    .copyWith(fontFeatures: const [FontFeature.tabularFigures()])),
          ]),
          if (note != null) MutedText(note!),
        ]),
      );
}

void showMessage(BuildContext context, String text) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(text)));
}

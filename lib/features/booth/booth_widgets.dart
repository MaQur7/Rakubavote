import 'dart:typed_data';

import 'package:flutter/material.dart';


import '../../core/theme.dart';
import '../../l10n/app_localizations.dart';

/// Light background tint of a position colour (ballot body, review card).
Color tintOf(Color c, [double amount = 0.10]) => Color.alphaBlend(c.withValues(alpha: amount), RakubaColors.white);

/// "Help" pill shown on every voter screen.
class HelpButton extends StatelessWidget {
  const HelpButton({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return OutlinedButton.icon(
      key: const ValueKey('booth-help'),
      style: boothOutlinedStyle().copyWith(
        minimumSize: const WidgetStatePropertyAll(Size(RakubaSpace.xxl + RakubaSpace.l, RakubaSizes.minTouch)),
        shape: const WidgetStatePropertyAll(StadiumBorder()),
      ),
      icon: const Icon(Icons.help_outline),
      label: Text(t.help),
      onPressed: () => showDialog<void>(
        context: context,
        builder: (c) => AlertDialog(
          // Voters read this: larger than admin dialogs.
          title: Text(t.helpTitle, style: rakubaText(context, RakubaType.name, bold: true)),
          content: Text(t.helpText, style: rakubaText(context, RakubaType.heading)),
          actions: [
            FilledButton(onPressed: () => Navigator.pop(c), child: Text(t.ok)),
          ],
        ),
      ),
    );
  }
}

/// Black square with the candidate number, as on the paper ballot.
class NumberBox extends StatelessWidget {
  const NumberBox(this.label, {super.key, this.size = 44});
  final String label;
  final double size;

  @override
  Widget build(BuildContext context) => Container(
        constraints: BoxConstraints(minWidth: size, minHeight: size),
        padding: const EdgeInsets.symmetric(horizontal: RakubaSpace.xs),
        alignment: Alignment.center,
        decoration: BoxDecoration(color: RakubaColors.ink, borderRadius: BorderRadius.circular(RakubaRadius.input)),
        child: Text(label,
            textDirection: TextDirection.ltr,
            style: rakubaText(context, RakubaType.heading, bold: true, colour: RakubaColors.white)
                .copyWith(fontFeatures: const [FontFeature.tabularFigures()])),
      );
}

class CircleImage extends StatelessWidget {
  const CircleImage(this.bytes, {super.key, this.size = 88, this.dashed = false});
  final Uint8List? bytes;
  final double size;
  final bool dashed;

  @override
  Widget build(BuildContext context) {
    if (dashed) {
      return CustomPaint(
        size: Size.square(size),
        painter: DashedBorderPainter(color: RakubaColors.border, radius: size / 2),
      );
    }
    return ClipOval(
      child: Container(
        width: size,
        height: size,
        color: RakubaColors.rule,
        child: bytes == null ? null : Image.memory(bytes!, fit: BoxFit.cover, gaplessPlayback: true),
      ),
    );
  }
}

class SymbolImage extends StatelessWidget {
  const SymbolImage(this.bytes, {super.key, this.size = 44});
  final Uint8List? bytes;
  final double size;

  @override
  Widget build(BuildContext context) {
    if (bytes == null) return SizedBox(width: size, height: size);
    return ClipRRect(
      borderRadius: BorderRadius.circular(RakubaRadius.input),
      child: Image.memory(bytes!, width: size, height: size, fit: BoxFit.contain, gaplessPlayback: true),
    );
  }
}

/// Dashed rounded border, used for "No choice" (mockups 3 and 4).
class DashedBorderPainter extends CustomPainter {
  DashedBorderPainter(
      {required this.color, this.radius = RakubaRadius.control, this.width = RakubaLine.strong, this.dash = 8, this.gap = 6});
  final Color color;
  final double radius;
  final double width;
  final double dash;
  final double gap;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = RRect.fromRectAndRadius(Offset.zero & size, Radius.circular(radius));
    final path = Path()..addRRect(rect.deflate(width / 2));
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;
    for (final metric in path.computeMetrics()) {
      var d = 0.0;
      while (d < metric.length) {
        canvas.drawPath(metric.extractPath(d, d + dash), paint);
        d += dash + gap;
      }
    }
  }

  @override
  bool shouldRepaint(DashedBorderPainter old) => old.color != color || old.width != width;
}

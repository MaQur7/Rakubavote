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
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(96, RakubaSizes.minTouch),
        shape: const StadiumBorder(),
      ),
      icon: const Icon(Icons.help_outline),
      label: Text(t.help),
      onPressed: () => showDialog<void>(
        context: context,
        builder: (c) => AlertDialog(
          title: Text(t.helpTitle, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700)),
          content: Text(t.helpText, style: const TextStyle(fontSize: 20, height: 1.4)),
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
        padding: const EdgeInsets.symmetric(horizontal: 6),
        alignment: Alignment.center,
        decoration: BoxDecoration(color: RakubaColors.ink, borderRadius: BorderRadius.circular(8)),
        child: Text(label,
            textDirection: TextDirection.ltr,
            style: TextStyle(color: RakubaColors.white, fontWeight: FontWeight.w700, fontSize: size * 0.5)),
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
        color: RakubaColors.placeholder,
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
      borderRadius: BorderRadius.circular(6),
      child: Image.memory(bytes!, width: size, height: size, fit: BoxFit.contain, gaplessPlayback: true),
    );
  }
}

/// The square tick box on the right of each row.
class TickBox extends StatelessWidget {
  const TickBox({super.key, required this.checked, required this.colour, this.size = 64});
  final bool checked;
  final Color colour;
  final double size;

  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: checked ? colour : RakubaColors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: checked ? colour : RakubaColors.border, width: 3),
        ),
        child: checked ? Icon(Icons.check, color: RakubaColors.white, size: size * 0.7) : null,
      );
}

/// Dashed rounded border, used for "No choice" (mockups 3 and 4).
class DashedBorderPainter extends CustomPainter {
  DashedBorderPainter({required this.color, this.radius = 12, this.width = 2, this.dash = 8, this.gap = 6});
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
  bool shouldRepaint(DashedBorderPainter old) => old.color != color;
}

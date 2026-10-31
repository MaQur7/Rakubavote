import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../theme.dart';

/// "Rakuba" + "vote" wordmark. On dark backgrounds "vote" is Light Thatch.
class Wordmark extends StatelessWidget {
  const Wordmark({super.key, this.onDark = false, this.size = 20, this.suffix});
  final bool onDark;
  final double size;
  final String? suffix;

  @override
  Widget build(BuildContext context) {
    final base = TextStyle(
        fontFamily: RakubaFonts.latin, fontFamilyFallback: RakubaFonts.fallbackFor(arabic: false), fontWeight: FontWeight.w700, fontSize: size,
        color: onDark ? RakubaColors.white : RakubaColors.ink);
    return Text.rich(
      TextSpan(style: base, children: [
        const TextSpan(text: 'Rakuba'),
        TextSpan(text: 'vote', style: TextStyle(color: onDark ? RakubaColors.lightThatch : RakubaColors.nileBlue)),
        if (suffix != null) TextSpan(text: ' $suffix'),
      ]),
      // The product name is Latin in every language (brand guidelines).
      textDirection: TextDirection.ltr,
    );
  }
}

/// Rounded status pill, e.g. "Offline · saved on this laptop".
class StatusPill extends StatelessWidget {
  const StatusPill(this.text, {super.key, this.colour = RakubaColors.acaciaGreen});
  final String text;
  final Color colour;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(color: colour, borderRadius: BorderRadius.circular(999)),
        child: Text(text, style: const TextStyle(color: RakubaColors.white, fontSize: RakubaSizes.label)),
      );
}

/// White card with a bold heading, as used across the admin mockups.
class SectionCard extends StatelessWidget {
  const SectionCard({super.key, this.title, this.trailing, required this.child, this.padding = 18});
  final String? title;
  final Widget? trailing;
  final Widget child;
  final double padding;

  @override
  Widget build(BuildContext context) => Card(
        margin: const EdgeInsets.only(bottom: 16),
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (title != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(children: [
                    Expanded(
                        child: Text(title!, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700))),
                    ?trailing,
                  ]),
                ),
              child,
            ],
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
    final radius = circle ? BorderRadius.circular(size) : BorderRadius.circular(8);
    return ClipRRect(
      borderRadius: radius,
      child: Container(
        width: size,
        height: size,
        color: RakubaColors.placeholder,
        alignment: Alignment.center,
        child: bytes != null
            ? Image.memory(bytes!, width: size, height: size, fit: BoxFit.cover, gaplessPlayback: true)
            : (label == null
                ? null
                : Padding(
                    padding: const EdgeInsets.all(6),
                    child: Text(label!, textAlign: TextAlign.center, style: const TextStyle(fontSize: 13)),
                  )),
      ),
    );
  }
}

/// Small text label above a field.
class FieldLabel extends StatelessWidget {
  const FieldLabel(this.text, {super.key});
  final String text;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 6, top: 10),
        child: Text(text, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
      );
}

/// Warning box in the mockup style (thatch border, warm tint).
class NoticeBox extends StatelessWidget {
  const NoticeBox({super.key, required this.child, this.border = RakubaColors.thatchGold,
      this.background = RakubaColors.warningTint});
  final Widget child;
  final Color border;
  final Color background;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: background,
          border: Border.all(color: border, width: 1.5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: child,
      );
}

void showMessage(BuildContext context, String text) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(text, style: const TextStyle(fontSize: 16))));
}

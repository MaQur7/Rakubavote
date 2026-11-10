import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../theme.dart';

// The Rakubavote mark and the visual language derived from it (D26,
// docs/design-system.md section 9 and 11). Everything here is drawn from the
// same numbers as brand/ (tool/brand_assets.py): a 120 x 120 square, unit 4.
// Nothing in this file may introduce a shape that is not part of the mark:
// roof bar, post, 45 degree tick with round ends, the bay between the posts.

/// The mark's geometry on its 120-unit square.
abstract final class MarkGeometry {
  static const size = 120.0;
  static const unit = 4.0;
  static const roof = Rect.fromLTWH(8, 20, 104, 16);
  static const roofRadius = 4.0;
  static const postLeft = Rect.fromLTWH(20, 36, 12, 64);
  static const postRight = Rect.fromLTWH(88, 36, 12, 64);
  static const bay = Rect.fromLTWH(32, 36, 56, 64);
  static const tick = [Offset(42, 72), Offset(54, 84), Offset(78, 60)];
  static const stroke = 12.0;

  /// Bay proportion (width : height), used for photo windows.
  static const bayAspect = 56 / 64;
}

enum MarkScheme { colour, onDark, oneColour }

({Color roof, Color post, Color tick}) _schemeColours(MarkScheme s) => switch (s) {
      MarkScheme.colour => (roof: RakubaColors.thatchGold, post: RakubaColors.ink, tick: RakubaColors.nileBlue),
      MarkScheme.onDark => (roof: RakubaColors.lightThatch, post: RakubaColors.paper, tick: RakubaColors.paper),
      MarkScheme.oneColour => (roof: RakubaColors.ink, post: RakubaColors.ink, tick: RakubaColors.ink),
    };

Paint _fill(Color c) => Paint()..color = c;

Paint _stroke(Color c, double w) => Paint()
  ..color = c
  ..style = PaintingStyle.stroke
  ..strokeWidth = w
  ..strokeCap = StrokeCap.round
  ..strokeJoin = StrokeJoin.round;

Path _polyline(List<Offset> pts) {
  final p = Path()..moveTo(pts.first.dx, pts.first.dy);
  for (final o in pts.skip(1)) {
    p.lineTo(o.dx, o.dy);
  }
  return p;
}

class _MarkPainter extends CustomPainter {
  _MarkPainter(this.roof, this.post, this.tick);
  final Color roof;
  final Color post;
  final Color tick;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.shortestSide / MarkGeometry.size);
    canvas.drawRRect(
        RRect.fromRectAndRadius(MarkGeometry.roof, const Radius.circular(MarkGeometry.roofRadius)), _fill(roof));
    canvas.drawRect(MarkGeometry.postLeft, _fill(post));
    canvas.drawRect(MarkGeometry.postRight, _fill(post));
    canvas.drawPath(_polyline(MarkGeometry.tick), _stroke(tick, MarkGeometry.stroke));
  }

  @override
  bool shouldRepaint(_MarkPainter old) => old.roof != roof || old.post != post || old.tick != tick;
}

/// The Rakubavote mark. Minimum size 24 (design system).
class RakubaMark extends StatelessWidget {
  const RakubaMark({super.key, this.size = 48, this.scheme = MarkScheme.colour});
  final double size;
  final MarkScheme scheme;

  @override
  Widget build(BuildContext context) {
    final c = _schemeColours(scheme);
    return Semantics(
      label: 'Rakubavote',
      image: true,
      child: CustomPaint(size: Size.square(size), painter: _MarkPainter(c.roof, c.post, c.tick)),
    );
  }
}

/// The mark with the name. [role] ("Station admin") sits beside it in plain
/// text and is never styled as part of the name.
class RakubaLogo extends StatelessWidget {
  const RakubaLogo({super.key, this.onDark = false, this.markSize = 40, this.role});
  final bool onDark;
  final double markSize;
  final String? role;

  @override
  Widget build(BuildContext context) {
    final name = TextStyle(
      fontFamily: RakubaFonts.latin,
      fontFamilyFallback: RakubaFonts.fallbackFor(arabic: false),
      fontWeight: FontWeight.w700,
      fontSize: markSize * 0.56,
      height: 1,
      color: onDark ? RakubaColors.paper : RakubaColors.ink,
    );
    return Row(mainAxisSize: MainAxisSize.min, children: [
      RakubaMark(size: markSize, scheme: onDark ? MarkScheme.onDark : MarkScheme.colour),
      SizedBox(width: markSize / 5),
      // The name is Latin and left to right in every language.
      Text.rich(
        TextSpan(style: name, children: [
          const TextSpan(text: 'Rakuba'),
          TextSpan(text: 'vote', style: TextStyle(color: onDark ? RakubaColors.lightThatch : RakubaColors.nileBlue)),
        ]),
        textDirection: TextDirection.ltr,
      ),
      if (role != null) ...[
        const SizedBox(width: RakubaSpace.s),
        Flexible(
          child: Text(role!,
              overflow: TextOverflow.ellipsis,
              style: rakubaText(context, RakubaType.body,
                  colour: onDark ? RakubaColors.paper : RakubaColors.inkMuted)),
        ),
      ],
    ]);
  }
}

// ------------------------------------------------------------------ the tick

class _TickPainter extends CustomPainter {
  _TickPainter(this.colour, this.progress);
  final Color colour;
  final double progress;

  // The tick alone on the 120 square (icon "Vote").
  static const _pts = [Offset(28, 62), Offset(50, 84), Offset(92, 42)];

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0) return;
    canvas.scale(size.shortestSide / MarkGeometry.size);
    final metric = _polyline(_pts).computeMetrics().first;
    canvas.drawPath(metric.extractPath(0, metric.length * progress.clamp(0.0, 1.0)), _stroke(colour, MarkGeometry.stroke));
  }

  @override
  bool shouldRepaint(_TickPainter old) => old.colour != colour || old.progress != progress;
}

/// The tick from the mark: 45 degrees, arms 1 : 2, round ends. Used wherever
/// something is chosen, saved or done; never a stock check icon.
class BrandTick extends StatelessWidget {
  const BrandTick({super.key, required this.size, required this.colour, this.progress = 1});
  final double size;
  final Color colour;

  /// 0..1: how much of the stroke is drawn (short arm first), for motion.
  final double progress;

  @override
  Widget build(BuildContext context) =>
      CustomPaint(size: Size.square(size), painter: _TickPainter(colour, progress));
}

/// A tick that draws itself once, short arm then long arm (the only way the
/// tick moves). Shows complete at once when animations are turned off.
class DrawnTick extends StatefulWidget {
  const DrawnTick({super.key, required this.size, required this.colour});
  final double size;
  final Color colour;

  @override
  State<DrawnTick> createState() => _DrawnTickState();
}

class _DrawnTickState extends State<DrawnTick> with SingleTickerProviderStateMixin {
  late final _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 480));

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.maybeDisableAnimationsOf(context) ?? false) {
      _c.value = 1;
    } else if (!_c.isAnimating && _c.value == 0) {
      _c.forward();
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _c,
        builder: (context, _) =>
            BrandTick(size: widget.size, colour: widget.colour, progress: Curves.easeOut.transform(_c.value)),
      );
}

/// The square tick box of the paper ballot: empty, or filled with the tick.
/// The one sign for chosen, done and received everywhere in the app.
class TickBox extends StatelessWidget {
  const TickBox({super.key, required this.checked, required this.colour, this.size = RakubaSpace.xxl});
  final bool checked;
  final Color colour;
  final double size;

  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: checked ? colour : RakubaColors.card,
          borderRadius: BorderRadius.circular(size >= RakubaSpace.xl ? RakubaRadius.input : RakubaRadius.tick),
          border: Border.all(color: checked ? colour : RakubaColors.border, width: RakubaLine.strong),
        ),
        child: checked ? BrandTick(size: size * 0.8, colour: RakubaColors.white) : null,
      );
}

// ------------------------------------------------------------------ icons

/// Icons built only from the mark's parts on its 120 grid: bars, posts,
/// 45 degree strokes and the round end.
enum BrandIconKind { station, vote, results, voterCard, checkIn, secret, next, back, add, tie, up, down }

class _IconPainter extends CustomPainter {
  _IconPainter(this.kind, this.colour, this.rtl);
  final BrandIconKind kind;
  final Color colour;
  final bool rtl;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.shortestSide / MarkGeometry.size);
    final f = _fill(colour);
    final s = _stroke(colour, MarkGeometry.stroke);
    void bar(double x, double y, double w, double h, [double r = 0]) =>
        canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(x, y, w, h), Radius.circular(r)), f);
    void shelter() {
      bar(8, 20, 104, 16, 4);
      bar(20, 36, 12, 64);
      bar(88, 36, 12, 64);
    }

    void chevron(List<Offset> pts) => canvas.drawPath(_polyline(pts), s);

    switch (kind) {
      case BrandIconKind.station:
        shelter();
      case BrandIconKind.vote:
        chevron(const [Offset(28, 62), Offset(50, 84), Offset(92, 42)]);
      case BrandIconKind.results:
        bar(8, 20, 104, 16, 4);
        bar(26, 60, 12, 40);
        bar(54, 44, 12, 56);
        bar(82, 76, 12, 24);
      case BrandIconKind.voterCard:
        bar(12, 24, 96, 16, 4);
        bar(18, 50, 30, 34);
        bar(58, 52, 44, 10, 2);
        bar(58, 72, 30, 10, 2);
      case BrandIconKind.checkIn:
        shelter();
        canvas.drawCircle(const Offset(60, 62), 10, f);
        bar(46, 78, 28, 22, 4);
      case BrandIconKind.secret:
        bar(38, 22, 44, 12, 4);
        bar(38, 30, 12, 26);
        bar(70, 30, 12, 26);
        canvas.saveLayer(const Rect.fromLTWH(0, 0, 120, 120), Paint());
        bar(26, 54, 68, 48, 4);
        canvas.drawCircle(const Offset(60, 78), 6, Paint()..blendMode = BlendMode.clear);
        canvas.restore();
      case BrandIconKind.next:
      case BrandIconKind.back:
        final forward = (kind == BrandIconKind.next) != rtl;
        chevron(forward
            ? const [Offset(46, 34), Offset(72, 60), Offset(46, 86)]
            : const [Offset(74, 34), Offset(48, 60), Offset(74, 86)]);
      case BrandIconKind.add:
        bar(26, 54, 68, 12, 2);
        bar(54, 26, 12, 68, 2);
      case BrandIconKind.tie:
        bar(26, 42, 68, 12, 2);
        bar(26, 66, 68, 12, 2);
      case BrandIconKind.up:
        chevron(const [Offset(34, 72), Offset(60, 46), Offset(86, 72)]);
      case BrandIconKind.down:
        chevron(const [Offset(34, 48), Offset(60, 74), Offset(86, 48)]);
    }
  }

  @override
  bool shouldRepaint(_IconPainter old) => old.kind != kind || old.colour != colour || old.rtl != rtl;
}

class BrandIcon extends StatelessWidget {
  const BrandIcon(this.kind, {super.key, this.size, this.colour});
  final BrandIconKind kind;
  final double? size;
  final Color? colour;

  @override
  Widget build(BuildContext context) {
    final theme = IconTheme.of(context);
    return CustomPaint(
      size: Size.square(size ?? theme.size ?? 24),
      painter: _IconPainter(kind, colour ?? theme.color ?? RakubaColors.ink,
          Directionality.of(context) == TextDirection.rtl),
    );
  }
}

// ------------------------------------------------------------------ dividers

/// Roof line: opens a screen or a section. The roof bar, 4 : 1 corner.
class RoofLine extends StatelessWidget {
  const RoofLine({super.key, this.colour = RakubaColors.thatchGold, this.height = RakubaSpace.xs});
  final Color colour;
  final double height;

  @override
  Widget build(BuildContext context) => Container(
        height: height,
        decoration: BoxDecoration(color: colour, borderRadius: BorderRadius.circular(height / 4)),
      );
}

class _PostRulePainter extends CustomPainter {
  _PostRulePainter(this.colour);
  final Color colour;

  @override
  void paint(Canvas canvas, Size size) {
    final f = _fill(colour);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, RakubaLine.strong), f);
    // Posts 3 wide, set in by their own width times three (the overhang).
    const w = 6.0;
    const inset = 18.0;
    if (size.width > 2 * (inset + w) + 24) {
      canvas.drawRect(Rect.fromLTWH(inset, 0, w, size.height), f);
      canvas.drawRect(Rect.fromLTWH(size.width - inset - w, 0, w, size.height), f);
    }
  }

  @override
  bool shouldRepaint(_PostRulePainter old) => old.colour != colour;
}

/// Post rule: a line carried on two short posts. Sits under panel headings.
class PostRule extends StatelessWidget {
  const PostRule({super.key, this.colour = RakubaColors.ink});
  final Color colour;

  @override
  Widget build(BuildContext context) => CustomPaint(
        size: const Size(double.infinity, RakubaSpace.xs),
        painter: _PostRulePainter(colour),
      );
}

/// Tick end: a rule that ends in the tick. Closes a finished list or step.
class TickEnd extends StatelessWidget {
  const TickEnd({super.key, this.colour = RakubaColors.nileBlue});
  final Color colour;

  @override
  Widget build(BuildContext context) => Row(children: [
        const Expanded(child: ColoredBox(color: RakubaColors.ink, child: SizedBox(height: RakubaLine.strong))),
        const SizedBox(width: RakubaSpace.xs),
        BrandTick(size: RakubaSpace.m, colour: colour),
      ]);
}

/// Tally dots: diameter of the tick's round end. Small counts and progress.
class TallyDots extends StatelessWidget {
  const TallyDots({super.key, required this.filled, required this.total, this.colour = RakubaColors.nileBlue});
  final int filled;
  final int total;
  final Color colour;

  @override
  Widget build(BuildContext context) => Semantics(
        label: '$filled / $total',
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          for (var i = 0; i < total; i++)
            Padding(
              padding: const EdgeInsetsDirectional.only(end: RakubaSpace.xs),
              child: Container(
                width: RakubaSpace.s,
                height: RakubaSpace.s,
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: i < filled ? colour : RakubaColors.rule),
              ),
            ),
        ]),
      );
}

// ------------------------------------------------------------------ patterns

class _HatchPainter extends CustomPainter {
  _HatchPainter(this.colour);
  final Color colour;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Offset.zero & size);
    final p = Paint()
      ..color = colour
      ..strokeWidth = 1.5;
    // 45 degrees, the angle of the tick's long arm; one line every 8.
    const step = 8 * math.sqrt2;
    for (var x = -size.height; x < size.width; x += step) {
      canvas.drawLine(Offset(x, size.height), Offset(x + size.height, 0), p);
    }
  }

  @override
  bool shouldRepaint(_HatchPainter old) => old.colour != colour;
}

/// Thatch hatch: fine lines at the tick angle. For photo placeholders and
/// empty image areas only, never behind text.
class ThatchHatch extends StatelessWidget {
  const ThatchHatch({super.key, this.colour = RakubaColors.thatchGold, this.background = RakubaColors.card, this.child});
  final Color colour;
  final Color background;
  final Widget? child;

  @override
  Widget build(BuildContext context) =>
      ColoredBox(color: background, child: CustomPaint(painter: _HatchPainter(colour), child: child));
}

class _WeavePainter extends CustomPainter {
  _WeavePainter(this.colour);
  final Color colour;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Offset.zero & size);
    // The tick at 3/10 size (short arm 6, long arm 12, stroke 6), rows offset.
    final s = _stroke(colour, 6);
    const tile = 36.0;
    for (var row = -1; row * (tile / 2) < size.height + tile; row++) {
      final shift = row.isOdd ? tile / 2 : 0.0;
      for (var x = -tile + shift; x < size.width + tile; x += tile) {
        final y = row * (tile / 2);
        canvas.drawPath(_polyline([Offset(x + 3, y + 9), Offset(x + 9, y + 15), Offset(x + 21, y + 3)]), s);
      }
    }
  }

  @override
  bool shouldRepaint(_WeavePainter old) => old.colour != colour;
}

/// Mat weave: the tick repeated like a woven mat. Brand surfaces only
/// (first-run and unlock panels, covers); never behind text.
class MatWeave extends StatelessWidget {
  const MatWeave({super.key, required this.colour, this.height});
  final Color colour;
  final double? height;

  @override
  Widget build(BuildContext context) =>
      CustomPaint(size: Size(double.infinity, height ?? double.infinity), painter: _WeavePainter(colour));
}

class _ColonnadePainter extends CustomPainter {
  _ColonnadePainter(this.roof, this.post);
  final Color roof;
  final Color post;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Offset.zero & size);
    // Half-size mark: roof 8 high, posts 6 wide, one every 34 (post + bay).
    canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, size.width, 8), const Radius.circular(2)), _fill(roof));
    for (var x = 6.0; x < size.width - 6; x += 34) {
      canvas.drawRect(Rect.fromLTWH(x, 8, 6, size.height - 8), _fill(post));
    }
  }

  @override
  bool shouldRepaint(_ColonnadePainter old) => old.roof != roof || old.post != post;
}

/// Colonnade: posts repeating every bay under one long roof. A footer border.
class Colonnade extends StatelessWidget {
  const Colonnade({super.key, this.roof = RakubaColors.thatchGold, this.post = RakubaColors.ink});
  final Color roof;
  final Color post;

  @override
  Widget build(BuildContext context) => CustomPaint(
        size: const Size(double.infinity, RakubaSpace.l),
        painter: _ColonnadePainter(roof, post),
      );
}

// ------------------------------------------------------------------ frames

/// Shelter frame: a photo in the bay under the roof, at the bay's 7 : 8
/// proportion. With no photo the bay shows the thatch hatch and [label].
class ShelterFrame extends StatelessWidget {
  const ShelterFrame({super.key, required this.width, this.bytes, this.label});
  final double width;
  final Uint8List? bytes;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final k = width / MarkGeometry.roof.width;
    final roofH = MarkGeometry.roof.height * k;
    final post = MarkGeometry.postLeft.width * k;
    final inset = (MarkGeometry.postLeft.left - MarkGeometry.roof.left) * k;
    final bayW = MarkGeometry.bay.width * k;
    final bayH = MarkGeometry.bay.height * k;
    Widget postBox() => Container(width: post, height: bayH, color: RakubaColors.ink);
    return SizedBox(
      width: width,
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        RoofLine(height: roofH),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: inset),
          child: Row(children: [
            postBox(),
            SizedBox(
              width: bayW,
              height: bayH,
              child: bytes != null
                  ? Image.memory(bytes!, fit: BoxFit.cover, gaplessPlayback: true)
                  : ThatchHatch(
                      child: label == null
                          ? null
                          : Center(
                              child: ColoredBox(
                                color: RakubaColors.card,
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
            postBox(),
          ]),
        ),
      ]),
    );
  }
}

import 'package:flutter/material.dart';

import '../../theme/zave/zave.dart';
import 'zave_press.dart';

/// Which radius a card carries. Zave sizes the corner to the element rather
/// than using one global radius — see [ZaveRadius].
enum ZaveCardSize {
  /// `.cardLg` r28 — hero / marketing.
  large,

  /// `.card` r24 — the default.
  medium,

  /// `.zv-card` r20 — the compact in-app card.
  compact,

  /// `.cardSm` r18 — tasks, cells.
  small,
}

/// A Zave glass card.
///
/// Pass [onTap] to make it a `.listRow`: it then takes the pressed fill step on
/// touch, matching the web's hover. A card with no [onTap] never changes fill.
class ZaveCard extends StatefulWidget {
  const ZaveCard({
    required this.child,
    this.size = ZaveCardSize.medium,
    this.padding,
    this.onTap,
    this.isNow = false,
    super.key,
  });

  final Widget child;
  final ZaveCardSize size;
  final EdgeInsets? padding;
  final VoidCallback? onTap;

  /// Raise the card to the [ZaveGlass.now] step — "this is the one happening
  /// now". Reserve it for today's item or the active slot; if several cards on
  /// a screen are `isNow`, none of them reads as current.
  final bool isNow;

  @override
  State<ZaveCard> createState() => _ZaveCardState();
}

class _ZaveCardState extends State<ZaveCard> {
  bool _pressed = false;

  double get _radius => switch (widget.size) {
    ZaveCardSize.large => ZaveRadius.cardLg,
    ZaveCardSize.medium => ZaveRadius.card,
    ZaveCardSize.compact => ZaveRadius.cardCompact,
    ZaveCardSize.small => ZaveRadius.cardSm,
  };

  @override
  Widget build(BuildContext context) {
    final bool lifted = widget.isNow || (_pressed && widget.onTap != null);

    // One ladder, four things on it: how much light the face catches, how
    // bright its lit rim is, how thick it reads, and how far above the ground
    // it sits. They are separate tokens so they can be tuned, not so they can
    // disagree — a `now` pane behind a `rest` hairline is what made the old
    // flat cards read as stickers.
    //
    // Pressed moves DOWN, not up: the fill brightens the way the web's hover
    // does, but the shadow tightens toward the ground. A press that grows its
    // shadow feels wrong for a reason people cannot usually name.
    final bool pressed = _pressed && widget.onTap != null;

    final BoxDecoration deco = BoxDecoration(
      gradient: widget.isNow
          ? ZaveFill.now
          : (lifted ? ZaveFill.hover : ZaveFill.rest),
      border: ZaveEdgeBorder(
        gradient: widget.isNow
            ? ZaveEdge.now
            : (lifted ? ZaveEdge.hover : ZaveEdge.rest),
        highlight: widget.isNow ? ZaveEdge.bevelNow : ZaveEdge.bevel,
        underside: ZaveEdge.underside,
      ),
      boxShadow: widget.isNow
          ? ZaveShadow.lifted
          : (pressed ? ZaveShadow.pressed : ZaveShadow.resting),
      borderRadius: BorderRadius.circular(_radius),
    );

    final Widget body = AnimatedContainer(
      duration: ZaveMotion.fast,
      curve: ZaveMotion.curve,
      decoration: deco,
      padding: widget.padding ?? ZaveSpace.cardPad,
      child: widget.child,
    );

    if (widget.onTap == null) return body;

    return ZavePress(
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: body,
      ),
    );
  }
}

/// `.dot` — the 9px status dot.
///
/// The colour is the status: [ZaveColors.green] done, [ZaveColors.amber]
/// waiting, [ZaveColors.scheduled] queued, [ZaveColors.ink35] inert.
class ZaveDot extends StatelessWidget {
  const ZaveDot(this.color, {this.size, super.key});

  final Color color;
  final double? size;

  @override
  Widget build(BuildContext context) {
    final double d = size ?? ZaveSpace.dot;
    return Container(
      height: d,
      width: d,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

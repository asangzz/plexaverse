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

    // Fill and edge move together, one step at a time. They are separate
    // tokens so a surface cannot end up with a `now` pane behind a `rest`
    // hairline, which is what made the old flat cards read as stickers.
    final BoxDecoration deco = BoxDecoration(
      gradient: widget.isNow
          ? ZaveFill.now
          : (lifted ? ZaveFill.hover : ZaveFill.rest),
      border: ZaveEdgeBorder(
        gradient: widget.isNow
            ? ZaveEdge.now
            : (lifted ? ZaveEdge.hover : ZaveEdge.rest),
        highlight: widget.isNow ? ZaveEdge.bevelNow : ZaveEdge.bevel,
      ),
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

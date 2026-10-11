import 'package:flutter/widgets.dart';

import '../../theme/zave/zave.dart';

/// A sweep of light across a loading block, and the blocks it sweeps.
///
/// ## The rule this changes
///
/// Thirteen files in this app carried a comment saying the opposite — "No
/// shimmer: Zave's motion rule is short and physical; nothing bounces, and a
/// looping sweep on half the screen is the opposite of that." That reading
/// was defensible but it was never the whole rule: the system already runs
/// two infinite animations, [ZaveMotion.spin] (42s, the ambient rotation) and
/// [ZaveMotion.thinkingDot] (1.2s, the AI "thinking" dots). Both are ambient
/// and low-contrast, and that is the company this belongs in — not the
/// bouncing press the motion rule was written to forbid.
///
/// So the sweep is deliberately quiet: one band crossing every 1.4 seconds
/// with a pause between passes. It should read as "this is still coming",
/// not as an effect.
///
/// ## Why the shapes are an opaque colour and not [ZaveGlass.hover]
///
/// Because the sweep is a `ShaderMask` in [BlendMode.srcATop], and srcATop
/// takes the band's RGB while KEEPING the destination's alpha. Over a fill
/// that is nine percent white, a band of any colour is nine percent of it —
/// which is to say invisible. The first build of this shimmered correctly
/// and could not be seen on a device.
///
/// So the shapes paint [_fill], the opaque colour `ZaveGlass.hover` already
/// resolved to over a card (#282633), and the band lifts it to [_lift]. The
/// fill is unchanged to the eye and the sweep now has somewhere to go.
///
/// ## One sweep per group, not one per bar
///
/// [ZaveShimmer] owns the animation and paints ONE band across its whole
/// subtree. Five bars inside one card are crossed by a single sweep, in the
/// order they sit on screen — which is what makes the card read as one thing
/// loading. Give each bar its own animation and you get five sweeps at five
/// phases, which reads as five unrelated things and is five times the work.
///
/// A [ZaveSkeleton] with no [ZaveShimmer] above it still renders: it draws
/// the static fill and says nothing. That is the honest fallback, and it is
/// also exactly what Reduce Motion gets.
///
/// ```dart
/// ZaveShimmer(
///   child: Column(
///     children: <Widget>[
///       ZaveSkeleton.bar(),
///       SizedBox(height: ZaveSpace.md),
///       ZaveSkeleton.bar(widthFactor: 0.6),
///     ],
///   ),
/// )
/// ```
class ZaveShimmer extends StatefulWidget {
  const ZaveShimmer({required this.child, this.enabled = true, super.key});

  final Widget child;

  /// Pass false to freeze the sweep without unwrapping the subtree — for a
  /// skeleton that is on its way out, or a test that wants a stable frame.
  final bool enabled;

  @override
  State<ZaveShimmer> createState() => _ZaveShimmerState();
}

class _ZaveShimmerState extends State<ZaveShimmer>
    with SingleTickerProviderStateMixin {
  /// One pass plus a rest. The band crosses during the first ~60% and the
  /// remainder is empty, so two passes do not run into each other — a
  /// continuous belt of light reads as a progress bar, which this is not.
  static const Duration _period = Duration(milliseconds: 1400);

  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: _period,
  );

  bool _still = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _sync();
  }

  @override
  void didUpdateWidget(ZaveShimmer old) {
    super.didUpdateWidget(old);
    if (old.enabled != widget.enabled) _sync();
  }

  void _sync() {
    // Reduce Motion stops the sweep outright rather than slowing it. A
    // skeleton still communicates without it, so there is nothing to
    // degrade to.
    final bool still = MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    _still = still;
    if (still || !widget.enabled) {
      if (_c.isAnimating) _c.stop();
      return;
    }
    if (!_c.isAnimating) _c.repeat();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_still || !widget.enabled) return widget.child;

    return AnimatedBuilder(
      animation: _c,
      child: widget.child,
      builder: (BuildContext context, Widget? child) => ShaderMask(
        // srcATop: the band tints what is already painted and adds nothing
        // where the subtree is transparent. Without it the gradient would
        // paint a rectangle over the gaps between the bars.
        blendMode: BlendMode.srcATop,
        shaderCallback: (Rect bounds) => _band(_c.value).createShader(bounds),
        child: child,
      ),
    );
  }

  /// The travelling highlight.
  ///
  /// `t` runs 0..1 over the period; the band is mapped onto the first 60% so
  /// the rest of the period is a pause with the band off-screen.
  LinearGradient _band(double t) {
    const double travel = 0.6;
    // -0.4 → 1.4 so the band is fully off both edges at the ends of its run.
    final double head = t >= travel ? 1.4 : -0.4 + (t / travel) * 1.8;

    return LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: const <Color>[_fill, _lift, _fill],
      stops: <double>[
        (head - 0.22).clamp(0.0, 1.0),
        head.clamp(0.0, 1.0),
        (head + 0.22).clamp(0.0, 1.0),
      ],
    );
  }
}

/// What a skeleton shape is painted.
///
/// `ZaveGlass.hover` (9% white) resolved over a card interior. Opaque, for
/// the reason in [ZaveShimmer]'s doc: a translucent fill gives the sweep no
/// alpha to work with.
const Color _fill = Color(0xFF282633);

/// The centre of the band — [_fill] lifted about a fifth of the way to white.
/// Enough to read as light crossing the shape, not enough to read as a
/// second colour.
const Color _lift = Color(0xFF575660);

/// One block of a loading skeleton.
///
/// Shapes only. The sweep comes from the [ZaveShimmer] above it, and without
/// one these are simply the dim fills this app already used everywhere.
class ZaveSkeleton extends StatelessWidget {
  /// A line of text that has not arrived.
  ///
  /// [widthFactor] shortens it as a fraction of the available width — a
  /// column of bars at 1.0, 0.8, 0.55 reads as a paragraph, where three full
  /// ones read as a table.
  const ZaveSkeleton.bar({this.height, this.widthFactor, this.width, super.key})
    : _shape = _SkeletonShape.bar;

  /// The 44pt disc every list row in this app opens with.
  const ZaveSkeleton.circle({this.width, super.key})
    : height = null,
      widthFactor = null,
      _shape = _SkeletonShape.circle;

  /// A picture, a card, a tile — anything with area rather than a line.
  const ZaveSkeleton.block({
    this.height,
    this.width,
    this.widthFactor,
    super.key,
  }) : _shape = _SkeletonShape.block;

  final _SkeletonShape _shape;

  /// Defaults to [ZaveSpace.md] (12) for a bar — the height every
  /// hand-rolled `_Bar` in this app already used, so the migration changed
  /// no bar's thickness.
  ///
  /// A block with no height takes whatever its parent gives it, which is
  /// what an `AspectRatio` or an `Expanded` wants. In an unbounded column it
  /// would collapse, so give it one there.
  final double? height;

  final double? width;

  /// 0..1 of the available width. Ignored when [width] is set.
  final double? widthFactor;

  @override
  Widget build(BuildContext context) {
    final double? h = switch (_shape) {
      _SkeletonShape.bar => height ?? ZaveSpace.md,
      _SkeletonShape.circle => width ?? _circle,
      // Null on purpose — see [height].
      _SkeletonShape.block => height,
    };

    final Widget box = Container(
      height: h,
      width: _shape == _SkeletonShape.circle ? h : width,
      decoration: BoxDecoration(
        color: _fill,
        shape: _shape == _SkeletonShape.circle
            ? BoxShape.circle
            : BoxShape.rectangle,
        borderRadius: switch (_shape) {
          // A bar is a line of type, so it takes the pill radius the rest of
          // the system gives to things that are wider than they are tall.
          _SkeletonShape.bar => ZaveRadius.pillBr,
          _SkeletonShape.block => BorderRadius.circular(ZaveRadius.cardSm),
          _SkeletonShape.circle => null,
        },
      ),
    );

    if (width != null || _shape == _SkeletonShape.circle) return box;

    final double? f = widthFactor;
    if (f == null) return SizedBox(width: double.infinity, child: box);

    // Left-aligned: a short bar centred in its row reads as a caption, not as
    // the ragged end of a paragraph.
    return Align(
      alignment: Alignment.centerLeft,
      child: FractionallySizedBox(widthFactor: f, child: box),
    );
  }

  /// [ZaveRowCircle.size], repeated rather than imported so this file depends
  /// on tokens only.
  static const double _circle = 44;
}

enum _SkeletonShape { bar, circle, block }

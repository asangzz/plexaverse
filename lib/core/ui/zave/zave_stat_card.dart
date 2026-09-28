import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../theme/zave/zave.dart';
import 'zave_press.dart';

/// The reference's signature tile: a label, a small chart, and a number far
/// larger than anything else on it.
///
/// ## What makes it read the way it does
///
/// **The number is the card.** In the reference it is roughly 40pt against a
/// 15pt label — not "big", nearly three times everything around it — and it is
/// painted with [ZaveAccent.lavender] rather than left white. A white numeral
/// at that size competes with the primary action; the lavender ramp is the one
/// thing in the palette that can be that large and still sit behind violet in
/// the hierarchy.
///
/// **The chart is not data, it is texture.** It sits between the label and the
/// number, unlabelled, with no axis and no scale. Give it the shape of the
/// trend and nothing more — a reader who wants the figure reads the figure.
///
/// **The card is defined by its hairline, not its fill.** Sampled off the
/// reference, the tile interior (#13111F) is within a few points of the ground
/// it sits on. It is an outline holding a number, which is why these can be
/// packed two-and-a-bit to a screen without the page turning into a grid of
/// boxes.
class ZaveStatCard extends StatelessWidget {
  const ZaveStatCard({
    required this.label,
    required this.value,
    this.sublabel,
    this.unit,
    this.chart,
    this.onTap,
    this.filled = false,
    this.width,
    this.labelMaxLines = 1,
    this.labelStyle,
    super.key,
  });

  /// The top line — what this measures.
  final String label;

  /// The readout itself. A string, not a number: `'100+'` and `'—'` are both
  /// legitimate answers and neither is an int.
  final String value;

  /// Under the label. The reference uses it for state (`online`) or timing
  /// (`Tomorrow`), never for a second measurement.
  final String? sublabel;

  /// Beside the number, in the label's size. `BPM`, `Days`, `%`.
  final String? unit;

  /// [ZaveSparkline] or [ZaveAreaWedge]. Omit it and the number simply sits
  /// lower — the card does not reserve the space.
  final Widget? chart;

  final VoidCallback? onTap;

  /// The "this is the one" treatment: a solid violet tile. At most one per
  /// group, the way the reference fills only Next Training.
  ///
  /// It no longer suppresses [chart]. That rule was written for the violet
  /// wedge, which really is invisible on violet — but it is a fact about that
  /// ONE chart, not about filled cards, and it was silently blanking the live
  /// task's illustration. A caller that has nothing readable to draw on violet
  /// passes no chart; deciding that here meant this widget had to know what
  /// each chart is made of.
  final bool filled;

  /// Fixed width for a horizontally-scrolling strip. Null fills the parent.
  final double? width;

  /// Two when the label is a sentence rather than a noun — a task title needs
  /// the second line where `Heart rate` does not.
  final int labelMaxLines;

  /// Overrides the label's style. The one caller that needs it strikes a
  /// finished task through; keeping it a style override rather than a `done`
  /// flag stops this card learning what a task is.
  final TextStyle? labelStyle;

  /// How tall the chart band is. Exposed because the card's height budget is
  /// the sum of fixed parts and this is the only one worth trading: a caller
  /// with a shorter strip shortens the chart, never the number.
  static const double chartHeight = 38;

  // There is deliberately no `stripHeight` constant. A hand-computed height
  // was tried twice and was wrong twice: every gap here is `.w`-scaled and
  // every size `.sp`-scaled, so the sum moves with the screen and again with
  // the reader's text-size setting. A strip sizes itself — see the
  // IntrinsicHeight in `_ActivityStrip`.

  @override
  Widget build(BuildContext context) {
    final Color labelColor = filled ? ZaveColors.white : ZaveColors.white;
    final Color subColor = filled ? ZaveColors.ink62 : ZaveColors.ink45;

    final Widget card = Container(
      width: width,
      padding: EdgeInsets.all(ZaveSpace.lg),
      decoration: filled
          ? BoxDecoration(
              gradient: ZaveAccent.violetCard,
              borderRadius: BorderRadius.circular(ZaveRadius.cardCompact),
            )
          : ZaveSurface.cardCompact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // min, so the card is usable anywhere — a Spacer here would demand a
        // bounded height and crash the first time one of these is dropped into
        // an ordinary vertical list.
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  label,
                  style:
                      labelStyle ?? ZaveType.label.copyWith(color: labelColor),
                  maxLines: labelMaxLines,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(Icons.chevron_right, size: 18, color: subColor),
            ],
          ),
          if (sublabel != null) ...<Widget>[
            SizedBox(height: ZaveSpace.xs),
            Text(
              sublabel!,
              style: ZaveType.bodyMuted.copyWith(color: subColor),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],

          // The chart floats between the label and the number rather than
          // being pinned to either — that gap is what stops the tile reading
          // as a form field.
          // A filled card has no chart, and gets the chart's space as a gap
          // instead. Same total either way, which is what makes a filled tile
          // and a charted one the same height in a row — the reference's
          // strip has no ragged bottom edge.
          if (chart != null) ...<Widget>[
            SizedBox(height: ZaveSpace.md),
            SizedBox(height: chartHeight, width: double.infinity, child: chart),
          ] else
            SizedBox(height: ZaveSpace.md + chartHeight),

          SizedBox(height: ZaveSpace.md),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: <Widget>[
              Flexible(
                child: filled
                    // On violet, white. The lavender ramp is for the ramp's
                    // own contrast against a dark ground and has none here.
                    ? Text(
                        value,
                        style: ZaveType.statNumber.copyWith(
                          color: ZaveColors.white,
                        ),
                        maxLines: 1,
                      )
                    : ZaveGradientText(value, style: ZaveType.statNumber),
              ),
              if (unit != null) ...<Widget>[
                SizedBox(width: ZaveSpace.sm),
                Text(unit!, style: ZaveType.label.copyWith(color: subColor)),
              ],
            ],
          ),
        ],
      ),
    );

    if (onTap == null) return card;
    return ZavePress(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: card,
      ),
    );
  }
}

/// Text painted with [ZaveAccent.lavender].
///
/// A `ShaderMask` rather than a gradient-filled box behind clipped glyphs: the
/// mask follows the letterforms, so the ramp runs through the strokes the way
/// the reference's numerals do instead of banding across the line box.
class ZaveGradientText extends StatelessWidget {
  const ZaveGradientText(this.text, {required this.style, super.key});

  final String text;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      // srcIn keeps only where the glyphs are; the white below is a carrier
      // and never shows.
      blendMode: BlendMode.srcIn,
      shaderCallback: (Rect bounds) => ZaveAccent.lavender.createShader(bounds),
      child: Text(
        text,
        style: style.copyWith(color: ZaveColors.white),
        maxLines: 1,
      ),
    );
  }
}

/// The wiggle — a heart-rate-shaped line with no axis and no scale.
///
/// [values] are plotted as given and normalised to their own min and max, so
/// the shape is the trend and the numbers behind it never need to be in any
/// particular unit. Fewer than two points draws nothing rather than a dot.
class ZaveSparkline extends StatelessWidget {
  const ZaveSparkline({required this.values, super.key});

  final List<double> values;

  @override
  Widget build(BuildContext context) =>
      CustomPaint(painter: _SparklinePainter(values), size: Size.infinite);
}

class _SparklinePainter extends CustomPainter {
  _SparklinePainter(this.values);

  final List<double> values;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.length < 2) return;
    final double lo = values.reduce(math.min);
    final double hi = values.reduce(math.max);
    final double span = (hi - lo).abs() < 1e-9 ? 1 : hi - lo;

    final Path path = Path();
    for (int i = 0; i < values.length; i++) {
      final double x = size.width * i / (values.length - 1);
      // Inset vertically so the peak and trough are not clipped by the box.
      final double t = (values[i] - lo) / span;
      final double y = size.height * (1 - t) * 0.82 + size.height * 0.09;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        // The line brightens toward its peak, which is what gives the
        // reference's sparkline a direction without an arrowhead.
        ..shader = const LinearGradient(
          colors: <Color>[Color(0x66FFFFFF), ZaveColors.lavenderHi],
        ).createShader(Offset.zero & size),
    );
  }

  @override
  bool shouldRepaint(_SparklinePainter old) => old.values != values;
}

/// The swoosh — a filled wedge rising left to right, for a progress-shaped
/// reading rather than a fluctuating one.
///
/// [progress] is 0..1 and sets how high the curve climbs, not how far along it
/// stops: the reference's wedge always spans the full width and it is the
/// HEIGHT that carries the value.
class ZaveAreaWedge extends StatelessWidget {
  const ZaveAreaWedge({required this.progress, super.key});

  final double progress;

  @override
  Widget build(BuildContext context) => CustomPaint(
    painter: _WedgePainter(progress.clamp(0.0, 1.0)),
    size: Size.infinite,
  );
}

class _WedgePainter extends CustomPainter {
  _WedgePainter(this.progress);

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final double top = size.height * (1 - (0.25 + 0.75 * progress));
    final Path path = Path()
      ..moveTo(0, size.height)
      ..cubicTo(
        size.width * 0.45,
        size.height,
        size.width * 0.55,
        top,
        size.width,
        top,
      )
      ..lineTo(size.width, size.height)
      ..close();

    canvas.drawPath(
      path,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: <Color>[Color(0x335E3DE6), Color(0xCC8B6BF2)],
        ).createShader(Offset.zero & size),
    );
  }

  @override
  bool shouldRepaint(_WedgePainter old) => old.progress != progress;
}

/// A proportion bar — [value] of a whole, drawn as a filled track.
///
/// ## Why the kit needed one
///
/// [ZaveSparkline] wants a series and [ZaveAreaWedge] wants a progress, and a
/// lot of this app's numbers are neither: a post's reactions, comments and
/// shares are three point-in-time counts. Drawing a sparkline through one of
/// them would mean inventing the other points, which is the one thing a
/// readout must never do — a fabricated trend is worse than no chart, because
/// the user cannot tell it is fabricated.
///
/// A proportion is the honest chart for a count, because the denominator is
/// also real. `reactions / (reactions + comments + shares)` is a fact about
/// the post, not an illustration of one.
///
/// The track is always drawn, including at zero. An empty track says "none of
/// this"; a missing track says "we did not measure", and those are different
/// claims.
class ZaveMeter extends StatelessWidget {
  const ZaveMeter({required this.value, this.height = 4, super.key});

  /// 0..1. Clamped rather than asserted: a caller dividing by a total it did
  /// not compute should get a full bar, not a crash in a release build.
  final double value;

  final double height;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: height,
    width: double.infinity,
    child: CustomPaint(
      // Size.infinite, not the default. A childless CustomPaint with no size
      // collapses to zero and the painter draws into nothing — which, with a
      // minimum-width hair, renders as a single dot per bar.
      size: Size.infinite,
      painter: _MeterPainter(value.clamp(0.0, 1.0)),
    ),
  );
}

class _MeterPainter extends CustomPainter {
  _MeterPainter(this.value);

  final double value;

  @override
  void paint(Canvas canvas, Size size) {
    final Radius r = Radius.circular(size.height / 2);

    canvas.drawRRect(
      RRect.fromRectAndRadius(Offset.zero & size, r),
      Paint()..color = const Color(0x14FFFFFF),
    );

    if (value <= 0) return;

    // A hair of minimum width, so a real-but-tiny share reads as a sliver
    // rather than as nothing. 3% of a post's engagement is still 3%.
    final double w = math.max(size.height, size.width * value);
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, w, size.height), r),
      Paint()
        ..shader = ZaveAccent.lavender.createShader(
          Rect.fromLTWH(0, 0, size.width, size.height),
        ),
    );
  }

  @override
  bool shouldRepaint(_MeterPainter old) => old.value != value;
}

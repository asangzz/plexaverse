import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/ui/zave/zave_kit.dart';

/// The follower series, spaced by TIME.
///
/// ## Why not `ZaveSparkline`
///
/// Because that one plots by index, and its own doc calls it "texture, not
/// data" — which is the right call for a stat card's background and the wrong
/// one here. These readings are irregularly spaced: someone records a count
/// when they think of it, so a run of daily entries during a burst sits beside
/// a six-week gap. Drawing them evenly would silently claim they were taken
/// evenly, and the shape it produced would be a shape nothing measured.
///
/// ## Why not interpolate the gaps
///
/// Filling them would be inventing follower numbers for days nobody counted.
/// This is the one figure in the product that only ever comes from the person
/// looking at the screen, and a chart that quietly makes some up is worse than
/// no chart. Straight segments between real points, and the points drawn, so
/// the gaps are visible as gaps.
///
/// ## The checkpoint line
///
/// The phase target is the whole reason this series is collected, so it is
/// drawn rather than left to a caption. When the target is far above the
/// readings the line would push the data into the bottom few pixels, so the
/// y-range only stretches to include it when it is within reach — otherwise
/// the series keeps the height and the target is stated in words instead.
class FollowerSeriesChart extends StatelessWidget {
  const FollowerSeriesChart({
    required this.points,
    required this.target,
    this.height = 96,
    super.key,
  });

  /// Oldest first. Fewer than two and nothing is drawn.
  final List<({DateTime at, double value})> points;

  /// The phase's follower checkpoint.
  final int target;

  final double height;

  @override
  Widget build(BuildContext context) {
    if (points.length < 2) return const SizedBox.shrink();
    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(
        painter: _SeriesPainter(points: points, target: target.toDouble()),
        // A chart is one thing to a screen reader, and reading out forty
        // coordinates would be worse than reading out none.
        isComplex: true,
      ),
    );
  }
}

class _SeriesPainter extends CustomPainter {
  _SeriesPainter({required this.points, required this.target});

  final List<({DateTime at, double value})> points;
  final double target;

  @override
  void paint(Canvas canvas, Size size) {
    final double t0 = points.first.at.millisecondsSinceEpoch.toDouble();
    final double t1 = points.last.at.millisecondsSinceEpoch.toDouble();
    // Every reading on one day — real when someone corrects a typo minutes
    // later. Falling back to index spacing here is honest: there is no time
    // axis left to be wrong about.
    final double span = (t1 - t0).abs() < 1 ? 0 : t1 - t0;

    double lo = points.first.value;
    double hi = points.first.value;
    for (final ({DateTime at, double value}) p in points) {
      lo = math.min(lo, p.value);
      hi = math.max(hi, p.value);
    }

    // Stretch to the checkpoint only when it is close enough that including it
    // leaves the series readable. Past that it flattens the line to nothing.
    final bool showTarget = target > 0 && target <= hi * 1.6;
    if (showTarget) hi = math.max(hi, target);

    // A flat series has no range to normalise against; centre it instead of
    // dividing by zero. A plateau is a real thing for a follower count to do.
    final double range = (hi - lo).abs() < 1 ? 0 : hi - lo;

    const double pad = 6;
    double xOf(int i) {
      if (span == 0) {
        return points.length == 1
            ? size.width / 2
            : pad + (size.width - pad * 2) * (i / (points.length - 1));
      }
      final double f =
          (points[i].at.millisecondsSinceEpoch.toDouble() - t0) / span;
      return pad + (size.width - pad * 2) * f;
    }

    double yOf(double v) {
      if (range == 0) return size.height / 2;
      return pad + (size.height - pad * 2) * (1 - (v - lo) / range);
    }

    if (showTarget) {
      final double ty = yOf(target);
      final Paint dash = Paint()
        ..color = ZaveColors.rule
        ..strokeWidth = 1;
      // Dashed by hand — Flutter's Canvas has no dash support, and a solid
      // rule here reads as an axis rather than as a goal.
      for (double x = 0; x < size.width; x += 8) {
        canvas.drawLine(
          Offset(x, ty),
          Offset(math.min(x + 4, size.width), ty),
          dash,
        );
      }
    }

    final Path line = Path();
    for (int i = 0; i < points.length; i++) {
      final Offset o = Offset(xOf(i), yOf(points[i].value));
      // Straight segments. A spline would bow between two real readings and
      // invent values that were never measured — the same objection as
      // resampling, drawn instead of computed.
      i == 0 ? line.moveTo(o.dx, o.dy) : line.lineTo(o.dx, o.dy);
    }

    final Path fill = Path.from(line)
      ..lineTo(xOf(points.length - 1), size.height)
      ..lineTo(xOf(0), size.height)
      ..close();

    canvas.drawPath(
      fill,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            ZaveColors.lavenderLo.withValues(alpha: 0.28),
            ZaveColors.lavenderLo.withValues(alpha: 0),
          ],
        ).createShader(Offset.zero & size),
    );

    canvas.drawPath(
      line,
      Paint()
        ..color = ZaveColors.lavenderLo
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    // The readings themselves, so an eight-week gap is visibly a gap and not
    // a long straight stretch that might have been measured all along.
    final Paint dot = Paint()..color = ZaveColors.lavenderLo;
    for (int i = 0; i < points.length; i++) {
      canvas.drawCircle(Offset(xOf(i), yOf(points[i].value)), 2.5, dot);
    }

    // The latest reading, emphasised — it is the number the card states.
    canvas.drawCircle(
      Offset(xOf(points.length - 1), yOf(points.last.value)),
      4,
      Paint()..color = ZaveColors.green,
    );
  }

  @override
  bool shouldRepaint(_SeriesPainter old) =>
      old.target != target || !identical(old.points, points);
}

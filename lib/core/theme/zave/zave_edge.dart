import 'dart:ui' show lerpDouble;

import 'package:flutter/widgets.dart';

/// A hairline that is **lit**, rather than one flat colour all the way round.
///
/// ## Why this exists
///
/// Every Zave surface used to be the same recipe: a white fill at 5% and a
/// white border at 9%, uniform on all four sides. It is consistent and it is
/// why the app reads flat. A real pane of glass does not have one brightness —
/// the edge facing the light is bright, the edge facing away is almost gone,
/// and that difference is most of what makes a surface look like a surface
/// rather than a rectangle of slightly lighter paint.
///
/// The ground already has a light source: [ZaveGround.bloom], a violet ellipse
/// anchored above the top-left of every screen. Nothing was reading from it.
/// This border does — its gradient runs top-left to bottom-right so a card's
/// upper-left edge catches the bloom and its lower-right edge falls into the
/// ground. One light source, now with something to strike.
///
/// ## Why the border does not animate between states
///
/// [BoxBorder.lerp] only interpolates [Border] and [BorderDirectional]; handed
/// anything else it swaps at the halfway point. Rather than fight that, state
/// stays where this system already put it — **in the fill step** — and the
/// edge gradient is constant per state. A 1px hairline swapping over 180ms is
/// invisible; a fill crossfading is not, and the fill is what carries the
/// meaning.
class ZaveEdgeBorder extends BoxBorder {
  const ZaveEdgeBorder({
    required this.gradient,
    this.highlight,
    this.underside,
    this.width = 1,
  });

  /// Painted along the stroke. Give it a bright stop first and a near-zero
  /// stop last — the light is at the top-left.
  final Gradient gradient;

  /// An optional bevel: a bright line drawn just INSIDE the top edge.
  ///
  /// This is the one detail that makes a translucent rectangle read as a sheet
  /// of glass rather than as tinted paint. A real pane has thickness, and the
  /// top face of that thickness catches the light as a hard specular line — it
  /// is what you see along the top of every physical glass panel, and what
  /// every convincing "glassmorphism" surface is actually imitating.
  ///
  /// Only the top. A bevel on all four sides reads as a bezel or a button, not
  /// as glass, and the light is above anyway.
  final Gradient? highlight;

  /// The bevel's opposite: a dark line just inside the BOTTOM edge.
  ///
  /// The top face of a pane's thickness catches the light; the bottom face is
  /// turned away from it and goes darker than the pane itself. With only the
  /// top highlight a card reads as having a lit rim; with both it reads as
  /// having a body between them, which is the difference between an outline
  /// and an object.
  ///
  /// Subtler than [highlight] by design. Shadow carries less information than
  /// light here — the ground is already almost black, so there is not much
  /// room below the fill to go darker before the line becomes a hard black
  /// stripe.
  final Gradient? underside;

  final double width;

  // BoxBorder wants a representative side for callers that inspect one. The
  // colour is unused: [paint] draws with the shader, never with these.
  @override
  BorderSide get top => BorderSide(width: width, color: const Color(0x00000000));

  @override
  BorderSide get bottom => top;

  @override
  bool get isUniform => true;

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(width);

  @override
  ShapeBorder scale(double t) => ZaveEdgeBorder(
    gradient: gradient,
    highlight: highlight,
    underside: underside,
    width: width * t,
  );

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) =>
      Path()..addRect(rect.deflate(width));

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) =>
      Path()..addRect(rect);

  @override
  ShapeBorder? lerpFrom(ShapeBorder? a, double t) => a is ZaveEdgeBorder
      ? ZaveEdgeBorder(
          gradient: Gradient.lerp(a.gradient, gradient, t)!,
          highlight: Gradient.lerp(a.highlight, highlight, t),
          underside: Gradient.lerp(a.underside, underside, t),
          width: lerpDouble(a.width, width, t)!,
        )
      : super.lerpFrom(a, t);

  @override
  ShapeBorder? lerpTo(ShapeBorder? b, double t) => b is ZaveEdgeBorder
      ? ZaveEdgeBorder(
          gradient: Gradient.lerp(gradient, b.gradient, t)!,
          highlight: Gradient.lerp(highlight, b.highlight, t),
          underside: Gradient.lerp(underside, b.underside, t),
          width: lerpDouble(width, b.width, t)!,
        )
      : super.lerpTo(b, t);

  @override
  void paint(
    Canvas canvas,
    Rect rect, {
    TextDirection? textDirection,
    BoxShape shape = BoxShape.rectangle,
    BorderRadius? borderRadius,
  }) {
    if (width <= 0) return;

    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = width
      ..shader = gradient.createShader(rect);

    // Inset by half the stroke so the line sits INSIDE the box. Stroking on
    // the path itself would straddle the edge and clip against the fill,
    // which on a 1px hairline reads as a half-density line.
    if (shape == BoxShape.circle) {
      canvas.drawCircle(rect.center, (rect.shortestSide - width) / 2, paint);
      return;
    }
    final BorderRadius radius = borderRadius ?? BorderRadius.zero;
    canvas.drawRRect(radius.toRRect(rect).deflate(width / 2), paint);

    // Both faces of the pane's thickness. Each runs between the corner arcs
    // rather than across them: carried into a corner a bevel reads as a
    // second, misaligned outline. Stopping short of each radius is also what
    // gives the line its soft ends.
    _face(canvas, rect, radius, highlight, rect.top + width + 0.5, 0.6);
    _face(canvas, rect, radius, underside, rect.bottom - width - 0.5, 0.75);
  }

  /// One horizontal inner line at [y], inset from each corner by [corner] of
  /// its radius.
  static void _face(
    Canvas canvas,
    Rect rect,
    BorderRadius radius,
    Gradient? paint,
    double y,
    double corner,
  ) {
    if (paint == null) return;

    final double x1 = rect.left + radius.topLeft.x * corner + 1;
    final double x2 = rect.right - radius.topRight.x * corner - 1;
    if (x2 <= x1) return;

    // A one-pixel-tall rect, not the line itself: a shader needs area, and a
    // degenerate rect yields a gradient with nothing to interpolate across.
    canvas.drawLine(
      Offset(x1, y),
      Offset(x2, y),
      Paint()
        ..strokeWidth = 1
        ..shader = paint.createShader(Rect.fromLTRB(x1, y, x2, y + 1)),
    );
  }

  @override
  bool operator ==(Object other) =>
      other is ZaveEdgeBorder &&
      other.gradient == gradient &&
      other.highlight == highlight &&
      other.underside == underside &&
      other.width == width;

  @override
  int get hashCode => Object.hash(gradient, highlight, underside, width);
}

/// The lit-edge gradients, one per depth step.
///
/// Each runs bright at the top-left to nearly nothing at the bottom-right.
/// The steps are the same ladder [ZaveGlass] uses — rest, hover, now — so a
/// surface that moves up a fill step moves its edge up with it and the two
/// cannot drift apart.
class ZaveEdge {
  const ZaveEdge._();

  static const Alignment _from = Alignment.topLeft;
  static const Alignment _to = Alignment.bottomRight;

  static LinearGradient _lit(int hi, int lo) => LinearGradient(
    begin: _from,
    end: _to,
    colors: <Color>[Color(hi), Color(lo)],
    // The falloff is front-loaded: the lit stretch is short and the dark
    // stretch is long, which is how a small light close to a surface behaves.
    stops: const <double>[0.0, 0.7],
  );

  /// A card at rest. Peaks brighter than the old flat 9% hairline and ends
  /// dimmer, so the average is unchanged and only the *distribution* moved.
  static final LinearGradient rest = _lit(0x2EFFFFFF, 0x0AFFFFFF);

  /// Pressed, and the web's hover.
  static final LinearGradient hover = _lit(0x47FFFFFF, 0x14FFFFFF);

  /// "This is the one happening now."
  static final LinearGradient now = _lit(0x66FFFFFF, 0x1FFFFFFF);

  /// Controls — chips, pills, inputs, icon buttons. Smaller objects need a
  /// tighter range or the unlit side disappears entirely at 38px across.
  static final LinearGradient control = _lit(0x33FFFFFF, 0x12FFFFFF);

  /// A focused input. Focus brightens the edge; it never draws a platform
  /// focus ring.
  static final LinearGradient focused = _lit(0x80FFFFFF, 0x26FFFFFF);

  /// The bevel on a card. Horizontal, brightest just off the left corner
  /// where the key light lands, gone by three-quarters across.
  static final LinearGradient bevel = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: const <Color>[
      Color(0x00FFFFFF),
      Color(0x59FFFFFF),
      Color(0x00FFFFFF),
    ],
    stops: const <double>[0.0, 0.22, 0.8],
  );

  /// The same, brighter, for the surface that is currently "now".
  static final LinearGradient bevelNow = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: const <Color>[
      Color(0x00FFFFFF),
      Color(0x8CFFFFFF),
      Color(0x00FFFFFF),
    ],
    stops: const <double>[0.0, 0.22, 0.85],
  );

  /// The underside of a card — the bevel's dark twin.
  ///
  /// Centred rather than left-weighted: the top face is lit from one side, but
  /// the bottom face is simply turned away from the light everywhere, so its
  /// darkness does not have a direction.
  static final LinearGradient underside = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: const <Color>[
      Color(0x00000000),
      Color(0x45000000),
      Color(0x00000000),
    ],
    stops: const <double>[0.0, 0.5, 1.0],
  );
}

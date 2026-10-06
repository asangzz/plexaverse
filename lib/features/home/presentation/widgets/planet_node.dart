/// How each planet is DRAWN.
///
/// ## Why there are real hex values in this file
///
/// Zave's rule is that colour only ever names a status, and every other file in
/// this feature obeys it. A planet is the exception, and deliberately: these
/// gradients are a *depiction of a planet*, the way a photograph is. Mars is
/// red because Mars is red — that red is not naming a failure state, and
/// re-tinting Saturn to `ZaveColors.amber` would not make the screen more
/// consistent, it would make it a diagram of nothing.
///
/// So: the spheres are literal, ported value-for-value from `PLANET_GRADIENT`
/// and `PLANET_SHADOWS` in `components/automate/GamifiedRoadmap.tsx`. Every
/// piece of CHROME around them — the ring disc, the orbit arc, the status
/// labels, the panel — is pure Zave. The boundary is the sphere's edge.
///
/// ## Two CSS features Flutter does not have
///
/// * **`inset` box-shadow** carries the sphere read on eight of the nine
///   planets (`inset -5px -5px 15px rgba(0,0,0,0.6)` and friends): a dark
///   terminator on the bottom-right interior edge. Flutter's [BoxShadow] is
///   outer-only, so [PlanetSphere] overlays a second [RadialGradient] biased
///   to the top-left instead — same light direction, same read.
/// * **`filter: grayscale()/brightness()/contrast()`** on a locked planet →
///   [ColorFiltered] with the composed matrix in [_lockedFilter].
library;

import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/responsive/screen_util.dart';
import '../../../../core/ui/zave/zave_kit.dart';
import '../../domain/roadmap_level.dart';
import '../roadmap_status_ui.dart';

/// The drawing spec for one planet.
class PlanetVisual {
  const PlanetVisual({
    required this.ring,
    required this.sphere,
    required this.gradient,
    required this.insetAlpha,
    required this.halo,
    required this.haloBlur,
  });

  /// The `#151a21` disc's diameter, in design px.
  final double ring;

  /// The sphere's diameter, in design px.
  final double sphere;

  /// `PLANET_GRADIENT[key]`. Null for the Milky Way, which is transparent and
  /// is drawn entirely by its arc, stars and core.
  final Gradient? gradient;

  /// Strength of the emulated `inset` shadow, 0 for none.
  final double insetAlpha;

  /// The outer `0 0 Npx rgba(…)` halo — light the object emits.
  final Color halo;
  final double haloBlur;
}

// CSS `radial-gradient(circle at X% Y%, …)` defaults to a farthest-corner
// extent, so the radius is the distance from the centre point to the far
// corner, as a fraction of the box. Computed here rather than eyeballed.
double _farthestCorner(double cx, double cy) => math.sqrt(
  math.pow(math.max(cx, 1 - cx), 2) + math.pow(math.max(cy, 1 - cy), 2),
);

/// CSS percentage position → Flutter's (-1..1) alignment space.
Alignment _at(double x, double y) => Alignment(x * 2 - 1, y * 2 - 1);

const Color _mercuryLight = Color(0xFFA8ABB3);
const Color _mercuryDark = Color(0xFF44484F);

/// `PLANET_SIZES` + `PLANET_GRADIENT` + `PLANET_SHADOWS`, keyed as the web
/// keys them.
///
/// **Every key in `roadmapPlanets` must appear here.** It did not always: when
/// the arc was 66 days the timeline stopped at Neptune, so nebula, quasar and
/// nova were knowingly left out. The 1000-day rebuild made all twelve
/// reachable and nothing failed loudly, because both lookup sites fall back to
/// `planetVisuals['uranus']!` — so days 601-1000 drew Uranus's cyan sphere
/// under three different names. A missing key here is invisible by
/// construction; `planet_visuals_test.dart` is what makes it visible.
final Map<String, PlanetVisual> planetVisuals = <String, PlanetVisual>{
  'mercury': PlanetVisual(
    ring: 88,
    sphere: 60,
    gradient: RadialGradient(
      center: _at(0.3, 0.3),
      radius: _farthestCorner(0.3, 0.3),
      colors: const <Color>[_mercuryLight, _mercuryDark],
    ),
    insetAlpha: 0.6,
    halo: const Color(0x4DA8ABB3), // rgba(168,171,179,0.3)
    haloBlur: 10,
  ),
  'venus': const PlanetVisual(
    ring: 104,
    sphere: 72,
    // CSS 135deg points down-right: top-left → bottom-right.
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: <Color>[Color(0xFFF5D76E), Color(0xFFE67E22), Color(0xFFF39C12)],
    ),
    insetAlpha: 0.5,
    halo: Color(0x66F5D76E), // rgba(245,215,110,0.4)
    haloBlur: 15,
  ),
  'earth': PlanetVisual(
    ring: 136,
    sphere: 96,
    gradient: RadialGradient(
      center: _at(0.35, 0.35),
      radius: _farthestCorner(0.35, 0.35),
      colors: const <Color>[
        Color(0xFF4DA6FF),
        Color(0xFF2ECC71),
        Color(0xFFFFFFFF),
        Color(0xFF3498DB),
      ],
      stops: const <double>[0, 0.45, 0.8, 1],
    ),
    insetAlpha: 0.7,
    halo: const Color(0x664DA6FF), // rgba(77,166,255,0.4)
    haloBlur: 15,
  ),
  'mars': PlanetVisual(
    ring: 108,
    sphere: 76,
    gradient: RadialGradient(
      center: _at(0.4, 0.4),
      radius: _farthestCorner(0.4, 0.4),
      colors: const <Color>[
        Color(0xFFE74C3C),
        Color(0xFFC0392B),
        Color(0xFFFFFFFF),
      ],
      stops: const <double>[0, 0.6, 0.95],
    ),
    insetAlpha: 0.6,
    halo: const Color(0x66E74C3C), // rgba(231,76,60,0.4)
    haloBlur: 10,
  ),
  'jupiter': const PlanetVisual(
    ring: 148,
    sphere: 108,
    // `repeating-linear-gradient(0deg, …)` — 0deg points UP, and the pattern
    // repeats every 60% of the box height. One period is expressed here and
    // TileMode.repeated does the rest, which is what `repeating-` means.
    gradient: LinearGradient(
      begin: Alignment.bottomCenter,
      end: Alignment(0, -0.2), // 60% of the way up the box
      colors: <Color>[
        Color(0xFFD35400),
        Color(0xFFF39C12),
        Color(0xFFECF0F1),
        Color(0xFFF39C12),
        Color(0xFFD35400),
      ],
      stops: <double>[0, 0.25, 0.5, 0.75, 1],
      tileMode: TileMode.repeated,
    ),
    insetAlpha: 0.7,
    halo: Color(0x4DD35400), // rgba(211,84,0,0.3)
    haloBlur: 20,
  ),
  'saturn': PlanetVisual(
    ring: 116,
    sphere: 80,
    gradient: RadialGradient(
      radius: _farthestCorner(0.5, 0.5),
      colors: const <Color>[Color(0xFFF1C40F), Color(0xFFF39C12)],
    ),
    insetAlpha: 0.6,
    halo: const Color(0x4DF1C40F), // rgba(241,196,15,0.3)
    haloBlur: 15,
  ),
  'uranus': PlanetVisual(
    ring: 100,
    sphere: 70,
    gradient: RadialGradient(
      center: _at(0.3, 0.3),
      radius: _farthestCorner(0.3, 0.3),
      colors: const <Color>[Color(0xFF7FDBFF), Color(0xFF39CCCC)],
    ),
    insetAlpha: 0.4,
    halo: const Color(0x4D7FDBFF), // rgba(127,219,255,0.3)
    haloBlur: 15,
  ),
  'neptune': PlanetVisual(
    ring: 100,
    sphere: 70,
    gradient: RadialGradient(
      center: _at(0.4, 0.4),
      radius: _farthestCorner(0.4, 0.4),
      colors: const <Color>[Color(0xFF0074D9), Color(0xFF001F3F)],
    ),
    insetAlpha: 0.7,
    halo: const Color(0x4D0074D9), // rgba(0,116,217,0.3)
    haloBlur: 15,
  ),
  // The deep-space three. `PLANET_SHADOWS` gives these no `inset` component at
  // all — they are emissive objects, not lit spheres — so insetAlpha is 0 and
  // the terminator overlay is skipped. Their gradients are `circle` with no
  // `at`, i.e. centred: the default centre plus a farthest-corner radius, the
  // same shape as Saturn.
  'nebula': PlanetVisual(
    ring: 110,
    sphere: 80,
    gradient: RadialGradient(
      radius: _farthestCorner(0.5, 0.5),
      colors: const <Color>[
        Color(0xFFFF00FF),
        Color(0xFF4B0082),
        Color(0xFF000000),
      ],
      stops: const <double>[0, 0.5, 1],
    ),
    insetAlpha: 0,
    halo: const Color(0x66FF00FF), // rgba(255,0,255,0.4)
    haloBlur: 20,
  ),
  'quasar': PlanetVisual(
    ring: 120,
    sphere: 85,
    gradient: RadialGradient(
      radius: _farthestCorner(0.5, 0.5),
      colors: const <Color>[
        Color(0xFFFFFFFF),
        Color(0xFF00FFFF),
        Color(0xFF00008B),
      ],
      stops: const <double>[0, 0.3, 1],
    ),
    insetAlpha: 0,
    halo: const Color(0x8000FFFF), // rgba(0,255,255,0.5)
    haloBlur: 25,
  ),
  'nova': PlanetVisual(
    ring: 130,
    sphere: 90,
    gradient: RadialGradient(
      radius: _farthestCorner(0.5, 0.5),
      colors: const <Color>[
        Color(0xFFFF4500),
        Color(0xFFFFFF00),
        Color(0xFF000000),
      ],
      stops: const <double>[0, 0.4, 1],
    ),
    insetAlpha: 0,
    halo: const Color(0x99FF4500), // rgba(255,69,0,0.6)
    haloBlur: 30,
  ),
  'milkyway': const PlanetVisual(
    ring: 150,
    sphere: 110,
    gradient: null,
    insetAlpha: 0,
    halo: Color(0x665761EB), // rgba(87,97,235,0.4)
    haloBlur: 60,
  ),
};

/// The drawing spec for a planet key.
///
/// Use this, never a raw `planetVisuals[key] ?? …` at the call site. The
/// release fallback has to exist — a missing texture must not take the roadmap
/// down — but on its own it is the bug: it draws a real planet's sphere under
/// another planet's name and looks deliberate. The assert makes a porting gap
/// fail in debug and in tests, where it is cheap to fix.
PlanetVisual planetVisual(String key) {
  final PlanetVisual? v = planetVisuals[key];
  assert(
    v != null,
    'No PlanetVisual for planet key "$key". Every key in roadmapPlanets needs '
    'an entry in planetVisuals, or it silently renders as Uranus.',
  );
  return v ?? planetVisuals['uranus']!;
}

/// `filter: grayscale(0.6) brightness(0.7) contrast(0.9)` on a locked planet.
///
/// Composed by hand into one matrix: desaturate towards luminance by 0.6, then
/// scale by brightness × contrast and re-centre the contrast pivot at mid-grey.
/// The web uses a soft 0.6 rather than a full grayscale so the planet stays
/// recognisable — a locked leg should read as "not yet", not as "broken".
final ColorFilter _lockedFilter = _buildLockedFilter();

ColorFilter _buildLockedFilter() {
  const double sat = 0.4; // 1 - grayscale(0.6)
  const double brightness = 0.7;
  const double contrast = 0.9;
  const double lr = 0.2126;
  const double lg = 0.7152;
  const double lb = 0.0722;

  double s(double lum, {required bool own}) =>
      (own ? (1 - sat) * lum + sat : (1 - sat) * lum) * brightness * contrast;

  // Contrast pivots on mid-grey, so the offset puts 0.5 back where it was.
  const double offset = 255 * 0.5 * (1 - contrast) * brightness;

  return ColorFilter.matrix(<double>[
    s(lr, own: true),
    s(lg, own: false),
    s(lb, own: false),
    0,
    offset,
    s(lr, own: false),
    s(lg, own: true),
    s(lb, own: false),
    0,
    offset,
    s(lr, own: false),
    s(lg, own: false),
    s(lb, own: true),
    0,
    offset,
    0,
    0,
    0,
    1,
    0,
  ]);
}

/// The planet itself: gradient sphere, emulated inset terminator, and the two
/// per-planet ornaments (Saturn's ring, Jupiter's spot, the Milky Way's arc).
class PlanetSphere extends StatelessWidget {
  const PlanetSphere({
    required this.planetKey,
    required this.isLocked,
    super.key,
  });

  final String planetKey;
  final bool isLocked;

  PlanetVisual get _v => planetVisual(planetKey);

  @override
  Widget build(BuildContext context) {
    final double size = _v.sphere.r;
    final bool isMilkyway = planetKey == 'milkyway';

    Widget sphere = Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: _v.gradient,
        // Light the object emits, NOT depth on a surface. Zave's "depth is a
        // fill step, never a shadow" governs cards, rows and controls; a star
        // with no halo is a flat disc.
        boxShadow: <BoxShadow>[
          BoxShadow(color: _v.halo, blurRadius: _v.haloBlur.r),
        ],
      ),
      child: _v.insetAlpha == 0
          ? null
          : DecoratedBox(
              // The emulated `inset -Npx -Npx` terminator: transparent at the
              // top-left where the light is, black at the bottom-right rim.
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  center: const Alignment(-0.5, -0.5),
                  radius: 1.15,
                  colors: <Color>[
                    const Color(0x00000000),
                    Color.fromRGBO(0, 0, 0, _v.insetAlpha),
                  ],
                  stops: const <double>[0.35, 1],
                ),
              ),
            ),
    );

    if (planetKey == 'saturn') {
      sphere = Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: <Widget>[
          // The ring passes BEHIND the planet on the web (z-index -1); a Stack
          // cannot paint a child behind its sibling, so the ring is drawn first
          // and the sphere over it, which is the same result.
          Transform.rotate(
            angle: 15 * math.pi / 180,
            child: Container(
              height: size * 0.14,
              width: size * 1.8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.elliptical(size * 0.9, size * 0.07),
                ),
                border: Border.all(
                  color: const Color(0x4DF1C40F), // rgba(241,196,15,0.3)
                  width: 4,
                ),
                boxShadow: const <BoxShadow>[
                  BoxShadow(color: Color(0x33F1C40F), blurRadius: 10),
                ],
              ),
            ),
          ),
          sphere,
        ],
      );
    } else if (planetKey == 'jupiter') {
      sphere = Stack(
        clipBehavior: Clip.hardEdge,
        children: <Widget>[
          sphere,
          Positioned(
            top: size * 0.6,
            right: size * 0.25,
            child: Container(
              height: size * 0.1,
              width: size * 0.15,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xCCC0392B), // #c0392b at 0.8
              ),
            ),
          ),
        ],
      );
    } else if (isMilkyway) {
      sphere = _MilkyWay(size: size);
    }

    if (!isLocked) return sphere;

    // Locked: desaturated and dimmed, then at 80% — the web applies both.
    return Opacity(
      opacity: 0.8,
      child: ColorFiltered(colorFilter: _lockedFilter, child: sphere),
    );
  }
}

/// The journey's last node: an outlined arc mirroring the sun at the very top,
/// a scatter of stars inside its crest, and a single bright core.
///
/// The 60 stars are **deterministic** (`(i * 13.5) % 1` and friends) because
/// the web needed them to survive hydration; the same formulas are used here so
/// the two platforms draw the same sky.
class _MilkyWay extends StatelessWidget {
  const _MilkyWay({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    final double arc = 600.r;

    return SizedBox(
      height: size,
      width: size,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            top: -80.r,
            child: SizedBox(
              height: arc,
              width: arc,
              child: ClipOval(
                child: CustomPaint(
                  painter: const _MilkyWayPainter(),
                  child: Stack(
                    children: <Widget>[
                      for (int i = 0; i < 60; i++) _star(i, arc),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 14.r,
            width: 14.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: ZaveColors.white.withValues(alpha: 0.9),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: const Color(0xCC8A2BE2), // rgba(138,43,226,0.8)
                  blurRadius: 20.r,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _star(int i, double arc) {
    final double r1 = (i * 13.5) % 1;
    final double r2 = (i * 17.2) % 1;
    final double r3 = (i * 19.8) % 1;
    final double d = (r1 * 2.5 + 0.5) * (r1 + 0.5);

    return Positioned(
      top: arc * (r2 * 0.5),
      left: arc * r3,
      child: Container(
        height: d,
        width: d,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: ZaveColors.white.withValues(alpha: r1 * 0.8 + 0.2),
          boxShadow: const <BoxShadow>[
            BoxShadow(color: ZaveColors.white, blurRadius: 5),
          ],
        ),
      ),
    );
  }
}

/// The galaxy's outlined crest: a bright 2px top arc thinning to a hairline at
/// the sides, over a violet wash falling away from the top.
class _MilkyWayPainter extends CustomPainter {
  const _MilkyWayPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;

    canvas.drawRect(
      rect,
      Paint()
        ..shader = const RadialGradient(
          center: Alignment.topCenter,
          radius: 0.6,
          colors: <Color>[
            Color(0x268A2BE2), // rgba(138,43,226,0.15)
            Color(0x008A2BE2),
          ],
        ).createShader(rect),
    );

    final Rect ring = rect.deflate(1);
    // Sides — `border-left/right: 1px solid rgba(255,255,255,0.05)`.
    canvas.drawArc(
      ring,
      math.pi,
      math.pi,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = ZaveGlass.rest,
    );
    // Crest — `border-top: 2px solid rgba(255,255,255,0.25)`.
    canvas.drawArc(
      ring,
      math.pi * 1.25,
      math.pi * 0.5,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round
        ..color = ZaveColors.white.withValues(alpha: 0.25),
    );
  }

  @override
  bool shouldRepaint(_MilkyWayPainter oldDelegate) => false;
}

/// The orbit ring: a faint full circle with the journey-so-far swept over it.
///
/// The sweep starts at twelve o'clock and runs clockwise, so "how far round" is
/// literally how far through the planet's days the user is.
class _OrbitRingPainter extends CustomPainter {
  const _OrbitRingPainter({required this.fraction, required this.color});

  final double fraction;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    // The web's ring radius is `ring / 2 + 8`; the box is `ring + 40` wide, so
    // inset by 12 to land on it.
    final Rect rect = Rect.fromCircle(
      center: size.center(Offset.zero),
      radius: size.width / 2 - 12.r,
    );

    canvas.drawArc(
      rect,
      0,
      math.pi * 2,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        // `rgba(255,255,255,0.05)` — the Zave rest fill, exactly.
        ..color = ZaveGlass.rest,
    );

    if (fraction <= 0) return;

    // The web's `drop-shadow(0 0 5px color)` — a blurred pass under the sharp
    // one. A stroke glow, not a surface shadow.
    canvas.drawArc(
      rect,
      -math.pi / 2,
      math.pi * 2 * fraction,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round
        ..color = color.withValues(alpha: 0.5)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
    );
    canvas.drawArc(
      rect,
      -math.pi / 2,
      math.pi * 2 * fraction,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round
        ..color = color,
    );
  }

  @override
  bool shouldRepaint(_OrbitRingPainter old) =>
      old.fraction != fraction || old.color != color;
}

/// A whole planet node: the disc, its orbit ring and dot, the sphere, and the
/// name pinned to its right.
///
/// [status] is the segment's status, already reduced to one value by the
/// timeline — a segment reads `completed` only when every day in it is done,
/// `active` when any day is today, and so on.
class PlanetNode extends StatefulWidget {
  const PlanetNode({
    required this.planetKey,
    required this.name,
    required this.fraction,
    required this.status,
    super.key,
  });

  final String planetKey;
  final String name;

  /// How far round the orbit the selected day sits, 0..1.
  final double fraction;

  final LevelStatus status;

  @override
  State<PlanetNode> createState() => _PlanetNodeState();
}

class _PlanetNodeState extends State<PlanetNode>
    with SingleTickerProviderStateMixin {
  /// `@keyframes pulse-blue` — 2s, ease-in-out, infinite, on the active planet
  /// only. Gated on reduced-motion below, as the web's global
  /// `prefers-reduced-motion` rule gates it there.
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncPulse();
  }

  @override
  void didUpdateWidget(PlanetNode oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.status != widget.status) _syncPulse();
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  /// Started and stopped here rather than in `build` — starting a ticker from
  /// inside a build marks the [AnimatedBuilder] dirty during that same build.
  void _syncPulse() {
    final bool shouldPulse =
        widget.status == LevelStatus.active &&
        !_isMilkyway &&
        !MediaQuery.disableAnimationsOf(context);

    if (shouldPulse && !_pulse.isAnimating) {
      _pulse.repeat(reverse: true);
    } else if (!shouldPulse && _pulse.isAnimating) {
      _pulse.stop();
      _pulse.value = 0;
    }
  }

  bool get _isMilkyway => widget.planetKey == 'milkyway';
  bool get _isLocked => widget.status == LevelStatus.locked;

  @override
  Widget build(BuildContext context) {
    final PlanetVisual v = planetVisual(widget.planetKey);
    final Color signal = roadmapStatusColor(widget.status);
    final double ring = v.ring.r;

    final double box = ring + 40.r;

    // The widget is exactly the ring box wide, and the name hangs OUTSIDE it to
    // the right (`left: 100%` on the web, `clipBehavior: none` here). That is
    // not a detail: the caller centres this widget on the progression line, and
    // a Row that included the name would push the planet off the line by half
    // the name's width.
    return SizedBox(
      height: box,
      width: box,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: <Widget>[
          if (!_isMilkyway)
            Positioned.fill(
              child: CustomPaint(
                painter: _OrbitRingPainter(
                  fraction: widget.fraction,
                  color: signal,
                ),
              ),
            ),
          _disc(ring, signal),
          if (!_isMilkyway && !_isLocked)
            Positioned.fill(
              child: _OrbitDot(
                fraction: widget.fraction,
                color: widget.status == LevelStatus.missed
                    // Amber for missed — Zave has no red.
                    ? ZaveColors.amber
                    : ZaveColors.mint,
              ),
            ),
          Positioned(
            // CSS `margin-left: 18px`; Zave's nearest token is 16.
            left: box + ZaveSpace.lg,
            top: 0,
            bottom: 0,
            child: Center(
              child: Opacity(
                opacity: _isLocked ? 0.4 : 1,
                child: Text(
                  widget.name.toUpperCase(),
                  softWrap: false,
                  style: ZaveType.spaceGrotesk(
                    size: _planetNameSize,
                    weight: FontWeight.w800,
                    // The web's `#f1f3fc` is white with a hint of blue in it;
                    // Zave has no such token and does not want one.
                    color: ZaveColors.white,
                    tracking: 0.08 * _planetNameSize,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// The `#151a21` disc the sphere sits in.
  Widget _disc(double ring, Color signal) {
    final Widget sphere = PlanetSphere(
      planetKey: widget.planetKey,
      isLocked: _isLocked,
    );

    if (_isMilkyway) return sphere;

    return AnimatedBuilder(
      animation: _pulse,
      builder: (BuildContext context, Widget? child) {
        // pulse-blue: 15px → 35px → 15px on the active planet; a steady halo
        // on the others, and none at all on a locked one.
        final double glow = switch (widget.status) {
          LevelStatus.active => 15 + 20 * _pulse.value,
          LevelStatus.completed => 15,
          LevelStatus.missed => 20,
          LevelStatus.locked => 0,
        };

        return Container(
          height: ring,
          width: ring,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            // `#151a21`. No Zave token is this dark neutral; midnight is the
            // app's own base and is the closest thing the system has.
            color: ZaveColors.midnight,
            border: Border.all(color: ZaveGlass.inputBorder, width: 1),
            boxShadow: glow == 0
                ? null
                : <BoxShadow>[
                    BoxShadow(
                      color: signal.withValues(alpha: 0.3),
                      blurRadius: glow.r,
                    ),
                  ],
          ),
          child: Opacity(opacity: _isLocked ? 0.5 : 1, child: child),
        );
      },
      child: sphere,
    );
  }
}

/// The web's mobile planet-name size (`@media (max-width:767px)`), which is the
/// branch a phone renders. Below every Zave type token — the smallest,
/// `ZaveType.kicker`, is 13 — so it is derived from the roadmap's own Space
/// Grotesk face rather than inventing a new one.
const double _planetNameSize = 14;

/// The dot riding the orbit at the current fraction.
class _OrbitDot extends StatelessWidget {
  const _OrbitDot({required this.fraction, required this.color});

  final double fraction;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: fraction * 2 * math.pi,
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          height: 8.r,
          width: 8.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
            border: Border.all(color: ZaveColors.midnight, width: 2),
            boxShadow: <BoxShadow>[BoxShadow(color: color, blurRadius: 10.r)],
          ),
        ),
      ),
    );
  }
}

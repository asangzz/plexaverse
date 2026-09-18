import 'dart:math' as math;
import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';

import '../../../../core/responsive/screen_util.dart';
import '../../../../core/ui/zave/zave_kit.dart';
import '../../domain/season_two.dart';

/// The Season 2 black hole: four phases in orbit around a singularity that
/// counts out the week.
///
/// ## Where the literal colours come from, and where they stop
///
/// The ember wash here is the same exemption the planets take in
/// `planet_node.dart`: an accretion disk is a **depiction**, and there is no
/// Zave token for "superheated infalling matter". The disk, the outer glow and
/// the core keep the web's exact values.
///
/// The **dots do not**. Which phase is live is data, not scenery, so the dots
/// take Zave signals — [ZaveColors.amber] for now, [ZaveColors.ink35] for the
/// rest. They happen to read close to the web's ember, which is a happy
/// accident rather than the reason.
///
/// ## Motion
///
/// The web runs four infinite animations here (disk 4 s, active dot 2 s, core
/// 3 s, the `● now` blink 1.5 s) and disables all of them under
/// `prefers-reduced-motion`. This runs **two** controllers — the disk and the
/// dot — and drops the core's shadow pulse, which was doing the least work for
/// the most frames. Both honour [MediaQuery.disableAnimationsOf].
class BlackHoleVisual extends StatefulWidget {
  const BlackHoleVisual({
    required this.phaseIndex,
    required this.phaseDay,
    super.key,
  });

  /// Which of the four orbit phases is live, 0..3.
  final int phaseIndex;

  /// Day within the phase, 1..7 — the number inside the core.
  final int phaseDay;

  @override
  State<BlackHoleVisual> createState() => _BlackHoleVisualState();
}

class _BlackHoleVisualState extends State<BlackHoleVisual>
    with TickerProviderStateMixin {
  late final AnimationController _disk = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 4),
  );
  late final AnimationController _dot = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final bool still = MediaQuery.disableAnimationsOf(context);
    for (final AnimationController c in <AnimationController>[_disk, _dot]) {
      if (still && c.isAnimating) {
        c.stop();
        c.value = 0;
      } else if (!still && !c.isAnimating) {
        c.repeat(reverse: true);
      }
    }
  }

  @override
  void dispose() {
    _disk.dispose();
    _dot.dispose();
    super.dispose();
  }

  /// The web's `orbitPos`: 0° at the top, clockwise.
  Offset _orbitPos(double angleDegrees, double radius) {
    final double rad = (angleDegrees - 90) * math.pi / 180;
    return Offset(math.cos(rad) * radius, math.sin(rad) * radius);
  }

  @override
  Widget build(BuildContext context) {
    final double box = 320.r;
    final double orbitR = 110.r;

    return SizedBox(
      height: box,
      width: box,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: <Widget>[
          // Outer diffuse glow.
          Container(
            height: box,
            width: box,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: <Color>[
                  Color(0x2E78350F), // rgba(120,53,15,0.18)
                  Color(0x0078350F),
                ],
                stops: <double>[0, 0.7],
              ),
            ),
          ),

          // Accretion disk. The web tilts a circle with `rotateX(72deg)`; 240 x
          // 48 is already that squash, so the ellipse is drawn pre-tilted —
          // same picture, no perspective matrix.
          FadeTransition(
            opacity: Tween<double>(
              begin: 0.7,
              end: 1,
            ).animate(CurvedAnimation(parent: _disk, curve: ZaveMotion.curve)),
            child: ImageFiltered(
              // CSS `blur(6px)` is Gaussian sigma 3.
              imageFilter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
              child: Container(
                height: 48.r,
                width: 240.r,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.elliptical(120.r, 24.r),
                  ),
                  gradient: const LinearGradient(
                    colors: <Color>[
                      Color(0x00D97706),
                      Color(0x73D97706), // 0.45
                      Color(0xA6F59E0B), // 0.65
                      Color(0x73D97706),
                      Color(0x00D97706),
                    ],
                    stops: <double>[0, 0.3, 0.5, 0.7, 1],
                  ),
                ),
              ),
            ),
          ),

          // The phase orbit.
          Container(
            height: orbitR * 2 + 20.r,
            width: orbitR * 2 + 20.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: ZaveGlass.restBorder, width: 1),
            ),
          ),

          for (int i = 0; i < seasonTwoPhases.length; i++)
            _dotAt(i, orbitR, i == widget.phaseIndex),

          _phaseLabel(orbitR + 26.r),

          // The singularity: the app's own void, ringed in rule.
          Container(
            height: 60.r,
            width: 60.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              // `#000008` — the Season 2 ground. ZaveColors.void_ is the same
              // idea and the token the system already has for "pure black".
              color: ZaveColors.void_,
              border: Border.all(color: ZaveColors.rule, width: 2),
            ),
          ),
          SizedBox(
            height: 60.r,
            width: 60.r,
            child: CustomPaint(
              painter: _PhaseDayArcPainter(fraction: widget.phaseDay / 7),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                '${widget.phaseDay}',
                style: ZaveType.mono.copyWith(
                  height: 1,
                  fontWeight: FontWeight.w700,
                  color: ZaveColors.amber,
                ),
              ),
              Text(
                'OF 7',
                style: ZaveType.mono.copyWith(
                  height: 1,
                  fontSize: 8.sp,
                  color: ZaveColors.ink45,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _dotAt(int index, double orbitR, bool isActive) {
    final Offset pos = _orbitPos(seasonTwoPhases[index].angleDegrees, orbitR);
    final double size = (isActive ? 22 : 14).r;

    final Widget dot = Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        // Amber names "now". A phase that is not this week's drops to the
        // plain control fill and the rule hairline — present, not signalling.
        color: isActive ? ZaveColors.amber : ZaveGlass.controlFill,
        border: Border.all(
          color: isActive ? ZaveColors.amber : ZaveColors.rule,
          width: isActive ? 2 : 1,
        ),
      ),
    );

    return Transform.translate(
      offset: pos,
      child: isActive
          ? AnimatedBuilder(
              animation: _dot,
              builder: (BuildContext context, Widget? child) => DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: ZaveColors.amber.withValues(alpha: 0.55),
                      blurRadius: (10 + 14 * _dot.value).r,
                    ),
                  ],
                ),
                child: child,
              ),
              child: dot,
            )
          : dot,
    );
  }

  Widget _phaseLabel(double radius) {
    final SeasonTwoPhase phase = seasonTwoPhases[widget.phaseIndex];
    return Transform.translate(
      offset: _orbitPos(phase.angleDegrees, radius),
      child: Text(
        phase.label.toUpperCase(),
        softWrap: false,
        style: ZaveType.mono.copyWith(
          height: 1,
          fontSize: 9.sp,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.1 * 9,
          color: ZaveColors.amber,
        ),
      ),
    );
  }
}

/// The week's progress, drawn inside the singularity.
class _PhaseDayArcPainter extends CustomPainter {
  const _PhaseDayArcPainter({required this.fraction});

  final double fraction;

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Rect.fromCircle(
      center: size.center(Offset.zero),
      radius: size.width / 2 - 4,
    );

    canvas.drawArc(
      rect,
      0,
      math.pi * 2,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..color = ZaveGlass.rest,
    );
    canvas.drawArc(
      rect,
      -math.pi / 2,
      math.pi * 2 * fraction.clamp(0.0, 1.0),
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round
        ..color = ZaveColors.amber,
    );
  }

  @override
  bool shouldRepaint(_PhaseDayArcPainter old) => old.fraction != fraction;
}

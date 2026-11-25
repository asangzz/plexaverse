import 'dart:math' as math;
import 'dart:ui' show PathMetric;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/ui/app_icons.dart';
import '../../../../../core/ui/zave/zave_kit.dart';
import '../../../domain/contest_repository.dart';
import '../../../domain/contest_words.dart';
import '../../../domain/levels_words.dart';
import '../contest_kit.dart';

/// A level's node: the web's 76×70 ellipse. Logical pixels, not scaled: the
/// path is a drawing whose swing is measured against these, and the web
/// draws it the same size on every phone.
const double kPathNodeWidth = 76;
const double kPathNodeHeight = 70;

/// Drawn on the dark slab, its icon dimmed: a level with nothing to open —
/// not reached, missed, nothing to do, or removed after review.
bool isDarkState(PathNodeState state) => switch (state) {
  PathNodeState.locked ||
  PathNodeState.missed ||
  PathNodeState.unavailable ||
  PathNodeState.revoked => true,
  _ => false,
};

/// The node's fill and its two shadows: the glow, then the 8px ledge it
/// stands on (CSS lists the ledge first; Flutter paints the list in order,
/// so the glow goes underneath here).
class _Skin {
  const _Skin({required this.shadows, this.light, this.dark});

  /// The radial gradient's two stops; null for the flat slab.
  final Color? light;
  final Color? dark;
  final List<BoxShadow> shadows;
}

_Skin _kindSkin(Color light, Color dark, Color ledge, Color glow) => _Skin(
  light: light,
  dark: dark,
  shadows: <BoxShadow>[
    BoxShadow(color: glow, blurRadius: 26),
    BoxShadow(color: ledge, offset: const Offset(0, 8)),
  ],
);

final _Skin _lessonSkin = _kindSkin(
  const Color(0xFF6C75FF),
  ContestColors.lesson,
  const Color(0xFF1A1F9A),
  const Color(0x8C2F3AF7),
);

final _Skin _linkedInSkin = _kindSkin(
  const Color(0xFF3AA0FF),
  ContestColors.linkedIn,
  const Color(0xFF06417D),
  const Color(0x8C0A66C2),
);

/// The top learners' level: gold, the shoutout's colour.
final _Skin _followSkin = _kindSkin(
  const Color(0xFFFFD166),
  const Color(0xFFF5A623),
  const Color(0xFFB9770E),
  const Color(0x73FFD166),
);

/// The Sunday levels, open or done: orange, so they stay recognisable as
/// the levels that are open all week.
final _Skin _sundaySkin = _kindSkin(
  ContestColors.sundayLight,
  ContestColors.sunday,
  ContestColors.sundayLedge,
  ContestColors.sundayNodeGlow,
);

final _Skin _planSkin = _kindSkin(
  const Color(0xFF34D399),
  const Color(0xFF0F9F6E),
  const Color(0xFF0A6B4A),
  const Color(0x8010A37F),
);

const _Skin _doneSkin = _Skin(
  light: Color(0xFF5CF2B2),
  dark: ContestColors.green,
  shadows: <BoxShadow>[
    BoxShadow(color: Color(0x6600DC82), blurRadius: 22),
    BoxShadow(color: Color(0xFF00905A), offset: Offset(0, 8)),
  ],
);

const _Skin _darkSkin = _Skin(
  shadows: <BoxShadow>[
    BoxShadow(color: Color(0xFF10163A), offset: Offset(0, 8)),
  ],
);

/// The KIND is the base colour, so a glance down the week tells lesson from
/// task; the STATE then overrides it — green once finished, the dark slab
/// while there is nothing to open. An unknown kind arrives locked, and draws
/// as the slab. A Sunday level open or done is orange ([isOrange]), done
/// keeping its check.
_Skin _skinFor(PathNode node) {
  if (isOrange(node)) return _sundaySkin;
  if (isFinished(node.state)) return _doneSkin;
  if (isDarkState(node.state)) return _darkSkin;
  return switch (node.kind) {
    PathNodeKind.lesson => _lessonSkin,
    PathNodeKind.planWeek => _planSkin,
    PathNodeKind.followWinners => _followSkin,
    PathNodeKind.unknown => _darkSkin,
    _ => _linkedInSkin,
  };
}

const BorderRadius _ellipse = BorderRadius.all(
  Radius.elliptical(kPathNodeWidth / 2, kPathNodeHeight / 2),
);

/// One level on the path: the round, raised button the design draws. A port
/// of the web's `PathNode.tsx`.
///
/// ## What the colour says
///
/// See [_skinFor]. On top of it: an amber ring and dot while an admin has
/// the level, a red ring when they sent it back or an audit removed it, and
/// for a level skipped today (still open) the kind's own skin with a dashed
/// periwinkle ring, a dimmed icon and a skip badge.
/// Colour is never the only signal — the label carries the state in words,
/// and the card spells it out.
///
/// ## The Sunday levels are orange (25 Nov 2026)
///
/// This planner week's set-up levels (`openAllWeek`) sit in the week's
/// Sunday and stay open all week: orange while open, orange with the check
/// once done; an image waiting for its post has the locked slab like any
/// locked level. One whose post day has gone undone is DISABLED: the dark
/// slab, no press, "Day passed" under it and the reason in its semantics.
///
/// ## The press, and nothing else
///
/// [ZavePress]'s short scale-down, and nothing moves on its own: no pulse
/// and no idle bob. Infinite ambient animations were the root cause of the
/// jank fixed in July 2026, on the web and here, and a path of forty nodes
/// is the last place to bring one back.
class PathNodeButton extends StatelessWidget {
  const PathNodeButton({
    required this.node,
    required this.dayName,
    required this.onPressed,
    this.current = false,
    this.progress = 0,
    this.expanded = false,
    this.level,
    super.key,
  });

  final PathNode node;

  /// Said before the level's name: "Wed, day 17".
  final String dayName;

  /// Its number in the day — Level 1, Level 2 … (owner, 24 Nov 2026: the
  /// home is a Duolingo-style level path). Null leaves it unsaid.
  final int? level;
  final VoidCallback onPressed;

  /// The level the START bubble sits on.
  final bool current;

  /// 0–1, drawn on the current level's ring.
  final double progress;

  /// Its card is open.
  final bool expanded;

  /// A Sunday level whose post day has gone: no card, no press.
  bool get disabled => isDayPassed(node);

  /// "Wed, day 17: Lesson part 2 of 3. Open today." — and, for a level of
  /// today waiting on an earlier one, what it waits for, so a screen reader
  /// hears why without opening the card; for a Sunday level whose day has
  /// passed, why it is closed.
  String get semanticsLabel {
    final String? detail = node.detail;
    final String waits =
        node.state == PathNodeState.locked &&
            detail != null &&
            detail.startsWith('Unlocks after ')
        ? ' $detail.'
        : '';
    final String? reason = disabled ? dayPassedReason(node) : null;
    final String why = reason == null ? '' : ' $reason.';
    final String number = level == null ? '' : 'Level $level, ';
    return '$dayName: $number${levelName(node)}. '
        '${nodeStateWord(node)}.$waits$why';
  }

  @override
  Widget build(BuildContext context) {
    final _Skin skin = _skinFor(node);
    final Color? light = skin.light;
    final Color? dark = skin.dark;
    final Color? ring = switch (node.state) {
      PathNodeState.pending => const Color(0xD9FFD166),
      PathNodeState.rejected ||
      PathNodeState.revoked => const Color(0xE6E5484D),
      _ => null,
    };

    final bool skipped = node.state == PathNodeState.skipped;
    final Widget face = isFinished(node.state)
        ? const Icon(AppIcons.check, size: 30, color: ContestColors.ink)
        : Opacity(
            opacity: isDarkState(node.state) ? 0.4 : (skipped ? 0.6 : 1),
            child: Icon(
              contestKindIcon(node.kind),
              size: 28,
              color: ZaveColors.white,
            ),
          );

    final Widget body = Container(
      width: kPathNodeWidth,
      height: kPathNodeHeight,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: light == null ? ContestColors.slab : null,
        gradient: light == null || dark == null
            ? null
            : RadialGradient(
                center: const Alignment(-0.3, -0.4),
                radius: 1,
                colors: <Color>[light, dark],
                stops: const <double>[0, 0.7],
              ),
        borderRadius: _ellipse,
        boxShadow: skin.shadows,
      ),
      child: face,
    );

    final bool off = disabled;
    return Semantics(
      button: true,
      enabled: !off,
      expanded: off ? null : expanded,
      label: semanticsLabel,
      excludeSemantics: true,
      onTap: off ? null : onPressed,
      child: GestureDetector(
        onTap: off ? null : onPressed,
        behavior: HitTestBehavior.opaque,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: <Widget>[
            if (current)
              Positioned(
                left: -13,
                top: -13,
                right: -13,
                bottom: -13,
                child: CustomPaint(painter: _ProgressRing(progress)),
              ),
            if (ring != null)
              Positioned(
                left: -8,
                top: -8,
                right: -8,
                bottom: -8,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border.all(color: ring, width: 4),
                    borderRadius: const BorderRadius.all(
                      Radius.elliptical(
                        kPathNodeWidth / 2 + 8,
                        kPathNodeHeight / 2 + 8,
                      ),
                    ),
                  ),
                ),
              ),
            if (skipped)
              const Positioned(
                left: -7,
                top: -7,
                right: -7,
                bottom: -7,
                child: CustomPaint(painter: _DashedRing()),
              ),
            if (off) body else ZavePress(child: body),
            // The label beside a node is the web's desktop only; on a phone
            // "Day passed" sits under it, clear of the node's ledge.
            if (off)
              const Positioned(
                top: kPathNodeHeight + 12,
                left: -40,
                right: -40,
                child: Center(child: _DayPassedTag()),
              ),
            if (skipped)
              Positioned(
                top: -4,
                right: -4,
                child: Container(
                  width: 16,
                  height: 16,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: ContestColors.peri,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: ContestColors.groundTop,
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    AppIcons.skip,
                    size: 9,
                    color: ContestColors.groundTop,
                  ),
                ),
              ),
            if (node.state == PathNodeState.pending)
              Positioned(
                top: -4,
                right: -4,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: ContestColors.amber,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: ContestColors.groundTop,
                      width: 2,
                    ),
                  ),
                ),
              ),
            if (current)
              const Positioned(
                top: -54,
                left: -60,
                right: -60,
                child: Center(child: _StartBubble()),
              ),
          ],
        ),
      ),
    );
  }
}

/// "Day passed", under a Sunday level whose post day has gone: muted, as
/// the web's phone draws it. Its words are in the node's semantics already.
class _DayPassedTag extends StatelessWidget {
  const _DayPassedTag();

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
        decoration: BoxDecoration(
          color: const Color(0x0DFFFFFF),
          borderRadius: ZaveRadius.pillBr,
          border: Border.all(color: const Color(0x1AFFFFFF)),
        ),
        child: Text(
          kSundayLevelDayPassed,
          maxLines: 1,
          style: GoogleFonts.manrope(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: const Color(0x99FFFFFF),
          ),
        ),
      ),
    );
  }
}

/// The skipped level's ring: 3px, dashed, periwinkle at 75% — the web's
/// `outline: 3px dashed rgba(174,180,255,0.75)` 4px off the node. A
/// [BoxDecoration] has no dashes, so it is painted.
class _DashedRing extends CustomPainter {
  const _DashedRing();

  static const Color _colour = Color(0xBFAEB4FF);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..color = _colour;
    final Rect oval = (Offset.zero & size).deflate(1.5);
    final Path ring = Path()..addOval(oval);
    const double dash = 7;
    const double gap = 5;
    for (final PathMetric m in ring.computeMetrics()) {
      for (double d = 0; d < m.length; d += dash + gap) {
        canvas.drawPath(m.extractPath(d, math.min(d + dash, m.length)), stroke);
      }
    }
  }

  @override
  bool shouldRepaint(_DashedRing oldDelegate) => false;
}

/// "START", over the level to do now: a white bubble on its own ledge, with
/// a tail pointing at the node.
class _StartBubble extends StatelessWidget {
  const _StartBubble();

  static const Color _blue = Color(0xFF2F3AF7);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
          decoration: const BoxDecoration(
            color: ZaveColors.white,
            borderRadius: BorderRadius.all(Radius.circular(12)),
            boxShadow: <BoxShadow>[
              BoxShadow(color: Color(0xFFC7CBF5), offset: Offset(0, 4)),
            ],
          ),
          child: Text(
            'START',
            style: GoogleFonts.manrope(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.4,
              height: 1.2,
              color: _blue,
            ),
          ),
        ),
        const CustomPaint(size: Size(14, 7), painter: _Tail()),
      ],
    );
  }
}

class _Tail extends CustomPainter {
  const _Tail();

  @override
  void paint(Canvas canvas, Size size) {
    final Path tail = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();
    canvas.drawPath(tail, Paint()..color = ZaveColors.white);
  }

  @override
  bool shouldRepaint(_Tail oldDelegate) => false;
}

/// The ring round the current level: the part's progress as an arc from 12
/// o'clock over a faint track. The web's SVG — r 46 in a 100 box, stroke 5 —
/// scaled to the box it is given.
class _ProgressRing extends CustomPainter {
  const _ProgressRing(this.progress);

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final double scale = math.min(size.width, size.height) / 100;
    final Offset centre = size.center(Offset.zero);
    final double radius = 46 * scale;
    final Paint stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5 * scale;
    canvas.drawCircle(centre, radius, stroke..color = const Color(0x59AEB4FF));
    final double p = progress.clamp(0, 1).toDouble();
    if (p <= 0) return;
    canvas.drawArc(
      Rect.fromCircle(center: centre, radius: radius),
      -math.pi / 2,
      2 * math.pi * p,
      false,
      stroke
        ..color = ContestColors.peri
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_ProgressRing oldDelegate) =>
      oldDelegate.progress != progress;
}

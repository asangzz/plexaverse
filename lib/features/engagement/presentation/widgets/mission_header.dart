import 'dart:math' as math;
import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';

import '../../../../core/responsive/screen_util.dart';
import '../../../../core/ui/zave/zave_kit.dart';
import '../../domain/engagement_repository.dart';

/// The mission header both habit screens open with.
///
/// The web renders the step title as an `h1` with an indigo→green gradient
/// clip, and the Level/Step meta as a pill on the right. Zave has no gradient
/// text and no indigo — its rule is that colour names a status and nothing is
/// tinted for decoration — so the emphasis the gradient was carrying is done
/// by the type scale instead.
///
/// **The step's NAME is not here.** It is the screen's `largeTitle`, in the
/// collapsing header. It used to be an h2 on this block as well, and the
/// result was a page that said "Comment on posts" in the bar and "Comment on
/// posts" again two lines below it — because on these two screens the roadmap
/// step and the screen are the same thing, so `mission.title` and the page
/// name are the same string. What is left here is what the bar does NOT say:
/// which day and step it is, what the step asks for, and what it pays.
///
/// [mission] is null when today's roadmap day has no step for this screen: a
/// company-brand user has no `/connections` step at all, and Season 2+ users
/// are past day 66. The web's `/connections` spins forever in that case; this
/// header says so in one line and lets the screen carry on working.
class MissionHeader extends StatelessWidget {
  const MissionHeader({
    required this.mission,
    required this.fallbackDescription,
    super.key,
  });

  final EngagementMission? mission;

  final String fallbackDescription;

  @override
  Widget build(BuildContext context) {
    final EngagementMission? m = mission;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          m == null ? 'DAILY HABIT' : 'DAY ${m.levelId} · STEP ${m.stepId}',
          style: ZaveType.kicker,
        ),
        SizedBox(height: ZaveSpace.md),
        Text(m?.description ?? fallbackDescription, style: ZaveType.lead),
        SizedBox(height: ZaveSpace.lg),
        Wrap(
          spacing: ZaveSpace.sm,
          runSpacing: ZaveSpace.sm,
          children: <Widget>[
            if (m != null)
              ZavePill(
                label: '${m.xpReward} XP',
                color: ZaveColors.amber,
                leading: const ZaveDot(ZaveColors.amber),
              ),
            if (m != null && m.isCompleted)
              const ZavePill(
                label: 'Already claimed today',
                color: ZaveColors.green,
                leading: ZaveDot(ZaveColors.green),
              ),
          ],
        ),
        if (m == null) ...<Widget>[
          SizedBox(height: ZaveSpace.lg),
          Container(
            padding: ZaveSpace.rowPad,
            decoration: ZaveSurface.row,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Amber, not red: Zave has no red, and "no step today" is a
                // waiting state rather than a failure.
                const ZaveDot(ZaveColors.amber),
                SizedBox(width: ZaveSpace.md),
                Expanded(
                  child: Text(
                    "Today's roadmap has no step for this habit, so there is "
                    'no XP to claim. Everything else here still works.',
                    style: ZaveType.caption.copyWith(color: ZaveColors.ink62),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

/// The golden-hour banner — the 60 minutes after the user's own post goes out,
/// when commenting on niche posts pulls the most reach back to it.
///
/// Reached only through the deep link the roadmap builds
/// (`/comments?context=golden_hour&topic=…`), exactly as on the web. The web
/// paints it in an amber gradient with a ⚡ glyph; here amber is already the
/// Zave signal for "time-sensitive, act now", so it carries the same meaning
/// with the dot and the text alone.
class GoldenHourBanner extends StatelessWidget {
  const GoldenHourBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: ZaveSpace.rowPad,
      decoration: ZaveSurface.row,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const ZaveDot(ZaveColors.amber),
          SizedBox(width: ZaveSpace.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'GOLDEN HOUR',
                  style: ZaveType.kicker.copyWith(color: ZaveColors.amber),
                ),
                SizedBox(height: ZaveSpace.xs),
                Text(
                  '60 minutes to amplify your post. Comment on niche posts now, '
                  'while LinkedIn is still surfacing your content.',
                  style: ZaveType.caption.copyWith(color: ZaveColors.ink62),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// The progress ring from the web's sidebar — `done` of `total`.
///
/// Ported as a [CustomPaint] of two arcs: a track at the rest fill step and a
/// progress arc from -90°, round-capped, 8px wide, which is the web's SVG
/// exactly (`r=45`, `strokeWidth=8`, `-rotate-90`, `strokeLinecap="round"`).
///
/// The web sweeps it in an indigo→green gradient. Zave has no indigo and no
/// decorative gradients, so the arc is flat [ZaveColors.green]: the ring counts
/// work that is DONE, and green is what done means in this palette.
class EngagementProgressRing extends StatelessWidget {
  const EngagementProgressRing({
    required this.done,
    required this.total,
    super.key,
  });

  final int done;
  final int total;

  /// The web's `w-36 h-36` — 144px. There is no Zave token for a ring
  /// diameter, so the figure is named once here and scaled with the rest of
  /// the layout rather than repeated at a call site.
  static const double _diameter = 144;

  /// The web's `strokeWidth="8"`.
  static const double _stroke = 8;

  @override
  Widget build(BuildContext context) {
    final double progress = total <= 0 ? 0 : math.min(done / total, 1.0);
    final double size = _diameter.r;

    return SizedBox(
      height: size,
      width: size,
      child: CustomPaint(
        painter: _RingPainter(progress: progress, stroke: _stroke.r),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('$done', style: ZaveType.h2),
              SizedBox(height: ZaveSpace.xs),
              Text('/ $total', style: ZaveType.kicker),
            ],
          ),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  const _RingPainter({required this.progress, required this.stroke});

  final double progress;
  final double stroke;

  @override
  void paint(Canvas canvas, Size size) {
    final Rect bounds = Offset.zero & size;
    final Rect arc = bounds.deflate(stroke / 2);

    final Paint track = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..color = ZaveGlass.hover;
    canvas.drawArc(arc, 0, math.pi * 2, false, track);

    if (progress <= 0) return;

    final Paint done = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round
      ..color = ZaveColors.green;
    canvas.drawArc(arc, -math.pi / 2, math.pi * 2 * progress, false, done);
  }

  @override
  bool shouldRepaint(_RingPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.stroke != stroke;
}

/// The sticky "finish step" bar.
///
/// **A deliberate departure from the web.** The web puts the count, the ring
/// and the Finish Step button in a right-hand sidebar that is `sticky top-8` —
/// but its results grid is a single column until 1280px, so on every phone and
/// tablet that sidebar drops BELOW a long list of cards and the stickiness does
/// nothing. The recon calls this the page's weakest point. Here the one action
/// that closes the mission rides in a bar that is always reachable, and the
/// ring and the how-it-works copy stay in the body where they belong.
///
/// One primary button per screen is a Zave rule, and this is that button — so
/// nothing else on either habit screen is white.
class FinishStepBar extends StatelessWidget {
  const FinishStepBar({
    required this.done,
    required this.total,
    required this.unit,
    required this.onFinish,
    required this.busy,
    this.note,
    super.key,
  });

  final int done;
  final int total;

  /// 'deployed' on comments, 'sent' on connections — the web's own words.
  final String unit;

  /// Null disables the button: either the target is not met yet, or there is
  /// no roadmap step today to claim.
  final VoidCallback? onFinish;

  final bool busy;

  /// Why the button is disabled, when the reason is not simply "not finished".
  final String? note;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: ZaveSurface.headerBlurSigma,
          sigmaY: ZaveSurface.headerBlurSigma,
        ),
        child: DecoratedBox(
          decoration: const BoxDecoration(
            color: ZaveGlass.headerFill,
            border: Border(
              top: BorderSide(color: ZaveGlass.headerBorder, width: 1),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                ZaveSpace.gutter,
                ZaveSpace.lg,
                ZaveSpace.gutter,
                ZaveSpace.lg,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        '$done / $total $unit',
                        style: ZaveType.label.copyWith(
                          color: done >= total
                              ? ZaveColors.mint
                              : ZaveColors.ink62,
                        ),
                      ),
                      SizedBox(width: ZaveSpace.md),
                      Expanded(
                        child: Wrap(
                          spacing: ZaveSpace.sm,
                          runSpacing: ZaveSpace.sm,
                          alignment: WrapAlignment.end,
                          children: <Widget>[
                            for (int i = 0; i < total; i++)
                              ZaveDot(
                                i < done ? ZaveColors.green : ZaveColors.ink35,
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (note != null) ...<Widget>[
                    SizedBox(height: ZaveSpace.sm),
                    Text(note!, style: ZaveType.caption),
                  ],
                  SizedBox(height: ZaveSpace.md),
                  ZaveButton.primary(
                    label: 'Finish step',
                    expand: true,
                    busy: busy,
                    onPressed: onFinish,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

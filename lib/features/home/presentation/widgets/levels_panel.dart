import 'package:flutter/material.dart';

import '../../../../core/responsive/screen_util.dart';
import '../../../../core/ui/zave/zave_kit.dart';
import '../../domain/roadmap_level.dart';

/// The mission surface for the selected roadmap day.
///
/// A heading that names the day, the day's completion bar, and the day's steps
/// as a horizontal strip.
///
/// **There is no primary button.** There was one, labelled with the live step,
/// and it said the same words as the filled card directly beneath it — the
/// screen offered the same action twice in two shapes. The filled card is the
/// action now, which is also what the reference does: its Next Training tile is
/// tapped, not accompanied by a button repeating it.
///
/// So this screen has no `ZaveButtonKind.primary` at all, and that is allowed.
/// The rule is at most one, not exactly one.
///
/// The one thing worth not "improving": **the visible steps are not always all
/// the steps.** A locked day shows none, a completed day shows only the ones it
/// still missed, and only an active or missed day shows the lot. That is what
/// makes a finished day read as finished instead of as a wall of ticks.
class LevelsPanel extends StatelessWidget {
  const LevelsPanel({required this.level, required this.onStart, super.key});

  final RoadmapLevel level;

  /// Navigates to a task's route. The routes are the web's own paths.
  final ValueChanged<String> onStart;

  @override
  Widget build(BuildContext context) {
    final LevelStatus status = level.status;
    final bool isLocked = status == LevelStatus.locked;
    final bool isToday = status == LevelStatus.active;
    final bool isCompleted = status == LevelStatus.completed;

    final int done = level.doneCount;
    final int total = level.steps.length;
    final int percent = level.completionPercent;

    final List<RoadmapStep> visible = isLocked
        ? const <RoadmapStep>[]
        : isCompleted
        ? level.steps.where((RoadmapStep s) => s.isPending).toList()
        : level.steps;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // "Today" only for the live day. A past or future day names
            // itself, so the panel never lies about which day you are on.
            Text(
              isLocked
                  ? 'Locked'
                  : isToday
                  ? 'Today'
                  : 'Day ${level.id}',
              style: ZaveType.h2,
            ),
            if (!isLocked && total > 0) ...<Widget>[
              SizedBox(width: ZaveSpace.lg),
              Expanded(child: _CompletionBar(percent: percent)),
              // CSS gap: 10px; Zave's nearest token is 12.
              SizedBox(width: ZaveSpace.md),
              Text(
                '$done/$total',
                style: ZaveType.caption.copyWith(
                  color: ZaveColors.mint,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ],
        ),
        SizedBox(height: ZaveSpace.sm),
        Text(_subline(status, visible.length), style: ZaveType.bodyMuted),
        SizedBox(height: ZaveSpace.xl),

        if (visible.isNotEmpty) _StepStrip(steps: visible, onStart: onStart),
      ],
    );
  }

  /// Exact web copy, including the spelled-out count — "Three small things."
  /// reads better than "3 small things."
  String _subline(LevelStatus status, int visibleCount) {
    if (status == LevelStatus.locked) {
      return 'Finish the earlier days to unlock this one.';
    }
    if (status == LevelStatus.completed && visibleCount == 0) {
      return 'Nothing missed — great work.';
    }
    if (visibleCount == 0) return 'No tasks here yet.';
    return '${countWord(visibleCount)} small '
        '${visibleCount == 1 ? 'thing' : 'things'}.';
  }
}

/// The day's completion, beside the heading. Green because colour only ever
/// names a status — here, work already done.
class _CompletionBar extends StatelessWidget {
  const _CompletionBar({required this.percent});

  final int percent;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: ZaveRadius.pillBr,
      child: Container(
        height: 6.h,
        color: ZaveGlass.inputBorder, // rgba(255,255,255,0.10)
        alignment: Alignment.centerLeft,
        child: TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0, end: percent / 100),
          duration: ZaveMotion.fast,
          curve: ZaveMotion.curve,
          builder: (BuildContext context, double value, Widget? _) =>
              FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: value.clamp(0, 1),
                heightFactor: 1,
                child: const ColoredBox(color: ZaveColors.green),
              ),
        ),
      ),
    );
  }
}

/// The day's steps, side by side.
///
/// They were a vertical checklist with a tick at the head of each row. The
/// ticks are gone with it: a list of ticks is a report on the past, and the
/// reference puts what is left to do in front of you as cards instead.
///
/// The current step is the FILLED one — the same "this is the one" treatment
/// the reference gives Next Training, and the reason a filled card has to be
/// rare. A done step keeps its place, struck through, because a day that
/// silently loses its finished steps reads as a day that is not progressing.
///
/// Height comes from [IntrinsicHeight] rather than a constant: titles are one
/// or two lines depending on the day, and the tallest sets the row.
class _StepStrip extends StatelessWidget {
  const _StepStrip({required this.steps, required this.onStart});

  final List<RoadmapStep> steps;
  final ValueChanged<String> onStart;

  /// Narrow enough that the next card always shows at the right edge. A strip
  /// whose last card ends flush looks like a grid, and nobody swipes a grid.
  static const double _cardWidth = 168;

  @override
  Widget build(BuildContext context) {
    // The wedge on each card is the step's XP against the biggest step of the
    // day, so the tallest curve is the day's heaviest task. It is the same
    // fact the numeral states, drawn — which is what the reference's own cards
    // do (a heart-rate line beside 67 BPM, a rising wedge beside 24 Days), and
    // is why the picture can be read at a glance without a legend.
    final int topXp = steps
        .map((RoadmapStep s) => s.xpReward)
        .fold(0, (int a, int b) => a > b ? a : b);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            for (final RoadmapStep step in steps) ...<Widget>[
              SizedBox(width: _cardWidth, child: _stepCard(step, topXp)),
              if (step != steps.last) SizedBox(width: ZaveSpace.md),
            ],
          ],
        ),
      ),
    );
  }

  /// A step rendered as the SAME [ZaveStatCard] the rest of the app uses.
  ///
  /// Not a lookalike written beside it. A second card class drifts the first
  /// time one of them gains a state, and the two sitting in one strip is
  /// exactly where that shows.
  Widget _stepCard(RoadmapStep step, int topXp) {
    final bool isDone = step.isCompleted;
    final bool isNow = step.isCurrent;

    return ZaveStatCard(
      label: step.title,
      labelMaxLines: 2,
      labelStyle: isDone
          ? ZaveType.label.copyWith(
              color: ZaveColors.ink50,
              decoration: TextDecoration.lineThrough,
              decorationColor: ZaveColors.ink50,
            )
          : null,
      sublabel: isDone
          ? 'Done'
          : isNow
          ? 'Now'
          : 'To do',
      // A step with no reward has no number to show, and `+0` is worse than
      // nothing.
      value: step.xpReward > 0 ? '+${step.xpReward}' : '—',
      unit: step.xpReward > 0 ? 'XP' : null,
      chart: topXp > 0 ? ZaveAreaWedge(progress: step.xpReward / topXp) : null,
      filled: isNow,
      onTap: () => onStart(step.moduleLink),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../../core/responsive/screen_util.dart';
import '../../../../core/ui/zave/zave_kit.dart';
import '../../domain/roadmap_level.dart';

/// The mission surface for the selected roadmap day.
///
/// The web's `LevelsPanel`: a heading that names the day, the day's completion
/// bar, ONE white primary action, the task list, and two stat tiles. It renders
/// identically on desktop (a sticky right-hand card) and mobile (inside the
/// bottom sheet) — the panel itself has no responsive branch — so this is a
/// straight port with the styling re-expressed in Zave.
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

    // The next thing to do: the in-progress step, else the first missed one,
    // else simply the first.
    RoadmapStep? current;
    for (final RoadmapStep s in level.steps) {
      if (s.isCurrent) {
        current = s;
        break;
      }
    }
    if (current == null) {
      for (final RoadmapStep s in level.steps) {
        if (s.isPending) {
          current = s;
          break;
        }
      }
    }
    final RoadmapStep? currentStep =
        current ?? (level.steps.isEmpty ? null : level.steps.first);

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

        // The one white thing on the screen: the next action. It sits above
        // the list so the thing to do is the first thing you reach.
        if (!isLocked && currentStep != null) ...<Widget>[
          ZaveButton.primary(
            label: currentStep.title,
            expand: true,
            trailing: const Icon(Icons.arrow_forward),
            onPressed: () => onStart(currentStep.moduleLink),
          ),
          SizedBox(height: ZaveSpace.lg),
        ],

        for (final RoadmapStep step in visible) ...<Widget>[
          _StepRow(step: step, onStart: onStart),
          SizedBox(height: ZaveSpace.md),
        ],

        SizedBox(height: ZaveSpace.sm),
        Row(
          children: <Widget>[
            Expanded(
              child: _StatTile(
                value: '$done/$total',
                label: isToday ? 'done today' : 'done',
              ),
            ),
            SizedBox(width: ZaveSpace.md),
            Expanded(
              child: _StatTile(
                value: '$percent%',
                label: 'complete',
                valueColor: ZaveColors.mint,
              ),
            ),
          ],
        ),
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

/// One task row.
///
/// Three states in one stack: done strikes through at half strength, the active
/// one steps up to the [ZaveGlass.now] fill, everything else sits at rest. XP
/// always sits at the right edge. **The whole row is the link** — there is no
/// play button, and no tick-to-complete, because completion is the server's to
/// decide.
class _StepRow extends StatelessWidget {
  const _StepRow({required this.step, required this.onStart});

  final RoadmapStep step;
  final ValueChanged<String> onStart;

  @override
  Widget build(BuildContext context) {
    final bool isDone = step.isCompleted;
    final bool isActive = step.isCurrent;
    final bool isMissed = step.isPending;

    return Semantics(
      button: true,
      label: 'Start ${step.title}',
      child: ZaveCard(
        size: ZaveCardSize.small,
        isNow: isActive,
        padding: ZaveSpace.rowPad,
        onTap: () => onStart(step.moduleLink),
        child: Row(
          children: <Widget>[
            _StatusMark(isDone: isDone, isActive: isActive, isMissed: isMissed),
            SizedBox(width: ZaveSpace.lg),
            Expanded(
              child: Text(
                step.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: ZaveType.body.copyWith(
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
                  color: isDone ? ZaveColors.ink50 : ZaveColors.ink85,
                  decoration: isDone ? TextDecoration.lineThrough : null,
                  decorationColor: ZaveColors.ink50,
                ),
              ),
            ),
            if (!isDone && step.xpReward > 0) ...<Widget>[
              SizedBox(width: ZaveSpace.md),
              Text(
                '+${step.xpReward}',
                style: ZaveType.caption.copyWith(
                  fontWeight: FontWeight.w700,
                  // Amber is Zave's word for points. It brightens on the step
                  // that is actually yours to earn right now.
                  color: isActive ? ZaveColors.amber : ZaveColors.ink45,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// The 28px mark at the head of a task row.
class _StatusMark extends StatelessWidget {
  const _StatusMark({
    required this.isDone,
    required this.isActive,
    required this.isMissed,
  });

  final bool isDone;
  final bool isActive;
  final bool isMissed;

  @override
  Widget build(BuildContext context) {
    final double size = 28.r;

    if (isDone) {
      return Container(
        height: size,
        width: size,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: ZaveColors.green,
        ),
        child: Icon(
          Icons.check,
          size: 16.r,
          // Ink on a solid fill, exactly as a white Zave pill carries ink
          // letters rather than black ones.
          color: ZaveColors.ink,
        ),
      );
    }

    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isActive
              ? ZaveColors.white
              // Amber for a missed step — Zave has no red.
              : isMissed
              ? ZaveColors.amber
              : ZaveColors.ink35,
          width: 2,
        ),
      ),
    );
  }
}

/// One of the two tiles under the list: the day's progress, stated plainly.
class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.value,
    required this.label,
    this.valueColor = ZaveColors.white,
  });

  final String value;
  final String label;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return ZaveCard(
      size: ZaveCardSize.small,
      padding: ZaveSpace.rowPad,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            value,
            // The `.zv-h` recipe (800 / -0.035em / 1.05) at 26 — the same
            // face as ZaveType.h2, one step down. The web sets the recipe
            // inline here for the same reason.
            style: ZaveType.h2.copyWith(
              fontSize: 26.sp,
              letterSpacing: -0.035 * 26.sp,
              color: valueColor,
            ),
          ),
          SizedBox(height: ZaveSpace.xs),
          Text(label, style: ZaveType.caption),
        ],
      ),
    );
  }
}

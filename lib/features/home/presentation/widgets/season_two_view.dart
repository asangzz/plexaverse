import 'package:flutter/material.dart';

import '../../../../core/responsive/screen_util.dart';
import '../../../../core/ui/zave/zave_kit.dart';
import '../../../plexa/presentation/plexa_day_sheet.dart';
import '../../domain/roadmap_progress.dart';
import '../../domain/season_two.dart';
import 'black_hole_visual.dart';

/// Season 2 — what the home screen becomes once the 66 days are over.
///
/// Season 1 is a journey with an end. Season 2 is a habit with a rhythm: one
/// narrative phase a week, four phases a cycle, forever. The surface says so —
/// there is no progress bar to 100%, only a cycle number that keeps climbing.
///
/// ## What this port does NOT carry over
///
/// The web renders this in an amber/ember palette invented for the season
/// (`#d97706`, `#f0c060`, `#8c6040`, …). The black hole itself keeps those
/// values, because it is a depiction. **Everything else here is Zave**: the
/// cards are [ZaveCard], the habit states are green-for-done and amber-for-
/// open, and the planner CTA is the screen's one white primary button rather
/// than an amber gradient. Two palettes would have made Season 2 look like a
/// different product, which is exactly what this alignment exists to stop.
///
/// ## What the habit rows deliberately cannot do
///
/// They navigate, and that is all. The web threads a `handleComplete` into
/// every row and then never calls it — completion is recorded server-side when
/// the work actually lands. A tick-to-complete control here would let a user
/// mark "Publish a post" done without publishing one.
class SeasonTwoView extends StatelessWidget {
  const SeasonTwoView({
    required this.progress,
    required this.contentMode,
    required this.seasonStartedAt,
    required this.roadmapStartedAt,
    required this.onStart,
    required this.topInset,
    super.key,
  });

  final RoadmapProgress progress;

  /// `'authority'` | `'transformation'`. Decides which phase table answers.
  final String contentMode;

  final DateTime? seasonStartedAt;
  final DateTime? roadmapStartedAt;

  final ValueChanged<String> onStart;
  final double topInset;

  @override
  Widget build(BuildContext context) {
    final int day = seasonDay(
      seasonStartedAt: seasonStartedAt,
      roadmapStartedAt: roadmapStartedAt,
    );
    final int cycle = seasonTwoLoopNumber(day);
    final int phaseDay = seasonTwoPhaseDay(day);
    final int phaseIndex = seasonTwoPhaseIndex(day, contentMode);
    final SeasonTwoPhase phase = seasonTwoPhases[phaseIndex];
    final NarrativePhase intent = seasonTwoIntent(day, contentMode);

    final List<DailyHabit> habits = habitsForToday();
    final int done = habits
        .where((DailyHabit h) => progress.isStepDone(progress.currentDay, h.id))
        .length;

    return Padding(
      padding: EdgeInsets.only(top: topInset),
      child: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(vertical: ZaveSpace.xl),
              child: Column(
                children: <Widget>[
                  const _Title(),
                  SizedBox(height: ZaveSpace.lg),
                  BlackHoleVisual(phaseIndex: phaseIndex, phaseDay: phaseDay),
                  SizedBox(height: ZaveSpace.lg),
                  _Counters(cycle: cycle, daysInside: day, phaseDay: phaseDay),
                ],
              ),
            ),
          ),
          _Sheet(
            phase: phase,
            intent: intent,
            cycle: cycle,
            phaseIndex: phaseIndex,
            habits: habits,
            doneCount: done,
            isDone: (DailyHabit h) =>
                progress.isStepDone(progress.currentDay, h.id),
            pendingPostId: progress.pendingPostIdToday,
            onStart: onStart,
          ),
        ],
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ZaveSpace.gutter),
      child: Column(
        children: <Widget>[
          Text('✦ PHASE 2 — KEEP GOING', style: ZaveType.kicker),
          SizedBox(height: ZaveSpace.xs),
          Text(
            'Your ongoing plan',
            textAlign: TextAlign.center,
            style: ZaveType.spaceGrotesk(
              size: 24,
              weight: FontWeight.w700,
              tracking: 0.04 * 24,
            ),
          ),
          SizedBox(height: ZaveSpace.xs),
          Text(
            'Each week your posts get a little bolder.',
            textAlign: TextAlign.center,
            style: ZaveType.caption,
          ),
        ],
      ),
    );
  }
}

/// Cycle · Days in phase 2 · Phase day. The three numbers that say where you
/// are when there is no finish line to measure against.
class _Counters extends StatelessWidget {
  const _Counters({
    required this.cycle,
    required this.daysInside,
    required this.phaseDay,
  });

  final int cycle;
  final int daysInside;
  final int phaseDay;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        _tile('Cycle', '$cycle'),
        _divider(),
        _tile('Days in phase 2', '$daysInside'),
        _divider(),
        _tile('Phase day', '$phaseDay', suffix: '/7'),
      ],
    );
  }

  Widget _divider() => Padding(
    padding: EdgeInsets.symmetric(horizontal: ZaveSpace.lg),
    child: Container(height: 28.h, width: 1, color: ZaveColors.rule),
  );

  Widget _tile(String label, String value, {String? suffix}) => Column(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      Text(label.toUpperCase(), style: ZaveType.kicker),
      SizedBox(height: ZaveSpace.xs),
      Text.rich(
        TextSpan(
          text: value,
          style: ZaveType.spaceGrotesk(size: 26, color: ZaveColors.amber),
          children: <InlineSpan>[
            if (suffix != null)
              TextSpan(
                text: suffix,
                style: ZaveType.spaceGrotesk(size: 13, color: ZaveColors.ink45),
              ),
          ],
        ),
      ),
    ],
  );
}

/// The bottom card: which phase this week is, and today's habits.
///
/// The web puts this in a fixed 16px-inset sheet over the black hole; a phone
/// Column reaches the same layout without pinning a height, and without
/// fighting the app shell's bottom bar for the last 64px.
class _Sheet extends StatelessWidget {
  const _Sheet({
    required this.phase,
    required this.intent,
    required this.cycle,
    required this.phaseIndex,
    required this.habits,
    required this.doneCount,
    required this.isDone,
    required this.pendingPostId,
    required this.onStart,
  });

  final SeasonTwoPhase phase;
  final NarrativePhase intent;
  final int cycle;
  final int phaseIndex;
  final List<DailyHabit> habits;
  final int doneCount;
  final bool Function(DailyHabit) isDone;
  final String? pendingPostId;
  final ValueChanged<String> onStart;

  @override
  Widget build(BuildContext context) {
    final bool allDone = doneCount == habits.length;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        ZaveSpace.gutter,
        0,
        ZaveSpace.gutter,
        // Clears the shell's bottom bar, which the body extends behind.
        ZaveSpace.section,
      ),
      child: ZaveCard(
        size: ZaveCardSize.compact,
        padding: EdgeInsets.symmetric(
          horizontal: ZaveSpace.lg,
          vertical: ZaveSpace.lg,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  phase.symbol,
                  style: ZaveType.h3.copyWith(color: ZaveColors.amber),
                ),
                SizedBox(width: ZaveSpace.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text('PHASE · CYCLE $cycle', style: ZaveType.kicker),
                      Text(phase.label, style: ZaveType.h3),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: ZaveSpace.md),

            // The week's brief, in one sentence, with the phase's own signal
            // down the left edge.
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: ZaveSpace.md,
                vertical: ZaveSpace.md,
              ),
              decoration: BoxDecoration(
                color: ZaveGlass.rest,
                borderRadius: ZaveRadius.cardSmBr,
                border: Border(
                  left: BorderSide(color: ZaveColors.amber, width: 3),
                ),
              ),
              child: Text(intent.intent, style: ZaveType.bodyMuted),
            ),
            SizedBox(height: ZaveSpace.md),

            for (int i = 0; i < seasonTwoPhases.length; i++)
              _PhaseLegendRow(
                phase: seasonTwoPhases[i],
                isActive: i == phaseIndex,
                isPast: i < phaseIndex,
              ),
            SizedBox(height: ZaveSpace.md),

            ZaveButton.primary(
              label: "View this cycle's plan",
              expand: true,
              trailing: const Icon(Icons.chevron_right),
              onPressed: () => onStart('/planner'),
            ),

            SizedBox(height: ZaveSpace.xl),
            Row(
              children: <Widget>[
                Expanded(child: Text('DAILY TASKS', style: ZaveType.kicker)),
                ZavePill(
                  label: '$doneCount/${habits.length}${allDone ? ' ✓' : ''}',
                  color: allDone ? ZaveColors.green : ZaveColors.amber,
                ),
              ],
            ),
            SizedBox(height: ZaveSpace.md),
            // Season 1 reaches Open Plexa from its mission sheet; Season 2
            // replaces that whole surface, so finishing the 66 days used to
            // take the day's conversation away from the users who had been
            // here longest and earned it. This is the only other door to it —
            // same chat, same day, same counts.
            if (!allDone) ...<Widget>[
              ZaveButton.primary(
                label: 'Open Plexa',
                icon: const Icon(Icons.auto_awesome_outlined),
                expand: true,
                onPressed: () => showPlexaDay(context),
              ),
              SizedBox(height: ZaveSpace.md),
            ],
            for (final DailyHabit habit in habits) ...<Widget>[
              _HabitRow(
                habit: habit,
                isDone: isDone(habit),
                // The publish habit deep-links to the post awaiting approval
                // when there is one, rather than to a blank composer.
                link: habit.id == 1 && pendingPostId != null
                    ? '/posts/$pendingPostId'
                    : habit.link,
                onStart: onStart,
              ),
              SizedBox(height: ZaveSpace.sm),
            ],
          ],
        ),
      ),
    );
  }
}

/// One of the four phases, in orbit order. Past phases recede, the live one
/// carries the [ZaveGlass.now] fill.
class _PhaseLegendRow extends StatelessWidget {
  const _PhaseLegendRow({
    required this.phase,
    required this.isActive,
    required this.isPast,
  });

  final SeasonTwoPhase phase;
  final bool isActive;
  final bool isPast;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isPast
          ? 0.45
          : isActive
          ? 1
          : 0.65,
      child: Container(
        margin: EdgeInsets.only(bottom: ZaveSpace.xs),
        padding: EdgeInsets.symmetric(
          horizontal: ZaveSpace.md,
          vertical: ZaveSpace.sm,
        ),
        decoration: isActive ? ZaveSurface.rowNow : null,
        child: Row(
          children: <Widget>[
            Text(
              phase.symbol,
              style: ZaveType.label.copyWith(
                color: isActive ? ZaveColors.amber : ZaveColors.ink45,
              ),
            ),
            SizedBox(width: ZaveSpace.md),
            Expanded(
              child: Text(
                phase.label,
                style: ZaveType.label.copyWith(
                  color: isActive ? ZaveColors.ink85 : ZaveColors.ink45,
                ),
              ),
            ),
            if (isActive)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const ZaveDot(ZaveColors.amber),
                  SizedBox(width: ZaveSpace.sm),
                  Text(
                    'NOW',
                    style: ZaveType.kicker.copyWith(color: ZaveColors.amber),
                  ),
                ],
              )
            else if (isPast)
              Text(
                'DONE',
                style: ZaveType.kicker.copyWith(color: ZaveColors.green),
              ),
          ],
        ),
      ),
    );
  }
}

/// One of today's habits. Tapping the row opens the task; the trailing button
/// is the same action, shown because the web shows it.
class _HabitRow extends StatelessWidget {
  const _HabitRow({
    required this.habit,
    required this.isDone,
    required this.link,
    required this.onStart,
  });

  final DailyHabit habit;
  final bool isDone;
  final String link;
  final ValueChanged<String> onStart;

  @override
  Widget build(BuildContext context) {
    return ZaveCard(
      size: ZaveCardSize.small,
      padding: EdgeInsets.symmetric(
        horizontal: ZaveSpace.lg,
        vertical: ZaveSpace.md,
      ),
      onTap: isDone ? null : () => onStart(link),
      child: Opacity(
        opacity: isDone ? 0.65 : 1,
        child: Row(
          children: <Widget>[
            ZaveDot(isDone ? ZaveColors.green : ZaveColors.amber),
            SizedBox(width: ZaveSpace.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    habit.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: ZaveType.label.copyWith(
                      color: isDone ? ZaveColors.ink50 : ZaveColors.ink85,
                      decoration: isDone ? TextDecoration.lineThrough : null,
                      decorationColor: ZaveColors.ink50,
                    ),
                  ),
                  Text(
                    '+${habit.xp} XP',
                    style: ZaveType.caption.copyWith(
                      color: isDone ? ZaveColors.ink35 : ZaveColors.amber,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              isDone ? Icons.check : Icons.play_arrow,
              size: 18.r,
              color: isDone ? ZaveColors.green : ZaveColors.amber,
            ),
          ],
        ),
      ),
    );
  }
}

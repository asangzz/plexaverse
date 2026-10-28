import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/zave_routes.dart';

import '../../../../core/ui/app_icons.dart';
import '../../../../core/ui/zave/zave_kit.dart';
import '../../application/learn_controllers.dart';
import '../../domain/learn_repository.dart';
import '../../domain/learn_unit.dart';
import '../widgets/lesson_player.dart';
import '../widgets/level_node.dart';

/// The week, climbed.
///
/// Section = the phase, unit = the week's topic, levels = one day's ladder.
/// The lesson and the post are the same work: the sentence the user writes in
/// an exercise is the sentence that ends up in the post, so neither is a tax
/// on the other.
///
/// ## Two screens, not one with a swapped body
///
/// The path wears a large title and scrolls. A day being climbed is a quiz: a
/// progress bar it cannot scroll away from, a question, and a bar pinned to
/// the foot that the keyboard pushes up. Those are different layouts — the
/// large-title header is a collapsing sliver and cannot hold a non-scrolling
/// body at all — so they are different scaffolds rather than one scaffold
/// apologising for both.
class LearnPage extends ConsumerWidget {
  const LearnPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int? openDay = ref.watch(learnOpenDayProvider);
    return openDay == null ? const _PathScreen() : _DayScreen(day: openDay);
  }
}

class _PathScreen extends ConsumerWidget {
  const _PathScreen();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<LearnPath> path = ref.watch(learnPathProvider);

    return ZaveScaffold(
      largeTitle: 'Learn',
      subtitle: 'This week, one day at a time',
      body: path.when(
        loading: () => const _PathSkeleton(),
        error: (Object e, StackTrace _) => ZaveScrollView(
          children: <Widget>[
            ZaveEmptyState(
              kicker: 'NOT READY',
              title: 'No week to climb yet',
              body: learnMessage(e),
              // A week with no plan is not a failed request, and retrying
              // cannot produce one — the planner is where a week comes from.
              action: e is LearnNoPlan
                  ? ZaveButton(
                      label: 'Open the planner',
                      onPressed: () => context.push(ZaveRoutes.planner),
                    )
                  : ZaveButton(
                      label: 'Try again',
                      onPressed: () => ref.invalidate(learnPathProvider),
                    ),
            ),
          ],
        ),
        data: (LearnPath p) => _Path(path: p),
      ),
    );
  }
}

/// The week's days, as a column of rungs.
class _Path extends ConsumerWidget {
  const _Path({required this.path});

  final LearnPath path;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (path.days.isEmpty) {
      return ZaveScrollView(
        children: const <Widget>[
          ZaveEmptyState(
            title: 'Nothing to climb this week',
            body: 'When the week has a plan, its days show up here.',
          ),
        ],
      );
    }

    return RefreshIndicator(
      color: ZaveColors.white,
      backgroundColor: ZaveColors.deep,
      onRefresh: () async {
        // The PATH only. Never the unit — that provider's build() is a model
        // call, and a pull-to-refresh that regenerates a ladder would be an
        // expensive gesture with no visible result.
        ref.invalidate(learnPathProvider);
        await ref.read(learnPathProvider.future);
      },
      child: ZaveScrollView(
        children: <Widget>[
          _WeekHeader(path: path),
          SizedBox(height: ZaveSpace.xl),
          for (final LearnPathDay day in path.days) ...<Widget>[
            _DayRow(day: day),
            SizedBox(height: ZaveSpace.md),
          ],
          SizedBox(height: ZaveSpace.section),
        ],
      ),
    );
  }
}

class _WeekHeader extends ConsumerWidget {
  const _WeekHeader({required this.path});

  final LearnPath path;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final LearnWeek week = ref.read(learnWeekProvider.notifier);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Text(
                path.phase.isEmpty
                    ? 'WEEK ${path.weekNumber}'
                    : path.phase.toUpperCase(),
                style: ZaveType.kicker,
              ),
            ),
            ZaveIconButton(
              icon: const Icon(AppIcons.chevronLeft),
              tooltip: 'Previous week',
              onPressed: path.weekNumber > 1
                  ? () => week.showWeek(path.weekNumber - 1)
                  : null,
            ),
            SizedBox(width: ZaveSpace.sm),
            ZaveIconButton(
              icon: const Icon(AppIcons.chevronRight),
              tooltip: 'Next week',
              onPressed: () => week.showWeek(path.weekNumber + 1),
            ),
          ],
        ),
        SizedBox(height: ZaveSpace.md),
        Text(
          path.unitTitle.isEmpty ? 'Week ${path.weekNumber}' : path.unitTitle,
          style: ZaveType.h2,
        ),
        SizedBox(height: ZaveSpace.sm),
        Text(
          '${path.completedDays} of ${path.climbable.length} days done',
          style: ZaveType.bodyMuted,
        ),
      ],
    );
  }
}

/// One day, as a row with its rung and its progress.
class _DayRow extends ConsumerWidget {
  const _DayRow({required this.day});

  final LearnPathDay day;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool locked = day.isLocked;
    final bool done = day.status == UnitStatus.complete;

    return ZaveCard(
      // A locked day is not tappable, and says why rather than just refusing.
      onTap: locked
          ? null
          : () => ref.read(learnOpenDayProvider.notifier).open(day.dayIndex),
      child: Row(
        children: <Widget>[
          LevelNode(
            // The rung shows the day's SHAPE, not a level — a post day, a
            // script day, the newsletter.
            kind: switch (day.kind) {
              DayKind.article => LevelKind.review,
              DayKind.videoScript => LevelKind.visual,
              _ => LevelKind.draft,
            },
            status: done
                ? LevelStatus.complete
                : locked
                ? LevelStatus.locked
                : LevelStatus.available,
          ),
          SizedBox(width: ZaveSpace.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  day.day.toUpperCase(),
                  style: ZaveType.kicker.copyWith(
                    color: locked ? ZaveColors.ink35 : ZaveColors.ink62,
                  ),
                ),
                SizedBox(height: ZaveSpace.xs),
                Text(
                  day.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: ZaveType.body.copyWith(
                    color: locked ? ZaveColors.ink45 : ZaveColors.white,
                  ),
                ),
                SizedBox(height: ZaveSpace.sm),
                Text(
                  locked
                      ? 'Finish the day before this one'
                      // Said out loud, because the first tap is the
                      // expensive one: the server builds the whole ladder
                      // with a model call before it can answer.
                      : !day.started
                      ? "Tap to start — today's lesson is written when you do"
                      : '${day.completedCount} of ${day.levelCount} levels',
                  style: ZaveType.caption.copyWith(
                    color: locked ? ZaveColors.ink35 : ZaveColors.ink62,
                  ),
                ),
              ],
            ),
          ),
          if (!locked && !done)
            const Icon(
              AppIcons.chevronRight,
              size: 18,
              color: ZaveColors.ink45,
            ),
        ],
      ),
    );
  }
}

/// One day's ladder, once it has been opened.
class _DayScreen extends ConsumerWidget {
  const _DayScreen({required this.day});

  final int day;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final LearnPath? path = ref.watch(learnPathProvider).value;
    void close() => ref.read(learnOpenDayProvider.notifier).close();

    // A day can only be opened from a loaded path, so this is the
    // week-changed-underneath case. Going back to the week is the only
    // sensible answer, and it is one frame.
    if (path == null) return const _PathScreen();

    final int week = path.weekNumber;
    final AsyncValue<LearnUnit> unit = ref.watch(
      learnUnitControllerProvider(week, day),
    );

    return ZaveScaffold(
      title: _titleFor(path),
      // Replaces the route's back arrow, which would leave Learn entirely.
      // Inside a day, back means back to the week.
      leading: ZaveIconButton(
        icon: const Icon(AppIcons.back),
        tooltip: 'Back to the week',
        onPressed: close,
      ),
      body: unit.when(
        // The first open BUILDS the ladder with a model call, so this wait is
        // seconds, not milliseconds, and says so.
        loading: () => const _BuildingLadder(),
        error: (Object e, StackTrace _) => ZaveScrollView(
          children: <Widget>[
            ZaveEmptyState(
              kicker: 'COULD NOT OPEN',
              title: "Today's lesson did not come through",
              body: learnMessage(e),
              action: ZaveButton(
                label: 'Try again',
                // By the user, never automatically — a retry is another
                // model call.
                onPressed: () =>
                    ref.invalidate(learnUnitControllerProvider(week, day)),
              ),
            ),
          ],
        ),
        data: (LearnUnit u) => LessonPlayer(
          unit: u,
          week: week,
          day: day,
          onClose: close,
        ),
      ),
    );
  }

  String _titleFor(LearnPath path) {
    for (final LearnPathDay d in path.days) {
      if (d.dayIndex == day) return d.title;
    }
    return path.unitTitle.isEmpty ? 'This week' : path.unitTitle;
  }
}

class _BuildingLadder extends StatelessWidget {
  const _BuildingLadder();

  @override
  Widget build(BuildContext context) => ZaveScrollView(
    children: <Widget>[
      ZaveCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("WRITING TODAY'S LESSON", style: ZaveType.kicker),
            SizedBox(height: ZaveSpace.lg),
            const ZaveShimmer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ZaveSkeleton.bar(widthFactor: 0.5, height: 18),
                  SizedBox(height: 12),
                  ZaveSkeleton.bar(),
                  SizedBox(height: 8),
                  ZaveSkeleton.bar(widthFactor: 0.8),
                  SizedBox(height: 20),
                  ZaveSkeleton.block(height: 72),
                  SizedBox(height: 12),
                  ZaveSkeleton.block(height: 72),
                ],
              ),
            ),
            SizedBox(height: ZaveSpace.lg),
            Text(
              'This one is written for you, now. It takes a few seconds.',
              style: ZaveType.caption.copyWith(color: ZaveColors.ink45),
            ),
          ],
        ),
      ),
    ],
  );
}

class _PathSkeleton extends StatelessWidget {
  const _PathSkeleton();

  @override
  Widget build(BuildContext context) => ZaveShimmer(
    child: ZaveScrollView(
      children: <Widget>[
        const ZaveSkeleton.bar(width: 120),
        SizedBox(height: ZaveSpace.lg),
        const ZaveSkeleton.bar(widthFactor: 0.7, height: 30),
        SizedBox(height: ZaveSpace.xl),
        for (int i = 0; i < 5; i++) ...<Widget>[
          const ZaveSkeleton.block(height: 96),
          SizedBox(height: ZaveSpace.md),
        ],
      ],
    ),
  );
}

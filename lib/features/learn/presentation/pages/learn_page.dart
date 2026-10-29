import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/zave_routes.dart';
import '../../../../core/ui/app_icons.dart';
import '../../../../core/ui/zave/zave_kit.dart';
import '../../../plexa/presentation/widgets/plexa_clips.dart';
import '../../../plexa/presentation/widgets/plexa_mascot.dart';
import '../../application/learn_controllers.dart';
import '../../domain/ladder_template.dart';
import '../../domain/learn_repository.dart';
import '../../domain/learn_unit.dart';
import '../widgets/lesson_player.dart';
import '../widgets/level_node.dart';

/// The week, as a path you climb.
///
/// A port of the web's `components/learn/LearnPath.tsx`: one continuous run
/// of nodes from Monday to Friday, a day marker between each group, and a
/// unit banner at the top naming the week's topic — the thing every post
/// that week is a facet of.
///
/// ## The offset curve
///
/// Nodes are pushed left and right on a fixed four-step cycle rather than a
/// sine or a random walk. A sine makes the amplitude depend on how many
/// nodes a day happens to have, so a six-level day and a seven-level day
/// curve differently and the path looks like it is drifting; a fixed cycle
/// is the same shape whatever is on it. It is also the thing that makes a
/// long list feel like a journey instead of a form, which is the entire
/// reason the nodes are not a list.
///
/// ## The path does not go away while a day is being built
///
/// Opening a day is a model call that takes seconds. The web learned to keep
/// the path on screen through it — the day's nodes dim and "Writing today's
/// lessons…" appears under that day's marker — rather than replacing the
/// whole screen with a spinner, so the wait happens somewhere that makes
/// sense. This did replace the screen, and now it does not.
class LearnPage extends ConsumerWidget {
  const LearnPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final LearnSpot? spot = ref.watch(learnOpenDayProvider);
    final AsyncValue<LearnPath> path = ref.watch(learnPathProvider);
    final int? week = path.value?.weekNumber;

    // The unit is fetched HERE and not in the player: mounting the player on
    // an empty unit would leave the user watching a spinner where a lesson
    // should be.
    final AsyncValue<LearnUnit>? unit = spot == null || week == null
        ? null
        : ref.watch(learnUnitControllerProvider(week, spot.dayIndex));

    final LearnUnit? ready = unit?.value;
    if (spot != null && week != null && ready?.dayIndex == spot.dayIndex) {
      return _PlayerScreen(unit: ready!, week: week, spot: spot);
    }

    return ZaveScaffold(
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
        data: (LearnPath p) => _Path(
          path: p,
          busyDayIndex: unit is AsyncLoading ? spot?.dayIndex : null,
          failedDay: unit?.hasError ?? false ? spot?.dayIndex : null,
          error: unit?.error,
        ),
      ),
    );
  }
}

class _Path extends ConsumerWidget {
  const _Path({
    required this.path,
    required this.busyDayIndex,
    required this.failedDay,
    required this.error,
  });

  final LearnPath path;

  /// The day whose ladder is being written, if any.
  final int? busyDayIndex;

  final int? failedDay;
  final Object? error;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // One counter for the WHOLE path, not per day — the curve is a property
    // of the run of nodes, so restarting it at each day would kink it.
    int nodeOrder = 0;

    return Column(
      children: <Widget>[
        _UnitBanner(path: path),
        Expanded(
          child: RefreshIndicator(
            color: ZaveColors.white,
            backgroundColor: ZaveColors.deep,
            onRefresh: () async {
              // The PATH only. Never a unit — that provider's build() is a
              // model call, and a pull-to-refresh that regenerated a ladder
              // would be an expensive gesture with no visible result.
              ref.invalidate(learnPathProvider);
              await ref.read(learnPathProvider.future);
            },
            child: ListView(
              padding: EdgeInsets.fromLTRB(
                ZaveSpace.gutter,
                ZaveSpace.md,
                ZaveSpace.gutter,
                ZaveSpace.section,
              ),
              children: <Widget>[
                if (path.days.isEmpty)
                  const ZaveEmptyState(
                    title: 'Nothing to climb this week',
                    body: 'This week has no writing days yet. Generate a '
                        'plan in the planner first.',
                  ),
                for (final LearnPathDay day in path.days)
                  _DayGroup(
                    day: day,
                    nodes: levelsForDay(day),
                    here: path.nextDayIndex == day.dayIndex,
                    busy: busyDayIndex == day.dayIndex,
                    firstOrder: () {
                      final int start = nodeOrder;
                      nodeOrder += levelsForDay(day).length;
                      return start;
                    }(),
                    onOpen: (int levelIndex) => ref
                        .read(learnOpenDayProvider.notifier)
                        .open(day.dayIndex, levelIndex),
                  ),
                if (failedDay != null && error != null) ...<Widget>[
                  SizedBox(height: ZaveSpace.xl),
                  _CouldNotOpen(
                    message: learnMessage(error!),
                    onDismiss: () =>
                        ref.read(learnOpenDayProvider.notifier).close(),
                  ),
                ],
                if (path.nextDayIndex == null && path.days.isNotEmpty) ...<Widget>[
                  SizedBox(height: ZaveSpace.xxl),
                  const _WeekComplete(),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// The week's topic, pinned above the path.
///
/// Outside the scroll view rather than sticky inside it, which is the same
/// result with none of the sliver machinery: on a path this long it is the
/// only thing telling you what any of it is for.
class _UnitBanner extends ConsumerWidget {
  const _UnitBanner({required this.path});

  final LearnPath path;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final LearnWeek week = ref.read(learnWeekProvider.notifier);
    final String phase = path.phase.replaceAll('_', ' ');

    return Padding(
      padding: EdgeInsets.fromLTRB(
        ZaveSpace.gutter,
        ZaveScaffold.contentTop(context) + ZaveSpace.md,
        ZaveSpace.gutter,
        ZaveSpace.sm,
      ),
      child: Container(
        padding: ZaveSpace.cardPad,
        decoration: BoxDecoration(
          color: ZaveColors.violet,
          borderRadius: ZaveRadius.cardBr,
          boxShadow: ZaveShadow.lifted,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    phase.isEmpty
                        ? 'WEEK ${path.weekNumber}'
                        : '${phase.toUpperCase()} · WEEK ${path.weekNumber}',
                    style: ZaveType.kicker.copyWith(
                      color: ZaveColors.white.withValues(alpha: 0.7),
                    ),
                  ),
                  SizedBox(height: ZaveSpace.xs),
                  Text(
                    path.unitTitle.isEmpty
                        ? 'Week ${path.weekNumber}'
                        : path.unitTitle,
                    style: ZaveType.h3.copyWith(color: ZaveColors.white),
                  ),
                ],
              ),
            ),
            SizedBox(width: ZaveSpace.sm),
            _BannerArrow(
              icon: AppIcons.chevronLeft,
              tooltip: 'Previous week',
              onPressed: path.weekNumber > 1
                  ? () => week.showWeek(path.weekNumber - 1)
                  : null,
            ),
            SizedBox(width: ZaveSpace.xs),
            _BannerArrow(
              icon: AppIcons.chevronRight,
              tooltip: 'Next week',
              onPressed: () => week.showWeek(path.weekNumber + 1),
            ),
          ],
        ),
      ),
    );
  }
}

class _BannerArrow extends StatelessWidget {
  const _BannerArrow({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final Widget box = Container(
      height: 34,
      width: 34,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        // Darkened violet rather than glass: a white scrim on a violet card
        // reads as a lighter patch, not a control.
        color: Colors.black.withValues(alpha: onPressed == null ? 0.08 : 0.18),
        borderRadius: BorderRadius.circular(ZaveRadius.cardSm),
      ),
      child: Icon(
        icon,
        size: 16,
        color: ZaveColors.white.withValues(alpha: onPressed == null ? 0.3 : 0.8),
      ),
    );

    if (onPressed == null) return box;
    return Tooltip(
      message: tooltip,
      child: ZavePress(
        child: GestureDetector(
          onTap: onPressed,
          behavior: HitTestBehavior.opaque,
          child: box,
        ),
      ),
    );
  }
}

/// One day: its marker, then its run of nodes.
class _DayGroup extends StatelessWidget {
  const _DayGroup({
    required this.day,
    required this.nodes,
    required this.here,
    required this.busy,
    required this.firstOrder,
    required this.onOpen,
  });

  final LearnPathDay day;
  final List<PathNode> nodes;

  /// The day the user is actually on. Plexa stands beside it.
  final bool here;

  final bool busy;

  /// Where this day's nodes sit in the path-wide curve.
  final int firstOrder;

  final ValueChanged<int> onOpen;

  /// Centre, right, centre, left — a lazy S.
  static const List<double> _curve = <double>[0, 52, 0, -52];

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      _DayMarker(day: day),
      if (here)
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.only(right: ZaveSpace.md),
            // Still, not playing. This page scrolls for thirty nodes and a
            // looping video parked in it would run the whole time the user
            // is reading a lesson list.
            child: const PlexaMascot(
              clip: PlexaClip.excited,
              clips: <PlexaClip>[PlexaClip.excited],
              height: 104,
              still: true,
            ),
          ),
        ),
      if (busy) ...<Widget>[
        Padding(
          padding: EdgeInsets.only(bottom: ZaveSpace.md),
          child: Text(
            "Writing today's lessons…",
            textAlign: TextAlign.center,
            style: ZaveType.caption.copyWith(color: ZaveColors.ink62),
          ),
        ),
      ],
      Opacity(
        opacity: busy ? 0.4 : 1,
        child: Column(
          children: <Widget>[
            for (int i = 0; i < nodes.length; i++) ...<Widget>[
              if (i > 0) SizedBox(height: ZaveSpace.lg),
              Transform.translate(
                offset: Offset(_curve[(firstOrder + i) % _curve.length], 0),
                child: LevelNode(
                  kind: nodes[i].kind,
                  status: nodes[i].status,
                  label: nodes[i].title,
                  onTap: nodes[i].status == LevelStatus.locked || busy
                      ? null
                      : () => onOpen(i),
                ),
              ),
            ],
          ],
        ),
      ),
    ],
  );
}

class _DayMarker extends StatelessWidget {
  const _DayMarker({required this.day});

  final LearnPathDay day;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.symmetric(vertical: ZaveSpace.xl),
    // The rules give way to the title, not the other way round.
    //
    // Two plain `Expanded` dividers split the leftover evenly with the text
    // and left a phone showing "Why most …", which names nothing. The
    // dividers are decoration; the day's title is the only thing on this row
    // a user reads.
    child: Row(
      children: <Widget>[
        const Expanded(child: Divider(color: ZaveColors.rule, height: 1)),
        SizedBox(width: ZaveSpace.sm),
        Flexible(
          flex: 10,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (day.isLocked) ...<Widget>[
                const Icon(AppIcons.lock, size: 12, color: ZaveColors.ink35),
                SizedBox(width: ZaveSpace.xs),
              ],
              Text(day.day.toUpperCase(), style: ZaveType.kicker),
              SizedBox(width: ZaveSpace.sm),
              Flexible(
                child: Text(
                  day.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: ZaveType.caption.copyWith(color: ZaveColors.ink45),
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: ZaveSpace.sm),
        const Expanded(child: Divider(color: ZaveColors.rule, height: 1)),
      ],
    ),
  );
}

class _WeekComplete extends StatelessWidget {
  const _WeekComplete();

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: ZaveSpace.cardPad,
    decoration: BoxDecoration(
      color: ZaveColors.green.withValues(alpha: 0.06),
      border: Border.all(color: ZaveColors.green.withValues(alpha: 0.25)),
      borderRadius: ZaveRadius.cardBr,
    ),
    child: Column(
      children: <Widget>[
        Text(
          'Week complete.',
          style: ZaveType.label.copyWith(color: ZaveColors.green),
        ),
        SizedBox(height: ZaveSpace.xs),
        Text(
          'Every post this week was written in your own words.',
          textAlign: TextAlign.center,
          style: ZaveType.caption.copyWith(color: ZaveColors.ink62),
        ),
      ],
    ),
  );
}

/// The day would not open. Shown UNDER the path rather than instead of it —
/// the week is still there and still climbable.
class _CouldNotOpen extends StatelessWidget {
  const _CouldNotOpen({required this.message, required this.onDismiss});

  final String message;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: ZaveSpace.cardPad,
    decoration: BoxDecoration(
      color: ZaveColors.amber.withValues(alpha: 0.08),
      border: Border.all(color: ZaveColors.amber.withValues(alpha: 0.25)),
      borderRadius: ZaveRadius.cardBr,
    ),
    child: Column(
      children: <Widget>[
        Text(
          message,
          textAlign: TextAlign.center,
          style: ZaveType.caption.copyWith(color: ZaveColors.amber),
        ),
        SizedBox(height: ZaveSpace.md),
        ZaveButton(label: 'Back to the path', onPressed: onDismiss),
      ],
    ),
  );
}

/// One day's ladder, open.
class _PlayerScreen extends ConsumerWidget {
  const _PlayerScreen({
    required this.unit,
    required this.week,
    required this.spot,
  });

  final LearnUnit unit;
  final int week;
  final LearnSpot spot;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void close() => ref.read(learnOpenDayProvider.notifier).close();

    return ZaveScaffold(
      title: unit.title,
      // Replaces the route's back arrow, which would leave Learn entirely.
      // Inside a day, back means back to the week.
      leading: ZaveIconButton(
        icon: const Icon(AppIcons.back),
        tooltip: 'Back to the week',
        onPressed: close,
      ),
      body: LessonPlayer(
        unit: unit,
        week: week,
        day: spot.dayIndex,
        // A node the user tapped may be ahead of where they actually are —
        // the path draws placeholders from the template before the ladder
        // exists. The real ladder is the authority.
        openAt: spot.levelIndex,
        onClose: close,
      ),
    );
  }
}

class _PathSkeleton extends StatelessWidget {
  const _PathSkeleton();

  @override
  Widget build(BuildContext context) => ZaveShimmer(
    child: ZaveScrollView(
      children: <Widget>[
        const ZaveSkeleton.block(height: 84),
        SizedBox(height: ZaveSpace.xl),
        for (int i = 0; i < 4; i++) ...<Widget>[
          const ZaveSkeleton.bar(widthFactor: 0.6, height: 14),
          SizedBox(height: ZaveSpace.lg),
          Center(
            child: ClipOval(
              child: const ZaveSkeleton.block(
                height: LevelNode.size,
                width: LevelNode.size,
              ),
            ),
          ),
          SizedBox(height: ZaveSpace.lg),
        ],
      ],
    ),
  );
}

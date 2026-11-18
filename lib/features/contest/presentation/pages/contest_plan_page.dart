import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/responsive/screen_util.dart';
import '../../../../core/router/zave_routes.dart';
import '../../../../core/ui/zave/zave_kit.dart';
import '../../../../core/week/week_shape.dart';
import '../../application/plan_week_controllers.dart';
import '../../domain/contest_repository.dart';
import '../widgets/contest_kit.dart';
import '../widgets/sheet/contest_sheet.dart';
import '../widgets/skip_level.dart';

/// `/contest/plan` — Sunday's level: plan this week, day by day. The web's
/// `WeekPlanGuide`.
///
/// No links are asked for here: each piece the learner posts by hand has its
/// link asked for on the day it goes out, as that day's own level. The day
/// list is the Planner's own data with the server's words; the page draws it.
///
/// ## What the web has that this does not
///
/// The web puts the Planner's ChatGPT connector panel under the list. The app
/// has no connector UI, so the page keeps the list, "Open the Planner" and
/// "I've planned this week" — and the not-planned line drops its mention of
/// the connector rather than pointing at a panel that is not there.
class ContestPlanPage extends ConsumerWidget {
  const ContestPlanPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<PlanWeekView> plan = ref.watch(contestPlanWeekProvider);

    return ContestSheet(
      onRefresh: () async {
        ref.invalidate(contestPlanWeekProvider);
        try {
          await ref.read(contestPlanWeekProvider.future);
        } on Object {
          // The sheet shows the failure itself.
        }
      },
      children: <Widget>[
        const ContestSheetHeader(
          kicker: 'Sunday · plan this week',
          title: 'Plan this week',
          // No counts or weekdays here: the week's shape is the server's, and
          // the day-by-day list below is read off it.
          lead:
              'Get this week ready in the Planner, day by day below. Nothing to '
              'share today: each piece you post yourself has its link asked '
              'for on the day it goes out.',
        ),
        plan.when(
          data: (PlanWeekView view) => _ThisWeek(view: view),
          error: (Object error, StackTrace _) =>
              Text(contestMessage(error), style: ContestType.meta),
          loading: () => const ContestSheetSkeleton(),
        ),
      ],
    );
  }
}

/// "This week": the topic, the way to the Planner, the days, and marking it
/// planned.
class _ThisWeek extends StatelessWidget {
  const _ThisWeek({required this.view});

  final PlanWeekView view;

  @override
  Widget build(BuildContext context) {
    final String? topic = view.topic;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.end,
          spacing: ZaveSpace.md,
          runSpacing: ZaveSpace.md,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Semantics(
                  header: true,
                  child: Text('This week', style: ContestType.sectionTitle),
                ),
                if (topic != null && topic.isNotEmpty) ...<Widget>[
                  SizedBox(height: ZaveSpace.xs),
                  Text(topic, style: ContestType.meta),
                ],
              ],
            ),
            // The app's own Planner — `plannerHref` is the web's address.
            ContestGhostPill(
              label: 'Open the Planner',
              onPressed: () => context.go(ZaveRoutes.planner),
            ),
          ],
        ),
        if (!view.planned) ...<Widget>[
          SizedBox(height: ZaveSpace.lg),
          Text(
            'This week is not in the Planner yet. Open the Planner to '
            'generate it.',
            style: ZaveType.body.copyWith(fontSize: 15.sp),
          ),
        ],
        SizedBox(height: ZaveSpace.lg),
        for (final PlanWeekDay day in view.days) ...<Widget>[
          _DayRow(day: day),
          SizedBox(height: ZaveSpace.md),
        ],
        SizedBox(height: ZaveSpace.sm),
        _Completion(view: view),
      ],
    );
  }
}

/// One planner day: a rest day as a quiet line, anything else as a panel
/// with its title, its state and what to do with it.
class _DayRow extends StatelessWidget {
  const _DayRow({required this.day});

  final PlanWeekDay day;

  /// The web's `KIND_LABEL`.
  static String _kindLabel(DayKind kind) => switch (kind) {
    DayKind.post => 'Post',
    DayKind.videoScript => 'Video',
    DayKind.article => 'Newsletter article',
    DayKind.rest => 'Rest',
  };

  @override
  Widget build(BuildContext context) {
    final String date = weekdayDate(day.dayKey);
    if (day.kind == DayKind.rest) {
      return Semantics(
        label: '${day.weekday}: rest',
        excludeSemantics: true,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: ZaveSpace.xs,
            vertical: ZaveSpace.sm,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: 92.w,
                child: Text(
                  date,
                  style: ContestType.meta.copyWith(
                    fontFeatures: const <FontFeature>[
                      FontFeature.tabularFigures(),
                    ],
                  ),
                ),
              ),
              SizedBox(width: ZaveSpace.md),
              Expanded(child: Text(day.instruction, style: ContestType.meta)),
            ],
          ),
        ),
      );
    }
    final String? title = day.title;
    return Semantics(
      label: '${day.weekday}: ${_kindLabel(day.kind)}',
      container: true,
      child: ContestPanel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('$date · ${_kindLabel(day.kind)}', style: ContestType.meta),
            SizedBox(height: ZaveSpace.xs),
            Text(
              title == null || title.isEmpty ? 'Not planned yet' : title,
              style: ContestType.cardTitle,
            ),
            SizedBox(height: ZaveSpace.sm),
            ContestDot(
              tone: day.ready ? ContestTone.live : ContestTone.idle,
              label: day.status,
            ),
            SizedBox(height: ZaveSpace.md),
            Text(
              day.instruction,
              style: ZaveType.body.copyWith(
                fontSize: 15.sp,
                height: 1.6,
                color: ZaveColors.ink85,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Marking the week planned, or why it cannot be marked yet.
class _Completion extends ConsumerWidget {
  const _Completion({required this.view});

  final PlanWeekView view;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final PlanWeekMark mark = ref.watch(planWeekActionsProvider);
    final TextStyle line = ZaveType.body.copyWith(
      fontSize: 16.sp,
      color: ZaveColors.ink85,
    );

    if (view.status == PlanWeekStatus.done || mark.done) {
      return Semantics(
        liveRegion: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'This week is planned. Each video’s and the article’s link is a '
              'level of its own day.',
              style: line,
            ),
            SizedBox(height: ZaveSpace.lg),
            const NextLevelPill(from: PathNodeKind.planWeek),
          ],
        ),
      );
    }
    if (view.status == PlanWeekStatus.locked) {
      return Text(
        '${view.lockedDetail ?? 'Finish or skip today’s earlier levels first'}. Plan '
        'the week now, and mark it planned once they are done.',
        style: line,
      );
    }
    if (view.status == PlanWeekStatus.unavailable) {
      return Text(
        view.reason == PlanWeekReason.notToday
            ? 'You mark this week planned on Sunday, its first day, as that '
                  'day’s level.'
            : 'Marking the week planned is a contest level, for its entrants.',
        style: ContestType.meta,
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ContestPrimaryPill(
          label: 'I’ve planned this week',
          busy: mark.busy,
          // Refused by the server until the week exists in the Planner, so
          // the button waits for it and says why.
          onPressed: view.planned
              ? ref.read(planWeekActionsProvider.notifier).complete
              : null,
        ),
        if (!view.planned) ...<Widget>[
          SizedBox(height: ZaveSpace.sm),
          Text(kNoPlanLine, style: ContestType.meta),
        ],
        if (mark.error != null) ...<Widget>[
          SizedBox(height: ZaveSpace.md),
          SheetAlert(message: mark.error!, backToPath: mark.locked),
        ],
        const ContestSkipLevel(kind: PathNodeKind.planWeek),
      ],
    );
  }
}

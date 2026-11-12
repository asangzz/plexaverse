import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:plexaverse/core/router/zave_routes.dart';
import 'package:plexaverse/core/week/week_shape.dart';
import 'package:plexaverse/features/contest/application/plan_week_controllers.dart';
import 'package:plexaverse/features/contest/data/contest_repositories.dart';
import 'package:plexaverse/features/contest/domain/contest_repository.dart';
import 'package:plexaverse/features/contest/presentation/pages/contest_plan_page.dart';
import 'package:plexaverse/features/contest/presentation/widgets/sheet/contest_sheet.dart';

/// Sunday's level: plan this week, day by day, and mark it planned.
///
/// The button waits for the Planner — the server refuses it until the week
/// exists there — and says why instead of failing. The day list is the
/// server's words, dated as calendar days, never moved by a timezone.
void main() {
  setUp(FakeContestWorld.reset);

  test('a day key prints as the web prints it, whatever the timezone', () {
    expect(weekdayDate('2026-11-18'), 'Wed 18 Nov');
    expect(weekdayDate('2026-11-15'), 'Sun 15 Nov');
    expect(weekdayDate('2027-01-01'), 'Fri 1 Jan');
    expect(weekdayDate('not a day'), '');
    expect(weekdayDate(null), '');
  });

  testWidgets('not in the Planner yet: the button waits, and says why', (
    WidgetTester tester,
  ) async {
    final _Repo repo = _Repo(_view(planned: false));
    await _pump(tester, repo);

    expect(find.text('SUNDAY · PLAN THIS WEEK'), findsOneWidget);
    expect(find.text('Plan this week'), findsOneWidget);
    expect(
      find.text(
        'This week is not in the Planner yet. Open the Planner to generate it.',
      ),
      findsOneWidget,
    );
    expect(find.text(kNoPlanLine), findsOneWidget);

    await tester.ensureVisible(find.text('I’ve planned this week'));
    await tester.tap(find.text('I’ve planned this week'));
    await tester.pump();
    expect(repo.marks, 0);
  });

  testWidgets('the days, in the server’s words, dated as calendar days', (
    WidgetTester tester,
  ) async {
    await _pump(tester, _Repo(_view()));
    expect(find.text('Writing updates people act on'), findsOneWidget);
    expect(find.text('Wed 18 Nov · Video'), findsOneWidget);
    expect(find.text('Thu 19 Nov · Newsletter article'), findsOneWidget);
    expect(
      find.text('Three numbers I check before every client call'),
      findsOneWidget,
    );
    expect(find.text('Script ready'), findsOneWidget);
    expect(find.text('Article not written yet'), findsOneWidget);
    expect(
      find.text(
        'Record this video and keep it ready. On Wednesday, 18 Nov, this '
        'level will ask for the link to your posted video.',
      ),
      findsOneWidget,
    );
    // A rest day is a quiet line, not a panel.
    expect(find.text('Sun 15 Nov'), findsOneWidget);
    expect(find.text('Plan the week — nothing to post today.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('planned: marked once, then done, and the standing re-read', (
    WidgetTester tester,
  ) async {
    final _Repo repo = _Repo(_view());
    await _pump(tester, repo);
    final int reads = repo.viewReads;

    await tester.ensureVisible(find.text('I’ve planned this week'));
    await tester.tap(find.text('I’ve planned this week'));
    await tester.pump();
    await tester.pump();

    expect(repo.marks, 1);
    expect(
      find.text(
        'This week is planned. Each video’s and the article’s link is a level '
        'of its own day.',
      ),
      findsOneWidget,
    );
    expect(find.text('I’ve planned this week'), findsNothing);
    expect(repo.viewReads, greaterThan(reads));
  });

  testWidgets('refused at the gate: the server’s sentence and the way back', (
    WidgetTester tester,
  ) async {
    await _pump(
      tester,
      _Repo(
        _view(),
        refuse: const ContestLocked('Finish Post 5 valuable comments first.'),
      ),
    );
    await tester.ensureVisible(find.text('I’ve planned this week'));
    await tester.tap(find.text('I’ve planned this week'));
    await tester.pump();
    await tester.pump();
    expect(find.text('Finish Post 5 valuable comments first.'), findsOneWidget);
    expect(find.text('Back to the path'), findsOneWidget);
  });

  testWidgets('locked by the view itself: plan now, mark it after', (
    WidgetTester tester,
  ) async {
    await _pump(
      tester,
      _Repo(
        _view(
          status: PlanWeekStatus.locked,
          lockedDetail: 'Unlocks after Comment on a top voice',
        ),
      ),
    );
    expect(
      find.text(
        'Unlocks after Comment on a top voice. Plan the week now, and mark it '
        'planned once they are done.',
      ),
      findsOneWidget,
    );
    expect(find.text('I’ve planned this week'), findsNothing);
  });

  testWidgets('not Sunday: the list still reads, the marking waits', (
    WidgetTester tester,
  ) async {
    await _pump(
      tester,
      _Repo(
        _view(
          status: PlanWeekStatus.unavailable,
          reason: PlanWeekReason.notToday,
        ),
      ),
    );
    expect(
      find.text(
        'You mark this week planned on Sunday, its first day, as that day’s '
        'level.',
      ),
      findsOneWidget,
    );
    expect(find.text('Wed 18 Nov · Video'), findsOneWidget);
  });

  testWidgets('"Open the Planner" opens the app’s own Planner, not the web '
      'path the view carries', (WidgetTester tester) async {
    await _pump(tester, _Repo(_view()));
    await tester.ensureVisible(find.text('Open the Planner'));
    await tester.tap(find.text('Open the Planner'));
    await tester.pumpAndSettle();
    expect(find.text('planner'), findsOneWidget);
  });

  testWidgets('the mock flavor’s Wednesday renders at the narrowest phone', (
    WidgetTester tester,
  ) async {
    await _pump(tester, FakeContestRepository(latency: Duration.zero));
    expect(find.text('This week'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

// ── Fixtures ────────────────────────────────────────────────────────────────

PlanWeekView _view({
  bool planned = true,
  PlanWeekStatus status = PlanWeekStatus.open,
  PlanWeekReason? reason,
  String? lockedDetail,
}) => PlanWeekView(
  status: status,
  reason: reason,
  lockedDetail: lockedDetail,
  weekNumber: 7,
  planned: planned,
  topic: 'Writing updates people act on',
  plannerHref: '/planner?week=7',
  days: const <PlanWeekDay>[
    PlanWeekDay(
      index: 6,
      weekday: 'Sunday',
      dayKey: '2026-11-15',
      kind: DayKind.rest,
      status: 'Rest',
      ready: true,
      instruction: 'Plan the week — nothing to post today.',
    ),
    PlanWeekDay(
      index: 2,
      weekday: 'Wednesday',
      dayKey: '2026-11-18',
      kind: DayKind.videoScript,
      title: 'Three numbers I check before every client call',
      status: 'Script ready',
      ready: true,
      instruction:
          'Record this video and keep it ready. On Wednesday, 18 Nov, this '
          'level will ask for the link to your posted video.',
    ),
    PlanWeekDay(
      index: 3,
      weekday: 'Thursday',
      dayKey: '2026-11-19',
      kind: DayKind.article,
      status: 'Article not written yet',
      instruction:
          'Get the article ready to paste into LinkedIn’s newsletter. On '
          'Thursday, 19 Nov, this level will ask for the article’s link.',
    ),
  ],
);

class _Repo extends FakeContestRepository {
  _Repo(this.view, {this.refuse}) : super(latency: Duration.zero);

  final PlanWeekView view;
  final ContestRefusal? refuse;
  int marks = 0;
  int viewReads = 0;

  @override
  Future<PlanWeekView> fetchPlanWeek() async {
    viewReads++;
    return view;
  }

  @override
  Future<PlanWeekResult> completePlanWeek() async {
    final ContestRefusal? no = refuse;
    if (no != null) throw no;
    marks++;
    return const PlanWeekResult(taskId: 'plan-1');
  }
}

Future<void> _pump(WidgetTester tester, ContestRepository repository) async {
  tester.view.physicalSize = const Size(375, 667) * 3;
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
  final GoRouter router = GoRouter(
    routes: <RouteBase>[
      GoRoute(path: '/', builder: (_, _) => const ContestPlanPage()),
      GoRoute(path: ZaveRoutes.contest, builder: (_, _) => const Text('path')),
      GoRoute(
        path: ZaveRoutes.planner,
        builder: (_, _) => const Text('planner'),
      ),
    ],
  );
  addTearDown(router.dispose);
  await tester.pumpWidget(
    ProviderScope(
      overrides: <Override>[
        contestRepositoryProvider.overrideWithValue(repository),
      ],
      child: MaterialApp.router(routerConfig: router),
    ),
  );
  await tester.pump();
  await tester.pump();
}

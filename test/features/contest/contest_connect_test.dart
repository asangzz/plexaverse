import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:plexaverse/core/plan/plan_refusal.dart';
import 'package:plexaverse/core/platform/link_opening.dart';
import 'package:plexaverse/core/router/zave_routes.dart';
import 'package:plexaverse/core/ui/zave/zave_kit.dart';
import 'package:plexaverse/features/contest/data/contest_repositories.dart';
import 'package:plexaverse/features/contest/domain/contest_repository.dart';
import 'package:plexaverse/features/engagement/data/engagement_repositories.dart';
import 'package:plexaverse/features/engagement/domain/engagement_repository.dart';
import 'package:plexaverse/features/engagement/presentation/pages/connections_page.dart';

/// "Connect with leaders" — the Connection Sprint opened from the contest.
///
/// The same cards as the ordinary page, but a different contract, and each
/// half of it is a way to lose a learner's work or their XP:
///   * the targets come from the CONTEST's route, never the plan-gated
///     `ai/connections` — on a Monday or Thursday an entrant pays nothing;
///   * Finish pays the contest task and NEVER credits the roadmap step;
///   * while today's earlier levels are open, the page says which comes
///     first and asks for no targets — every request sent would be refused
///     at Finish;
///   * Finish goes back to the path, which then shows the level done.
void main() {
  setUp(FakeContestWorld.reset);

  testWidgets('finish pays the contest task, never the roadmap step, and '
      'goes back to the path', (WidgetTester tester) async {
    final _Contest contest = _Contest(_path(PathNodeState.today));
    final _Engagement day = _Engagement(sent: 5);
    await _pump(tester, contest, day);

    expect(find.text('Connect with leaders'), findsOneWidget);
    expect(
      find.text(
        'Send each request with its note, then finish to collect your contest '
        'XP.',
      ),
      findsOneWidget,
    );
    expect(find.text('5 / 5 sent'), findsOneWidget);
    // One set a day: there is no new set to ask for in the contest.
    expect(find.text('New set'), findsNothing);

    await tester.tap(find.text('Finish and collect XP'));
    await tester.pumpAndSettle();

    expect(contest.completions, 1);
    expect(day.stepsCompleted, 0);
    expect(day.connectionsAsked, 0);
    expect(contest.targetReads, 1);
    expect(find.text('the path'), findsOneWidget);
  });

  testWidgets('finish waits for every note to be copied', (
    WidgetTester tester,
  ) async {
    final _Contest contest = _Contest(_path(PathNodeState.today));
    final _Engagement day = _Engagement(sent: 4);
    await _pump(tester, contest, day);

    expect(find.text('Send one more request to finish.'), findsOneWidget);
    await tester.tap(find.text('Finish and collect XP'));
    await tester.pump();
    expect(contest.completions, 0);
  });

  testWidgets(
    'a copied note is ticked on the day row the ordinary page reads',
    (WidgetTester tester) async {
      final List<String> clipboard = _captureClipboard(tester);
      final _Engagement day = _Engagement(sent: 0);
      await _pump(tester, _Contest(_path(PathNodeState.today)), day);

      // Clear of the header above and the finish bar below.
      final Finder copy = find.text('Copy & open LinkedIn').first;
      await tester.drag(find.byType(ListView), const Offset(0, -600));
      await tester.pump();
      await tester.tap(copy);
      for (int i = 0; i < 4; i++) {
        await tester.pump();
      }
      expect(clipboard, <String>['Hello — I would be glad to connect.']);
      expect(day.ticked, <String>['cn:0']);
      expect(find.text('1 / 5 sent'), findsOneWidget);
      // The card's "Copied" resets after two seconds.
      await tester.pump(const Duration(seconds: 3));
    },
  );

  testWidgets('locked: which level comes first, and no targets asked for', (
    WidgetTester tester,
  ) async {
    final _Contest contest = _Contest(
      _path(
        PathNodeState.locked,
        detail: 'Unlocks after Post 5 valuable comments',
      ),
    );
    final _Engagement day = _Engagement(sent: 5);
    await _pump(tester, contest, day);

    expect(
      find.text(
        'Unlocks after Post 5 valuable comments. Levels open one after '
        'another — finish it first.',
      ),
      findsOneWidget,
    );
    expect(contest.targetReads, 0);
    expect(day.connectionsAsked, 0);
    expect(find.text('Finish and collect XP'), findsNothing);
  });

  testWidgets('refused at the gate after all: the sentence and the way back', (
    WidgetTester tester,
  ) async {
    final _Contest contest = _Contest(
      _path(PathNodeState.today),
      refuse: const ContestLocked('Finish Post 5 valuable comments first.'),
    );
    await _pump(tester, contest, _Engagement(sent: 5));

    await tester.tap(find.text('Finish and collect XP'));
    await tester.pump();
    await tester.pump();
    expect(find.text('Finish Post 5 valuable comments first.'), findsOneWidget);
    expect(find.text('Back to the path'), findsOneWidget);
    // Still here: the learner's ticks are not thrown away.
    expect(find.text('5 / 5 sent'), findsOneWidget);
  });

  testWidgets('off a contest day the plan refuses, and the plan sheet opens', (
    WidgetTester tester,
  ) async {
    final _Contest contest = _Contest(
      _path(PathNodeState.today),
      targets: ContestPlanRefused(
        const PlanRefusal(
          kind: PlanRefusalKind.needsPlan,
          message: 'Finding people to connect with is part of a plan.',
        ),
      ),
    );
    await _pump(tester, contest, _Engagement(sent: 0));
    await tester.pumpAndSettle();

    // The card under it, and the sheet over it.
    expect(find.text('This is part of a plan'), findsOneWidget);
    expect(find.text('Needs a plan'), findsOneWidget);
    expect(find.text('See plans'), findsWidgets);
  });

  testWidgets('the back button returns to the contest', (
    WidgetTester tester,
  ) async {
    await _pump(
      tester,
      _Contest(_path(PathNodeState.today)),
      _Engagement(sent: 0),
    );
    await tester.tap(_iconButton('Back to the contest'));
    await tester.pumpAndSettle();
    expect(find.text('the path'), findsOneWidget);
  });

  testWidgets('the ordinary page leaves for the roadmap, not the contest', (
    WidgetTester tester,
  ) async {
    final _Contest contest = _Contest(_path(PathNodeState.today));
    final _Engagement day = _Engagement(sent: 0);
    await _pump(tester, contest, day, fromContest: false);

    expect(find.text('Finish and collect XP'), findsNothing);
    expect(contest.targetReads, 0);
    expect(day.connectionsAsked, 1);

    await tester.tap(_iconButton('Back to the roadmap'));
    await tester.pumpAndSettle();
    expect(find.text('the roadmap'), findsOneWidget);
  });
}

// ── Fixtures ────────────────────────────────────────────────────────────────

/// Records what reaches the clipboard, without a platform to put it on.
List<String> _captureClipboard(WidgetTester tester) {
  final List<String> writes = <String>[];
  tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
    SystemChannels.platform,
    (MethodCall call) async {
      if (call.method == 'Clipboard.setData') {
        writes.add((call.arguments as Map<Object?, Object?>)['text'] as String);
      }
      return null;
    },
  );
  addTearDown(
    () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      null,
    ),
  );
  return writes;
}

Finder _iconButton(String tooltip) => find.byWidgetPredicate(
  (Widget w) => w is ZaveIconButton && w.tooltip == tooltip,
);

final ConnectionBatch _batch = ConnectionBatch(
  profession: 'Product Manager',
  cached: true,
  connections: <ConnectionTarget>[
    for (int i = 0; i < 5; i++)
      const ConnectionTarget(
        role: 'Head of Product',
        company: 'Stripe',
        searchQuery: 'Head of Product Stripe',
        linkedinSearchUrl: 'https://www.linkedin.com/search/results/people/',
        note: 'Hello — I would be glad to connect.',
      ),
  ],
);

/// Today, a Monday, with its connect level in [state].
ContestPath _path(PathNodeState state, {String? detail}) => ContestPath(
  status: ContestPathStatus.running,
  dayNumber: 9,
  weekNumber: 2,
  days: <PathDay>[
    PathDay(
      dayNumber: 9,
      dayKey: '2026-11-09',
      weekday: 1,
      isToday: true,
      nodes: <PathNode>[
        PathNode(
          id: '2026-11-09:connect_leaders',
          kind: PathNodeKind.connectLeaders,
          state: state,
          title: 'Connect with leaders',
          points: 60,
          href: state == PathNodeState.today
              ? '/connections?from=contest'
              : null,
          detail: detail,
        ),
      ],
    ),
  ],
);

class _Contest extends FakeContestRepository {
  _Contest(this.path, {this.refuse, this.targets})
    : super(latency: Duration.zero);

  final ContestPath path;
  final ContestRefusal? refuse;

  /// A refusal of the targets, in place of the batch.
  final ContestRefusal? targets;
  int targetReads = 0;
  int completions = 0;

  @override
  Future<ContestPath> fetchPath() async => path;

  @override
  Future<ConnectionBatch> fetchConnectTargets() async {
    targetReads++;
    final ContestRefusal? no = targets;
    if (no != null) throw no;
    return _batch;
  }

  @override
  Future<ConnectTaskResult> completeConnect() async {
    final ContestRefusal? no = refuse;
    if (no != null) throw no;
    completions++;
    return const ConnectTaskResult(taskId: 'connect-1', pointsApplied: 60);
  }
}

/// The ordinary page's backend, recording what the contest page must and
/// must not touch.
class _Engagement implements EngagementRepository {
  _Engagement({required int sent})
    : _done = <String>[
        for (int i = 0; i < sent; i++) plexaItemId(PlexaLane.connections, i),
      ];

  final List<String> _done;
  final List<String> ticked = <String>[];
  int connectionsAsked = 0;
  int stepsCompleted = 0;

  @override
  Future<PlexaSession> fetchDaySession() async =>
      PlexaSession(connections: _done);

  @override
  Future<PlexaSession> setDayItemDone({
    required PlexaLane lane,
    required String itemId,
    bool done = true,
  }) async {
    ticked.add(itemId);
    return PlexaSession(connections: <String>[..._done, itemId]);
  }

  @override
  Future<ConnectionBatch> findConnections() async {
    connectionsAsked++;
    return _batch;
  }

  @override
  Future<void> completeStep({required int levelId, required int stepId}) async {
    stepsCompleted++;
  }

  @override
  Future<RoadmapProgress> fetchRoadmapProgress() async =>
      RoadmapProgress(currentDay: 12, roadmapStartedAt: DateTime.utc(2026, 11));

  @override
  Future<CommentBatch> generateComments({String? topic}) =>
      throw UnimplementedError();

  @override
  Future<void> teachStyle({required String text, String? topic}) async {}

  @override
  Future<TopVoiceDay> fetchTopVoices() => throw UnimplementedError();

  @override
  Future<bool> markTopVoiceActed(String shownId) async => false;
}

class _Opened implements LinkOpeningService {
  @override
  Future<LinkOpenResult> open(String url) async => const LinkOpened();
}

Future<void> _pump(
  WidgetTester tester,
  ContestRepository contest,
  EngagementRepository engagement, {
  bool fromContest = true,
}) async {
  tester.view.physicalSize = const Size(375, 667) * 3;
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
  final GoRouter router = GoRouter(
    initialLocation: ZaveRoutes.connections,
    routes: <RouteBase>[
      GoRoute(
        path: ZaveRoutes.connections,
        builder: (_, _) => ConnectionsPage(fromContest: fromContest),
      ),
      GoRoute(
        path: ZaveRoutes.contest,
        builder: (_, _) => const Text('the path'),
      ),
      GoRoute(
        path: ZaveRoutes.roadmap,
        builder: (_, _) => const Text('the roadmap'),
      ),
      GoRoute(
        path: ZaveRoutes.pricing,
        builder: (_, _) => const Text('pricing'),
      ),
      GoRoute(
        path: ZaveRoutes.settings,
        builder: (_, _) => const Text('settings'),
      ),
    ],
  );
  addTearDown(router.dispose);
  await tester.pumpWidget(
    ProviderScope(
      overrides: <Override>[
        contestRepositoryProvider.overrideWithValue(contest),
        engagementRepositoryProvider.overrideWithValue(engagement),
        linkOpeningProvider.overrideWithValue(_Opened()),
      ],
      child: MaterialApp.router(routerConfig: router),
    ),
  );
  for (int i = 0; i < 4; i++) {
    await tester.pump();
  }
}

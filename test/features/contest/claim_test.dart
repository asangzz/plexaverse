import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:plexaverse/core/router/zave_routes.dart';
import 'package:plexaverse/features/contest/application/claim_controllers.dart';
import 'package:plexaverse/features/contest/data/contest_repositories.dart';
import 'package:plexaverse/features/contest/domain/contest_repository.dart';
import 'package:plexaverse/features/contest/presentation/pages/contest_claim_page.dart';

/// The article's and the videos' post-link levels.
///
/// The level is named by the route's `kind` and `occurrence` and found in the
/// path's claims the way the server finds it. The occurrence is opaque and
/// goes back exactly as it came. A link that fails the server's own rule is
/// refused before it is sent; one that passes waits for our team, and the
/// page says so at once.
void main() {
  setUp(FakeContestWorld.reset);

  group('which claim a level is', () {
    test('matched on kind AND occurrence, from the path’s claims', () {
      final ContestPath path = _path(<PostClaim>[
        _claim(ClaimKind.video, '6:1:2', ClaimStatus.open),
        _claim(ClaimKind.video, '6:1:4', ClaimStatus.notReady),
        _claim(ClaimKind.article, '6:1', ClaimStatus.notReady),
      ]);
      expect(
        claimLevelOf(path, ClaimKind.video, '6:1:4').claim?.status,
        ClaimStatus.notReady,
      );
      expect(
        claimLevelOf(path, ClaimKind.article, '6:1').claim?.kind,
        ClaimKind.article,
      );
      // Same occurrence, other kind: not the same piece.
      expect(claimLevelOf(path, ClaimKind.article, '6:1:2').claim, isNull);
      expect(claimLevelOf(path, ClaimKind.unknown, '6:1:2').claim, isNull);
    });

    test('gated only by today’s node for that piece', () {
      final ContestPath locked = _path(
        <PostClaim>[_claim(ClaimKind.video, '6:1:2', ClaimStatus.open)],
        node: _node(
          '6:1:2',
          PathNodeState.locked,
          detail: 'Unlocks after Post 5 valuable comments',
        ),
      );
      expect(
        claimLevelOf(locked, ClaimKind.video, '6:1:2').lockedDetail,
        'Unlocks after Post 5 valuable comments',
      );
      // A late claim — its day has passed — is never gated.
      final ContestPath late = _path(<PostClaim>[
        _claim(ClaimKind.video, '6:1:2', ClaimStatus.open),
      ], node: _node('5:1:4', PathNodeState.locked, detail: 'x'));
      expect(claimLevelOf(late, ClaimKind.video, '6:1:2').lockedDetail, isNull);
    });
  });

  group('the page', () {
    testWidgets('a link that is not a post is refused before it is sent', (
      WidgetTester tester,
    ) async {
      final _Repo repo = _Repo(
        _path(<PostClaim>[_claim(ClaimKind.video, '6:1:2', ClaimStatus.open)]),
      );
      await _pump(tester, repo, kind: 'video', occurrence: '6:1:2');

      expect(find.text('LINKEDIN · POST LINK'), findsOneWidget);
      expect(find.text('Share your video’s link'), findsOneWidget);
      expect(find.text(kClaimsLine), findsOneWidget);
      expect(find.text('Goes out Wed 11 Nov'), findsOneWidget);
      expect(find.text('Share the link'), findsOneWidget);

      await _enter(tester, 'https://www.linkedin.com/in/someone/');
      await _submit(tester);
      expect(find.text(kNotAPostLinkLine), findsOneWidget);
      expect(repo.claims, isEmpty);

      // Editing the field takes the line away.
      await _enter(tester, 'https://www.linkedin.com/in/someone');
      expect(find.text(kNotAPostLinkLine), findsNothing);
    });

    testWidgets('a post link goes with the occurrence unchanged, and waits for '
        'our team at once', (WidgetTester tester) async {
      final _Repo repo = _Repo(
        _path(<PostClaim>[_claim(ClaimKind.video, '6:1:2', ClaimStatus.open)]),
      );
      await _pump(tester, repo, kind: 'video', occurrence: '6:1:2');
      final int reads = repo.pathReads;

      await _enter(
        tester,
        '  https://linkedin.com/posts/me_three-numbers-activity-7393/  ',
      );
      await _submit(tester);

      expect(repo.claims, <(ClaimKind, String, String)>[
        (
          ClaimKind.video,
          '6:1:2',
          'https://linkedin.com/posts/me_three-numbers-activity-7393/',
        ),
      ]);
      expect(find.text('Waiting for our team'), findsOneWidget);
      // The link as the server stored it, not as it was typed.
      expect(
        find.text(
          'https://www.linkedin.com/posts/me_three-numbers-activity-7393',
        ),
        findsOneWidget,
      );
      expect(find.text('Submit'), findsNothing);
      expect(find.text('Back to the path'), findsOneWidget);
      expect(repo.pathReads, greaterThan(reads));
      expect(tester.takeException(), isNull);
    });

    testWidgets('the server’s refusal is said in its words; the gate’s comes '
        'with the way back', (WidgetTester tester) async {
      final _Repo repo = _Repo(
        _path(<PostClaim>[_claim(ClaimKind.article, '6:1', ClaimStatus.open)]),
        refuse: const ContestLocked('Finish Post 5 valuable comments first.'),
      );
      await _pump(tester, repo, kind: 'article', occurrence: '6:1');
      expect(find.text('Share your article’s link'), findsOneWidget);

      await _enter(tester, 'https://www.linkedin.com/pulse/status-updates-me');
      await _submit(tester);
      expect(
        find.text('Finish Post 5 valuable comments first.'),
        findsOneWidget,
      );
      expect(find.text('Back to the path'), findsOneWidget);
      // Still claimable once the earlier level is done.
      expect(find.text('Submit'), findsOneWidget);
    });

    testWidgets('locked behind today’s earlier levels: no field', (
      WidgetTester tester,
    ) async {
      await _pump(
        tester,
        _Repo(
          _path(
            <PostClaim>[_claim(ClaimKind.video, '6:1:2', ClaimStatus.open)],
            node: _node(
              '6:1:2',
              PathNodeState.locked,
              detail: 'Unlocks after Post 5 valuable comments',
            ),
          ),
        ),
        kind: 'video',
        occurrence: '6:1:2',
      );
      expect(
        find.text(
          'Unlocks after Post 5 valuable comments. Finish it on the path, then '
          'come back here.',
        ),
        findsOneWidget,
      );
      expect(find.text('Submit'), findsNothing);
    });

    testWidgets('before its day: when it opens, read as a calendar date', (
      WidgetTester tester,
    ) async {
      await _pump(
        tester,
        _Repo(
          _path(<PostClaim>[
            _claim(
              ClaimKind.article,
              '6:1',
              ClaimStatus.notReady,
              day: '2026-11-12',
            ),
          ]),
        ),
        kind: 'article',
        occurrence: '6:1',
      );
      expect(find.text('Not open yet'), findsOneWidget);
      expect(
        find.text(
          'You can share its link from Thu 12 Nov, the day it goes out.',
        ),
        findsOneWidget,
      );
      expect(find.text('Submit'), findsNothing);
    });

    testWidgets('rejected: the reason, and the link can be sent again', (
      WidgetTester tester,
    ) async {
      await _pump(
        tester,
        _Repo(
          _path(<PostClaim>[
            _claim(
              ClaimKind.video,
              '5:1:4',
              ClaimStatus.rejected,
              rejectReason: 'The link opens a different post.',
            ),
          ]),
        ),
        kind: 'video',
        occurrence: '5:1:4',
      );
      expect(find.text('Not approved'), findsOneWidget);
      expect(
        find.text(
          'The link opens a different post. Send the right link below.',
        ),
        findsOneWidget,
      );
      expect(find.text('Submit'), findsOneWidget);
    });

    testWidgets('a piece the path does not list, or a kind this build cannot '
        'name, opens nothing', (WidgetTester tester) async {
      await _pump(
        tester,
        _Repo(
          _path(<PostClaim>[
            _claim(ClaimKind.video, '6:1:2', ClaimStatus.open),
          ]),
        ),
        kind: 'poll',
        occurrence: '6:1:2',
      );
      expect(
        find.text(
          'This piece is not open to claim. Check the week card on the path '
          'for what is.',
        ),
        findsOneWidget,
      );
    });

    testWidgets('the mock flavor’s Wednesday video renders', (
      WidgetTester tester,
    ) async {
      final FakeContestRepository fake = FakeContestRepository(
        latency: Duration.zero,
      );
      final PostClaim open = (await fake.fetchPath()).claims.firstWhere(
        (PostClaim c) => c.status == ClaimStatus.open,
      );
      await _pump(
        tester,
        fake,
        kind: open.kind.wire,
        occurrence: open.occurrence,
      );
      expect(find.text(open.title), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}

// ── Fixtures ────────────────────────────────────────────────────────────────

PostClaim _claim(
  ClaimKind kind,
  String occurrence,
  ClaimStatus status, {
  String day = '2026-11-11',
  String? rejectReason,
}) => PostClaim(
  kind: kind,
  occurrence: occurrence,
  title: kind == ClaimKind.article
      ? 'Why your status update should start with the decision'
      : 'Three numbers I check before every client call',
  postingDayKey: day,
  opensOnKey: day,
  status: status,
  points: kind == ClaimKind.article ? 70 : 40,
  rejectReason: rejectReason,
);

PathNode _node(String occurrence, PathNodeState state, {String? detail}) =>
    PathNode(
      id: '2026-11-11:video:$occurrence',
      kind: PathNodeKind.video,
      state: state,
      title: 'Share your video’s link',
      points: 40,
      detail: detail,
      claim: NodeClaim(kind: ClaimKind.video, occurrence: occurrence),
    );

ContestPath _path(List<PostClaim> claims, {PathNode? node}) => ContestPath(
  status: ContestPathStatus.running,
  dayNumber: 11,
  weekNumber: 2,
  days: <PathDay>[
    PathDay(
      dayNumber: 11,
      dayKey: '2026-11-11',
      weekday: 3,
      isToday: true,
      nodes: <PathNode>[?node],
    ),
  ],
  claims: claims,
);

class _Repo extends FakeContestRepository {
  _Repo(this.path, {this.refuse}) : super(latency: Duration.zero);

  final ContestPath path;
  final ContestRefusal? refuse;
  final List<(ClaimKind, String, String)> claims =
      <(ClaimKind, String, String)>[];
  int pathReads = 0;

  @override
  Future<ContestPath> fetchPath() async {
    pathReads++;
    return path;
  }

  @override
  Future<ClaimResult> claimPostLink({
    required ClaimKind kind,
    required String occurrence,
    required String postUrl,
  }) async {
    final ContestRefusal? no = refuse;
    if (no != null) throw no;
    claims.add((kind, occurrence, postUrl));
    final PostClaim listed = path.claimFor(kind, occurrence)!;
    return ClaimResult(
      taskId: 'claim-1',
      claim: listed.copyWith(
        status: ClaimStatus.pending,
        postUrl:
            'https://www.linkedin.com/posts/me_three-numbers-activity-7393',
      ),
    );
  }
}

Future<void> _enter(WidgetTester tester, String text) async {
  await tester.ensureVisible(find.byType(TextField));
  await tester.enterText(find.byType(TextField), text);
  await tester.pump();
}

Future<void> _submit(WidgetTester tester) async {
  await tester.ensureVisible(find.text('Submit'));
  await tester.tap(find.text('Submit'));
  await tester.pump();
  await tester.pump();
}

Future<void> _pump(
  WidgetTester tester,
  ContestRepository repository, {
  required String kind,
  required String occurrence,
}) async {
  tester.view.physicalSize = const Size(375, 667) * 3;
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
  final GoRouter router = GoRouter(
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (_, _) => ContestClaimPage(kind: kind, occurrence: occurrence),
      ),
      GoRoute(path: ZaveRoutes.contest, builder: (_, _) => const Text('path')),
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

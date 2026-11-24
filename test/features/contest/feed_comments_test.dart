import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:plexaverse/core/router/zave_routes.dart';
import 'package:plexaverse/features/contest/application/contest_controllers.dart';
import 'package:plexaverse/features/contest/application/feed_comments_controllers.dart';
import 'package:plexaverse/features/contest/data/contest_repositories.dart';
import 'package:plexaverse/features/contest/domain/contest_links.dart';
import 'package:plexaverse/features/contest/domain/contest_repository.dart';
import 'package:plexaverse/features/contest/presentation/pages/contest_feed_comments_page.dart';
import 'package:plexaverse/features/contest/presentation/widgets/feed/feed_words.dart';

/// "Post 5 valuable comments".
///
/// What this pins:
///
///  - **The inline check is the server's.** A link is flagged in its field —
///    empty, not a comment link, or one already sent today however it is
///    spelt — in the web's words, and a link the check refuses is never sent.
///  - **One at a time.** After each send the field moves to the next comment
///    and says what the last one paid.
///  - **The warning comes before the button**, with the real penalty, and no
///    "0 more" threat when there is none.
void main() {
  const String first =
      'https://www.linkedin.com/feed/update/urn:li:activity:7394000000000000001/';
  // The same post as [first], spelt the other way LinkedIn spells it.
  const String firstAgain =
      'https://linkedin.com/posts/meera-iyer_status-activity-7394000000000000001-abcd';
  const String second = 'https://lnkd.in/p/AbCd123';

  const FeedCommentsView fresh = FeedCommentsView(
    status: FeedCommentsStatus.open,
    points: 100,
    shares: <int>[20, 20, 20, 20, 20],
    penalty: 50,
    linkPoints: <int>[],
    pointsApplied: 0,
  );

  ContestPath pathWith(PathNodeState state, {String? detail}) => ContestPath(
    status: ContestPathStatus.running,
    days: <PathDay>[
      PathDay(
        dayNumber: 11,
        dayKey: '2026-11-11',
        weekday: 3,
        isToday: true,
        nodes: <PathNode>[
          PathNode(
            id: '2026-11-11:feed_comments',
            kind: PathNodeKind.feedComments,
            state: state,
            title: 'Post 5 valuable comments',
            points: 100,
            detail: detail,
          ),
        ],
      ),
    ],
  );

  group('the words', () {
    test('the warning names the real penalty, and drops the clause at 0', () {
      expect(
        feedWarningLine(50),
        'We check these. A link that isn’t your comment, or a comment that isn’t genuine, is a false claim: the XP is taken back and 50 more is deducted.',
      );
      expect(
        feedWarningLine(1200),
        endsWith('the XP is taken back and 1,200 more is deducted.'),
      );
      expect(
        feedWarningLine(0),
        'We check these. A link that isn’t your comment, or a comment that isn’t genuine, is a false claim: the XP is taken back.',
      );
    });

    test(
      'the shares line: even, uneven (the fifth carries the rest), none',
      () {
        expect(feedSharesLine(fresh), '+20 XP each, 100 for all 5');
        expect(
          feedSharesLine(
            const FeedCommentsView(
              points: 101,
              shares: <int>[20, 20, 20, 20, 21],
            ),
          ),
          '+20 XP each (the fifth +21), 101 for all 5',
        );
        expect(
          feedSharesLine(const FeedCommentsView(shares: <int>[0, 0, 0, 0, 0])),
          '',
        );
      },
    );

    test('a problem reads as the web’s line', () {
      expect(
        feedProblemText(FeedCommentLinkProblem.empty),
        'Paste the link to this comment.',
      );
      expect(
        feedProblemText(FeedCommentLinkProblem.bad),
        'That is not a link to a comment on a LinkedIn post. Use Copy link to comment.',
      );
      expect(
        feedProblemText(FeedCommentLinkProblem.duplicate),
        'You already sent this comment today. Each comment counts once.',
      );
    });

    test('the last send moves the read on until the re-read catches up', () {
      const FeedCommentSubmitResult sent = FeedCommentSubmitResult(
        n: 2,
        pointsApplied: 20,
        dayPoints: 40,
        links: <String>[first, second],
      );
      final FeedCommentsNow ahead = effectiveFeed(
        fresh.copyWith(links: <String>[first], linkPoints: <int>[20]),
        sent,
      );
      expect(ahead.links, <String>[first, second]);
      expect(ahead.linkPoints, <int>[20, 20]);
      expect(ahead.pointsApplied, 40);

      final FeedCommentsNow caughtUp = effectiveFeed(
        fresh.copyWith(
          links: <String>[first, second],
          linkPoints: <int>[20, 20],
          pointsApplied: 40,
        ),
        sent,
      );
      expect(caughtUp.links, <String>[first, second]);

      final FeedCommentsNow revoked = effectiveFeed(
        fresh.copyWith(status: FeedCommentsStatus.revoked),
        sent,
      );
      expect(revoked.links, isEmpty, reason: 'a removed day is the read’s');
    });
  });

  group('sending', () {
    Future<(ProviderContainer, _FeedRepo)> ready(FeedCommentsView view) async {
      TestWidgetsFlutterBinding.ensureInitialized();
      final _FeedRepo repo = _FeedRepo(view);
      final ProviderContainer c = ProviderContainer(
        overrides: <Override>[
          contestRepositoryProvider.overrideWithValue(repo),
        ],
      );
      addTearDown(c.dispose);
      c.listen(feedCommentsProvider, (_, _) {});
      c.listen(feedCommentsActionsProvider, (_, _) {});
      await c.read(feedCommentsProvider.future);
      return (c, repo);
    }

    test('a link the check refuses is never sent — not empty, not a bad '
        'link, not today’s comment spelt another way', () async {
      final (ProviderContainer c, _FeedRepo repo) = await ready(
        fresh.copyWith(links: <String>[first], linkPoints: <int>[20]),
      );
      final FeedCommentsActions send = c.read(
        feedCommentsActionsProvider.notifier,
      );
      expect(await send.send('   '), isFalse);
      expect(
        await send.send('https://www.linkedin.com/in/meera-iyer'),
        isFalse,
      );
      expect(await send.send(firstAgain), isFalse);
      expect(repo.sent, isEmpty);

      expect(await send.send('  $second  '), isTrue);
      expect(repo.sent, <String>[second], reason: 'trimmed, as the web sends');
      expect(c.read(feedCommentsActionsProvider).last?.n, 2);
    });

    test(
      'the server’s refusal is kept in its words; typing clears it',
      () async {
        final (ProviderContainer c, _FeedRepo repo) = await ready(fresh);
        repo.refuse = const ContestDuplicateUrl(
          'This comment was already shared on 2026-11-09.',
        );
        final FeedCommentsActions send = c.read(
          feedCommentsActionsProvider.notifier,
        );
        expect(await send.send(first), isFalse);
        expect(
          c.read(feedCommentsActionsProvider).error,
          'This comment was already shared on 2026-11-09.',
        );
        send.clearError();
        expect(c.read(feedCommentsActionsProvider).error, isNull);
      },
    );
  });

  group('the page', () {
    Future<_FeedRepo> pump(
      WidgetTester tester,
      FeedCommentsView view, {
      ContestPath? path,
    }) async {
      tester.view.physicalSize = const Size(375, 667) * 3;
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);
      final _FeedRepo repo = _FeedRepo(view);
      final GoRouter router = GoRouter(
        initialLocation: ZaveRoutes.contestFeedComments,
        routes: <RouteBase>[
          GoRoute(
            path: ZaveRoutes.contest,
            builder: (_, _) => const Text('the path'),
          ),
          GoRoute(
            path: ZaveRoutes.contestFeedComments,
            builder: (_, _) => const ContestFeedCommentsPage(),
          ),
        ],
      );
      addTearDown(router.dispose);
      await tester.pumpWidget(
        ProviderScope(
          overrides: <Override>[
            contestRepositoryProvider.overrideWithValue(repo),
            contestPathProvider.overrideWith(
              (Ref ref) async => path ?? pathWith(PathNodeState.today),
            ),
          ],
          child: MaterialApp.router(
            routerConfig: router,
            builder: (BuildContext context, Widget? child) => MediaQuery(
              data: MediaQuery.of(context).copyWith(disableAnimations: true),
              child: child!,
            ),
          ),
        ),
      );
      await settle(tester);
      return repo;
    }

    Future<void> enter(WidgetTester tester, String link) async {
      final Finder field = find.byType(TextField);
      await tester.ensureVisible(field);
      await tester.enterText(field, link);
      await settle(tester);
    }

    Future<void> sendIt(WidgetTester tester, String label) async {
      final Finder pill = find.bySemanticsLabel(label);
      await tester.ensureVisible(pill);
      await tester.tap(pill);
      await settle(tester);
    }

    testWidgets('the header, the feed link, and the warning BEFORE the '
        'button', (WidgetTester tester) async {
      await pump(tester, fresh);
      expect(find.text('Post 5 valuable comments'), findsOneWidget);
      expect(find.bySemanticsLabel('+100 XP'), findsWidgets);
      expect(find.bySemanticsLabel('Open your LinkedIn feed'), findsOneWidget);
      expect(find.text('Your 5 comments, one at a time'), findsOneWidget);
      expect(find.text(kFeedHowLine), findsOneWidget);
      expect(find.text('+20 XP each, 100 for all 5'), findsOneWidget);
      expect(find.text('Comment 1 of 5'), findsOneWidget);

      final Finder warning = find.text(feedWarningLine(50));
      final Finder button = find.bySemanticsLabel('Send comment 1');
      expect(warning, findsOneWidget);
      expect(
        tester.getTopLeft(warning).dy,
        lessThan(tester.getTopLeft(button).dy),
        reason: 'the rule is read before anything can be sent',
      );
      expect(find.text('Why every day'), findsOneWidget);
      expect(find.text('What counts as valuable'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('inline validation, in the web’s words: empty, bad, and a '
        'duplicate of today’s — none of them sent', (
      WidgetTester tester,
    ) async {
      final _FeedRepo repo = await pump(
        tester,
        fresh.copyWith(links: <String>[first], linkPoints: <int>[20]),
      );
      expect(find.text('Comment 2 of 5'), findsOneWidget);
      expect(find.text('Sent today · 1 of 5'), findsOneWidget);

      await sendIt(tester, 'Send comment 2');
      expect(find.text('Paste the link to this comment.'), findsOneWidget);

      await enter(tester, 'https://in.linkedin.com/posts/x-activity-2-y');
      expect(
        find.text(
          'That is not a link to a comment on a LinkedIn post. Use Copy link to comment.',
        ),
        findsOneWidget,
      );

      await enter(tester, firstAgain);
      expect(
        find.text(
          'You already sent this comment today. Each comment counts once.',
        ),
        findsOneWidget,
      );
      await sendIt(tester, 'Send comment 2');
      expect(repo.sent, isEmpty);
      expect(tester.takeException(), isNull);
    });

    testWidgets('a good link is sent, the field clears and moves on, and the '
        'last send says what it paid', (WidgetTester tester) async {
      final _FeedRepo repo = await pump(tester, fresh);
      await enter(tester, first);
      await sendIt(tester, 'Send comment 1');
      await settle(tester);

      expect(repo.sent, <String>[first]);
      expect(
        find.text('Comment 1 sent · +20 XP. Now comment 2.'),
        findsOneWidget,
      );
      expect(find.text('Comment 2 of 5'), findsOneWidget);
      expect(find.text('Sent today · 1 of 5'), findsOneWidget);
      final TextField field = tester.widget(find.byType(TextField));
      expect(field.controller?.text, isEmpty);
    });

    testWidgets('a refusal the server still makes shows under the field', (
      WidgetTester tester,
    ) async {
      final _FeedRepo repo = await pump(tester, fresh);
      repo.refuse = const ContestDuplicateUrl(
        'This comment was already shared on 2026-11-09. Each comment counts once.',
      );
      await enter(tester, first);
      await sendIt(tester, 'Send comment 1');
      expect(
        find.text(
          'This comment was already shared on 2026-11-09. Each comment counts once.',
        ),
        findsOneWidget,
      );
    });

    testWidgets('no penalty set: no “0 more” threat', (
      WidgetTester tester,
    ) async {
      await pump(tester, fresh.copyWith(penalty: 0));
      expect(find.text(feedWarningLine(0)), findsOneWidget);
      expect(find.textContaining('0 more is deducted'), findsNothing);
    });

    testWidgets('locked: “Not open yet” in place of the form', (
      WidgetTester tester,
    ) async {
      await pump(
        tester,
        fresh,
        path: pathWith(
          PathNodeState.locked,
          detail: 'Unlocks after Comment on a top voice',
        ),
      );
      expect(find.text('Not open yet'), findsOneWidget);
      expect(
        find.text(
          'Unlocks after Comment on a top voice. Levels open one after another — finish or skip it first.',
        ),
        findsOneWidget,
      );
      expect(find.byType(TextField), findsNothing);
      expect(find.bySemanticsLabel('Open your LinkedIn feed'), findsNothing);
    });

    testWidgets('done: in, paid, and the way on', (WidgetTester tester) async {
      await pump(
        tester,
        fresh.copyWith(
          status: FeedCommentsStatus.done,
          links: <String>[first, second, '$second-3', '$second-4', '$second-5'],
          linkPoints: <int>[20, 20, 20, 20, 20],
          pointsApplied: 100,
        ),
        path: pathWith(PathNodeState.done, detail: '5 of 5 posted'),
      );
      expect(find.text('Today’s comments are in'), findsOneWidget);
      expect(
        find.text('Five new comments count on each day of the levels.'),
        findsOneWidget,
      );
      expect(find.byType(TextField), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets('revoked: removed after review, the reason and what it took', (
      WidgetTester tester,
    ) async {
      await pump(
        tester,
        fresh.copyWith(
          status: FeedCommentsStatus.revoked,
          links: <String>[first],
          revokeReason: 'Two of the links were the same comment',
          pointsDeducted: 110,
          pointsApplied: 0,
        ),
        path: pathWith(PathNodeState.revoked),
      );
      expect(find.text('Removed after review'), findsOneWidget);
      expect(
        find.text('Removed: Two of the links were the same comment — −110 XP'),
        findsOneWidget,
      );
      expect(
        find.text('Your other days count as usual. Think we got it wrong?'),
        findsOneWidget,
      );
      // The web's appeal line: the removed claims and appeals page.
      expect(find.bySemanticsLabel('Appeal the decision'), findsOneWidget);
      expect(find.byType(TextField), findsNothing);
    });

    testWidgets('the mock flavor’s running contest renders, locked behind '
        'the comment level', (WidgetTester tester) async {
      FakeContestWorld.reset();
      addTearDown(FakeContestWorld.reset);
      tester.view.physicalSize = const Size(375, 667) * 3;
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);
      final GoRouter router = GoRouter(
        initialLocation: ZaveRoutes.contestFeedComments,
        routes: <RouteBase>[
          GoRoute(
            path: ZaveRoutes.contestFeedComments,
            builder: (_, _) => const ContestFeedCommentsPage(),
          ),
        ],
      );
      addTearDown(router.dispose);
      await tester.pumpWidget(
        ProviderScope(
          overrides: <Override>[
            contestRepositoryProvider.overrideWithValue(
              FakeContestRepository(latency: Duration.zero),
            ),
          ],
          child: MaterialApp.router(routerConfig: router),
        ),
      );
      for (int i = 0; i < 5; i++) {
        await settle(tester);
      }
      expect(find.text('Post 5 valuable comments'), findsOneWidget);
      expect(find.text('Not open yet'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}

/// Lets the reads land. Each hop — the path, the gate, the level, the frame —
/// is a microtask or a zero-length timer, and a bare `pump()` advances no
/// time, so it runs none of the timers.
Future<void> settle(WidgetTester tester) async {
  for (int i = 0; i < 8; i++) {
    await tester.pump(Duration.zero);
  }
}

/// Plays the server for the feed-comments task: one view, and a send that
/// takes any link the inline check would and pays a fifth of the hundred.
class _FeedRepo implements ContestRepository {
  _FeedRepo(this.view);

  FeedCommentsView view;
  ContestRefusal? refuse;
  final List<String> sent = <String>[];

  @override
  Future<FeedCommentsView> fetchFeedComments() async => view;

  @override
  Future<FeedCommentSubmitResult> submitFeedComment(String link) async {
    if (refuse case final ContestRefusal no) throw no;
    sent.add(link);
    final List<String> links = <String>[...view.links, link];
    view = view.copyWith(
      links: links,
      linkPoints: <int>[...?view.linkPoints, 20],
      pointsApplied: (view.pointsApplied ?? 0) + 20,
      status: links.length >= 5
          ? FeedCommentsStatus.done
          : FeedCommentsStatus.open,
    );
    return FeedCommentSubmitResult(
      taskId: 'feed',
      status: links.length >= 5
          ? FeedCommentSubmitStatus.done
          : FeedCommentSubmitStatus.open,
      n: links.length,
      pointsApplied: 20,
      dayPoints: view.pointsApplied ?? 0,
      links: links,
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('${invocation.memberName}');
}

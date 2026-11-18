import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:plexaverse/core/platform/link_opening.dart';
import 'package:plexaverse/core/router/zave_routes.dart';
import 'package:plexaverse/features/contest/application/comment_level_controllers.dart';
import 'package:plexaverse/features/contest/application/contest_controllers.dart';
import 'package:plexaverse/features/contest/data/contest_repositories.dart';
import 'package:plexaverse/features/contest/domain/contest_repository.dart';
import 'package:plexaverse/features/contest/presentation/pages/contest_comment_page.dart';
import 'package:plexaverse/features/contest/presentation/widgets/comment/comment_words.dart';

/// The daily comment level.
///
/// The three rules this file exists for:
///
///  - **No read while locked.** The level's GET writes the day's row and may
///    spend a model call, and the server does not gate it. So the app asks
///    the path first and does not call it while the path shows the level
///    locked — or before the path has answered at all.
///  - **The first try is the one that pays**, and the page says so in the
///    web's words: after a miss the day's XP is gone, and the right picks are
///    kept for the retry.
///  - **The post opens only on LinkedIn, over https**, and only after the
///    comment is on the clipboard.
void main() {
  const String template =
      'This is the {{1}} I needed. Leading with the {{2}} cut our questions, and the {{3}} land faster.';
  const List<String> bank = <String>[
    'decision',
    'remainder',
    'approvals',
    'reminder',
    'approves',
    'decisive',
  ];
  const List<String> answers = <String>['reminder', 'decision', 'approvals'];
  const String finished = _finished;
  const CommentPost post = CommentPost(
    author: 'Meera Iyer',
    firstLine: 'Most status updates bury the one decision.',
  );

  CommentLevelView open({CommentFirstTry firstTry = CommentFirstTry.none}) =>
      CommentLevelView(
        status: CommentLevelStatus.open,
        post: post,
        template: template,
        blankCount: 3,
        bank: bank,
        firstTry: firstTry,
        pointsApplied: 0,
      );

  CommentLevelView done({
    String? postUrl =
        'https://www.linkedin.com/posts/meera-iyer_status-activity-7394000000000000000-abcd',
    CommentFirstTry firstTry = CommentFirstTry.right,
    int paid = 40,
  }) => CommentLevelView(
    status: CommentLevelStatus.done,
    post: post.copyWith(postUrl: postUrl),
    template: template,
    blankCount: 3,
    bank: bank,
    firstTry: firstTry,
    answers: answers,
    comment: finished,
    pointsApplied: paid,
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
            id: '2026-11-11:comment',
            kind: PathNodeKind.comment,
            state: state,
            title: 'Comment on a top voice',
            points: 40,
            detail: detail,
          ),
        ],
      ),
    ],
  );

  final ContestPath lockedPath = pathWith(
    PathNodeState.locked,
    detail: 'Unlocks after Lesson part 3 of 3',
  );
  final ContestPath openPath = pathWith(PathNodeState.today);

  group('the gate comes before the read', () {
    test('a level the path shows locked is never read', () async {
      final _Repo repo = _Repo(levels: <CommentLevelView>[open()]);
      final ProviderContainer container = ProviderContainer(
        overrides: <Override>[
          contestRepositoryProvider.overrideWithValue(repo),
          contestPathProvider.overrideWith((Ref ref) async => lockedPath),
        ],
      );
      addTearDown(container.dispose);
      container.listen(commentLevelControllerProvider, (_, _) {});
      await container.read(contestPathProvider.future);
      final CommentLevelState state = await container.read(
        commentLevelControllerProvider.future,
      );
      expect(state, isA<CommentLevelLocked>());
      expect(
        (state as CommentLevelLocked).detail,
        'Unlocks after Lesson part 3 of 3',
      );
      expect(repo.reads, 0, reason: 'the GET writes and may spend a call');
    });

    test('nothing is read until the path answers', () async {
      final _Repo repo = _Repo(levels: <CommentLevelView>[open()]);
      final Completer<ContestPath> path = Completer<ContestPath>();
      final ProviderContainer container = ProviderContainer(
        overrides: <Override>[
          contestRepositoryProvider.overrideWithValue(repo),
          contestPathProvider.overrideWith((Ref ref) => path.future),
        ],
      );
      addTearDown(container.dispose);
      container.listen(commentLevelControllerProvider, (_, _) {});
      expect(
        await container.read(commentLevelControllerProvider.future),
        isA<CommentLevelWaiting>(),
      );
      expect(repo.reads, 0);

      path.complete(openPath);
      await container.read(contestPathProvider.future);
      final CommentLevelState state = await container.read(
        commentLevelControllerProvider.future,
      );
      expect(state, isA<CommentLevelReady>());
      expect(repo.reads, 1);
    });

    test('a path that failed is no gate: the level is read and the '
        'answer’s LOCKED still holds', () async {
      final _Repo repo = _Repo(levels: <CommentLevelView>[open()]);
      final ProviderContainer container = ProviderContainer(
        retry: (_, _) => null,
        overrides: <Override>[
          contestRepositoryProvider.overrideWithValue(repo),
          contestPathProvider.overrideWith(
            (Ref ref) => Future<ContestPath>.error(const ContestUnavailable()),
          ),
        ],
      );
      addTearDown(container.dispose);
      container.listen(commentLevelControllerProvider, (_, _) {});
      await expectLater(
        container.read(contestPathProvider.future),
        throwsA(isA<ContestUnavailable>()),
      );
      expect(
        await container.read(commentLevelControllerProvider.future),
        isA<CommentLevelReady>(),
      );
      expect(repo.reads, 1);
    });

    test('the mock flavor’s running contest (comment locked behind the '
        'lesson) opens no comment level either', () async {
      FakeContestWorld.reset();
      addTearDown(FakeContestWorld.reset);
      final _CountingFake repo = _CountingFake();
      final ProviderContainer container = ProviderContainer(
        overrides: <Override>[
          contestRepositoryProvider.overrideWithValue(repo),
        ],
      );
      addTearDown(container.dispose);
      container.listen(commentLevelControllerProvider, (_, _) {});
      await container.read(contestPathProvider.future);
      expect(
        await container.read(commentLevelControllerProvider.future),
        isA<CommentLevelLocked>(),
      );
      expect(repo.reads, 0);
    });

    testWidgets('while another request writes the comment it asks again '
        'every 3 s, and stops when the page goes', (WidgetTester tester) async {
      const CommentLevelView writing = CommentLevelView(
        reason: CommentLevelReason.writing,
      );
      final _Repo repo = _Repo(
        levels: <CommentLevelView>[writing, writing, writing],
      );
      final ProviderContainer container = ProviderContainer(
        overrides: <Override>[
          contestRepositoryProvider.overrideWithValue(repo),
          contestPathProvider.overrideWith((Ref ref) async => openPath),
        ],
      );
      final ProviderSubscription<AsyncValue<CommentLevelState>> sub = container
          .listen(commentLevelControllerProvider, (_, _) {});
      await settle(tester);
      expect(repo.reads, 1);

      await tester.pump(kCommentWritingPoll - const Duration(milliseconds: 1));
      expect(repo.reads, 1, reason: 'not before the interval');
      await tester.pump(const Duration(milliseconds: 1));
      await settle(tester);
      expect(repo.reads, 2);

      // Leaving the page disposes the read, and its timer with it.
      sub.close();
      container.dispose();
      await tester.pump(kCommentWritingPoll * 3);
      expect(repo.reads, 2);
    });
  });

  group('the player', () {
    Future<ProviderContainer> ready(_Repo repo) async {
      final ProviderContainer container = ProviderContainer(
        overrides: <Override>[
          contestRepositoryProvider.overrideWithValue(repo),
          contestPathProvider.overrideWith((Ref ref) async => openPath),
        ],
      );
      addTearDown(container.dispose);
      container.listen(commentLevelControllerProvider, (_, _) {});
      container.listen(commentLevelActionsProvider, (_, _) {});
      await container.read(contestPathProvider.future);
      await container.read(commentLevelControllerProvider.future);
      return container;
    }

    test('words go into the blanks left to right, a filled blank gives its '
        'word back, and a used word cannot be placed twice', () async {
      final ProviderContainer c = await ready(
        _Repo(levels: <CommentLevelView>[open()]),
      );
      final CommentLevelActions play = c.read(
        commentLevelActionsProvider.notifier,
      );
      play.place(3);
      play.place(3);
      play.place(0);
      expect(c.read(commentLevelActionsProvider).slots, <int?>[3, 0, null]);
      play.takeBack(0);
      play.place(2);
      expect(c.read(commentLevelActionsProvider).slots, <int?>[2, 0, null]);
      expect(c.read(commentLevelActionsProvider).full, isFalse);
    });

    test('a miss sends the whole sequence, keeps the right picks and clears '
        'the wrong ones on Try again', () async {
      final _Repo repo = _Repo(levels: <CommentLevelView>[open()]);
      final ProviderContainer c = await ready(repo);
      final CommentLevelActions play = c.read(
        commentLevelActionsProvider.notifier,
      );
      // reminder, remainder (wrong), approvals.
      play
        ..place(3)
        ..place(1)
        ..place(2);
      await play.check();
      expect(repo.submitted.single, <String>[
        'reminder',
        'remainder',
        'approvals',
      ]);
      final CommentPlay missed = c.read(commentLevelActionsProvider);
      expect(missed.graded?.correct, isFalse);
      expect(missed.frozen, isTrue);
      play.place(0);
      expect(
        c.read(commentLevelActionsProvider).slots,
        <int?>[3, 1, 2],
        reason: 'nothing moves while the verdict is up',
      );

      play.tryAgain();
      expect(c.read(commentLevelActionsProvider).slots, <int?>[3, null, 2]);
      // The level now knows the first try missed.
      final CommentLevelState level = c
          .read(commentLevelControllerProvider)
          .requireValue;
      expect(
        (level as CommentLevelReady).level.firstTry,
        CommentFirstTry.wrong,
      );
    });

    test('a right answer lands as the finished level at once', () async {
      final _Repo repo = _Repo(levels: <CommentLevelView>[open()]);
      final ProviderContainer c = await ready(repo);
      final CommentLevelActions play = c.read(
        commentLevelActionsProvider.notifier,
      );
      play
        ..place(3)
        ..place(0)
        ..place(2);
      await play.check();
      final CommentLevelState level = c
          .read(commentLevelControllerProvider)
          .requireValue;
      expect(
        (level as CommentLevelReady).level.status,
        CommentLevelStatus.done,
      );
      expect(level.level.comment, finished);
      expect(c.read(commentLevelActionsProvider).graded, isNull);
    });

    test('a refusal is said in the server’s words, and LOCKED re-reads the '
        'path', () async {
      int pathReads = 0;
      final _Repo repo = _Repo(
        levels: <CommentLevelView>[open()],
        refuse: const ContestLocked('Finish Lesson part 3 of 3 first.'),
      );
      final ProviderContainer c = ProviderContainer(
        overrides: <Override>[
          contestRepositoryProvider.overrideWithValue(repo),
          contestPathProvider.overrideWith((Ref ref) async {
            pathReads++;
            return openPath;
          }),
        ],
      );
      addTearDown(c.dispose);
      c.listen(commentLevelControllerProvider, (_, _) {});
      c.listen(commentLevelActionsProvider, (_, _) {});
      await c.read(contestPathProvider.future);
      await c.read(commentLevelControllerProvider.future);
      final CommentLevelActions play = c.read(
        commentLevelActionsProvider.notifier,
      );
      play
        ..place(3)
        ..place(0)
        ..place(2);
      await play.check();
      expect(
        c.read(commentLevelActionsProvider).error,
        'Finish Lesson part 3 of 3 first.',
      );
      await c.read(contestPathProvider.future);
      expect(pathReads, 2);
    });
  });

  group('Comment on LinkedIn', () {
    late List<String> clipboard;
    late List<String> order;
    bool refuseCopy = false;

    setUp(() {
      clipboard = <String>[];
      order = <String>[];
      refuseCopy = false;
      TestWidgetsFlutterBinding.ensureInitialized();
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemChannels.platform, (
            MethodCall call,
          ) async {
            if (call.method == 'Clipboard.setData') {
              if (refuseCopy) throw PlatformException(code: 'refused');
              clipboard.add(
                (call.arguments as Map<Object?, Object?>)['text'] as String,
              );
              order.add('copy');
            }
            return null;
          });
    });

    tearDown(
      () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemChannels.platform, null),
    );

    Future<(CommentHandOff, _Opener)> handOff(
      String? postUrl, {
      LinkOpenResult result = const LinkOpened(),
    }) async {
      final _Opener opener = _Opener(result, order);
      final ProviderContainer c = ProviderContainer(
        overrides: <Override>[
          contestRepositoryProvider.overrideWithValue(
            _Repo(levels: <CommentLevelView>[done(postUrl: postUrl)]),
          ),
          contestPathProvider.overrideWith(
            (Ref ref) async => pathWith(PathNodeState.done),
          ),
          linkOpeningProvider.overrideWithValue(opener),
        ],
      );
      addTearDown(c.dispose);
      c.listen(commentLevelControllerProvider, (_, _) {});
      c.listen(commentLevelActionsProvider, (_, _) {});
      await c.read(contestPathProvider.future);
      await c.read(commentLevelControllerProvider.future);
      final CommentHandOff outcome = await c
          .read(commentLevelActionsProvider.notifier)
          .handOff();
      expect(c.read(commentLevelActionsProvider).handOff, outcome);
      return (outcome, opener);
    }

    test('copies the comment FIRST, then opens the post on LinkedIn', () async {
      final (CommentHandOff outcome, _Opener opener) = await handOff(
        'https://www.linkedin.com/posts/meera-iyer_status-activity-7394000000000000000-abcd',
      );
      expect(outcome, CommentHandOff.copied);
      expect(clipboard, <String>[finished]);
      expect(opener.opened, hasLength(1));
      expect(order, <String>['copy', 'open']);
    });

    test('opens only https on linkedin.com or a subdomain of it', () async {
      const Map<String, bool> hosts = <String, bool>{
        'https://www.linkedin.com/feed/update/urn:li:activity:1/': true,
        'https://linkedin.com/posts/a-b-activity-1-x': true,
        'https://in.linkedin.com/posts/a-b-activity-1-x': true,
        'http://www.linkedin.com/posts/a-b-activity-1-x': false,
        'https://linkedin.com.evil.example/posts/x': false,
        'https://evil.example/?u=https://www.linkedin.com/posts/x': false,
        'https://user@www.linkedin.com/posts/x': false,
        'javascript:alert(1)': false,
        'notalinkedin.com/posts/x': false,
      };
      for (final MapEntry<String, bool> host in hosts.entries) {
        order.clear();
        final (CommentHandOff outcome, _Opener opener) = await handOff(
          host.key,
        );
        expect(opener.opened.isNotEmpty, host.value, reason: host.key);
        // Copied either way: the comment is theirs to post wherever.
        expect(outcome, CommentHandOff.copied, reason: host.key);
        expect(order.first, 'copy', reason: host.key);
      }
    });

    test('no link at all: copied, and nothing opened', () async {
      final (CommentHandOff outcome, _Opener opener) = await handOff(null);
      expect(outcome, CommentHandOff.copied);
      expect(opener.opened, isEmpty);
      expect(clipboard, <String>[finished]);
    });

    test(
      'a refused copy opens nothing and keeps the comment on screen',
      () async {
        refuseCopy = true;
        final (CommentHandOff outcome, _Opener opener) = await handOff(
          'https://www.linkedin.com/posts/x-activity-1-y',
        );
        expect(outcome, CommentHandOff.refused);
        expect(opener.opened, isEmpty);
      },
    );

    test(
      'a post that would not open is reported, the comment copied',
      () async {
        final (CommentHandOff outcome, _) = await handOff(
          'https://www.linkedin.com/posts/x-activity-1-y',
          result: const LinkOpenFailed(),
        );
        expect(outcome, CommentHandOff.notOpened);
        expect(clipboard, <String>[finished]);
      },
    );
  });

  group('the page', () {
    /// The bank sits below the fold on a small phone: scroll to it first.
    Future<void> tap(WidgetTester tester, String label) async {
      final Finder f = find.bySemanticsLabel(label);
      await tester.ensureVisible(f);
      await tester.tap(f);
      await settle(tester);
    }

    Future<_Repo> pump(
      WidgetTester tester, {
      required ContestPath? path,
      required List<CommentLevelView> levels,
      LinkOpeningService? opener,
    }) async {
      tester.view.physicalSize = const Size(375, 667) * 3;
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);
      final _Repo repo = _Repo(levels: levels);
      final Completer<ContestPath> pending = Completer<ContestPath>();
      final GoRouter router = GoRouter(
        initialLocation: ZaveRoutes.contestComment,
        routes: <RouteBase>[
          GoRoute(
            path: ZaveRoutes.contest,
            builder: (_, _) => const Text('the path'),
          ),
          GoRoute(
            path: ZaveRoutes.contestComment,
            builder: (_, _) => const ContestCommentPage(),
          ),
        ],
      );
      addTearDown(router.dispose);
      await tester.pumpWidget(
        ProviderScope(
          overrides: <Override>[
            contestRepositoryProvider.overrideWithValue(repo),
            contestPathProvider.overrideWith(
              (Ref ref) => path == null ? pending.future : Future.value(path),
            ),
            if (opener != null) linkOpeningProvider.overrideWithValue(opener),
          ],
          child: MaterialApp.router(
            routerConfig: router,
            // Stills, not video: no player in a test.
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

    testWidgets('locked: “Not open yet”, in the web’s words, and no read', (
      WidgetTester tester,
    ) async {
      final _Repo repo = await pump(
        tester,
        path: lockedPath,
        levels: <CommentLevelView>[open()],
      );
      expect(find.text('Comment on a top voice'), findsOneWidget);
      expect(find.text('Not open yet'), findsOneWidget);
      expect(
        find.text(
          'Unlocks after Lesson part 3 of 3. Levels open one after another — finish or skip it first.',
        ),
        findsOneWidget,
      );
      expect(repo.reads, 0);
      expect(tester.takeException(), isNull);
    });

    testWidgets('waiting on the path: the skeleton, the way out, no read', (
      WidgetTester tester,
    ) async {
      final _Repo repo = await pump(
        tester,
        path: null,
        levels: <CommentLevelView>[open()],
      );
      expect(
        find.bySemanticsLabel('Getting today’s post ready'),
        findsOneWidget,
      );
      expect(find.byTooltip('Leave the comment level'), findsOneWidget);
      expect(repo.reads, 0);
    });

    testWidgets('a first try that misses: the day’s XP is gone, said once in '
        'the bar and again on the retry', (WidgetTester tester) async {
      await pump(tester, path: openPath, levels: <CommentLevelView>[open()]);
      expect(find.text('Complete the comment'), findsOneWidget);
      expect(
        find.text('Tap the words in order to fill the blanks.'),
        findsOneWidget,
      );

      await tap(tester, 'reminder');
      await tap(tester, 'remainder');
      await tap(tester, 'approvals');
      await settle(tester);
      await tap(tester, 'Check');
      await settle(tester);

      expect(find.text('Not quite.'), findsOneWidget);
      expect(find.text(kWrongLine), findsOneWidget);
      expect(
        find.bySemanticsLabel(
          'Blank 2: remainder, wrong, the right word is decision',
        ),
        findsOneWidget,
      );
      expect(find.text('→ decision'), findsOneWidget);

      await tap(tester, 'Try again');
      await settle(tester);
      expect(find.text(kFirstTryMissedNote), findsOneWidget);
      expect(find.bySemanticsLabel('Blank 1: reminder'), findsOneWidget);
      expect(find.bySemanticsLabel('Blank 2'), findsOneWidget);

      await tap(tester, 'decision');
      await settle(tester);
      await tap(tester, 'Check');
      await settle(tester);

      expect(find.text('Your comment is ready'), findsOneWidget);
      expect(find.text(kNoXpTodayLine), findsOneWidget);
      expect(find.bySemanticsLabel(contestXpLabel(40)), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets('right first time: the level pays, and no “no XP” line', (
      WidgetTester tester,
    ) async {
      await pump(tester, path: openPath, levels: <CommentLevelView>[open()]);
      await tap(tester, 'reminder');
      await tap(tester, 'decision');
      await tap(tester, 'approvals');
      await settle(tester);
      await tap(tester, 'Check');
      await settle(tester);
      expect(find.text('Your comment is ready'), findsOneWidget);
      expect(find.bySemanticsLabel(contestXpLabel(40)), findsOneWidget);
      expect(find.text(kNoXpTodayLine), findsNothing);
      expect(find.bySemanticsLabel('Comment on LinkedIn'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Comment on LinkedIn copies, opens the post, and goes back '
        'to the path', (WidgetTester tester) async {
      final List<String> order = <String>[];
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        (MethodCall call) async {
          if (call.method == 'Clipboard.setData') order.add('copy');
          return null;
        },
      );
      addTearDown(
        () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          SystemChannels.platform,
          null,
        ),
      );
      final _Opener opener = _Opener(const LinkOpened(), order);
      await pump(
        tester,
        path: pathWith(PathNodeState.done),
        levels: <CommentLevelView>[done()],
        opener: opener,
      );
      await tap(tester, 'Comment on LinkedIn');
      await settle(tester);
      expect(order, <String>['copy', 'open']);
      expect(find.text('the path'), findsOneWidget);
    });

    testWidgets('a done level with no LinkedIn link says to use the feed', (
      WidgetTester tester,
    ) async {
      await pump(
        tester,
        path: pathWith(PathNodeState.done),
        levels: <CommentLevelView>[done(postUrl: 'https://evil.example/p')],
      );
      expect(
        find.text(
          'The post’s link is not available, so open it from your LinkedIn feed.',
        ),
        findsOneWidget,
      );
    });

    for (final (CommentLevelReason? reason, String title)
        in <(CommentLevelReason?, String)>[
          (CommentLevelReason.notToday, 'No comment level today'),
          (CommentLevelReason.noPost, 'No post to comment on today'),
          (CommentLevelReason.notRunning, 'The contest is not running'),
          (CommentLevelReason.notJoined, 'Join the contest first'),
          (CommentLevelReason.writing, 'Writing today’s comment'),
          (null, 'Today’s comment is not ready'),
        ]) {
      testWidgets('unavailable, ${reason?.name ?? 'not written'}: “$title”', (
        WidgetTester tester,
      ) async {
        await pump(
          tester,
          path: openPath,
          levels: <CommentLevelView>[CommentLevelView(reason: reason)],
        );
        expect(find.text(title), findsOneWidget);
        expect(
          find.bySemanticsLabel('See the contest'),
          reason == CommentLevelReason.notJoined
              ? findsOneWidget
              : findsNothing,
        );
        expect(tester.takeException(), isNull);
        // The writing poll's timer goes with the page.
        await tester.pumpWidget(const SizedBox.shrink());
      });
    }
  });

  test('the template splits as the web’s does: a marker past the blank '
      'count is dropped', () {
    final List<CommentPart> parts = splitTemplate('a {{1}} b {{4}} c {{2}}', 2);
    expect(parts.whereType<CommentSlot>().map((CommentSlot s) => s.slot), <int>[
      0,
      1,
    ]);
    expect(
      parts.whereType<CommentText>().map((CommentText t) => t.text).join(),
      'a  b  c ',
    );
  });
}

const String _finished =
    'This is the reminder I needed. Leading with the decision cut our questions, and the approvals land faster.';

/// Lets the reads land. Each hop — the path, the gate, the level, the frame —
/// is a microtask or a zero-length timer, and a bare `pump()` advances no
/// time, so it runs none of the timers.
Future<void> settle(WidgetTester tester) async {
  for (int i = 0; i < 8; i++) {
    await tester.pump(Duration.zero);
  }
}

/// The XP tag's spoken label — "+40 XP" with a true plus.
String contestXpLabel(int n) => '+$n XP';

/// Plays the server for the comment level: the levels to read, in order (the
/// last repeats), and a grader with the fixture's answer key. Every other
/// route is out of scope here.
class _Repo implements ContestRepository {
  _Repo({required this.levels, this.refuse});

  final List<CommentLevelView> levels;
  final ContestRefusal? refuse;
  int reads = 0;
  final List<List<String>> submitted = <List<String>>[];
  bool _missed = false;

  static const List<String> _answers = <String>[
    'reminder',
    'decision',
    'approvals',
  ];

  @override
  Future<CommentLevelView> fetchCommentLevel() async {
    final CommentLevelView level = levels[reads.clamp(0, levels.length - 1)];
    reads++;
    return level;
  }

  @override
  Future<CommentSubmitResult> submitComment(List<String> words) async {
    submitted.add(words);
    if (refuse case final ContestRefusal no) throw no;
    final CommentLevelView base = levels.first;
    final List<CommentBlank> blanks = <CommentBlank>[
      for (int i = 0; i < words.length; i++)
        CommentBlank(
          value: words[i],
          correct: words[i] == _answers[i],
          answer: _answers[i],
        ),
    ];
    final bool correct = blanks.every((CommentBlank b) => b.correct);
    final bool first = !_missed;
    if (!correct) _missed = true;
    return CommentSubmitResult(
      correct: correct,
      blanks: blanks,
      firstTry: first,
      pointsApplied: correct && first ? 40 : 0,
      level: correct
          ? base.copyWith(
              status: CommentLevelStatus.done,
              answers: _answers,
              comment: _finished,
              firstTry: first ? CommentFirstTry.right : CommentFirstTry.wrong,
              pointsApplied: first ? 40 : 0,
            )
          : base.copyWith(firstTry: CommentFirstTry.wrong),
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('${invocation.memberName}');
}

/// The mock flavor's own fake, counting the level's reads.
class _CountingFake extends FakeContestRepository {
  _CountingFake() : super(latency: Duration.zero);

  int reads = 0;

  @override
  Future<CommentLevelView> fetchCommentLevel() {
    reads++;
    return super.fetchCommentLevel();
  }
}

class _Opener implements LinkOpeningService {
  _Opener(this.result, this.order);

  final LinkOpenResult result;
  final List<String> order;
  final List<String> opened = <String>[];

  @override
  Future<LinkOpenResult> open(String url) async {
    opened.add(url);
    order.add('open');
    return result;
  }
}

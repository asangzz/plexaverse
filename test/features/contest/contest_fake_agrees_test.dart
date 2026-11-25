import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/core/router/zave_routes.dart';
import 'package:plexaverse/core/week/week_shape.dart';
import 'package:plexaverse/features/contest/application/contest_controllers.dart';
import 'package:plexaverse/features/contest/data/contest_repositories.dart';
import 'package:plexaverse/features/contest/domain/contest_links.dart';
import 'package:plexaverse/features/contest/domain/contest_repository.dart';
import 'package:plexaverse/features/contest/domain/contest_words.dart';
import 'package:plexaverse/features/contest/domain/lesson_parts.dart';

/// The mock flavor's contest, held against the server it stands in for.
///
/// The mock build is what this app is tested on by hand, so every way the
/// fake can drift from `lib/services/contest-*.service.ts` is a bug manual
/// testing cannot find — worse, one it CONFIRMS, because the fixture shows
/// the wrong behaviour consistently. These pin the server's rules the fake
/// plays: the gate, the parts, when a level opens, what pays, the reveal.
/// Each runs against every scenario a screen can be shown.
FakeContestRepository _fake([
  FakeContestScenario scenario = FakeContestScenario.running,
]) => FakeContestRepository(scenario: scenario, latency: Duration.zero);

/// The states that let the next level of today open (`PASSABLE_STATES`) —
/// `skipped` among them since Skip (17 Nov 2026).
bool _passable(PathNodeState s) => switch (s) {
  PathNodeState.done ||
  PathNodeState.approved ||
  PathNodeState.pending ||
  PathNodeState.revoked ||
  PathNodeState.unavailable ||
  PathNodeState.missed ||
  PathNodeState.skipped => true,
  _ => false,
};

/// The server's own invariants on a path, whatever state it is in.
void _expectServerShaped(ContestPath path, TodayQuiz quiz) {
  if (!path.hasWeek) return;
  final List<PathDay> days = path.days;
  for (int i = 0; i < days.length; i++) {
    final PathDay d = days[i];
    // Sunday to Saturday, consecutive, numbered on the contest's calendar.
    if (i > 0) {
      expect(d.weekday, days[i - 1].weekday + 1);
      expect(d.dayNumber, days[i - 1].dayNumber + 1);
    }
    for (final PathNode n in d.nodes) {
      // Locked never opens; and what opens, opens by the server's rules.
      if (n.state == PathNodeState.locked) expect(n.href, isNull, reason: n.id);
      if (n.state == PathNodeState.revoked) expect(n.href, isNull);
      if (n.state == PathNodeState.revoked) expect(n.points, 0);
      if (n.kind == PathNodeKind.connectLeaders && isFinished(n.state)) {
        expect(n.href, isNull, reason: 'a finished connect never reopens');
      }
      // A skipped part opens on itself (`?part=k`).
      if (n.isLesson && n.href != null) {
        expect(<PathNodeState>[
          PathNodeState.today,
          PathNodeState.done,
          PathNodeState.skipped,
        ], contains(n.state));
        // The web's address since 24 Nov 2026 (`/levels`).
        expect(
          n.href,
          n.state == PathNodeState.skipped
              ? '/levels/lesson?part=${n.part!.index}'
              : '/levels/lesson',
        );
      }
      if (n.kind.isClaim) {
        expect(n.claim, isNotNull);
        if (n.href != null) {
          expect(<PathNodeState>[
            PathNodeState.today,
            PathNodeState.rejected,
            PathNodeState.pending,
            PathNodeState.skipped,
          ], contains(n.state));
        }
      }
      // Skip lives on today only.
      if (!d.isToday) expect(n.canSkip, isFalse, reason: n.id);
      if (n.kind == PathNodeKind.planWeek) expect(n.points, 0);
      // The Sunday levels: set-up steps of the Sunday they sit on, never
      // skipped, and a passed one opens nothing.
      if (n.openAllWeek) {
        expect(n.kind, PathNodeKind.planWeek, reason: n.id);
        expect(n.setup, isNotNull, reason: n.id);
        expect(n.canSkip, isFalse, reason: n.id);
        if (n.state == PathNodeState.missed) expect(n.href, isNull);
      }
      // The video levels were retired (25 Nov 2026): a video node is only
      // ever a claim already sent.
      if (n.kind == PathNodeKind.video) {
        expect(<PathNodeState>[
          PathNodeState.pending,
          PathNodeState.approved,
          PathNodeState.rejected,
        ], contains(n.state));
      }
      if (n.href != null) expect(canOpen(n), isTrue, reason: n.id);
    }
    // Only the last lesson part pays — the day credit.
    final List<PathNode> parts = lessonPartsOf(d);
    for (int k = 0; k < parts.length; k++) {
      expect(parts[k].points > 0, k == parts.length - 1, reason: parts[k].id);
    }
  }

  final PathDay? today = path.today;
  if (today == null) return;
  // The gate: after the first level that is not passable, nothing is open —
  // but the follow level (24 Nov 2026) and the open-all-week Sunday levels
  // (25 Nov 2026), which are outside the order: never locked behind another
  // level, never a holder, never skipped.
  bool blocked = false;
  for (final PathNode n in today.nodes) {
    if (n.openAllWeek) {
      expect(n.canSkip, isFalse, reason: n.id);
      continue;
    }
    if (n.kind == PathNodeKind.followWinners) {
      expect(n.state, isNot(PathNodeState.locked), reason: n.id);
      expect(n.canSkip, isFalse, reason: n.id);
      continue;
    }
    if (blocked) {
      expect(
        n.state == PathNodeState.today || n.state == PathNodeState.rejected,
        isFalse,
        reason: '${n.id} is open behind an unfinished level',
      );
    }
    if (!_passable(n.state)) blocked = true;
  }
  // At most one level can be skipped: the first open one, with nothing
  // holding the chain before it.
  final List<PathNode> skippable = today.nodes
      .where((PathNode n) => n.canSkip)
      .toList();
  expect(skippable.length, lessThanOrEqualTo(1));
  if (skippable.isNotEmpty) {
    final int i = today.nodes.indexOf(skippable.single);
    expect(<PathNodeState>[
      PathNodeState.today,
      PathNodeState.rejected,
    ], contains(skippable.single.state));
    for (int j = 0; j < i; j++) {
      expect(
        _passable(today.nodes[j].state),
        isTrue,
        reason: today.nodes[j].id,
      );
    }
  }
  // Today's parts are the same cut the player makes of the same lesson.
  if (quiz.isReady && quiz.started == true) {
    final List<LessonPart> cut = lessonPartBounds(quiz.total);
    final List<PathNode> parts = lessonPartsOf(today);
    expect(parts, hasLength(cut.length));
    for (int k = 0; k < parts.length; k++) {
      expect(parts[k].part!.start, cut[k].start);
      expect(parts[k].part!.end, cut[k].end);
    }
  }
}

Future<void> _answerUpTo(FakeContestRepository repo, int count) async {
  // Graded by the fake, which is the server here; picking the first option
  // is all a test needs.
  while (true) {
    final TodayQuiz q = await repo.fetchTodayQuiz();
    final int? i = q.firstUnansweredIndex;
    if (i == null || q.answeredCount >= count) return;
    await repo.answerQuiz(
      day: q.day!,
      itemId: q.questions[i].id,
      value: q.questions[i].options.first,
    );
  }
}

void main() {
  setUp(FakeContestWorld.reset);

  group('every scenario says one thing on every route', () {
    final Map<FakeContestScenario, (bool?, ContestPathStatus, QuizStatus)>
    want = <FakeContestScenario, (bool?, ContestPathStatus, QuizStatus)>{
      // (an entrant? null = no overview, path status, lesson status)
      FakeContestScenario.running: (
        true,
        ContestPathStatus.running,
        QuizStatus.ready,
      ),
      FakeContestScenario.noContest: (
        null,
        ContestPathStatus.noContest,
        QuizStatus.noContest,
      ),
      // Reading is joining (owner, 24 Nov 2026): the overview's read enters
      // the learner in the running — or the next — round, so the path and
      // the lesson read after it already see an entrant.
      FakeContestScenario.notJoined: (
        true,
        ContestPathStatus.running,
        QuizStatus.ready,
      ),
      FakeContestScenario.upcoming: (
        true,
        ContestPathStatus.upcoming,
        QuizStatus.upcoming,
      ),
      FakeContestScenario.ended: (
        true,
        ContestPathStatus.ended,
        QuizStatus.ended,
      ),
      FakeContestScenario.revealed: (
        true,
        ContestPathStatus.running,
        QuizStatus.ready,
      ),
      FakeContestScenario.paused: (
        true,
        ContestPathStatus.running,
        QuizStatus.ready,
      ),
    };

    for (final FakeContestScenario s in FakeContestScenario.values) {
      test(s.name, () async {
        final FakeContestRepository repo = _fake(s);
        final ContestOverview? o = await repo.fetchOverview();
        final ContestPath p = await repo.fetchPath();
        final TodayQuiz q = await repo.fetchTodayQuiz();
        final BoardResult b = await repo.fetchBoard(limit: 50);
        final (
          bool? entrant,
          ContestPathStatus pathStatus,
          QuizStatus quizStatus,
        ) = want[s]!;

        expect(o?.isEntrant, entrant);
        expect(p.status, pathStatus);
        expect(q.status, quizStatus);
        _expectServerShaped(p, q);

        if (o != null) {
          // No rank and no rows before the reveal — not even the viewer's.
          expect(o.entry?.rank == null, !o.board.revealed || !o.isEntrant);
          expect(b.revealed, o.board.revealed);
          if (!b.revealed) {
            expect(b.rows, isEmpty);
            expect(b.viewer, isNull);
          }
          // A rank is the viewer's place on the board.
          if (o.entry?.rank case final int rank) expect(b.viewer?.rank, rank);
          // The window is the dates; the length is never drawn but agrees.
          expect(p.finalDay ?? o.lengthDays, o.lengthDays);
        }
        // The board's names are only for an entrant to see.
        if (o?.isEntrant != true) {
          expect(b.rows.where((BoardRow r) => r.name != null), isEmpty);
        }
      });
    }
  });

  group('the running week, a Wednesday mid-path', () {
    test(
      'START is on lesson part 2, and the rest of today waits behind it',
      () async {
        final FakeContestRepository repo = _fake();
        final ContestPath p = await repo.fetchPath();
        final TodayQuiz q = await repo.fetchTodayQuiz();

        expect(p.days.map((PathDay d) => d.weekday), <int>[
          0,
          1,
          2,
          3,
          4,
          5,
          6,
        ]);
        expect(p.today!.weekday, 3);
        expect(currentNodeId(p.days), endsWith(':lesson:2'));

        final PathNode part2 = p.todayNode(PathNodeKind.lesson) == null
            ? throw StateError('no lesson')
            : lessonPartsOf(p.today)[1];
        // The node's count is the lesson read's.
        final int inPart = q.answeredCount - part2.part!.start!;
        expect(
          part2.detail,
          '$inPart of ${part2.part!.end! - part2.part!.start!} answered',
        );

        expect(p.todayNode(PathNodeKind.comment)!.state, PathNodeState.locked);
        expect(
          p.todayNode(PathNodeKind.comment)!.detail,
          'Unlocks after Lesson part 3 of 3',
        );
        // No video level any more (25 Nov 2026): the week's one claim is
        // Thursday's article.
        expect(p.todayNode(PathNodeKind.video), isNull);
        expect(
          p.claims.where((PostClaim c) => c.kind == ClaimKind.article),
          hasLength(1),
        );
        // Last week's video was sent back and is still claimable.
        expect(
          p.claims.where((PostClaim c) => c.status == ClaimStatus.rejected),
          hasLength(1),
        );
        expect(p.feedComments!.points, 100);
      },
    );

    test('the comment GET ignores the gate, as the server’s does — the '
        'answer route does not', () async {
      final FakeContestRepository repo = _fake();
      final CommentLevelView level = await repo.fetchCommentLevel();
      expect(level.status, CommentLevelStatus.open);
      await expectLater(
        repo.submitComment(<String>['reminder', 'decision', 'approvals']),
        throwsA(
          isA<ContestLocked>().having(
            (ContestLocked e) => e.message,
            'message',
            // The nearest earlier level still holding the chain — the locked
            // part 3 — in the server's "finish or skip" words.
            'Finish or skip Lesson part 3 of 3 first.',
          ),
        ),
      );
    });

    test('finishing the lesson pays the day, moves the streak and opens the '
        'comment', () async {
      final FakeContestRepository repo = _fake();
      final int streak = (await repo.fetchOverview())!.entry!.streak;
      TodayQuiz q = await repo.fetchTodayQuiz();

      QuizAnswerResult? last;
      while (q.firstUnansweredIndex != null) {
        final PublicQuizItem item = q.questions[q.firstUnansweredIndex!];
        last = await repo.answerQuiz(
          day: q.day!,
          itemId: item.id,
          value: item.options.first,
        );
        q = await repo.fetchTodayQuiz();
      }
      expect(last!.completed, isTrue);
      // The finishing answer carries the day credit; the score does not.
      expect(last.pointsApplied, greaterThanOrEqualTo(50));
      expect(q.completed, isTrue);
      expect((await repo.fetchOverview())!.entry!.streak, streak + 1);

      final ContestPath p = await repo.fetchPath();
      _expectServerShaped(p, q);
      expect(currentNodeId(p.days), endsWith(':comment'));
      expect(isLessonDone(p.today), isTrue);
      final NextLevel next = nextOpenLevel(p, PathNodeKind.lesson);
      expect(next.route, ZaveRoutes.contestComment);
    });

    test('the first comment submission is the only one that can pay', () async {
      final FakeContestRepository repo = _fake();
      await _answerUpTo(repo, 99);
      await repo.fetchCommentLevel();
      final CommentSubmitResult wrong = await repo.submitComment(<String>[
        'remainder',
        'decision',
        'approvals',
      ]);
      expect(wrong.correct, isFalse);
      expect(wrong.firstTry, isTrue);
      expect(wrong.pointsApplied, 0);
      expect(wrong.blanks.first.answer, 'reminder');
      final CommentSubmitResult right = await repo.submitComment(<String>[
        'reminder',
        'decision',
        'approvals',
      ]);
      expect(right.correct, isTrue);
      expect(right.firstTry, isFalse);
      expect(right.pointsApplied, 0);
      expect(right.level.status, CommentLevelStatus.done);
      expect(isLinkedInHost(right.level.post!.postUrl), isTrue);
    });

    test('feed comments go one at a time, each paid its share, duplicates '
        'refused however they are spelt', () async {
      final FakeContestRepository repo = _fake();
      await _answerUpTo(repo, 99);
      await repo.fetchCommentLevel();
      await repo.submitComment(<String>['reminder', 'decision', 'approvals']);

      FeedCommentsView view = await repo.fetchFeedComments();
      expect(view.shares.fold(0, (int a, int b) => a + b), view.points);

      const String link =
          'https://www.linkedin.com/feed/update/urn:li:activity:7300001';
      final FeedCommentSubmitResult first = await repo.submitFeedComment(link);
      expect(first.n, 1);
      expect(first.pointsApplied, view.shares.first);
      await expectLater(
        repo.submitFeedComment('$link/?trk=feed'),
        throwsA(isA<ContestDuplicateUrl>()),
      );
      await expectLater(
        repo.submitFeedComment('https://www.linkedin.com/in/jane'),
        throwsA(isA<ContestBadUrl>()),
      );
      view = await repo.fetchFeedComments();
      expect(view.links, hasLength(1));
      expect(view.linkPoints, <int>[view.shares.first]);

      final ContestPath p = await repo.fetchPath();
      final PathNode feed = p.todayNode(PathNodeKind.feedComments)!;
      expect(feed.started, isTrue);
      expect(feed.detail, '1 of 5 posted');
      expect(feed.points, view.points - view.shares.first);
    });

    test('claims: no new video, Thursday’s is too early, last week’s '
        'rejected one can be sent again', () async {
      final FakeContestRepository repo = _fake();
      final ContestPath p = await repo.fetchPath();
      const String url = 'https://www.linkedin.com/posts/me_video-activity-1';

      // Nothing to share today, and a new video claim is refused.
      expect(
        p.claims.where((PostClaim c) => c.status == ClaimStatus.open),
        isEmpty,
      );
      await expectLater(
        repo.claimPostLink(
          kind: ClaimKind.video,
          occurrence: '6:1:2',
          postUrl: url,
        ),
        throwsA(
          isA<ContestNotOpen>().having(
            (ContestNotOpen e) => e.message,
            'message',
            'Video levels were retired on 25 Nov 2026.',
          ),
        ),
      );

      final PostClaim thursday = p.claims.firstWhere(
        (PostClaim c) => c.kind == ClaimKind.article,
      );
      await expectLater(
        repo.claimPostLink(
          kind: thursday.kind,
          occurrence: thursday.occurrence,
          postUrl: url,
        ),
        throwsA(
          isA<ContestTooEarly>().having(
            (ContestTooEarly e) => e.message,
            'message',
            'You can share it from Thursday, 12 Nov, the day it goes out.',
          ),
        ),
      );

      final PostClaim rejected = p.claims.firstWhere(
        (PostClaim c) => c.status == ClaimStatus.rejected,
      );
      final ClaimResult r = await repo.claimPostLink(
        kind: rejected.kind,
        occurrence: rejected.occurrence,
        postUrl: url,
      );
      expect(r.claim.status, ClaimStatus.pending);
      await expectLater(
        repo.claimPostLink(
          kind: ClaimKind.video,
          occurrence: rejected.occurrence,
          postUrl: 'https://www.linkedin.com/in/jane',
        ),
        throwsA(isA<ContestBadUrl>()),
      );
    });

    test('a Wednesday offers no connect, invites or plan', () async {
      final FakeContestRepository repo = _fake();
      await expectLater(
        repo.completeConnect(),
        throwsA(isA<ContestWrongDay>()),
      );
      await expectLater(
        repo.submitInvites(Uint8List.fromList(<int>[1]), 'a.jpg'),
        throwsA(isA<ContestWrongDay>()),
      );
      await expectLater(
        repo.completePlanWeek(),
        throwsA(isA<ContestWrongDay>()),
      );
      final PlanWeekView plan = await repo.fetchPlanWeek();
      expect(plan.status, PlanWeekStatus.unavailable);
      expect(plan.reason, PlanWeekReason.notToday);
      expect(plan.days.first.weekday, 'Sunday');
      expect(
        (await repo.fetchConnectTargets()).connections.where(
          (ConnectionTarget t) => t.isDirectMessage,
        ),
        hasLength(1),
      );
    });

    test(
      'an answer is graded once: a second send is the first read back',
      () async {
        final FakeContestRepository repo = _fake();
        final TodayQuiz q = await repo.fetchTodayQuiz();
        final QuizAnswerView first = q.answered.first;
        final PublicQuizItem item = q.questions.firstWhere(
          (PublicQuizItem i) => i.id == first.itemId,
        );
        final QuizAnswerResult again = await repo.answerQuiz(
          day: q.day!,
          itemId: item.id,
          value: item.options.firstWhere((String o) => o != first.value),
        );
        expect(again.replay, isTrue);
        expect(again.value, first.value);
        await expectLater(
          repo.answerQuiz(day: q.day! - 1, itemId: item.id, value: first.value),
          throwsA(isA<ContestNotToday>()),
        );
      },
    );
  });

  // There is no join step (owner, 24 Nov 2026): the server's
  // ensureLevelsEntry runs before the overview and the path answer, and
  // enters the learner anonymously. Deliberately changed from the old
  // "joining" group, which pinned the join call this replaced.
  group('the Sunday levels (setupLevels=1)', () {
    test('a planned week’s set-up steps are Sunday’s last levels, open all '
        'week, in every live state', () async {
      final FakeContestRepository repo = _fake();
      final ContestPath p = await repo.fetchPath();
      final PathDay sunday = p.days.first;
      expect(sunday.weekday, 0);
      expect(sunday.isToday, isFalse);

      final List<PathNode> steps = sunday.nodes
          .where((PathNode n) => n.openAllWeek)
          .toList();
      // After Sunday's own levels, in place of "Plan this week".
      expect(sunday.nodes.sublist(sunday.nodes.length - steps.length), steps);
      expect(
        sunday.nodes.where(
          (PathNode n) => n.kind == PathNodeKind.planWeek && !n.openAllWeek,
        ),
        isEmpty,
      );
      expect(steps.map((PathNode n) => n.title), <String>[
        'Write Monday’s post',
        'Add Monday’s image',
        'Write Wednesday’s post',
        'Add Wednesday’s image',
        'Write Friday’s post',
        'Add Friday’s image',
      ]);
      expect(steps.map((PathNode n) => n.state), <PathNodeState>[
        PathNodeState.done,
        PathNodeState.missed,
        PathNodeState.today,
        PathNodeState.locked,
        PathNodeState.today,
        PathNodeState.locked,
      ]);
      expect(steps[1].detail, 'Day passed — Monday’s image was not added');
      expect(steps[1].href, isNull);
      expect(steps[3].detail, 'Unlocks after Write Wednesday’s post');
      expect(
        steps[2].setup,
        const NodeSetup(dayIndex: 2, step: SetupStep.post),
      );
      expect(steps[3].setup!.imageKind, 'photo');
      expect(steps.every((PathNode n) => n.points == 0), isTrue);
      expect(steps.first.id, '${sunday.dayKey}:plan_week:post:0');

      // Only the day that holds them; and none of them is START on a
      // Wednesday, whose own levels come first.
      expect(
        p.days.where((PathDay d) => d.nodes.any((PathNode n) => n.openAllWeek)),
        hasLength(1),
      );
      expect(
        steps.map((PathNode n) => n.id),
        isNot(contains(currentNodeId(p.days))),
      );
    });

    test('a set-up step is refused a skip on every day', () async {
      final FakeContestRepository repo = _fake();
      final PathNode step = (await repo.fetchPath()).days.first.nodes
          .firstWhere(
            (PathNode n) => n.openAllWeek && n.state == PathNodeState.today,
          );
      await expectLater(
        repo.skipLevel(step.id),
        throwsA(isA<ContestNotOpen>()),
      );
    });

    test('the plan view reads the playbook week: Mon, Wed and Fri posts with '
        'their roles, Thursday’s article, the rest days', () async {
      final PlanWeekView v = await _fake().fetchPlanWeek();
      expect(v.days.map((PlanWeekDay d) => d.kind), <DayKind>[
        DayKind.rest,
        DayKind.post,
        DayKind.rest,
        DayKind.post,
        DayKind.article,
        DayKind.post,
        DayKind.rest,
      ]);
      expect(
        v.days
            .where((PlanWeekDay d) => d.kind == DayKind.post)
            .map((PlanWeekDay d) => '${d.role} · ${d.formatName}'),
        <String>[
          'teach · Numbered steps',
          'story · Mistake → lesson',
          'opinion · Industry take',
        ],
      );
      expect(
        v.days.any((PlanWeekDay d) => d.kind == DayKind.videoScript),
        isFalse,
      );
    });
  });

  group('entering on read', () {
    test('a late learner starts today, with the days before it missed and the '
        'lesson not yet opened', () async {
      final FakeContestRepository repo = _fake(FakeContestScenario.notJoined);
      final ContestOverview o = (await repo.fetchOverview())!;
      expect(o.isEntrant, isTrue);
      expect(o.entry!.streak, 0);

      final ContestPath p = await repo.fetchPath();
      final TodayQuiz q = await repo.fetchTodayQuiz();
      _expectServerShaped(p, q);
      for (final PathDay d in p.days.where(
        (PathDay d) => d.dayKey.compareTo(p.today!.dayKey) < 0,
      )) {
        // The Sunday levels are the Planner's, not the entry's: they keep
        // their live state whenever the learner joined.
        expect(
          d.nodes
              .where((PathNode n) => !n.openAllWeek)
              .every((PathNode n) => n.state == PathNodeState.missed),
          isTrue,
          reason: d.dayKey,
        );
      }
      // Not missed for the week trophy: those days were not asked of them.
      expect(p.weekReward!.missedDay, isFalse);
      expect(q.started, isFalse);
      expect(q.ownQuestions, 0);
      // Before the open, the path assumes the opened size.
      expect(lessonPartsOf(p.today).first.part!.end, 5);

      final TodayQuiz opened = await repo.startLesson();
      expect(opened.started, isTrue);
      expect(opened.ownQuestions, 5);
      expect(opened.total, 15);
      expect(
        opened.questions.where((PublicQuizItem i) => i.isOwn),
        hasLength(5),
      );
    });

    test(
      'an answer before the open fixes the day to the set questions — the '
      'server’s trap, kept so a player that skips the open is caught',
      () async {
        final FakeContestRepository repo = _fake(FakeContestScenario.notJoined);
        await repo.fetchOverview();
        final TodayQuiz q = await repo.fetchTodayQuiz();
        await repo.answerQuiz(
          day: q.day!,
          itemId: q.questions.first.id,
          value: q.questions.first.options.first,
        );
        final TodayQuiz opened = await repo.startLesson();
        expect(opened.ownQuestions, 0);
        expect(opened.total, 10);
      },
    );

    test('with no round, reading enters nobody and nothing opens', () async {
      final FakeContestRepository repo = _fake(FakeContestScenario.noContest);
      expect(await repo.fetchOverview(), isNull);
      expect((await repo.fetchPath()).status, ContestPathStatus.noContest);
      await expectLater(repo.startLesson(), throwsA(isA<ContestNotRunning>()));
    });

    test('the path alone enters too — either read is enough', () async {
      final FakeContestRepository repo = _fake(FakeContestScenario.notJoined);
      expect((await repo.fetchPath()).status, ContestPathStatus.running);
      expect((await repo.fetchOverview())!.isEntrant, isTrue);
    });

    test(
      'an upcoming round enters the learner and waits for its first day',
      () async {
        final FakeContestRepository repo = _fake(FakeContestScenario.upcoming);
        final ContestOverview o = (await repo.fetchOverview())!;
        expect(o.phase, ContestPhase.upcoming);
        expect(o.isEntrant, isTrue);
        expect((await repo.fetchPath()).status, ContestPathStatus.upcoming);
        expect((await repo.fetchTodayQuiz()).status, QuizStatus.upcoming);
        await expectLater(
          repo.startLesson(),
          throwsA(isA<ContestNotRunning>()),
        );
      },
    );

    test(
      'before any read, a write is refused as "open your levels first"',
      () async {
        final FakeContestRepository repo = _fake(FakeContestScenario.notJoined);
        await expectLater(
          repo.startLesson(),
          throwsA(isA<ContestNotEntered>()),
        );
        await expectLater(
          repo.completeConnect(),
          throwsA(isA<ContestNotEntered>()),
        );
        expect(
          (await repo.fetchCommentLevel()).reason,
          CommentLevelReason.notJoined,
        );
        expect(
          (await repo.fetchFeedComments()).reason,
          FeedCommentsReason.notJoined,
        );
      },
    );
  });

  group('paused scoring', () {
    test('answers are recorded and never paid, and the streak stays', () async {
      final FakeContestRepository repo = _fake(FakeContestScenario.paused);
      final ContestOverview o = (await repo.fetchOverview())!;
      expect(o.entry!.scoringPaused, isTrue);
      expect(o.entry!.freeDaysLeft, 0);
      expect(o.contest.freeDays, 7);

      TodayQuiz q = await repo.fetchTodayQuiz();
      expect(q.scoringPaused, isTrue);
      expect(
        q.answered.every((QuizAnswerView a) => a.pointsApplied == null),
        isTrue,
      );
      QuizAnswerResult? last;
      while (q.firstUnansweredIndex != null) {
        final PublicQuizItem item = q.questions[q.firstUnansweredIndex!];
        last = await repo.answerQuiz(
          day: q.day!,
          itemId: item.id,
          value: item.options.first,
        );
        expect(last.scored, isFalse);
        expect(last.pointsApplied, 0);
        q = await repo.fetchTodayQuiz();
      }
      expect(q.score!.points, 0);
      expect((await repo.fetchOverview())!.entry!.streak, o.entry!.streak);
    });
  });

  group('the last days', () {
    test('the board is open: a rank, a finalist, a revoked day that pays '
        'nothing', () async {
      final FakeContestRepository repo = _fake(FakeContestScenario.revealed);
      final ContestOverview o = (await repo.fetchOverview())!;
      expect(o.board.revealed, isTrue);
      expect(o.entry!.rank, 7);
      final BoardResult board = await repo.fetchBoard(limit: 10);
      expect(board.rows, hasLength(10));
      expect(board.viewerOutsideRows, isFalse);
      expect(
        gapLine(board.rows, board.viewer, o.contest.rewardTopN),
        startsWith('You are a finalist.'),
      );

      final ContestPath p = await repo.fetchPath();
      final PathNode revoked = p.days
          .expand((PathDay d) => d.nodes)
          .firstWhere((PathNode n) => n.state == PathNodeState.revoked);
      expect(revoked.points, 0);
      expect(revoked.detail, startsWith('Removed: '));
    });

    test('the final standings pin a viewer outside the top rows', () async {
      final FakeContestRepository repo = _fake(FakeContestScenario.ended);
      final BoardResult board = await repo.fetchBoard(limit: 10);
      expect(board.revealed, isTrue);
      expect(board.viewer!.rank, 14);
      expect(board.viewerOutsideRows, isTrue);
    });
  });

  group('skip', () {
    // The running fixture: Wednesday 2026-11-11, part 1 done, two of part 2
    // answered, part 3 locked, everything after it locked behind it.
    const String today = '2026-11-11';

    PathNode nodeOf(ContestPath p, String id) =>
        p.today!.nodes.firstWhere((PathNode n) => n.id == id);

    test('the open part is the one Skip may be pressed on', () async {
      final FakeContestRepository repo = _fake();
      final ContestPath p = await repo.fetchPath();
      _expectServerShaped(p, await repo.fetchTodayQuiz());
      expect(nodeOf(p, '$today:lesson:2').canSkip, isTrue);
      expect(p.today!.nodes.where((PathNode n) => n.canSkip), hasLength(1));
      final TodayQuiz q = await repo.fetchTodayQuiz();
      expect(q.dayKey, today);
      expect(q.skippedParts, isEmpty);
    });

    test('skipping the open part keeps it open on itself, opens the next '
        'and moves START', () async {
      final FakeContestRepository repo = _fake();
      final SkipResult r = await repo.skipLevel('$today:lesson:2');
      expect(r.nodeId, '$today:lesson:2');
      expect(r.alreadySkipped, isFalse);

      final ContestPath p = await repo.fetchPath();
      final TodayQuiz q = await repo.fetchTodayQuiz();
      _expectServerShaped(p, q);
      final PathNode two = nodeOf(p, '$today:lesson:2');
      expect(two.state, PathNodeState.skipped);
      expect(two.href, '/levels/lesson?part=2');
      expect(two.detail, 'You skipped this · 2 of 5 answered');
      expect(two.canSkip, isFalse);
      expect(contestLevelRoute(two), '${ZaveRoutes.contestLesson}?part=2');
      final PathNode three = nodeOf(p, '$today:lesson:3');
      expect(three.state, PathNodeState.today);
      expect(three.canSkip, isTrue);
      expect(currentNodeId(p.days), '$today:lesson:3');
      expect(openLevelOf(p.days)!.id, '$today:lesson:3');
      expect(q.skippedParts, <int>[2]);
      // Behind the part now open, in the server's words.
      expect(
        nodeOf(p, '$today:comment').detail,
        'Unlocks after Lesson part 3 of 3',
      );
    });

    test('a repeat is a success that writes nothing', () async {
      final FakeContestRepository repo = _fake();
      await repo.skipLevel('$today:lesson:2');
      final SkipResult again = await repo.skipLevel('$today:lesson:2');
      expect(again.alreadySkipped, isTrue);
    });

    test('refusals, in the server’s order and words', () async {
      final FakeContestRepository repo = _fake();
      await expectLater(
        repo.skipLevel('2026-11-10:comment'),
        throwsA(
          isA<ContestWrongDay>().having(
            (ContestWrongDay e) => e.message,
            'message',
            'That day is over. Reload the path for today’s.',
          ),
        ),
      );
      await expectLater(
        repo.skipLevel('$today:nothing'),
        throwsA(
          isA<ContestInvalid>().having(
            (ContestInvalid e) => e.message,
            'message',
            'That level is not on today’s path.',
          ),
        ),
      );
      await expectLater(
        repo.skipLevel('$today:lesson:1'),
        throwsA(isA<ContestAlreadyDone>()),
      );
      await expectLater(
        repo.skipLevel('$today:comment'),
        throwsA(
          isA<ContestLocked>().having(
            (ContestLocked e) => e.message,
            'message',
            'Finish or skip Lesson part 3 of 3 first.',
          ),
        ),
      );
    });

    test('a locked part refuses an answer; a skipped part takes one beside '
        'the open part', () async {
      final FakeContestRepository repo = _fake();
      TodayQuiz q = await repo.fetchTodayQuiz();
      // Part 3 starts at question 10 of 15, behind the open part 2.
      await expectLater(
        repo.answerQuiz(
          day: q.day!,
          itemId: q.questions[10].id,
          value: q.questions[10].options.first,
        ),
        throwsA(
          isA<ContestLocked>().having(
            (ContestLocked e) => e.message,
            'message',
            'Finish or skip Lesson part 2 of 3 first.',
          ),
        ),
      );

      await repo.skipLevel('$today:lesson:2');
      q = await repo.fetchTodayQuiz();
      // The open part 3 first, then the skipped part 2 beside it.
      await repo.answerQuiz(
        day: q.day!,
        itemId: q.questions[10].id,
        value: q.questions[10].options.first,
      );
      await repo.answerQuiz(
        day: q.day!,
        itemId: q.questions[7].id,
        value: q.questions[7].options.first,
      );
      final ContestPath p = await repo.fetchPath();
      expect(
        nodeOf(p, '$today:lesson:2').detail,
        'You skipped this · 3 of 5 answered',
      );
      expect(nodeOf(p, '$today:lesson:3').detail, '1 of 5 answered');
    });

    test('a skipped part finished is done, and the day pays only once every '
        'part is', () async {
      final FakeContestRepository repo = _fake();
      final int streak = (await repo.fetchOverview())!.entry!.streak;
      await repo.skipLevel('$today:lesson:2');
      TodayQuiz q = await repo.fetchTodayQuiz();
      // Part 3 in full.
      for (int i = 10; i < 15; i++) {
        final QuizAnswerResult r = await repo.answerQuiz(
          day: q.day!,
          itemId: q.questions[i].id,
          value: q.questions[i].options.first,
        );
        expect(r.completed, isFalse);
      }
      ContestPath p = await repo.fetchPath();
      expect(nodeOf(p, '$today:lesson:3').state, PathNodeState.done);
      expect(isLessonDone(p.today), isFalse);
      // The skipped part 2 passes the gate, so the comment is open now.
      expect(openLevelOf(p.days)!.id, '$today:comment');
      expect((await repo.fetchOverview())!.entry!.streak, streak);

      q = await repo.fetchTodayQuiz();
      QuizAnswerResult? last;
      for (int i = 7; i < 10; i++) {
        last = await repo.answerQuiz(
          day: q.day!,
          itemId: q.questions[i].id,
          value: q.questions[i].options.first,
        );
      }
      expect(last!.completed, isTrue);
      expect((await repo.fetchOverview())!.entry!.streak, streak + 1);
      p = await repo.fetchPath();
      _expectServerShaped(p, await repo.fetchTodayQuiz());
      expect(nodeOf(p, '$today:lesson:2').state, PathNodeState.done);
      expect(isLessonDone(p.today), isTrue);
    });

    test(
      'a skipped task stays open, passes the gate, and pays if done',
      () async {
        final FakeContestRepository repo = _fake();
        await repo.skipLevel('$today:lesson:2');
        await repo.skipLevel('$today:lesson:3');
        ContestPath p = await repo.fetchPath();
        // Every part left is skipped: the comment is the open level.
        expect(openLevelOf(p.days)!.id, '$today:comment');
        expect(nodeOf(p, '$today:comment').canSkip, isTrue);

        await repo.skipLevel('$today:comment');
        p = await repo.fetchPath();
        _expectServerShaped(p, await repo.fetchTodayQuiz());
        final PathNode comment = nodeOf(p, '$today:comment');
        expect(comment.state, PathNodeState.skipped);
        expect(comment.detail, 'You skipped this');
        expect(comment.href, isNotNull);
        expect(stateWord(comment.state), 'Skipped, still open today');
        expect(actionWord(comment), 'Start +40 XP');
        expect(contestLevelRoute(comment), ZaveRoutes.contestComment);
        expect(currentNodeId(p.days), '$today:feed_comments');

        // Done after all: it pays as usual, and the skip no longer shows.
        await repo.fetchCommentLevel();
        final CommentSubmitResult r = await repo.submitComment(<String>[
          'reminder',
          'decision',
          'approvals',
        ]);
        expect(r.pointsApplied, 40);
        p = await repo.fetchPath();
        expect(nodeOf(p, '$today:comment').state, PathNodeState.done);
      },
    );

    test('a level behind the open one cannot be skipped', () async {
      final FakeContestRepository repo = _fake();
      await repo.skipLevel('$today:lesson:2');
      // The open part 3 is the one; the feed comments behind it are locked.
      await expectLater(
        repo.skipLevel('$today:feed_comments'),
        throwsA(isA<ContestLocked>()),
      );
    });
  });

  group('what the fake sends, the wire can carry', () {
    for (final FakeContestScenario s in FakeContestScenario.values) {
      test(s.name, () async {
        final FakeContestRepository repo = _fake(s);
        Map<String, dynamic> wire(Map<String, dynamic> json) =>
            jsonDecode(jsonEncode(json)) as Map<String, dynamic>;
        final ContestOverview? o = await repo.fetchOverview();
        if (o != null) expect(ContestOverview.fromJson(wire(o.toJson())), o);
        final ContestPath p = await repo.fetchPath();
        expect(ContestPath.fromJson(wire(p.toJson())), p);
        final TodayQuiz q = await repo.fetchTodayQuiz();
        expect(TodayQuiz.fromJson(wire(q.toJson())), q);
        final BoardResult b = await repo.fetchBoard();
        expect(BoardResult.fromJson(wire(b.toJson())), b);
        final PlanWeekView plan = await repo.fetchPlanWeek();
        expect(PlanWeekView.fromJson(wire(plan.toJson())), plan);
      });
    }
  });

  group('the controllers over the fake', () {
    ProviderContainer container(ContestRepository repo) {
      final ProviderContainer c = ProviderContainer(
        overrides: <Override>[
          contestRepositoryProvider.overrideWithValue(repo),
        ],
      );
      addTearDown(c.dispose);
      return c;
    }

    test(
      'the lock is read off the path, and is pending until it answers',
      () async {
        final ProviderContainer c = container(_fake());
        final ProviderSubscription<TodayLock> comment = c.listen(
          todayLockProvider(PathNodeKind.comment),
          (TodayLock? _, TodayLock _) {},
        );
        expect(comment.read().pending, isTrue);
        await c.read(contestPathProvider.future);
        expect(comment.read().pending, isFalse);
        expect(comment.read().locked, 'Unlocks after Lesson part 3 of 3');
        expect(
          c.read(todayLockProvider(PathNodeKind.lesson)).isLocked,
          isFalse,
        );
        // Not on today's path at all: not locked by the gate.
        expect(
          c.read(todayLockProvider(PathNodeKind.weeklyInvites)).isLocked,
          isFalse,
        );
      },
    );

    testWidgets(
      'coming back to the app re-reads the standing and the path, and only '
      'while a contest screen is up',
      (WidgetTester tester) async {
        final _Counting repo = _Counting();
        // The same scope throughout, so the reads below are one cache's: the
        // second pump only stops watching the refresher.
        Widget screen({required bool refresher}) => ProviderScope(
          overrides: <Override>[
            contestRepositoryProvider.overrideWithValue(repo),
          ],
          child: Consumer(
            builder: (BuildContext context, WidgetRef ref, Widget? _) {
              if (refresher) ref.watch(contestResumeRefreshProvider);
              ref.watch(contestOverviewProvider);
              ref.watch(contestPathProvider);
              return const SizedBox.shrink();
            },
          ),
        );

        await tester.pumpWidget(screen(refresher: true));
        await tester.pump();
        expect(repo.reads['overview'], 1);
        expect(repo.reads['path'], 1);

        // The OS walks the states one at a time, and so does this.
        void walk(List<AppLifecycleState> states) {
          for (final AppLifecycleState s in states) {
            tester.binding.handleAppLifecycleStateChanged(s);
          }
        }

        const List<AppLifecycleState> away = <AppLifecycleState>[
          AppLifecycleState.inactive,
          AppLifecycleState.hidden,
          AppLifecycleState.paused,
        ];
        const List<AppLifecycleState> back = <AppLifecycleState>[
          AppLifecycleState.hidden,
          AppLifecycleState.inactive,
          AppLifecycleState.resumed,
        ];

        walk(away);
        await tester.pump();
        expect(repo.reads['overview'], 1);
        walk(back);
        await tester.pump();
        expect(repo.reads['overview'], 2);
        expect(repo.reads['path'], 2);

        // Gone with the screen that watched it: a resume costs nothing. An
        // unwatched provider is let go a moment later, not on the same frame.
        await tester.pumpWidget(screen(refresher: false));
        await tester.pump(const Duration(milliseconds: 50));
        expect(repo.reads['overview'], 2);
        walk(away);
        walk(back);
        await tester.pump();
        expect(repo.reads['overview'], 2);
      },
    );

    // The consistency meter joined the refresh (17 Nov 2026): it counts
    // what the path pays, as the web's `refreshStanding` re-reads it.
    test('a refresh re-reads the standing, the path, the board, the lesson and '
        'the consistency meter', () async {
      final _Counting repo = _Counting();
      final ProviderContainer c = container(repo);
      c.listen(contestOverviewProvider, (_, _) {});
      c.listen(contestPathProvider, (_, _) {});
      c.listen(contestBoardProvider(50), (_, _) {});
      c.listen(todayQuizProvider, (_, _) {});
      c.listen(contestConsistencyProvider, (_, _) {});
      await c.read(contestOverviewProvider.future);
      await c.read(contestPathProvider.future);
      await c.read(contestBoardProvider(50).future);
      await c.read(todayQuizProvider.future);
      await c.read(contestConsistencyProvider.future);
      expect(repo.reads, <String, int>{
        'overview': 1,
        'path': 1,
        'board': 1,
        'quiz': 1,
        'consistency': 1,
      });

      refreshContestStanding(c.invalidate);
      await c.read(contestOverviewProvider.future);
      await c.read(contestPathProvider.future);
      await c.read(contestBoardProvider(50).future);
      await c.read(todayQuizProvider.future);
      await c.read(contestConsistencyProvider.future);
      expect(repo.reads, <String, int>{
        'overview': 2,
        'path': 2,
        'board': 2,
        'quiz': 2,
        'consistency': 2,
      });
    });
  });
}

class _Counting extends FakeContestRepository {
  _Counting() : super(latency: Duration.zero);

  final Map<String, int> reads = <String, int>{};

  void _count(String key) => reads[key] = (reads[key] ?? 0) + 1;

  @override
  Future<ContestOverview?> fetchOverview() {
    _count('overview');
    return super.fetchOverview();
  }

  @override
  Future<ContestPath> fetchPath() {
    _count('path');
    return super.fetchPath();
  }

  @override
  Future<ConsistencyView> fetchConsistency() {
    _count('consistency');
    return super.fetchConsistency();
  }

  @override
  Future<BoardResult> fetchBoard({int? limit}) {
    _count('board');
    return super.fetchBoard(limit: limit);
  }

  @override
  Future<TodayQuiz> fetchTodayQuiz() {
    _count('quiz');
    return super.fetchTodayQuiz();
  }
}

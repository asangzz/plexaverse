import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/core/week/week_shape.dart';
import 'package:plexaverse/features/engagement/data/engagement_repositories.dart';
import 'package:plexaverse/features/engagement/domain/comment_draft.dart';
import 'package:plexaverse/features/engagement/domain/connection_target.dart';
import 'package:plexaverse/features/home/data/home_repositories.dart';
import 'package:plexaverse/features/home/domain/roadmap_progress.dart';
import 'package:plexaverse/features/planner/data/planner_repositories.dart';
import 'package:plexaverse/features/planner/domain/plan_slot.dart';
import 'package:plexaverse/features/planner/domain/planner_repository.dart';
import 'package:plexaverse/features/planner/domain/weekly_article.dart';
import 'package:plexaverse/features/plexa/data/plexa_repositories.dart';
import 'package:plexaverse/features/plexa/domain/plexa_day.dart';
import 'package:plexaverse/features/posts/data/post_library_repositories.dart';
import 'package:plexaverse/features/posts/domain/post_library_repository.dart';

/// The mock flavor's fakes, held against the server they stand in for.
///
/// ## Why this file exists
///
/// The mock build is what this app is manually tested on. Every divergence
/// between a fake and the real server is therefore a bug that testing cannot
/// find — and worse, one that testing actively CONFIRMS, because the fixture
/// shows the wrong behaviour consistently and looks deliberate.
///
/// An audit found fourteen. Four were caught earlier by hand: a week built as
/// seven posts after the product moved to two, a newsletter name hardcoded so
/// `isFirstArticle` was false for ever, two surfaces holding separate day
/// sessions, and a missing `readingMinutes` that rendered "0 min read".
///
/// The rule, already written into `fake_day_session.dart`: a fixture that
/// cannot demonstrate the behaviour it stands in for is worse than no
/// fixture, because it teaches the wrong thing confidently.
void main() {
  group('the planner fake', () {
    test('a future week has NO plan, which is a state the server has', () {
      // It used to ignore week/season entirely and hand back week 3's plan
      // whatever was asked for — so `plan == null`, the locked-preview branch
      // at the top of PlannerPage.build, was unreachable in mock.
      return FakePlannerRepository().fetchWeek(week: 9).then((PlannerState s) {
        expect(s.plan, isNull);
        expect(s.isGenerated, isFalse);
        // The season roadmap still previews it.
        expect(s.upcomingTopic, isNotNull);
        expect(s.upcomingTitle, isNotNull);
      });
    });

    test('a past week is finished, not a copy of the current one', () async {
      // Browsing back used to serve week 3's half-done plan under a "Week 2"
      // heading, so the finished-week state had no fixture at all.
      final PlannerState s = await FakePlannerRepository().fetchWeek(week: 2);
      expect(s.plan, isNotNull);
      expect(s.plan!.weekNumber, 2);
      for (final PlanSlot slot in s.plan!.posts) {
        if (!slot.isPublishable) continue;
        expect(slot.status, SlotStatus.published);
      }
    });

    test('the current week still has one', () async {
      final PlannerState s = await FakePlannerRepository().fetchWeek(week: 3);
      expect(s.plan, isNotNull);
      expect(s.currentWeekNumber, 3);
    });

    test('formats are values the server can actually emit', () async {
      // These were 'image' and 'poll'. PostFormat has no 'image', and no day
      // carries a poll since Friday became a video script — and the planner
      // renders this string straight onto a pill the user reads.
      const Set<String> serverFormats = <String>{
        'text',
        'text_image',
        'carousel',
        'poll',
      };
      final PlannerState s = await FakePlannerRepository().fetchWeek();

      for (final PlanSlot slot in s.plan!.posts) {
        expect(
          serverFormats,
          contains(slot.format),
          reason: '${slot.day} has a format the server cannot send',
        );
      }
    });

    test('the week it serves IS the shared week shape', () async {
      final PlannerState s = await FakePlannerRepository().fetchWeek();
      for (int i = 0; i < 7; i++) {
        expect(s.plan!.posts[i].kind, dayKindAt(i));
        expect(s.plan!.posts[i].format, dayFormatAt(i));
      }
    });

    test(
      'generating on a hand-off day is refused, as the server refuses',
      () async {
        // Five days in seven have nothing for the post generator to make. The
        // fake used to generate a post for any index, so NOT_A_POST_DAY — the
        // one failure a user reaches by tapping, and the branch that says a
        // retry will never work — could not be walked.
        final FakePlannerRepository repo = FakePlannerRepository();
        final PlannerState s = await repo.fetchWeek();

        for (int i = 0; i < 7; i++) {
          if (s.plan!.posts[i].isPublishable) continue;
          await expectLater(
            repo.generateSlotPost(planId: 'mock-plan-1', slotIndex: i),
            throwsA(
              isA<PlannerGenerateFailure>().having(
                (PlannerGenerateFailure f) => f.kind,
                'kind',
                PlannerGenerateFailureKind.notAPostDay,
              ),
            ),
          );
        }
      },
    );

    test('a post day still generates', () async {
      final FakePlannerRepository repo = FakePlannerRepository();
      final GeneratedSlot g = await repo.generateSlotPost(
        planId: 'mock-plan-1',
        slotIndex: 0,
        force: true,
      );
      expect(g.postId, isNotNull);
    });

    test(
      'both article writes answer with the article, as the route does',
      () async {
        // They returned null, so a caller reconciling from the response took
        // the empty branch in mock and the real one against a server.
        final FakePlannerRepository repo = FakePlannerRepository();

        final WeeklyArticle? scheduled = await repo.setArticleSchedule(
          weekNumber: 3,
          season: 1,
          when: DateTime.now().add(const Duration(days: 2)),
        );
        expect(scheduled, isNotNull);
        expect(scheduled!.scheduledFor, isNotNull);

        final WeeklyArticle? published = await repo.markArticlePublished(
          weekNumber: 3,
          season: 1,
        );
        expect(published, isNotNull);
        expect(published!.isPublished, isTrue);
      },
    );
  });

  group('the engagement fakes', () {
    test('the first batch of the day is NOT cached; the next one is', () async {
      // Both hardcoded `cached: true` with an xpCost never spent, so the
      // charging branch — the first ask of the day, the one the real routes
      // bill for — never ran, and CachedBatchNote was permanently on screen.
      final FakeEngagementRepository repo = FakeEngagementRepository();

      final CommentBatch first = await repo.generateComments();
      expect(first.cached, isFalse);
      expect(
        await repo.generateComments().then((CommentBatch b) => b.cached),
        isTrue,
      );

      final ConnectionBatch c1 = await repo.findConnections();
      expect(c1.cached, isFalse);
      expect(
        await repo.findConnections().then((ConnectionBatch b) => b.cached),
        isTrue,
      );
    });
  });

  group('Open Plexa and the engagement screens', () {
    test('describe the SAME day, item for item', () async {
      // They share one `plexa_day` row, and that sharing is the feature:
      // clearing an item on one surface has to show up on the other. Open
      // Plexa carried 2 Top Voices, 1 comment draft and 1 connection against
      // the engagement fakes' 5, 3 and 5 — so they could never be caught
      // disagreeing, because disagreeing was their normal state.
      final PlexaDay day = await FakePlexaRepository().fetchDay();
      final FakeEngagementRepository eng = FakeEngagementRepository();

      final int tv = day.items
          .where((DayItem i) => i.id.startsWith('tv:'))
          .length;
      final int nw = day.items
          .where((DayItem i) => i.id.startsWith('nw:'))
          .length;
      final int cn = day.items
          .where((DayItem i) => i.id.startsWith('cn:'))
          .length;

      expect(tv, (await eng.fetchTopVoices()).posts.length);
      expect(nw, (await eng.generateComments()).comments.length);
      expect(cn, (await eng.findConnections()).connections.length);
    });

    test('ready is derived from what is there, not asserted', () async {
      final PlexaDay day = await FakePlexaRepository().fetchDay();
      expect(
        day.ready.comments,
        day.items.any((DayItem i) => i.id.startsWith('nw:')),
      );
      expect(
        day.ready.topVoices,
        day.items.any((DayItem i) => i.id.startsWith('tv:')),
      );
    });
  });

  group('the roadmap fake', () {
    test(
      'pending and scheduled are mutually exclusive, and both reachable',
      () async {
        // The server documents them as mutually exclusive. The fake pinned
        // `pending` and never set the others, so two of the three branches in
        // roadmap_level.dart were dead.
        final FakeHomeRepository repo = FakeHomeRepository();

        final RoadmapProgress before = await repo.fetchRoadmapProgress();
        expect(before.pendingPostIdToday, isNotNull);
        expect(before.scheduledPostId, isNull);

        // Approving today's post is what flips it — in the planner, on the row
        // both slices read.
        await FakePlannerRepository().approveSlot(
          planId: 'mock-plan-1',
          slotIndex: 0,
        );

        final RoadmapProgress after = await repo.fetchRoadmapProgress();
        expect(after.pendingPostIdToday, isNull);
        expect(after.scheduledPostId, isNotNull);
        expect(after.scheduledPostAt, isNotNull);
      },
    );
  });

  group('the post library fake', () {
    test('pages by the limit it was given', () async {
      // It ignored `limit` and treated any cursor as the end, so the library
      // always had exactly one short page and infinite scroll never fired a
      // second request.
      final FakePostLibraryRepository repo = FakePostLibraryRepository();

      final PostPage first = await repo.fetchPage(limit: 2);
      expect(first.posts, hasLength(2));
      expect(first.hasMore, isTrue);
      expect(first.nextCursor, first.posts.last.id);

      final PostPage second = await repo.fetchPage(
        limit: 2,
        cursor: first.nextCursor,
      );
      expect(second.posts, hasLength(2));
      // The cursor actually advanced.
      expect(
        second.posts.map((LibraryPost p) => p.id),
        isNot(contains(first.posts.first.id)),
      );
    });

    test('walks the whole list and then stops', () async {
      final FakePostLibraryRepository repo = FakePostLibraryRepository();
      final Set<String> seen = <String>{};

      String? cursor;
      for (int guard = 0; guard < 20; guard++) {
        final PostPage page = await repo.fetchPage(limit: 2, cursor: cursor);
        for (final LibraryPost p in page.posts) {
          // A cursor that fails to advance would re-serve a post here.
          expect(seen.add(p.id), isTrue, reason: '${p.id} served twice');
        }
        if (!page.hasMore) break;
        cursor = page.nextCursor;
        expect(cursor, isNotNull);
      }

      final PostPage all = await repo.fetchPage(limit: kPostPageLimit * 10);
      expect(seen.length, all.posts.length);
    });
  });
}

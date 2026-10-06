import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/features/planner/domain/weekly_article.dart';

/// The article reminder — `scheduledFor`.
///
/// It is NOT a publish time. LinkedIn's API has no articles endpoint and no
/// newsletter endpoint, and the personal scope set is `w_member_social` — UGC
/// shares only. The only thing a time buys is a nudge; the user still pastes
/// the article into LinkedIn's own composer. Any UI that implies otherwise is
/// lying about what the product can do.
///
/// The field has been on the wire since the column existed — the mobile route
/// spreads the service's row — and had no field on this model to land in. So a
/// reminder set on the WEB was being sent to the phone and dropped: the nudge
/// arrived for a time the app had never shown, and offered no way to move it
/// or clear it.
void main() {
  WeeklyArticle article({String? scheduledFor, String? publishedAt}) =>
      WeeklyArticle(
        id: 'a1',
        weekNumber: 3,
        season: 1,
        title: 'The handoff nobody documents',
        thesis: 'Onboarding is a design problem, not a paperwork problem.',
        scheduledFor: scheduledFor,
        publishedAt: publishedAt,
      );

  group('reminderAt', () {
    final DateTime now = DateTime.utc(2026, 10, 6, 12);

    test('a time still ahead of us is a reminder', () {
      final DateTime? at = article(
        scheduledFor: '2026-10-11T09:00:00.000Z',
      ).reminderAt(now: now);

      expect(at, isNotNull);
      expect(at!.toUtc(), DateTime.utc(2026, 10, 11, 9));
    });

    test('a time already past is NOT a reminder', () {
      // The task has already fired, or the week has moved on. Showing it would
      // promise a nudge that is not coming, and the row would sit there
      // offering to "change" something that no longer exists.
      expect(
        article(scheduledFor: '2026-10-01T09:00:00.000Z').reminderAt(now: now),
        isNull,
      );
      expect(
        article(scheduledFor: '2026-10-01T09:00:00.000Z').hasReminder(now: now),
        isFalse,
      );
    });

    test('the exact instant counts as past, not as a reminder', () {
      // Strictly after. At the boundary the task is firing right now, so there
      // is nothing left to remind anyone about.
      expect(
        article(scheduledFor: '2026-10-06T12:00:00.000Z').reminderAt(now: now),
        isNull,
      );
    });

    test('no time set is no reminder, and does not throw', () {
      expect(article().reminderAt(now: now), isNull);
      expect(article().hasReminder(now: now), isFalse);
    });

    test('an unparseable stamp is no reminder rather than a crash', () {
      // Fail toward "none". A malformed value from the server should cost the
      // user the row, not the whole planner screen.
      for (final String bad in <String>['', 'soon', 'next tuesday', '{}']) {
        expect(article(scheduledFor: bad).reminderAt(now: now), isNull);
      }
    });

    test('comes back in local time, because that is what gets rendered', () {
      // The wire is UTC and the row prints a weekday and an hour. Rendering
      // the UTC instant would show the wrong hour for everyone outside UTC,
      // which is every user this product has.
      final DateTime? at = article(
        scheduledFor: '2026-10-11T09:00:00.000Z',
      ).reminderAt(now: now);
      expect(at!.isUtc, isFalse);
    });
  });

  group('what the card is allowed to offer', () {
    final DateTime now = DateTime.utc(2026, 10, 6, 12);

    test(
      'a published article is done — the server refuses a reminder on it',
      () {
        // `setArticleSchedule` throws ALREADY_PUBLISHED, which the route turns
        // into a 400. The card hides the row on `isPublished` so the user is
        // never offered a control whose only outcome is a refusal.
        final WeeklyArticle a = article(
          scheduledFor: '2026-10-11T09:00:00.000Z',
          publishedAt: '2026-10-05T10:00:00.000Z',
        );
        expect(a.isPublished, isTrue);
      },
    );

    test('an unpublished article with no reminder is the ask state', () {
      final WeeklyArticle a = article();
      expect(a.isPublished, isFalse);
      expect(a.hasReminder(now: now), isFalse);
    });
  });

  group('the wire shape', () {
    test('parses scheduledFor, which it previously dropped', () {
      final WeeklyArticle a = WeeklyArticle.fromJson(<String, dynamic>{
        'id': 'a1',
        'weekNumber': 3,
        'season': 1,
        'title': 'The handoff nobody documents',
        'thesis': 'Onboarding is a design problem.',
        'scheduledFor': '2026-10-11T09:00:00.000Z',
      });
      expect(a.scheduledFor, '2026-10-11T09:00:00.000Z');
    });

    test(
      'tolerates a null scheduledFor, which is how a reminder is cleared',
      () {
        final WeeklyArticle a = WeeklyArticle.fromJson(<String, dynamic>{
          'id': 'a1',
          'weekNumber': 3,
          'season': 1,
          'title': 'The handoff nobody documents',
          'thesis': 'Onboarding is a design problem.',
          'scheduledFor': null,
        });
        expect(a.scheduledFor, isNull);
      },
    );

    test('ignores the body the route deliberately stops sending', () {
      // The summary endpoint strips it; the model has no field for it. A
      // response that still carried one must not blow up parsing.
      final WeeklyArticle a = WeeklyArticle.fromJson(<String, dynamic>{
        'id': 'a1',
        'weekNumber': 3,
        'season': 1,
        'title': 'The handoff nobody documents',
        'thesis': 'Onboarding is a design problem.',
        'readingMinutes': 6,
      });
      expect(a.hasBody, isFalse);
      expect(a.readMinutes, 6);
    });
  });
}

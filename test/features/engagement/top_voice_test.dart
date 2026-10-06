import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/core/engagement/top_voice_categories.dart';
import 'package:plexaverse/core/week/comment_targets.dart';
import 'package:plexaverse/features/engagement/domain/top_voice.dart';

void main() {
  group('the target clamp', () {
    test('a full day asks for the roadmap target', () {
      expect(
        reachableCommentTarget(
          roadmapTarget: dailyCommentTarget,
          curatedTotal: 5,
        ),
        10,
      );
    });

    test('a thinly-stocked day narrows to what it can actually produce', () {
      // Two curated posts plus five drafts is seven. Asking for ten here is a
      // step the user can never finish, which is the exact failure the
      // hardcoded 3 used to cause one layer down.
      expect(
        reachableCommentTarget(
          roadmapTarget: dailyCommentTarget,
          curatedTotal: 2,
        ),
        7,
      );
    });

    test('no curated posts still leaves the generated half finishable', () {
      // The state every phone-only user was permanently in before the mobile
      // top-voices route existed: five cards against a bar reading ten, and a
      // Finish button that could not enable.
      expect(
        reachableCommentTarget(
          roadmapTarget: dailyCommentTarget,
          curatedTotal: 0,
        ),
        5,
      );
    });

    test('never widens a target the roadmap set lower', () {
      // A company-brand day asks for three. Five curated plus five drafts is
      // ten, and handing the user a bar of ten for a three-comment step would
      // be inventing work.
      expect(reachableCommentTarget(roadmapTarget: 3, curatedTotal: 5), 3);
    });
  });

  group('TopVoiceDay', () {
    TopVoice post(String id, {String? actedAt}) =>
        TopVoice(shownId: id, actedAt: actedAt);

    test('counts only what has been acted on', () {
      final TopVoiceDay day = TopVoiceDay(
        posts: <TopVoice>[
          post('a', actedAt: '2026-10-06T09:00:00Z'),
          post('b'),
          post('c'),
        ],
      );
      expect(day.actedCount, 1);
    });

    test('resumes at the first outstanding post', () {
      final TopVoiceDay day = TopVoiceDay(
        posts: <TopVoice>[
          post('a', actedAt: '2026-10-06T09:00:00Z'),
          post('b', actedAt: '2026-10-06T09:05:00Z'),
          post('c'),
        ],
      );
      expect(day.firstOutstanding, 2);
    });

    test('a finished day resumes at the start rather than off the end', () {
      final TopVoiceDay day = TopVoiceDay(
        posts: <TopVoice>[post('a', actedAt: '2026-10-06T09:00:00Z')],
      );
      // -1 would index out of the list and take the section down on the one
      // day the user has earned the green tick.
      expect(day.firstOutstanding, 0);
    });

    test('withActed stamps one and leaves the rest alone', () {
      final TopVoiceDay day = TopVoiceDay(
        posts: <TopVoice>[post('a'), post('b')],
      );
      final TopVoiceDay next = day.withActed('b');

      expect(next.posts[0].isActed, isFalse);
      expect(next.posts[1].isActed, isTrue);
      expect(next.actedCount, 1);
    });

    test('withActed does not re-stamp an already-acted post', () {
      const String original = '2026-10-06T09:00:00.000Z';
      final TopVoiceDay day = TopVoiceDay(
        posts: <TopVoice>[post('a', actedAt: original)],
      );
      // Plexa may have stamped this minutes ago; overwriting the server's
      // value with "now" would quietly rewrite when the user acted.
      expect(day.withActed('a').posts.single.actedAt, original);
    });

    test('withActed ignores an id that is not in the day', () {
      final TopVoiceDay day = TopVoiceDay(posts: <TopVoice>[post('a')]);
      expect(day.withActed('zzz').actedCount, 0);
    });
  });

  group('TopVoice', () {
    test('falls back to the body when the import caught no opener', () {
      const TopVoice p = TopVoice(postContent: 'A short body.', firstLine: '');
      expect(p.headline, 'A short body.');
    });

    test('truncates a long body used as a headline', () {
      final TopVoice p = TopVoice(postContent: 'x' * 400);
      expect(p.headline.length, 121); // 120 + the ellipsis
      expect(p.headline.endsWith('…'), isTrue);
    });

    test('prints LinkedIn’s own age shorthand', () {
      final DateTime now = DateTime.utc(2026, 10, 6, 12);
      String ageOf(Duration ago) =>
          TopVoice(postedAt: now.subtract(ago).toIso8601String()).age(now: now);

      expect(ageOf(const Duration(minutes: 20)), '20m');
      expect(ageOf(const Duration(hours: 3)), '3h');
      expect(ageOf(const Duration(days: 2)), '2d');
    });

    test('says nothing rather than guessing at an unparseable stamp', () {
      // A wrong age above a real post reads as the product being confused
      // about which post it means.
      expect(const TopVoice(postedAt: 'not a date').age(), '');
      expect(const TopVoice().age(), '');
    });

    test('takes at most two initials, and survives an empty name', () {
      expect(const TopVoice(authorName: 'Priya Raman').initials, 'PR');
      expect(
        const TopVoice(authorName: 'Jean  Claude  Van Damme').initials,
        'JC',
      );
      expect(const TopVoice(authorName: '   ').initials, '?');
    });

    test('a row with no drafted comment still renders', () {
      // The batch writes the row whether or not a comment came back — losing
      // the pick would hand the user the same post tomorrow and charge twice.
      const TopVoice p = TopVoice(shownId: 'a', comment: null);
      expect(p.hasComment, isFalse);
      expect(const TopVoice(comment: '   ').hasComment, isFalse);
    });

    test('parses the wire shape the mobile route sends', () {
      final TopVoice p = TopVoice.fromJson(<String, dynamic>{
        'shownId': 'shown-1',
        'postId': 'tv-1',
        'postUrl': 'https://www.linkedin.com/feed/update/urn:li:share:1',
        'authorName': 'Priya Raman',
        'authorHandle': 'priyaraman',
        'category': 'leadership',
        'postContent': 'A post',
        'firstLine': 'A post',
        'postedAt': '2026-10-06T00:00:00.000Z',
        'comment': 'A comment',
        'actedAt': null,
      });

      expect(p.shownId, 'shown-1');
      expect(p.category, 'leadership');
      expect(p.isActed, isFalse);
    });
  });

  group('the category vocabulary', () {
    test('carries all forty, as ids', () {
      expect(topVoiceCategories.length, 40);
      expect(
        topVoiceCategories.keys.every(
          (String id) => RegExp(r'^[a-z_]+$').hasMatch(id),
        ),
        isTrue,
        reason: 'ids are what the database stores; labels must not leak in',
      );
    });

    test('recognises an id and refuses a label', () {
      // The whole reason this list is closed: the server fails the entire
      // preferences PATCH on an unknown value, so a label here does not
      // narrow the feed — it loses every other field in the same write.
      expect(isTopVoiceCategoryId('artificial_intelligence'), isTrue);
      expect(isTopVoiceCategoryId('Artificial Intelligence'), isFalse);
      expect(isTopVoiceCategoryId('Engineering'), isFalse);
    });

    test('labels an id, and shows an unknown one rather than inventing', () {
      expect(topVoiceCategoryLabel('csr'), 'Corporate Social Responsibility');
      expect(topVoiceCategoryLabel('made_up'), 'made_up');
    });
  });
}

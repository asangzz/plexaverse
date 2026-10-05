import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/core/week/week_shape.dart';

/// The week, as two features read it: the planner draws a day, and the home
/// roadmap decides whether that day gets a "Publish a post" mission.
///
/// Both answers come from this one table, which is the point — they disagreed
/// before, and the way it showed was the roadmap asking for a post on five
/// days of seven that no longer produce one.
void main() {
  group('the shape', () {
    test('two posts, two scripts, one newsletter, two rest days', () {
      // The pivot, counted. If any of these move, the web moved them, and the
      // mobile planner and roadmap both need to know.
      int count(DayKind k) => weekShape.where((DayKind d) => d == k).length;

      expect(count(DayKind.post), 2);
      expect(count(DayKind.videoScript), 2);
      expect(count(DayKind.article), 1);
      expect(count(DayKind.rest), 2);
      expect(weekShape, hasLength(7));
    });

    test('each day is the kind WEEK_SHAPE gives it', () {
      expect(dayKindAt(0), DayKind.post); // Monday
      expect(dayKindAt(1), DayKind.post); // Tuesday — the hero
      expect(dayKindAt(2), DayKind.videoScript); // Wednesday
      expect(dayKindAt(3), DayKind.article); // Thursday — the newsletter
      expect(dayKindAt(4), DayKind.videoScript); // Friday
      expect(dayKindAt(5), DayKind.rest); // Saturday
      expect(dayKindAt(6), DayKind.rest); // Sunday
    });

    test('Sunday is a rest day, and Thursday carries the newsletter', () {
      // Stated on its own because it is the inversion most likely to be got
      // wrong from memory: the article ran on Sunday for the whole life of the
      // product before the pivot.
      expect(isRestDayIndex(6), isTrue);
      expect(dayKindAt(3), DayKind.article);
    });

    test('an out-of-range index clamps rather than throwing', () {
      // Callers index this from a weekday arithmetic they did themselves.
      for (final int i in <int>[-1, 7, 99]) {
        expect(() => dayKindAt(i), returnsNormally);
      }
    });
  });

  group('weekdayIndexForDay', () {
    test('day 1 is the weekday the roadmap started on', () {
      // A Wednesday start — DateTime.weekday 3, so index 2.
      final DateTime wed = DateTime(2026, 10, 7);
      expect(wed.weekday, DateTime.wednesday);
      expect(weekdayIndexForDay(1, wed), 2);
    });

    test('it advances with the day and wraps the week', () {
      final DateTime mon = DateTime(2026, 10, 5);
      expect(mon.weekday, DateTime.monday);
      expect(weekdayIndexForDay(1, mon), 0);
      expect(weekdayIndexForDay(7, mon), 6); // Sunday
      expect(weekdayIndexForDay(8, mon), 0); // back to Monday
    });

    test('a roadmap that began on a Monday posts on days 1 and 2', () {
      // The join the roadmap actually makes: roadmap day → weekday → kind.
      final DateTime mon = DateTime(2026, 10, 5);
      DayKind kindOfDay(int d) => dayKindAt(weekdayIndexForDay(d, mon));

      expect(kindOfDay(1).isPublishable, isTrue);
      expect(kindOfDay(2).isPublishable, isTrue);
      for (final int d in <int>[3, 4, 5, 6, 7]) {
        expect(
          kindOfDay(d).isPublishable,
          isFalse,
          reason: 'day $d must not be asked for a post',
        );
      }
    });
  });

  group('what each kind means', () {
    test('only a post is publishable by us', () {
      expect(DayKind.post.isPublishable, isTrue);
      expect(DayKind.videoScript.isPublishable, isFalse);
      expect(DayKind.article.isPublishable, isFalse);
      expect(DayKind.rest.isPublishable, isFalse);
    });

    test('a hand-off is work we prepare and the user posts', () {
      expect(DayKind.videoScript.isHandoff, isTrue);
      expect(DayKind.article.isHandoff, isTrue);
      expect(DayKind.post.isHandoff, isFalse);
      expect(DayKind.rest.isHandoff, isFalse);
    });
  });

  group('the next posting day', () {
    // The roadmap deep-links "generate the next post" at a planner slot. It
    // used to use (today + 1) % 7, which lands on a video script, the
    // newsletter or a rest day five times in seven — and the planner refuses
    // to generate on every one of them, so the link was a dead end most days.
    int nextAfter(int slot) {
      for (int i = 1; i <= 7; i++) {
        final int c = (slot + i) % 7;
        if (dayKindAt(c) == DayKind.post) return c;
      }
      return slot;
    }

    test('every day of the week points at a day that takes a post', () {
      for (int slot = 0; slot < 7; slot++) {
        expect(
          dayKindAt(nextAfter(slot)).isPublishable,
          isTrue,
          reason: 'from day $slot the link must reach a posting day',
        );
      }
    });

    test('it never points at the day it started from', () {
      for (int slot = 0; slot < 7; slot++) {
        expect(nextAfter(slot), isNot(slot));
      }
    });

    test('from Monday the next one is Tuesday, and from Tuesday it wraps', () {
      expect(nextAfter(0), 1); // Mon -> Tue
      expect(nextAfter(1), 0); // Tue -> Mon, the week's only other post day
      expect(nextAfter(4), 0); // Fri -> Mon, over the weekend
    });
  });
}

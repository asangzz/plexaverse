import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/features/contest/domain/lesson_parts.dart';
import 'package:plexaverse/features/contest/domain/today_quiz.dart';

/// The day's lesson in parts, held to the web's `lib/contest-lesson/parts.ts`
/// — its tests' expectations, copied.
///
/// The path service cuts the day with that function and sends the cut on
/// each node; the player cuts it with this one. If the two ever disagree, a
/// node says "2 of 5 answered" while the player says "Part 3 of 3".
void main() {
  List<int> sizes(int total) =>
      lessonPartBounds(total).map((LessonPart p) => p.size).toList();

  group('lessonPartBounds', () {
    test('cuts a day into three parts', () {
      expect(kLessonParts, 3);
      expect(sizes(15), <int>[5, 5, 5]);
      expect(sizes(10), <int>[3, 3, 4]);
      expect(sizes(5), <int>[1, 2, 2]);
      expect(lessonPartBounds(10), const <LessonPart>[
        LessonPart(index: 0, start: 0, end: 3),
        LessonPart(index: 1, start: 3, end: 6),
        LessonPart(index: 2, start: 6, end: 10),
      ]);
    });

    test('covers every question exactly once, in order', () {
      for (int total = 0; total <= 40; total++) {
        int at = 0;
        final List<LessonPart> parts = lessonPartBounds(total);
        for (int i = 0; i < parts.length; i++) {
          expect(parts[i].index, i);
          expect(parts[i].start, at);
          expect(parts[i].end, greaterThan(parts[i].start));
          at = parts[i].end;
        }
        expect(at, total, reason: 'total $total');
      }
    });

    test('drops empty parts on a tiny day, and has none for an empty one', () {
      expect(lessonPartBounds(2), const <LessonPart>[
        LessonPart(index: 0, start: 0, end: 1),
        LessonPart(index: 1, start: 1, end: 2),
      ]);
      expect(lessonPartBounds(1), const <LessonPart>[
        LessonPart(index: 0, start: 0, end: 1),
      ]);
      expect(lessonPartBounds(0), isEmpty);
      expect(lessonPartBounds(-3), isEmpty);
    });
  });

  group('partOf', () {
    test('finds the part a question is in', () {
      expect(partOf(0, 10)?.index, 0);
      expect(partOf(2, 10)?.index, 0);
      expect(partOf(3, 10)?.index, 1);
      expect(partOf(9, 10)?.index, 2);
      expect(partOf(0, 5), const LessonPart(index: 0, start: 0, end: 1));
      expect(partOf(14, 15), const LessonPart(index: 2, start: 10, end: 15));
    });

    test('is null outside the lesson', () {
      expect(partOf(10, 10), isNull);
      expect(partOf(-1, 10), isNull);
    });
  });

  // ── Skipped parts (owner, 17 Nov 2026) ─────────────────────────────────

  group('lessonPartStates — which questions, not how many', () {
    Set<int> range(int a, int b) => <int>{for (int i = a; i < b; i++) i};
    List<LessonPartState> st(
      int total,
      Set<int> answered, [
      List<int> skipped = const <int>[],
      LessonWhen when = LessonWhen.today,
      bool complete = false,
    ]) => lessonPartStates(
      total: total,
      answered: answered,
      skipped: skipped.toSet(),
      when: when,
      complete: complete,
    ).map((LessonPartView p) => p.state).toList();

    const LessonPartState done = LessonPartState.done;
    const LessonPartState today = LessonPartState.today;
    const LessonPartState skipped = LessonPartState.skipped;
    const LessonPartState locked = LessonPartState.locked;
    const LessonPartState missed = LessonPartState.missed;

    test('no skips, n answered in order: the old count rule, for 10 (3/3/4) '
        'and 15 (5/5/5)', () {
      for (final int total in <int>[10, 15]) {
        final List<LessonPart> parts = lessonPartBounds(total);
        for (int n = 0; n <= total; n++) {
          final List<LessonPartState?> old = <LessonPartState?>[
            for (final LessonPart p in parts) n >= p.end ? done : null,
          ];
          final int firstOpen = old.indexOf(null);
          final List<LessonPartState> expected = <LessonPartState>[
            for (int i = 0; i < old.length; i++)
              old[i] ?? (i == firstOpen ? today : locked),
          ];
          expect(st(total, range(0, n)), expected, reason: '$total, $n');
        }
      }
    });

    test('part 1 skipped, nothing answered: skipped, today, locked', () {
      expect(st(15, <int>{}, <int>[1]), <LessonPartState>[
        skipped,
        today,
        locked,
      ]);
    });

    test('part 1 skipped, part 2 fully answered: skipped, done, today', () {
      expect(st(15, range(5, 10), <int>[1]), <LessonPartState>[
        skipped,
        done,
        today,
      ]);
    });

    test('parts 1 and 2 skipped: part 3 is open', () {
      expect(st(15, <int>{}, <int>[1, 2]), <LessonPartState>[
        skipped,
        skipped,
        today,
      ]);
    });

    test('every part left skipped: none is open', () {
      expect(st(15, range(0, 5), <int>[2, 3]), <LessonPartState>[
        done,
        skipped,
        skipped,
      ]);
    });

    test('a skipped part answered in full later is done', () {
      expect(st(15, range(0, 5), <int>[1]), <LessonPartState>[
        done,
        today,
        locked,
      ]);
    });

    test('complete makes every part done; a past day’s unfinished parts are '
        'missed, a future day’s locked', () {
      expect(
        st(15, <int>{}, <int>[1], LessonWhen.today, true),
        <LessonPartState>[done, done, done],
      );
      expect(st(15, range(0, 5), <int>[2], LessonWhen.past), <LessonPartState>[
        done,
        missed,
        missed,
      ]);
      expect(
        st(15, <int>{}, const <int>[], LessonWhen.future),
        <LessonPartState>[locked, locked, locked],
      );
    });

    test('counts each part’s answered questions', () {
      final List<LessonPartView> views = lessonPartStates(
        total: 15,
        answered: <int>{0, 1, 6},
        skipped: <int>{1},
        when: LessonWhen.today,
        complete: false,
      );
      expect(views.map((LessonPartView v) => v.answeredInPart), <int>[2, 1, 0]);
    });
  });

  group('lesson node ids', () {
    test('skippedPartsOf reads only this day’s lesson ids', () {
      const List<String> ids = <String>[
        '2026-11-02:lesson:1',
        '2026-11-02:lesson:3',
        '2026-11-01:lesson:2',
        '2026-11-02:comment',
        '2026-11-02:lesson:x',
        '2026-11-02:lesson:2:extra',
        '2026-11-02:lesson:0',
      ];
      expect(skippedPartsOf(ids, '2026-11-02'), <int>{1, 3});
    });

    test('lessonNodeId round-trips through skippedPartsOf', () {
      expect(lessonNodeId('2026-11-17', 2), '2026-11-17:lesson:2');
      expect(
        skippedPartsOf(<String>[lessonNodeId('2026-11-17', 2)], '2026-11-17'),
        <int>{2},
      );
    });

    test('answered indexes are read off the item ids; an unknown id is '
        'ignored', () {
      const List<PublicQuizItem> qs = <PublicQuizItem>[
        PublicQuizItem(id: 'a'),
        PublicQuizItem(id: 'b'),
        PublicQuizItem(id: 'c'),
        PublicQuizItem(id: 'd'),
      ];
      expect(answeredIndexesOf(qs, <String>['c', 'a', 'zz']), <int>{0, 2});
    });
  });
}

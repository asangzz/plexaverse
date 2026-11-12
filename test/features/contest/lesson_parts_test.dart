import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/features/contest/domain/lesson_parts.dart';

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
}

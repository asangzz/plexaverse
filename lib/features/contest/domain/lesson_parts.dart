/// A day's lesson in parts — the checkpoints on the path.
///
/// A port of the web's `lib/contest-lesson/parts.ts`. The lesson is ONE run of
/// questions on the server, answered in order; the parts are a way of cutting
/// that run, and the path service and the player must cut it the same way or
/// a node's "2 of 5 answered" and the player's "Part 2 of 3" disagree. The
/// path sends its cut on each node (`NodePart.start`/`end`) and that wins
/// when present; this is for the player, and for a node from a server that
/// sent none.
library;

/// How many parts a day's lesson is cut into.
const int kLessonParts = 3;

/// One part: the half-open range `[start, end)` of the day's ordered
/// questions. [index] is 0-based.
class LessonPart {
  const LessonPart({
    required this.index,
    required this.start,
    required this.end,
  });

  final int index;
  final int start;
  final int end;

  int get size => end - start;

  bool contains(int questionIndex) =>
      questionIndex >= start && questionIndex < end;

  @override
  bool operator ==(Object other) =>
      other is LessonPart &&
      other.index == index &&
      other.start == start &&
      other.end == end;

  @override
  int get hashCode => Object.hash(index, start, end);

  @override
  String toString() => 'LessonPart($index: $start–$end)';
}

/// The day's parts for a lesson of [total] questions: part k is
/// `[floor(k·total/3), floor((k+1)·total/3))` — 15 → 5/5/5, 10 → 3/3/4,
/// 5 → 1/2/2. An empty part is dropped (a lesson of fewer than three
/// questions has fewer parts) and the rest renumbered from 0.
List<LessonPart> lessonPartBounds(int total) {
  final int n = total < 0 ? 0 : total;
  final List<LessonPart> out = <LessonPart>[];
  for (int k = 0; k < kLessonParts; k++) {
    final int start = (k * n) ~/ kLessonParts;
    final int end = ((k + 1) * n) ~/ kLessonParts;
    if (end > start) {
      out.add(LessonPart(index: out.length, start: start, end: end));
    }
  }
  return out;
}

/// The part question [index] (0-based) falls in, or null outside the lesson.
LessonPart? partOf(int index, int total) {
  for (final LessonPart p in lessonPartBounds(total)) {
    if (p.contains(index)) return p;
  }
  return null;
}

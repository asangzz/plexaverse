/// A day's lesson in parts — the checkpoints on the path.
///
/// A port of the web's `lib/contest-lesson/parts.ts`. The lesson is ONE run of
/// questions on the server; the parts are a way of cutting that run, and the
/// path service and the player must cut it the same way or a node's "2 of 5
/// answered" and the player's "Part 2 of 3" disagree. The path sends its cut
/// on each node (`NodePart.start`/`end`) and that wins when present; this is
/// for the player, and for a node from a server that sent none.
///
/// ## Which part is where is decided by WHICH questions are answered
///
/// Parts are answered in order, except a part the learner skipped (17 Nov
/// 2026), which stays open beside the next. So a part's state follows the
/// questions answered in it — never a count of the day's answers.
/// [lessonPartStates] is the one rule the server's answer endpoint, the path
/// and the player share.
library;

import 'today_quiz.dart';

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

/// A lesson part's node id: the one the path draws and a skip is keyed on.
/// [k] is 1-based.
String lessonNodeId(String dayKey, int k) => '$dayKey:lesson:$k';

/// The 1-based part numbers skipped on [dayKey], read off that day's skipped
/// node ids — an exact match of `<dayKey>:lesson:<digits>`, so another day's
/// id or a task's never counts.
Set<int> skippedPartsOf(Iterable<String> ids, String dayKey) {
  final Set<int> out = <int>{};
  final String prefix = '$dayKey:lesson:';
  final RegExp digits = RegExp(r'^\d+$');
  for (final String id in ids) {
    if (!id.startsWith(prefix)) continue;
    final String rest = id.substring(prefix.length);
    if (!digits.hasMatch(rest)) continue;
    final int? k = int.tryParse(rest);
    if (k != null && k >= 1) out.add(k);
  }
  return out;
}

/// The 0-based indexes in [questions] of the answers [answeredIds] cover. An
/// id not in the day's questions is ignored.
Set<int> answeredIndexesOf(
  List<PublicQuizItem> questions,
  Iterable<String> answeredIds,
) {
  final Set<String> ids = answeredIds.toSet();
  return <int>{
    for (int i = 0; i < questions.length; i++)
      if (ids.contains(questions[i].id)) i,
  };
}

/// Where a lesson part stands. Mirrors `LessonPartState`.
enum LessonPartState { done, today, skipped, locked, missed }

/// Which day a lesson's parts are reckoned for, against today.
enum LessonWhen { past, today, future }

/// One part, and where it stands. Mirrors `LessonPartView`.
class LessonPartView extends LessonPart {
  const LessonPartView({
    required super.index,
    required super.start,
    required super.end,
    required this.state,
    required this.answeredInPart,
  });

  final LessonPartState state;

  /// How many of the part's questions are answered.
  final int answeredInPart;

  @override
  bool operator ==(Object other) =>
      other is LessonPartView &&
      super == other &&
      other.state == state &&
      other.answeredInPart == answeredInPart;

  @override
  int get hashCode => Object.hash(super.hashCode, state, answeredInPart);

  @override
  String toString() =>
      'LessonPartView($index: $start–$end, ${state.name}, $answeredInPart)';
}

/// Each part's state — the one rule for the path, the server and the player.
///
/// - done: every question in it answered, or the day [complete];
/// - past, not done → missed; future → locked;
/// - today: a [skipped] part (1-based) → skipped; the first part neither done
///   nor skipped → today (the open one); every later such part → locked.
List<LessonPartView> lessonPartStates({
  required int total,
  required Set<int> answered,
  required Set<int> skipped,
  required LessonWhen when,
  required bool complete,
}) {
  bool openFound = false;
  return <LessonPartView>[
    for (final LessonPart p in lessonPartBounds(total))
      () {
        int inPart = 0;
        for (int i = p.start; i < p.end; i++) {
          if (answered.contains(i)) inPart++;
        }
        LessonPartState state;
        if (complete || inPart >= p.size) {
          state = LessonPartState.done;
        } else if (when == LessonWhen.past) {
          state = LessonPartState.missed;
        } else if (when == LessonWhen.future) {
          state = LessonPartState.locked;
        } else if (skipped.contains(p.index + 1)) {
          state = LessonPartState.skipped;
        } else if (!openFound) {
          state = LessonPartState.today;
          openFound = true;
        } else {
          state = LessonPartState.locked;
        }
        return LessonPartView(
          index: p.index,
          start: p.start,
          end: p.end,
          state: state,
          answeredInPart: inPart,
        );
      }(),
  ];
}

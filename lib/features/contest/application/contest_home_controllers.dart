import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/contest_repository.dart';
import '../domain/lesson_parts.dart';

part 'contest_home_controllers.g.dart';

// The levels page's own state: which Plexa moment greets the learner, and
// which level's card is open. Everything the page DRAWS comes from the shared
// reads in contest_controllers.dart; nothing here restates a server rule.
//
// There is no join any more (owner, 24 Nov 2026): reading the overview
// enters the learner in the running round, so the join card and its action
// are gone.

// ── Plexa's moment ──────────────────────────────────────────────────────────

/// Which Plexa moment greets the learner on the contest page. Decoration
/// only — the stats bar and the path still say in words what happened.
///
/// The web's fourth running moment, the weekend rest day, is not here: every
/// contest day carries a lesson, so it cannot fire, and its clip is not
/// bundled.
enum ContestMoment {
  /// The first minutes after joining: a gold ticket.
  joined,

  /// The streak went back to zero after there was one.
  streakReset,

  /// A streak milestone.
  streakFlame,

  /// The contest is over: final standings.
  finale,
}

/// How long after joining the page still greets the new entrant. The web's
/// `JUST_JOINED_MS`.
const Duration kJustJoinedFor = Duration(minutes: 10);

/// Streak lengths Plexa celebrates (`PLEXA_STORYBOARD.md` §2 on the web).
const Set<int> kStreakMilestones = <int>{3, 7, 14, 20};

/// Joined in the last [kJustJoinedFor], on the device's clock against the
/// server's `joinedAt` — as the web compares them. A join stamped after
/// [now] (a phone clock running behind) greets nobody, as on the web.
bool isJustJoined(ContestEntryView entry, DateTime now) {
  final Duration since = now.difference(entry.joinedAt);
  return !since.isNegative && since < kJustJoinedFor;
}

/// The moment above a running entrant's path; the first match wins. The
/// web's `runningMoment`.
///
/// Nothing remembers that a moment was seen: the flame and the shrug play
/// on every visit while their condition holds, exactly as on the web.
ContestMoment? runningMoment(ContestEntryView entry, DateTime now) {
  if (isJustJoined(entry, now)) return ContestMoment.joined;
  if (entry.streak == 0 && entry.bestStreak > 0) {
    return ContestMoment.streakReset;
  }
  if (kStreakMilestones.contains(entry.streak)) {
    return ContestMoment.streakFlame;
  }
  return null;
}

/// The moment on an entrant's page before day 1 or after the last day: the
/// finale once it has ended, the ticket in the first minutes after joining.
ContestMoment? quietMoment(ContestOverview overview, DateTime now) {
  final ContestEntryView? entry = overview.entry;
  if (overview.phase == ContestPhase.ended) return ContestMoment.finale;
  if (entry != null && isJustJoined(entry, now)) return ContestMoment.joined;
  return null;
}

// ── Today's lesson, as the path reads it ────────────────────────────────────

/// How far through today's lesson the learner is, and how many they got
/// right — what the current part's START ring and the "get N right" quest
/// read. The web's `useLessonProgress`.
class LessonProgress {
  const LessonProgress({
    required this.answered,
    required this.total,
    required this.correct,
    this.answeredIndexes,
  });

  final int answered;
  final int total;
  final int correct;

  /// WHICH questions are answered, by index in lesson order — after a skip
  /// the answers need not be a prefix, so a part's ring counts these.
  final Set<int>? answeredIndexes;
}

/// Null until the lesson is readable: not ready, or no questions yet. The
/// right count is the server's score when it sent one, else the answers
/// marked right — never a grade made here.
LessonProgress? lessonProgressOf(TodayQuiz? quiz) {
  if (quiz == null || !quiz.isReady || quiz.total == 0) return null;
  return LessonProgress(
    answered: quiz.answeredCount,
    total: quiz.total,
    answeredIndexes: answeredIndexesOf(
      quiz.questions,
      quiz.answered.map((QuizAnswerView a) => a.itemId),
    ),
    correct:
        quiz.score?.correct ??
        quiz.answered.where((QuizAnswerView a) => a.correct).length,
  );
}

// ── The node card ───────────────────────────────────────────────────────────

/// The path level whose card is open, or null. One card at a time: opening a
/// level closes the last one, and a second tap on the same level closes it.
///
/// Dies with the path, so the page opens with every card shut — as the web's
/// does on each visit.
@riverpod
class ContestOpenNode extends _$ContestOpenNode {
  @override
  String? build() => null;

  void toggle(String id) => state = state == id ? null : id;

  void close() => state = null;
}

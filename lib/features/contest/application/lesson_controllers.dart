import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/contest_repositories.dart';
import '../domain/contest_repository.dart';
import '../domain/contest_words.dart';
import '../domain/lesson_parts.dart';
import 'contest_controllers.dart';
import 'skip_controllers.dart';

part 'lesson_controllers.g.dart';

// Today's lesson, one question at a time — the web's `ContestQuiz.tsx`.
//
// Everything the player decides lives on [LessonRun]: which question is on
// screen, what was picked, what is in flight, which refusal belongs to which
// question. The widgets draw it. Every verdict, every point and every
// "finished" is the server's; this file only remembers what the server said.

// ── Where a visit is ────────────────────────────────────────────────────────

/// Where a visit is: on one of the day's questions, or on its score.
sealed class LessonAt {
  const LessonAt();
}

/// On question [index] (0-based, in lesson order).
final class AtQuestion extends LessonAt {
  const AtQuestion(this.index);

  final int index;

  @override
  bool operator ==(Object other) => other is AtQuestion && other.index == index;

  @override
  int get hashCode => index.hashCode;

  @override
  String toString() => 'AtQuestion($index)';
}

/// On the day's score.
final class AtScore extends LessonAt {
  const AtScore();

  @override
  bool operator ==(Object other) => other is AtScore;

  @override
  int get hashCode => 0;

  @override
  String toString() => 'AtScore';
}

/// Parked: every part still to do was skipped, and the learner came in
/// without asking for one (17 Nov 2026). The screen says what is still open
/// and offers each skipped part.
final class AtParked extends LessonAt {
  const AtParked();

  @override
  bool operator ==(Object other) => other is AtParked;

  @override
  int get hashCode => 1;

  @override
  String toString() => 'AtParked';
}

/// Where the learner asked to be, tagged with the contest day it belongs to.
///
/// Left to "the first unanswered question", the screen would jump past a
/// reveal the moment its answer was counted — so Check pins the question it
/// answers and only Continue moves on. The day is the pin's expiry: a lesson
/// left open past midnight re-reads as a new day's, and a pin from yesterday
/// falls away by itself.
class LessonPin {
  const LessonPin(this.day, this.at);

  final int? day;
  final LessonAt at;
}

/// The checkpoint screen after part [part] (0-based), tagged like the pin.
class LessonCheckpoint {
  const LessonCheckpoint(this.day, this.part);

  final int? day;
  final int part;
}

/// The option picked on a question, before Check. It belongs to the question
/// it was picked on: the player is not rebuilt per question (Plexa plays the
/// lesson as one take inside it), so a pick tagged with its question reads as
/// nothing on any other.
class LessonPick {
  const LessonPick(this.itemId, this.value);

  final String itemId;
  final String value;
}

/// A refusal, held against the question it was sent for. A screen shows it
/// only on that question: NOT_TODAY brings a new day's lesson, and its words
/// must not sit under a question the learner has not answered yet.
class LessonProblem {
  const LessonProblem(this.itemId, this.message);

  final String itemId;
  final String message;
}

/// What the player has in flight. One thing at a time.
enum LessonWork {
  /// `POST /contest/lesson`: the day's first open writes the learner's own
  /// questions with a model call. Nothing can be answered until it lands.
  opening,

  /// The open failed and the read stands in for it.
  loading,

  /// One answer, and — when it was refused — the read that follows.
  answering,

  /// Skipping the open part (`POST /contest/skip`), and the reads after it.
  skipping,
}

// ── An answer as the player shows it ────────────────────────────────────────

/// Whether the answer that finished the day earned the finishing bonus.
class FinishOutcome {
  const FinishOutcome({required this.earned, required this.minCorrect});

  final bool earned;

  /// What the bonus needs — "No bonus for finishing: it needs 9 right."
  final int minCorrect;
}

/// A question's answer as the player shows it: the server's record of it on a
/// resume, or this visit's reply, which also says what the answer moved.
///
/// Every field is the server's. Nothing in the contest decides right from
/// wrong by comparing the pick with anything — the verdict arrives with
/// [correct] and the option to paint green with [correctOption].
/// `test/features/contest/no_client_grading_test.dart` holds the slice to it.
class LessonAnswer {
  const LessonAnswer({
    required this.value,
    required this.correct,
    required this.correctOption,
    required this.explain,
    this.pointsApplied,
    this.completed = false,
    this.bonus,
    this.weekBonus,
  });

  /// A resumed answer: the record, and what the ledger paid its own event.
  factory LessonAnswer.recorded(QuizAnswerView record) => LessonAnswer(
    value: record.value,
    correct: record.correct,
    correctOption: record.correctOption,
    explain: record.explain,
    pointsApplied: record.pointsApplied,
  );

  /// The option the record holds — on a replay, the first attempt's, which
  /// may not be the one this device sent.
  final String value;
  final bool correct;
  final String correctOption;
  final String explain;

  /// What the ledger paid, never what scoring is doing now. For an answer
  /// given on this visit, everything it moved — the day credit and the
  /// finishing and week bonuses when it brought them; for a resumed one, its
  /// own event. Null: given while scoring was paused, and never paid.
  final int? pointsApplied;

  /// This visit's answer finished the day.
  final bool completed;

  /// Only on the answer that finished the day on this visit, when the
  /// contest pays a finishing bonus.
  final FinishOutcome? bonus;

  /// What the week's bonus paid, when this visit's answer completed the
  /// week; 0 while scoring was paused. Null otherwise.
  final int? weekBonus;
}

/// The line under the verdict about XP — what the ledger paid this answer,
/// whenever it was given. The web's `pointsLine`, its words verbatim.
///
/// It follows the answer, never whether scoring is paused now: an answer
/// paid at 09:00 and reread after the free days ran out still shows what it
/// was paid. One the ledger holds nothing for says only "Not scored." — a
/// longer account is where "until you have a plan" crept in on the web,
/// which read as these answers scoring later. They never do.
///
/// "With the bonus for finishing" only when the finish earned it: the bonus
/// needs a minimum of right answers, and a last answer short of it must not
/// claim one that was never paid.
String? lessonPointsLine(LessonAnswer answer) {
  final int? points = answer.pointsApplied;
  if (points == null) return 'Not scored.';
  final String? figure = points == 0 ? null : contestXp(points);
  final FinishOutcome? bonus = answer.bonus;
  if (answer.completed && bonus != null) {
    if (bonus.earned) {
      return figure == null ? null : '$figure, with the bonus for finishing';
    }
    final String missed =
        'No bonus for finishing: it needs ${formatCount(bonus.minCorrect)} right.';
    return figure == null ? missed : '$figure. $missed';
  }
  return figure;
}

// ── The run ─────────────────────────────────────────────────────────────────

/// Today's lesson as the player holds it, and everything the screen decides
/// from it.
///
/// [quiz] is the run's OWN copy — from the open, then from the reads it
/// makes after each answer. Not `todayQuizProvider`: the resume refresher and
/// every contest write re-read that one, and a lesson that moved whenever
/// something else re-read it would jump under the learner's finger.
class LessonRunState {
  LessonRunState({
    this.quiz,
    this.loadError,
    this.local = const <String, LessonAnswer>{},
    this.pin,
    this.checkpoint,
    this.picked,
    this.redrawn = false,
    this.work,
    this.problem,
    this.requestedPart,
  });

  /// Null until the lesson is in — and for good when it could not be read.
  final TodayQuiz? quiz;

  /// Why the lesson could not be read at all, in one sentence.
  final String? loadError;

  /// Answers given on this visit, by question id. They win over the read's
  /// record of the same answer: the reply says everything it moved.
  final Map<String, LessonAnswer> local;
  final LessonPin? pin;
  final LessonCheckpoint? checkpoint;
  final LessonPick? picked;

  /// The last answer met STALE_QUIZ: the questions were redrawn for the
  /// learner's level, and the screen says so until the next move.
  final bool redrawn;
  final LessonWork? work;
  final LessonProblem? problem;

  /// The part (1-based) the visit was opened for — `?part=k`, a skipped
  /// part's own link. Null for a plain visit.
  final int? requestedPart;

  bool get isBusy => work != null;

  /// The lesson is still on its way in — the skeleton's time.
  bool get isLoading => quiz == null && loadError == null;

  /// The contest day the questions were loaded for, sent back with each
  /// answer.
  int? get day => quiz?.day;

  /// Today's questions, in lesson order. Empty unless the lesson is ready.
  List<PublicQuizItem> get questions => switch (quiz) {
    final TodayQuiz q when q.isReady => q.questions,
    _ => const <PublicQuizItem>[],
  };

  /// Every answered question's answer: the read's record, with this visit's
  /// replies over it.
  late final Map<String, LessonAnswer> answers = <String, LessonAnswer>{
    for (final QuizAnswerView a in quiz?.answered ?? const <QuizAnswerView>[])
      a.itemId: LessonAnswer.recorded(a),
    for (final PublicQuizItem q in questions)
      if (local[q.id] case final LessonAnswer mine) q.id: mine,
  };

  /// The first question in lesson order with no answer; null once every one
  /// has one. Only "is the day finished": which question can be answered is
  /// [isReachable]'s, part by part.
  late final int? firstUnanswered = () {
    for (int i = 0; i < questions.length; i++) {
      if (!answers.containsKey(questions[i].id)) return i;
    }
    return null;
  }();

  /// The day's lesson is done: every question answered, or the server says
  /// so.
  bool get finished =>
      questions.isNotEmpty &&
      (firstUnanswered == null || (quiz?.completed ?? false));

  /// The answered questions, by index in lesson order — WHICH ones, never
  /// how many.
  late final Set<int> answeredIdx = <int>{
    for (int i = 0; i < questions.length; i++)
      if (answers.containsKey(questions[i].id)) i,
  };

  /// The parts as [skipped] would leave them, by `lessonPartStates` — the
  /// rule the path and the answer endpoint share.
  List<LessonPartView> partStatesWith(Set<int> skipped) => lessonPartStates(
    total: questions.length,
    answered: answeredIdx,
    skipped: skipped,
    when: LessonWhen.today,
    complete: quiz?.completed ?? false,
  );

  /// Each part: done, the open one (`today`), skipped (still open beside
  /// it), or locked.
  late final List<LessonPartView> partStates = partStatesWith(
    (quiz?.skippedParts ?? const <int>[]).toSet(),
  );

  /// The part question [i] is in.
  LessonPartView? partAt(int i) {
    for (final LessonPartView p in partStates) {
      if (p.contains(i)) return p;
    }
    return null;
  }

  /// Question [i] is in a part that can be answered now: the open one or a
  /// skipped one.
  bool playable(int i) => switch (partAt(i)?.state) {
    LessonPartState.today || LessonPartState.skipped => true,
    _ => false,
  };

  /// The first unanswered question of [part], or null when it has none.
  int? firstOpenIn(LessonPart part) {
    for (int i = part.start; i < part.end && i < questions.length; i++) {
      if (!answeredIdx.contains(i)) return i;
    }
    return null;
  }

  /// Can question [i] be opened: answered, or the next to answer in a part
  /// that is open or skipped. Within a part, one at a time is the format.
  bool isReachable(int i) {
    if (i < 0 || i >= questions.length) return false;
    if (answeredIdx.contains(i)) return true;
    final LessonPartView? p = partAt(i);
    return p != null && playable(i) && i == firstOpenIn(p);
  }

  /// Where a visit opens: the part asked for ([want], 1-based) if it is open
  /// or skipped, else the open part, else parked on the skipped ones — or
  /// the score once the day is finished.
  LessonAt openingFor(int? want) {
    if (finished) return const AtScore();
    if (want != null && want >= 1 && want <= partStates.length) {
      final LessonPartView asked = partStates[want - 1];
      if (asked.state == LessonPartState.skipped ||
          asked.state == LessonPartState.today) {
        final int? i = firstOpenIn(asked);
        if (i != null) return AtQuestion(i);
      }
    }
    for (final LessonPartView p in partStates) {
      if (p.state != LessonPartState.today) continue;
      final int? i = firstOpenIn(p);
      if (i != null) return AtQuestion(i);
    }
    return const AtParked();
  }

  /// Where a fresh visit opens.
  LessonAt get opening => openingFor(requestedPart);

  /// Where the screen is: the pin, while it still names a screen this lesson
  /// has; else where a fresh visit opens.
  ///
  /// A pinned question must be [isReachable] — questions not reached yet
  /// cannot be opened.
  late final LessonAt at = () {
    final LessonPin? p = pin;
    if (p == null || p.day != day) return opening;
    return switch (p.at) {
      AtScore() => opening,
      AtParked() => finished ? const AtScore() : const AtParked(),
      AtQuestion(:final int index) => isReachable(index) ? p.at : opening,
    };
  }();

  /// The checkpoint to show, if one is up: only between two parts, only for
  /// this day's questions, and only while the day is not finished.
  LessonPart? get shownCheckpoint {
    final LessonCheckpoint? c = checkpoint;
    if (c == null || c.day != day || at is! AtQuestion || finished) {
      return null;
    }
    final List<LessonPart> parts = lessonPartBounds(questions.length);
    return c.part + 1 < parts.length ? parts[c.part] : null;
  }

  /// Right answers so far, by the server's verdicts.
  int get correctCount => questions
      .where((PublicQuizItem q) => answers[q.id]?.correct ?? false)
      .length;

  /// Right answers in a row up to and including question [index] (once it
  /// is answered), for the header's "N in a row" — counted back from there.
  /// The one figure the player counts itself, and only for the header.
  int rightInARow(int index) {
    int n = 0;
    for (int i = index; i >= 0 && i < questions.length; i--) {
      final LessonAnswer? a = answers[questions[i].id];
      if (a == null) {
        if (i == index) continue;
        break;
      }
      if (!a.correct) break;
      n++;
    }
    return n;
  }

  /// Where Continue leads from question [index]: on within its part (an
  /// answered question, or the part's next to answer); else, when rereading,
  /// on to the next answered question; else where a fresh visit would open —
  /// the open part, parked, or the score.
  ///
  /// Not on to an answered question after answering [index] on THIS visit: a
  /// part come back to after a skip is followed by parts already done, and
  /// finishing it must go to the open part (or the score), not page through
  /// answered questions.
  LessonAt nextFrom(int index) {
    final int n = index + 1;
    if (n < questions.length) {
      final LessonPartView? p = partAt(index);
      if (p != null &&
          n < p.end &&
          (answeredIdx.contains(n) || n == firstOpenIn(p))) {
        return AtQuestion(n);
      }
      if (answeredIdx.contains(n) && !local.containsKey(questions[index].id)) {
        return AtQuestion(n);
      }
    }
    return openingFor(null);
  }

  /// The pick on [itemId], or null.
  String? pickFor(String itemId) {
    final LessonPick? p = picked;
    return p != null && p.itemId == itemId ? p.value : null;
  }

  /// The refusal sent for [itemId], or null.
  String? problemFor(String itemId) {
    final LessonProblem? p = problem;
    return p != null && p.itemId == itemId ? p.message : null;
  }

  LessonRunState copyWith({
    TodayQuiz? quiz,
    Map<String, LessonAnswer>? local,
    LessonPin? pin,
    LessonCheckpoint? checkpoint,
    LessonPick? picked,
    bool? redrawn,
    LessonWork? work,
    LessonProblem? problem,
    bool clearPin = false,
    bool clearCheckpoint = false,
    bool clearPick = false,
    bool clearWork = false,
    bool clearProblem = false,
    int? requestedPart,
    bool clearRequested = false,
  }) => LessonRunState(
    quiz: quiz ?? this.quiz,
    loadError: loadError,
    local: local ?? this.local,
    pin: clearPin ? null : (pin ?? this.pin),
    checkpoint: clearCheckpoint ? null : (checkpoint ?? this.checkpoint),
    picked: clearPick ? null : (picked ?? this.picked),
    redrawn: redrawn ?? this.redrawn,
    work: clearWork ? null : (work ?? this.work),
    problem: clearProblem ? null : (problem ?? this.problem),
    requestedPart: clearRequested
        ? null
        : (requestedPart ?? this.requestedPart),
  );
}

/// One visit to today's lesson.
///
/// ## The open comes first, and is waited for
///
/// Building this POSTs the open, and nothing can be answered until it lands.
/// The day's first open writes the learner's own questions with a model call;
/// an answer that reached the server first would create the day's row
/// without them, and the open only writes them while nothing is answered —
/// so the day would be the set questions alone, for good. If the open fails,
/// the read stands in, and the set questions are the lesson: a model hiccup
/// never costs a streak.
///
/// ## One open per visit
///
/// The open is held alive while it runs. Backing out mid-open and coming
/// straight back finds the same run still waiting on the same request — a
/// second POST would claim a second attempt and pay for a second model call
/// for the same five questions. Once it lands, leaving disposes the run, and
/// the next visit opens again (cheaply: the questions are already written).
///
/// ## Answers in order, as text
///
/// [answer] sends the option's TEXT — each learner sees their own order, so
/// an index would re-point — for the question on screen, and only while it
/// is the next to answer in a part that is open or skipped. The reveal is the
/// reply: a replay shows the RECORDED answer, never this device's pick.
///
/// ## A part can be skipped
///
/// [skipPart] skips the open part (`POST /contest/skip`); it stays open beside
/// the next one until the day ends. [request] opens a visit on a skipped
/// part — a skipped node's own link. A LOCKED refusal (an answer in a part
/// neither open nor skipped: another device moved on) drops the pin, as
/// NOT_TODAY does, and the re-read reopens where the parts now say.
@riverpod
class LessonRun extends _$LessonRun {
  /// Counts the reads after answers, so one that lands late never replaces a
  /// newer one — the read after the last answer is what carries the score.
  int _reads = 0;

  /// The part this visit was opened for — [request]'s. Copied into every
  /// state the open builds.
  int? _requested;

  @override
  LessonRunState build() {
    unawaited(_open());
    return LessonRunState(work: LessonWork.opening);
  }

  ContestRepository get _repo => ref.read(contestRepositoryProvider);

  /// Open this visit on part [part] (1-based) — `?part=k`. Safe to call from
  /// a page's `initState`: it only records the wish, and the open copies it
  /// into the state it builds. A lesson already in takes it a moment later.
  void request(int? part) {
    _requested = part;
    if (state.quiz == null || state.requestedPart == part) return;
    Future<void>.microtask(() {
      if (!ref.mounted) return;
      state = state.copyWith(requestedPart: part, clearRequested: part == null);
    });
  }

  /// The error screen's "Try again": open the lesson again.
  void retry() {
    if (state.isBusy) return;
    state = LessonRunState(work: LessonWork.opening);
    unawaited(_open());
  }

  Future<void> _open() async {
    // Pinned while the request runs — see "One open per visit".
    final link = ref.keepAlive();
    try {
      TodayQuiz quiz;
      try {
        quiz = await _repo.startLesson();
        if (!ref.mounted) return;
        // Opening can write the day's own questions, which changes the day's
        // size — and so where the path cuts its parts.
        ref.invalidate(contestPathProvider);
        ref.invalidate(todayQuizProvider);
      } on Object {
        if (!ref.mounted) return;
        // Not running, not entered, or the open itself failed: the read
        // says which screen this is.
        state = LessonRunState(work: LessonWork.loading);
        quiz = await _repo.fetchTodayQuiz();
        if (!ref.mounted) return;
      }
      state = LessonRunState(quiz: quiz, requestedPart: _requested);
    } on Object catch (e) {
      if (!ref.mounted) return;
      state = LessonRunState(loadError: contestMessage(e));
    } finally {
      link.close();
    }
  }

  /// The question on screen, when it can be answered now: unanswered, and
  /// the next to answer in a part that is open or skipped.
  int? _answerable(LessonRunState s) {
    final LessonAt at = s.at;
    if (at is! AtQuestion) return null;
    final int index = at.index;
    if (index >= s.questions.length) return null;
    if (s.answeredIdx.contains(index) || !s.isReachable(index)) return null;
    return index;
  }

  /// Pick [value] on the question on screen. Nothing is sent until Check.
  void pick(String value) {
    final LessonRunState s = state;
    final int? index = _answerable(s);
    if (s.isBusy || index == null) return;
    state = s.copyWith(picked: LessonPick(s.questions[index].id, value));
  }

  /// Check: answer the question on screen with [value], the option's text.
  Future<void> answer(String value) async {
    final LessonRunState s = state;
    final int? day = s.day;
    final int? index = _answerable(s);
    // In order within a part: the question on screen, and only while it is
    // its part's next to answer. Never during the open, never twice at once.
    if (s.isBusy || day == null || index == null || value.isEmpty) return;
    final PublicQuizItem item = s.questions[index];

    // Held while it runs: leaving mid-answer must not lose the re-read of the
    // standing it moved.
    final link = ref.keepAlive();
    // Pinned before sending: once counted, it stops being "the next to
    // answer" and the screen must stay on its reveal.
    state = s.copyWith(
      work: LessonWork.answering,
      pin: LessonPin(day, AtQuestion(index)),
      redrawn: false,
      clearProblem: true,
    );
    try {
      final QuizAnswerResult result = await _repo.answerQuiz(
        day: day,
        itemId: item.id,
        value: value,
      );
      if (!ref.mounted) return;
      state = state.copyWith(
        clearWork: true,
        clearPick: true,
        local: <String, LessonAnswer>{
          ...state.local,
          item.id: _fromReply(result, item, value),
        },
      );
      // The total moved, and the last answer moves the streak, the path and
      // the board with it.
      refreshContestStanding(ref.invalidate);
      // The answer that finishes today's lesson is what opens "Learners of
      // the week" on the contest page (the web's useAnswerContestQuiz). Only
      // that one: the page stays alive under the lesson, so re-reading on
      // every answer would be fifteen reads that cannot change anything.
      if (result.completed) ref.invalidate(contestFeaturedProvider);
      unawaited(_reread());
    } on ContestNotToday {
      if (!ref.mounted) return;
      // The contest day rolled over since the lesson was loaded. A new day
      // has to be OPENED, not just read — read alone, its first answer would
      // fix it to the set questions.
      state = LessonRunState(work: LessonWork.opening);
      unawaited(_open());
    } on ContestLocked {
      if (!ref.mounted) return;
      // A part that is not open — another device moved on, or the parts were
      // re-cut. Not an error to show: the pin drops, as for NOT_TODAY, and
      // the re-read reopens the visit where the parts now say.
      state = state.copyWith(clearPin: true, clearPick: true);
      ref.invalidate(contestPathProvider);
      await _reread();
      if (!ref.mounted) return;
      state = state.copyWith(clearWork: true);
    } on ContestStale {
      if (!ref.mounted) return;
      // Redrawn for the learner's level since they loaded. Not an error: the
      // pin drops so the screen opens on the new set's first question, and
      // one line says why.
      state = state.copyWith(clearPin: true, clearPick: true, redrawn: true);
      await _reread();
      if (!ref.mounted) return;
      state = state.copyWith(clearWork: true);
    } on Object catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(
        problem: LessonProblem(item.id, contestMessage(e)),
      );
      // Whatever refused it may have moved the lesson — or the answer landed
      // and only its reply was lost, and the read will show it answered.
      await _reread();
      if (!ref.mounted) return;
      state = state.copyWith(clearWork: true);
    } finally {
      link.close();
    }
  }

  /// This visit's reply, as the screen shows it.
  LessonAnswer _fromReply(
    QuizAnswerResult result,
    PublicQuizItem item,
    String sent,
  ) {
    // Not scored is the ledger's word: nothing was paid, and never will be.
    final int? paid = result.scored ? result.pointsApplied : null;
    // The server's record of it; the pick sent, from a server that does not
    // say.
    final String value = result.value.isEmpty ? sent : result.value;
    if (result.replay) {
      // Answered already — on another device, or by a reply that was lost.
      // The recorded answer and what the ledger paid it, exactly as a
      // resumed answer shows: no finish and no bonus.
      return LessonAnswer(
        value: value,
        correct: result.correct,
        correctOption: result.correctOption,
        explain: result.explain,
        pointsApplied: paid,
      );
    }
    final FinishBonus? finish = state.quiz?.finishBonus;
    FinishOutcome? bonus;
    if (result.completed && finish != null && finish.points > 0) {
      // The right answers before this one, plus this one, by the server's
      // verdicts — against what the contest asks.
      final int before = state.questions
          .where(
            (PublicQuizItem q) =>
                q.id != item.id && (state.answers[q.id]?.correct ?? false),
          )
          .length;
      bonus = FinishOutcome(
        earned: before + (result.correct ? 1 : 0) >= finish.minCorrect,
        minCorrect: finish.minCorrect,
      );
    }
    return LessonAnswer(
      value: value,
      correct: result.correct,
      correctOption: result.correctOption,
      explain: result.explain,
      pointsApplied: paid,
      completed: result.completed,
      bonus: bonus,
      weekBonus: result.weekBonus,
    );
  }

  /// Re-read the lesson as it stands. A failed read keeps the lesson already
  /// on screen: it is almost always the network, and the questions in memory
  /// are still today's.
  Future<void> _reread() async {
    final int read = ++_reads;
    try {
      final TodayQuiz fresh = await _repo.fetchTodayQuiz();
      if (!ref.mounted || read != _reads) return;
      state = state.copyWith(quiz: fresh);
    } on Object {
      // Kept as it was.
    }
  }

  /// Open [to] — an answered question from the steps, or the score. Never
  /// while an answer is in flight: the screen must stay on the question it
  /// belongs to.
  void go(LessonAt to) {
    final LessonRunState s = state;
    if (s.isBusy) return;
    state = s.copyWith(
      pin: LessonPin(s.day, to),
      clearCheckpoint: true,
      redrawn: false,
      clearProblem: true,
    );
  }

  /// Skip lesson part [k] (1-based) — the open one. Then: the part now open,
  /// if one is; else the path's next level when it is not a lesson part (the
  /// route is returned, and the page goes there); else parked on the skipped
  /// parts. A refusal is shown under the question on screen.
  Future<String?> skipPart(int k) async {
    final LessonRunState s = state;
    final String? dayKey = s.quiz?.dayKey;
    if (s.isBusy || dayKey == null || ref.read(skipCooldownProvider)) {
      return null;
    }
    final LessonAt here = s.at;
    final String? itemId = here is AtQuestion && here.index < s.questions.length
        ? s.questions[here.index].id
        : null;
    final link = ref.keepAlive();
    state = s.copyWith(
      work: LessonWork.skipping,
      redrawn: false,
      clearProblem: true,
    );
    try {
      final SkipOutcome outcome = await performSkip(
        ref,
        lessonNodeId(dayKey, k),
      );
      if (!ref.mounted) return null;
      await _reread();
      if (!ref.mounted) return null;
      // Over a read that failed, the skip is still known.
      TodayQuiz? quiz = state.quiz;
      if (quiz != null && !quiz.skippedParts.contains(k)) {
        quiz = quiz.copyWith(
          skippedParts: <int>[...quiz.skippedParts, k]..sort(),
        );
      }
      state = state.copyWith(quiz: quiz, clearWork: true);
      for (final LessonPartView p in state.partStates) {
        if (p.state != LessonPartState.today) continue;
        final int? i = state.firstOpenIn(p);
        if (i != null) {
          go(AtQuestion(i));
          return null;
        }
      }
      final PathNode? next = outcome.next;
      if (next != null && !next.isLesson) {
        final String? route = contestLevelRoute(next);
        if (route != null) return route;
      }
      go(const AtParked());
      return null;
    } on Object catch (e) {
      if (!ref.mounted) return null;
      state = state.copyWith(
        clearWork: true,
        clearCheckpoint: true,
        problem: itemId == null
            ? null
            : LessonProblem(itemId, contestMessage(e)),
      );
      return null;
    } finally {
      link.close();
    }
  }

  /// Continue from the answered question on screen — and from the
  /// checkpoint, where it reads "Keep going".
  ///
  /// On the last question of a part that is not the day's last, answered on
  /// THIS visit, when the next part is the open one and what follows is its
  /// first question to answer, it opens the checkpoint. "This visit" is what tells finishing a part from
  /// rereading it: after a reload, stepping back to part 1's last question and
  /// pressing Continue must not announce a checkpoint passed yesterday.
  void next() {
    final LessonRunState s = state;
    final LessonAt at = s.at;
    if (s.isBusy || at is! AtQuestion) return;
    final int index = at.index;
    final PublicQuizItem item = s.questions[index];
    if (!s.answers.containsKey(item.id)) return;
    final LessonAt to = s.nextFrom(index);
    if (s.shownCheckpoint != null) {
      go(to);
      return;
    }
    final LessonPartView? part = s.partAt(index);
    final LessonPartView? following =
        part != null && part.index + 1 < s.partStates.length
        ? s.partStates[part.index + 1]
        : null;
    final int? first = following == null ? null : s.firstOpenIn(following);
    if (part != null &&
        following != null &&
        !s.finished &&
        following.state == LessonPartState.today &&
        index == part.end - 1 &&
        first != null &&
        to == AtQuestion(first) &&
        s.local.containsKey(item.id)) {
      state = s.copyWith(checkpoint: LessonCheckpoint(s.day, part.index));
      return;
    }
    go(to);
  }
}

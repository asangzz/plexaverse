import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/learn_repositories.dart';
import '../domain/learn_repository.dart';
import '../domain/learn_unit.dart';

part 'learn_controllers.g.dart';

/// Which week the path is showing.
///
/// Null means "whatever the server says is current". The server owns that
/// calculation — a Sunday-anchored week off roadmapStartedAt — and a client
/// that recomputed it would ask for a week the plan was never saved under.
@riverpod
class LearnWeek extends _$LearnWeek {
  @override
  int? build() => null;

  /// Moving week closes whatever day is open, first.
  ///
  /// Day 1 of week 4 is not day 1 of week 5, and the unit provider is keyed by
  /// both — so a player left open across a week change would be showing a
  /// ladder from the other week. The web's arrows call setOpen(null) before
  /// setWeek for the same reason; doing it in here means a caller cannot
  /// forget.
  void showWeek(int week) {
    ref.read(learnOpenDayProvider.notifier).close();
    state = week;
  }

  void showCurrent() {
    ref.read(learnOpenDayProvider.notifier).close();
    state = null;
  }
}

/// The week as a path.
@riverpod
Future<LearnPath> learnPath(Ref ref) {
  final int? week = ref.watch(learnWeekProvider);
  return ref.watch(learnRepositoryProvider).fetchPath(week: week);
}

/// One day's ladder.
///
/// ## Why this is keepAlive and never invalidated
///
/// Its build() calls a GET that **generates the ladder with a model call** the
/// first time a day is opened. Every reflex the stack has around GETs is wrong
/// for it: `ref.invalidate` would re-run it, an error-retry would re-run it, a
/// refresh-on-resume would re-run it — and each re-run is another model call
/// and another few seconds of the user staring at a spinner for questions they
/// already have.
///
/// So: fetched exactly once per (week, day), kept alive, and every later
/// version of the unit — from banking a level, from the draft, from the
/// visual check — is WRITTEN INTO state by [LearnUnitController.absorb]
/// rather than refetched.
///
/// The server caches the built ladder on its own row, so even a genuine
/// refetch would return identical questions. That is a safety net, not a
/// licence: it still costs a round trip the user did not ask for.
@Riverpod(keepAlive: true)
class LearnUnitController extends _$LearnUnitController {
  @override
  Future<LearnUnit> build(int week, int day) =>
      ref.watch(learnRepositoryProvider).fetchUnit(week: week, day: day);

  /// Replace the unit with a newer one the server just handed us.
  ///
  /// This is the ONLY way the unit changes after its first load.
  void absorb(LearnUnit unit) => state = AsyncData<LearnUnit>(unit);

  /// Re-read the ladder from the server.
  ///
  /// Deliberately NOT wired to pull-to-refresh or to resume. The one caller is
  /// the draft action recovering from a lost response: the generation may have
  /// finished and been billed while the socket died, and the only way to find
  /// out is to ask.
  Future<void> reloadAfterLostResponse() async {
    final AsyncValue<LearnUnit> next = await AsyncValue.guard(
      () => ref.read(learnRepositoryProvider).fetchUnit(week: week, day: day),
    );
    if (!ref.mounted) return;
    // A FAILED re-read keeps the ladder we already have.
    //
    // This runs after a draft that did not come back, which is overwhelmingly
    // a network problem — so the re-read is likely to fail for the same
    // reason. Assigning the error state would replace a perfectly good
    // ladder, sitting in memory, with "today's lesson did not come through",
    // and this provider is keepAlive and never refetched: the only way back
    // is the Try again button, which costs a model call. The user would lose
    // a climbed day to a dropped connection.
    if (next.hasError) return;
    state = next;
  }
}

/// A node on the path: which day, and which level of it.
///
/// The level matters because the path draws its nodes from the TEMPLATE,
/// before any ladder exists — so a user can tap the fifth node of a day that
/// has never been opened. The ladder, once it arrives, is the authority on
/// whether that level is actually reachable; see `LessonPlayer`.
class LearnSpot {
  const LearnSpot(this.dayIndex, this.levelIndex);

  final int dayIndex;
  final int levelIndex;

  @override
  bool operator ==(Object other) =>
      other is LearnSpot &&
      other.dayIndex == dayIndex &&
      other.levelIndex == levelIndex;

  @override
  int get hashCode => Object.hash(dayIndex, levelIndex);
}

/// Which node is open, if any.
@riverpod
class LearnOpenDay extends _$LearnOpenDay {
  @override
  LearnSpot? build() => null;

  void open(int dayIndex, [int levelIndex = 0]) =>
      state = LearnSpot(dayIndex, levelIndex);
  void close() => state = null;
}

/// What the learn screen has in flight.
///
/// On a controller rather than the player widget because a widget can be
/// disposed mid-call — and the draft call is up to two minutes long, which is
/// ample time for the user to leave. `test/architecture/no_async_state_in_widgets_test.dart`
/// enforces this.
enum LearnWork {
  /// Grading ONE question, at `/learn/answer`. Short.
  grading,

  /// Banking the level, at `/learn/level`.
  submitting,

  /// Writing the post. Long, expensive, and charged.
  drafting,

  /// Asking whether the poster landed.
  checkingVisual,

  /// Marking the read-back done.
  reviewing,
}

// ── The quiz run ─────────────────────────────────────────────────────────────

/// One attempt at one level: where the learner is in it, and what it has cost.
///
/// ## Why a run is a thing with a name
///
/// The level is banked once, at the end, by `/learn/level`. Everything before
/// that — which question is on screen, the answers collected so far, how many
/// hearts are gone — exists only for the duration of the attempt and is
/// discarded if the learner quits. That is a run, and it is the unit of state
/// the quiz actually has. Spreading it over a widget's fields would mean a
/// rotation or a rebuild could silently restore a heart.
class LearnRunState {
  const LearnRunState({
    this.levelIndex = 0,
    this.taught = false,
    this.questionIndex = 0,
    this.value = '',
    this.verdict,
    this.wrong = 0,
    this.streak = 0,
    this.answers = const <String, String>{},
    this.outOfHearts = false,
    this.work,
    this.error,
  });

  /// Which level this run belongs to. A run is thrown away when it changes.
  final int levelIndex;

  /// The teaching card has been read. Questions start after it.
  final bool taught;

  final int questionIndex;

  /// What is answered on screen right now — an option's LABEL for the picker
  /// types, the typed text for the two free-text ones.
  final String value;

  /// The server's verdict on the current question, once there is one. Null
  /// means still answering, and it is what locks the controls.
  final AnswerVerdict? verdict;

  /// Wrong answers AND skips. Both cost a heart: a free skip is a button that
  /// finishes the level for you, and the first learner to notice that stops
  /// answering anything.
  final int wrong;

  /// Consecutive correct answers. Shown from two up.
  final int streak;

  /// Collected so far, by exercise id. Sent in one go when the level ends.
  final Map<String, String> answers;

  /// The budget is spent and the level restarts. Set locally the moment the
  /// fifth heart goes, and again if the server refuses the bank with
  /// OUT_OF_HEARTS — the server's count is the one that decides, this one
  /// just does not make the learner answer three more questions to find out.
  final bool outOfHearts;

  final LearnWork? work;
  final String? error;

  bool get isBusy => work != null;
  int get heartsLeft =>
      (kMistakeBudget - wrong).clamp(0, kMistakeBudget).toInt();

  LearnRunState copyWith({
    int? levelIndex,
    bool? taught,
    int? questionIndex,
    String? value,
    AnswerVerdict? verdict,
    int? wrong,
    int? streak,
    Map<String, String>? answers,
    bool? outOfHearts,
    LearnWork? work,
    String? error,
    bool clearVerdict = false,
    bool clearWork = false,
    bool clearError = false,
  }) => LearnRunState(
    levelIndex: levelIndex ?? this.levelIndex,
    taught: taught ?? this.taught,
    questionIndex: questionIndex ?? this.questionIndex,
    value: value ?? this.value,
    verdict: clearVerdict ? null : (verdict ?? this.verdict),
    wrong: wrong ?? this.wrong,
    streak: streak ?? this.streak,
    answers: answers ?? this.answers,
    outOfHearts: outOfHearts ?? this.outOfHearts,
    work: clearWork ? null : (work ?? this.work),
    error: clearError ? null : (error ?? this.error),
  );
}

/// What a step through the run asks the screen to do next.
enum LearnStep {
  /// Still inside the level — draw the next question.
  next,

  /// The level banked. Move on, or close if it was the last one.
  banked,

  /// Nothing moved: out of hearts, or the request failed.
  stopped,
}

/// Drives one attempt at one level.
///
/// ## Nothing is written after this is disposed
///
/// The player is the only listener, so backing out of a day disposes this
/// provider — and the user can do that in the second between tapping Check
/// and the verdict arriving. Riverpod throws `UnmountedRefException` on a
/// state write past that point, and it escapes to the zone rather than to
/// any caller's catch, so in release it is a Sentry report on an ordinary
/// gesture. Every write after an await is therefore guarded by `ref.mounted`.
///
/// Deliberately NOT keepAlive. Quitting a level mid-run discards it — the
/// hearts are spent, the answers are not banked, and the level is taken again
/// from the top. That is the web's behaviour and it is the honest one: a run
/// that survived being walked away from would let a learner spend four hearts,
/// leave, and come back to a fresh level with the answers already known.
@riverpod
class LearnRun extends _$LearnRun {
  @override
  LearnRunState build(int week, int day) {
    // Seeded from the ladder, not from zero.
    //
    // The player only exists once the unit has loaded, so this read always
    // finds one. Doing it here rather than from the widget's initState is
    // what makes the FIRST frame right: a learner resuming a half-climbed
    // day would otherwise see level one for a frame before being moved.
    final LearnUnit? unit = ref
        .read(learnUnitControllerProvider(week, day))
        .value;
    final int levels = unit?.levels.length ?? 0;
    if (levels == 0) return const LearnRunState();
    final int next = unit?.nextLevelIndex ?? 0;
    // -1 means the unit is FINISHED. Clamping that to 0 reopened a completed
    // day at its first level and walked the user back through all seven,
    // each one saying "you have already finished this level". The last one
    // is where they actually left off.
    final int at = next < 0 ? levels - 1 : next.clamp(0, levels - 1);
    return LearnRunState(levelIndex: at);
  }

  LearnRepository get _repo => ref.read(learnRepositoryProvider);

  LearnUnitController get _unit =>
      ref.read(learnUnitControllerProvider(week, day).notifier);

  /// Point the run at a level, discarding any run on a different one.
  ///
  /// Called by the player when it mounts and whenever the level changes. Safe
  /// to call repeatedly: it only resets when the index actually moved, so a
  /// rebuild mid-question does not cost the learner their place.
  void ensureLevel(int index) {
    if (state.levelIndex == index) return;
    state = LearnRunState(levelIndex: index);
  }

  /// Move to another level, discarding the run on this one.
  void goToLevel(int index) => ensureLevel(index);

  /// Take the level again from the top. Hearts included — that is the point.
  void restart() => state = LearnRunState(levelIndex: state.levelIndex);

  void teachRead() => state = state.copyWith(taught: true);

  void setValue(String value) => state = state.copyWith(value: value);

  void clearError() => state = state.copyWith(clearError: true);

  /// Answer the question on screen.
  ///
  /// The verdict is the SERVER's, always. The answer key rides along inside
  /// the ladder because the explanation is shown after answering, which puts
  /// it a few lines from this method — and a locally-computed verdict is one
  /// inspection away from completing a unit without reading a word.
  Future<void> check({
    required LearnUnit unit,
    required LearnLevel level,
    required Exercise exercise,
  }) async {
    if (state.isBusy || state.verdict != null) return;
    final String value = state.value;
    state = state.copyWith(work: LearnWork.grading, clearError: true);
    try {
      final AnswerVerdict verdict = await _repo.gradeAnswer(
        unitId: unit.id,
        // The level is passed in rather than read off this run's own state:
        // the two cannot disagree that way, and an answer graded against the
        // wrong level is a question the server has never heard of.
        levelIndex: level.index,
        exerciseId: exercise.id,
        value: value,
      );
      if (!ref.mounted) return;
      final bool spent = !verdict.correct && state.wrong + 1 >= kMistakeBudget;
      state = state.copyWith(
        clearWork: true,
        verdict: verdict,
        answers: <String, String>{...state.answers, exercise.id: value},
        streak: verdict.correct ? state.streak + 1 : 0,
        wrong: verdict.correct ? state.wrong : state.wrong + 1,
        outOfHearts: spent ? true : null,
      );
    } on Object catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(clearWork: true, error: _say(e));
    }
  }

  /// Skip moves on. It does not grade.
  ///
  /// The web's first version called the grader with a blank answer and showed
  /// the result bar, which put the correct answer on screen — so Skip behaved
  /// exactly like getting it wrong, and the one thing the learner had just
  /// asked not to see was the thing it showed them. Skip means skip: the
  /// question is recorded unanswered and the next one appears.
  ///
  /// It still costs a heart.
  Future<LearnStep> skip({
    required LearnUnit unit,
    required LearnLevel level,
    required Exercise exercise,
  }) async {
    if (state.isBusy) return LearnStep.stopped;
    final bool spent = state.wrong + 1 >= kMistakeBudget;
    state = state.copyWith(
      answers: <String, String>{...state.answers, exercise.id: ''},
      streak: 0,
      wrong: state.wrong + 1,
      outOfHearts: spent ? true : null,
      clearError: true,
    );
    if (spent) return LearnStep.stopped;
    return advance(unit: unit, level: level);
  }

  /// Move past the answered question — to the next one, or out of the level.
  Future<LearnStep> advance({
    required LearnUnit unit,
    required LearnLevel level,
  }) async {
    if (state.isBusy) return LearnStep.stopped;
    final bool last = state.questionIndex >= level.exercises.length - 1;
    if (!last) {
      state = state.copyWith(
        questionIndex: state.questionIndex + 1,
        value: '',
        clearVerdict: true,
        clearError: true,
      );
      return LearnStep.next;
    }
    return _bank(unit: unit, level: level);
  }

  /// The last question is answered: hand the whole level to the server.
  ///
  /// Every answer is re-graded there. This client's heart count is a pacing
  /// device; the count that decides whether the level banked is the one made
  /// where it is written.
  Future<LearnStep> _bank({
    required LearnUnit unit,
    required LearnLevel level,
  }) async {
    state = state.copyWith(work: LearnWork.submitting, clearError: true);
    // Taken BEFORE the await, deliberately.
    //
    // `_unit` is `ref.read(...)`, and a Ref throws once its provider is
    // disposed — which this one is the moment the learner leaves the day.
    // Reading it after the round trip therefore threw INSIDE the try, the
    // catch reported a banked level as a failure, and the level the learner
    // had just finished was lost. The controller itself is keepAlive, so a
    // reference taken while we were still mounted stays good.
    final LearnUnitController unit_ = _unit;
    try {
      final SubmitResult result = await _repo.submitLevel(
        unitId: unit.id,
        levelIndex: level.index,
        answers: <LevelAnswer>[
          for (final Exercise e in level.exercises)
            LevelAnswer(exerciseId: e.id, value: state.answers[e.id] ?? ''),
        ],
      );
      // The unit controller is keepAlive, so the banked level survives even
      // if this run does not — a learner who finishes a level and leaves in
      // the same second keeps the level.
      unit_.absorb(result.unit);
      if (!ref.mounted) return LearnStep.banked;
      state = state.copyWith(clearWork: true, clearVerdict: true);
      return LearnStep.banked;
    } on LearnOutOfHearts catch (e) {
      if (!ref.mounted) return LearnStep.stopped;
      state = state.copyWith(
        clearWork: true,
        outOfHearts: true,
        error: e.message,
      );
      return LearnStep.stopped;
    } on Object catch (e) {
      if (!ref.mounted) return LearnStep.stopped;
      state = state.copyWith(clearWork: true, error: _say(e));
      return LearnStep.stopped;
    }
  }
}

// ── The action levels ────────────────────────────────────────────────────────

/// In-flight work and the last failure for the three levels that are finished
/// by doing rather than by answering.
class LearnBusy {
  const LearnBusy({this.work, this.error});

  final LearnWork? work;

  /// The sentence to show. Null when nothing has failed since the last action.
  final String? error;

  bool get isBusy => work != null;
  bool get isDrafting => work == LearnWork.drafting;

  LearnBusy copyWith({
    LearnWork? work,
    String? error,
    bool clearWork = false,
    bool clearError = false,
  }) => LearnBusy(
    work: clearWork ? null : (work ?? this.work),
    error: clearError ? null : (error ?? this.error),
  );
}

/// Draft, visual and review.
///
/// Every write goes through here so the in-flight flag and the failure live in
/// one place that outlives the player — the draft is a two-minute call and the
/// user will leave during it.
@Riverpod(keepAlive: true)
class LearnActions extends _$LearnActions {
  @override
  LearnBusy build(int week, int day) => const LearnBusy();

  LearnRepository get _repo => ref.read(learnRepositoryProvider);

  LearnUnitController get _unit =>
      ref.read(learnUnitControllerProvider(week, day).notifier);

  /// Write the post.
  ///
  /// ## Losing the answer does not mean losing the charge
  ///
  /// This runs a 120s model chain against an OS that will suspend the socket
  /// the moment the user switches apps. The server can finish, bill the XP and
  /// write the post while this client sees a timeout. Re-firing would sell the
  /// user a second post, so on ANY failure the unit is re-read before the
  /// button is offered again — and if the draft level came back complete, the
  /// work landed and this reports success.
  Future<bool> draft(String unitId) async {
    if (state.isBusy) return false;
    state = state.copyWith(work: LearnWork.drafting, clearError: true);
    try {
      _unit.absorb(await _repo.runDraft(unitId));
      state = state.copyWith(clearWork: true);
      return true;
    } on Object catch (e) {
      // Ask the server what actually happened before deciding this failed.
      await _unit.reloadAfterLostResponse();
      if (_draftLanded()) {
        state = state.copyWith(clearWork: true);
        return true;
      }
      state = state.copyWith(clearWork: true, error: _say(e));
      return false;
    }
  }

  bool _draftLanded() {
    final LearnUnit? unit = ref
        .read(learnUnitControllerProvider(week, day))
        .value;
    if (unit == null) return false;
    return unit.levels.any(
      (LearnLevel l) => l.kind == LevelKind.draft && l.isComplete,
    );
  }

  /// Ask whether the poster landed.
  ///
  /// [LearnImageMissing] is not a failure — it is "not yet" — so it sets a
  /// nudge rather than an error and the button stays live.
  Future<bool> checkVisual(String unitId) async {
    if (state.isBusy) return false;
    state = state.copyWith(work: LearnWork.checkingVisual, clearError: true);
    try {
      _unit.absorb(await _repo.checkVisual(unitId));
      state = state.copyWith(clearWork: true);
      return true;
    } on LearnImageMissing catch (e) {
      state = state.copyWith(clearWork: true, error: e.message);
      return false;
    } on Object catch (e) {
      state = state.copyWith(clearWork: true, error: _say(e));
      return false;
    }
  }

  Future<bool> review(String unitId) async {
    if (state.isBusy) return false;
    state = state.copyWith(work: LearnWork.reviewing, clearError: true);
    try {
      _unit.absorb(await _repo.completeReview(unitId));
      state = state.copyWith(clearWork: true);
      return true;
    } on Object catch (e) {
      state = state.copyWith(clearWork: true, error: _say(e));
      return false;
    }
  }

  void clearError() => state = state.copyWith(clearError: true);
}

/// One sentence for a thrown thing, so no screen ever shows a stack trace.
String _say(Object e) => switch (e) {
  LearnOutOfHearts(:final String message) => message,
  LearnImageMissing(:final String message) => message,
  LearnGenerationFailed(:final String message) => message,
  LearnNoPlan(:final String message) => message,
  LearnRestDay(:final String message) => message,
  _ => 'That did not go through. Try again.',
};

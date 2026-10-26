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
/// version of the unit — from submitting a level, from the draft, from the
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
    state = await AsyncValue.guard(
      () => ref.read(learnRepositoryProvider).fetchUnit(week: week, day: day),
    );
  }
}

/// Which day's player is open, if any.
@riverpod
class LearnOpenDay extends _$LearnOpenDay {
  @override
  int? build() => null;

  void open(int dayIndex) => state = dayIndex;
  void close() => state = null;
}

/// What the learn screen has in flight.
///
/// On the controller rather than the player widget because a widget can be
/// disposed mid-call — and the draft call is up to two minutes long, which is
/// ample time for the user to leave. `test/architecture/no_async_state_in_widgets_test.dart`
/// enforces this.
enum LearnWork {
  /// Grading a level's answers.
  submitting,

  /// Writing the post. Long, expensive, and charged.
  drafting,

  /// Asking whether the poster landed.
  checkingVisual,

  /// Marking the read-back done.
  reviewing,
}

/// In-flight work and the last failure, for the open unit.
class LearnBusy {
  const LearnBusy({
    this.work,
    this.error,
    this.results = const <ExerciseResult>[],
  });

  final LearnWork? work;

  /// The sentence to show. Null when nothing has failed since the last action.
  final String? error;

  /// Per-exercise verdicts from the last submit. The SERVER's, never ours.
  final List<ExerciseResult> results;

  bool get isBusy => work != null;
  bool get isDrafting => work == LearnWork.drafting;

  LearnBusy copyWith({
    LearnWork? work,
    String? error,
    List<ExerciseResult>? results,
    bool clearWork = false,
    bool clearError = false,
    bool clearResults = false,
  }) => LearnBusy(
    work: clearWork ? null : (work ?? this.work),
    error: clearError ? null : (error ?? this.error),
    results: clearResults
        ? const <ExerciseResult>[]
        : (results ?? this.results),
  );
}

/// Drives one unit's climb.
///
/// Every write goes through here so the in-flight flag, the failure and the
/// server's verdicts live in one place that outlives the player.
@Riverpod(keepAlive: true)
class LearnActions extends _$LearnActions {
  @override
  LearnBusy build(int week, int day) => const LearnBusy();

  LearnRepository get _repo => ref.read(learnRepositoryProvider);

  LearnUnitController get _unit =>
      ref.read(learnUnitControllerProvider(week, day).notifier);

  /// Answer a level.
  ///
  /// Returns true only when every answer passed. **A successful request is not
  /// a passed level**: the server grades all-or-nothing and returns the unit
  /// UNCHANGED when anything is wrong, so the verdict is in `results`, not in
  /// the absence of an exception.
  Future<bool> submit({
    required String unitId,
    required int levelIndex,
    required List<LevelAnswer> answers,
  }) async {
    if (state.isBusy) return false;
    state = state.copyWith(
      work: LearnWork.submitting,
      clearError: true,
      clearResults: true,
    );
    try {
      final SubmitResult result = await _repo.submitLevel(
        unitId: unitId,
        levelIndex: levelIndex,
        answers: answers,
      );
      _unit.absorb(result.unit);
      state = state.copyWith(clearWork: true, results: result.results);
      return result.allCorrect;
    } on Object catch (e) {
      state = state.copyWith(clearWork: true, error: _say(e));
      return false;
    }
  }

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

  void clearResults() => state = state.copyWith(clearResults: true);

  static String _say(Object e) => switch (e) {
    LearnImageMissing(:final String message) => message,
    LearnGenerationFailed(:final String message) => message,
    LearnNoPlan(:final String message) => message,
    LearnRestDay(:final String message) => message,
    _ => 'That did not go through. Try again.',
  };
}

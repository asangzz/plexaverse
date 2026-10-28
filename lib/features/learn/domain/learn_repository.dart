import 'learn_unit.dart';

/// Reads and writes the week's climb.
///
/// Backed by `/learn`, `/learn/unit`, `/learn/level` and `/learn/action` on
/// the mobile API. Those routes wrap the SAME `lib/services/learn.service` the
/// web uses, so the ladder's shape, its progression rules and its grading
/// cannot drift between the two clients.
abstract class LearnRepository {
  /// The week as a path. [week] null means the current one.
  Future<LearnPath> fetchPath({int? week});

  /// One day's ladder.
  ///
  /// **Slow and not free on first open.** When the day has never been opened
  /// the server generates the whole ladder with a model call before it can
  /// answer. That is why this must never be prefetched speculatively, never
  /// retried automatically, and never refetched on resume: each of those is a
  /// model call the user did not ask for. Once built, the ladder is cached on
  /// the server row and every later read returns the identical questions —
  /// which it must, because a climb happens over several sittings.
  Future<LearnUnit> fetchUnit({required int week, required int day});

  /// Grade ONE question. Writes nothing.
  ///
  /// Called on every Check. The quiz is one question to a screen and the
  /// learner is told whether they were right before the next appears; without
  /// this the app would have to submit a whole level at once, which is the
  /// stacked-form behaviour the web replaced, and the two clients would
  /// teach differently.
  ///
  /// Cheap and idempotent — it is a read, so a retry cannot bank an answer or
  /// advance anything.
  Future<AnswerVerdict> gradeAnswer({
    required String unitId,
    required int levelIndex,
    required String exerciseId,
    required String value,
  });

  /// Bank a level: every answer, re-graded, at the end of the run.
  ///
  /// **Mistakes are allowed.** Up to [kMistakeBudget] wrong answers still
  /// bank the level — a level that demanded a clean run is one retaken until
  /// the learner has memorised the option positions, which is the single
  /// thing these exercises must not reward. Past the budget, or with nothing
  /// right at all, the server writes nothing and throws [LearnOutOfHearts].
  ///
  /// Every answer is re-graded here rather than trusted from [gradeAnswer],
  /// which is a read: the count that decides whether the level passed is made
  /// again where it is banked.
  ///
  /// Grading is the server's. The correct answers travel inside the ladder
  /// because the player reveals them after answering — this client must never
  /// derive a verdict from them.
  Future<SubmitResult> submitLevel({
    required String unitId,
    required int levelIndex,
    required List<LevelAnswer> answers,
  });

  /// Write the post from what they climbed.
  ///
  /// Runs the entire brand-post pipeline synchronously — the same work as the
  /// planner's Generate, up to two minutes. Show progress, not a spinner.
  Future<LearnUnit> runDraft(String unitId);

  /// Check whether the poster they went to make actually landed.
  ///
  /// Throws [LearnImageMissing] when it has not. That is not a failure — it
  /// means come back when you have one — so the caller shows a nudge rather
  /// than an error.
  Future<LearnUnit> checkVisual(String unitId);

  /// They read it back.
  Future<LearnUnit> completeReview(String unitId);
}

/// The week has no plan to climb yet.
///
/// Its own type because the answer is a screen, not an error: the user needs
/// to be sent to the planner, and "something went wrong" would send them
/// nowhere.
class LearnNoPlan implements Exception {
  const LearnNoPlan([this.message = 'This week has no plan yet.']);
  final String message;

  @override
  String toString() => message;
}

/// The poster has not been made yet.
///
/// Distinct from a failure on purpose — the server answers 409 IMAGE_MISSING
/// rather than a generic 4xx precisely so a client can tell "not done yet"
/// apart from "broken".
class LearnImageMissing implements Exception {
  const LearnImageMissing([
    this.message = 'No poster yet — make one and come back.',
  ]);
  final String message;

  @override
  String toString() => message;
}

/// The five hearts are spent: the level is retaken from the top.
///
/// Its own type because it is not an error in the ordinary sense — nothing
/// broke, nothing was lost but the run, and the only sensible screen is one
/// button that starts the level again. Rendering it as "something went wrong"
/// would make a pacing device look like a fault.
class LearnOutOfHearts implements Exception {
  const LearnOutOfHearts([
    this.message = 'That is five wrong in one level. Run it again.',
  ]);
  final String message;

  @override
  String toString() => message;
}

/// Saturday and Sunday have no ladder.
class LearnRestDay implements Exception {
  const LearnRestDay([this.message = 'This is a rest day.']);
  final String message;

  @override
  String toString() => message;
}

/// The model could not produce a climbable ladder.
///
/// Retryable BY THE USER, never automatically: a retry is another model call.
class LearnGenerationFailed implements Exception {
  const LearnGenerationFailed([
    this.message = "Could not build today's lesson. Try again.",
  ]);
  final String message;

  @override
  String toString() => message;
}

/// One sentence for anything this slice can throw.
///
/// The screens used to render `e.toString()`, which for the unrecognised
/// codes — anything outside the five `_mapped` knows — is a raw
/// `DioException` dump: the full URL, the status line and the stack. App
/// stores reject that, and a user cannot act on it. Unknown stays generic on
/// purpose; a code we have never seen is not something we can explain.
String learnMessage(Object error) => switch (error) {
  LearnNoPlan(:final String message) => message,
  LearnRestDay(:final String message) => message,
  LearnImageMissing(:final String message) => message,
  LearnOutOfHearts(:final String message) => message,
  LearnGenerationFailed(:final String message) => message,
  _ => 'That did not come through. Try again.',
};

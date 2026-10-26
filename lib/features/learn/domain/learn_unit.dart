import 'package:freezed_annotation/freezed_annotation.dart';

// DayKind lives in core/week for the same reason the planner takes it from
// there: a unit IS one planner day, and the two must not drift.
export '../../../core/week/week_shape.dart' show DayKind;

import '../../../core/week/week_shape.dart';

part 'learn_unit.freezed.dart';
part 'learn_unit.g.dart';

/// Where one level is. Mirrors `LevelStatus` in the web's `lib/learn/ladder.ts`.
enum LevelStatus {
  locked,
  available,
  complete;

  static LevelStatus parse(String? raw) => switch (raw) {
    'available' => LevelStatus.available,
    'complete' => LevelStatus.complete,
    _ => LevelStatus.locked,
  };

  String get wire => name;
}

/// Where one day's climb is. Mirrors `UnitStatus`.
enum UnitStatus {
  locked,
  available,
  inProgress,
  complete;

  /// `in_progress` on the wire, `inProgress` in Dart — the only name that is
  /// not a straight pass-through.
  static UnitStatus parse(String? raw) => switch (raw) {
    'available' => UnitStatus.available,
    'in_progress' => UnitStatus.inProgress,
    'complete' => UnitStatus.complete,
    _ => UnitStatus.locked,
  };

  String get wire => this == UnitStatus.inProgress ? 'in_progress' : name;
}

/// What a level is for. Mirrors `LevelKind`.
///
/// The order is the climb: words, then the opening, then what actually
/// happened, then the ask — and only then is there enough to write from.
enum LevelKind {
  vocabulary,
  hook,
  substance,
  close,
  draft,
  visual,
  review;

  static LevelKind parse(String? raw) => switch (raw) {
    'hook' => LevelKind.hook,
    'substance' => LevelKind.substance,
    'close' => LevelKind.close,
    'draft' => LevelKind.draft,
    'visual' => LevelKind.visual,
    'review' => LevelKind.review,
    _ => LevelKind.vocabulary,
  };

  String get wire => name;

  /// Levels with no exercises, completed by doing the thing rather than
  /// answering. Mirrors `levelIsAction`.
  bool get isAction =>
      this == LevelKind.draft ||
      this == LevelKind.visual ||
      this == LevelKind.review;
}

/// One question.
///
/// Four shapes on the wire, discriminated by `type`. Modelled as ONE class
/// with nullable per-variant fields rather than a sealed union, because the
/// JSON is a union the server owns: a sealed hierarchy here would need a
/// hand-written converter and would throw on a fifth type the server adds
/// before this app ships, where an unknown type can instead degrade to a
/// level the player skips.
///
/// **`correctIndex` and `modelAnswer` arrive on the wire and are NOT the
/// verdict.** They are here because the player shows them AFTER answering —
/// that is the teaching moment. Grading happens on the server, and this client
/// must never decide correctness from these fields. See the level route.
@freezed
abstract class Exercise with _$Exercise {
  const Exercise._();

  const factory Exercise({
    required String id,
    required String type,
    required String prompt,

    /// One of the five voice-coach upgrade kinds, so written and spoken
    /// mistakes file under the same headings.
    String? teaches,

    /// choice, gap
    @Default(<String>[]) List<String> options,
    int? correctIndex,
    String? explain,

    /// gap — carries exactly one `___`.
    String? sentence,

    /// rewrite — pre-filled so the user edits rather than stares.
    String? starter,
    String? modelAnswer,

    /// compose
    String? placeholder,
    @Default(0) int minChars,
  }) = _Exercise;

  factory Exercise.fromJson(Map<String, dynamic> json) =>
      _$ExerciseFromJson(json);

  bool get isChoice => type == 'choice';
  bool get isGap => type == 'gap';
  bool get isRewrite => type == 'rewrite';

  /// Never graded. There is no wrong answer to "what did you actually ship".
  bool get isCompose => type == 'compose';

  /// A type this build does not know how to render. The player skips these
  /// rather than showing a blank.
  bool get isRenderable => isChoice || isGap || isRewrite || isCompose;

  /// Tapped answers travel as the option's TEXT, never its index — option
  /// order is regenerated per unit and an index would silently re-point.
  String? optionAt(int index) =>
      index >= 0 && index < options.length ? options[index] : null;
}

/// The rule a level teaches, before any question is asked.
@freezed
abstract class TeachBlock with _$TeachBlock {
  const factory TeachBlock({
    required String rule,
    required String why,
    required String before,
    required String after,
    String? kind,
  }) = _TeachBlock;

  factory TeachBlock.fromJson(Map<String, dynamic> json) =>
      _$TeachBlockFromJson(json);
}

/// What the user answered. Kept so `draft` can stitch the post from it.
@freezed
abstract class LevelAnswer with _$LevelAnswer {
  const factory LevelAnswer({
    required String exerciseId,
    required String value,

    /// Absent for `compose`, which is not graded.
    bool? correct,
  }) = _LevelAnswer;

  factory LevelAnswer.fromJson(Map<String, dynamic> json) =>
      _$LevelAnswerFromJson(json);
}

@freezed
abstract class LearnLevel with _$LearnLevel {
  const LearnLevel._();

  const factory LearnLevel({
    required int index,
    @JsonKey(name: 'kind', fromJson: LevelKind.parse) required LevelKind kind,
    required String title,
    TeachBlock? teach,
    @Default(<Exercise>[]) List<Exercise> exercises,
    @JsonKey(name: 'status', fromJson: LevelStatus.parse)
    @Default(LevelStatus.locked)
    LevelStatus status,
    @Default(<LevelAnswer>[]) List<LevelAnswer> answers,
    String? completedAt,
  }) = _LearnLevel;

  factory LearnLevel.fromJson(Map<String, dynamic> json) =>
      _$LearnLevelFromJson(json);

  bool get isComplete => status == LevelStatus.complete;
  bool get isLocked => status == LevelStatus.locked;

  /// Exercises this build can draw. See [Exercise.isRenderable].
  List<Exercise> get renderable =>
      exercises.where((Exercise e) => e.isRenderable).toList();
}

/// One day of the planner, as a ladder.
@freezed
abstract class LearnUnit with _$LearnUnit {
  const LearnUnit._();

  const factory LearnUnit({
    required String id,
    required int season,
    required int weekNumber,
    required int dayIndex,
    @JsonKey(name: 'kind', fromJson: DayKind.parse) required DayKind kind,
    required String title,

    /// The week's topic, above the day's own title.
    @Default('') String unitTitle,
    @Default(<LearnLevel>[]) List<LearnLevel> levels,
    @JsonKey(name: 'status', fromJson: UnitStatus.parse)
    @Default(UnitStatus.available)
    UnitStatus status,
    @Default(0) int nextLevelIndex,

    /// The post this unit writes, once `draft` has run.
    String? postId,
    String? postContent,
    String? imageUrl,
  }) = _LearnUnit;

  factory LearnUnit.fromJson(Map<String, dynamic> json) =>
      _$LearnUnitFromJson(json);

  int get completedCount => levels.where((LearnLevel l) => l.isComplete).length;

  bool get isComplete => status == UnitStatus.complete;

  /// The level the user should be on, or null when the climb is done.
  ///
  /// The server sends -1 when the unit is finished, which the bounds check
  /// below absorbs along with any other out-of-range value.
  LearnLevel? get nextLevel {
    if (nextLevelIndex < 0 || nextLevelIndex >= levels.length) return null;
    return levels[nextLevelIndex];
  }
}

/// One day on the week's path, without its ladder.
@freezed
abstract class LearnPathDay with _$LearnPathDay {
  const LearnPathDay._();

  const factory LearnPathDay({
    required int dayIndex,

    /// Monday … Sunday, for the node label.
    required String day,
    @JsonKey(name: 'kind', fromJson: DayKind.parse) required DayKind kind,
    required String title,
    @JsonKey(name: 'status', fromJson: UnitStatus.parse)
    @Default(UnitStatus.locked)
    UnitStatus status,
    @Default(0) int levelCount,
    @Default(0) int completedCount,

    /// False means opening this day will GENERATE its ladder — a model call,
    /// so the client must expect the first open to be slow.
    @Default(false) bool started,
  }) = _LearnPathDay;

  factory LearnPathDay.fromJson(Map<String, dynamic> json) =>
      _$LearnPathDayFromJson(json);

  /// Saturday and Sunday. No ladder, and that is the point of a rest day.
  ///
  /// The server already filters these OUT of the path, so this should never
  /// be true in practice — `days` is sparse over `dayIndex` rather than
  /// carrying seven entries. Kept as a guard so a future server that stops
  /// filtering cannot put homework on the rest day by accident.
  bool get isRest => kind == DayKind.rest;

  bool get isLocked => status == UnitStatus.locked;

  double get progress =>
      levelCount == 0 ? 0 : (completedCount / levelCount).clamp(0, 1);
}

/// The week, as something to climb.
@freezed
abstract class LearnPath with _$LearnPath {
  const LearnPath._();

  const factory LearnPath({
    required int season,
    required int weekNumber,

    /// This week's topic from the season roadmap — the unit heading.
    @Default('') String unitTitle,

    /// The phase, for the section label above it.
    @Default('') String phase,
    @Default(<LearnPathDay>[]) List<LearnPathDay> days,

    /// Where "Start" points. Null when the week is finished.
    ///
    /// A `dayIndex`, NOT a position in [days] — the list omits rest days, so
    /// the two do not line up. Look it up, do not index with it.
    int? nextDayIndex,
  }) = _LearnPath;

  factory LearnPath.fromJson(Map<String, dynamic> json) =>
      _$LearnPathFromJson(json);

  /// Defensive: the server omits rest days already. See [LearnPathDay.isRest].
  List<LearnPathDay> get climbable =>
      days.where((LearnPathDay d) => !d.isRest).toList();

  int get completedDays => climbable
      .where((LearnPathDay d) => d.status == UnitStatus.complete)
      .length;
}

/// One exercise's verdict, from the server. The client never computes these.
@freezed
abstract class ExerciseResult with _$ExerciseResult {
  const factory ExerciseResult({
    required String exerciseId,
    required bool correct,
    @Default('') String message,
  }) = _ExerciseResult;

  factory ExerciseResult.fromJson(Map<String, dynamic> json) =>
      _$ExerciseResultFromJson(json);
}

/// What answering a level gives back.
@freezed
abstract class SubmitResult with _$SubmitResult {
  const SubmitResult._();

  const factory SubmitResult({
    required LearnUnit unit,
    @Default(<ExerciseResult>[]) List<ExerciseResult> results,
  }) = _SubmitResult;

  factory SubmitResult.fromJson(Map<String, dynamic> json) =>
      _$SubmitResultFromJson(json);

  /// A level is all-or-nothing: one wrong answer and nothing is written.
  bool get allCorrect =>
      results.isNotEmpty && results.every((ExerciseResult r) => r.correct);
}

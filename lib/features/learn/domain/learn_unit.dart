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

/// Enum spellings on the wire.
///
/// json_serializable writes the DART name by default — `videoScript`,
/// `inProgress` — while every `parse()` here reads the SERVER's
/// `video_script` and `in_progress`. A unit that went out through `toJson`
/// and came back therefore changed shape under you: the day's kind fell to
/// its `post` default and the unit's status to `locked`. Nothing serialises
/// a unit today; the asymmetry is removed so that nothing has to find out.
String _dayKindWire(DayKind kind) => kind.wire;
String _levelKindWire(LevelKind kind) => kind.wire;
String _levelStatusWire(LevelStatus status) => status.wire;
String _unitStatusWire(UnitStatus status) => status.wire;

/// How many wrong answers a level tolerates before it has to be retaken.
///
/// Five, drawn as hearts. Mirrors `MISTAKE_BUDGET` in the web's
/// `lib/learn/ladder.ts`, and it is a PACING device here, not a rule: the
/// count that decides whether a level banked is made again on the server in
/// submitLevel. A client that counted alone would be a budget a determined
/// learner discovers they can ignore.
const int kMistakeBudget = 5;

/// One answer on an option list.
///
/// A `label` for every type, plus `fills` for `pair` — where an option is two
/// words that belong together and the sentence has two blanks. Modelled as
/// one class rather than two because the player only ever needs "what does
/// this row say" and "what does picking it put in the sentence", and the
/// second is simply empty for the five types that have one blank or none.
///
/// The answer travels back to the server as the LABEL, for every type. That
/// is the web's rule (`gradeExercise`'s pair branch compares by label) and it
/// is the right one: the stored answer then reads as the thing the learner
/// actually picked off the screen.
@freezed
abstract class ExerciseOption with _$ExerciseOption {
  const factory ExerciseOption({
    required String label,

    /// `pair` only — what this option puts into the sentence's two blanks,
    /// in order. Empty for every other type.
    @Default(<String>[]) List<String> fills,
  }) = _ExerciseOption;

  factory ExerciseOption.fromJson(Map<String, dynamic> json) =>
      _$ExerciseOptionFromJson(json);
}

/// `options` arrives as `["a","b"]` for most types and as
/// `[{label, fills}]` for `pair`. One field, two wire shapes, because that is
/// what the server sends — and a client that modelled them as two fields
/// would have to keep them in step for no gain.
List<ExerciseOption> _optionsFromJson(Object? raw) {
  if (raw is! List) return const <ExerciseOption>[];
  return <ExerciseOption>[
    for (final Object? item in raw)
      if (item is Map)
        ExerciseOption(
          label: item['label']?.toString() ?? '',
          fills: <String>[
            for (final Object? f in (item['fills'] as List<Object?>? ?? const <Object?>[]))
              f?.toString() ?? '',
          ],
        )
      else
        ExerciseOption(label: item?.toString() ?? ''),
  ];
}

List<Object> _optionsToJson(List<ExerciseOption> options) => <Object>[
  for (final ExerciseOption o in options)
    if (o.fills.isEmpty)
      o.label
    else
      <String, Object>{'label': o.label, 'fills': o.fills},
];

/// One question.
///
/// Seven shapes on the wire, discriminated by `type`. Modelled as ONE class
/// with nullable per-variant fields rather than a sealed union, because the
/// JSON is a union the server owns: a sealed hierarchy here would need a
/// hand-written converter and would throw on an eighth type the server adds
/// after this build ships, where an unknown type can instead be REFUSED with
/// a message — see [LearnLevel.isClimbable].
///
/// **`correctIndex` and `modelAnswer` arrive on the wire and are NOT the
/// verdict.** They are here because the player shows them AFTER answering —
/// that is the teaching moment. Grading happens on the server, per question
/// at `/learn/answer` and again for the whole level at `/learn/level`, and
/// this client must never decide correctness from these fields.
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

    /// choice, gap, pair, dialogue, meaning.
    @JsonKey(fromJson: _optionsFromJson, toJson: _optionsToJson)
    @Default(<ExerciseOption>[])
    List<ExerciseOption> options,
    int? correctIndex,
    String? explain,

    /// gap carries exactly one `___`; pair carries exactly two.
    String? sentence,

    /// meaning — the term under test, which appears inside [sentence].
    String? term,

    /// dialogue — who left the comment ("A founder in your audience"), and
    /// what they said.
    String? speaker,
    String? opener,

    /// rewrite — the weak sentence, shown as a card to rewrite from.
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
  bool get isPair => type == 'pair';
  bool get isDialogue => type == 'dialogue';
  bool get isMeaning => type == 'meaning';
  bool get isRewrite => type == 'rewrite';

  /// Never graded. There is no wrong answer to "what did you actually ship".
  bool get isCompose => type == 'compose';

  /// Answered by picking a row, rather than by typing.
  bool get isPicker =>
      isChoice || isGap || isPair || isDialogue || isMeaning;

  /// Answered in a text box.
  bool get isFreeText => isRewrite || isCompose;

  /// A type this build knows how to draw.
  ///
  /// An older app must NOT quietly drop a type it has not heard of: the level
  /// would render with questions missing and the run would submit a partial
  /// answer set, which the server then grades as wrong. A lesson that is
  /// silently incomplete is worse than one that refuses — see
  /// [LearnLevel.isClimbable].
  bool get isRenderable => isPicker || isFreeText;

  /// What the sentence looks like with this option's fills dropped in.
  ///
  /// `gap` has one blank and `pair` has two; everything else has none and
  /// gets the sentence back unchanged. Used to draw the sentence live as the
  /// learner picks, which is the whole point of the format — the answer is
  /// read in place, as a sentence, not as a word beside one.
  String filled(ExerciseOption? option) {
    final String raw = sentence ?? '';
    if (option == null) return raw;
    final List<String> fills = option.fills.isEmpty
        ? <String>[option.label]
        : option.fills;
    int i = 0;
    return raw.replaceAllMapped(
      '___',
      (Match _) => i < fills.length ? fills[i++] : '___',
    );
  }

  /// Tapped answers travel as the option's LABEL, never its index — option
  /// order is regenerated per unit and an index would silently re-point.
  List<String> get optionLabels =>
      <String>[for (final ExerciseOption o in options) o.label];

  ExerciseOption? optionFor(String label) {
    for (final ExerciseOption o in options) {
      if (o.label == label) return o;
    }
    return null;
  }

  String? optionAt(int index) =>
      index >= 0 && index < options.length ? options[index].label : null;
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
    @JsonKey(name: 'kind', fromJson: LevelKind.parse, toJson: _levelKindWire)
    required LevelKind kind,
    required String title,
    TeachBlock? teach,
    @Default(<Exercise>[]) List<Exercise> exercises,
    @JsonKey(
      name: 'status',
      fromJson: LevelStatus.parse,
      toJson: _levelStatusWire,
    )
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

  /// False when the server sent a question type this build cannot draw.
  ///
  /// The player refuses the whole level rather than showing the subset it
  /// understands. Submitting the subset would look like answering and grade
  /// as failing, and the user would have no way to see what they had missed.
  bool get isClimbable =>
      kind.isAction || renderable.length == exercises.length;

  /// The types that would have been dropped, for the message.
  List<String> get unsupportedTypes => exercises
      .where((Exercise e) => !e.isRenderable)
      .map((Exercise e) => e.type)
      .toSet()
      .toList();
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
    @JsonKey(name: 'kind', fromJson: DayKind.parse, toJson: _dayKindWire)
    required DayKind kind,
    required String title,

    /// The week's topic, above the day's own title.
    @Default('') String unitTitle,
    @Default(<LearnLevel>[]) List<LearnLevel> levels,
    @JsonKey(
      name: 'status',
      fromJson: UnitStatus.parse,
      toJson: _unitStatusWire,
    )
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
    @JsonKey(name: 'kind', fromJson: DayKind.parse, toJson: _dayKindWire)
    required DayKind kind,
    required String title,
    @JsonKey(
      name: 'status',
      fromJson: UnitStatus.parse,
      toJson: _unitStatusWire,
    )
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

/// What banking a level gives back.
///
/// There is no `allCorrect` here, and its absence is the point. Mistakes are
/// allowed now — up to [kMistakeBudget] — so a level can bank with wrong
/// answers in it, and a client that read "every result correct" as "the level
/// passed" would send the learner back to the top of a level they had just
/// finished. Past the budget the server does not answer with this at all: it
/// refuses with OUT_OF_HEARTS and writes nothing.
@freezed
abstract class SubmitResult with _$SubmitResult {
  const factory SubmitResult({
    required LearnUnit unit,
    @Default(<ExerciseResult>[]) List<ExerciseResult> results,
  }) = _SubmitResult;

  factory SubmitResult.fromJson(Map<String, dynamic> json) =>
      _$SubmitResultFromJson(json);
}

/// The server's verdict on ONE question, from `/learn/answer`.
///
/// The client never builds one of these from the answer key. It is the whole
/// reason that endpoint exists: the quiz is one question to a screen, and the
/// half second between committing to an answer and being told is where the
/// teaching happens.
@freezed
abstract class AnswerVerdict with _$AnswerVerdict {
  const factory AnswerVerdict({
    required bool correct,
    @Default('') String message,

    /// The whole corrected line, and ONLY on a miss — reading the finished
    /// sentence right is what makes the next one easier. Null for the
    /// free-text questions, which have no single right answer.
    String? solution,
  }) = _AnswerVerdict;

  factory AnswerVerdict.fromJson(Map<String, dynamic> json) =>
      _$AnswerVerdictFromJson(json);
}

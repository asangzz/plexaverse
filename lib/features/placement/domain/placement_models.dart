/// The placement test's wire shapes, one to one with the web's
/// `PlacementStatus`, `PlacementStep` and `PlacementResult`
/// (`lib/services/placement.service.ts`) and `PublicPlacementItem`
/// (`lib/placement/engine.ts`).
///
/// ## Nothing here can say whether an answer was right
///
/// The server strips every item to its prompt and options before it leaves —
/// no answer key, no band, no bank id (the bank id is band-coded, so even that
/// would leak the verdict). [PublicPlacementItem.id] is an opaque per-attempt
/// handle, `step-N`, sent back exactly as it arrived. A placement test that
/// teaches mid-way measures the teaching, so the models give the screen
/// nothing to mark an answer with, by construction.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

import 'cefr_band.dart';

part 'placement_models.freezed.dart';
part 'placement_models.g.dart';

/// The three objective parts, in the order the test runs them
/// (`OBJECTIVE_SKILLS`). Writing is an optional fourth step after the band is
/// set, and is not one of these.
enum ObjectiveSkill {
  vocabulary('Vocabulary'),
  grammar('Grammar'),
  reading('Reading');

  const ObjectiveSkill(this.label);

  /// `SKILL_LABEL` on the web.
  final String label;

  String get wire => name;

  /// "Part 2 of 3" — read off this enum's order, never restated.
  String get partOf => 'Part ${index + 1} of ${values.length}';

  /// A part off the wire, or null for anything that is not one.
  static ObjectiveSkill? parse(Object? raw) {
    for (final ObjectiveSkill skill in values) {
      if (skill.name == raw) return skill;
    }
    return null;
  }
}

/// Where a step stands.
///
/// [writing] means the attempt is already COMPLETED: the answer that finished
/// the third part set the band in the same write, and the writing task that
/// follows is optional feedback that never moves it.
enum PlacementStage {
  objective,
  writing;

  String get wire => name;

  /// Unknown reads as [objective]: a step the page cannot place then shows
  /// "This question did not load", whose Try again asks the server where the
  /// attempt really is.
  static PlacementStage parse(Object? raw) =>
      raw == 'writing' ? PlacementStage.writing : PlacementStage.objective;
}

/// The task every learner gets (`WRITING_TASK` in `lib/placement/writing.ts`).
///
/// A step at the writing stage carries the task the server grades against;
/// this is the same text, kept as the fallback for the intro's "Add the
/// writing", which opens the step without one.
const WritingTask standardWritingTask = WritingTask(
  prompt:
      'In 3–6 sentences, introduce what you do at work and describe one '
      'thing you achieved recently.',
  hint:
      'Write as you would on LinkedIn. There is no right answer — this shows '
      'how you write, not what you have done.',
);

/// The optional writing task. [minChars] and [maxChars] are the limits the
/// server enforces, counted after trimming, so the Grade button wakes at
/// exactly the length the server will accept.
@freezed
abstract class WritingTask with _$WritingTask {
  const factory WritingTask({
    @Default('') String prompt,
    @Default('') String hint,
    @Default(30) int minChars,
    @Default(1200) int maxChars,
  }) = _WritingTask;

  factory WritingTask.fromJson(Map<String, dynamic> json) =>
      _$WritingTaskFromJson(json);
}

/// One question, without its answer or its band.
@freezed
abstract class PublicPlacementItem with _$PublicPlacementItem {
  const factory PublicPlacementItem({
    /// The handle for THIS question in THIS attempt (`step-N`), not a bank
    /// id. Never built or parsed here.
    @Default('') String id,
    @JsonKey(fromJson: ObjectiveSkill.parse, toJson: _skillWire)
    ObjectiveSkill? skill,

    /// Reading questions only.
    String? passage,
    @Default('') String prompt,

    /// Four, in the bank's order — placement options are not shuffled,
    /// unlike the lesson's. The answer goes back as the option's TEXT.
    @Default(<String>[]) List<String> options,
  }) = _PublicPlacementItem;

  factory PublicPlacementItem.fromJson(Map<String, dynamic> json) =>
      _$PublicPlacementItemFromJson(json);
}

/// Which parts an attempt actually tested.
///
/// False on a test that closed on a walk-away means that part's band was
/// CREDITED — the level held before, pulled down to the lowest part that was
/// measured — not scored. Missing reads as measured: every part of a finished
/// test was.
@freezed
abstract class PlacementMeasured with _$PlacementMeasured {
  const PlacementMeasured._();

  const factory PlacementMeasured({
    @Default(true) bool vocabulary,
    @Default(true) bool grammar,
    @Default(true) bool reading,
  }) = _PlacementMeasured;

  factory PlacementMeasured.fromJson(Map<String, dynamic> json) =>
      _$PlacementMeasuredFromJson(json);

  bool of(ObjectiveSkill skill) => switch (skill) {
    ObjectiveSkill.vocabulary => vocabulary,
    ObjectiveSkill.grammar => grammar,
    ObjectiveSkill.reading => reading,
  };
}

/// What a model said about the optional writing. Up to three lines each.
@freezed
abstract class WritingFeedback with _$WritingFeedback {
  const WritingFeedback._();

  const factory WritingFeedback({
    @Default(<String>[]) List<String> strengths,
    @Default(<String>[]) List<String> improvements,
  }) = _WritingFeedback;

  factory WritingFeedback.fromJson(Map<String, dynamic> json) =>
      _$WritingFeedbackFromJson(json);

  bool get isEmpty => strengths.isEmpty && improvements.isEmpty;
}

/// The open attempt, as of the read that reported it.
@freezed
abstract class PlacementInProgress with _$PlacementInProgress {
  const factory PlacementInProgress({
    @Default('') String attemptId,
    @Default(0) int answered,

    /// When it closes on what it holds if nothing more is answered: 24 hours
    /// after the last answer, never later than 48 hours after the start.
    @JsonKey(fromJson: _instant, toJson: _instantWire) DateTime? closesAt,
  }) = _PlacementInProgress;

  factory PlacementInProgress.fromJson(Map<String, dynamic> json) =>
      _$PlacementInProgressFromJson(json);
}

/// The latest completed attempt, as the status card shows it.
@freezed
abstract class PlacementSummary with _$PlacementSummary {
  const PlacementSummary._();

  const factory PlacementSummary({
    @Default('') String attemptId,
    @JsonKey(fromJson: _instant, toJson: _instantWire) DateTime? completedAt,
    @JsonKey(fromJson: CefrBand.parse, toJson: _bandWire) CefrBand? band,
    @JsonKey(fromJson: CefrBand.parse, toJson: _bandWire)
    CefrBand? vocabularyBand,
    @JsonKey(fromJson: CefrBand.parse, toJson: _bandWire) CefrBand? grammarBand,
    @JsonKey(fromJson: CefrBand.parse, toJson: _bandWire) CefrBand? readingBand,
    @JsonKey(fromJson: CefrBand.parse, toJson: _bandWire) CefrBand? writingBand,
    WritingFeedback? writingFeedback,

    /// The three parts are done and no writing has been sent: the optional
    /// writing step can still be taken for this result.
    @Default(false) bool writingPending,

    /// Closed on what it held after the learner walked away, rather than
    /// finished.
    @Default(false) bool closedEarly,
    @Default(PlacementMeasured()) PlacementMeasured measured,
  }) = _PlacementSummary;

  factory PlacementSummary.fromJson(Map<String, dynamic> json) =>
      _$PlacementSummaryFromJson(json);

  /// The three part bands, or null unless the row carries all three
  /// (`skillsOf` on the web).
  Map<ObjectiveSkill, CefrBand>? get skillBands =>
      _skills(vocabularyBand, grammarBand, readingBand);
}

/// `GET /placement` — the learner's band, the last result, an open attempt,
/// and whether Start works now.
@freezed
abstract class PlacementStatus with _$PlacementStatus {
  const factory PlacementStatus({
    /// The band lessons are written at now. The server reports
    /// [defaultBand] until a test completes, so a missing value reads as it
    /// would have.
    @JsonKey(fromJson: _bandOrDefault, toJson: _bandWire)
    @Default(defaultBand)
    CefrBand band,
    @Default(false) bool hasPlacement,
    PlacementSummary? latest,

    /// Open as of this read, not for good — see [PlacementInProgress.closesAt].
    PlacementInProgress? inProgress,

    /// False only during the 30-day cooldown with nothing open.
    @Default(true) bool canStart,
    @JsonKey(fromJson: _instant, toJson: _instantWire) DateTime? nextRetakeAt,

    /// The learner has agreed to their writing being sent to a model
    /// (`assessment_grading`), so the writing step need not ask.
    @Default(false) bool writingConsent,
  }) = _PlacementStatus;

  factory PlacementStatus.fromJson(Map<String, dynamic> json) =>
      _$PlacementStatusFromJson(json);
}

/// What the test is asking now: a question, or the writing task of an attempt
/// that is already complete.
@freezed
abstract class PlacementStep with _$PlacementStep {
  const factory PlacementStep({
    @Default('') String attemptId,
    @JsonKey(fromJson: PlacementStage.parse, toJson: _stageWire)
    @Default(PlacementStage.objective)
    PlacementStage stage,

    /// The part being tested. Null at the writing stage.
    @JsonKey(fromJson: ObjectiveSkill.parse, toJson: _skillWire)
    ObjectiveSkill? skill,

    /// Null at the writing stage.
    PublicPlacementItem? item,
    @Default(0) int answered,

    /// A progress figure, not a promise: the staircase decides the real
    /// length.
    @Default(0) int estimatedTotal,

    /// Set at the writing stage only.
    WritingTask? writingTask,

    /// The same instant [PlacementInProgress.closesAt] reports; it moves with
    /// each answer, up to the two-day cap. Null at the writing stage.
    @JsonKey(fromJson: _instant, toJson: _instantWire) DateTime? closesAt,
  }) = _PlacementStep;

  factory PlacementStep.fromJson(Map<String, dynamic> json) =>
      _$PlacementStepFromJson(json);
}

/// A completed attempt's result — what writing and finish answer with.
@freezed
abstract class PlacementResult with _$PlacementResult {
  const PlacementResult._();

  const factory PlacementResult({
    @JsonKey(fromJson: CefrBand.parse, toJson: _bandWire) CefrBand? band,
    @JsonKey(fromJson: CefrBand.parse, toJson: _bandWire)
    CefrBand? vocabularyBand,
    @JsonKey(fromJson: CefrBand.parse, toJson: _bandWire) CefrBand? grammarBand,
    @JsonKey(fromJson: CefrBand.parse, toJson: _bandWire) CefrBand? readingBand,
    @JsonKey(fromJson: CefrBand.parse, toJson: _bandWire) CefrBand? writingBand,
    WritingFeedback? writingFeedback,

    /// Text was sent for grading, whether or not a grade came back.
    @Default(false) bool writingSubmitted,

    /// When the band was set — the retake date counts from here, not from
    /// whenever this screen is looked at.
    @JsonKey(fromJson: _instant, toJson: _instantWire) DateTime? completedAt,
    @Default(false) bool closedEarly,
    @Default(PlacementMeasured()) PlacementMeasured measured,
  }) = _PlacementResult;

  factory PlacementResult.fromJson(Map<String, dynamic> json) =>
      _$PlacementResultFromJson(json);

  Map<ObjectiveSkill, CefrBand>? get skillBands =>
      _skills(vocabularyBand, grammarBand, readingBand);
}

Map<ObjectiveSkill, CefrBand>? _skills(
  CefrBand? vocabulary,
  CefrBand? grammar,
  CefrBand? reading,
) {
  if (vocabulary == null || grammar == null || reading == null) return null;
  return <ObjectiveSkill, CefrBand>{
    ObjectiveSkill.vocabulary: vocabulary,
    ObjectiveSkill.grammar: grammar,
    ObjectiveSkill.reading: reading,
  };
}

CefrBand _bandOrDefault(Object? raw) => CefrBand.parse(raw) ?? defaultBand;

String? _bandWire(CefrBand? band) => band?.wire;

String? _skillWire(ObjectiveSkill? skill) => skill?.wire;

String _stageWire(PlacementStage stage) => stage.wire;

/// An ISO instant off the wire. Unreadable is null rather than a throw: every
/// date here is advisory (a closing time, a retake date), and a screen that
/// cannot read one states the rule instead.
DateTime? _instant(Object? raw) =>
    raw is String ? DateTime.tryParse(raw) : null;

String? _instantWire(DateTime? at) => at?.toUtc().toIso8601String();

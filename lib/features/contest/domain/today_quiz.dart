import 'package:freezed_annotation/freezed_annotation.dart';

part 'today_quiz.freezed.dart';
part 'today_quiz.g.dart';

/// Whether there is a lesson today, and if not, which screen says why.
/// Mirrors `QuizStatus` in the web's `lib/services/contest-quiz.service.ts`.
///
/// An unknown status reads as [noQuizToday]: a screen with nothing to
/// answer that still says the contest is there.
enum QuizStatus {
  @JsonValue('no_contest')
  noContest,
  @JsonValue('not_joined')
  notJoined,
  upcoming,
  ended,
  @JsonValue('no_quiz_today')
  noQuizToday,
  ready,
}

/// Why there is no lesson. Mirrors `QuizUnavailableReason`. Only
/// [bankEnded] changes what a screen says; the rest restate the status.
enum QuizReason {
  @JsonValue('no_contest')
  noContest,
  @JsonValue('not_joined')
  notJoined,
  @JsonValue('not_started')
  notStarted,
  @JsonValue('contest_ended')
  contestEnded,

  /// The authored questions for this band have run out before today.
  @JsonValue('bank_ended')
  bankEnded,
}

/// What a question tests. Mirrors `QuizSkill` in `lib/contest-quiz/types.ts`.
///
/// [other] is the guard for a skill this build does not know: the question
/// still plays, under the plain word "Lesson" rather than a wrong name.
enum QuizSkill {
  vocabulary,
  grammar,

  /// Register, collocation and phrasing — the right way to say it at work.
  usage,

  /// Carries a passage.
  reading,
  other;

  /// The kicker's word. The web's `SKILL_LABEL`, verbatim.
  String get label => switch (this) {
    QuizSkill.vocabulary => 'Vocabulary',
    QuizSkill.grammar => 'Grammar',
    QuizSkill.usage => 'Saying it at work',
    QuizSkill.reading => 'Reading',
    QuizSkill.other => 'Lesson',
  };
}

/// One question as the learner sees it before answering: never the answer,
/// never the explanation, never the band. Mirrors `PublicQuizItem`.
@freezed
abstract class PublicQuizItem with _$PublicQuizItem {
  const PublicQuizItem._();

  const factory PublicQuizItem({
    /// A bank question's `qz-b1-0001`, or `ai-<day>-<n>` for one written for
    /// this learner. Sent back with the answer.
    @Default('') String id,
    @JsonKey(unknownEnumValue: QuizSkill.other)
    @Default(QuizSkill.other)
    QuizSkill skill,

    /// Reading questions only: a short workplace text.
    String? passage,
    @Default('') String prompt,

    /// Four, in THIS learner's order (shuffled per learner, stable across
    /// reloads). The answer travels back as the option's TEXT — never its
    /// index, which would re-point under another learner's order.
    @Default(<String>[]) List<String> options,
  }) = _PublicQuizItem;

  factory PublicQuizItem.fromJson(Map<String, dynamic> json) =>
      _$PublicQuizItemFromJson(json);

  /// Written for this learner — the web's "For your work" tag. The web's
  /// `isAiItemId`, the same pattern.
  bool get isOwn => _ownId.hasMatch(id);

  static final RegExp _ownId = RegExp(r'^ai-\d+-\d+$');
}

/// An answered question, with what is revealed once it is answered. Mirrors
/// `QuizAnswerView`.
@freezed
abstract class QuizAnswerView with _$QuizAnswerView {
  const factory QuizAnswerView({
    @Default('') String itemId,

    /// The option text the record holds.
    @Default('') String value,
    @Default(false) bool correct,
    @Default('') String correctOption,
    @Default('') String explain,

    /// What the ledger paid this answer — its own event, read from the
    /// ledger, never inferred from whether scoring is paused now. NULL means
    /// it was given while scoring was paused and is never paid: "Not
    /// scored", not "0 XP".
    int? pointsApplied,
  }) = _QuizAnswerView;

  factory QuizAnswerView.fromJson(Map<String, dynamic> json) =>
      _$QuizAnswerViewFromJson(json);
}

/// The ledger's total for today's lesson.
///
/// [points] counts each answer's event and the finishing bonus — NOT the day
/// credit or the week's bonus, which the finishing answer's `pointsApplied`
/// does include. The two figures differ by design on the web too.
@freezed
abstract class QuizScore with _$QuizScore {
  const factory QuizScore({
    @Default(0) int correct,
    @Default(0) int wrong,
    @Default(0) int points,
  }) = _QuizScore;

  factory QuizScore.fromJson(Map<String, dynamic> json) =>
      _$QuizScoreFromJson(json);
}

/// What finishing pays, and how many right answers it needs.
@freezed
abstract class FinishBonus with _$FinishBonus {
  const factory FinishBonus({
    @Default(0) int points,
    @Default(0) int minCorrect,
  }) = _FinishBonus;

  factory FinishBonus.fromJson(Map<String, dynamic> json) =>
      _$FinishBonusFromJson(json);
}

/// Today's lesson as it stands. `GET /contest/lesson` and the `POST` that
/// opens it both answer `{quiz}` with this. Mirrors `TodayQuiz`.
///
/// Every field but [status] is present only when it means something, and the
/// ones whose absence the web reads differently from `false` stay nullable.
@freezed
abstract class TodayQuiz with _$TodayQuiz {
  const TodayQuiz._();

  const factory TodayQuiz({
    @JsonKey(unknownEnumValue: QuizStatus.noQuizToday)
    @Default(QuizStatus.noQuizToday)
    QuizStatus status,

    /// Every status but `ready`.
    @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)
    QuizReason? reason,
    String? contestId,

    /// The contest day the questions belong to — sent back with every
    /// answer, so a lesson left open past midnight is refused NOT_TODAY.
    int? day,

    /// The band the questions are drawn at (`A1`…`C2`).
    String? band,

    /// Today's band is fixed for the day.
    @Default(false) bool bandLocked,

    /// Will there be a lesson tomorrow at today's band? Null when the server
    /// has not said — and then nothing is promised.
    bool? tomorrow,

    /// The lesson has been opened (`POST`), so its personal questions are in
    /// [questions] if they were written. False on a fresh day: the player
    /// opens it and waits before the first answer.
    bool? started,

    /// How many of [questions] were written for this learner; 0 when that
    /// failed, and the lesson is the set questions alone.
    @Default(0) int ownQuestions,

    /// All of today's questions, answered or not, in lesson order.
    @Default(<PublicQuizItem>[]) List<PublicQuizItem> questions,

    /// In the order they were answered.
    @Default(<QuizAnswerView>[]) List<QuizAnswerView> answered,
    @Default(false) bool completed,
    QuizScore? score,
    FinishBonus? finishBonus,

    /// An answer given NOW earns nothing, ever. Says nothing about answers
    /// already given — each carries what the ledger paid it.
    @Default(false) bool scoringPaused,

    /// Today's contest day key (`YYYY-MM-DD`, the contest's timezone), sent
    /// only while `ready`: a lesson part's node id — what Skip is keyed on —
    /// is `<dayKey>:lesson:<k>`. Null from a server before Skip, and then the
    /// player offers no "Skip this part".
    String? dayKey,

    /// Lesson parts (1-based, sorted) skipped today. Each stays open beside
    /// the next part until the day ends.
    @Default(<int>[]) List<int> skippedParts,
  }) = _TodayQuiz;

  factory TodayQuiz.fromJson(Map<String, dynamic> json) =>
      _$TodayQuizFromJson(json);

  bool get isReady => status == QuizStatus.ready;

  int get total => questions.length;
  int get answeredCount => answered.length;

  /// The stored answer to [itemId], or null while it is unanswered.
  QuizAnswerView? answerFor(String itemId) {
    for (final QuizAnswerView a in answered) {
      if (a.itemId == itemId) return a;
    }
    return null;
  }

  /// The first question in lesson order with no answer, or null once every
  /// one has one.
  ///
  /// Within a part, questions are answered in order; a skipped part stays
  /// open beside the next one (`lessonPartStates`).
  int? get firstUnansweredIndex {
    for (int i = 0; i < questions.length; i++) {
      if (answerFor(questions[i].id) == null) return i;
    }
    return null;
  }
}

/// What one answer returns (`POST /contest/quiz/answer` → `{result}`).
/// Mirrors `QuizAnswerResult`.
@freezed
abstract class QuizAnswerResult with _$QuizAnswerResult {
  const factory QuizAnswerResult({
    /// The option text the RECORD holds — on a replay, the first attempt's,
    /// which may not be the one just sent. Shown instead of the local pick.
    @Default('') String value,
    @Default(false) bool correct,
    @Default('') String correctOption,
    @Default('') String explain,

    /// Every question of today is now answered.
    @Default(false) bool completed,

    /// A first attempt: ALL the XP this request moved — the answer, plus the
    /// day credit, the finishing bonus and the week's bonus when it brought
    /// them. A replay: the first attempt's own event only.
    @Default(0) int pointsApplied,

    /// Whether the ledger pays this answer at all; false when it was recorded
    /// while scoring was paused.
    @Default(true) bool scored,

    /// This answer completed the contest week: what the week's bonus paid
    /// (already inside [pointsApplied]), 0 while paused. Null otherwise, and
    /// always on a replay.
    int? weekBonus,

    /// Already answered elsewhere (another device, a lost reply): this is
    /// that answer read back, and nothing was recorded or paid now.
    @Default(false) bool replay,
  }) = _QuizAnswerResult;

  factory QuizAnswerResult.fromJson(Map<String, dynamic> json) =>
      _$QuizAnswerResultFromJson(json);
}

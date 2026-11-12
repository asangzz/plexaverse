import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/week/week_shape.dart';
import 'contest_path.dart';

// The connect level's targets are the /connections flow's own batch, one DTO
// for both: the contest route answers exactly what `ai/connections` does.
export '../../engagement/domain/connection_target.dart'
    show ConnectionBatch, ConnectionTarget;

part 'contest_tasks.freezed.dart';
part 'contest_tasks.g.dart';

// The LinkedIn tasks' wire shapes. Each mirrors its type in the web's
// `lib/contest-path-types.ts` or `lib/services/contest-tasks.service.ts`, one
// to one, so a renamed field shows up as a parse that no longer matches the
// fixture copied from the web.

// ── The comment level (every day) ──────────────────────────────────────────

/// Mirrors `CommentLevelView['status']`. Unknown reads as unavailable:
/// nothing to fill in.
enum CommentLevelStatus { unavailable, open, done }

/// Why there is no comment level today. Mirrors `CommentLevelView['reason']`.
///
/// No reason at all on an unavailable level means the comment could not be
/// written this time — see [CommentLevelView.notWritten]. An unknown reason
/// reads as that too.
enum CommentLevelReason {
  @JsonValue('not_today')
  notToday,
  @JsonValue('no_post')
  noPost,
  @JsonValue('not_running')
  notRunning,
  @JsonValue('not_joined')
  notJoined,

  /// Another request is writing today's comment right now: ask again shortly.
  writing,
}

/// How the day's FIRST submission went — the only one that can pay.
enum CommentFirstTry { none, right, wrong }

/// The top voice's post the comment answers.
@freezed
abstract class CommentPost with _$CommentPost {
  const factory CommentPost({
    @Default('') String author,
    @Default('') String firstLine,

    /// Only once the level is done. Filtered to `https` by the server, and
    /// opened only on a LinkedIn host by the app — `isLinkedInHost`.
    String? postUrl,
  }) = _CommentPost;

  factory CommentPost.fromJson(Map<String, dynamic> json) =>
      _$CommentPostFromJson(json);
}

/// `GET /contest/tasks/comment` → `{level}`. Mirrors `CommentLevelView`.
///
/// The comment with its blanks, the word bank and the post — never the
/// answers, and never the post's link, until a submission gets every blank
/// right. Then [comment], [answers] and `post.postUrl` arrive.
@freezed
abstract class CommentLevelView with _$CommentLevelView {
  const CommentLevelView._();

  const factory CommentLevelView({
    @JsonKey(unknownEnumValue: CommentLevelStatus.unavailable)
    @Default(CommentLevelStatus.unavailable)
    CommentLevelStatus status,
    @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)
    CommentLevelReason? reason,
    CommentPost? post,

    /// The comment with `{{1}}` … `{{n}}` where the blanks go.
    String? template,
    int? blankCount,

    /// Answers and distractors, shuffled once for the day.
    @Default(<String>[]) List<String> bank,
    @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)
    CommentFirstTry? firstTry,

    /// Once done: the right word for each blank, in order.
    @Default(<String>[]) List<String> answers,

    /// Once done: the finished comment, ready to copy.
    String? comment,

    /// What the day's comment has paid.
    int? pointsApplied,
  }) = _CommentLevelView;

  factory CommentLevelView.fromJson(Map<String, dynamic> json) =>
      _$CommentLevelViewFromJson(json);

  /// Unavailable with no reason: the comment could not be written this time.
  /// The web calls this `not_written`.
  bool get notWritten =>
      status == CommentLevelStatus.unavailable && reason == null;

  /// Being written by another request: the page asks again shortly.
  bool get isWriting =>
      status == CommentLevelStatus.unavailable &&
      reason == CommentLevelReason.writing;
}

/// One blank of a submission, graded. The right word is ALWAYS returned.
@freezed
abstract class CommentBlank with _$CommentBlank {
  const factory CommentBlank({
    @Default('') String value,
    @Default(false) bool correct,
    @Default('') String answer,
  }) = _CommentBlank;

  factory CommentBlank.fromJson(Map<String, dynamic> json) =>
      _$CommentBlankFromJson(json);
}

/// `POST /contest/tasks/comment/answer` → `{result}`. Mirrors
/// `CommentSubmitResult`.
@freezed
abstract class CommentSubmitResult with _$CommentSubmitResult {
  const factory CommentSubmitResult({
    /// Every blank right.
    @Default(false) bool correct,

    /// One per blank, in order.
    @Default(<CommentBlank>[]) List<CommentBlank> blanks,

    /// This was the day's first submission — the one that scores.
    @Default(false) bool firstTry,

    /// What THIS submission paid.
    @Default(0) int pointsApplied,

    /// The level after it: done, with the comment and the post's link, once
    /// every blank is right.
    required CommentLevelView level,
  }) = _CommentSubmitResult;

  factory CommentSubmitResult.fromJson(Map<String, dynamic> json) =>
      _$CommentSubmitResultFromJson(json);
}

// ── Post 5 valuable comments (every day) ────────────────────────────────────

/// Mirrors `FeedCommentsView['status']`.
enum FeedCommentsStatus { unavailable, open, done, revoked }

/// Mirrors `FeedCommentsView['reason']`.
enum FeedCommentsReason {
  @JsonValue('not_running')
  notRunning,
  @JsonValue('not_joined')
  notJoined,
  @JsonValue('not_today')
  notToday,
}

/// `GET /contest/tasks/feed-comments` → `{view}`. Mirrors `FeedCommentsView`.
///
/// The five links go in ONE AT A TIME and each pays its share as it lands.
/// A pure read: it does not check the lock — the path does.
@freezed
abstract class FeedCommentsView with _$FeedCommentsView {
  const FeedCommentsView._();

  const factory FeedCommentsView({
    @JsonKey(unknownEnumValue: FeedCommentsStatus.unavailable)
    @Default(FeedCommentsStatus.unavailable)
    FeedCommentsStatus status,
    @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)
    FeedCommentsReason? reason,

    /// How many links the day asks for.
    @Default(5) int perDay,

    /// What the five pay IN TOTAL.
    @Default(0) int points,

    /// What comment 1…5 pays; they sum to [points].
    @Default(<int>[]) List<int> shares,

    /// What a false claim costs on top of what it paid. The warning before
    /// the send button names it, and drops the clause when it is 0.
    @Default(0) int penalty,

    /// Today's links so far, normalised, in the order sent.
    @Default(<String>[]) List<String> links,

    /// What each of [links] paid. ABSENT on a day sent five-at-once (before
    /// 11 Nov 2026) — null, not empty, so a page does not print "+0 XP"
    /// beside links that were paid as one.
    List<int>? linkPoints,

    /// What the day has paid so far.
    int? pointsApplied,
    String? revokeReason,

    /// The whole deduction a revoke wrote, as a positive number.
    int? pointsDeducted,
  }) = _FeedCommentsView;

  factory FeedCommentsView.fromJson(Map<String, dynamic> json) =>
      _$FeedCommentsViewFromJson(json);

  /// Which comment of the day the next link would be, 1-based.
  int get nextNumber => links.length + 1;

  /// What the next link would pay, 0 once the five are in.
  int get nextShare => links.length < shares.length ? shares[links.length] : 0;
}

/// Mirrors `FeedCommentSubmitResult['status']`.
enum FeedCommentSubmitStatus { open, done }

/// `POST /contest/tasks/feed-comments` → `{result}`. Mirrors
/// `FeedCommentSubmitResult`.
@freezed
abstract class FeedCommentSubmitResult with _$FeedCommentSubmitResult {
  const factory FeedCommentSubmitResult({
    @Default('') String taskId,

    /// `done` once this was the fifth.
    @JsonKey(unknownEnumValue: FeedCommentSubmitStatus.open)
    @Default(FeedCommentSubmitStatus.open)
    FeedCommentSubmitStatus status,

    /// Which comment of the day this was, 1…5.
    @Default(1) int n,

    /// What the ledger paid for THIS comment; 0 while scoring is paused.
    @Default(0) int pointsApplied,

    /// What the day has paid so far, this one included.
    @Default(0) int dayPoints,
    @Default(<String>[]) List<String> links,
  }) = _FeedCommentSubmitResult;

  factory FeedCommentSubmitResult.fromJson(Map<String, dynamic> json) =>
      _$FeedCommentSubmitResultFromJson(json);
}

// ── Connect with leaders (Mon, Thu) ─────────────────────────────────────────

/// `POST /contest/tasks/connect` → `{result}`. Mirrors `ConnectTaskResult`.
@freezed
abstract class ConnectTaskResult with _$ConnectTaskResult {
  const factory ConnectTaskResult({
    @Default('') String taskId,
    @Default('done') String status,

    /// What the ledger paid; 0 while scoring is paused, and on a repeat what
    /// it paid the first time.
    @Default(0) int pointsApplied,

    /// Already done today — nothing was paid by this request.
    @Default(false) bool alreadyDone,
  }) = _ConnectTaskResult;

  factory ConnectTaskResult.fromJson(Map<String, dynamic> json) =>
      _$ConnectTaskResultFromJson(json);
}

// ── Weekly invites (Sat) ────────────────────────────────────────────────────

/// The largest screenshot the invites level takes: 8 MB, the server's
/// `MAX_PROOF_BYTES`. Checked before the upload, so an oversized file costs
/// the learner a sentence instead of eight megabytes of mobile data.
const int kMaxInvitesScreenshotBytes = 8 * 1024 * 1024;

/// `POST /contest/tasks/invites` → `{result}`. Mirrors `InvitesSubmitResult`.
///
/// Paid at once, then checked by our team. There is no GET for invites: the
/// task's state comes from its node on the path.
@freezed
abstract class InvitesSubmitResult with _$InvitesSubmitResult {
  const factory InvitesSubmitResult({
    @Default('') String taskId,
    @Default('done') String status,

    /// What the ledger paid; 0 while scoring is paused.
    @Default(0) int pointsApplied,

    /// It replaced a screenshot sent under the old review flow.
    @Default(false) bool replaced,
  }) = _InvitesSubmitResult;

  factory InvitesSubmitResult.fromJson(Map<String, dynamic> json) =>
      _$InvitesSubmitResultFromJson(json);
}

// ── Plan this week (Sun) ────────────────────────────────────────────────────

/// Mirrors `PlanWeekView['status']`.
enum PlanWeekStatus { unavailable, locked, open, done }

/// Mirrors `PlanWeekView['reason']`.
enum PlanWeekReason {
  @JsonValue('not_running')
  notRunning,
  @JsonValue('not_joined')
  notJoined,
  @JsonValue('not_today')
  notToday,
}

String _dayKindWire(DayKind kind) => kind.wire;

/// One planner day of the week being planned. Mirrors `PlanWeekDay`.
@freezed
abstract class PlanWeekDay with _$PlanWeekDay {
  const factory PlanWeekDay({
    /// WEEK_SHAPE's index: 0 = Monday … 6 = Sunday. The days ARRIVE in
    /// calendar order, the week's Sunday first.
    @Default(0) int index,

    /// "Wednesday".
    @Default('') String weekday,

    /// `YYYY-MM-DD`, the planner's own date for the slot, in the USER's
    /// timezone.
    @Default('') String dayKey,
    @JsonKey(fromJson: DayKind.parse, toJson: _dayKindWire)
    @Default(DayKind.post)
    DayKind kind,
    String? title,

    /// The server's words: "Approved and scheduled", "Script ready", "Rest".
    @Default('') String status,

    /// Ready for its day. Drives the tick.
    @Default(false) bool ready,

    /// What to do with it, and when its link is asked for — written by the
    /// server, date included.
    @Default('') String instruction,
  }) = _PlanWeekDay;

  factory PlanWeekDay.fromJson(Map<String, dynamic> json) =>
      _$PlanWeekDayFromJson(json);
}

/// `GET /contest/tasks/plan` → `{view}`. Mirrors `PlanWeekView`.
@freezed
abstract class PlanWeekView with _$PlanWeekView {
  const factory PlanWeekView({
    @JsonKey(unknownEnumValue: PlanWeekStatus.unavailable)
    @Default(PlanWeekStatus.unavailable)
    PlanWeekStatus status,
    @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)
    PlanWeekReason? reason,

    /// "Unlocks after …" while locked.
    String? lockedDetail,

    /// The planner week planned — on a Sunday, the week it starts — and its
    /// journey number.
    @Default(1) int weekNumber,
    @Default(1) int season,

    /// The week exists in the Planner. "I've planned this week" waits on it.
    @Default(false) bool planned,
    String? topic,

    /// A WEB path (`/planner?week=N`). The app opens its own Planner.
    @Default('') String plannerHref,
    @Default(<PlanWeekDay>[]) List<PlanWeekDay> days,
  }) = _PlanWeekView;

  factory PlanWeekView.fromJson(Map<String, dynamic> json) =>
      _$PlanWeekViewFromJson(json);
}

/// `POST /contest/tasks/plan` → `{result}`. Mirrors `PlanWeekResult`.
@freezed
abstract class PlanWeekResult with _$PlanWeekResult {
  const factory PlanWeekResult({
    @Default('') String taskId,
    @Default('done') String status,

    /// Already marked today — nothing changed.
    @Default(false) bool alreadyDone,
  }) = _PlanWeekResult;

  factory PlanWeekResult.fromJson(Map<String, dynamic> json) =>
      _$PlanWeekResultFromJson(json);
}

// ── The article and the videos, claimed by link ─────────────────────────────

/// `POST /contest/tasks/claim` → `{result}`. Mirrors `ClaimResult`: the claim
/// is now pending, with the link the server normalised.
@freezed
abstract class ClaimResult with _$ClaimResult {
  const factory ClaimResult({
    @Default('') String taskId,
    required PostClaim claim,
  }) = _ClaimResult;

  factory ClaimResult.fromJson(Map<String, dynamic> json) =>
      _$ClaimResultFromJson(json);
}

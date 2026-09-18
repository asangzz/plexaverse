import 'package:freezed_annotation/freezed_annotation.dart';

part 'plan_slot.freezed.dart';
part 'plan_slot.g.dart';

/// Where a slot is in its life. Mirrors `DailyPostSlot['status']` in the web's
/// `lib/services/week-plan.service.ts`.
///
/// The order matters — it is the progression a slot moves through, and the
/// server reconciles a slot forward against the real post on every read.
enum SlotStatus {
  /// The week has a title for this day, but nothing is written yet.
  planned,

  /// Generation is in flight.
  generating,

  /// A draft exists and is waiting for the user to approve it.
  generated,

  /// Approved and scheduled. It will go out on its own.
  approved,

  /// Actually on LinkedIn.
  ///
  /// The server will only report this when the post has a real LinkedIn share
  /// URN — a client cannot claim it. A historic bug stamped slots 'published'
  /// on a FAILED publish, so the server now demotes any slot whose post never
  /// reached LinkedIn.
  published;

  static SlotStatus parse(String? raw) => switch (raw) {
    'generating' => SlotStatus.generating,
    'generated' => SlotStatus.generated,
    'approved' => SlotStatus.approved,
    'published' => SlotStatus.published,
    _ => SlotStatus.planned,
  };

  String get wire => name;
}

/// One day of the week's plan.
///
/// A week is NOT seven posts that share a topic. It is **one long-form article
/// plus six posts that argue facets of it** (CLAUDE.md §6b). The weekday titles
/// are chosen from the Sunday article's own section headings, which is why they
/// read as one argument rather than seven angles on a subject.
@freezed
abstract class PlanSlot with _$PlanSlot {
  const PlanSlot._();

  const factory PlanSlot({
    /// 'Monday' … 'Sunday'.
    required String day,

    /// The content type — 'niche', 'general', 'productive', 'poll'.
    @Default('general') String type,

    /// 'text' | 'image' | 'poll' | 'carousel'.
    @Default('text') String format,

    /// The editorial angle the model was given. Free text it may rewrite.
    @Default('') String angle,
    @Default('') String title,
    @Default(false) bool titleEditedByUser,
    @Default(<String>[]) List<String> hashtags,
    @JsonKey(unknownEnumValue: SlotStatus.planned)
    @Default(SlotStatus.planned)
    SlotStatus status,

    /// The server id of the generated post, once one exists.
    String? postId,

    /// A maintenance-mode rest day. Reduced-cadence users (3 posts a week) get
    /// these; the Sunday article still generates regardless, because it is the
    /// week's spine rather than one of its posts.
    @Default(false) bool restDay,

    /// This slot carries a takeaway in its first comment. Decided by the
    /// planner rather than at generation time, so the user can see which days
    /// will have one before any of them are written.
    String? artifact,

    /// Which poster style this day gets — 'comparison', 'infographic', …
    /// A property of the WEEK, not a coin flip per post.
    String? posterTag,
  }) = _PlanSlot;

  factory PlanSlot.fromJson(Map<String, dynamic> json) =>
      _$PlanSlotFromJson(json);

  /// Something exists to read.
  bool get hasPost => postId != null && postId!.isNotEmpty;

  /// The user has to do something about this one.
  bool get needsApproval => status == SlotStatus.generated;
}

/// A whole week's plan.
@freezed
abstract class WeekPlan with _$WeekPlan {
  const WeekPlan._();

  const factory WeekPlan({
    required String id,
    required int weekNumber,
    required int season,
    String? phase,
    String? topic,
    @Default(<PlanSlot>[]) List<PlanSlot> posts,
    String? generatedAt,
  }) = _WeekPlan;

  factory WeekPlan.fromJson(Map<String, dynamic> json) =>
      _$WeekPlanFromJson(json);

  int get publishedCount =>
      posts.where((PlanSlot s) => s.status == SlotStatus.published).length;

  int get liveSlotCount => posts.where((PlanSlot s) => !s.restDay).length;

  /// Slots waiting on the user.
  List<PlanSlot> get awaitingApproval =>
      posts.where((PlanSlot s) => s.needsApproval).toList(growable: false);
}

/// The planner endpoint's whole response.
///
/// [plan] is null for a week that has not been generated yet; the
/// [upcomingTopic] / [upcomingTitle] fields then carry the season roadmap's
/// preview for that week so the UI can show a locked card instead of nothing.
@freezed
abstract class PlannerState with _$PlannerState {
  const PlannerState._();

  const factory PlannerState({
    WeekPlan? plan,
    @Default(1) int currentWeekNumber,
    @Default(1) int currentSeason,
    String? upcomingTopic,
    String? upcomingPhase,
    String? upcomingTitle,
  }) = _PlannerState;

  factory PlannerState.fromJson(Map<String, dynamic> json) =>
      _$PlannerStateFromJson(json);

  /// This week exists and has content.
  bool get isGenerated => plan != null;
}

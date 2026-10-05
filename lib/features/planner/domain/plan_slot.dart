import 'package:freezed_annotation/freezed_annotation.dart';

// DayKind lives in core/week, not here: the home roadmap reads it too, to
// decide whether a day gets a "Publish a post" mission, and neither feature
// should depend on the other. The web splits it out for the same reason.
export '../../../core/week/week_shape.dart' show DayKind;

import '../../../core/week/week_shape.dart';

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
/// ## The week is no longer seven posts
///
/// It is two posts, two video scripts, one newsletter and a weekend off —
/// `WEEK_SHAPE` in the web's `lib/week-shape.ts`:
///
///   Mon  post            we write it, the chain publishes it
///   Tue  post (hero)     the week's biggest swing
///   Wed  video script    we write it, the user records and posts it
///   Thu  article         the newsletter, pasted in by the user
///   Fri  video script
///   Sat  rest
///   Sun  rest
///
/// That is a deliberate reduction from seven published posts to two: at seven,
/// the server's grounding runs out of banked material after the first few and
/// the rest come from its generic no-story branch.
///
/// **Sunday is a rest day now.** The article moved to Thursday. Anything still
/// drawing an article card on Sunday is describing the previous product.
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

    /// What this day produces. **Absent on every plan written before the
    /// pivot**, which is why it is nullable and why nothing reads it directly
    /// — go through [kind], the mirror of the web's `slotKind()`.
    ///
    /// Reading the raw field would resolve those rows to null and blank the
    /// grid for anyone mid-week when this shipped.
    @JsonKey(name: 'kind') String? rawKind,

    /// A maintenance-mode rest day. Reduced-cadence users get these.
    ///
    /// Pre-pivot rows carry only this, which is how [kind] reconstructs their
    /// kind: the product had exactly two states then, rest or a post.
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

  /// What this day produces, with pre-pivot rows reconstructed.
  ///
  /// The exact mirror of `slotKind()` in the web's `lib/week-shape.ts`:
  /// a row written before `kind` existed carries only `restDay`, so it
  /// resolves to the two states the product had at the time.
  DayKind get kind => rawKind != null
      ? DayKind.parse(rawKind)
      : (restDay ? DayKind.rest : DayKind.post);

  /// True when the chain publishes this day for the user. Mirrors
  /// `slotIsPublishable()`.
  bool get isPublishable => kind.isPublishable;

  /// We prepare it; the user posts it. Video scripts and the newsletter.
  bool get isHandoff => kind.isHandoff;

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

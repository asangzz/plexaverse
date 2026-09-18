import 'package:freezed_annotation/freezed_annotation.dart';

part 'roadmap_progress.freezed.dart';
part 'roadmap_progress.g.dart';

/// What the server knows about this user's 66-day journey.
///
/// The exact payload of `GET /roadmap/progress` (the mobile mirror of the
/// web's `/api/roadmap/progress`, both served by
/// `lib/services/roadmap.service.ts` → `getRoadmapProgress`). The web's
/// `GamifiedRoadmap` builds its whole surface from this one object plus the
/// pure, client-side roadmap in `lib/roadmap-data.ts`; this port does the same,
/// which is why there is no "dashboard" endpoint behind the home screen.
///
/// `lastCompletedStep` is in the payload and deliberately not modelled — the
/// web reads it nowhere, and json_serializable ignores keys it does not know,
/// so the server can keep sending it.
@freezed
abstract class RoadmapProgress with _$RoadmapProgress {
  const RoadmapProgress._();

  const factory RoadmapProgress({
    /// 1..66. Day 1 is the day the roadmap started.
    @Default(1) int currentDay,

    /// Completion keys, each `'<levelId>-<stepId>'`. The composite key is why
    /// the Sunday reach task is step 5 and not 4 — step 4 already belongs to
    /// the day-1..4 profile extras, and a collision would have each step
    /// marking the other done.
    @Default(<String>[]) List<String> completedSteps,

    /// Needed on the CLIENT, not just the server: the Sunday reach task only
    /// exists on days the client can prove are Sundays. Without it the app
    /// rebuilds a roadmap with no Sundays in it and that task never renders,
    /// however correctly the server placed it.
    DateTime? roadmapStartedAt,

    /// `'personal'` | `'company'`. Decides which roadmap is built.
    @Default('personal') String brandType,

    /// An AI post written for today and waiting for approval. Its presence
    /// rewrites today's publish task into "Approve Your Daily Post".
    String? pendingPostIdToday,

    /// An approved post already queued to publish.
    String? scheduledPostId,
    DateTime? scheduledPostAt,
  }) = _RoadmapProgress;

  factory RoadmapProgress.fromJson(Map<String, dynamic> json) =>
      _$RoadmapProgressFromJson(json);

  /// True when this user runs a Company Page rather than a personal brand.
  bool get isCompany => brandType == 'company';

  /// Has `stepId` on `levelId` been completed? The key shape is the server's.
  bool isStepDone(int levelId, int stepId) =>
      completedSteps.contains('$levelId-$stepId');
}

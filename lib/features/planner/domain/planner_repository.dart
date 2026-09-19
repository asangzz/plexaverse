import 'plan_slot.dart';
import 'weekly_article.dart';

/// Reads and writes the week plan.
///
/// Backed by `/planner` and `/planner/article` on the mobile API. Those routes
/// did not exist until the web-alignment work added them — the planner is the
/// spine of the product, and the mobile app had no way to reach it.
abstract class PlannerRepository {
  /// The current week, or a specific one.
  Future<PlannerState> fetchWeek({int? week, int? season});

  /// Updates one slot — a title edit, or approving a generated draft.
  ///
  /// The server refuses to mark a slot `published` unless its post actually
  /// reached LinkedIn, so that transition is not something the client can
  /// drive; it happens as a side effect of publishing.
  Future<WeekPlan> updateSlot({
    required String planId,
    required int slotIndex,
    String? title,
    bool? titleEditedByUser,
    SlotStatus? status,
    String? posterTag,
  });

  /// Approves a generated draft.
  ///
  /// Separate from [updateSlot] because approving is two writes on the server,
  /// not one: the plan slot AND the Post row it points at, which is what
  /// actually queues the thing for publishing. Sending it through the generic
  /// slot patch is how mobile ended up marking slots "Approved" while the
  /// post stayed a draft and the day passed with nothing published.
  Future<ApproveResult> approveSlot({
    required String planId,
    required int slotIndex,
  });

  /// The week's Sunday article.
  Future<ArticleState> fetchArticle({int? week, int? season});

  /// Records that the user pasted the article into LinkedIn themselves.
  Future<WeeklyArticle?> markArticlePublished({
    required int weekNumber,
    required int season,
    String? publishedUrl,
  });
}


/// What approving a slot actually did.
class ApproveResult {
  const ApproveResult({
    required this.plan,
    this.scheduledFor,
    this.postUpdated = false,
  });

  final WeekPlan plan;

  /// When it will publish, or null when the slot's moment has already passed
  /// (approved, but the user publishes it by hand) or there is no roadmap
  /// start to place it on. Never a past time — the server refuses to
  /// back-date.
  final DateTime? scheduledFor;

  /// False when the slot had no post to move — the plan was approved and
  /// nothing was queued. Worth saying out loud rather than implying success.
  final bool postUpdated;
}

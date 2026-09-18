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

  /// The week's Sunday article.
  Future<ArticleState> fetchArticle({int? week, int? season});

  /// Records that the user pasted the article into LinkedIn themselves.
  Future<WeeklyArticle?> markArticlePublished({
    required int weekNumber,
    required int season,
    String? publishedUrl,
  });
}

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

  /// Writes the post for [slotIndex], or replaces it when [force] is true.
  ///
  /// Costs XP. Throws [PlannerGenerateFailure] rather than returning a
  /// sentinel, because the reasons are genuinely different actions for the
  /// user — top up, connect an account, or simply try again — and collapsing
  /// them into null would lose the only thing that tells them which.
  Future<GeneratedSlot> generateSlotPost({
    required String planId,
    required int slotIndex,
    bool force = false,
  });

  /// The carousel counterpart of [generateSlotPost], for a slot whose format
  /// is `carousel`. Separate because the server route is separate; the caller
  /// branches on the slot's format rather than the repository guessing.
  Future<GeneratedSlot> generateSlotCarousel({
    required String planId,
    required int slotIndex,
    bool force = false,
  });

  /// Replaces the week's topic and rewrites the unwritten days.
  ///
  /// Free, and non-destructive by design: days already generated, approved or
  /// published keep the posts they have. Returns the re-planned week.
  Future<WeekPlan> changeTopic({required String planId, required String topic});

  /// Rewrites one day's title. Free. Returns the new title.
  ///
  /// Clears the server's `titleEditedByUser` flag, so a title the user typed
  /// by hand is only ever replaced when they ask for it here.
  Future<String> regenerateTitle({
    required String planId,
    required int slotIndex,
  });

  /// The week's Sunday article.
  Future<ArticleState> fetchArticle({int? week, int? season});

  /// The article's BODY, fetched when it is actually read.
  ///
  /// [fetchArticle] returns the summary the planner screen draws and leaves
  /// the body out — it was ninety percent of that response for text the
  /// screen does not show. This is the call the article sheet and Copy make.
  Future<String> fetchArticleBody({int? week, int? season});

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

/// The post a slot generation produced.
class GeneratedSlot {
  const GeneratedSlot({required this.postId, this.alreadyGenerated = false});

  final String? postId;

  /// True when another request had already claimed the slot — a double-tap,
  /// or a retry that raced the first attempt. Success, not an error, and no
  /// XP was spent the second time.
  final bool alreadyGenerated;
}

/// Why a slot generation did not produce a post.
class PlannerGenerateFailure implements Exception {
  const PlannerGenerateFailure({required this.kind, this.message});

  final PlannerGenerateFailureKind kind;

  /// The server's own words where it sent them — the XP message names the
  /// price and the balance, which a generic string would lose.
  final String? message;
}

enum PlannerGenerateFailureKind {
  /// 402. The user needs to top up before this will work.
  insufficientXp,

  /// 400. Nothing to publish to, so nothing to generate for.
  noLinkedinAccount,

  /// 400 `NOT_A_POST_DAY`. This day is a video script, the newsletter, or
  /// rest — there is nothing for the post generator to make.
  ///
  /// A retry can never succeed, which is what separates it from [failed]: the
  /// answer is not "try again" but "this is not that kind of day". The server
  /// refuses before spending any XP.
  notAPostDay,

  /// Anything else — the slot has been rolled back and a retry is sensible.
  failed,
}

import 'plan_slot.dart';
import 'video_script.dart';
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

  /// Draws the poster for a slot that has just been written.
  ///
  /// A SECOND call on purpose. `generatePlannerPost` returns a body and no
  /// image — the poster is a separate, separately-priced model call, and the
  /// server has never drawn one as part of generating — so a client that stops
  /// at the first call leaves the day imageless. The web's planner makes
  /// exactly this pair, in this order; mobile made only the first half, which
  /// is why every planner post on the phone arrived as bare text.
  ///
  /// Costs XP (one image generation), so it is only ever worth calling for a
  /// slot this request actually wrote.
  ///
  /// Returns the poster as a base64 `data:` URI, or null when none came back.
  Future<String?> generateSlotPoster({
    required String topic,
    required String content,
    required String posterTitle,

    /// The slot's post type — 'niche', 'general', 'productive', 'light'. Picks
    /// the poster's visual category AND keeps this path on the same provider
    /// the unattended chain would have used for the same day.
    required String slotType,
    required String userName,
    String? profileImageUrl,

    /// The style the WEEK chose. Null is a quiet downgrade to an unstyled
    /// poster — which is what every poster was before the reference library
    /// existed — not a failure.
    String? posterTag,
  });

  /// Hangs an image on a post that already exists.
  ///
  /// [imageUrl] is the raw `data:` URI [generateSlotPoster] returned, and that
  /// is deliberate: the server's own guard in `updateUserPost` turns it into a
  /// Storage upload. Uploading it from the phone first would be a second code
  /// path for the same bytes, and the one that pays mobile data for it.
  Future<void> attachPostImage({
    required String postId,
    required String imageUrl,
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

  /// The week's video scripts, in day order.
  ///
  /// Never throws for a read failure — the service swallows its own and
  /// returns an empty list, and this mirrors that: a database hiccup costs the
  /// planner its scripts, not its week.
  ///
  /// [week] and [season] are REQUIRED, unlike the article's. The route has no
  /// "current week" default, and the caller has better numbers anyway: the
  /// loaded plan's own, which guarantees the scripts belong to the week on
  /// screen rather than to whatever the server thinks today is.
  Future<List<VideoScript>> fetchWeekScripts({
    required int week,
    required int season,
  });

  /// Records that the user filmed and posted one.
  ///
  /// The ONLY way a script is ever closed out. LinkedIn's video upload is a
  /// different API from a text share and this product does not speak it, so no
  /// share URN ever comes back to match — exactly the newsletter's situation.
  ///
  /// Returns null when the slot has no script to close.
  Future<VideoScript?> markScriptPosted({
    required int weekNumber,
    required int season,
    required int dayIndex,
  });

  /// Writes the script for one slot on demand.
  ///
  /// Scripts are written on Sunday with the rest of the week; this is the
  /// path for when that did not happen, or when the user wants it early.
  /// Costs a model call, so the server rate-limits it as AI_EXPENSIVE.
  Future<VideoScript> generateScript({
    required int weekNumber,
    required int season,
    required int dayIndex,
    bool force,
  });

  /// The week's long-form article — Thursday's newsletter.
  Future<ArticleState> fetchArticle({int? week, int? season});

  /// The article's BODY, fetched when it is actually read.
  ///
  /// [fetchArticle] returns the summary the planner screen draws and leaves
  /// the body out — it was ninety percent of that response for text the
  /// screen does not show. This is the call the article sheet and Copy make.
  Future<String> fetchArticleBody({int? week, int? season});

  /// Records the name of the newsletter the user created on LinkedIn.
  ///
  /// The only way this value is ever set. Nothing syncs it because nothing
  /// can, and until it is set `isFirstArticle` stays true — so the planner
  /// keeps asking the user to create a newsletter they already have, and every
  /// caption that mentions the article refers to it generically.
  ///
  /// Returns the stored name, which is [name] trimmed.
  Future<String> setNewsletterName(String name);

  /// Sets — or clears — the reminder for the week's article.
  ///
  /// **This does not publish anything**, and no caller should suggest it
  /// does. There is no articles endpoint on the scopes this product holds, so
  /// the only thing a time buys is a notification at it; the user still pastes
  /// the article across by hand.
  ///
  /// Null clears both the stored time and the booked task.
  ///
  /// Throws [PlannerScheduleRefused] when the article is already published or
  /// the time has passed — both of which carry the server's own sentence,
  /// because it says what to do next.
  Future<WeeklyArticle?> setArticleSchedule({
    required int weekNumber,
    required int season,
    required DateTime? when,
  });

  /// Records that the user pasted the article into LinkedIn themselves.
  Future<WeeklyArticle?> markArticlePublished({
    required int weekNumber,
    required int season,
    String? publishedUrl,
  });
}

/// The server refused a reminder, and said why.
///
/// A typed failure rather than a bool because the two reasons need different
/// words — "you already published this one" and "pick a time that has not
/// passed" are different instructions — and the server's own sentence is
/// better than anything the client could compose from a code.
class PlannerScheduleRefused implements Exception {
  const PlannerScheduleRefused(this.message);

  final String message;

  @override
  String toString() => message;
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
  const GeneratedSlot({
    required this.postId,
    this.alreadyGenerated = false,
    this.content,
    this.posterTitle,
  });

  final String? postId;

  /// True when another request had already claimed the slot — a double-tap,
  /// or a retry that raced the first attempt. Success, not an error, and no
  /// XP was spent the second time.
  final bool alreadyGenerated;

  /// The body the model wrote.
  ///
  /// Carried back rather than re-read off the post, because the poster is
  /// drawn FROM this text and re-fetching what the server just handed us is a
  /// round-trip the user waits through for nothing.
  final String? content;

  /// The headline the server put on the slot, for the poster's title overlay.
  final String? posterTitle;
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

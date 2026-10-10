import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/failure.dart';
import '../../settings/application/settings_controllers.dart';
import '../../settings/domain/settings_entities.dart';
import '../../posts/application/post_library_controllers.dart';
import '../data/planner_repositories.dart';
import '../domain/plan_slot.dart';
import '../domain/planner_repository.dart';
import '../domain/video_script.dart';
import '../domain/weekly_article.dart';

part 'planner_controller.g.dart';

/// Which week the planner is showing.
///
/// Null means "whatever the server says is current" — the server owns the
/// current-week calculation (a calendar Sun–Sat anchor off roadmapStartedAt),
/// and the client must not recompute it or it will ask for a week the plan was
/// never saved under.
@riverpod
class PlannerWeek extends _$PlannerWeek {
  @override
  ({int? week, int? season}) build() => (week: null, season: null);

  void show(int week, int season) => state = (week: week, season: season);

  /// Back to the server's idea of now.
  void showCurrent() => state = (week: null, season: null);
}

/// The week plan.
@riverpod
class PlannerController extends _$PlannerController {
  @override
  Future<PlannerState> build() {
    final ({int? week, int? season}) target = ref.watch(plannerWeekProvider);
    return ref
        .watch(plannerRepositoryProvider)
        .fetchWeek(week: target.week, season: target.season);
  }

  /// Approves a generated draft.
  ///
  /// Optimistic: the slot flips immediately and is reconciled from the server's
  /// response. Approving is the single most-tapped action on this screen and a
  /// round-trip of dead UI for it reads as a broken button.
  /// Writes the post for a slot, or replaces it when [force] is true.
  ///
  /// Marks the slot `generating` locally first so the row shows work in
  /// progress — the server does the same thing under a row lock, and the
  /// call takes seconds, not milliseconds. On any failure the local state is
  /// re-read rather than guessed: the server rolls the slot back to
  /// `planned`, and inventing that here would be a second source of truth.
  ///
  /// Rethrows [PlannerGenerateFailure] so the caller can say which of the
  /// three things the user has to do.
  Future<GeneratedSlot?> generate(int slotIndex, {bool force = false}) async {
    final PlannerState? current = state.value;
    final WeekPlan? plan = current?.plan;
    if (plan == null) return null;

    final List<PlanSlot> optimistic = List<PlanSlot>.of(plan.posts);
    optimistic[slotIndex] = optimistic[slotIndex].copyWith(
      status: SlotStatus.generating,
    );
    state = AsyncData<PlannerState>(
      current!.copyWith(plan: plan.copyWith(posts: optimistic)),
    );

    try {
      // The slot's own format decides which generator runs. Branching here
      // rather than inside the repository keeps the two server routes
      // visible as two routes — they claim and roll back independently.
      final PlannerRepository repo = ref.read(plannerRepositoryProvider);
      final bool isCarousel = plan.posts[slotIndex].format == 'carousel';
      final GeneratedSlot result = isCarousel
          ? await repo.generateSlotCarousel(
              planId: plan.id,
              slotIndex: slotIndex,
              force: force,
            )
          : await repo.generateSlotPost(
              planId: plan.id,
              slotIndex: slotIndex,
              force: force,
            );
      // The carousel route draws its own slides; only the text path leaves a
      // day needing artwork. Before the refetch, so the invalidation that
      // reloads the row happens once, with the image already attached.
      if (!isCarousel) await _attachPoster(repo, plan, slotIndex, result);
      ref.invalidateSelf();
      return result;
    } on PlannerGenerateFailure {
      ref.invalidateSelf();
      rethrow;
    } on Object {
      ref.invalidateSelf();
      return null;
    }
  }

  /// Draws the day's poster and hangs it on the post that was just written.
  ///
  /// ## Why this is a second call
  ///
  /// `generatePlannerPost` returns a body and nothing else — by design. The
  /// poster is a separate model call with its own price, and the server has
  /// never drawn one as part of generating a slot; the web's planner makes
  /// this same pair of calls, in this same order. A client that stops at the
  /// first one therefore produces a post with no image, which is exactly what
  /// the phone did: both of the week's posted days are `text_image`, so every
  /// planner post generated on mobile arrived as bare text while the identical
  /// slot generated on web arrived with a poster.
  ///
  /// ## Why nothing in here is fatal
  ///
  /// The post already exists and the XP for it is already spent. A poster that
  /// fails costs the user an image they can redo; letting that failure escape
  /// would cost them the post, and the planner row would roll back to
  /// `planned` over artwork. So every step swallows: no poster, no `imageUrl`
  /// in the answer, or a PATCH that does not land all leave the day exactly as
  /// a successful text-only generation would have.
  Future<void> _attachPoster(
    PlannerRepository repo,
    WeekPlan plan,
    int slotIndex,
    GeneratedSlot result,
  ) async {
    final PlanSlot slot = plan.posts[slotIndex];
    // `alreadyGenerated` means another request wrote this slot — its poster
    // went with it, and drawing a second one would charge for an image that
    // replaces one already on the post.
    if (slot.format != 'text_image' || result.alreadyGenerated) return;
    final String? postId = result.postId;
    if (postId == null || postId.isEmpty) return;

    // The badge is decoration. The web sends an empty name and no avatar when
    // the session has not loaded and gets a poster back regardless, so a
    // profile read that fails must not stop the image.
    String userName = '';
    String? profileImageUrl;
    try {
      final AccountSnapshot account = await ref.read(
        accountSnapshotProvider.future,
      );
      userName = account.user.name;
      profileImageUrl = account.user.avatarUrl;
    } on Object {
      userName = '';
      profileImageUrl = null;
    }

    try {
      final String? imageUrl = await repo.generateSlotPoster(
        topic: plan.topic ?? '',
        content: _posterBrief(result.content, slot.title, plan.topic),
        // The slot's title, not the server's echo of it: the user may have
        // renamed the day, and the overlay should carry what they see.
        posterTitle: slot.title,
        slotType: slot.type,
        userName: userName,
        profileImageUrl: profileImageUrl,
        posterTag: slot.posterTag,
      );
      if (imageUrl == null || imageUrl.isEmpty) return;
      // The raw `data:` URI goes up as-is — the server turns it into a Storage
      // upload on the way in. See [PlannerRepository.attachPostImage].
      await repo.attachPostImage(postId: postId, imageUrl: imageUrl);
    } on Object {
      // Deliberately swallowed — see the doc comment.
    }
  }

  /// Draws a NEW poster for the post a slot already has.
  ///
  /// The deliberate opposite of [_attachPoster] in two ways. It runs on
  /// demand rather than as a silent tail of generation, so its failure is
  /// REPORTED — the user pressed a button and paid XP, and swallowing that
  /// would leave them staring at the old image wondering whether anything
  /// happened. And it draws from the post's own body rather than from a
  /// generation result, because by now the user may have edited the words the
  /// picture is supposed to illustrate.
  ///
  /// Returns whether a new image landed.
  Future<bool> regeneratePoster(int slotIndex) async {
    final PlannerState? current = state.value;
    final WeekPlan? plan = current?.plan;
    if (plan == null || slotIndex >= plan.posts.length) return false;

    final PlanSlot slot = plan.posts[slotIndex];
    final String? postId = slot.postId;
    if (postId == null || postId.isEmpty) return false;

    final PlannerRepository repo = ref.read(plannerRepositoryProvider);

    String userName = '';
    String? profileImageUrl;
    try {
      final AccountSnapshot account = await ref.read(
        accountSnapshotProvider.future,
      );
      userName = account.user.name;
      profileImageUrl = account.user.avatarUrl;
    } on Object {
      userName = '';
      profileImageUrl = null;
    }

    // The words as they stand now, not as they were generated.
    String? body;
    try {
      body = (await ref.read(postDetailProvider(postId).future)).content;
    } on Object {
      body = null;
    }

    final String? imageUrl = await repo.generateSlotPoster(
      topic: plan.topic ?? '',
      content: _posterBrief(body, slot.title, plan.topic),
      posterTitle: slot.title,
      slotType: slot.type,
      userName: userName,
      profileImageUrl: profileImageUrl,
      posterTag: slot.posterTag,
    );
    if (imageUrl == null || imageUrl.isEmpty) return false;

    await repo.attachPostImage(postId: postId, imageUrl: imageUrl);
    // Both: the planner carries the slot's preview, the post detail carries
    // the full image, and the sheet shows one of each.
    ref.invalidate(postDetailProvider(postId));
    ref.invalidateSelf();
    return true;
  }

  /// What the poster is drawn FROM: the body just written, then the day's
  /// title, then the week's topic. The web's `postContent || title || topic`,
  /// and the order matters — an empty brief still returns a poster, just a
  /// generic one that illustrates nothing the post says.
  static String _posterBrief(String? content, String title, String? topic) {
    for (final String? candidate in <String?>[content, title, topic]) {
      final String value = candidate?.trim() ?? '';
      if (value.isNotEmpty) return value;
    }
    return '';
  }

  /// Replaces the week's topic and re-plans the unwritten days.
  ///
  /// Returns the failure message, or null on success. Non-destructive by
  /// contract — days already generated keep their posts — which is why this
  /// does not warn before running.
  Future<String?> changeTopic(String topic) async {
    final WeekPlan? plan = state.value?.plan;
    if (plan == null) return 'No plan to change.';
    try {
      await ref
          .read(plannerRepositoryProvider)
          .changeTopic(planId: plan.id, topic: topic);
      ref.invalidateSelf();
      return null;
    } on Object {
      return "Couldn't re-plan the week. Try again.";
    }
  }

  /// Rewrites one day's title. Returns the failure message, or null.
  Future<String?> regenerateTitle(int slotIndex) async {
    final WeekPlan? plan = state.value?.plan;
    if (plan == null) return null;
    try {
      await ref
          .read(plannerRepositoryProvider)
          .regenerateTitle(planId: plan.id, slotIndex: slotIndex);
      ref.invalidateSelf();
      return null;
    } on Object {
      return "Couldn't rewrite that title. Try again.";
    }
  }

  /// Approves a generated draft, and reports what that actually did.
  ///
  /// Goes through [PlannerRepository.approveSlot] rather than the generic slot
  /// patch: approving moves the Post row too, which is the part that queues
  /// it for publishing. Returns the outcome so the caller can say when it will
  /// go out — or say plainly that nothing was queued — instead of leaving the
  /// user to infer it from a status chip.
  Future<ApproveResult?> approve(int slotIndex) async {
    final PlannerState? current = state.value;
    final WeekPlan? plan = current?.plan;
    if (plan == null) return null;

    final List<PlanSlot> optimistic = List<PlanSlot>.of(plan.posts);
    optimistic[slotIndex] = optimistic[slotIndex].copyWith(
      status: SlotStatus.approved,
    );
    state = AsyncData<PlannerState>(
      current!.copyWith(plan: plan.copyWith(posts: optimistic)),
    );

    try {
      final result = await ref
          .read(plannerRepositoryProvider)
          .approveSlot(planId: plan.id, slotIndex: slotIndex);
      state = AsyncData<PlannerState>(current.copyWith(plan: result.plan));
      return result;
    } on Object {
      // Put the server's truth back. A failed approve that still looks
      // approved is worse than one that visibly did not take.
      ref.invalidateSelf();
      return null;
    }
  }

  /// Writes the sheet's edits: the title to the SLOT row, the body to the
  /// POST row.
  ///
  /// A null argument means the user never touched that field. The dirty flags
  /// that decide it stay on the sheet — only a text field knows whether its
  /// contents are something a person typed or something we put there — but
  /// everything after that decision is a use case: two rows, two endpoints, an
  /// order between them, and one sentence to show when one refuses.
  ///
  /// It lived on `_SlotSheetState` until this change, and the price of that
  /// placement was a widget holding `postLibraryRepositoryProvider` — another
  /// slice's DATA layer — and then hand-invalidating that slice's cache
  /// afterwards, because having written around the controller that owns the
  /// post there was nothing else that could have told it.
  ///
  /// ## The body call sends `content` and NOTHING else. That is load-bearing.
  ///
  /// `updateUserPost` detaches a post from its planner day whenever
  /// `scheduledFor` is PRESENT in the request body — changed or not, null or
  /// not. It clears the slot's `postId` and drops the day back to `planned`.
  /// So the obvious shape for an edit form, one call carrying every field,
  /// would blank the very day it was saving. [PostDetail.save] is used here
  /// rather than the post repository precisely because it cannot send
  /// `scheduledFor`; [PostDetail.setSchedule] is the method that can, and
  /// nothing on this path may ever reach for it.
  ///
  /// Returns an error sentence, or null when everything the user changed
  /// landed.
  Future<String?> saveSlotEdits(
    int slotIndex, {
    String? title,
    String? body,
  }) async {
    final WeekPlan? plan = state.value?.plan;
    if (plan == null || slotIndex >= plan.posts.length) {
      return 'That day is no longer in this week.';
    }
    final PlanSlot slot = plan.posts[slotIndex];

    try {
      // Title first, so a rename that lands is visible even when the body
      // call is the one that refuses. Through [rename] rather than a bare
      // patch because that is what sets `titleEditedByUser` — the flag that
      // stops the next regenerate overwriting a title someone typed by hand.
      final String trimmed = title?.trim() ?? '';
      if (trimmed.isNotEmpty && trimmed != slot.title) {
        await rename(slotIndex, trimmed);
      }

      // The body goes up exactly as typed. The trim is only to ask whether
      // there is anything here at all — emptying a post is not a save, and
      // the user's own trailing blank line is theirs to keep.
      final String? postId = slot.postId;
      if (body != null && body.trim().isNotEmpty && postId != null) {
        // No invalidation after this, deliberately. [PostDetail.save]
        // publishes the row the write returned into its own cache, so the
        // sheet's body and the library row behind it are already current.
        await ref.read(postDetailProvider(postId).notifier).save(content: body);
      }
      return null;
    } on PlannerGenerateFailure catch (e) {
      return e.message ?? 'That did not save.';
    } on Object {
      return 'That did not save. Try again.';
    }
  }

  /// Renames a slot. [titleEditedByUser] tells the generator not to overwrite
  /// it on a regenerate.
  Future<void> rename(int slotIndex, String title) =>
      _patch(slotIndex, title: title, titleEditedByUser: true);

  Future<void> setPosterTag(int slotIndex, String tag) =>
      _patch(slotIndex, posterTag: tag);

  Future<void> _patch(
    int slotIndex, {
    String? title,
    bool? titleEditedByUser,
    SlotStatus? status,
    String? posterTag,
  }) async {
    final PlannerState? current = state.value;
    final WeekPlan? plan = current?.plan;
    if (plan == null) return;

    if (status != null || title != null) {
      final List<PlanSlot> optimistic = List<PlanSlot>.of(plan.posts);
      optimistic[slotIndex] = optimistic[slotIndex].copyWith(
        status: status ?? optimistic[slotIndex].status,
        title: title ?? optimistic[slotIndex].title,
      );
      state = AsyncData<PlannerState>(
        current!.copyWith(plan: plan.copyWith(posts: optimistic)),
      );
    }

    try {
      final WeekPlan updated = await ref
          .read(plannerRepositoryProvider)
          .updateSlot(
            planId: plan.id,
            slotIndex: slotIndex,
            title: title,
            titleEditedByUser: titleEditedByUser,
            status: status,
            posterTag: posterTag,
          );
      state = AsyncData<PlannerState>(current!.copyWith(plan: updated));
    } on Object {
      // Put the server's truth back. A failed approve that still looks approved
      // is worse than one that visibly did not take.
      ref.invalidateSelf();
    }
  }
}

/// The week's video scripts, keyed to the week on screen.
///
/// Its own controller for the same reason the article has one: a script is not
/// one of the week's posts. It is prepared and handed over, it never reaches
/// the publish ladder, and a failed read of it must not cost the user their
/// plan — the planner renders fine with no scripts, it just cannot say which
/// hand-off days are done.
///
/// Watches the PLAN rather than [plannerWeekProvider]. That provider holds
/// `(null, null)` for "whatever the server thinks is current", and the scripts
/// route has no such default — it requires real numbers. Taking them off the
/// loaded plan also guarantees the scripts belong to the week being drawn
/// rather than to today, which matters the moment the user pages backwards.
@riverpod
class VideoScriptsController extends _$VideoScriptsController {
  @override
  Future<List<VideoScript>> build() async {
    final PlannerState planner = await ref.watch(
      plannerControllerProvider.future,
    );
    final WeekPlan? plan = planner.plan;
    if (plan == null) return const <VideoScript>[];

    try {
      return await ref
          .read(plannerRepositoryProvider)
          .fetchWeekScripts(week: plan.weekNumber, season: plan.season);
    } on Object {
      // Swallowed, like the service's own read. The planner is still correct
      // without this; it just falls back to "not written yet" on the two
      // video days, which is the honest answer when we cannot tell.
      return const <VideoScript>[];
    }
  }

  /// The script for one slot, or null.
  VideoScript? forDay(int dayIndex) {
    for (final VideoScript v in state.value ?? const <VideoScript>[]) {
      if (v.dayIndex == dayIndex) return v;
    }
    return null;
  }

  /// Records that the user filmed and posted one.
  ///
  /// The only way a script is ever closed out — see [VideoScript]. Optimistic,
  /// because the user is telling US what they did and the server stores
  /// exactly that; the only failure is a tick that comes back.
  Future<bool> markPosted(int dayIndex) async {
    final List<VideoScript>? current = state.value;
    if (current == null) return false;
    final int i = current.indexWhere((VideoScript v) => v.dayIndex == dayIndex);
    if (i == -1 || current[i].isPosted) return false;

    state = AsyncData<List<VideoScript>>(
      List<VideoScript>.of(current)
        ..[i] = current[i].copyWith(status: 'published'),
    );

    try {
      final VideoScript? saved = await ref
          .read(plannerRepositoryProvider)
          .markScriptPosted(
            weekNumber: current[i].weekNumber,
            season: current[i].season,
            dayIndex: dayIndex,
          );
      if (saved == null) {
        // 404 — the row went away under us. Put the tick back rather than
        // leaving a day marked done that the server has no record of.
        state = AsyncData<List<VideoScript>>(current);
        return false;
      }
      state = AsyncData<List<VideoScript>>(
        List<VideoScript>.of(state.value ?? current)..[i] = saved,
      );
      return true;
    } on Object {
      state = AsyncData<List<VideoScript>>(current);
      return false;
    }
  }

  /// Writes the script for a day Sunday did not.
  ///
  /// Returns an error sentence, or null on success. Not optimistic — there is
  /// nothing to show until the model answers, and a spinner that resolves into
  /// real content is the honest shape for a call that takes seconds.
  Future<String?> generate(int dayIndex, {bool force = false}) async {
    final PlannerState? planner = ref.read(plannerControllerProvider).value;
    final WeekPlan? plan = planner?.plan;
    if (plan == null) return 'The week has not loaded yet.';

    try {
      final VideoScript written = await ref
          .read(plannerRepositoryProvider)
          .generateScript(
            weekNumber: plan.weekNumber,
            season: plan.season,
            dayIndex: dayIndex,
            force: force,
          );
      final List<VideoScript> next = List<VideoScript>.of(
        state.value ?? const <VideoScript>[],
      );
      final int i = next.indexWhere((VideoScript v) => v.dayIndex == dayIndex);
      if (i == -1) {
        next.add(written);
      } else {
        next[i] = written;
      }
      state = AsyncData<List<VideoScript>>(next);
      return null;
    } on Failure catch (f) {
      return f.message;
    } on Object {
      return 'The script could not be written. Try again.';
    }
  }
}

/// The week's long-form article — Thursday's newsletter.
///
/// Separate from [PlannerController] because the article is not one of the
/// week's posts — it is the week's spine, it generates even in maintenance
/// mode, and a failed article must never cost the user their plan.
@riverpod
class ArticleController extends _$ArticleController {
  @override
  Future<ArticleState> build() {
    final ({int? week, int? season}) target = ref.watch(plannerWeekProvider);
    return ref
        .watch(plannerRepositoryProvider)
        .fetchArticle(week: target.week, season: target.season);
  }

  /// Sets — or clears — the reminder for the week's article.
  ///
  /// Returns an error sentence, or null on success. The server's own words are
  /// passed through on a refusal: "pick a time that has not already passed"
  /// tells the user what to do and a generic failure does not.
  ///
  /// Not optimistic. This is a deliberate choice with a time attached, and a
  /// reminder that appeared to save and then reverted would be worse than one
  /// that took a moment — the user cannot tell whether to expect the nudge.
  /// The article's body, fetched only when something is about to show it.
  ///
  /// The week summary deliberately does not carry it — it was ninety percent
  /// of that response for text no card renders. Null on failure, so the
  /// caller can say so rather than opening an empty sheet or copying nothing.
  ///
  /// Here rather than on the page: reading a repository is the data layer's
  /// business, and the page was importing `data/` for this one call.
  Future<String?> fetchArticleBody(ArticleState a) async {
    final WeeklyArticle? article = a.article;
    if (article == null) return null;
    if (article.hasBody) return article.body;
    try {
      return await ref
          .read(plannerRepositoryProvider)
          .fetchArticleBody(week: a.weekNumber, season: a.season);
    } on Object {
      return null;
    }
  }

  Future<String?> setArticleReminder(DateTime? when) async {
    final ArticleState? current = state.value;
    if (current?.article == null) {
      return 'There is no article to remind you about.';
    }

    try {
      await ref
          .read(plannerRepositoryProvider)
          .setArticleSchedule(
            weekNumber: current!.weekNumber,
            season: current.season,
            when: when,
          );
      ref.invalidateSelf();
      return null;
    } on PlannerScheduleRefused catch (e) {
      return e.message;
    } on Failure catch (f) {
      return f.message;
    } on Object {
      return 'That reminder did not save. Try again.';
    }
  }

  /// Records the name of the newsletter the user created on LinkedIn.
  ///
  /// Returns an error sentence, or null on success.
  ///
  /// Optimistic on the NAME, which is safe — the user typed it and the server
  /// stores it verbatim — and deliberately NOT optimistic on
  /// `isFirstArticle`. That flag does not mean "has a name"; it means LinkedIn
  /// will ask them to create the newsletter while they publish, which is true
  /// for this edition whatever we record. The web makes the same distinction
  /// and for the same reason: flipping it here would delete the
  /// create-a-newsletter step from under the user at exactly the moment they
  /// open LinkedIn and are asked to create one.
  Future<String?> setNewsletterName(String name) async {
    final String trimmed = name.trim();
    if (trimmed.isEmpty) return 'Give the newsletter a name first.';

    final ArticleState? current = state.value;
    if (current != null) {
      state = AsyncData<ArticleState>(
        current.copyWith(newsletterName: trimmed),
      );
    }

    try {
      await ref.read(plannerRepositoryProvider).setNewsletterName(trimmed);
      // DELIBERATELY NOT `invalidateSelf()`.
      //
      // The server answers `isFirstArticle: !newsletterName`, so a refetch
      // here would come back false — and the card's create-a-newsletter note
      // is keyed on that flag. The user would watch the step disappear
      // seconds after naming it, at precisely the moment they tap "Copy &
      // open editor" and LinkedIn asks them to create one.
      //
      // The flag does not mean "has a name". It means LinkedIn will ask them
      // to CREATE the newsletter while they publish THIS edition, which is
      // still true. Recording the name is not creating the newsletter;
      // LinkedIn is where it comes into being. So the local patch stands and
      // the server's answer is picked up on the next natural read — next
      // week, or a pull-to-refresh — by which time it is correct.
      //
      // The web guards the same moment the same way, with its
      // `serverSaysFirst || savedNewsletterName !== null`. Nothing on this
      // screen reads `newsletterCreatedAt`, so skipping the refetch costs
      // nothing.
      return null;
    } on Failure catch (f) {
      if (current != null) state = AsyncData<ArticleState>(current);
      return f.message;
    } on Object {
      if (current != null) state = AsyncData<ArticleState>(current);
      return 'That did not save. Try again.';
    }
  }

  /// Records that the user pasted the article into LinkedIn themselves.
  ///
  /// This is the ONLY way an article is ever marked published: the API cannot
  /// publish one, so it never gets a LinkedIn share URN and the normal
  /// publish path can never close it out.
  Future<void> markPublished({String? url}) async {
    final ArticleState? current = state.value;
    if (current?.article == null) return;

    await ref
        .read(plannerRepositoryProvider)
        .markArticlePublished(
          weekNumber: current!.weekNumber,
          season: current.season,
          publishedUrl: url,
        );
    ref.invalidateSelf();
  }
}

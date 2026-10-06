import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/failure.dart';
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

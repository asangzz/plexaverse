import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/planner_repositories.dart';
import '../domain/plan_slot.dart';
import '../domain/weekly_article.dart';
import '../domain/planner_repository.dart';

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

/// The week's Sunday article.
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

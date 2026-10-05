import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/router/zave_routes.dart';
import '../../../core/week/comment_targets.dart';
import '../data/engagement_repositories.dart';
import '../domain/engagement_repository.dart';

part 'engagement_controllers.g.dart';

/// Where the user is on the 66-day roadmap.
///
/// Read once per screen and shared by both, rather than folded into each
/// batch controller: the two habits sit on the SAME day, and a failed roadmap
/// read must not take the generated batch down with it. The screens render the
/// batch and the mission independently for exactly that reason.
@riverpod
Future<RoadmapProgress> engagementProgress(Ref ref) =>
    ref.watch(engagementRepositoryProvider).fetchRoadmapProgress();

/// Today's roadmap step for one of the two habit screens.
///
/// Null is a real answer, not an error — see [EngagementMission.locate]. The
/// family key is the web-identical `moduleLink` the roadmap stores, which is
/// the same string as the route, so `/comments` and `/connections` are the
/// only two values that ever reach it.
@riverpod
Future<EngagementMission?> engagementMission(Ref ref, String moduleLink) async {
  final RoadmapProgress progress = await ref.watch(
    engagementProgressProvider.future,
  );
  return EngagementMission.locate(
    progress,
    moduleLink: moduleLink,
    // The web's own defaults when the step description carries no number:
    // 3 comments, 10 connections. (Connections then overrides the whole thing
    // with the batch length — see `ConnectionBatch.targetCount`.)
    // Declared, not scraped, and no longer inverted: comments ask for ten a
    // day (five curated Top Voices plus five from the user's niche) and
    // connections for a posting day's twelve. It read `connections ? 10 : 3`,
    // which had the larger number on the smaller task.
    fallbackTarget: moduleLink == ZaveRoutes.connections
        ? invitesPerPostingDay
        : dailyCommentTarget,
  );
}

/// The day's comment batch.
///
/// Keyed by [topic] so the golden-hour deep link (`?context=golden_hour&
/// topic=…`) asks for comments about the user's OWN post rather than the
/// server's niche pick. A null or empty topic is the ordinary path and lets the
/// server choose.
///
/// Generation fires on first watch, which mirrors the web: the page has no
/// "generate" button in practice, because it auto-fetches on mount and the
/// day's batch is replayed for free afterwards.
@riverpod
class CommentsController extends _$CommentsController {
  @override
  Future<CommentBatch> build(String? topic) =>
      ref.watch(engagementRepositoryProvider).generateComments(topic: topic);

  /// The user copied this comment, so it counts as deployed.
  ///
  /// Local only, and deliberately so: the last thing this app can observe is
  /// the copy. Whether the comment was actually posted happens inside LinkedIn,
  /// where we have no visibility — claiming otherwise would be a lie the
  /// progress bar tells.
  void markSent(int index) {
    final CommentBatch? batch = state.value;
    if (batch == null || index < 0 || index >= batch.comments.length) return;
    if (batch.comments[index].isSent) return;
    state = AsyncData<CommentBatch>(
      batch.copyWith(comments: _replace(batch.comments, index, isSent: true)),
    );
  }

  /// The user rewrote a draft.
  void edit(int index, String text) {
    final CommentBatch? batch = state.value;
    if (batch == null || index < 0 || index >= batch.comments.length) return;
    if (batch.comments[index].comment == text) return;
    state = AsyncData<CommentBatch>(
      batch.copyWith(comments: _replace(batch.comments, index, comment: text)),
    );
  }

  /// Teaches a user-written edit to `/ai/style-memory`.
  ///
  /// Called when the field loses focus, matching the web's `onBlur`. It is a
  /// no-op unless the text actually differs from what was last taught, so
  /// tapping in and out of a field does not re-embed the same sentence.
  ///
  /// Never throws: the repository swallows its own failure. The user did not
  /// ask for this call and cannot act on its failure.
  Future<void> teachEdit(int index) async {
    final CommentBatch? batch = state.value;
    if (batch == null || index < 0 || index >= batch.comments.length) return;

    final CommentDraft draft = batch.comments[index];
    if (!draft.isWorthTeaching) return;

    final String text = draft.comment;
    state = AsyncData<CommentBatch>(
      batch.copyWith(comments: _replace(batch.comments, index, taught: text)),
    );

    await ref
        .read(engagementRepositoryProvider)
        .teachStyle(
          text: text,
          topic: draft.searchKeywords.isNotEmpty
              ? draft.searchKeywords
              : batch.topic,
        );
  }

  static List<CommentDraft> _replace(
    List<CommentDraft> comments,
    int index, {
    String? comment,
    bool? isSent,
    String? taught,
  }) {
    final List<CommentDraft> next = List<CommentDraft>.of(comments);
    next[index] = next[index].copyWith(
      comment: comment ?? next[index].comment,
      isSent: isSent ?? next[index].isSent,
      taughtText: taught ?? next[index].taughtText,
    );
    return next;
  }
}

/// The day's connection targets.
@riverpod
class ConnectionsController extends _$ConnectionsController {
  @override
  Future<ConnectionBatch> build() =>
      ref.watch(engagementRepositoryProvider).findConnections();

  /// The user copied this note, so the request counts as sent.
  ///
  /// Same caveat as comments: copying is the last observable moment. The send
  /// itself happens in LinkedIn.
  void markSent(int index) {
    final ConnectionBatch? batch = state.value;
    if (batch == null || index < 0 || index >= batch.connections.length) return;
    if (batch.connections[index].isSent) return;

    final List<ConnectionTarget> next = List<ConnectionTarget>.of(
      batch.connections,
    );
    next[index] = next[index].copyWith(isSent: true);
    state = AsyncData<ConnectionBatch>(batch.copyWith(connections: next));
  }
}

/// Claiming the roadmap step's XP.
///
/// Its own notifier rather than a flag on either batch controller, because the
/// write is about the ROADMAP, not about the batch: it must survive a batch
/// refresh, and it invalidates [engagementProgressProvider] so the step comes
/// back marked complete without a second round of guessing on the client.
///
/// Not optimistic. Awarding XP in the UI before the server has recorded it is
/// the one thing a gamified surface must never get wrong — a step that looks
/// claimed but was not is a support ticket, and the write is a single fast POST.
@riverpod
class StepCompletion extends _$StepCompletion {
  /// Whether a claim made from this screen has been accepted.
  ///
  /// A `bool` rather than `void` so the state has something to say: the screen
  /// reads `isLoading` while the POST is in flight and `hasError` when it was
  /// refused, and the value itself is what the bar would show if the user
  /// stayed put after claiming.
  @override
  Future<bool> build() async => false;

  /// Credits the step. Returns true when the server accepted it.
  ///
  /// The POST is idempotent server-side, so a double tap cannot double-award.
  Future<bool> complete(EngagementMission mission) async {
    state = const AsyncLoading<bool>();
    try {
      await ref
          .read(engagementRepositoryProvider)
          .completeStep(levelId: mission.levelId, stepId: mission.stepId);
      // The mission re-reads from here, so the step comes back `isCompleted`
      // from the server rather than being flipped locally.
      ref.invalidate(engagementProgressProvider);
      state = const AsyncData<bool>(true);
      return true;
    } on Object catch (error, stack) {
      state = AsyncError<bool>(error, stack);
      return false;
    }
  }
}

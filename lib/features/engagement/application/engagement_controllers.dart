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

/// Today's five curated posts, and the stamp when the user opens one.
///
/// Its own controller rather than a field on [CommentsController], because the
/// two halves of the comments screen have genuinely different lifetimes: the
/// niche batch is replayed free all day from a server-side cache, while this
/// one is generated once, charged once, and carries a DURABLE per-item done
/// state that Open Plexa also writes. Folding them together would mean a
/// failure in either half taking the other down, on a screen whose whole point
/// is that there are two ways to make the day's ten.
///
/// Not `keepAlive`: the stamp lives on the server, so there is nothing here
/// worth surviving a pop that a re-read would not recover.
@riverpod
class TopVoicesController extends _$TopVoicesController {
  @override
  Future<TopVoiceDay> build() =>
      ref.watch(engagementRepositoryProvider).fetchTopVoices();

  /// The user opened this post to comment on it.
  ///
  /// Optimistic, and the opposite of the rule the publish path follows.
  /// Publishing must never claim something reached LinkedIn; here the user is
  /// telling US they acted and the server stores exactly that, so the only
  /// failure mode is a tick that comes back — which it does, because a count
  /// that stayed up after a failed write would tell them the day is recorded
  /// when it is not.
  Future<void> markActed(String shownId) async {
    final TopVoiceDay? day = state.value;
    if (day == null) return;
    if (day.posts.every((TopVoice p) => p.shownId != shownId)) return;

    final TopVoiceDay before = day;
    state = AsyncData<TopVoiceDay>(day.withActed(shownId));

    try {
      await ref.read(engagementRepositoryProvider).markTopVoiceActed(shownId);
    } on Object {
      // Roll back to exactly what was there, not to "not acted": Plexa may
      // have stamped this row minutes ago, and a blanket clear would erase a
      // tick the server is right about.
      state = AsyncData<TopVoiceDay>(before);
    }
  }
}

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
  Future<CommentBatch> build(String? topic) async {
    final EngagementRepository repo = ref.watch(engagementRepositoryProvider);

    // Both at once. The session is a small read and the batch is the slow one,
    // so waiting for them in sequence would put the ledger's latency in front
    // of the content for no reason.
    final (CommentBatch batch, PlexaSession session) = await (
      repo.generateComments(topic: topic),
      repo.fetchDaySession(),
    ).wait;

    return batch.copyWith(
      comments: <CommentDraft>[
        for (int i = 0; i < batch.comments.length; i++)
          batch.comments[i].copyWith(
            isSent: session
                .doneIn(PlexaLane.comments)
                .contains(plexaItemId(PlexaLane.comments, i)),
          ),
      ],
    );
  }

  /// The user copied this comment, so it counts as deployed.
  ///
  /// "Sent" still means COPIED, and that has not changed: the copy is the last
  /// thing this app can observe, and what happens inside LinkedIn afterwards is
  /// invisible to us. What changed is where the tick is kept.
  ///
  /// It used to live only in this controller's state — and the controller is
  /// auto-dispose, so it did not survive the screen being popped. Tapping
  /// through to the dashboard and back showed `0 of 10` over work the user had
  /// done, while Open Plexa, reading the shared row, showed the real count. Two
  /// surfaces disagreeing about the same morning.
  ///
  /// Optimistic, and the same argument Plexa's own mark makes: the user is
  /// telling US they acted, the server stores exactly that, and the only
  /// failure mode is a tick that comes back.
  Future<void> markSent(int index) async {
    final CommentBatch? batch = state.value;
    if (batch == null || index < 0 || index >= batch.comments.length) return;
    if (batch.comments[index].isSent) return;

    state = AsyncData<CommentBatch>(
      batch.copyWith(comments: _replace(batch.comments, index, isSent: true)),
    );

    try {
      await ref
          .read(engagementRepositoryProvider)
          .setDayItemDone(
            lane: PlexaLane.comments,
            itemId: plexaItemId(PlexaLane.comments, index),
          );
    } on Object {
      // Put it back. A tick that stays after a failed write tells the user the
      // day is recorded when it is not — which is the whole failure this
      // change exists to end, just in the other direction.
      final CommentBatch? current = state.value;
      if (current != null) {
        state = AsyncData<CommentBatch>(
          current.copyWith(
            comments: _replace(current.comments, index, isSent: false),
          ),
        );
      }
    }
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
  Future<ConnectionBatch> build() async {
    final EngagementRepository repo = ref.watch(engagementRepositoryProvider);

    final (ConnectionBatch batch, PlexaSession session) = await (
      repo.findConnections(),
      repo.fetchDaySession(),
    ).wait;

    final List<String> done = session.doneIn(PlexaLane.connections);
    return batch.copyWith(
      connections: <ConnectionTarget>[
        for (int i = 0; i < batch.connections.length; i++)
          batch.connections[i].copyWith(
            isSent: done.contains(plexaItemId(PlexaLane.connections, i)),
          ),
      ],
    );
  }

  /// The user copied this note, so the request counts as sent.
  ///
  /// Same caveat as comments — copying is the last observable moment, and the
  /// send itself happens in LinkedIn — and the same fix: the tick is written to
  /// the shared day row rather than held in an auto-dispose controller that
  /// forgot it the moment the screen was popped.
  Future<void> markSent(int index) async {
    final ConnectionBatch? batch = state.value;
    if (batch == null || index < 0 || index >= batch.connections.length) return;
    if (batch.connections[index].isSent) return;

    state = AsyncData<ConnectionBatch>(
      batch.copyWith(connections: _withSent(batch.connections, index, true)),
    );

    try {
      await ref
          .read(engagementRepositoryProvider)
          .setDayItemDone(
            lane: PlexaLane.connections,
            itemId: plexaItemId(PlexaLane.connections, index),
          );
    } on Object {
      final ConnectionBatch? current = state.value;
      if (current != null) {
        state = AsyncData<ConnectionBatch>(
          current.copyWith(
            connections: _withSent(current.connections, index, false),
          ),
        );
      }
    }
  }

  static List<ConnectionTarget> _withSent(
    List<ConnectionTarget> targets,
    int index,
    bool isSent,
  ) {
    final List<ConnectionTarget> next = List<ConnectionTarget>.of(targets);
    next[index] = next[index].copyWith(isSent: isSent);
    return next;
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

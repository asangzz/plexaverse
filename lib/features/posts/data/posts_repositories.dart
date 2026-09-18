import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/env.dart';
import '../../../core/network/api_paths.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/storage/app_database.dart';
import '../../../core/storage/dao/posts_dao.dart';
import '../../../core/sync/mutation_dispatcher.dart';
import '../../../core/sync/pending_mutation.dart';
import '../../../core/sync/sync_engine.dart';
import '../../../core/sync/sync_failure.dart';
import '../domain/posts_repository.dart';

/// Bundled fixture mirroring the seeded demo posts. Posts are Drift-backed
/// and seeded on first launch by `PostsDao.seedIfEmpty`, so the running mock
/// reads from Drift, not this file directly; the fixture documents the mock
/// payload shape (per the mock-backend convention) and is available for
/// tests / a future JSON-first seed path via `MockApi.loadArray`.
// ignore: unused_element
const String kPostsMockAsset = 'assets/mock/posts/posts.json';

// ── Shared local-mirror mapping ─────────────────────────────────────────────

/// Maps a Drift row (+ optional metrics) to the domain [PostEntity]. Shared
/// by both repositories — reads always come from the local `posts` table so
/// the UI stays reactive regardless of backend.
PostEntity _mapRow(PostsTableData r, [PostMetricsTableData? metrics]) =>
    PostEntity(
      id: r.id,
      remoteId: r.remoteId,
      content: r.content,
      hookLine: r.hookLine,
      status: PostStatusX.fromString(r.status),
      platform: r.platform,
      scheduledAt: r.scheduledAt,
      publishedAt: r.publishedAt,
      errorMessage: r.errorMessage,
      metrics: metrics != null
          ? PostMetricsEntity(
              impressions: metrics.impressions,
              engagements: metrics.engagements,
              likes: metrics.likes,
              comments: metrics.comments,
              reposts: metrics.reposts,
            )
          : null,
      createdAt: r.createdAt,
      updatedAt: r.updatedAt,
    );

/// Local aggregation of analytics off the Drift store — identical maths for
/// both repositories (the API variant will later replace this with the remote
/// metrics endpoint). Kept as a free function so both share one code path.
Future<AnalyticsEntity> _aggregateAnalytics(PostsDao dao) async {
  final allPosts = await dao.watchAll().first;

  var totalImpressions = 0;
  var totalEngagements = 0;
  var totalReactions = 0;
  var totalComments = 0;
  var totalReposts = 0;
  TopPostSummary? topPost;
  var topImpressions = 0;
  final weekdayImpressions = List<int>.filled(7, 0);
  final rawSeries = <double>[];

  for (final post in allPosts) {
    if (post.status != 'published') continue;
    final metrics = await dao.getMetrics(post.id);
    if (metrics == null) continue;

    totalImpressions += metrics.impressions;
    totalEngagements += metrics.engagements;
    totalReactions += metrics.likes;
    totalComments += metrics.comments;
    totalReposts += metrics.reposts;
    rawSeries.add(metrics.impressions.toDouble());

    if (post.publishedAt != null) {
      weekdayImpressions[post.publishedAt!.weekday - 1] += metrics.impressions;
    }

    if (metrics.impressions > topImpressions) {
      topImpressions = metrics.impressions;
      final raw = post.hookLine ?? post.content;
      topPost = TopPostSummary(
        postId: post.id,
        preview: raw.length > 80 ? raw.substring(0, 80) : raw,
        impressions: metrics.impressions,
        engagements: metrics.engagements,
        engagementRate: metrics.impressions > 0
            ? metrics.engagements / metrics.impressions
            : 0,
      );
    }
  }

  final maxImp =
      rawSeries.isEmpty ? 1.0 : rawSeries.reduce((a, b) => a > b ? a : b);
  final impressionSeries =
      rawSeries.map((v) => maxImp > 0 ? v / maxImp : 0.0).toList();

  return AnalyticsEntity(
    totalImpressions: totalImpressions,
    totalEngagements: totalEngagements,
    impressionsDelta: 18,
    reactions: totalReactions,
    comments: totalComments,
    reposts: totalReposts,
    reactionsDelta: 22,
    commentsDelta: 8,
    repostsDelta: 31,
    impressionSeries: impressionSeries,
    topPost: topPost,
    weekdayImpressions: weekdayImpressions,
  );
}

// ── Base repository (shared Drift-backed local mirror + sync enqueue) ───────

/// Common behaviour for both repositories. Reads are Drift streams; drafts
/// write straight through; publish/schedule/retry apply an optimistic local
/// status change and enqueue the server intent on the [SyncEngine].
///
/// The only difference between mock and real is the mutation HANDLER
/// registered on the [MutationDispatcher] (see `postsRepositoryProvider`) —
/// the Api handler POSTs to Dio, the Fake handler simulates success. The
/// enqueue path is identical, which keeps offline behaviour uniform.
abstract class _BasePostsRepository implements PostsRepository {
  const _BasePostsRepository(this._dao, this._syncEngine);

  final PostsDao _dao;
  final SyncEngine _syncEngine;

  int get _now => DateTime.now().microsecondsSinceEpoch;

  @override
  Stream<List<PostEntity>> watchAll() =>
      _dao.watchAll().map((rows) => rows.map(_mapRow).toList());

  @override
  Stream<List<PostEntity>> watchByStatus(PostStatus status) =>
      _dao.watchByStatus(status.name).map((rows) => rows.map(_mapRow).toList());

  @override
  Stream<List<PostEntity>> watchRecent(int limit) =>
      _dao.watchRecent(limit).map((rows) => rows.map(_mapRow).toList());

  @override
  Future<Map<PostStatus, int>> getCounts() async {
    try {
      final raw = await _dao.countAll();
      return <PostStatus, int>{
        for (final status in PostStatus.values) status: raw[status.name] ?? 0,
      };
    } on Object {
      throw const PostsUnavailable();
    }
  }

  @override
  Future<PostEntity> createDraft({
    required String content,
    String? hookLine,
  }) async {
    try {
      final id = await _dao.insertPost(
        PostsTableCompanion(
          content: Value(content),
          hookLine: Value(hookLine),
          status: const Value('draft'),
          updatedAt: Value(DateTime.now()),
        ),
      );
      final row = await _dao.getById(id);
      if (row == null) throw const PostsUnavailable();
      return _mapRow(row);
    } on PostsUnavailable {
      rethrow;
    } on Object {
      throw const PostsUnavailable();
    }
  }

  @override
  Future<PostEntity> updateContent({
    required int id,
    required String content,
    String? hookLine,
  }) async {
    try {
      await _dao.updatePost(
        PostsTableCompanion(
          id: Value(id),
          content: Value(content),
          hookLine: Value(hookLine),
          updatedAt: Value(DateTime.now()),
        ),
      );
      final row = await _dao.getById(id);
      if (row == null) throw const PostsUnavailable();
      return _mapRow(row);
    } on PostsUnavailable {
      rethrow;
    } on Object {
      throw const PostsUnavailable();
    }
  }

  @override
  Future<PostEntity> schedulePost({
    required int id,
    required DateTime scheduledAt,
  }) async {
    return _mutateAndEnqueue(
      id: id,
      companion: PostsTableCompanion(
        id: Value(id),
        status: const Value('scheduled'),
        scheduledAt: Value(scheduledAt),
        updatedAt: Value(DateTime.now()),
      ),
      mutation: SchedulePostMutation(
        id: 'schedule-$id-$_now',
        idempotencyKey: 'schedule-$id-${scheduledAt.toUtc().toIso8601String()}',
        createdAt: DateTime.now().toUtc(),
        payload: <String, dynamic>{
          'localId': id,
          'scheduledAt': scheduledAt.toUtc().toIso8601String(),
        },
      ),
    );
  }

  @override
  Future<PostEntity> publishNow(int id) async {
    final now = DateTime.now();
    return _mutateAndEnqueue(
      id: id,
      companion: PostsTableCompanion(
        id: Value(id),
        status: const Value('published'),
        publishedAt: Value(now),
        scheduledAt: const Value(null),
        updatedAt: Value(now),
      ),
      mutation: PublishPostMutation(
        id: 'publish-$id-$_now',
        idempotencyKey: 'publish-$id',
        createdAt: now.toUtc(),
        payload: <String, dynamic>{'localId': id},
      ),
    );
  }

  @override
  Future<PostEntity> retryPost(int id) async {
    return _mutateAndEnqueue(
      id: id,
      companion: PostsTableCompanion(
        id: Value(id),
        status: const Value('scheduled'),
        errorMessage: const Value(null),
        scheduledAt: Value(DateTime.now().add(const Duration(minutes: 5))),
        updatedAt: Value(DateTime.now()),
      ),
      mutation: RetryPostMutation(
        id: 'retry-$id-$_now',
        idempotencyKey: 'retry-$id-$_now',
        createdAt: DateTime.now().toUtc(),
        payload: <String, dynamic>{'localId': id},
      ),
    );
  }

  @override
  Future<void> deletePost(int id) async {
    try {
      await _dao.deletePost(id);
    } on Object {
      throw const PostsUnavailable();
    }
  }

  @override
  Future<AnalyticsEntity> fetchAnalytics({int rangeDays = 7}) async {
    try {
      return await _aggregateAnalytics(_dao);
    } on Object {
      throw const PostsUnavailable();
    }
  }

  /// Applies the optimistic local state change, enqueues the server intent,
  /// and returns the freshly-read local row. The server round-trip happens
  /// asynchronously in the sync engine handler — the UI reflects the local
  /// change immediately and the Drift stream re-emits when the handler mirrors
  /// the confirmed result back.
  Future<PostEntity> _mutateAndEnqueue({
    required int id,
    required PostsTableCompanion companion,
    required PendingMutation mutation,
  }) async {
    try {
      await _dao.updatePost(companion);
      await _syncEngine.enqueue(mutation);
      final row = await _dao.getById(id);
      if (row == null) throw const PostsUnavailable();
      return _mapRow(row);
    } on PostsUnavailable {
      rethrow;
    } on Object {
      throw const PostsUnavailable();
    }
  }
}

// ── Real (API) repository ───────────────────────────────────────────────────

/// Real implementation. Reads mirror the local Drift store; mutations enqueue
/// on the sync engine whose registered handler POSTs to the posts API via
/// [DioClient] (endpoints in [ApiPaths]). Constructor injects the client so a
/// later fully-remote read path can be added without touching call sites.
class ApiPostsRepository extends _BasePostsRepository {
  const ApiPostsRepository(super.dao, super.syncEngine, this._client);

  // ignore: unused_field — reserved for the remote read/metrics path.
  final DioClient _client;
}

// ── Fake (mock) repository ──────────────────────────────────────────────────

/// Mock implementation used by the `mock` flavor. Behaves identically to the
/// real repo for reads/writes against Drift; its sync handler simulates a
/// successful server round-trip after a short simulated latency instead of
/// hitting Dio. Test credentials / demo posts come from the seeded Drift store
/// (`PostsDao.seedIfEmpty`, mirrored in `assets/mock/posts/posts.json`).
class FakePostsRepository extends _BasePostsRepository {
  const FakePostsRepository(super.dao, super.syncEngine);
}

// ── Mutation handlers (registered on the dispatcher) ────────────────────────

/// Registers the posts mutation handlers on the [MutationDispatcher] exactly
/// once. The engine drains queued rows and routes them here by [MutationKind].
/// Each handler resolves the local Drift row from the payload, performs the
/// backend effect (real: Dio POST; mock: simulated success), then mirrors the
/// confirmed state back into the `posts` table so the UI stream updates.
void registerPostsMutationHandlers({
  required MutationDispatcher dispatcher,
  required PostsDao dao,
  required bool useFake,
  required DioClient Function() clientOf,
}) {

  /// Resolves the SERVER id (a cuid) for a local post row.
  ///
  /// Every `/posts/{id}/...` route keys on the server id. The previous code
  /// interpolated `localId` — the Drift autoincrement — straight into those
  /// paths, so every publish, schedule and retry 404ed. A post with no
  /// `remoteId` has never reached the server, so acting on it server-side is
  /// not a transient failure to retry; it is permanent until it syncs.
  Future<String?> remoteIdOf(int localId) async =>
      (await dao.getById(localId))?.remoteId;

  Future<MutationOutcome> handlePublish(
    String mutationId,
    Map<String, dynamic> payload,
  ) async {
    final localId = payload['localId'] as int?;
    if (localId == null) {
      return MutationOutcome.permanent(
        const SyncPermanentFailure(message: 'publishPost missing localId'),
      );
    }
    try {
      if (useFake) {
        await Future<void>.delayed(const Duration(milliseconds: 400));
      } else {
        final remoteId = await remoteIdOf(localId);
        if (remoteId == null) {
          return MutationOutcome.permanent(
            const SyncPermanentFailure(
              message: 'publishPost: post has not synced to the server yet',
            ),
          );
        }
        await clientOf().post<Map<String, dynamic>>(
          ApiPaths.postPublish(remoteId),
        );
      }
      // Confirmed published — clear any stale error the UI may have shown.
      await dao.updatePost(
        PostsTableCompanion(
          id: Value(localId),
          status: const Value('published'),
          errorMessage: const Value(null),
          updatedAt: Value(DateTime.now()),
        ),
      );
      return MutationOutcome.succeeded;
    } on Object catch (e) {
      return MutationOutcome.transient(SyncTransientFailure(message: '$e'));
    }
  }

  Future<MutationOutcome> handleSchedule(
    String mutationId,
    Map<String, dynamic> payload,
  ) async {
    final localId = payload['localId'] as int?;
    final scheduledAt = payload['scheduledAt'] as String?;
    if (localId == null || scheduledAt == null) {
      return MutationOutcome.permanent(
        const SyncPermanentFailure(message: 'schedulePost missing fields'),
      );
    }
    try {
      if (useFake) {
        await Future<void>.delayed(const Duration(milliseconds: 400));
      } else {
        // There is no `/posts/{id}/schedule` route. Scheduling is its own
        // resource: POST /schedules, keyed by the post's SERVER id.
        final remoteId = await remoteIdOf(localId);
        if (remoteId == null) {
          return MutationOutcome.permanent(
            const SyncPermanentFailure(
              message: 'schedulePost: post has not synced to the server yet',
            ),
          );
        }
        await clientOf().post<Map<String, dynamic>>(
          ApiPaths.schedules,
          data: <String, dynamic>{
            'postId': remoteId,
            'scheduledAt': scheduledAt,
          },
        );
      }
      return MutationOutcome.succeeded;
    } on Object catch (e) {
      return MutationOutcome.transient(SyncTransientFailure(message: '$e'));
    }
  }

  Future<MutationOutcome> handleRetry(
    String mutationId,
    Map<String, dynamic> payload,
  ) async {
    final localId = payload['localId'] as int?;
    if (localId == null) {
      return MutationOutcome.permanent(
        const SyncPermanentFailure(message: 'retryPost missing localId'),
      );
    }
    try {
      if (useFake) {
        await Future<void>.delayed(const Duration(milliseconds: 400));
      } else {
        // There is no `/posts/{id}/retry` route. Retrying a failed post is
        // simply publishing it again.
        final remoteId = await remoteIdOf(localId);
        if (remoteId == null) {
          return MutationOutcome.permanent(
            const SyncPermanentFailure(
              message: 'retryPost: post has not synced to the server yet',
            ),
          );
        }
        await clientOf().post<Map<String, dynamic>>(
          ApiPaths.postPublish(remoteId),
        );
      }
      return MutationOutcome.succeeded;
    } on Object catch (e) {
      return MutationOutcome.transient(SyncTransientFailure(message: '$e'));
    }
  }

  dispatcher
    ..register(MutationKind.publishPost, handlePublish)
    ..register(MutationKind.schedulePost, handleSchedule)
    ..register(MutationKind.retryPost, handleRetry);
}

// ── Selector provider ───────────────────────────────────────────────────────

/// Mock ↔ real switch on `useFakeBackend`; release builds can never get the
/// mock. Registers the posts mutation handlers as a side effect of resolution
/// so the sync engine can drain posts mutations. Override in tests with
/// `overrideWithValue`.
final postsRepositoryProvider = Provider<PostsRepository>((ref) {
  final useFake = ref.watch(useFakeBackendProvider);
  assert(
    !(kReleaseMode && useFake),
    'useFakeBackend must be false in release builds.',
  );

  final dao = ref.watch(appDatabaseProvider).postsDao;
  final syncEngine = ref.watch(syncEngineProvider);
  final dispatcher = ref.watch(mutationDispatcherProvider);

  registerPostsMutationHandlers(
    dispatcher: dispatcher,
    dao: dao,
    useFake: useFake && !kReleaseMode,
    clientOf: () => ref.read(dioClientProvider),
  );

  if (useFake && !kReleaseMode) {
    return FakePostsRepository(dao, syncEngine);
  }
  return ApiPostsRepository(dao, syncEngine, ref.watch(dioClientProvider));
});

import 'analytics_entity.dart';
import 'post_entity.dart';

export 'analytics_entity.dart';
export 'post_entity.dart';

/// Thrown when a posts read or mutation can't be satisfied — the UI maps it
/// to the shared network-error state with retry (WF-31 analogue). Following
/// the orders/products convention (`feature-orders-products.md`) there is
/// exactly ONE sentinel per feature and NO typed error taxonomy; every
/// repository method collapses all failures into this.
class PostsUnavailable implements Exception {
  const PostsUnavailable();
}

/// Seam between the Posts screens and the backend, resolved mock/real by
/// `postsRepositoryProvider` via `useFakeBackend`.
///
/// Posts are an OFFLINE-FIRST product feature (RULINGS: Plexaverse product
/// tables persist to Drift). Reads are Drift streams so the UI updates
/// reactively; write intents are applied to the local `posts` table
/// immediately and — for publish/schedule/retry — enqueued on the
/// `SyncEngine` offline queue so the server call survives connectivity loss
/// and process kills. This differs from the orders/products list pattern
/// (which is a pure API/mock fetch with no local store), because the legacy
/// Plexaverse posts feature was Drift-backed and that behaviour is product
/// identity that must be preserved.
abstract class PostsRepository {
  /// Watch all posts, ordered by most recently updated.
  Stream<List<PostEntity>> watchAll();

  /// Watch posts filtered by status.
  Stream<List<PostEntity>> watchByStatus(PostStatus status);

  /// Watch the N most recent posts (for the dashboard).
  Stream<List<PostEntity>> watchRecent(int limit);

  /// Total counts per status.
  Future<Map<PostStatus, int>> getCounts();

  /// Create a new local draft. Returns the created entity.
  Future<PostEntity> createDraft({required String content, String? hookLine});

  /// Update a draft's content/hook.
  Future<PostEntity> updateContent({
    required int id,
    required String content,
    String? hookLine,
  });

  /// Schedule a post for a future time. Applied locally and queued on the
  /// sync engine.
  Future<PostEntity> schedulePost({
    required int id,
    required DateTime scheduledAt,
  });

  /// Publish immediately. Applied locally and queued on the sync engine.
  Future<PostEntity> publishNow(int id);

  /// Retry a failed post. Applied locally and queued on the sync engine.
  Future<PostEntity> retryPost(int id);

  /// Delete a post.
  Future<void> deletePost(int id);

  /// Analytics for the dashboard / analytics tab (local aggregation for now).
  Future<AnalyticsEntity> fetchAnalytics({int rangeDays = 7});
}

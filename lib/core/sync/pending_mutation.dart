/// Status of a queued mutation (ProHealth §7.2, §7.5).
///
/// Lifecycle:
///   pending → uploading → succeeded
///                       ↘ transientFailed → (next attempt) → uploading
///                                         ↘ (max attempts hit) → exhausted
///                       ↘ permanentFailed (server rejected — 4xx unrecoverable)
///
/// `exhausted` and `permanentFailed` are both surfaced in the sync inbox
/// (§11.5) but with different actions: exhausted offers Retry (resets the
/// attempt counter), permanentFailed only offers Discard.
enum SyncStatus {
  pending,
  uploading,
  succeeded,
  transientFailed,
  permanentFailed,
  exhausted,
}

/// Discriminator for the sealed [PendingMutation] hierarchy. Persisted as the
/// `kind` column on the SyncQueue row; `MutationDispatcher` uses this to
/// route to the right feature handler.
///
/// Boilerplate ships a single generic kind. Feature agents add members here
/// (one per server mutation — e.g. `publishPost`, `schedulePost`,
/// `markNotificationRead`) plus a matching [PendingMutation] subclass, then
/// register a handler with the `MutationDispatcher`.
enum MutationKind {
  /// Placeholder mutation kind so the sync queue / dispatcher / barrier
  /// machinery stays exercisable before real feature kinds are added.
  genericMutation,

  /// Posts feature (`lib/features/posts`) — publish a draft immediately.
  /// Payload: `{'localId': int}`. Handler in `posts_repositories.dart`.
  publishPost,

  /// Posts feature — schedule a draft for a future time.
  /// Payload: `{'localId': int, 'scheduledAt': ISO-8601 String}`.
  schedulePost,

  /// Posts feature — retry a failed publish (re-schedule shortly).
  /// Payload: `{'localId': int}`.
  retryPost,
}

/// Sealed mutation type (§7.2). `idempotencyKey` is the server-known token
/// the backend uses to dedup retries (§6); `batchId` groups mutations that
/// should ship together (§7.4).
///
/// Payloads are intentionally `Map<String, dynamic>` at the storage layer
/// because the sync engine is feature-agnostic. Feature-side producers build
/// the payload via freezed DTOs and call `toJson()` immediately before
/// enqueuing; consumers decode it back in their dispatcher handler. JSON goes
/// through `SyncPayloadCodec` — never a raw `jsonEncode`/`jsonDecode` at call
/// sites.
sealed class PendingMutation {
  const PendingMutation({
    required this.id,
    required this.idempotencyKey,
    required this.createdAt,
    required this.payload,
    this.batchId,
  });

  /// UUIDv4. Same id as the SyncQueue row.
  final String id;

  /// Stable token the backend dedups against. Same value across retries.
  final String idempotencyKey;

  /// Optional grouping key. Mutations with the same `batchId` are surfaced as
  /// a unit in the sync inbox and drain FIFO within the group.
  final String? batchId;

  final DateTime createdAt;
  final Map<String, dynamic> payload;

  MutationKind get kind;
}

/// Generic placeholder mutation. Feature agents replace this with concrete
/// subclasses (one per [MutationKind]) when wiring real features onto the
/// sync engine.
final class GenericMutation extends PendingMutation {
  const GenericMutation({
    required super.id,
    required super.idempotencyKey,
    required super.createdAt,
    required super.payload,
    super.batchId,
  });

  @override
  MutationKind get kind => MutationKind.genericMutation;
}

/// Publish a draft post now. Owned by the posts feature; the handler
/// registered on the [MutationDispatcher] POSTs to the posts API and mirrors
/// the result into the local Drift `posts` table. Payload carries the local
/// Drift row id under `localId` so the handler can resolve + update the row.
final class PublishPostMutation extends PendingMutation {
  const PublishPostMutation({
    required super.id,
    required super.idempotencyKey,
    required super.createdAt,
    required super.payload,
    super.batchId,
  });

  @override
  MutationKind get kind => MutationKind.publishPost;
}

/// Schedule a draft post for a future time. Payload:
/// `{'localId': int, 'scheduledAt': ISO-8601 String}`.
final class SchedulePostMutation extends PendingMutation {
  const SchedulePostMutation({
    required super.id,
    required super.idempotencyKey,
    required super.createdAt,
    required super.payload,
    super.batchId,
  });

  @override
  MutationKind get kind => MutationKind.schedulePost;
}

/// Retry a previously-failed publish. Payload: `{'localId': int}`.
final class RetryPostMutation extends PendingMutation {
  const RetryPostMutation({
    required super.id,
    required super.idempotencyKey,
    required super.createdAt,
    required super.payload,
    super.batchId,
  });

  @override
  MutationKind get kind => MutationKind.retryPost;
}

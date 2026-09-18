/// Failure taxonomy the sync engine reasons about (ProHealth §6/§11.5).
///
/// ProHealth's reference puts this sealed hierarchy in
/// `core/network/failure.dart`. Here it is kept local to `core/sync` so the
/// storage/sync subsystem is self-contained and does not depend on — or
/// pre-empt the naming of — the network agent's error file
/// (`core/network/api_error.dart` per the shared manifest). Feature mutation
/// handlers construct one of these to tell the engine whether to retry.
///
/// The distinction is what drives retry policy:
///   - [SyncTransientFailure]  → exponential backoff, up to `maxAttempts`,
///                                then `exhausted` (Retry-able in the inbox).
///   - [SyncPermanentFailure]  → 4xx the server rejected; parked for Discard.
sealed class SyncFailure {
  const SyncFailure({this.message, this.errorCode});

  /// Human-readable message safe to surface in the sync inbox.
  final String? message;

  /// Stable string from the backend, drives client-side branching.
  final String? errorCode;
}

/// Recoverable: network blip, 5xx, timeout. Retried with backoff.
final class SyncTransientFailure extends SyncFailure {
  const SyncTransientFailure({super.message, super.errorCode});
}

/// Unrecoverable: server rejected the mutation (4xx). Never retried.
final class SyncPermanentFailure extends SyncFailure {
  const SyncPermanentFailure({super.message, super.errorCode});
}

/// Catch-all when nothing more specific is known (e.g. no handler
/// registered). Treated as permanent by the dispatcher.
final class SyncUnknownFailure extends SyncFailure {
  const SyncUnknownFailure({super.message, super.errorCode});
}

/// Renders a [SyncFailure] as a single log-friendly line, stored in
/// `SyncQueue.lastError` and shown in the inbox.
String renderFailureForLog(SyncFailure failure) {
  return '${failure.runtimeType}'
      '(${failure.errorCode ?? '-'}): '
      '${failure.message ?? ''}';
}

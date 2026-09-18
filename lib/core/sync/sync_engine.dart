// ignore_for_file: prefer_initializing_formals

import 'dart:async';

import 'package:clock/clock.dart';
import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../logging/app_logger.dart';
import '../storage/app_database.dart';
import '../storage/session_store.dart';
import 'connectivity_listener.dart';
import 'mutation_dispatcher.dart';
import 'pending_mutation.dart';
import 'sync_backoff.dart';
import 'sync_failure.dart';

part 'sync_engine.g.dart';

/// Offline-action engine (ProHealth §7). Persists mutations into the
/// encrypted SyncQueue table, dedupes by `idempotencyKey`, drains FIFO under
/// a single-flight lock, retries transient failures with exponential backoff,
/// and parks permanent failures for the sync inbox (§11.5).
///
/// Per-kind dispatch is provided by [MutationDispatcher] — features register
/// handlers so the engine stays decoupled from repositories.
///
/// This is entirely in-process (RULINGS ruling 10): no WorkManager /
/// BGAppRefresh wiring exists yet. Draining is triggered at boot
/// (`start()`), on connectivity regained, on enqueue when online, on the
/// signed-out → signed-in transition, and by the backoff wake timer.
class SyncEngine {
  SyncEngine({
    required AppDatabase database,
    required ConnectivityListener connectivity,
    required AppLogger logger,
    required MutationDispatcher dispatcher,
    required bool Function() isSignedIn,
    SyncBackoff backoff = const SyncBackoff(
      base: Duration(seconds: 1),
      max: Duration(minutes: 10),
    ),
    int maxAttempts = 8,
  })  : _db = database,
        _connectivity = connectivity,
        _logger = logger,
        _dispatcher = dispatcher,
        _isSignedIn = isSignedIn,
        _backoff = backoff,
        _maxAttempts = maxAttempts;

  final AppDatabase _db;
  final ConnectivityListener _connectivity;
  final AppLogger _logger;
  final MutationDispatcher _dispatcher;
  final bool Function() _isSignedIn;
  final SyncBackoff _backoff;
  final int _maxAttempts;

  StreamSubscription<bool>? _connectivitySub;
  Future<void>? _drainLock;
  Timer? _backoffTimer;
  bool _stopped = false;

  /// Called from bootstrap after tenant hydration (and on sign-in). Recovers
  /// leftovers and subscribes to connectivity.
  Future<void> start() async {
    _stopped = false;
    // Recover any row left `uploading` by a previous process kill — those are
    // orphans (single-flight invariant) and would otherwise be invisible to
    // every subsequent drain.
    await _db.requeueOrphanedUploading();
    _connectivitySub ??= _connectivity.online.listen((online) {
      if (online && !_stopped) {
        unawaited(_drain(reason: 'connectivity.regained'));
      }
    });
    if (await _connectivity.isOnline()) {
      unawaited(_drain(reason: 'start.online'));
    }
  }

  Future<void> stop() async {
    _stopped = true;
    await _connectivitySub?.cancel();
    _connectivitySub = null;
    _backoffTimer?.cancel();
    _backoffTimer = null;
  }

  /// Enqueue a mutation. Safe to call from anywhere — persistence happens
  /// before this returns so the mutation survives a process kill.
  Future<void> enqueue(PendingMutation mutation) async {
    final inserted = await _db.insertMutation(_companionFor(mutation));
    if (inserted == 0) {
      _logger.debug(
        'SyncEngine.enqueue dedup hit '
        '${mutation.kind} ${mutation.idempotencyKey}',
      );
      return;
    }
    _logger.info('SyncEngine.enqueue ${mutation.kind} ${mutation.id}');
    if (!_stopped && await _connectivity.isOnline()) {
      unawaited(_drain(reason: 'enqueue'));
    }
  }

  /// Enqueue a set of mutations atomically — all rows commit together or none
  /// do. Used by Submit Recovery (§7.1) so a crash mid-insert can never leave
  /// orphan upload rows without their umbrella sibling.
  ///
  /// Idempotency-key collisions inside the batch are skipped via the existing
  /// `InsertMode.insertOrIgnore`; partial-dedup is acceptable because the
  /// umbrella binds the batch together.
  Future<void> enqueueBatch(List<PendingMutation> mutations) async {
    if (mutations.isEmpty) return;
    await _db.transaction(() async {
      for (final mutation in mutations) {
        await _db.insertMutation(_companionFor(mutation));
      }
    });
    _logger.info('SyncEngine.enqueueBatch wrote ${mutations.length} rows');
    if (!_stopped && await _connectivity.isOnline()) {
      unawaited(_drain(reason: 'enqueueBatch'));
    }
  }

  SyncQueueCompanion _companionFor(PendingMutation mutation) {
    return SyncQueueCompanion.insert(
      id: mutation.id,
      kind: mutation.kind,
      idempotencyKey: mutation.idempotencyKey,
      batchId: Value(mutation.batchId),
      payloadJson: SyncPayloadCodec.encode(mutation.payload),
      createdAt: mutation.createdAt.toUtc(),
      status: SyncStatus.pending,
    );
  }

  Future<void> drainNow() => _drain(reason: 'manual');

  /// Upper bound on a single drain pass. If a dispatcher handler hangs
  /// (frozen network library, stuck multipart upload, deadlock) the lock
  /// would otherwise hold forever and block every future drain. On timeout we
  /// log and release the lock — the orphaned `uploading` row is recovered on
  /// the next `start()` (§11.5).
  static const Duration _drainTimeout = Duration(minutes: 5);

  Future<void> _drain({required String reason}) {
    final existing = _drainLock;
    if (existing != null) return existing;
    final future = _drainOnce(reason).timeout(
      _drainTimeout,
      onTimeout: () {
        _logger.warn(
          'SyncEngine.drain timed out ($reason) after $_drainTimeout',
        );
      },
    );
    _drainLock = future.whenComplete(() {
      if (identical(_drainLock, future)) _drainLock = null;
    });
    return future;
  }

  Future<void> _drainOnce(String reason) async {
    if (!_isSignedIn()) {
      _logger.info('SyncEngine.drain skipped ($reason) — signed out');
      return;
    }
    _logger.info('SyncEngine.drain start ($reason)');
    final pending = await _db.pendingMutations();
    if (pending.isNotEmpty) {
      for (final row in pending) {
        if (_stopped) break;
        if (await _isBlockedByBatch(row)) {
          _logger.debug(
            'SyncEngine.drain skip ${row.kind}/${row.id} '
            '— barrier waits on batch ${row.batchId}',
          );
          continue;
        }
        await _processRow(row);
      }
    } else {
      _logger.info('SyncEngine.drain done ($reason) — nothing to send');
    }
    await _db.deleteSucceeded();
    await _scheduleBackoffWake();
    _logger.info('SyncEngine.drain done ($reason)');
  }

  /// Barrier mutations must wait for every other row in their batch to have
  /// succeeded (§11.5) before they fire. The boilerplate ships no barrier
  /// kinds; feature agents add the umbrella [MutationKind]s here when a
  /// feature introduces a batch that must drain in full before its closing
  /// mutation is dispatched.
  static const Set<MutationKind> _barrierKinds = <MutationKind>{};

  Future<bool> _isBlockedByBatch(SyncQueueData row) async {
    if (!_barrierKinds.contains(row.kind)) return false;
    final batchId = row.batchId;
    if (batchId == null) return false;
    return _db.batchHasPendingSiblings(
      batchId: batchId,
      excludingId: row.id,
    );
  }

  /// Schedules a wake-up [Timer] at the earliest pending backoff deadline so
  /// transient failures don't rely on an external trigger (connectivity blip,
  /// foreground, manual retry) to re-drain. Cancel-and-replace: every call
  /// resets the timer to the new earliest deadline, so a freshly-failed row
  /// with a sooner deadline pre-empts an older, later one.
  Future<void> _scheduleBackoffWake() async {
    _backoffTimer?.cancel();
    _backoffTimer = null;
    if (_stopped) return;
    final deadline = await _db.earliestBackoffDeadline();
    if (deadline == null) return;
    final delay = deadline.difference(clock.now().toUtc());
    if (delay <= Duration.zero) {
      unawaited(_drain(reason: 'backoff.elapsed'));
      return;
    }
    _backoffTimer = Timer(delay, () {
      _backoffTimer = null;
      if (_stopped) return;
      unawaited(_drain(reason: 'backoff.wake'));
    });
  }

  Future<void> _processRow(SyncQueueData row) async {
    await _db.markStatus(id: row.id, status: SyncStatus.uploading);
    final result = await _dispatcher.dispatch(row);
    switch (result) {
      case MutationOutcomeSucceeded():
        await _db.markStatus(id: row.id, status: SyncStatus.succeeded);
      case MutationOutcomeTransient(:final failure):
        await _handleTransient(row, failure);
      case MutationOutcomePermanent(:final failure):
        await _handlePermanent(row, failure);
    }
  }

  Future<void> _handleTransient(SyncQueueData row, SyncFailure failure) async {
    final nextAttempt = row.attempts + 1;
    if (nextAttempt >= _maxAttempts) {
      await _giveUpAfterRetries(row, failure, nextAttempt);
      return;
    }
    await _db.markStatus(
      id: row.id,
      status: SyncStatus.transientFailed,
      attempts: nextAttempt,
      lastError: renderFailureForLog(failure),
      nextAttemptAt: clock.now().toUtc().add(_backoff.delayFor(nextAttempt)),
    );
  }

  Future<void> _giveUpAfterRetries(
    SyncQueueData row,
    SyncFailure failure,
    int attempts,
  ) async {
    // Distinct from `permanentFailed`: the server never rejected this — we
    // ran out of retry budget after repeated transient failures (§7.5). The
    // inbox offers Retry, which resets the attempt counter.
    await _db.markStatus(
      id: row.id,
      status: SyncStatus.exhausted,
      attempts: attempts,
      lastError: renderFailureForLog(failure),
    );
    _logger.warn(
      'SyncEngine: exhausted retries on '
      '${row.kind}/${row.id} after $attempts attempts',
    );
  }

  Future<void> _handlePermanent(SyncQueueData row, SyncFailure failure) async {
    await _db.markStatus(
      id: row.id,
      status: SyncStatus.permanentFailed,
      attempts: row.attempts + 1,
      lastError: renderFailureForLog(failure),
    );
    _logger.warn('SyncEngine: permanent failure on ${row.kind}/${row.id}');
  }
}

@Riverpod(keepAlive: true)
SyncEngine syncEngine(Ref ref) {
  final session = ref.watch(sessionStoreProvider);
  final engine = SyncEngine(
    database: ref.watch(appDatabaseProvider),
    connectivity: ref.watch(connectivityListenerProvider),
    logger: ref.watch(appLoggerProvider),
    dispatcher: ref.watch(mutationDispatcherProvider),
    // Whether a (non-expired) access token is present. Kept synchronous so
    // the drain loop can gate cheaply. ProHealth reads this off an async
    // `authGateProvider`; the auth feature can override this wiring once it
    // lands. Until then a null cache means "signed out" and the drain
    // simply skips — it never burns retries on 401s.
    isSignedIn: () => _signedInCache,
  );
  // Keep a cheap synchronous view of sign-in state fresh. `activeAccessToken`
  // is async, so we refresh the cache whenever the session provider rebuilds
  // and eagerly on first build; the drain re-checks connectivity anyway.
  ref.listen<SessionStore>(sessionStoreProvider, (_, next) {
    unawaited(_refreshSignedInCache(next, engine));
  });
  unawaited(_refreshSignedInCache(session, engine));
  ref.onDispose(() => unawaited(engine.stop()));
  return engine;
}

/// Synchronous cache of "is there a usable access token right now". Updated
/// asynchronously from [SessionStore]; read by the engine's drain gate.
bool _signedInCache = false;

Future<void> _refreshSignedInCache(
  SessionStore session,
  SyncEngine engine,
) async {
  final wasSignedIn = _signedInCache;
  final token = await session.activeAccessToken();
  _signedInCache = token != null;
  // Re-drain immediately on the signed-out → signed-in transition so a
  // freshly-authenticated session catches up on queued work without waiting
  // for the next connectivity blip or foreground tick.
  if (!wasSignedIn && _signedInCache) {
    unawaited(engine.drainNow());
  }
}

import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqlcipher_flutter_libs/sqlcipher_flutter_libs.dart';
import 'package:sqlite3/open.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite;

import '../config/env.dart';
import '../sync/pending_mutation.dart';
import '../sync/sync_queue.dart';
import 'dao/notification_dao.dart';
import 'dao/posts_dao.dart';
import 'dao/user_stats_dao.dart';
import 'db_key_manager.dart';
import 'secure_storage.dart';
import 'tables.dart';

part 'app_database.g.dart';

/// The single encrypted (SQLCipher) Drift database for the app
/// (RULINGS ruling 9). Holds the offline mutation queue (`sync_queue`,
/// core/sync) alongside the Plexaverse product tables (posts, post_metrics,
/// user_stats, missions, notifications). The pre-migration `users` /
/// `sessions` tables are dropped (ruling 8 — the session lives in
/// `SessionStore`).
///
/// Fresh `schemaVersion = 1`, no migration path: `onUpgrade` throws by design
/// (see [migration]). Wiping the local DB is acceptable at this dev stage.
@DriftDatabase(
  tables: <Type>[
    SyncQueue,
    PostsTable,
    PostMetricsTable,
    UserStatsTable,
    MissionsTable,
    NotificationsTable,
  ],
  daos: <Type>[
    PostsDao,
    UserStatsDao,
    NotificationDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(SecureStorageService secure, {this.seedDemoData = false})
      : super(_openConnection(secure));

  /// Test constructor — bypasses SQLCipher entirely (pass an in-memory or
  /// plain executor). Never used in production.
  AppDatabase.forTesting(super.executor, {this.seedDemoData = false});

  /// Whether a fresh database is filled with the demo fixtures.
  ///
  /// **Only ever true for the mock flavor.** This used to be unconditional:
  /// [migration]'s `beforeOpen` seeded on `details.wasCreated` alone, with no
  /// flavor, release or `useFakeBackend` check, so a real dev/staging/prod
  /// install wrote a 40-day streak, 1440 XP, level 8, five invented LinkedIn
  /// posts and 16,200 impressions of engagement into the user's own encrypted
  /// database before they had done anything.
  ///
  /// Nothing rendered those rows — both readers (`OdysseyPage`,
  /// `posts_controllers.dart`) were unrouted legacy code, and they are deleted
  /// in the same change — but the seed is gated rather than removed because it
  /// is what makes the mock flavor a usable demo. A future screen reading
  /// these DAOs must inherit an empty database, not someone else's numbers.
  final bool seedDemoData;

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (migrator) async {
          await migrator.createAll();
          // Hand-written covering indexes on the sync queue for the drain
          // query (status + createdAt), the dispatcher lookup (kind), and the
          // backoff-wake scan (nextAttemptAt).
          await customStatement(
            'CREATE INDEX IF NOT EXISTS idx_sync_queue_status_created '
            'ON sync_queue(status, created_at);',
          );
          await customStatement(
            'CREATE INDEX IF NOT EXISTS idx_sync_queue_kind '
            'ON sync_queue(kind);',
          );
          await customStatement(
            'CREATE INDEX IF NOT EXISTS idx_sync_queue_next_attempt '
            'ON sync_queue(next_attempt_at);',
          );
        },
        // Ships schema v1. Every future schema-version bump MUST add a
        // `from == N` branch here; the default throws loudly rather than
        // corrupting the DB — a forgotten migration step would otherwise
        // silently drop columns on existing installs (ruling 9 convention).
        onUpgrade: (migrator, from, to) async {
          throw UnimplementedError(
            'AppDatabase upgrade from v$from to v$to is not implemented. '
            'Add a migration branch alongside the schemaVersion bump.',
          );
        },
        beforeOpen: (details) async {
          // Foreign-key constraints are off by default in SQLite; turn them
          // on as soon as the encrypted connection is alive (post_metrics
          // cascades on posts).
          await customStatement('PRAGMA foreign_keys = ON;');
          // Seed demo product data on the fresh install — MOCK FLAVOR ONLY.
          // See [seedDemoData]: on a real backend these rows would be
          // indistinguishable from the user's own history.
          if (details.wasCreated && seedDemoData) {
            await postsDao.seedIfEmpty();
            await userStatsDao.seedIfEmpty();
          }
        },
      );

  // ---- SyncQueue query surface (used by SyncEngine / SyncController) --------

  Future<List<SyncQueueData>> pendingMutations({int limit = 50}) {
    final now = DateTime.now().toUtc();
    return (select(syncQueue)
          ..where((t) =>
              t.status.equalsValue(SyncStatus.pending) |
              t.status.equalsValue(SyncStatus.transientFailed))
          ..where((t) =>
              t.nextAttemptAt.isNull() |
              t.nextAttemptAt.isSmallerThanValue(now))
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)])
          ..limit(limit))
        .get();
  }

  Future<SyncQueueData?> findByIdempotencyKey(String key) {
    return (select(syncQueue)..where((t) => t.idempotencyKey.equals(key)))
        .getSingleOrNull();
  }

  Future<int> insertMutation(SyncQueueCompanion row) {
    return into(syncQueue).insert(row, mode: InsertMode.insertOrIgnore);
  }

  Future<int> markStatus({
    required String id,
    required SyncStatus status,
    String? lastError,
    DateTime? nextAttemptAt,
    int? attempts,
  }) {
    return (update(syncQueue)..where((t) => t.id.equals(id))).write(
      SyncQueueCompanion(
        status: Value(status),
        lastError: Value(lastError),
        nextAttemptAt: Value(nextAttemptAt),
        attempts: attempts != null ? Value(attempts) : const Value.absent(),
      ),
    );
  }

  Future<int> deleteSucceeded() {
    return (delete(syncQueue)
          ..where((t) => t.status.equalsValue(SyncStatus.succeeded)))
        .go();
  }

  /// Resets any row left in `uploading` from a previous process — those are
  /// orphans by definition (at most one engine instance can be uploading at a
  /// time). Without this the drain query (which filters on `pending` +
  /// `transientFailed`) would skip them forever after a process kill
  /// mid-dispatch.
  Future<int> requeueOrphanedUploading() {
    return (update(syncQueue)
          ..where((t) => t.status.equalsValue(SyncStatus.uploading)))
        .write(const SyncQueueCompanion(status: Value(SyncStatus.pending)));
  }

  /// True iff [batchId] still has at least one non-succeeded row OTHER than
  /// the caller (identified by [excludingId]). Used by the engine to hold
  /// back a barrier mutation until every other row in its batch has succeeded
  /// or been discarded.
  ///
  /// `permanentFailed` / `exhausted` count as "still outstanding" — a barrier
  /// must not fire while the inbox holds an explicit failure the user hasn't
  /// dealt with yet.
  Future<bool> batchHasPendingSiblings({
    required String batchId,
    required String excludingId,
  }) async {
    final query = (select(syncQueue)
          ..where((t) => t.batchId.equals(batchId))
          ..where((t) => t.id.equals(excludingId).not())
          ..where((t) => t.status.equalsValue(SyncStatus.succeeded).not())
          ..limit(1));
    final row = await query.getSingleOrNull();
    return row != null;
  }

  /// Earliest future `nextAttemptAt` among rows still in the retry loop
  /// (transient failures with a backoff deadline). Used by the engine to
  /// schedule a wake-up timer so backoff doesn't depend on a connectivity
  /// blip or foreground to fire.
  Future<DateTime?> earliestBackoffDeadline() async {
    final now = DateTime.now().toUtc();
    final query = (select(syncQueue)
          ..where((t) => t.status.equalsValue(SyncStatus.transientFailed))
          ..where((t) =>
              t.nextAttemptAt.isNotNull() &
              t.nextAttemptAt.isBiggerThanValue(now))
          ..orderBy(<OrderClauseGenerator<$SyncQueueTable>>[
            (t) => OrderingTerm.asc(t.nextAttemptAt),
          ])
          ..limit(1));
    final row = await query.getSingleOrNull();
    return row?.nextAttemptAt;
  }

  /// Live stream of every SyncQueue row. Used by SyncController to derive the
  /// global banner summary; not exposed to feature code directly.
  Stream<List<SyncQueueData>> watchSyncQueueRows() {
    return select(syncQueue).watch();
  }

  /// Live stream of every non-succeeded SyncQueue row, newest first. Powers
  /// the sync inbox list.
  Stream<List<SyncQueueData>> watchInboxRows() {
    return (select(syncQueue)
          ..where((t) => t.status.equalsValue(SyncStatus.succeeded).not())
          ..orderBy(<OrderClauseGenerator<$SyncQueueTable>>[
            (t) => OrderingTerm.desc(t.createdAt),
          ]))
        .watch();
  }

  Future<SyncQueueData?> findSyncQueueRow(String id) {
    return (select(syncQueue)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  Future<int> deleteSyncQueueRow(String id) {
    return (delete(syncQueue)..where((t) => t.id.equals(id))).go();
  }

  /// Distinct non-null `batchId` values from [SyncQueue]. Acts as a proxy for
  /// "entities with queued or in-flight uploads" — the MediaCacheSweeper uses
  /// it to avoid evicting media folders whose uploads are still pending.
  Future<Set<String>> distinctSyncQueueBatchIds() async {
    final query = selectOnly(syncQueue, distinct: true)
      ..addColumns(<Expression<Object>>[syncQueue.batchId])
      ..where(syncQueue.batchId.isNotNull());
    final rows = await query.get();
    return rows
        .map((row) => row.read(syncQueue.batchId))
        .whereType<String>()
        .toSet();
  }
}

/// Opens the encrypted SQLite database. The 256-bit key is resolved via
/// [DbKeyManager] (generated on first launch, stored in the Keystore /
/// Keychain). `PRAGMA key` must run before any other statement, hence the
/// `setup` callback.
LazyDatabase _openConnection(SecureStorageService secure) {
  return LazyDatabase(() async {
    if (Platform.isAndroid) {
      await applyWorkaroundToOpenSqlCipherOnOldAndroidVersions();
      // Route the `sqlite3` package at the bundled SQLCipher library
      // (libsqlcipher.so) instead of the stock libsqlite3.so, which Android
      // does not ship — without this, opening the DB fails with
      // "Failed to load dynamic library 'libsqlite3.so'".
      open.overrideFor(OperatingSystem.android, openCipherOnAndroid);
    }
    final hexKey = await DbKeyManager(secure).resolveHexKey();
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'plexaverse.sqlite'));
    return NativeDatabase(file, setup: (rawDb) => _setupCipher(rawDb, hexKey));
  });
}

/// Applies the SQLCipher PRAGMAs before any other statement runs and performs
/// a smoke read so a wrong key fails fast. Order is load-bearing.
void _setupCipher(sqlite.Database rawDb, String hexKey) {
  // SQLCipher requires PRAGMA key be the first statement executed. Using the
  // x'…' hex literal avoids any quoting / encoding ambiguity.
  rawDb.execute("PRAGMA key = \"x'$hexKey'\";");
  // Cipher v4 defaults — explicit so an upstream SQLCipher upgrade can't
  // silently change the on-disk format and brick existing DBs.
  rawDb.execute('PRAGMA cipher_compatibility = 4;');
  final result = rawDb.select('SELECT count(*) FROM sqlite_master;');
  if (result.isEmpty) {
    throw StateError('SQLCipher open failed: empty schema probe.');
  }
}

/// Companion JSON codec for sync payloads. Lives here so call sites never
/// reach for raw `jsonEncode`/`jsonDecode` directly.
class SyncPayloadCodec {
  const SyncPayloadCodec._();
  static String encode(Map<String, dynamic> payload) => jsonEncode(payload);
  static Map<String, dynamic> decode(String raw) =>
      jsonDecode(raw) as Map<String, dynamic>;
}

@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) {
  final db = AppDatabase(
    ref.watch(secureStorageProvider),
    // The demo fixtures belong to the mock flavor and nowhere else.
    seedDemoData: ref.watch(useFakeBackendProvider),
  );
  ref.onDispose(db.close);
  return db;
}

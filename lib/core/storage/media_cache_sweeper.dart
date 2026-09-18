// ignore_for_file: prefer_initializing_formals
// Named-parameter constructor reads cleaner than `this._cache` here; private
// fields stay private.

import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../config/app_config.dart';
import '../logging/app_logger.dart';
import 'app_database.dart';
import 'media_cache.dart';

part 'media_cache_sweeper.g.dart';

/// One-shot app-start cleanup of [MediaCache] (ProHealth §7.7).
///
/// Conservatively deletes encrypted media files older than
/// [AppConfig.mediaRetention] whose `jobId` is no longer referenced by a
/// `SyncQueue` row's `batchId` (mutations still queued or in flight for that
/// entity).
///
/// [MediaCache] lays files out as `media/pending/<jobId>/<filename>`, so the
/// jobId is the parent directory name — no filename parsing required here.
class MediaCacheSweeper {
  MediaCacheSweeper({
    required MediaCache cache,
    required AppDatabase database,
    required AppLogger logger,
  })  : _cache = cache,
        _database = database,
        _logger = logger;

  final MediaCache _cache;
  final AppDatabase _database;
  final AppLogger _logger;

  /// Single sweep pass. Returns the number of files deleted. Errors are
  /// logged but never rethrown — disk cleanup must not block or crash boot.
  Future<int> sweep() async {
    try {
      final active = await _activeJobIds();
      final removed = await _cache.evictOlderThan(
        AppConfig.mediaRetention,
        isEligible: (file) => !active.contains(_jobIdFor(file)),
      );
      if (removed > 0) {
        _logger.info('MediaCacheSweeper: removed $removed stale files');
      }
      return removed;
    } on Object catch (error, stack) {
      _logger.warn(
        'MediaCacheSweeper: sweep failed',
        error: error,
        stackTrace: stack,
      );
      return 0;
    }
  }

  Future<Set<String>> _activeJobIds() async {
    // No per-entity local draft table yet, so the only "still in-flight"
    // signal is a queued/uploading SyncQueue batchId. A feature that adds a
    // draft-id source wires it back in here.
    const drafts = <String>{};
    final queued = await _database.distinctSyncQueueBatchIds();
    return <String>{...drafts, ...queued};
  }

  String _jobIdFor(File file) {
    // Layout: <docs>/media/pending/<jobId>/<filename>
    return p.basename(p.dirname(file.path));
  }
}

@Riverpod(keepAlive: true)
Future<MediaCacheSweeper> mediaCacheSweeper(Ref ref) async {
  return MediaCacheSweeper(
    cache: await ref.watch(mediaCacheProvider.future),
    database: ref.watch(appDatabaseProvider),
    logger: ref.watch(appLoggerProvider),
  );
}

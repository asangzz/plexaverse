import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../storage/app_database.dart';
import 'pending_mutation.dart';
import 'sync_engine.dart';
import 'sync_status_summary.dart';

part 'sync_controller.g.dart';

/// App-lifetime projection of the SyncQueue (ProHealth §11.5). Watches the
/// drift stream and emits a [SyncStatusSummary] per change — that's what the
/// global sync banner consumes via Riverpod.
///
/// `core/sync` may legitimately depend on `core/storage` — both are
/// infrastructure adapters. Feature presentation never imports either;
/// presentation reads only [SyncStatusSummary].
@Riverpod(keepAlive: true)
class SyncController extends _$SyncController {
  @override
  Stream<SyncStatusSummary> build() {
    return ref.watch(appDatabaseProvider).watchSyncQueueRows().map(_summarise);
  }

  /// User-initiated drain ("Sync now"). Fire-and-forget; outcomes flow back
  /// through the queue stream this controller is already listening to.
  Future<void> drainNow() => ref.read(syncEngineProvider).drainNow();

  SyncStatusSummary _summarise(List<SyncQueueData> rows) {
    var pending = 0;
    var uploading = 0;
    var transient = 0;
    var exhausted = 0;
    var permanent = 0;
    for (final row in rows) {
      switch (row.status) {
        case SyncStatus.pending:
          pending++;
        case SyncStatus.uploading:
          uploading++;
        case SyncStatus.transientFailed:
          transient++;
        case SyncStatus.exhausted:
          exhausted++;
        case SyncStatus.permanentFailed:
          permanent++;
        case SyncStatus.succeeded:
          break;
      }
    }
    return SyncStatusSummary(
      pendingCount: pending,
      uploadingCount: uploading,
      transientFailedCount: transient,
      exhaustedCount: exhausted,
      permanentFailedCount: permanent,
    );
  }
}

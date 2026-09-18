/// Snapshot of the SyncQueue, projected from raw rows by `SyncController`.
/// Pure value object — no Flutter, no drift, no presentation logic. Drives
/// the global sync banner (core/ui) and the sync inbox.
///
/// Counts are split by status so the inbox can render distinct totals for
/// "will retry" vs "rejected" vs "exhausted" without re-querying.
class SyncStatusSummary {
  const SyncStatusSummary({
    required this.pendingCount,
    required this.uploadingCount,
    required this.transientFailedCount,
    required this.exhaustedCount,
    required this.permanentFailedCount,
  });

  const SyncStatusSummary.empty()
      : pendingCount = 0,
        uploadingCount = 0,
        transientFailedCount = 0,
        exhaustedCount = 0,
        permanentFailedCount = 0;

  final int pendingCount;
  final int uploadingCount;
  final int transientFailedCount;
  final int exhaustedCount;
  final int permanentFailedCount;

  int get inFlightCount => pendingCount + uploadingCount;

  int get failedCount =>
      transientFailedCount + exhaustedCount + permanentFailedCount;

  bool get isQuiet => inFlightCount == 0 && failedCount == 0;
}

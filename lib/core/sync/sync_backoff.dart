import 'dart:math';

/// Exponential backoff scheduler used by `SyncEngine`. Lives in its own file
/// so the engine stays under the file/class size caps.
///
/// `delayFor(attempt)` returns `base * 2^(attempt-1)`, clamped to `max`.
/// Engine defaults: `base = 1s`, `max = 10min`, `maxAttempts = 8`.
class SyncBackoff {
  const SyncBackoff({required this.base, required this.max});

  final Duration base;
  final Duration max;

  Duration delayFor(int attempt) {
    final factor = pow(2, attempt < 1 ? 0 : attempt - 1).toInt();
    final ms = base.inMilliseconds * factor;
    if (ms < 0 || ms > max.inMilliseconds) return max;
    return Duration(milliseconds: ms);
  }
}

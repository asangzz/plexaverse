import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/connections_repositories.dart';
import '../domain/connections_repository.dart';

part 'connections_controller.g.dart';

/// The roadmap's weekly connections check-in. The read half.
///
/// The web reads this on every roadmap open; so does this — a reading is a
/// few rows, and a stale one is exactly the case the card exists to catch.
@riverpod
Future<ConnectionSummary> connectionSummary(Ref ref) =>
    ref.watch(connectionsRepositoryProvider).fetchSummary();

/// Whether a save is in flight, and what the last attempt said.
///
/// Held here and not on the card for the reason the architecture test gives:
/// a `bool _busy` on a widget has shipped as a user-visible defect five times
/// in this codebase.
class ConnectionSave {
  const ConnectionSave({this.busy = false, this.error});

  final bool busy;

  /// The sentence to show under the field. Null when nothing has failed since
  /// the last attempt.
  final String? error;
}

/// Saves a typed count.
@riverpod
class ConnectionActions extends _$ConnectionActions {
  @override
  ConnectionSave build() => const ConnectionSave();

  /// Saves [raw] as the count, and answers whether it was saved.
  ///
  /// A number the server can only refuse is refused here, in its words, and
  /// never sent.
  Future<bool> record(String raw) async {
    if (state.busy) return false;
    final int? count = parseConnectionCount(raw);
    if (count == null) {
      state = const ConnectionSave(error: connectionRangeMessage);
      return false;
    }

    state = const ConnectionSave(busy: true);
    try {
      await ref.read(connectionsRepositoryProvider).record(count);
      if (!ref.mounted) return false;
      state = const ConnectionSave();
      // Re-read rather than patch: the week's figure depends on which earlier
      // reading is the baseline, and that is the server's arithmetic.
      ref.invalidate(connectionSummaryProvider);
      return true;
    } on Object catch (e) {
      if (!ref.mounted) return false;
      state = ConnectionSave(error: _say(e));
      return false;
    }
  }

  /// The field changed, so last attempt's sentence no longer describes it.
  void clearError() {
    if (state.error != null && !state.busy) state = const ConnectionSave();
  }

  static String _say(Object error) => switch (error) {
    ConnectionsInvalid(:final String message) => message,
    // The web's own fallback for a save that did not land.
    _ => 'Could not save that number.',
  };
}

/// Until when "Not now" holds on this device.
///
/// Three days — shorter than the follower card's month, because the question
/// is weekly. A per-device convenience exactly as the web's localStorage key
/// is per browser, under the same name: a snooze that cannot be read or
/// written just means the card asks again, so every failure here is "not
/// snoozed" and nothing waits on it.
@Riverpod(keepAlive: true)
class ConnectionPromptSnooze extends _$ConnectionPromptSnooze {
  static const String storageKey = 'plexa.connectionPrompt.snoozedUntil';

  static const Duration length = Duration(days: 3);

  @override
  Future<DateTime?> build() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final int? until = prefs.getInt(storageKey);
      return until == null ? null : DateTime.fromMillisecondsSinceEpoch(until);
    } on Object {
      return null;
    }
  }

  /// Puts the question away for [length].
  Future<void> snooze({DateTime? now}) async {
    final DateTime until = (now ?? DateTime.now()).add(length);
    // Shown at once; the write is only so it outlives the app.
    state = AsyncData<DateTime?>(until);
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt(storageKey, until.millisecondsSinceEpoch);
    } on Object {
      // A snooze we cannot remember just means we ask again next launch.
    }
  }
}

/// Is "Not now" still holding at [now]?
bool isConnectionPromptSnoozed(DateTime? until, {DateTime? now}) =>
    until != null && (now ?? DateTime.now()).isBefore(until);

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/logging/app_logger.dart';
import 'calendar_controller.dart';

part 'reschedule_controller.g.dart';

/// What a drag onto a new day is currently doing, and how it last went.
///
/// ## Why this is not on the widget
///
/// It was. `_busy` and `_error` were fields on `_CalendarPageState`, and the
/// catch that set them ran `if (!mounted) return;` first — so a user who
/// backed out of the calendar mid-round-trip got a reschedule that failed
/// with no trace anywhere. No banner, no state, no retry, and the next poll
/// showed the post sitting on its old day exactly as if nothing had been
/// attempted. State about whether a Cloud Task was re-queued cannot live on a
/// screen the user is free to leave.
///
/// A log line was the first fix and it is still there — it is what reaches
/// Crashlytics. But a log is for us, not for the person whose post did not
/// move. This is the part they can see.
///
/// ## What is deliberately NOT changed
///
/// `CalendarController.reschedule` stays non-optimistic. Its doc explains
/// why: scheduling is the one action on this screen whose server side does
/// real work — it re-queues the Cloud Task, rewrites the Google Calendar
/// event and detaches the post from its planner slot — so a local guess at
/// the result can be wrong in ways the user would only discover when the post
/// failed to go out. That decision is about optimism, not about ownership,
/// and this changes only the ownership.
@riverpod
class RescheduleController extends _$RescheduleController {
  /// Idle. `AsyncData` with nothing in it — not loading, not failed.
  @override
  AsyncValue<void> build() => const AsyncData<void>(null);

  /// Moves [postId] to [when].
  ///
  /// Returns true when the move landed. The outcome is also left on this
  /// controller, so a caller that has gone away does not take it with them.
  Future<bool> run({
    required String postId,
    required DateTime when,
  }) async {
    // Held for the length of the operation. This provider is autoDispose and
    // the calendar page is normally its only listener, so backing out during
    // the round-trip would otherwise let Riverpod tear the notifier down
    // mid-await — and writing `state` afterwards throws, losing the failure
    // in a new way while fixing the old one. Released in the `finally`, so a
    // page that is genuinely gone still disposes afterwards.
    // Type inferred: `KeepAliveLink` is not exported from
    // riverpod_annotation. Same shape AuthController uses.
    final link = ref.keepAlive();
    state = const AsyncLoading<void>();
    try {
      await ref
          .read(calendarControllerProvider.notifier)
          .reschedule(postId: postId, when: when);
      state = const AsyncData<void>(null);
      return true;
    } on Object catch (error, stackTrace) {
      // Crashlytics gets it regardless of who is still watching.
      ref
          .read(appLoggerProvider)
          .error(
            'Calendar reschedule failed: post $postId → '
            '${when.toIso8601String()}',
            error: error,
            stackTrace: stackTrace,
          );
      state = AsyncError<void>(error, stackTrace);
      return false;
    } finally {
      link.close();
    }
  }

  /// Clears a failure the user has read.
  ///
  /// Only ever called from a dismiss control. The failure does NOT clear
  /// itself on a rebuild or a navigation — surviving those is the entire
  /// point.
  void acknowledge() => state = const AsyncData<void>(null);
}

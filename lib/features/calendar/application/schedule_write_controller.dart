import 'package:flutter/foundation.dart' show setEquals;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/logging/app_logger.dart';
import 'schedules_controller.dart';

part 'schedule_write_controller.g.dart';

/// What the schedules screen is currently writing, and how the last write went.
///
/// [busyIds] is per-row and NOT one screen-wide boolean: a single flag cannot
/// say WHICH schedule is mutating, so pausing one row used to disable and spin
/// every other row for the whole round-trip. That property was fixed in
/// 2b32067 and is kept here exactly — only its owner changed.
class ScheduleWriteState {
  const ScheduleWriteState({
    this.busyIds = const <String>{},
    this.creating = false,
    this.error,
  });

  /// Schedule ids with a write in flight.
  final Set<String> busyIds;

  /// A create is in flight. Separate from [busyIds] because the row being
  /// created has no id yet.
  final bool creating;

  /// The last write's failure, as the message the screen shows. Null is "no
  /// failure outstanding" — it is cleared when the next write starts and when
  /// the user dismisses it, and by nothing else.
  final String? error;

  bool isBusy(String id) => busyIds.contains(id);

  /// Marks one row — or the create, which passes a null [rowId] — as writing.
  ScheduleWriteState marking(String? rowId, {required bool busy}) {
    if (rowId == null) {
      return ScheduleWriteState(busyIds: busyIds, creating: busy, error: error);
    }
    final Set<String> next = <String>{...busyIds};
    if (busy) {
      next.add(rowId);
    } else {
      next.remove(rowId);
    }
    return ScheduleWriteState(busyIds: next, creating: creating, error: error);
  }

  /// Sets or clears [error]. A named method rather than a `copyWith`
  /// parameter, because null here means "clear it" and a `copyWith` cannot
  /// tell that from "leave it alone".
  ScheduleWriteState withError(String? message) =>
      ScheduleWriteState(busyIds: busyIds, creating: creating, error: message);

  @override
  bool operator ==(Object other) =>
      other is ScheduleWriteState &&
      setEquals(other.busyIds, busyIds) &&
      other.creating == creating &&
      other.error == error;

  @override
  int get hashCode =>
      Object.hash(Object.hashAllUnordered(busyIds), creating, error);
}

/// The schedules screen's writes: create, pause/resume, delete.
///
/// ## Why this is not on the widget
///
/// `_busyIds`, `_creating` and `_error` were fields on `_SchedulesPageState`,
/// and the `catch` that set them ran `if (!mounted) return;` first — the same
/// shape that lost a failed reschedule on the calendar page next door, and the
/// same fix. Deleting a schedule and leaving the screen mid-round-trip
/// discarded the outcome entirely: no notice, no log, and a rule that may or
/// may not still be posting on the user's behalf. These are in-flight flags
/// for an async use case and the result of a repository call, which
/// ARCHITECTURE.md puts in `application/` by name.
///
/// ## What is deliberately NOT changed
///
/// [SchedulesController] keeps its own behaviour untouched: `setActive` stays
/// optimistic and swallows its failure by restoring the server's truth
/// (`invalidateSelf`), so a toggle that fails shows the switch snapping back
/// rather than a notice. That is its documented design — a switch that does
/// not move until a round-trip completes reads as broken — and this change is
/// about ownership, not optimism.
@riverpod
class ScheduleWriteController extends _$ScheduleWriteController {
  @override
  ScheduleWriteState build() => const ScheduleWriteState();

  /// Create — the sheet collects the draft, this sends it.
  ///
  /// Named parameters rather than the sheet's `ScheduleDraft`: that type lives
  /// in `presentation/`, and importing it here would reverse the dependency
  /// arrow this move exists to respect.
  Future<bool> create({
    required String linkedinAccountId,
    required List<int> dayOfWeek,
    required String timeOfDay,
    String? topicId,
  }) => _run(
    rowId: null,
    what: 'create schedule',
    action: () => ref
        .read(schedulesControllerProvider.notifier)
        .create(
          linkedinAccountId: linkedinAccountId,
          dayOfWeek: dayOfWeek,
          timeOfDay: timeOfDay,
          topicId: topicId,
        ),
  );

  Future<bool> setActive(String id, {required bool isActive}) => _run(
    rowId: id,
    what: '${isActive ? 'resume' : 'pause'} schedule $id',
    action: () => ref
        .read(schedulesControllerProvider.notifier)
        .setActive(id, isActive: isActive),
  );

  Future<bool> remove(String id) => _run(
    rowId: id,
    what: 'delete schedule $id',
    action: () => ref.read(schedulesControllerProvider.notifier).remove(id),
  );

  /// Clears a failure the user has read. Nothing else clears it — surviving a
  /// rebuild and a navigation is the point.
  void acknowledge() => state = state.withError(null);

  /// Runs one write behind the busy marker and the error surface, so every
  /// mutation on the screen fails the same visible way.
  ///
  /// Returns true when it landed.
  Future<bool> _run({
    required String? rowId,
    required String what,
    required Future<void> Function() action,
  }) async {
    // Pinned for the length of the operation. This provider is autoDispose and
    // the schedules page is normally its only listener, so leaving the screen
    // mid-round-trip would otherwise tear the notifier down mid-await and make
    // the `state =` below throw — losing the failure in a new way while fixing
    // the old one. Released in the `finally`, so a page that is genuinely gone
    // still disposes afterwards. Type inferred: `KeepAliveLink` is not
    // exported from riverpod_annotation. Same shape RescheduleController uses.
    final link = ref.keepAlive();
    state = state.marking(rowId, busy: true).withError(null);
    try {
      await action();
      state = state.marking(rowId, busy: false);
      return true;
    } on Object catch (error, stackTrace) {
      // Crashlytics gets it regardless of who is still watching.
      ref
          .read(appLoggerProvider)
          .error(
            'Schedules: $what failed',
            error: error,
            stackTrace: stackTrace,
          );
      state = state.marking(rowId, busy: false).withError('$error');
      return false;
    } finally {
      link.close();
    }
  }
}

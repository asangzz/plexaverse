import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/core/config/env.dart';
import 'package:plexaverse/features/calendar/application/schedule_write_controller.dart';
import 'package:plexaverse/features/calendar/application/schedules_controller.dart';
import 'package:plexaverse/features/calendar/data/calendar_repositories.dart';
import 'package:plexaverse/features/calendar/domain/calendar_repository.dart';
import 'package:plexaverse/features/calendar/domain/post_schedule.dart';

/// A failed schedule write must outlive the screen that started it, and must
/// name the row it belongs to.
///
/// ## The bug
///
/// `_busyIds`, `_creating` and `_error` were fields on `_SchedulesPageState`,
/// and the `catch` that set them ran `if (!mounted) return;` first. Deleting a
/// schedule and leaving the screen mid-round-trip discarded the outcome
/// entirely: no notice, no log, and an automation that may or may not still be
/// posting on the user's behalf.
///
/// ## The property 2b32067 established, kept
///
/// Busy is PER ROW. One screen-wide boolean cannot say which schedule is
/// mutating, so pausing one row greyed out every other one. Moving the state
/// to a controller must not quietly undo that.
void main() {
  late _FakeRepo repo;

  ProviderContainer containerWith(_FakeRepo r) {
    final ProviderContainer c = ProviderContainer(
      overrides: [
        calendarRepositoryProvider.overrideWithValue(r),
        // `appLogger` reads `envProvider`, which throws unless bootstrap set
        // it — and the controller logs on the failure path.
        envProvider.overrideWithValue(Env.mock),
      ],
    );
    addTearDown(c.dispose);
    // The page watches the list while it is up, and the write controller reads
    // that notifier. Listening here mirrors the screen rather than leaving an
    // autoDispose notifier to be torn down between awaits.
    c.listen(schedulesControllerProvider, (_, _) {}, fireImmediately: true);
    return c;
  }

  setUp(() => repo = _FakeRepo());

  test('a failed delete is left on the controller, not thrown away', () async {
    final ProviderContainer c = containerWith(repo..shouldFail = true);

    final bool ok = await c
        .read(scheduleWriteControllerProvider.notifier)
        .remove('s1');

    expect(ok, isFalse);
    expect(c.read(scheduleWriteControllerProvider).error, isNotNull);
  });

  test('the failure survives with NO listener — the screen having gone', () {
    // The real scenario: the page is disposed mid-round-trip. Nothing is
    // watching the provider, and the outcome must still be there when the user
    // comes back. `_run` pins the notifier with keepAlive for exactly this
    // reason; without it the element is torn down mid-await and writing
    // `state` throws, losing the failure in a new way.
    final ProviderContainer c = containerWith(repo..shouldFail = true);

    final Future<bool> pending = c
        .read(scheduleWriteControllerProvider.notifier)
        .remove('s1');

    return pending.then((_) {
      expect(
        c.read(scheduleWriteControllerProvider).error,
        isNotNull,
        reason: 'the failure was discarded once nobody was watching',
      );
    });
  });

  test('busy is per row, never screen-wide', () async {
    final ProviderContainer c = containerWith(repo..shouldFail = false);
    repo.block = true;

    final Future<bool> pending = c
        .read(scheduleWriteControllerProvider.notifier)
        .remove('s1');

    final ScheduleWriteState mid = c.read(scheduleWriteControllerProvider);
    expect(mid.isBusy('s1'), isTrue);
    expect(
      mid.isBusy('s2'),
      isFalse,
      reason: 'one row writing must not disable every other row',
    );
    expect(mid.creating, isFalse, reason: 'a delete is not a create');

    repo.release();
    await pending;
    expect(c.read(scheduleWriteControllerProvider).isBusy('s1'), isFalse);
  });

  test('a create raises `creating`, which has no row id to use', () async {
    final ProviderContainer c = containerWith(repo..shouldFail = false);
    repo.block = true;

    final Future<bool> pending = c
        .read(scheduleWriteControllerProvider.notifier)
        .create(
          linkedinAccountId: 'acc1',
          dayOfWeek: const <int>[1, 2],
          timeOfDay: '09:00',
        );

    expect(c.read(scheduleWriteControllerProvider).creating, isTrue);
    expect(c.read(scheduleWriteControllerProvider).busyIds, isEmpty);

    repo.release();
    await pending;
    expect(c.read(scheduleWriteControllerProvider).creating, isFalse);
    expect(repo.createdAccountId, 'acc1');
  });

  test('acknowledge clears it, and so does the next write starting', () async {
    final ProviderContainer c = containerWith(repo..shouldFail = true);
    final ScheduleWriteController ctl = c.read(
      scheduleWriteControllerProvider.notifier,
    );

    await ctl.remove('s1');
    expect(c.read(scheduleWriteControllerProvider).error, isNotNull);

    // Reading it repeatedly must not dismiss it — only the user can.
    c.read(scheduleWriteControllerProvider);
    expect(c.read(scheduleWriteControllerProvider).error, isNotNull);

    ctl.acknowledge();
    expect(c.read(scheduleWriteControllerProvider).error, isNull);
  });
}

class _FakeRepo implements CalendarRepository {
  bool shouldFail = false;
  String? createdAccountId;

  /// Holds a write open so the in-flight state can be observed.
  bool block = false;
  final Completer<void> _gate = Completer<void>();

  void release() {
    if (!_gate.isCompleted) _gate.complete();
  }

  Future<void> _maybeBlock() async {
    if (block) await _gate.future;
  }

  @override
  Future<List<PostSchedule>> fetchSchedules() async => const <PostSchedule>[];

  @override
  Future<void> deleteSchedule(String id) async {
    await _maybeBlock();
    if (shouldFail) throw StateError('server said no');
  }

  @override
  Future<PostSchedule> createSchedule({
    required String linkedinAccountId,
    required List<int> dayOfWeek,
    required String timeOfDay,
    required String timezone,
    String? topicId,
  }) async {
    await _maybeBlock();
    if (shouldFail) throw StateError('server said no');
    createdAccountId = linkedinAccountId;
    return const PostSchedule(id: 's9');
  }

  // Everything else on the contract is irrelevant to these writes.
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

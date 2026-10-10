import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/core/config/env.dart';
import 'package:plexaverse/features/calendar/application/reschedule_controller.dart';
import 'package:plexaverse/features/calendar/data/calendar_repositories.dart';
import 'package:plexaverse/features/calendar/domain/calendar_month.dart';
import 'package:plexaverse/features/calendar/domain/calendar_post.dart';
import 'package:plexaverse/features/calendar/domain/calendar_repository.dart';

/// A failed reschedule must outlive the screen that started it.
///
/// ## The bug
///
/// `_busy` and `_error` were fields on `_CalendarPageState`, and the catch
/// that set them ran `if (!mounted) return;` FIRST. So a user who backed out
/// of the calendar during the round-trip got a reschedule that failed with no
/// trace anywhere: no banner, no state, no retry. The next poll showed the
/// post sitting on its old day exactly as if nothing had been attempted —
/// and rescheduling is the one action here whose server side re-queues a
/// Cloud Task, so "nothing happened" was a lie about a post that would now go
/// out at the wrong time.
///
/// State about whether a Cloud Task was re-queued cannot live on a screen the
/// user is free to leave.
void main() {
  /// Fails every reschedule; records what it was asked to do.
  late _FakeRepo repo;

  ProviderContainer containerWith(_FakeRepo r) {
    final ProviderContainer c = ProviderContainer(
      overrides: [
        calendarRepositoryProvider.overrideWithValue(r),
        // `appLogger` reads `envProvider`, which throws unless bootstrap set
        // it — and the controller logs on the failure path, which is most of
        // what these tests exercise.
        envProvider.overrideWithValue(Env.mock),
      ],
    );
    addTearDown(c.dispose);
    return c;
  }

  setUp(() => repo = _FakeRepo());

  test('a failure is left on the controller, not thrown away', () async {
    final ProviderContainer c = containerWith(repo..shouldFail = true);

    final bool ok = await c
        .read(rescheduleControllerProvider.notifier)
        .run(postId: 'p1', when: DateTime.utc(2026, 5, 1, 9));

    expect(ok, isFalse);
    expect(c.read(rescheduleControllerProvider).hasError, isTrue);
  });

  test('the failure survives with NO listener — the screen having gone', () {
    // The real scenario: the page is disposed mid-round-trip. Nothing is
    // watching the provider, and the outcome must still be there when the
    // user comes back. `run` pins the notifier with keepAlive for exactly
    // this reason; without it the element is torn down mid-await and writing
    // `state` throws, losing the failure in a new way.
    final ProviderContainer c = containerWith(repo..shouldFail = true);

    // Start it, then never await it from a listener's perspective.
    final Future<bool> pending = c
        .read(rescheduleControllerProvider.notifier)
        .run(postId: 'p1', when: DateTime.utc(2026, 5, 1, 9));

    return pending.then((_) {
      expect(
        c.read(rescheduleControllerProvider).hasError,
        isTrue,
        reason: 'the failure was discarded once nobody was watching',
      );
    });
  });

  test('acknowledge clears it, and nothing else does', () async {
    final ProviderContainer c = containerWith(repo..shouldFail = true);
    final RescheduleController ctl = c.read(
      rescheduleControllerProvider.notifier,
    );

    await ctl.run(postId: 'p1', when: DateTime.utc(2026, 5, 1, 9));
    expect(c.read(rescheduleControllerProvider).hasError, isTrue);

    // Reading it repeatedly must not dismiss it — only the user can.
    c.read(rescheduleControllerProvider);
    expect(c.read(rescheduleControllerProvider).hasError, isTrue);

    ctl.acknowledge();
    expect(c.read(rescheduleControllerProvider).hasError, isFalse);
  });

  test('a success leaves no error behind', () async {
    final ProviderContainer c = containerWith(repo..shouldFail = false);

    final bool ok = await c
        .read(rescheduleControllerProvider.notifier)
        .run(postId: 'p1', when: DateTime.utc(2026, 5, 1, 9));

    expect(ok, isTrue);
    expect(c.read(rescheduleControllerProvider).hasError, isFalse);
    expect(repo.lastPostId, 'p1');
  });
}

class _FakeRepo implements CalendarRepository {
  bool shouldFail = false;
  String? lastPostId;

  @override
  Future<CalendarPost> reschedulePost({
    required String postId,
    required DateTime scheduledFor,
    String? accountId,
  }) async {
    lastPostId = postId;
    if (shouldFail) throw StateError('server said no');
    return const CalendarPost(id: 'p1');
  }

  @override
  Future<CalendarBuckets> fetchBuckets({DateTime? from, DateTime? to}) async =>
      const CalendarBuckets();

  // Everything else on the contract is irrelevant to a reschedule.
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

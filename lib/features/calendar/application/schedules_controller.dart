import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/calendar_repositories.dart';
import '../domain/post_schedule.dart';

part 'schedules_controller.g.dart';

/// The recurring auto-post schedules — the `/schedules` screen's data.
///
/// The web page is read-only: it lists schedules and opens a create modal, and
/// nothing on it can pause or delete a row. The mobile API exposes
/// `PATCH /schedules/{id}` and `DELETE /schedules/{id}`, and a phone with no way
/// to stop an automation that is posting on the user's behalf is worse than a
/// desktop with the same gap, so [setActive] and [remove] exist here. That is a
/// deliberate addition, not a port.
@riverpod
class SchedulesController extends _$SchedulesController {
  @override
  Future<List<PostSchedule>> build() =>
      ref.watch(calendarRepositoryProvider).fetchSchedules();

  Future<void> create({
    required String linkedinAccountId,
    required List<int> dayOfWeek,
    required String timeOfDay,
    String? topicId,
    String timezone = kDefaultScheduleTimezone,
  }) async {
    await ref
        .read(calendarRepositoryProvider)
        .createSchedule(
          linkedinAccountId: linkedinAccountId,
          dayOfWeek: dayOfWeek,
          timeOfDay: timeOfDay,
          timezone: timezone,
          topicId: topicId,
        );
    ref.invalidateSelf();
    await future;
  }

  /// Pause or resume a schedule.
  ///
  /// Optimistic: the switch is the whole control, and a switch that does not
  /// move until a round-trip completes reads as broken. The server's answer
  /// replaces the guess, and a failure puts the truth back.
  Future<void> setActive(String id, {required bool isActive}) async {
    final List<PostSchedule>? current = state.value;
    if (current == null) return;

    state = AsyncData<List<PostSchedule>>(<PostSchedule>[
      for (final PostSchedule s in current)
        if (s.id == id) s.copyWith(isActive: isActive) else s,
    ]);

    try {
      await ref
          .read(calendarRepositoryProvider)
          .updateSchedule(id: id, isActive: isActive);
      ref.invalidateSelf();
      await future;
    } on Object {
      ref.invalidateSelf();
    }
  }

  Future<void> remove(String id) async {
    await ref.read(calendarRepositoryProvider).deleteSchedule(id);
    ref.invalidateSelf();
    await future;
  }
}

/// The server's own default zone (`schedules.service.ts`). Sent explicitly so a
/// schedule created on mobile and one created on the web land in the same zone
/// even if that default later changes on one side.
const String kDefaultScheduleTimezone = 'Asia/Kolkata';

/// The connected LinkedIn accounts — the create-schedule form's required field.
///
/// The web's own `/schedules` page hard-codes `const accounts = []`, which is
/// why its "Add Schedule" button is permanently disabled and its yellow
/// "LinkedIn account required" notice always renders. That is a bug on the web,
/// not a design, so this screen reads the real list instead and the notice
/// appears only when the user genuinely has no account connected.
@riverpod
Future<List<CalendarAccount>> scheduleAccounts(Ref ref) =>
    ref.watch(calendarRepositoryProvider).fetchAccounts();

/// The user's topics — the create-schedule form's optional field.
@riverpod
Future<List<ScheduleTopic>> scheduleTopics(Ref ref) =>
    ref.watch(calendarRepositoryProvider).fetchTopics();

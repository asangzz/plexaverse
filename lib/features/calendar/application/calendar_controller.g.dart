// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendar_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The calendar's posts, already split into the grid bucket and the pending
/// backlog.
///
/// ## Why the split happens here and not on the server
///
/// The web's `/api/calendar/posts` returns `{scheduled, pending}` ready-made.
/// The mobile API has no such route — only `GET /posts` — so this controller
/// fetches the flat list and applies the server's own bucketing rule through
/// `splitCalendarBuckets`. The rule lives in the domain layer precisely so it
/// can be checked against `lib/services/calendar.service.ts` without reading a
/// widget.

@ProviderFor(CalendarController)
final calendarControllerProvider = CalendarControllerProvider._();

/// The calendar's posts, already split into the grid bucket and the pending
/// backlog.
///
/// ## Why the split happens here and not on the server
///
/// The web's `/api/calendar/posts` returns `{scheduled, pending}` ready-made.
/// The mobile API has no such route — only `GET /posts` — so this controller
/// fetches the flat list and applies the server's own bucketing rule through
/// `splitCalendarBuckets`. The rule lives in the domain layer precisely so it
/// can be checked against `lib/services/calendar.service.ts` without reading a
/// widget.
final class CalendarControllerProvider
    extends $AsyncNotifierProvider<CalendarController, CalendarBuckets> {
  /// The calendar's posts, already split into the grid bucket and the pending
  /// backlog.
  ///
  /// ## Why the split happens here and not on the server
  ///
  /// The web's `/api/calendar/posts` returns `{scheduled, pending}` ready-made.
  /// The mobile API has no such route — only `GET /posts` — so this controller
  /// fetches the flat list and applies the server's own bucketing rule through
  /// `splitCalendarBuckets`. The rule lives in the domain layer precisely so it
  /// can be checked against `lib/services/calendar.service.ts` without reading a
  /// widget.
  CalendarControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'calendarControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$calendarControllerHash();

  @$internal
  @override
  CalendarController create() => CalendarController();
}

String _$calendarControllerHash() =>
    r'56051d6cd36e399b8ff56d0138291464738435e3';

/// The calendar's posts, already split into the grid bucket and the pending
/// backlog.
///
/// ## Why the split happens here and not on the server
///
/// The web's `/api/calendar/posts` returns `{scheduled, pending}` ready-made.
/// The mobile API has no such route — only `GET /posts` — so this controller
/// fetches the flat list and applies the server's own bucketing rule through
/// `splitCalendarBuckets`. The rule lives in the domain layer precisely so it
/// can be checked against `lib/services/calendar.service.ts` without reading a
/// widget.

abstract class _$CalendarController extends $AsyncNotifier<CalendarBuckets> {
  FutureOr<CalendarBuckets> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<CalendarBuckets>, CalendarBuckets>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<CalendarBuckets>, CalendarBuckets>,
              AsyncValue<CalendarBuckets>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

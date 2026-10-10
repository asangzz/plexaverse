// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reschedule_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
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

@ProviderFor(RescheduleController)
final rescheduleControllerProvider = RescheduleControllerProvider._();

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
final class RescheduleControllerProvider
    extends $NotifierProvider<RescheduleController, AsyncValue<void>> {
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
  RescheduleControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'rescheduleControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$rescheduleControllerHash();

  @$internal
  @override
  RescheduleController create() => RescheduleController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<void>>(value),
    );
  }
}

String _$rescheduleControllerHash() =>
    r'c495d11cd102c2f855a833314289ce7988024858';

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

abstract class _$RescheduleController extends $Notifier<AsyncValue<void>> {
  AsyncValue<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, AsyncValue<void>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, AsyncValue<void>>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

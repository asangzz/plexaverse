// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_write_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
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

@ProviderFor(ScheduleWriteController)
final scheduleWriteControllerProvider = ScheduleWriteControllerProvider._();

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
final class ScheduleWriteControllerProvider
    extends $NotifierProvider<ScheduleWriteController, ScheduleWriteState> {
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
  ScheduleWriteControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'scheduleWriteControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$scheduleWriteControllerHash();

  @$internal
  @override
  ScheduleWriteController create() => ScheduleWriteController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ScheduleWriteState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ScheduleWriteState>(value),
    );
  }
}

String _$scheduleWriteControllerHash() =>
    r'027199eef425374ef40fd4ecb1d2fe7f4760d945';

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

abstract class _$ScheduleWriteController extends $Notifier<ScheduleWriteState> {
  ScheduleWriteState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<ScheduleWriteState, ScheduleWriteState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ScheduleWriteState, ScheduleWriteState>,
              ScheduleWriteState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

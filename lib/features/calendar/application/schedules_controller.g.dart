// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedules_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The recurring auto-post schedules — the `/schedules` screen's data.
///
/// The web page is read-only: it lists schedules and opens a create modal, and
/// nothing on it can pause or delete a row. The mobile API exposes
/// `PATCH /schedules/{id}` and `DELETE /schedules/{id}`, and a phone with no way
/// to stop an automation that is posting on the user's behalf is worse than a
/// desktop with the same gap, so [setActive] and [remove] exist here. That is a
/// deliberate addition, not a port.

@ProviderFor(SchedulesController)
final schedulesControllerProvider = SchedulesControllerProvider._();

/// The recurring auto-post schedules — the `/schedules` screen's data.
///
/// The web page is read-only: it lists schedules and opens a create modal, and
/// nothing on it can pause or delete a row. The mobile API exposes
/// `PATCH /schedules/{id}` and `DELETE /schedules/{id}`, and a phone with no way
/// to stop an automation that is posting on the user's behalf is worse than a
/// desktop with the same gap, so [setActive] and [remove] exist here. That is a
/// deliberate addition, not a port.
final class SchedulesControllerProvider
    extends $AsyncNotifierProvider<SchedulesController, List<PostSchedule>> {
  /// The recurring auto-post schedules — the `/schedules` screen's data.
  ///
  /// The web page is read-only: it lists schedules and opens a create modal, and
  /// nothing on it can pause or delete a row. The mobile API exposes
  /// `PATCH /schedules/{id}` and `DELETE /schedules/{id}`, and a phone with no way
  /// to stop an automation that is posting on the user's behalf is worse than a
  /// desktop with the same gap, so [setActive] and [remove] exist here. That is a
  /// deliberate addition, not a port.
  SchedulesControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'schedulesControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$schedulesControllerHash();

  @$internal
  @override
  SchedulesController create() => SchedulesController();
}

String _$schedulesControllerHash() =>
    r'0803081b58bcb57705fbbf160de32903050beefb';

/// The recurring auto-post schedules — the `/schedules` screen's data.
///
/// The web page is read-only: it lists schedules and opens a create modal, and
/// nothing on it can pause or delete a row. The mobile API exposes
/// `PATCH /schedules/{id}` and `DELETE /schedules/{id}`, and a phone with no way
/// to stop an automation that is posting on the user's behalf is worse than a
/// desktop with the same gap, so [setActive] and [remove] exist here. That is a
/// deliberate addition, not a port.

abstract class _$SchedulesController
    extends $AsyncNotifier<List<PostSchedule>> {
  FutureOr<List<PostSchedule>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<PostSchedule>>, List<PostSchedule>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<PostSchedule>>, List<PostSchedule>>,
              AsyncValue<List<PostSchedule>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// The connected LinkedIn accounts — the create-schedule form's required field.
///
/// The web's own `/schedules` page hard-codes `const accounts = []`, which is
/// why its "Add Schedule" button is permanently disabled and its yellow
/// "LinkedIn account required" notice always renders. That is a bug on the web,
/// not a design, so this screen reads the real list instead and the notice
/// appears only when the user genuinely has no account connected.

@ProviderFor(scheduleAccounts)
final scheduleAccountsProvider = ScheduleAccountsProvider._();

/// The connected LinkedIn accounts — the create-schedule form's required field.
///
/// The web's own `/schedules` page hard-codes `const accounts = []`, which is
/// why its "Add Schedule" button is permanently disabled and its yellow
/// "LinkedIn account required" notice always renders. That is a bug on the web,
/// not a design, so this screen reads the real list instead and the notice
/// appears only when the user genuinely has no account connected.

final class ScheduleAccountsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<CalendarAccount>>,
          List<CalendarAccount>,
          FutureOr<List<CalendarAccount>>
        >
    with
        $FutureModifier<List<CalendarAccount>>,
        $FutureProvider<List<CalendarAccount>> {
  /// The connected LinkedIn accounts — the create-schedule form's required field.
  ///
  /// The web's own `/schedules` page hard-codes `const accounts = []`, which is
  /// why its "Add Schedule" button is permanently disabled and its yellow
  /// "LinkedIn account required" notice always renders. That is a bug on the web,
  /// not a design, so this screen reads the real list instead and the notice
  /// appears only when the user genuinely has no account connected.
  ScheduleAccountsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'scheduleAccountsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$scheduleAccountsHash();

  @$internal
  @override
  $FutureProviderElement<List<CalendarAccount>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<CalendarAccount>> create(Ref ref) {
    return scheduleAccounts(ref);
  }
}

String _$scheduleAccountsHash() => r'336e9e9a97fd9d5d8323524a66f85473e775e50e';

/// The user's topics — the create-schedule form's optional field.

@ProviderFor(scheduleTopics)
final scheduleTopicsProvider = ScheduleTopicsProvider._();

/// The user's topics — the create-schedule form's optional field.

final class ScheduleTopicsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ScheduleTopic>>,
          List<ScheduleTopic>,
          FutureOr<List<ScheduleTopic>>
        >
    with
        $FutureModifier<List<ScheduleTopic>>,
        $FutureProvider<List<ScheduleTopic>> {
  /// The user's topics — the create-schedule form's optional field.
  ScheduleTopicsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'scheduleTopicsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$scheduleTopicsHash();

  @$internal
  @override
  $FutureProviderElement<List<ScheduleTopic>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ScheduleTopic>> create(Ref ref) {
    return scheduleTopics(ref);
  }
}

String _$scheduleTopicsHash() => r'03892fb339d36e84165af411c9550830fdf0e374';

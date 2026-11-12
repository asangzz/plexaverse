// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plan_week_controllers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// `GET /contest/tasks/plan` — this planner week, day by day.
///
/// Always a view, even with no contest: why the level is unavailable or
/// locked rides on it. Re-read on every open (auto-dispose), as the web's
/// `refetchOnMount` — the learner goes to the Planner and comes back
/// expecting what they just did there.

@ProviderFor(contestPlanWeek)
final contestPlanWeekProvider = ContestPlanWeekProvider._();

/// `GET /contest/tasks/plan` — this planner week, day by day.
///
/// Always a view, even with no contest: why the level is unavailable or
/// locked rides on it. Re-read on every open (auto-dispose), as the web's
/// `refetchOnMount` — the learner goes to the Planner and comes back
/// expecting what they just did there.

final class ContestPlanWeekProvider
    extends
        $FunctionalProvider<
          AsyncValue<PlanWeekView>,
          PlanWeekView,
          FutureOr<PlanWeekView>
        >
    with $FutureModifier<PlanWeekView>, $FutureProvider<PlanWeekView> {
  /// `GET /contest/tasks/plan` — this planner week, day by day.
  ///
  /// Always a view, even with no contest: why the level is unavailable or
  /// locked rides on it. Re-read on every open (auto-dispose), as the web's
  /// `refetchOnMount` — the learner goes to the Planner and comes back
  /// expecting what they just did there.
  ContestPlanWeekProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'contestPlanWeekProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$contestPlanWeekHash();

  @$internal
  @override
  $FutureProviderElement<PlanWeekView> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<PlanWeekView> create(Ref ref) {
    return contestPlanWeek(ref);
  }
}

String _$contestPlanWeekHash() => r'1cde05a683ca3e2cfa3d35643a68adcd82ea593c';

/// `POST /contest/tasks/plan` — "I've planned this week".

@ProviderFor(PlanWeekActions)
final planWeekActionsProvider = PlanWeekActionsProvider._();

/// `POST /contest/tasks/plan` — "I've planned this week".
final class PlanWeekActionsProvider
    extends $NotifierProvider<PlanWeekActions, PlanWeekMark> {
  /// `POST /contest/tasks/plan` — "I've planned this week".
  PlanWeekActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'planWeekActionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$planWeekActionsHash();

  @$internal
  @override
  PlanWeekActions create() => PlanWeekActions();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PlanWeekMark value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PlanWeekMark>(value),
    );
  }
}

String _$planWeekActionsHash() => r'6061435a7c87403db09c95cc1baff1fa505e44d8';

/// `POST /contest/tasks/plan` — "I've planned this week".

abstract class _$PlanWeekActions extends $Notifier<PlanWeekMark> {
  PlanWeekMark build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<PlanWeekMark, PlanWeekMark>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PlanWeekMark, PlanWeekMark>,
              PlanWeekMark,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

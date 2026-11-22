// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'billing_state_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// `GET /user/billing-state` — the State on record, and what the picker
/// starts on. Its own provider so an unreadable read hides the Settings row
/// only; the payment paths read fresh through [PlanCheckout].

@ProviderFor(billingState)
final billingStateProvider = BillingStateProvider._();

/// `GET /user/billing-state` — the State on record, and what the picker
/// starts on. Its own provider so an unreadable read hides the Settings row
/// only; the payment paths read fresh through [PlanCheckout].

final class BillingStateProvider
    extends
        $FunctionalProvider<
          AsyncValue<BillingState>,
          BillingState,
          FutureOr<BillingState>
        >
    with $FutureModifier<BillingState>, $FutureProvider<BillingState> {
  /// `GET /user/billing-state` — the State on record, and what the picker
  /// starts on. Its own provider so an unreadable read hides the Settings row
  /// only; the payment paths read fresh through [PlanCheckout].
  BillingStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'billingStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$billingStateHash();

  @$internal
  @override
  $FutureProviderElement<BillingState> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<BillingState> create(Ref ref) {
    return billingState(ref);
  }
}

String _$billingStateHash() => r'484fc09ac35045f3e5c71fef8717885a84761820';

/// Saving the buyer's State from one place ([BillingStateSource]): the
/// in-flight flag and the failure live here, never on the picker, so a
/// rebuilt or disposed picker cannot lose either. Null before any save.

@ProviderFor(BillingStateSave)
final billingStateSaveProvider = BillingStateSaveFamily._();

/// Saving the buyer's State from one place ([BillingStateSource]): the
/// in-flight flag and the failure live here, never on the picker, so a
/// rebuilt or disposed picker cannot lose either. Null before any save.
final class BillingStateSaveProvider
    extends $AsyncNotifierProvider<BillingStateSave, SavedBillingState?> {
  /// Saving the buyer's State from one place ([BillingStateSource]): the
  /// in-flight flag and the failure live here, never on the picker, so a
  /// rebuilt or disposed picker cannot lose either. Null before any save.
  BillingStateSaveProvider._({
    required BillingStateSaveFamily super.from,
    required BillingStateSource super.argument,
  }) : super(
         retry: null,
         name: r'billingStateSaveProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$billingStateSaveHash();

  @override
  String toString() {
    return r'billingStateSaveProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  BillingStateSave create() => BillingStateSave();

  @override
  bool operator ==(Object other) {
    return other is BillingStateSaveProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$billingStateSaveHash() => r'ec45c303bf297557f9c7d61ba5a05e24b04c5198';

/// Saving the buyer's State from one place ([BillingStateSource]): the
/// in-flight flag and the failure live here, never on the picker, so a
/// rebuilt or disposed picker cannot lose either. Null before any save.

final class BillingStateSaveFamily extends $Family
    with
        $ClassFamilyOverride<
          BillingStateSave,
          AsyncValue<SavedBillingState?>,
          SavedBillingState?,
          FutureOr<SavedBillingState?>,
          BillingStateSource
        > {
  BillingStateSaveFamily._()
    : super(
        retry: null,
        name: r'billingStateSaveProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Saving the buyer's State from one place ([BillingStateSource]): the
  /// in-flight flag and the failure live here, never on the picker, so a
  /// rebuilt or disposed picker cannot lose either. Null before any save.

  BillingStateSaveProvider call(BillingStateSource source) =>
      BillingStateSaveProvider._(argument: source, from: this);

  @override
  String toString() => r'billingStateSaveProvider';
}

/// Saving the buyer's State from one place ([BillingStateSource]): the
/// in-flight flag and the failure live here, never on the picker, so a
/// rebuilt or disposed picker cannot lose either. Null before any save.

abstract class _$BillingStateSave extends $AsyncNotifier<SavedBillingState?> {
  late final _$args = ref.$arg as BillingStateSource;
  BillingStateSource get source => _$args;

  FutureOr<SavedBillingState?> build(BillingStateSource source);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<SavedBillingState?>, SavedBillingState?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<SavedBillingState?>, SavedBillingState?>,
              AsyncValue<SavedBillingState?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}

/// Which payment control is waiting on the State — the web's
/// `useBillingStateGate().askingFor`. Set when a checkout answered
/// [PlanCheckoutStateNeeded]; cleared by a save (the caller then runs the
/// same checkout again) or a cancel (the payment is dropped, not the page).

@ProviderFor(BillingStateAsk)
final billingStateAskProvider = BillingStateAskProvider._();

/// Which payment control is waiting on the State — the web's
/// `useBillingStateGate().askingFor`. Set when a checkout answered
/// [PlanCheckoutStateNeeded]; cleared by a save (the caller then runs the
/// same checkout again) or a cancel (the payment is dropped, not the page).
final class BillingStateAskProvider
    extends $NotifierProvider<BillingStateAsk, String?> {
  /// Which payment control is waiting on the State — the web's
  /// `useBillingStateGate().askingFor`. Set when a checkout answered
  /// [PlanCheckoutStateNeeded]; cleared by a save (the caller then runs the
  /// same checkout again) or a cancel (the payment is dropped, not the page).
  BillingStateAskProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'billingStateAskProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$billingStateAskHash();

  @$internal
  @override
  BillingStateAsk create() => BillingStateAsk();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$billingStateAskHash() => r'5c684f2c0fbe6ae38605a29013f4e058800f41d4';

/// Which payment control is waiting on the State — the web's
/// `useBillingStateGate().askingFor`. Set when a checkout answered
/// [PlanCheckoutStateNeeded]; cleared by a save (the caller then runs the
/// same checkout again) or a cancel (the payment is dropped, not the page).

abstract class _$BillingStateAsk extends $Notifier<String?> {
  String? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String?, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String?, String?>,
              String?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

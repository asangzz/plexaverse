// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pricing_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Localised plan prices.
///
/// The country comes from the device locale. The mobile route accepts
/// `?country=` precisely so the client can answer that itself; the web's
/// IP-based chain is not reproduced because an IP guess on a phone is wrong as
/// often as it is right.

@ProviderFor(planPricing)
final planPricingProvider = PlanPricingProvider._();

/// Localised plan prices.
///
/// The country comes from the device locale. The mobile route accepts
/// `?country=` precisely so the client can answer that itself; the web's
/// IP-based chain is not reproduced because an IP guess on a phone is wrong as
/// often as it is right.

final class PlanPricingProvider
    extends
        $FunctionalProvider<
          AsyncValue<PlanPricing>,
          PlanPricing,
          FutureOr<PlanPricing>
        >
    with $FutureModifier<PlanPricing>, $FutureProvider<PlanPricing> {
  /// Localised plan prices.
  ///
  /// The country comes from the device locale. The mobile route accepts
  /// `?country=` precisely so the client can answer that itself; the web's
  /// IP-based chain is not reproduced because an IP guess on a phone is wrong as
  /// often as it is right.
  PlanPricingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'planPricingProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$planPricingHash();

  @$internal
  @override
  $FutureProviderElement<PlanPricing> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<PlanPricing> create(Ref ref) {
    return planPricing(ref);
  }
}

String _$planPricingHash() => r'404dedc26b8c5ef058e37a2b4403d1e2f1b1df62';

/// Which plans this account may buy.
///
/// Its own provider rather than a field on [planPricing] so a slow or failed
/// preferences read delays the GATE, not the prices. Null while loading and
/// null on failure both mean "show everything", which is the web's own
/// behaviour before `brandType` arrives.

@ProviderFor(pricingBrandType)
final pricingBrandTypeProvider = PricingBrandTypeProvider._();

/// Which plans this account may buy.
///
/// Its own provider rather than a field on [planPricing] so a slow or failed
/// preferences read delays the GATE, not the prices. Null while loading and
/// null on failure both mean "show everything", which is the web's own
/// behaviour before `brandType` arrives.

final class PricingBrandTypeProvider
    extends $FunctionalProvider<AsyncValue<String?>, String?, FutureOr<String?>>
    with $FutureModifier<String?>, $FutureProvider<String?> {
  /// Which plans this account may buy.
  ///
  /// Its own provider rather than a field on [planPricing] so a slow or failed
  /// preferences read delays the GATE, not the prices. Null while loading and
  /// null on failure both mean "show everything", which is the web's own
  /// behaviour before `brandType` arrives.
  PricingBrandTypeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pricingBrandTypeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pricingBrandTypeHash();

  @$internal
  @override
  $FutureProviderElement<String?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String?> create(Ref ref) {
    return pricingBrandType(ref);
  }
}

String _$pricingBrandTypeHash() => r'b8f1d113fbee8a7160eb8d03653ffe15a8278d10';

/// What every plan includes, per AI feature.
///
/// Never errors: a failed read falls back to [AllowanceTable.fallback], the
/// static list that mirrors the web's defaults. The block exists to say what a
/// plan buys, and a user deciding whether to pay should not see that sentence
/// replaced by a retry button. An empty live answer falls back too — a plan
/// that includes nothing is never the truth.

@ProviderFor(planAllowances)
final planAllowancesProvider = PlanAllowancesProvider._();

/// What every plan includes, per AI feature.
///
/// Never errors: a failed read falls back to [AllowanceTable.fallback], the
/// static list that mirrors the web's defaults. The block exists to say what a
/// plan buys, and a user deciding whether to pay should not see that sentence
/// replaced by a retry button. An empty live answer falls back too — a plan
/// that includes nothing is never the truth.

final class PlanAllowancesProvider
    extends
        $FunctionalProvider<
          AsyncValue<AllowanceTable>,
          AllowanceTable,
          FutureOr<AllowanceTable>
        >
    with $FutureModifier<AllowanceTable>, $FutureProvider<AllowanceTable> {
  /// What every plan includes, per AI feature.
  ///
  /// Never errors: a failed read falls back to [AllowanceTable.fallback], the
  /// static list that mirrors the web's defaults. The block exists to say what a
  /// plan buys, and a user deciding whether to pay should not see that sentence
  /// replaced by a retry button. An empty live answer falls back too — a plan
  /// that includes nothing is never the truth.
  PlanAllowancesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'planAllowancesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$planAllowancesHash();

  @$internal
  @override
  $FutureProviderElement<AllowanceTable> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<AllowanceTable> create(Ref ref) {
    return planAllowances(ref);
  }
}

String _$planAllowancesHash() => r'7b62d894107c49c1f9f36471e9d259684e995b7f';

/// The referral code and its lifetime counters.

@ProviderFor(ReferralController)
final referralControllerProvider = ReferralControllerProvider._();

/// The referral code and its lifetime counters.
final class ReferralControllerProvider
    extends $AsyncNotifierProvider<ReferralController, ReferralSummary> {
  /// The referral code and its lifetime counters.
  ReferralControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'referralControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$referralControllerHash();

  @$internal
  @override
  ReferralController create() => ReferralController();
}

String _$referralControllerHash() =>
    r'07d5589d292bac67cefa971ea86feb2ce5a5410e';

/// The referral code and its lifetime counters.

abstract class _$ReferralController extends $AsyncNotifier<ReferralSummary> {
  FutureOr<ReferralSummary> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<ReferralSummary>, ReferralSummary>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ReferralSummary>, ReferralSummary>,
              AsyncValue<ReferralSummary>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Buying a plan from the Pricing screen.
///
/// The create → sheet → verify sequence is [PlanCheckout]'s, shared with the
/// onboarding plan step; this only turns its outcome into the screen's
/// message and refreshes what a new plan changes.

@ProviderFor(CheckoutController)
final checkoutControllerProvider = CheckoutControllerProvider._();

/// Buying a plan from the Pricing screen.
///
/// The create → sheet → verify sequence is [PlanCheckout]'s, shared with the
/// onboarding plan step; this only turns its outcome into the screen's
/// message and refreshes what a new plan changes.
final class CheckoutControllerProvider
    extends $NotifierProvider<CheckoutController, void> {
  /// Buying a plan from the Pricing screen.
  ///
  /// The create → sheet → verify sequence is [PlanCheckout]'s, shared with the
  /// onboarding plan step; this only turns its outcome into the screen's
  /// message and refreshes what a new plan changes.
  CheckoutControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'checkoutControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$checkoutControllerHash();

  @$internal
  @override
  CheckoutController create() => CheckoutController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$checkoutControllerHash() =>
    r'ec7528f9afb88d5d79111d48411e09d7e24e4b2a';

/// Buying a plan from the Pricing screen.
///
/// The create → sheet → verify sequence is [PlanCheckout]'s, shared with the
/// onboarding plan step; this only turns its outcome into the screen's
/// message and refreshes what a new plan changes.

abstract class _$CheckoutController extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

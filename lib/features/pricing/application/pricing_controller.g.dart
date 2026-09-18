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

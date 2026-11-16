// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plan_checkout.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(planCheckout)
final planCheckoutProvider = PlanCheckoutProvider._();

final class PlanCheckoutProvider
    extends $FunctionalProvider<PlanCheckout, PlanCheckout, PlanCheckout>
    with $Provider<PlanCheckout> {
  PlanCheckoutProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'planCheckoutProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$planCheckoutHash();

  @$internal
  @override
  $ProviderElement<PlanCheckout> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PlanCheckout create(Ref ref) {
    return planCheckout(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PlanCheckout value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PlanCheckout>(value),
    );
  }
}

String _$planCheckoutHash() => r'1a9bb17dc8d24590a11a762bf601d3a4e3a8661e';

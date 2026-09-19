// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkout.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(checkout)
final checkoutProvider = CheckoutProvider._();

final class CheckoutProvider
    extends
        $FunctionalProvider<CheckoutService, CheckoutService, CheckoutService>
    with $Provider<CheckoutService> {
  CheckoutProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'checkoutProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$checkoutHash();

  @$internal
  @override
  $ProviderElement<CheckoutService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CheckoutService create(Ref ref) {
    return checkout(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CheckoutService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CheckoutService>(value),
    );
  }
}

String _$checkoutHash() => r'e9ad2649259351f4ecc5b79608c56555c5db5dd9';

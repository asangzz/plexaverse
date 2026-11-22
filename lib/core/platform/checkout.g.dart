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

String _$checkoutHash() => r'cb92d9711b6f6b946044d7bf3c60f7e675f335ac';

@ProviderFor(upiAppProbe)
final upiAppProbeProvider = UpiAppProbeProvider._();

final class UpiAppProbeProvider
    extends $FunctionalProvider<UpiAppProbe, UpiAppProbe, UpiAppProbe>
    with $Provider<UpiAppProbe> {
  UpiAppProbeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'upiAppProbeProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$upiAppProbeHash();

  @$internal
  @override
  $ProviderElement<UpiAppProbe> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  UpiAppProbe create(Ref ref) {
    return upiAppProbe(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UpiAppProbe value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UpiAppProbe>(value),
    );
  }
}

String _$upiAppProbeHash() => r'1f2f4fb77e14ff95d078afdf151e544e5987b673';

/// [canRegisterUpiAutopay] for a screen to watch.

@ProviderFor(upiAutopayOnDevice)
final upiAutopayOnDeviceProvider = UpiAutopayOnDeviceProvider._();

/// [canRegisterUpiAutopay] for a screen to watch.

final class UpiAutopayOnDeviceProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  /// [canRegisterUpiAutopay] for a screen to watch.
  UpiAutopayOnDeviceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'upiAutopayOnDeviceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$upiAutopayOnDeviceHash();

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    return upiAutopayOnDevice(ref);
  }
}

String _$upiAutopayOnDeviceHash() =>
    r'e6a612613aa7d1e760c4a4e3f56b7bcb711f0d46';

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offline_gate_interceptor.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(offlineGateInterceptor)
final offlineGateInterceptorProvider = OfflineGateInterceptorProvider._();

final class OfflineGateInterceptorProvider
    extends
        $FunctionalProvider<
          OfflineGateInterceptor,
          OfflineGateInterceptor,
          OfflineGateInterceptor
        >
    with $Provider<OfflineGateInterceptor> {
  OfflineGateInterceptorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'offlineGateInterceptorProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$offlineGateInterceptorHash();

  @$internal
  @override
  $ProviderElement<OfflineGateInterceptor> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  OfflineGateInterceptor create(Ref ref) {
    return offlineGateInterceptor(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OfflineGateInterceptor value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OfflineGateInterceptor>(value),
    );
  }
}

String _$offlineGateInterceptorHash() =>
    r'813897070ecda3e3f07fcce69a3f9ccaa2840935';

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connectivity_listener.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(connectivityListener)
final connectivityListenerProvider = ConnectivityListenerProvider._();

final class ConnectivityListenerProvider
    extends
        $FunctionalProvider<
          ConnectivityListener,
          ConnectivityListener,
          ConnectivityListener
        >
    with $Provider<ConnectivityListener> {
  ConnectivityListenerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'connectivityListenerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$connectivityListenerHash();

  @$internal
  @override
  $ProviderElement<ConnectivityListener> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ConnectivityListener create(Ref ref) {
    return connectivityListener(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ConnectivityListener value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ConnectivityListener>(value),
    );
  }
}

String _$connectivityListenerHash() =>
    r'18e491180d8ded36c9dbf8954c6740f3fe8d2673';

@ProviderFor(connectivityStream)
final connectivityStreamProvider = ConnectivityStreamProvider._();

final class ConnectivityStreamProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, Stream<bool>>
    with $FutureModifier<bool>, $StreamProvider<bool> {
  ConnectivityStreamProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'connectivityStreamProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$connectivityStreamHash();

  @$internal
  @override
  $StreamProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<bool> create(Ref ref) {
    return connectivityStream(ref);
  }
}

String _$connectivityStreamHash() =>
    r'0450d7e6348960359c90691a3c220ce1447e8b95';

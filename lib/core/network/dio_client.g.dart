// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dio_client.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Base URL is env-derived ([apiBaseUrl]) so dev/stage/live is config-only.
/// Only materialised when a real (non-mock) repository is resolved, i.e.
/// when `useFakeBackend` is false.

@ProviderFor(dioClient)
final dioClientProvider = DioClientProvider._();

/// Base URL is env-derived ([apiBaseUrl]) so dev/stage/live is config-only.
/// Only materialised when a real (non-mock) repository is resolved, i.e.
/// when `useFakeBackend` is false.

final class DioClientProvider
    extends $FunctionalProvider<DioClient, DioClient, DioClient>
    with $Provider<DioClient> {
  /// Base URL is env-derived ([apiBaseUrl]) so dev/stage/live is config-only.
  /// Only materialised when a real (non-mock) repository is resolved, i.e.
  /// when `useFakeBackend` is false.
  DioClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dioClientProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dioClientHash();

  @$internal
  @override
  $ProviderElement<DioClient> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DioClient create(Ref ref) {
    return dioClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DioClient value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DioClient>(value),
    );
  }
}

String _$dioClientHash() => r'e8cc85ecd301c61285bd09790ea94763bce19bee';

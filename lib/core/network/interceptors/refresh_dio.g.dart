// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'refresh_dio.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Near-bare Dio used solely for the refresh call AND for retrying the
/// original request after a successful refresh. Lives outside the main
/// interceptor chain so the refresh request doesn't recurse into
/// [AuthInterceptor] on a 401 from refresh itself. It does carry the
/// offline gate, though — the app is online-first, and a token refresh
/// attempted while definitively offline should fast-fail like every other
/// call instead of burning the connect timeout (no recursion risk: the
/// gate never re-enters the auth chain).
///
/// DEVIATION FROM PROHEALTH: ProHealth is multi-tenant and derives the
/// refresh base URL from a `RefreshBaseUrl` notifier set at bootstrap once
/// the tenant resolves (to avoid a tenant→dio→auth→tenant provider cycle).
/// Plexaverse is single-brand with an ENV-derived base URL
/// ([apiBaseUrlProvider]) and no tenant→network cycle, so the refresh Dio
/// simply reads the same env-derived base URL directly. No notifier to wire
/// at bootstrap, and no `StateError` on early read.

@ProviderFor(refreshDio)
final refreshDioProvider = RefreshDioProvider._();

/// Near-bare Dio used solely for the refresh call AND for retrying the
/// original request after a successful refresh. Lives outside the main
/// interceptor chain so the refresh request doesn't recurse into
/// [AuthInterceptor] on a 401 from refresh itself. It does carry the
/// offline gate, though — the app is online-first, and a token refresh
/// attempted while definitively offline should fast-fail like every other
/// call instead of burning the connect timeout (no recursion risk: the
/// gate never re-enters the auth chain).
///
/// DEVIATION FROM PROHEALTH: ProHealth is multi-tenant and derives the
/// refresh base URL from a `RefreshBaseUrl` notifier set at bootstrap once
/// the tenant resolves (to avoid a tenant→dio→auth→tenant provider cycle).
/// Plexaverse is single-brand with an ENV-derived base URL
/// ([apiBaseUrlProvider]) and no tenant→network cycle, so the refresh Dio
/// simply reads the same env-derived base URL directly. No notifier to wire
/// at bootstrap, and no `StateError` on early read.

final class RefreshDioProvider extends $FunctionalProvider<Dio, Dio, Dio>
    with $Provider<Dio> {
  /// Near-bare Dio used solely for the refresh call AND for retrying the
  /// original request after a successful refresh. Lives outside the main
  /// interceptor chain so the refresh request doesn't recurse into
  /// [AuthInterceptor] on a 401 from refresh itself. It does carry the
  /// offline gate, though — the app is online-first, and a token refresh
  /// attempted while definitively offline should fast-fail like every other
  /// call instead of burning the connect timeout (no recursion risk: the
  /// gate never re-enters the auth chain).
  ///
  /// DEVIATION FROM PROHEALTH: ProHealth is multi-tenant and derives the
  /// refresh base URL from a `RefreshBaseUrl` notifier set at bootstrap once
  /// the tenant resolves (to avoid a tenant→dio→auth→tenant provider cycle).
  /// Plexaverse is single-brand with an ENV-derived base URL
  /// ([apiBaseUrlProvider]) and no tenant→network cycle, so the refresh Dio
  /// simply reads the same env-derived base URL directly. No notifier to wire
  /// at bootstrap, and no `StateError` on early read.
  RefreshDioProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'refreshDioProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$refreshDioHash();

  @$internal
  @override
  $ProviderElement<Dio> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Dio create(Ref ref) {
    return refreshDio(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Dio value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Dio>(value),
    );
  }
}

String _$refreshDioHash() => r'5a2b9bdc921f47fb9673ca3338062194ae48f8e4';

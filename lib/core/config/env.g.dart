// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'env.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Overridden in `bootstrap()` from the flavored entry point.

@ProviderFor(env)
final envProvider = EnvProvider._();

/// Overridden in `bootstrap()` from the flavored entry point.

final class EnvProvider extends $FunctionalProvider<Env, Env, Env>
    with $Provider<Env> {
  /// Overridden in `bootstrap()` from the flavored entry point.
  EnvProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'envProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$envHash();

  @$internal
  @override
  $ProviderElement<Env> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Env create(Ref ref) {
    return env(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Env value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Env>(value),
    );
  }
}

String _$envHash() => r'de11c2506343a5bf83de083ca46c5cc425ea469e';

/// True when the app should resolve fake / in-memory backend
/// implementations instead of hitting a real API. Drives the
/// `Fake* / Api*` selection in repository providers.
///
/// True only for the **mock** flavor — dev / staging / prod all talk to a
/// real API (just different base URLs). Override in tests by re-overriding
/// `envProvider` or this provider directly.
///
/// A build-time escape hatch can force either way without changing flavor
/// (e.g. point the dev flavor at the mocks, or the mock flavor at a real
/// API for a one-off):
///   --dart-define=USE_FAKE_BACKEND=true|false

@ProviderFor(useFakeBackend)
final useFakeBackendProvider = UseFakeBackendProvider._();

/// True when the app should resolve fake / in-memory backend
/// implementations instead of hitting a real API. Drives the
/// `Fake* / Api*` selection in repository providers.
///
/// True only for the **mock** flavor — dev / staging / prod all talk to a
/// real API (just different base URLs). Override in tests by re-overriding
/// `envProvider` or this provider directly.
///
/// A build-time escape hatch can force either way without changing flavor
/// (e.g. point the dev flavor at the mocks, or the mock flavor at a real
/// API for a one-off):
///   --dart-define=USE_FAKE_BACKEND=true|false

final class UseFakeBackendProvider extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// True when the app should resolve fake / in-memory backend
  /// implementations instead of hitting a real API. Drives the
  /// `Fake* / Api*` selection in repository providers.
  ///
  /// True only for the **mock** flavor — dev / staging / prod all talk to a
  /// real API (just different base URLs). Override in tests by re-overriding
  /// `envProvider` or this provider directly.
  ///
  /// A build-time escape hatch can force either way without changing flavor
  /// (e.g. point the dev flavor at the mocks, or the mock flavor at a real
  /// API for a one-off):
  ///   --dart-define=USE_FAKE_BACKEND=true|false
  UseFakeBackendProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'useFakeBackendProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$useFakeBackendHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return useFakeBackend(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$useFakeBackendHash() => r'50493d24a41de5dd87e54a7ff98f8608deaa6db4';

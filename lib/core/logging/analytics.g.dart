// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Whether `Firebase.initializeApp()` succeeded this session. Overridden in
/// `bootstrap()` with the bool returned by `initFirebase()`.
///
/// Defaults to false (instead of throwing like `envProvider`) because
/// analytics is fail-soft by design: a missed override, a test container, or
/// a fresh checkout without `flutterfire configure` should silently disable
/// analytics, never crash.

@ProviderFor(firebaseReady)
final firebaseReadyProvider = FirebaseReadyProvider._();

/// Whether `Firebase.initializeApp()` succeeded this session. Overridden in
/// `bootstrap()` with the bool returned by `initFirebase()`.
///
/// Defaults to false (instead of throwing like `envProvider`) because
/// analytics is fail-soft by design: a missed override, a test container, or
/// a fresh checkout without `flutterfire configure` should silently disable
/// analytics, never crash.

final class FirebaseReadyProvider extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Whether `Firebase.initializeApp()` succeeded this session. Overridden in
  /// `bootstrap()` with the bool returned by `initFirebase()`.
  ///
  /// Defaults to false (instead of throwing like `envProvider`) because
  /// analytics is fail-soft by design: a missed override, a test container, or
  /// a fresh checkout without `flutterfire configure` should silently disable
  /// analytics, never crash.
  FirebaseReadyProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'firebaseReadyProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$firebaseReadyHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return firebaseReady(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$firebaseReadyHash() => r'38c7dec60f80896bce1c13d65a141173c0ba440b';

@ProviderFor(analytics)
final analyticsProvider = AnalyticsProvider._();

final class AnalyticsProvider
    extends $FunctionalProvider<Analytics, Analytics, Analytics>
    with $Provider<Analytics> {
  AnalyticsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'analyticsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$analyticsHash();

  @$internal
  @override
  $ProviderElement<Analytics> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Analytics create(Ref ref) {
    return analytics(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Analytics value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Analytics>(value),
    );
  }
}

String _$analyticsHash() => r'66b366dbdeb66a3b3f592a2b743684951d7260f6';

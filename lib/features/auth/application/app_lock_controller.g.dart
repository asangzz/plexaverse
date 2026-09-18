// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_lock_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Whether the app is currently locked behind the biometric / device-credential
/// unlock gate.
///
/// The app locks when biometric unlock is enabled and re-authentication is
/// needed: on cold start (resolved here from [BiometricPrefs.isEnabled], so a
/// killed-and-relaunched session is gated) and whenever the app is sent to the
/// background (`PlexaverseApp`'s lifecycle hook calls [lock]). The router
/// (redirect) sends a signed-in **and** locked user to `/unlock`; a successful
/// prompt calls [unlock].
///
/// Async so the router can hold on the splash until the initial locked/unlocked
/// state is known — avoiding a flash of authenticated content before `/unlock`.
///
/// **keepAlive is mandatory:** the router reads this via
/// `ref.read(appLockProvider)` and the lifecycle hook mutates it via
/// `ref.read(appLockProvider.notifier)`; autoDispose would tear the notifier
/// down between reads and lose the armed-lock state.

@ProviderFor(AppLock)
final appLockProvider = AppLockProvider._();

/// Whether the app is currently locked behind the biometric / device-credential
/// unlock gate.
///
/// The app locks when biometric unlock is enabled and re-authentication is
/// needed: on cold start (resolved here from [BiometricPrefs.isEnabled], so a
/// killed-and-relaunched session is gated) and whenever the app is sent to the
/// background (`PlexaverseApp`'s lifecycle hook calls [lock]). The router
/// (redirect) sends a signed-in **and** locked user to `/unlock`; a successful
/// prompt calls [unlock].
///
/// Async so the router can hold on the splash until the initial locked/unlocked
/// state is known — avoiding a flash of authenticated content before `/unlock`.
///
/// **keepAlive is mandatory:** the router reads this via
/// `ref.read(appLockProvider)` and the lifecycle hook mutates it via
/// `ref.read(appLockProvider.notifier)`; autoDispose would tear the notifier
/// down between reads and lose the armed-lock state.
final class AppLockProvider extends $AsyncNotifierProvider<AppLock, bool> {
  /// Whether the app is currently locked behind the biometric / device-credential
  /// unlock gate.
  ///
  /// The app locks when biometric unlock is enabled and re-authentication is
  /// needed: on cold start (resolved here from [BiometricPrefs.isEnabled], so a
  /// killed-and-relaunched session is gated) and whenever the app is sent to the
  /// background (`PlexaverseApp`'s lifecycle hook calls [lock]). The router
  /// (redirect) sends a signed-in **and** locked user to `/unlock`; a successful
  /// prompt calls [unlock].
  ///
  /// Async so the router can hold on the splash until the initial locked/unlocked
  /// state is known — avoiding a flash of authenticated content before `/unlock`.
  ///
  /// **keepAlive is mandatory:** the router reads this via
  /// `ref.read(appLockProvider)` and the lifecycle hook mutates it via
  /// `ref.read(appLockProvider.notifier)`; autoDispose would tear the notifier
  /// down between reads and lose the armed-lock state.
  AppLockProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appLockProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appLockHash();

  @$internal
  @override
  AppLock create() => AppLock();
}

String _$appLockHash() => r'96ba55c0a025ab76e9cc5ad8c34fea19ee92395b';

/// Whether the app is currently locked behind the biometric / device-credential
/// unlock gate.
///
/// The app locks when biometric unlock is enabled and re-authentication is
/// needed: on cold start (resolved here from [BiometricPrefs.isEnabled], so a
/// killed-and-relaunched session is gated) and whenever the app is sent to the
/// background (`PlexaverseApp`'s lifecycle hook calls [lock]). The router
/// (redirect) sends a signed-in **and** locked user to `/unlock`; a successful
/// prompt calls [unlock].
///
/// Async so the router can hold on the splash until the initial locked/unlocked
/// state is known — avoiding a flash of authenticated content before `/unlock`.
///
/// **keepAlive is mandatory:** the router reads this via
/// `ref.read(appLockProvider)` and the lifecycle hook mutates it via
/// `ref.read(appLockProvider.notifier)`; autoDispose would tear the notifier
/// down between reads and lose the armed-lock state.

abstract class _$AppLock extends $AsyncNotifier<bool> {
  FutureOr<bool> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<bool>, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<bool>, bool>,
              AsyncValue<bool>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Whether biometric app lock is switched on — the value behind the Security
/// settings toggle. Backed by [BiometricPrefs.isEnabled].

@ProviderFor(BiometricEnabled)
final biometricEnabledProvider = BiometricEnabledProvider._();

/// Whether biometric app lock is switched on — the value behind the Security
/// settings toggle. Backed by [BiometricPrefs.isEnabled].
final class BiometricEnabledProvider
    extends $AsyncNotifierProvider<BiometricEnabled, bool> {
  /// Whether biometric app lock is switched on — the value behind the Security
  /// settings toggle. Backed by [BiometricPrefs.isEnabled].
  BiometricEnabledProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'biometricEnabledProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$biometricEnabledHash();

  @$internal
  @override
  BiometricEnabled create() => BiometricEnabled();
}

String _$biometricEnabledHash() => r'2d12f6cfff8a379a0ba4069c54e85e6ecd33c3be';

/// Whether biometric app lock is switched on — the value behind the Security
/// settings toggle. Backed by [BiometricPrefs.isEnabled].

abstract class _$BiometricEnabled extends $AsyncNotifier<bool> {
  FutureOr<bool> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<bool>, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<bool>, bool>,
              AsyncValue<bool>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

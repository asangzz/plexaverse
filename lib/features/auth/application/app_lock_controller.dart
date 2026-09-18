import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/biometric_prefs.dart';

part 'app_lock_controller.g.dart';

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
@Riverpod(keepAlive: true)
class AppLock extends _$AppLock {
  @override
  Future<bool> build() async {
    // Lock on launch iff biometric unlock is enabled. The router only enforces
    // /unlock when the user is signed in, so a not-signed-in launch still flows
    // to /login regardless of this value.
    return ref.read(biometricPrefsProvider).isEnabled();
  }

  /// Re-arm the lock — called when the app is backgrounded.
  void lock() => state = const AsyncData<bool>(true);

  /// Clear the lock — called after a successful unlock or password sign-in, or
  /// when the user turns biometric unlock off.
  void unlock() => state = const AsyncData<bool>(false);
}

/// Whether biometric app lock is switched on — the value behind the Security
/// settings toggle. Backed by [BiometricPrefs.isEnabled].
@riverpod
class BiometricEnabled extends _$BiometricEnabled {
  @override
  Future<bool> build() => ref.read(biometricPrefsProvider).isEnabled();

  /// Persist the on/off setting. The caller is responsible for confirming a
  /// live biometric/credential check BEFORE enabling. Disabling also clears any
  /// armed lock so the user isn't stranded behind the gate.
  Future<void> set({required bool enabled}) async {
    await ref.read(biometricPrefsProvider).setEnabled(enabled: enabled);
    if (!enabled) ref.read(appLockProvider.notifier).unlock();
    state = AsyncData<bool>(enabled);
  }
}

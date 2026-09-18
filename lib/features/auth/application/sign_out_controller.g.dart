// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_out_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The single sign-out path (WF "Log out" + router idle-timeout). Both the
/// explicit log-out button and the router's idle-timeout redirect call
/// `signOut()` so they clear identical state.
///
/// Sequence: best-effort server-side session teardown (time-boxed) → clear the
/// stored tokens via [SessionStore] → re-arm nothing, then invalidate the auth
/// gate so the router re-resolves `signedIn = false` and redirects to `/login`.
/// Biometric opt-in is a device-level preference and is deliberately kept
/// across sign-outs.
///
/// **keepAlive is required, not cosmetic.** `signOut()` is invoked via
/// `ref.read(...notifier)` (which retains no listener) and performs async work
/// (the network logout + secure-storage `clear()`). If this were auto-dispose,
/// the controller would be torn down mid-await (no listeners), and the
/// `finally` block's `ref.invalidate(...)` would run on a disposed Ref and
/// throw, aborting the sign-out before it navigates. keepAlive keeps the Ref
/// valid for the whole operation.

@ProviderFor(SignOutController)
final signOutControllerProvider = SignOutControllerProvider._();

/// The single sign-out path (WF "Log out" + router idle-timeout). Both the
/// explicit log-out button and the router's idle-timeout redirect call
/// `signOut()` so they clear identical state.
///
/// Sequence: best-effort server-side session teardown (time-boxed) → clear the
/// stored tokens via [SessionStore] → re-arm nothing, then invalidate the auth
/// gate so the router re-resolves `signedIn = false` and redirects to `/login`.
/// Biometric opt-in is a device-level preference and is deliberately kept
/// across sign-outs.
///
/// **keepAlive is required, not cosmetic.** `signOut()` is invoked via
/// `ref.read(...notifier)` (which retains no listener) and performs async work
/// (the network logout + secure-storage `clear()`). If this were auto-dispose,
/// the controller would be torn down mid-await (no listeners), and the
/// `finally` block's `ref.invalidate(...)` would run on a disposed Ref and
/// throw, aborting the sign-out before it navigates. keepAlive keeps the Ref
/// valid for the whole operation.
final class SignOutControllerProvider
    extends $NotifierProvider<SignOutController, void> {
  /// The single sign-out path (WF "Log out" + router idle-timeout). Both the
  /// explicit log-out button and the router's idle-timeout redirect call
  /// `signOut()` so they clear identical state.
  ///
  /// Sequence: best-effort server-side session teardown (time-boxed) → clear the
  /// stored tokens via [SessionStore] → re-arm nothing, then invalidate the auth
  /// gate so the router re-resolves `signedIn = false` and redirects to `/login`.
  /// Biometric opt-in is a device-level preference and is deliberately kept
  /// across sign-outs.
  ///
  /// **keepAlive is required, not cosmetic.** `signOut()` is invoked via
  /// `ref.read(...notifier)` (which retains no listener) and performs async work
  /// (the network logout + secure-storage `clear()`). If this were auto-dispose,
  /// the controller would be torn down mid-await (no listeners), and the
  /// `finally` block's `ref.invalidate(...)` would run on a disposed Ref and
  /// throw, aborting the sign-out before it navigates. keepAlive keeps the Ref
  /// valid for the whole operation.
  SignOutControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'signOutControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$signOutControllerHash();

  @$internal
  @override
  SignOutController create() => SignOutController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$signOutControllerHash() => r'9ed7f235db84c573846b8ef0f3516b59d0c2465c';

/// The single sign-out path (WF "Log out" + router idle-timeout). Both the
/// explicit log-out button and the router's idle-timeout redirect call
/// `signOut()` so they clear identical state.
///
/// Sequence: best-effort server-side session teardown (time-boxed) → clear the
/// stored tokens via [SessionStore] → re-arm nothing, then invalidate the auth
/// gate so the router re-resolves `signedIn = false` and redirects to `/login`.
/// Biometric opt-in is a device-level preference and is deliberately kept
/// across sign-outs.
///
/// **keepAlive is required, not cosmetic.** `signOut()` is invoked via
/// `ref.read(...notifier)` (which retains no listener) and performs async work
/// (the network logout + secure-storage `clear()`). If this were auto-dispose,
/// the controller would be torn down mid-await (no listeners), and the
/// `finally` block's `ref.invalidate(...)` would run on a disposed Ref and
/// throw, aborting the sign-out before it navigates. keepAlive keeps the Ref
/// valid for the whole operation.

abstract class _$SignOutController extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Sign in, create account, and Google sign-up — the signed-out screen's three
/// use cases and the session hand-off they all end in.
///
/// **Why this exists at all.** All three used to run inside `_AuthPageState`,
/// which made the login page the only widget in the slice that imported
/// `data/`: it reached past `application/` straight to `authRepositoryProvider`
/// and so pointed the dependency arrow outward, the one direction
/// ARCHITECTURE.md forbids. The in-flight flags sat on that same State object,
/// which is what made the rest fragile — every step after an `await` had to
/// prove the widget was still alive before it could run, including the steps
/// that have nothing to do with drawing.
///
/// **What the page keeps.** Field validation, the shake, the consent decision
/// and every error string. That is the form, and the form is the widget's
/// business. What moved here is the part that has to finish whether or not
/// anyone is still looking at the screen.
///
/// ## The keep-alive link is load-bearing
///
/// [_run] pins this notifier with `ref.keepAlive()` for the length of each use
/// case and releases it in a `finally`. Without that pin the provider is
/// autoDispose and the page is its only listener, so a back tap mid-request
/// tears the notifier down and every `ref` use after the await throws
/// `UnmountedRefException` — the widget's own disposal hazard, moved one layer
/// in and no better for the move. With it, [_onAuthenticated] cannot be
/// interrupted: tokens written implies gate invalidated, always.
///
/// Releasing the link rather than declaring `keepAlive: true` is what lets the
/// busy state reset. A success deliberately leaves the spinner running — the
/// router is mid-redirect and the CTA must not come back to life under the
/// user's thumb — so that state is cleared only by the provider disposing once
/// the page is gone, which is exactly when a fresh `/login` wants it clear.

@ProviderFor(AuthController)
final authControllerProvider = AuthControllerProvider._();

/// Sign in, create account, and Google sign-up — the signed-out screen's three
/// use cases and the session hand-off they all end in.
///
/// **Why this exists at all.** All three used to run inside `_AuthPageState`,
/// which made the login page the only widget in the slice that imported
/// `data/`: it reached past `application/` straight to `authRepositoryProvider`
/// and so pointed the dependency arrow outward, the one direction
/// ARCHITECTURE.md forbids. The in-flight flags sat on that same State object,
/// which is what made the rest fragile — every step after an `await` had to
/// prove the widget was still alive before it could run, including the steps
/// that have nothing to do with drawing.
///
/// **What the page keeps.** Field validation, the shake, the consent decision
/// and every error string. That is the form, and the form is the widget's
/// business. What moved here is the part that has to finish whether or not
/// anyone is still looking at the screen.
///
/// ## The keep-alive link is load-bearing
///
/// [_run] pins this notifier with `ref.keepAlive()` for the length of each use
/// case and releases it in a `finally`. Without that pin the provider is
/// autoDispose and the page is its only listener, so a back tap mid-request
/// tears the notifier down and every `ref` use after the await throws
/// `UnmountedRefException` — the widget's own disposal hazard, moved one layer
/// in and no better for the move. With it, [_onAuthenticated] cannot be
/// interrupted: tokens written implies gate invalidated, always.
///
/// Releasing the link rather than declaring `keepAlive: true` is what lets the
/// busy state reset. A success deliberately leaves the spinner running — the
/// router is mid-redirect and the CTA must not come back to life under the
/// user's thumb — so that state is cleared only by the provider disposing once
/// the page is gone, which is exactly when a fresh `/login` wants it clear.
final class AuthControllerProvider
    extends $NotifierProvider<AuthController, AuthBusy> {
  /// Sign in, create account, and Google sign-up — the signed-out screen's three
  /// use cases and the session hand-off they all end in.
  ///
  /// **Why this exists at all.** All three used to run inside `_AuthPageState`,
  /// which made the login page the only widget in the slice that imported
  /// `data/`: it reached past `application/` straight to `authRepositoryProvider`
  /// and so pointed the dependency arrow outward, the one direction
  /// ARCHITECTURE.md forbids. The in-flight flags sat on that same State object,
  /// which is what made the rest fragile — every step after an `await` had to
  /// prove the widget was still alive before it could run, including the steps
  /// that have nothing to do with drawing.
  ///
  /// **What the page keeps.** Field validation, the shake, the consent decision
  /// and every error string. That is the form, and the form is the widget's
  /// business. What moved here is the part that has to finish whether or not
  /// anyone is still looking at the screen.
  ///
  /// ## The keep-alive link is load-bearing
  ///
  /// [_run] pins this notifier with `ref.keepAlive()` for the length of each use
  /// case and releases it in a `finally`. Without that pin the provider is
  /// autoDispose and the page is its only listener, so a back tap mid-request
  /// tears the notifier down and every `ref` use after the await throws
  /// `UnmountedRefException` — the widget's own disposal hazard, moved one layer
  /// in and no better for the move. With it, [_onAuthenticated] cannot be
  /// interrupted: tokens written implies gate invalidated, always.
  ///
  /// Releasing the link rather than declaring `keepAlive: true` is what lets the
  /// busy state reset. A success deliberately leaves the spinner running — the
  /// router is mid-redirect and the CTA must not come back to life under the
  /// user's thumb — so that state is cleared only by the provider disposing once
  /// the page is gone, which is exactly when a fresh `/login` wants it clear.
  AuthControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authControllerHash();

  @$internal
  @override
  AuthController create() => AuthController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthBusy value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthBusy>(value),
    );
  }
}

String _$authControllerHash() => r'926166952d44d0eeb7086002e45bb7fb403d23cc';

/// Sign in, create account, and Google sign-up — the signed-out screen's three
/// use cases and the session hand-off they all end in.
///
/// **Why this exists at all.** All three used to run inside `_AuthPageState`,
/// which made the login page the only widget in the slice that imported
/// `data/`: it reached past `application/` straight to `authRepositoryProvider`
/// and so pointed the dependency arrow outward, the one direction
/// ARCHITECTURE.md forbids. The in-flight flags sat on that same State object,
/// which is what made the rest fragile — every step after an `await` had to
/// prove the widget was still alive before it could run, including the steps
/// that have nothing to do with drawing.
///
/// **What the page keeps.** Field validation, the shake, the consent decision
/// and every error string. That is the form, and the form is the widget's
/// business. What moved here is the part that has to finish whether or not
/// anyone is still looking at the screen.
///
/// ## The keep-alive link is load-bearing
///
/// [_run] pins this notifier with `ref.keepAlive()` for the length of each use
/// case and releases it in a `finally`. Without that pin the provider is
/// autoDispose and the page is its only listener, so a back tap mid-request
/// tears the notifier down and every `ref` use after the await throws
/// `UnmountedRefException` — the widget's own disposal hazard, moved one layer
/// in and no better for the move. With it, [_onAuthenticated] cannot be
/// interrupted: tokens written implies gate invalidated, always.
///
/// Releasing the link rather than declaring `keepAlive: true` is what lets the
/// busy state reset. A success deliberately leaves the spinner running — the
/// router is mid-redirect and the CTA must not come back to life under the
/// user's thumb — so that state is cleared only by the provider disposing once
/// the page is gone, which is exactly when a fresh `/login` wants it clear.

abstract class _$AuthController extends $Notifier<AuthBusy> {
  AuthBusy build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AuthBusy, AuthBusy>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AuthBusy, AuthBusy>,
              AuthBusy,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

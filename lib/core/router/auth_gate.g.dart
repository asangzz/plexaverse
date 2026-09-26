// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_gate.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Resolves the session, refreshing the access token if that is all that is
/// wrong with it.
///
/// After sign-in / sign-out the pages `ref.invalidate(authGateProvider)` then
/// `await ref.read(authGateProvider.future)` to drive the recompute so the
/// go_router redirect fires.
///
/// ## Why this asks for a refresh
///
/// The access token lives one hour; the refresh token lives thirty days.
/// [SessionStore.activeAccessToken] returns null the moment the first is
/// spent, and `signedIn` is computed from it — so without the call below, the
/// app decided you were signed out an hour after your last use and bounced you
/// to /login with a refresh token still good for a month sitting unused in the
/// keychain.
///
/// Nothing else would have caught it. [TokenRefresher] is only ever called by
/// `AuthInterceptor`, and only on a 401 — which needs a REQUEST, and the gate
/// never makes one. A cold start with an expired token therefore made no
/// network call at all: it read the keychain, concluded "signed out", and
/// showed the login screen.
///
/// ## The order matters
///
/// Idle is read FIRST, and the refresh is skipped when it has expired.
/// Refreshing writes new tokens, and writing them calls
/// `SessionStore.touchActivity` — so a refresh performed before the idle check
/// would reset the very clock the idle timeout is measured on, and the
/// three-hour timeout would never fire again.
///
/// An idle-expired session is left with its tokens in place rather than
/// scrubbed here. Clearing is a side effect and this is a read; the guard owns
/// that, and it holds — `lastActivityAt` does not move, so the session stays
/// idle-expired on every subsequent launch too.

@ProviderFor(authGate)
final authGateProvider = AuthGateProvider._();

/// Resolves the session, refreshing the access token if that is all that is
/// wrong with it.
///
/// After sign-in / sign-out the pages `ref.invalidate(authGateProvider)` then
/// `await ref.read(authGateProvider.future)` to drive the recompute so the
/// go_router redirect fires.
///
/// ## Why this asks for a refresh
///
/// The access token lives one hour; the refresh token lives thirty days.
/// [SessionStore.activeAccessToken] returns null the moment the first is
/// spent, and `signedIn` is computed from it — so without the call below, the
/// app decided you were signed out an hour after your last use and bounced you
/// to /login with a refresh token still good for a month sitting unused in the
/// keychain.
///
/// Nothing else would have caught it. [TokenRefresher] is only ever called by
/// `AuthInterceptor`, and only on a 401 — which needs a REQUEST, and the gate
/// never makes one. A cold start with an expired token therefore made no
/// network call at all: it read the keychain, concluded "signed out", and
/// showed the login screen.
///
/// ## The order matters
///
/// Idle is read FIRST, and the refresh is skipped when it has expired.
/// Refreshing writes new tokens, and writing them calls
/// `SessionStore.touchActivity` — so a refresh performed before the idle check
/// would reset the very clock the idle timeout is measured on, and the
/// three-hour timeout would never fire again.
///
/// An idle-expired session is left with its tokens in place rather than
/// scrubbed here. Clearing is a side effect and this is a read; the guard owns
/// that, and it holds — `lastActivityAt` does not move, so the session stays
/// idle-expired on every subsequent launch too.

final class AuthGateProvider
    extends
        $FunctionalProvider<AsyncValue<AuthGate>, AuthGate, FutureOr<AuthGate>>
    with $FutureModifier<AuthGate>, $FutureProvider<AuthGate> {
  /// Resolves the session, refreshing the access token if that is all that is
  /// wrong with it.
  ///
  /// After sign-in / sign-out the pages `ref.invalidate(authGateProvider)` then
  /// `await ref.read(authGateProvider.future)` to drive the recompute so the
  /// go_router redirect fires.
  ///
  /// ## Why this asks for a refresh
  ///
  /// The access token lives one hour; the refresh token lives thirty days.
  /// [SessionStore.activeAccessToken] returns null the moment the first is
  /// spent, and `signedIn` is computed from it — so without the call below, the
  /// app decided you were signed out an hour after your last use and bounced you
  /// to /login with a refresh token still good for a month sitting unused in the
  /// keychain.
  ///
  /// Nothing else would have caught it. [TokenRefresher] is only ever called by
  /// `AuthInterceptor`, and only on a 401 — which needs a REQUEST, and the gate
  /// never makes one. A cold start with an expired token therefore made no
  /// network call at all: it read the keychain, concluded "signed out", and
  /// showed the login screen.
  ///
  /// ## The order matters
  ///
  /// Idle is read FIRST, and the refresh is skipped when it has expired.
  /// Refreshing writes new tokens, and writing them calls
  /// `SessionStore.touchActivity` — so a refresh performed before the idle check
  /// would reset the very clock the idle timeout is measured on, and the
  /// three-hour timeout would never fire again.
  ///
  /// An idle-expired session is left with its tokens in place rather than
  /// scrubbed here. Clearing is a side effect and this is a read; the guard owns
  /// that, and it holds — `lastActivityAt` does not move, so the session stays
  /// idle-expired on every subsequent launch too.
  AuthGateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authGateProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authGateHash();

  @$internal
  @override
  $FutureProviderElement<AuthGate> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<AuthGate> create(Ref ref) {
    return authGate(ref);
  }
}

String _$authGateHash() => r'a2960fe10dad62b4003ff981b55ddcf682cba497';

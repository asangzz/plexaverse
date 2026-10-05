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
/// ## The idle timeout is gone, and why
///
/// This used to read `SessionStore.isIdleExpired()` first and skip the refresh
/// when it fired, and the router then signed the user out and WIPED the
/// tokens. Three hours after your last token write, a refresh token with
/// twenty-nine days left on it was deleted. That is what "the login does not
/// last when I kill the app" was.
///
/// It was wrong twice over:
///
/// 1. **The policy is not this product's.** Three hours came from the health
///    app this codebase was skinned from, where a short idle window protects
///    patient data. The Plexaverse web app sets no `maxAge` at all — NextAuth
///    defaults to thirty days and has no idle concept — so the two halves of
///    the same product disagreed about how long a login lasts.
///
/// 2. **It did not measure activity.** `touchActivity` was documented as
///    running on every 2xx response; `AuthInterceptor` has no `onResponse`
///    hook and never called it. The only writers were login and refresh, so
///    the window ran from the last TOKEN WRITE. Using the app did not extend
///    it.
///
/// The session's real boundary is the refresh token, and it always was: when
/// that expires the refresh below returns null and `signedIn` is false on its
/// own. A second timer could only ever end the session EARLY.
///
/// Protecting an unattended phone is a different job and already has an
/// owner — the opt-in biometric lock, armed in `PlexaverseApp` when the app
/// leaves the foreground. That holds the session rather than destroying it,
/// which is what a lock should do.

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
/// ## The idle timeout is gone, and why
///
/// This used to read `SessionStore.isIdleExpired()` first and skip the refresh
/// when it fired, and the router then signed the user out and WIPED the
/// tokens. Three hours after your last token write, a refresh token with
/// twenty-nine days left on it was deleted. That is what "the login does not
/// last when I kill the app" was.
///
/// It was wrong twice over:
///
/// 1. **The policy is not this product's.** Three hours came from the health
///    app this codebase was skinned from, where a short idle window protects
///    patient data. The Plexaverse web app sets no `maxAge` at all — NextAuth
///    defaults to thirty days and has no idle concept — so the two halves of
///    the same product disagreed about how long a login lasts.
///
/// 2. **It did not measure activity.** `touchActivity` was documented as
///    running on every 2xx response; `AuthInterceptor` has no `onResponse`
///    hook and never called it. The only writers were login and refresh, so
///    the window ran from the last TOKEN WRITE. Using the app did not extend
///    it.
///
/// The session's real boundary is the refresh token, and it always was: when
/// that expires the refresh below returns null and `signedIn` is false on its
/// own. A second timer could only ever end the session EARLY.
///
/// Protecting an unattended phone is a different job and already has an
/// owner — the opt-in biometric lock, armed in `PlexaverseApp` when the app
/// leaves the foreground. That holds the session rather than destroying it,
/// which is what a lock should do.

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
  /// ## The idle timeout is gone, and why
  ///
  /// This used to read `SessionStore.isIdleExpired()` first and skip the refresh
  /// when it fired, and the router then signed the user out and WIPED the
  /// tokens. Three hours after your last token write, a refresh token with
  /// twenty-nine days left on it was deleted. That is what "the login does not
  /// last when I kill the app" was.
  ///
  /// It was wrong twice over:
  ///
  /// 1. **The policy is not this product's.** Three hours came from the health
  ///    app this codebase was skinned from, where a short idle window protects
  ///    patient data. The Plexaverse web app sets no `maxAge` at all — NextAuth
  ///    defaults to thirty days and has no idle concept — so the two halves of
  ///    the same product disagreed about how long a login lasts.
  ///
  /// 2. **It did not measure activity.** `touchActivity` was documented as
  ///    running on every 2xx response; `AuthInterceptor` has no `onResponse`
  ///    hook and never called it. The only writers were login and refresh, so
  ///    the window ran from the last TOKEN WRITE. Using the app did not extend
  ///    it.
  ///
  /// The session's real boundary is the refresh token, and it always was: when
  /// that expires the refresh below returns null and `signedIn` is false on its
  /// own. A second timer could only ever end the session EARLY.
  ///
  /// Protecting an unattended phone is a different job and already has an
  /// owner — the opt-in biometric lock, armed in `PlexaverseApp` when the app
  /// leaves the foreground. That holds the session rather than destroying it,
  /// which is what a lock should do.
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

String _$authGateHash() => r'a59eae82957a773058d1bacff28c3d90c1b7da88';

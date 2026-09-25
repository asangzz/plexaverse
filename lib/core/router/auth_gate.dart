import '../network/interceptors/auth_interceptor.dart';
import '../storage/session_store.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_gate.g.dart';

/// Snapshot of auth state the router needs to make redirect decisions (§14).
///
/// A deliberately minimal value object: just the two facts the guard branches
/// on. The full `AuthController` (under `features/auth/`) overrides
/// [authGateProvider] once the auth feature is built — the override point is
/// the provider, not the router. Until then this stub reads token presence +
/// idle state straight from [SessionStore] so the router already enforces the
/// post-auth boundary.
class AuthGate {
  const AuthGate({
    required this.signedIn,
    required this.idleExpired,
  });

  /// True iff a non-expired access token is present.
  final bool signedIn;

  /// True iff the last successful API call is older than the idle timeout.
  final bool idleExpired;
}

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
@Riverpod(keepAlive: true)
Future<AuthGate> authGate(Ref ref) async {
  final session = ref.watch(sessionStoreProvider);

  final idle = await session.isIdleExpired();
  var token = await session.activeAccessToken();

  if (token == null && !idle) {
    // Single-flight inside the refresher, and it answers null for every
    // failure including "there is no refresh token", so this needs no guard
    // of its own.
    token = await ref.read(tokenRefresherProvider).refresh();
  }

  return AuthGate(
    signedIn: token != null,
    idleExpired: idle,
  );
}

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

/// Overridden by the auth feature once it lands (after sign-in / sign-out the
/// pages `ref.invalidate(authGateProvider)` then `await
/// ref.read(authGateProvider.future)` to drive the recompute so the go_router
/// redirect fires). The fallback here consults [SessionStore] directly so the
/// rest of the router works today.
@Riverpod(keepAlive: true)
Future<AuthGate> authGate(Ref ref) async {
  final session = ref.watch(sessionStoreProvider);
  final token = await session.activeAccessToken();
  final idle = await session.isIdleExpired();
  return AuthGate(
    signedIn: token != null,
    idleExpired: idle,
  );
}

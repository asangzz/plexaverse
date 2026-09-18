import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/router/auth_gate.dart';
import '../../../core/storage/session_store.dart';
import '../data/auth_repository_providers.dart';
import 'app_lock_controller.dart';

part 'sign_out_controller.g.dart';

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
@Riverpod(keepAlive: true)
class SignOutController extends _$SignOutController {
  @override
  void build() {}

  Future<void> signOut() async {
    // Tell the backend to invalidate the refresh token while the access token
    // is still present. Best-effort and TIME-BOXED: a slow/unreachable backend
    // must not hang "Log out". On timeout/failure we sign out locally anyway.
    try {
      await ref
          .read(authRepositoryProvider)
          .signOut()
          .timeout(const Duration(seconds: 2));
    } on Object {
      // Proceed with local sign-out regardless.
    }
    try {
      await ref.read(sessionStoreProvider).clear();
    } finally {
      // Clear any armed biometric lock so a re-login isn't stranded behind the
      // gate, then flip the auth gate.
      ref.read(appLockProvider.notifier).unlock();
      ref.invalidate(authGateProvider);
      // Invalidating a listened-only keepAlive async provider leaves it serving
      // the STALE signed-in value; reading `.future` forces the recompute so
      // the router's redirect to `/login` fires.
      try {
        await ref.read(authGateProvider.future);
      } on Object {
        // A gate error is treated as signed-out by the router too — still fine.
      }
    }
  }
}

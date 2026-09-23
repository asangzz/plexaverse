import 'dart:async';

import '../../features/auth/application/app_lock_controller.dart';
import '../../features/auth/application/sign_out_controller.dart';
import '../../features/onboarding/application/onboarding_controller.dart';
import 'auth_gate.dart';
import 'route_paths.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/preferences/application/preferences_controller.dart';
import '../../features/preferences/domain/user_preferences.dart';

/// Query parameter used to round-trip the original location across the login
/// redirect, so a deep link survives the auth gate.
const String kPendingRedirectParam = 'redirect';

/// `?reason=expired` on the login URL signals an idle-timeout sign-out, so the
/// login screen can show a "session timed out" notice.
const String kReasonParam = 'reason';
const String kReasonExpired = 'expired';

/// Where the guard wants to send the user. Kept separate from the route
/// strings + deep-link query handling so the decision is a pure, exhaustively
/// testable function ([redirectDecision]); the side effects (idle sign-out,
/// deep-link preservation, path mapping) live in [appRedirect].
///
/// Plexaverse adds [RedirectTarget.onboarding] to the ProHealth set — the
/// first-run onboarding gate sits between the splash and the auth gate.
enum RedirectTarget { stay, splash, onboarding, login, home, unlock }

/// Pure routing decision. `stay` means "no redirect" (`null`). No Riverpod /
/// Flutter dependencies — exhaustively unit-testable.
///
/// Rules, in priority order (splash → unlock → login → onboarding → home):
///   0. /styleguide is public (dev/design reference) → stay.
///   1. Session / lock / onboarding state still resolving on cold start →
///      hold on the splash.
///   2. Signed in && idle > timeout → /login (clearSession).
///   3. Signed in && locked → /unlock (precedence over every signed-in
///      destination).
///   4. At /unlock but no longer locked / signed in → move on.
///   5. NOT signed in → /login, except on the pre-auth surface.
///   6. Signed in && onboarding not completed → /onboarding.
///   7. At /(splash), a completed /onboarding, or a pre-auth route while
///      signed in → /home.
///
/// **The onboarding gate sits BELOW the auth gate, and that ordering is the
/// whole point of it.** It used to sit above every auth rule, on the
/// inherited assumption that `/onboarding` was a pre-auth carousel a fresh
/// install should see before anything else. It is not: `OnboardingChatPage`
/// is the authenticated "Plexa setup" chat. It opens by calling `/auth/me`
/// for the user's name and it finishes by PATCHing `/user/preferences`.
///
/// With the gate on top, a signed-out fresh install was sent into that chat,
/// 401'd on the opening call, answered every question against a server that
/// did not know who they were, and hit "I hit a snag saving your setup" at
/// the end — having never been shown a login screen. Web has always had this
/// right: `/onboarding` lives under the `(dashboard)` route group, which
/// requires a session.
({RedirectTarget target, bool clearSession}) redirectDecision({
  required String location,
  required AuthGate? gate,
  required bool isResolving,
  bool locked = false,
  bool onboardingComplete = true,
}) {
  const stay = (target: RedirectTarget.stay, clearSession: false);

  if (location == RoutePaths.styleguide) return stay;

  final atSplash = location == RoutePaths.splash;
  final atOnboarding = location == RoutePaths.onboarding;
  final atUnlock = location == RoutePaths.unlock;
  final atPreAuth = RoutePaths.preAuth.contains(location);

  // Cold start: hold on the splash until the session, lock and onboarding
  // state all resolve.
  if (isResolving) {
    return atSplash
        ? stay
        : (target: RedirectTarget.splash, clearSession: false);
  }

  final signedIn = gate != null && gate.signedIn;
  final idleExpired = gate != null && gate.idleExpired;

  // An expired idle session is signed out — clear and bounce to /login.
  if (signedIn && idleExpired) {
    return (target: RedirectTarget.login, clearSession: true);
  }

  // Signed in but the app is locked → hold everything behind the unlock gate
  // (resume / relaunch re-authentication). Takes precedence over every
  // signed-in destination below.
  if (signedIn && locked) {
    return atUnlock
        ? stay
        : (target: RedirectTarget.unlock, clearSession: false);
  }

  // On the unlock screen but no longer locked (unlock succeeded) or no longer
  // signed in (logged out from the unlock screen) → move on.
  if (atUnlock) {
    return signedIn
        ? (target: RedirectTarget.home, clearSession: false)
        : (target: RedirectTarget.login, clearSession: false);
  }

  // Not signed in (or gate errored): the pre-auth surface is allowed,
  // anything else bounces to /login — INCLUDING /onboarding. See the class
  // comment: that chat cannot function, or save, without a session.
  if (!signedIn) {
    return atPreAuth
        ? stay
        : (target: RedirectTarget.login, clearSession: false);
  }

  // Signed in, but setup is unfinished → hold on the Plexa setup chat.
  if (!onboardingComplete) {
    return atOnboarding
        ? stay
        : (target: RedirectTarget.onboarding, clearSession: false);
  }

  // Signed in, set up, and sitting somewhere that is not a destination:
  // the splash, a completed onboarding, or the login screen → home.
  if (atSplash || atOnboarding || atPreAuth) {
    return (target: RedirectTarget.home, clearSession: false);
  }

  return stay;
}

/// Guard evaluated on every navigation (§14). Resolves the auth gate, app-lock
/// and onboarding state, runs the pure [redirectDecision], then applies the
/// side effects: idle sign-out and deep-link preservation.
///
/// AsyncValue resolution uses `ref.read` + `switch` pattern-matching;
/// 'resolving' means first-load only (no value AND not an error) — errors fail
/// OPEN (gate error = signed out, lock error = unlocked, onboarding error =
/// completed) so the user is never stranded on the splash.
String? appRedirect(Ref ref, GoRouterState state) {
  final gateAsync = ref.read(authGateProvider);
  final gate = switch (gateAsync) {
    AsyncData<AuthGate>(:final value) => value,
    _ => null,
  };
  // First load only: no value yet and not an error. An error (no value, not
  // loading) falls through and is treated as signed-out, so a corrupt session
  // never strands the user on the splash.
  final gateResolving = gate == null && gateAsync is! AsyncError;

  // App-lock state. Like the gate, hold on the splash until it first resolves
  // so a locked session never flashes content before /unlock. A lock error is
  // treated as unlocked (fail open to the normal auth flow, never strand).
  final lockAsync = ref.read(appLockProvider);
  final locked = switch (lockAsync) {
    AsyncData<bool>(:final value) => value,
    _ => false,
  };
  final lockResolving = !lockAsync.hasValue && lockAsync is! AsyncError;

  // Onboarding. The SERVER decides, and the device-local flag is only the
  // fallback.
  //
  // It used to be the local `onboarding_done` SharedPreferences key alone,
  // which is per-install: a user who completed setup on the WEB and then
  // installed the app was sent through the whole Plexa chat again, and their
  // answers overwrote what they had already set. Reinstalling did the same.
  //
  // Reading preferences here is only possible because the onboarding gate
  // now sits BELOW the auth check — there is a session by the time this runs,
  // so there is something to ask the server about.
  //
  // Both sources fail OPEN, for the same reason they always did: a returning
  // user must never be trapped in setup. A genuinely new user whose
  // preferences call fails simply lands on the dashboard and can open the
  // chat from there, which is recoverable; being held in a loop is not.
  final localOnboarding = ref.read(onboardingControllerProvider);
  // Only asked when there IS a session. Preferences is an authenticated
  // call; firing it for a signed-out user buys a guaranteed 401, and the
  // gate cannot matter to them anyway — the auth rule above sends them to
  // /login before onboarding is ever consulted.
  final serverOnboarding = (gate?.signedIn ?? false)
      ? ref.read(preferencesControllerProvider)
      : const AsyncLoading<UserPreferences>();
  final onboardingComplete = switch (serverOnboarding) {
    AsyncData<UserPreferences>(:final value) => value.onboardingCompleted,
    // No server answer yet — fall back to whatever this device remembers.
    _ => switch (localOnboarding) {
      AsyncData<bool>(:final value) => value,
      _ => true,
    },
  };
  // What holds the splash.
  //
  // The local flag always does — it is a disk read and resolves in
  // milliseconds.
  //
  // Preferences hold it too, but ONLY while signed in. A signed-out user
  // would otherwise wait on a call that is never made. And waiting here is
  // the point: immediately after sign-in the answer is still in flight, and
  // guessing from the device-local flag sends a returning user to onboarding
  // for the moment it takes to arrive — a flash of the wrong screen, or on a
  // slow connection several seconds of it, before the redirect corrects.
  // Better to hold the splash than to answer wrongly and take it back.
  final signedInNow = gate?.signedIn ?? false;
  final onboardingResolving =
      (!localOnboarding.hasValue && localOnboarding is! AsyncError) ||
      (signedInNow &&
          !serverOnboarding.hasValue &&
          serverOnboarding is! AsyncError);

  final isResolving = gateResolving || lockResolving || onboardingResolving;
  final location = state.matchedLocation;
  final decision = redirectDecision(
    location: location,
    gate: gate,
    isResolving: isResolving,
    locked: locked,
    onboardingComplete: onboardingComplete,
  );

  if (decision.clearSession) unawaited(_idleSignOut(ref));

  switch (decision.target) {
    case RedirectTarget.stay:
      return null;
    case RedirectTarget.splash:
      return RoutePaths.splash;
    case RedirectTarget.onboarding:
      return RoutePaths.onboarding;
    case RedirectTarget.unlock:
      return RoutePaths.unlock;
    case RedirectTarget.login:
      // `clearSession` here means the idle timeout fired — tell the login
      // screen so it can show the "session timed out" notice.
      final expired = decision.clearSession;
      // Preserve a genuine deep link; the splash, onboarding and login routes
      // are never destinations worth restoring.
      if (location == RoutePaths.login ||
          location == RoutePaths.splash ||
          location == RoutePaths.onboarding) {
        return expired
            ? '${RoutePaths.login}?$kReasonParam=$kReasonExpired'
            : RoutePaths.login;
      }
      return _toLoginPreserving(location, expired: expired);
    case RedirectTarget.home:
      if (location == RoutePaths.login) {
        final pending = state.uri.queryParameters[kPendingRedirectParam];
        // Open-redirect protection: restore only in-app locations.
        if (pending != null && pending.startsWith('/')) return pending;
      }
      return RoutePaths.home;
  }
}

String _toLoginPreserving(String location, {bool expired = false}) {
  final reason = expired ? '&$kReasonParam=$kReasonExpired' : '';
  if (location == RoutePaths.login) {
    return expired
        ? '${RoutePaths.login}?$kReasonParam=$kReasonExpired'
        : RoutePaths.login;
  }
  final encoded = Uri.encodeQueryComponent(location);
  return '${RoutePaths.login}?$kPendingRedirectParam=$encoded$reason';
}

/// Best-effort sign-out triggered by the idle-timeout guard. Delegates to the
/// one [SignOutController] so the idle timeout and the explicit "Log out"
/// button clear exactly the same state — tokens, the auth gate, AND the
/// user-scoped keepAlive PII. Keeping these in lockstep is why this does not
/// hand-roll the cleanup.
Future<void> _idleSignOut(Ref ref) async {
  await ref.read(signOutControllerProvider.notifier).signOut();
}

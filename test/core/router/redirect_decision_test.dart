import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/core/router/auth_gate.dart';
import 'package:plexaverse/core/router/redirect.dart';
import 'package:plexaverse/core/router/route_paths.dart';

/// `redirectDecision` is a pure function and its doc comment calls it
/// "exhaustively testable". It had no tests, and that is how the onboarding
/// gate came to sit above the auth gate without anyone noticing.
///
/// The first group is the regression. The rest pin the ordering around it,
/// because the bug was not a wrong rule — every rule was individually right —
/// it was two correct rules in the wrong order.
void main() {
  const signedOut = AuthGate(signedIn: false);
  const signedIn = AuthGate(signedIn: true);

  RedirectTarget target({
    required String location,
    AuthGate? gate = signedOut,
    bool isResolving = false,
    bool locked = false,
    bool onboardingComplete = true,
  }) => redirectDecision(
    location: location,
    gate: gate,
    isResolving: isResolving,
    locked: locked,
    onboardingComplete: onboardingComplete,
  ).target;

  group('the onboarding gate sits below the auth gate', () {
    test('a signed-out fresh install goes to LOGIN, not into Plexa setup', () {
      // The regression. `/onboarding` is the authenticated setup chat: it
      // opens with /auth/me and finishes by PATCHing /user/preferences. Sent
      // there signed out, a user answered every question and then hit "I hit
      // a snag saving your setup", having never seen a login screen.
      expect(
        target(
          location: RoutePaths.home,
          gate: signedOut,
          onboardingComplete: false,
        ),
        RedirectTarget.login,
      );
    });

    test('and is bounced off /onboarding itself when signed out', () {
      expect(
        target(
          location: RoutePaths.onboarding,
          gate: signedOut,
          onboardingComplete: false,
        ),
        RedirectTarget.login,
      );
    });

    test('but a SIGNED-IN user with unfinished setup is still held there', () {
      // The gate must keep working for the case it exists for.
      expect(
        target(
          location: RoutePaths.home,
          gate: signedIn,
          onboardingComplete: false,
        ),
        RedirectTarget.onboarding,
      );
    });

    test('and stays put once there', () {
      expect(
        target(
          location: RoutePaths.onboarding,
          gate: signedIn,
          onboardingComplete: false,
        ),
        RedirectTarget.stay,
      );
    });

    test('a completed onboarding does not trap a signed-in user', () {
      expect(
        target(location: RoutePaths.onboarding, gate: signedIn),
        RedirectTarget.home,
      );
    });
  });

  group(
    'a returning user is never sent to setup while the answer is loading',
    () {
      // The production bug this pins. The onboarding gate reads the SERVER's
      // onboardingCompleted, but on a fresh install the device-local flag is
      // false — so during the window where preferences are still in flight,
      // falling back to that flag sent every signed-in user to onboarding.
      // With a cached 401 from before sign-in it never corrected, and they
      // stayed there: an existing account, looking at a setup chat.
      test(
        'resolving holds the splash rather than guessing "not onboarded"',
        () {
          expect(
            target(
              location: RoutePaths.home,
              gate: signedIn,
              isResolving: true,
              onboardingComplete: false,
            ),
            RedirectTarget.splash,
          );
        },
      );

      test('once the server says completed, they go home and not to setup', () {
        expect(
          target(
            location: RoutePaths.home,
            gate: signedIn,
            onboardingComplete: true,
          ),
          RedirectTarget.stay,
        );
        expect(
          target(
            location: RoutePaths.splash,
            gate: signedIn,
            onboardingComplete: true,
          ),
          RedirectTarget.home,
        );
      });

      test('a genuinely new user still reaches setup', () {
        // The fix must not break the case the gate exists for.
        expect(
          target(
            location: RoutePaths.home,
            gate: signedIn,
            onboardingComplete: false,
          ),
          RedirectTarget.onboarding,
        );
      });
    },
  );

  group('auth boundary', () {
    test('signed out, /login is allowed', () {
      expect(
        target(location: RoutePaths.login, gate: signedOut),
        RedirectTarget.stay,
      );
    });

    test('signed out, any other route bounces to /login', () {
      expect(
        target(location: RoutePaths.home, gate: signedOut),
        RedirectTarget.login,
      );
    });

    test('a gate ERROR is treated as signed out, never as signed in', () {
      // appRedirect passes null for an errored gate — failing open to
      // "signed out" must not mean failing open to "let them in".
      expect(
        target(location: RoutePaths.home, gate: null),
        RedirectTarget.login,
      );
    });

    test('signed in on the login screen goes home', () {
      expect(
        target(location: RoutePaths.login, gate: signedIn),
        RedirectTarget.home,
      );
    });

    test('signed in and set up, an ordinary route is left alone', () {
      // Any route that is not splash / onboarding / unlock / pre-auth.
      expect(target(location: '/posts', gate: signedIn), RedirectTarget.stay);
    });
  });

  group('precedence', () {
    test('nothing signed-in clears the session any more', () {
      // Replaces "an idle-expired session clears and goes to login". That rule
      // destroyed a refresh token with twenty-nine days left on it three hours
      // after the last token write, and is why a login did not survive killing
      // the app. The only remaining way to lose tokens is signing out or the
      // server rejecting the refresh.
      for (final String location in <String>[
        RoutePaths.home,
        RoutePaths.login,
        RoutePaths.unlock,
      ]) {
        final d = redirectDecision(
          location: location,
          gate: signedIn,
          isResolving: false,
          onboardingComplete: false,
        );
        expect(
          d.clearSession,
          isFalse,
          reason: 'a signed-in session must never be wiped by a redirect',
        );
      }
    });

    test('a locked session is held, not destroyed', () {
      // The lock is what protects an unattended phone now, and the whole point
      // is that it keeps the session so unlocking returns you to it.
      final d = redirectDecision(
        location: RoutePaths.home,
        gate: signedIn,
        locked: true,
        isResolving: false,
        onboardingComplete: true,
      );
      expect(d.target, RedirectTarget.unlock);
      expect(d.clearSession, isFalse);
    });

    test('a lock outranks the onboarding gate', () {
      expect(
        target(
          location: RoutePaths.home,
          gate: signedIn,
          locked: true,
          onboardingComplete: false,
        ),
        RedirectTarget.unlock,
      );
    });

    test('a lock does NOT strand a signed-out user on /unlock', () {
      expect(
        target(location: RoutePaths.unlock, gate: signedOut, locked: true),
        RedirectTarget.login,
      );
    });

    test('unlocking moves on', () {
      expect(
        target(location: RoutePaths.unlock, gate: signedIn),
        RedirectTarget.home,
      );
    });

    test('resolving holds on the splash, whatever else is true', () {
      expect(
        target(
          location: RoutePaths.home,
          gate: null,
          isResolving: true,
          onboardingComplete: false,
        ),
        RedirectTarget.splash,
      );
      expect(
        target(location: RoutePaths.splash, gate: null, isResolving: true),
        RedirectTarget.stay,
      );
    });
  });

  group('public surface', () {
    test('/styleguide bypasses every rule', () {
      expect(
        target(
          location: RoutePaths.styleguide,
          gate: signedOut,
          isResolving: true,
          locked: true,
          onboardingComplete: false,
        ),
        RedirectTarget.stay,
      );
    });
  });
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/core/router/redirect.dart';
import 'package:plexaverse/features/preferences/domain/user_preferences.dart';

/// The state the gate is in for the few seconds after a sign-in.
const AsyncValue<UserPreferences> _inFlight = AsyncLoading<UserPreferences>();
const AsyncValue<UserPreferences> _failed = AsyncError<UserPreferences>(
  'boom',
  StackTrace.empty,
);

AsyncValue<UserPreferences> _says({required bool completed}) =>
    AsyncData<UserPreferences>(
      UserPreferences(exists: true, onboardingCompleted: completed),
    );

void main() {
  group('signed in', () {
    test('the server decides, and it says set up', () {
      final gate = onboardingGate(
        signedIn: true,
        // The device has never onboarded — a fresh install. The server
        // overrules it, which is the whole reason it is consulted.
        local: const AsyncData<bool>(false),
        server: _says(completed: true),
      );

      expect(gate.complete, isTrue);
      expect(gate.resolving, isFalse);
    });

    test('the server decides, and it says not yet', () {
      final gate = onboardingGate(
        signedIn: true,
        local: const AsyncData<bool>(true),
        server: _says(completed: false),
      );

      expect(gate.complete, isFalse);
      expect(gate.resolving, isFalse);
    });

    test('an answer still in flight holds the splash', () {
      // The regression. For the two to three seconds the first preferences
      // fetch takes, answering from the device flag would send a returning
      // user to the setup chat and then take it back.
      final gate = onboardingGate(
        signedIn: true,
        local: const AsyncData<bool>(false),
        server: _inFlight,
      );

      expect(gate.resolving, isTrue);
    });

    test('a failed read lands on the dashboard, not in setup', () {
      // Counter-intuitive and deliberate: a genuinely new user is not an
      // error case (their row answers 200 with onboardingCompleted false), so
      // an error is overwhelmingly an existing account. Setup would overwrite
      // what they already have.
      final gate = onboardingGate(
        signedIn: true,
        local: const AsyncData<bool>(false),
        server: _failed,
      );

      expect(gate.complete, isTrue);
      expect(gate.resolving, isFalse);
    });

    test('the local flag still holds the splash while it loads', () {
      final gate = onboardingGate(
        signedIn: true,
        local: const AsyncLoading<bool>(),
        server: _says(completed: true),
      );

      expect(gate.resolving, isTrue);
    });
  });

  group('signed out', () {
    test('never waits on a server answer it will not ask for', () {
      // The auth rule fires first, so this value is never used — but it must
      // not hold the splash, or a signed-out cold start hangs forever.
      final gate = onboardingGate(
        signedIn: false,
        local: const AsyncData<bool>(false),
        server: _inFlight,
      );

      expect(gate.resolving, isFalse);
    });

    test('an unreadable local flag is treated as set up', () {
      final gate = onboardingGate(
        signedIn: false,
        local: const AsyncError<bool>('disk', StackTrace.empty),
        server: _inFlight,
      );

      expect(gate.complete, isTrue);
      expect(gate.resolving, isFalse);
    });
  });
}

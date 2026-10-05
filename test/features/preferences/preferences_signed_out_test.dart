import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/core/router/auth_gate.dart';
import 'package:plexaverse/features/preferences/application/preferences_controller.dart';
import 'package:plexaverse/features/preferences/data/preferences_repositories.dart';
import 'package:plexaverse/features/preferences/domain/preferences_repository.dart';

/// Counts reads so the test can assert one did not happen.
class _CountingRepository implements PreferencesRepository {
  int fetches = 0;

  @override
  Future<UserPreferences> fetch() async {
    fetches++;
    return const UserPreferences(exists: true, onboardingCompleted: true);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('${invocation.memberName} is not used here');
}

ProviderContainer _containerFor(
  _CountingRepository repo, {
  required bool signedIn,
}) {
  final container = ProviderContainer(
    overrides: [
      preferencesRepositoryProvider.overrideWithValue(repo),
      authGateProvider.overrideWith(
        (Ref ref) async => AuthGate(signedIn: signedIn),
      ),
    ],
  );
  addTearDown(container.dispose);
  // The controller is autoDispose, so a bare `read` tears it down again
  // before its future settles. The router holds it open the same way.
  container.listen(preferencesControllerProvider, (_, _) {});
  return container;
}

void main() {
  test('signed out, preferences are never fetched', () async {
    // A 401 here is not a wasted request, it is a loop: AuthInterceptor
    // clears the session and announces a forced sign-out, the router turns
    // that into an auth-gate invalidation, and this controller watches the
    // gate. A signed-out login screen drove 52 calls and a 429 that way.
    final repo = _CountingRepository();
    final container = _containerFor(repo, signedIn: false);

    final prefs = await container.read(preferencesControllerProvider.future);

    expect(repo.fetches, 0);
    expect(prefs.exists, isFalse);
  });

  test('signed in, preferences are fetched once', () async {
    final repo = _CountingRepository();
    final container = _containerFor(repo, signedIn: true);

    final prefs = await container.read(preferencesControllerProvider.future);

    expect(repo.fetches, 1);
    expect(prefs.onboardingCompleted, isTrue);
  });
}

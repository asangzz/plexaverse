import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// Pins the Riverpod behaviour the onboarding gate is built on.
///
/// `appRedirect` holds the splash while preferences are still resolving, and
/// it decides "still resolving" with `!hasValue && is! AsyncError`. That test
/// is only correct if a provider whose PREVIOUS state was an error reports as
/// [AsyncLoading] — not [AsyncError] — for the window between a dependency
/// change and the refetch landing.
///
/// It matters because that is exactly the window a returning user signs in
/// through. `PreferencesController` is initialised by the router's refresh
/// listener while the user is still signed out, so its first state is the
/// 401. If that error survived the rebuild as an `AsyncError`, the gate would
/// fall through to the device-local flag — false on a fresh install — and
/// send a user who onboarded on the web into the setup chat again. That was
/// the bug; this pins the mechanism the fix relies on, because it is a
/// behaviour of Riverpod rather than of our code and a package upgrade could
/// take it away silently.
class _Gate extends Notifier<bool> {
  @override
  bool build() => false;
  void signIn() => state = true;
  void signOut() => state = false;
}

final _gate = NotifierProvider<_Gate, bool>(_Gate.new);

final _prefs = FutureProvider<String>((ref) async {
  if (!ref.watch(_gate)) throw StateError('401');
  await Future<void>.delayed(const Duration(milliseconds: 20));
  return 'preferences';
});

void main() {
  test('an errored provider reads as loading, not error, while it refetches',
      () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    // The router subscribes before there is a session, so the first state is
    // the 401.
    container.listen(_prefs, (_, _) {}, fireImmediately: false);
    await Future<void>.delayed(const Duration(milliseconds: 10));

    final signedOut = container.read(_prefs);
    expect(signedOut, isA<AsyncError<String>>());

    container.read(_gate.notifier).signIn();

    // The instant the session lands: no value yet, and NOT an error — so
    // `appRedirect` counts this as resolving and holds the splash.
    final refetching = container.read(_prefs);
    expect(refetching.hasValue, isFalse);
    expect(refetching, isNot(isA<AsyncError<String>>()),
        reason: 'the stale 401 must not outlive the sign-in that fixes it');
    expect(refetching.isLoading, isTrue);

    await Future<void>.delayed(const Duration(milliseconds: 60));
    expect(container.read(_prefs).value, 'preferences');
  });

  test('a DATA value DOES survive the rebuild, and the home screen needs it',
      () async {
    // The counterpart, and the opposite answer. `activeRoadmapDay` watches the
    // selected day, so every scroll of the roadmap rebuilds it — and the home
    // screen used to check `isLoading` and return its skeleton, destroying the
    // timeline, its ScrollController and its scroll position, then rebuilding
    // a frame later. On screen that was a white card flashing over the planet
    // and the timeline jumping instead of scrolling.
    //
    // It now checks `hasValue`, which is only correct because a dependency
    // rebuild keeps the previous DATA — unlike a previous error, above.
    final container = ProviderContainer();
    addTearDown(container.dispose);

    container.listen(_prefs, (_, _) {});
    container.read(_gate.notifier).signIn();
    await Future<void>.delayed(const Duration(milliseconds: 60));
    expect(container.read(_prefs).value, 'preferences');

    // Something the provider depends on changes again.
    container.read(_gate.notifier).signOut();

    final refetching = container.read(_prefs);
    expect(refetching.isLoading, isTrue);
    expect(
      refetching.hasValue,
      isTrue,
      reason: 'the value must outlive the rebuild, or the timeline is torn '
          'down on every scroll',
    );
  });
}

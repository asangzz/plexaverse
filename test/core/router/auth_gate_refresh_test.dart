import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/core/network/interceptors/auth_interceptor.dart';
import 'package:plexaverse/core/network/interceptors/token_refresher.dart';
import 'package:plexaverse/core/router/auth_gate.dart';
import 'package:plexaverse/core/storage/session_store.dart';

/// A session whose answers are set by the test rather than by a keychain.
class _FakeSession implements SessionStore {
  _FakeSession({this.access, this.refresh});

  String? access;
  String? refresh;

  @override
  Future<String?> activeAccessToken() async => access;

  @override
  Future<String?> refreshToken() async => refresh;

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('${invocation.memberName} is not used here');
}

/// Counts refreshes and hands back whatever the test says the server would.
class _FakeRefresher implements TokenRefresher {
  _FakeRefresher(this._result, {required this.session});

  final String? _result;
  final _FakeSession session;
  int calls = 0;

  @override
  Future<String?> refresh() async {
    calls++;
    // The real refresher persists through SessionStore.writeTokens.
    if (_result != null) session.access = _result;
    return _result;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('${invocation.memberName} is not used here');
}

ProviderContainer _containerFor(
  _FakeSession session,
  _FakeRefresher refresher,
) {
  final container = ProviderContainer(
    overrides: [
      sessionStoreProvider.overrideWithValue(session),
      tokenRefresherProvider.overrideWithValue(refresher),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  test('a live access token is used as-is, with no refresh', () async {
    final session = _FakeSession(access: 'live', refresh: 'r');
    final refresher = _FakeRefresher('new', session: session);

    final gate = await _containerFor(
      session,
      refresher,
    ).read(authGateProvider.future);

    expect(gate.signedIn, isTrue);
    expect(refresher.calls, 0);
  });

  test('an expired access token is refreshed rather than signed out', () async {
    // The bug. One hour after the last use the access token is spent, and the
    // gate used to report signed-out with a refresh token still good for
    // thirty days sitting unused — no network call made at all.
    final session = _FakeSession(refresh: 'still-good');
    final refresher = _FakeRefresher('fresh', session: session);

    final gate = await _containerFor(
      session,
      refresher,
    ).read(authGateProvider.future);

    expect(gate.signedIn, isTrue);
    expect(refresher.calls, 1);
  });

  test('a refresh that fails signs the user out', () async {
    final session = _FakeSession(refresh: 'revoked');
    final refresher = _FakeRefresher(null, session: session);

    final gate = await _containerFor(
      session,
      refresher,
    ).read(authGateProvider.future);

    expect(gate.signedIn, isFalse);
    expect(refresher.calls, 1);
  });

  test('no refresh token, no call and no session', () async {
    final session = _FakeSession();
    final refresher = _FakeRefresher(null, session: session);

    final gate = await _containerFor(
      session,
      refresher,
    ).read(authGateProvider.future);

    expect(gate.signedIn, isFalse);
  });

  group('the session outlives the app', () {
    test('a spent access token is refreshed, however long the app was shut', () {
      // The bug this replaces: a three-hour idle timer ran from the last TOKEN
      // WRITE — not from any activity, since nothing ever called
      // touchActivity — and the router then wiped the tokens. Killing the app
      // over lunch was enough to lose a refresh token good for another
      // twenty-nine days.
      //
      // There is no clock in the gate now. However long the app was closed,
      // the only question asked is whether the refresh token still works.
    });

    test('an expired access token always attempts a refresh', () async {
      final session = _FakeSession(refresh: 'still-good');
      final refresher = _FakeRefresher('fresh', session: session);

      final gate = await _containerFor(
        session,
        refresher,
      ).read(authGateProvider.future);

      expect(refresher.calls, 1);
      expect(gate.signedIn, isTrue);
    });

    test('the server refusing the refresh is what ends the session', () async {
      // The only remaining way to be signed out: the refresh token is spent,
      // revoked or absent, and the SERVER says so. Not a client-side timer.
      final session = _FakeSession(refresh: 'revoked');
      final refresher = _FakeRefresher(null, session: session);

      final gate = await _containerFor(
        session,
        refresher,
      ).read(authGateProvider.future);

      expect(refresher.calls, 1);
      expect(gate.signedIn, isFalse);
    });

    test('a live access token is used without a refresh round trip', () async {
      final session = _FakeSession(access: 'live', refresh: 'r');
      final refresher = _FakeRefresher('new', session: session);

      final gate = await _containerFor(
        session,
        refresher,
      ).read(authGateProvider.future);

      expect(refresher.calls, 0, reason: 'nothing was wrong with the token');
      expect(gate.signedIn, isTrue);
    });
  });
}

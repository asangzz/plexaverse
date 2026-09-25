import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/core/network/interceptors/auth_interceptor.dart';
import 'package:plexaverse/core/network/interceptors/token_refresher.dart';
import 'package:plexaverse/core/router/auth_gate.dart';
import 'package:plexaverse/core/storage/session_store.dart';

/// A session whose answers are set by the test rather than by a keychain.
class _FakeSession implements SessionStore {
  _FakeSession({
    this.access,
    this.refresh,
    this.idle = false,
  });

  String? access;
  String? refresh;
  bool idle;

  /// Set when a refresh writes new tokens, so the test can prove a refresh
  /// that happened AFTER the idle read cannot have moved the idle clock.
  bool activityTouched = false;

  @override
  Future<String?> activeAccessToken() async => access;

  @override
  Future<String?> refreshToken() async => refresh;

  @override
  Future<bool> isIdleExpired() async => idle;

  @override
  Future<void> touchActivity() async => activityTouched = true;

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
    if (_result != null) {
      // The real refresher persists through SessionStore.writeTokens, which
      // touches activity. Reproduced, because that is the thing the ordering
      // in `authGate` exists to stay ahead of.
      session.access = _result;
      await session.touchActivity();
    }
    return _result;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('${invocation.memberName} is not used here');
}

ProviderContainer _containerFor(_FakeSession session, _FakeRefresher refresher) {
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

    final gate = await _containerFor(session, refresher)
        .read(authGateProvider.future);

    expect(gate.signedIn, isTrue);
    expect(refresher.calls, 0);
  });

  test('an expired access token is refreshed rather than signed out', () async {
    // The bug. One hour after the last use the access token is spent, and the
    // gate used to report signed-out with a refresh token still good for
    // thirty days sitting unused — no network call made at all.
    final session = _FakeSession(refresh: 'still-good');
    final refresher = _FakeRefresher('fresh', session: session);

    final gate = await _containerFor(session, refresher)
        .read(authGateProvider.future);

    expect(gate.signedIn, isTrue);
    expect(refresher.calls, 1);
  });

  test('a refresh that fails signs the user out', () async {
    final session = _FakeSession(refresh: 'revoked');
    final refresher = _FakeRefresher(null, session: session);

    final gate = await _containerFor(session, refresher)
        .read(authGateProvider.future);

    expect(gate.signedIn, isFalse);
    expect(refresher.calls, 1);
  });

  test('no refresh token, no call and no session', () async {
    final session = _FakeSession();
    final refresher = _FakeRefresher(null, session: session);

    final gate = await _containerFor(session, refresher)
        .read(authGateProvider.future);

    expect(gate.signedIn, isFalse);
  });

  group('the idle timeout', () {
    test('is never resurrected by a refresh', () async {
      // The ordering trap. Refreshing writes tokens, writing tokens touches
      // activity, and activity is what idle is measured from — so a refresh
      // run before the idle check would reset the clock the timeout depends
      // on and the three-hour timeout would never fire again.
      final session = _FakeSession(refresh: 'still-good', idle: true);
      final refresher = _FakeRefresher('fresh', session: session);

      final gate = await _containerFor(session, refresher)
          .read(authGateProvider.future);

      expect(refresher.calls, 0, reason: 'an idle session must not refresh');
      expect(session.activityTouched, isFalse);
      expect(gate.idleExpired, isTrue);
    });

    test('is still reported when the access token is alive', () async {
      // The guard clears the session on this pair, so it has to survive.
      final session = _FakeSession(access: 'live', refresh: 'r', idle: true);
      final refresher = _FakeRefresher('new', session: session);

      final gate = await _containerFor(session, refresher)
          .read(authGateProvider.future);

      expect(gate.signedIn, isTrue);
      expect(gate.idleExpired, isTrue);
    });
  });
}

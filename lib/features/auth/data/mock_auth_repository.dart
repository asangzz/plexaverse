import 'package:flutter/foundation.dart';

import '../../../core/mock/mock_api.dart';
import '../domain/auth_repository.dart';

/// Stand-in credentials for the mock. Sign in with
/// `demo@plexaverse.com` / `password123`.
@visibleForTesting
const Map<String, String> kMockCredentials = <String, String>{
  'demo@plexaverse.com': 'password123',
};

/// A referral code the mock treats as invalid so the create-account
/// validation path is exercisable.
@visibleForTesting
const String kMockRejectedReferral = 'INVALID';

const String _kLoginSuccessAsset = 'assets/mock/auth/login_success.json';
const String _kRegisterSuccessAsset = 'assets/mock/auth/register_success.json';
const String _kRefreshAsset = 'assets/mock/auth/refresh_success.json';

/// In-memory [AuthRepository] used when `useFakeBackend` is true (the **mock**
/// flavor). Validates against [kMockCredentials] and, on success, returns the
/// [AuthTokens] + [AuthUser] deserialised from the bundled JSON under
/// `assets/mock/auth/` — the same shape the real endpoint returns after the
/// envelope unwrap.
///
/// The app is online-first, so the mock honours connectivity exactly like the
/// real path: when [_isOffline] reports a definite offline, calls fast-fail
/// with the network-failure variant — mirroring what `OfflineGateInterceptor`
/// does to the Dio-backed repository. This keeps the mock flavor's offline UX
/// identical to production.
class MockAuthRepository implements AuthRepository {
  const MockAuthRepository({bool Function()? isOffline})
      : _isOffline = isOffline;

  final bool Function()? _isOffline;

  @override
  Future<SignInResult> signIn({
    required String email,
    required String password,
  }) async {
    if (_isOffline?.call() ?? false) {
      // Fast-fail, same as the offline gate: no fake round-trip delay.
      return const SignInNetworkFailure();
    }
    final expected = kMockCredentials[email.trim().toLowerCase()];
    if (expected == null || expected != password) {
      // Mimic the round-trip before reporting the rejection.
      await Future<void>.delayed(MockApi.defaultDelay);
      return const SignInInvalidCredentials();
    }
    try {
      final json = await MockApi.loadObject(_kLoginSuccessAsset);
      return SignInSuccess(tokens: _tokens(json), user: _user(json));
    } on Object {
      return const SignInNetworkFailure();
    }
  }

  @override
  Future<RegisterResult> register({
    required String name,
    required String email,
    required String password,
    String? referralCode,
  }) async {
    if (_isOffline?.call() ?? false) return const RegisterNetworkFailure();
    await Future<void>.delayed(MockApi.defaultDelay);
    if (referralCode != null &&
        referralCode.trim().toUpperCase() == kMockRejectedReferral) {
      return const RegisterInvalid(
        message: 'That referral code is not valid.',
        fieldErrors: <String, String>{'referralCode': 'Invalid referral code'},
      );
    }
    if (kMockCredentials.containsKey(email.trim().toLowerCase())) {
      return const RegisterInvalid(
        message: 'An account with that email already exists.',
        fieldErrors: <String, String>{'email': 'Email already registered'},
      );
    }
    try {
      final json = await MockApi.loadObject(_kRegisterSuccessAsset);
      // Reflect the entered identity back so the mocked home reads naturally.
      final user = _user(json).copyWith(name: name, email: email.trim());
      return RegisterSuccess(tokens: _tokens(json), user: user);
    } on Object {
      return const RegisterNetworkFailure();
    }
  }

  @override
  Future<LinkedInResult> signInWithLinkedIn() async {
    if (_isOffline?.call() ?? false) return const LinkedInFailure();
    try {
      // Simulate the browser hand-off + code exchange round trip.
      final json = await MockApi.loadObject(
        _kLoginSuccessAsset,
        delay: const Duration(milliseconds: 1400),
      );
      return LinkedInSuccess(tokens: _tokens(json), user: _user(json));
    } on Object {
      return const LinkedInFailure();
    }
  }

  @override
  Future<void> signOut() async {
    // No server round trip to simulate; token clearing is SignOutController's.
    // Touch the refresh fixture only to keep the asset referenced/valid.
    assert(_kRefreshAsset.isNotEmpty);
  }

  AuthTokens _tokens(Map<String, dynamic> data) => AuthTokens.fromJson(data);

  AuthUser _user(Map<String, dynamic> data) =>
      AuthUser.fromJson(data['user'] as Map<String, dynamic>);
}

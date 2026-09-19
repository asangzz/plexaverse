import 'package:flutter/foundation.dart';

import '../../../core/mock/mock_api.dart';
import '../domain/auth_repository.dart';
import '../../../core/consent/notice.dart';

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
  // Not const: the mock remembers whether a Google sign-up has been completed
  // so the second attempt signs in rather than re-asking for consent.
  MockAuthRepository({bool Function()? isOffline}) : _isOffline = isOffline;

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
    required bool acceptedNotice,
    required String noticeVersion,
    Map<String, bool> consents = const <String, bool>{},
    String? referralCode,
  }) async {
    // Mirrors the server: without an affirmative acceptance there is no
    // account, so the mock must refuse too or the UI gate is never exercised.
    if (!acceptedNotice) {
      return const RegisterInvalid(
        message: 'You must accept the privacy notice to create an account.',
      );
    }
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

  /// Set once a mock Google sign-up has been completed, so a second
  /// [signInWithGoogle] returns a session instead of asking for consent again.
  bool _googleSignedUp = false;

  @override
  Future<GoogleResult> signInWithGoogle() async {
    if (_isOffline?.call() ?? false) return const GoogleFailure();
    try {
      // Simulate the browser hand-off.
      await Future<void>.delayed(const Duration(milliseconds: 1200));

      // First run returns consent_required, so the notice step is reachable
      // under the mock flavor with no Google Cloud setup at all. That is the
      // path most worth being able to exercise: it is the one that creates a
      // data principal.
      if (!_googleSignedUp) {
        return const GoogleConsentRequired(
          signupTicket: 'mock-signup-ticket',
          noticeVersion: kNoticeVersion,
          profile: GoogleProfile(
            email: 'demo@plexaverse.com',
            name: 'Demo User',
          ),
          purposes: <ConsentPurposeOption>[
            ConsentPurposeOption(
              purpose: 'style_learning',
              label:
                  'Read your existing LinkedIn posts to learn your writing voice',
              required_: false,
            ),
            ConsentPurposeOption(
              purpose: 'marketing',
              label: 'Send product updates and tips',
              required_: false,
            ),
          ],
        );
      }

      final json = await MockApi.loadObject(
        _kLoginSuccessAsset,
        delay: const Duration(milliseconds: 400),
      );
      return GoogleSignedIn(tokens: _tokens(json), user: _user(json));
    } on Object {
      return const GoogleFailure();
    }
  }

  @override
  Future<GoogleResult> completeGoogleSignUp({
    required String signupTicket,
    required String noticeVersion,
    required bool acceptedNotice,
    Map<String, bool> consents = const <String, bool>{},
    String? referralCode,
  }) async {
    if (_isOffline?.call() ?? false) return const GoogleFailure();
    // Mirrors the server: the notice is not optional.
    if (!acceptedNotice) {
      return const GoogleFailure(
        message: 'You must accept the privacy notice to create an account.',
      );
    }
    try {
      final json = await MockApi.loadObject(
        _kRegisterSuccessAsset,
        delay: const Duration(milliseconds: 900),
      );
      _googleSignedUp = true;
      return GoogleSignedIn(tokens: _tokens(json), user: _user(json));
    } on Object {
      return const GoogleFailure();
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

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../core/network/api_paths.dart';
import '../../../core/network/interceptors/auth_interceptor.dart';
import '../../../core/security/pkce.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/network/failure.dart';
import '../../../core/platform/web_auth.dart';
import '../domain/auth_repository.dart';

/// Real, Dio-backed [AuthRepository] — selected over [MockAuthRepository] when
/// `useFakeBackend` is false (prod, or any flavor pointed at a live backend via
/// `--dart-define=API_BASE_URL`).
///
/// The Plexaverse mobile API wraps every payload in a `{data, error, meta}`
/// envelope; [DioClient] unwraps it (RULINGS ruling 7), so on success
/// `response.data` is already the inner `{ accessToken, refreshToken,
/// expiresIn, refreshExpiresIn, user }` object. Errors arrive as a [Failure] on
/// `DioException.error` (mapped by `ErrorInterceptor` for transport/status, and
/// by the envelope seam for a 2xx-with-error body); we translate those to the
/// sealed result the UI understands — auth/validation → the "invalid" variant,
/// everything else → the network-failure variant. NO exception ever escapes.
///
/// The `_webAuth` seam is injected so the LinkedIn browser hand-off can be
/// faked in tests without touching `flutter_web_auth_2`.
class ApiAuthRepository implements AuthRepository {
  const ApiAuthRepository(this._client, this._webAuth);

  final DioClient _client;
  final WebAuthService _webAuth;

  /// The custom scheme the LinkedIn OAuth hand-off returns on. The backend's
  /// redirect_uri is the https bridge (/api/linkedin/mobile-callback), which
  /// forwards code/state to `plexaverse://oauth/linkedin` — that scheme is
  /// registered natively (AndroidManifest CallbackActivity intent-filter +
  /// iOS CFBundleURLSchemes) so the OS hands control back to the app.
  ///
  /// Was previously 'https', which required verified App/Universal Links that
  /// were never configured — flutter_web_auth_2 could never intercept the
  /// redirect, so every mobile LinkedIn connect silently dead-ended in the
  /// browser (worse after a 2FA bounce into the LinkedIn app).
  /// The custom scheme both OAuth bridges return through. Registered
  /// natively on iOS (CFBundleURLSchemes) and Android (the flutter_web_auth_2
  /// CallbackActivity intent-filter), scheme-only with no host constraint.
  static const String _callbackScheme = 'plexaverse';

  @override
  Future<SignInResult> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.post<Map<String, dynamic>>(
        ApiPaths.login,
        data: <String, dynamic>{'email': email, 'password': password},
        options: AuthInterceptor.skipAuth(),
      );
      final data = response.data;
      if (data == null) return const SignInNetworkFailure();
      return SignInSuccess(tokens: _tokens(data), user: _user(data));
    } on DioException catch (e) {
      final failure = e.error;
      if (failure is AuthFailure || failure is ValidationFailure) {
        return SignInInvalidCredentials(
          message: failure is Failure ? failure.message : null,
        );
      }
      return SignInNetworkFailure(
        message: failure is Failure ? failure.message : null,
      );
    } on Object catch (error, stackTrace) {
      // Non-Dio failure — almost always a payload-shape mismatch while parsing
      // the 2xx body. Surface it (never swallow silently) so a schema drift is
      // debuggable instead of masquerading as a network error.
      debugPrint('ApiAuthRepository.signIn parse failure: $error\n$stackTrace');
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
    try {
      final response = await _client.post<Map<String, dynamic>>(
        ApiPaths.register,
        data: <String, dynamic>{
          'name': name,
          'email': email,
          'password': password,
          // The server refuses a sign-up without these: consent under DPDP s6
          // is an affirmative act, so it is sent explicitly rather than
          // implied by the request existing.
          'acceptedNotice': acceptedNotice,
          'noticeVersion': noticeVersion,
          'consents': consents,
          if (referralCode != null && referralCode.isNotEmpty)
            'referralCode': referralCode,
        },
        options: AuthInterceptor.skipAuth(),
      );
      final data = response.data;
      if (data == null) return const RegisterNetworkFailure();
      return RegisterSuccess(tokens: _tokens(data), user: _user(data));
    } on DioException catch (e) {
      final failure = e.error;
      if (failure is ValidationFailure) {
        return RegisterInvalid(
          message: failure.message,
          fieldErrors: failure.fieldErrors,
        );
      }
      if (failure is AuthFailure) {
        return RegisterInvalid(message: failure.message);
      }
      return RegisterNetworkFailure(
        message: failure is Failure ? failure.message : null,
      );
    } on Object {
      return const RegisterNetworkFailure();
    }
  }

  @override
  Future<GoogleResult> signInWithGoogle() async {
    // The verifier lives HERE, in a local, for the duration of the hand-off.
    // It is single-use and lasts seconds; persisting it would only create
    // something worth stealing.
    final PkcePair pkce = PkcePair.generate();

    try {
      // 1. Ask the server for a finished authorize URL. The app never holds
      //    the Google client id.
      final urlResponse = await _client.post<Map<String, dynamic>>(
        ApiPaths.googleAuthUrl,
        data: <String, dynamic>{
          'codeChallenge': pkce.challenge,
          'codeChallengeMethod': PkcePair.method,
        },
        options: AuthInterceptor.skipAuth(),
      );
      final String? authUrl = urlResponse.data?['authUrl'] as String?;
      final String? issuedState = urlResponse.data?['state'] as String?;
      if (authUrl == null || authUrl.isEmpty || issuedState == null) {
        return const GoogleFailure();
      }

      // 2. System browser. NOT a webview — Google refuses OAuth in embedded
      //    webviews (disallowed_useragent); ASWebAuthenticationSession and
      //    Custom Tabs, which this seam uses, are allowed.
      final result = await _webAuth.authenticate(
        url: authUrl,
        callbackUrlScheme: _callbackScheme,
      );

      switch (result) {
        case WebAuthCancelled():
          return const GoogleCancelled();
        case WebAuthFailure():
          return const GoogleFailure();
        case WebAuthSuccess(:final callbackUrl):
          final Map<String, String> params =
              Uri.parse(callbackUrl).queryParameters;

          // The user pressed Cancel on Google's own screen.
          if (params['error'] == 'access_denied') return const GoogleCancelled();
          if (params['error'] != null) {
            return GoogleFailure(message: params['error_description']);
          }

          final String? code = params['code'];
          final String? state = params['state'];
          if (code == null || code.isEmpty) return const GoogleCancelled();

          // Redundant given PKCE — the server checks this too — but free, and
          // it turns a server rejection into a local abort.
          if (state != issuedState) return const GoogleFailure();

          return _exchange(code: code, state: state!, verifier: pkce.verifier);
      }
    } on DioException catch (e) {
      return GoogleFailure(message: _messageOf(e));
    } on Object {
      return const GoogleFailure();
    }
  }

  Future<GoogleResult> _exchange({
    required String code,
    required String state,
    required String verifier,
  }) async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiPaths.googleExchange,
      data: <String, dynamic>{
        'code': code,
        'state': state,
        'codeVerifier': verifier,
      },
      options: AuthInterceptor.skipAuth(),
    );
    final Map<String, dynamic>? data = response.data;
    if (data == null) return const GoogleFailure();

    // A 200 carrying a discriminator, not an error — see GoogleResult.
    if (data['status'] == 'consent_required') {
      return GoogleConsentRequired(
        signupTicket: data['signupTicket'] as String,
        noticeVersion: data['noticeVersion'] as String,
        profile: _profile(data['profile']),
        purposes: _purposes(data['purposes']),
      );
    }
    return GoogleSignedIn(tokens: _tokens(data), user: _user(data));
  }

  @override
  Future<GoogleResult> completeGoogleSignUp({
    required String signupTicket,
    required String noticeVersion,
    required bool acceptedNotice,
    Map<String, bool> consents = const <String, bool>{},
    String? referralCode,
  }) async {
    try {
      final response = await _client.post<Map<String, dynamic>>(
        ApiPaths.googleComplete,
        data: <String, dynamic>{
          'signupTicket': signupTicket,
          'acceptedNotice': acceptedNotice,
          'noticeVersion': noticeVersion,
          'consents': consents,
          'referralCode': ?referralCode,
        },
        options: AuthInterceptor.skipAuth(),
      );
      final Map<String, dynamic>? data = response.data;
      if (data == null) return const GoogleFailure();
      return GoogleSignedIn(tokens: _tokens(data), user: _user(data));
    } on DioException catch (e) {
      return GoogleFailure(message: _messageOf(e));
    } on Object {
      return const GoogleFailure();
    }
  }

  static GoogleProfile _profile(Object? raw) {
    final Map<String, dynamic> m =
        raw is Map<String, dynamic> ? raw : const <String, dynamic>{};
    return GoogleProfile(
      email: (m['email'] as String?) ?? '',
      name: m['name'] as String?,
      image: m['image'] as String?,
    );
  }

  static List<ConsentPurposeOption> _purposes(Object? raw) {
    if (raw is! List) return const <ConsentPurposeOption>[];
    return raw
        .whereType<Map<String, dynamic>>()
        .map(
          (Map<String, dynamic> m) => ConsentPurposeOption(
            purpose: (m['purpose'] as String?) ?? '',
            label: (m['label'] as String?) ?? '',
            required_: m['required'] == true,
          ),
        )
        .where((ConsentPurposeOption p) => p.purpose.isNotEmpty)
        .toList(growable: false);
  }

  /// The server's own message when it sent one — these routes answer with
  /// copy that is meant to be shown (e.g. the password-account refusal).
  static String? _messageOf(DioException e) {
    final Object? failure = e.error;
    if (failure is Failure) {
      final String? message = failure.message;
      if (message != null && message.isNotEmpty) return message;
    }
    return null;
  }

  @override
  Future<void> signOut() async {
    // Intentionally does nothing on the wire.
    //
    // There is no `/auth/logout` route on the mobile API. This used to POST to
    // one and swallow the resulting 404 on every single sign-out. Sign-out is
    // local: SignOutController clears the session store, which is what
    // actually ends the session — the access token then simply expires.
    //
    // If server-side token revocation is ever wanted, add the route in the web
    // repo first and call it here.
  }

  // --- Parsing helpers -------------------------------------------------------

  AuthTokens _tokens(Map<String, dynamic> data) =>
      AuthTokens.fromJson(_asStringMap(data));

  AuthUser _user(Map<String, dynamic> data) =>
      AuthUser.fromJson(_asStringMap(data['user']));

  /// Coerces a decoded JSON object into `Map<String, dynamic>`.
  ///
  /// A hard `value as Map<String, dynamic>` throws when the decoder hands back
  /// a differently-typed map (`Map<dynamic, dynamic>` / `Map<String, Object?>`)
  /// — which happens once a payload round-trips through the envelope-unwrap
  /// seam or any `Map` re-keying. `Map<String, dynamic>.from` accepts any
  /// `Map` and re-types it, so `fromJson` deserialises reliably.
  static Map<String, dynamic> _asStringMap(Object? value) {
    if (value is Map) return Map<String, dynamic>.from(value);
    throw FormatException('Expected a JSON object, got ${value.runtimeType}');
  }
}

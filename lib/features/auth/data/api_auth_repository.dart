import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../core/network/api_paths.dart';
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
  static const String _linkedInCallbackScheme = 'plexaverse';

  @override
  Future<SignInResult> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.post<Map<String, dynamic>>(
        ApiPaths.login,
        data: <String, dynamic>{'email': email, 'password': password},
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
    String? referralCode,
  }) async {
    try {
      final response = await _client.post<Map<String, dynamic>>(
        ApiPaths.register,
        data: <String, dynamic>{
          'name': name,
          'email': email,
          'password': password,
          if (referralCode != null && referralCode.isNotEmpty)
            'referralCode': referralCode,
        },
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
  Future<LinkedInResult> signInWithLinkedIn() async {
    try {
      // 1. Ask the backend for the provider authorize URL.
      final urlResponse = await _client.post<Map<String, dynamic>>(
        ApiPaths.linkedInAuthUrl,
        data: <String, dynamic>{'type': 'personal'},
      );
      final authUrl = urlResponse.data?['authUrl'] as String?;
      if (authUrl == null || authUrl.isEmpty) {
        return const LinkedInFailure();
      }

      // 2. Launch the browser hand-off via the core web-auth seam.
      final result = await _webAuth.authenticate(
        url: authUrl,
        callbackUrlScheme: _linkedInCallbackScheme,
      );
      switch (result) {
        case WebAuthCancelled():
          return const LinkedInCancelled();
        case WebAuthFailure():
          return const LinkedInFailure();
        case WebAuthSuccess(:final callbackUrl):
          final code = Uri.parse(callbackUrl).queryParameters['code'];
          if (code == null || code.isEmpty) return const LinkedInCancelled();
          // 3. Exchange the authorization code for a session.
          final exchange = await _client.post<Map<String, dynamic>>(
            ApiPaths.linkedInExchange,
            data: <String, dynamic>{'code': code, 'type': 'personal'},
          );
          final data = exchange.data;
          if (data == null) return const LinkedInFailure();
          return LinkedInSuccess(tokens: _tokens(data), user: _user(data));
      }
    } on DioException catch (e) {
      final failure = e.error;
      return LinkedInFailure(
        message: failure is Failure ? failure.message : null,
      );
    } on Object {
      return const LinkedInFailure();
    }
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

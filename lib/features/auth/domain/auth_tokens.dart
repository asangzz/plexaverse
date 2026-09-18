import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_tokens.freezed.dart';
part 'auth_tokens.g.dart';

/// The token pair returned by `POST /auth/login`, `/auth/register` and
/// `/auth/refresh` (see the Plexaverse mobile API — the enveloped
/// `{ data: { accessToken, refreshToken, expiresIn, refreshExpiresIn, user } }`
/// payload is unwrapped by [DioClient] before this deserialises).
///
/// Persisted via `SessionStore.writeTokens`. `expiresIn` (seconds) is optional
/// — opaque tokens without an expiry are treated as valid by `SessionStore`
/// (which parses the JWT `exp` claim when present).
@freezed
abstract class AuthTokens with _$AuthTokens {
  const factory AuthTokens({
    required String accessToken,
    required String refreshToken,
    int? expiresIn,
    int? refreshExpiresIn,
  }) = _AuthTokens;

  factory AuthTokens.fromJson(Map<String, dynamic> json) =>
      _$AuthTokensFromJson(json);
}

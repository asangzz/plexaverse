import 'dart:async';
import 'dart:convert';

import 'package:clock/clock.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'secure_storage.dart';
import 'storage_keys.dart';

part 'session_store.g.dart';

/// Single source of truth for the signed-in session (ProHealth §8, RULINGS
/// ruling 8): access/refresh tokens + the last-activity timestamp live here
/// on top of [SecureStorageService]. The old Drift `SessionsTable` is dropped
/// — nothing else stores the session.
///
/// Consumed by the auth interceptor and the auth feature. Token freshness is
/// validated against the JWT `exp` claim before the interceptor attaches the
/// Authorization header, with a small clock-skew margin.
///
/// ## There is no activity clock here any more
///
/// This used to keep `lastActivityAt` and an `isIdleExpired()` built on it,
/// and the router signed the user out three hours after it. Both are gone —
/// see `authGate` for the reasoning. Two things are worth recording so the
/// idea is not reinvented:
///
/// `touchActivity` was documented as running on every 2xx response. It never
/// did: `AuthInterceptor` has no `onResponse` hook, so the only writers were
/// login and refresh and the timestamp was really `lastTokenWriteAt`. Using
/// the app did not move it. It also cost a secure-storage write on a path
/// that gained nothing from one.
///
/// And the session's boundary is the refresh token, which the server owns.
/// A client-side timer can only end a session EARLY, never extend it, so it
/// can only ever disagree with the server in the one direction that loses the
/// user their login.
///
/// All time reads go through `package:clock` so tests can inject a fixed now.
class SessionStore {
  SessionStore(this._secure);

  final SecureStorageService _secure;


  /// Tokens issued within this margin of expiry are treated as expired so we
  /// refresh proactively rather than relying on a server 401.
  static const Duration _expiryMargin = Duration(seconds: 30);

  Future<String?> accessToken() => _secure.read(StorageKeys.accessToken);
  Future<String?> refreshToken() => _secure.read(StorageKeys.refreshToken);

  /// Returns the access token only when it is non-null and not within
  /// [_expiryMargin] of its `exp` claim. Tokens whose `exp` cannot be parsed
  /// are returned as-is so opaque (non-JWT) tokens still work.
  Future<String?> activeAccessToken() async {
    final token = await accessToken();
    if (token == null) return null;
    final exp = _readJwtExpiry(token);
    if (exp == null) return token;
    if (clock.now().toUtc().add(_expiryMargin).isAfter(exp)) {
      return null;
    }
    return token;
  }

  Future<void> writeTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _secure.write(StorageKeys.accessToken, accessToken);
    await _secure.write(StorageKeys.refreshToken, refreshToken);
  }

  /// Called on sign-out. Wipes tokens + activity; the encrypted DB / media
  /// keys are intentionally NOT cleared here (they survive sign-out so a
  /// re-login on the same device reopens the same encrypted store).
  Future<void> clear() async {
    await _secure.delete(StorageKeys.accessToken);
    await _secure.delete(StorageKeys.refreshToken);
    // Legacy: nothing writes this any more, but installs from before the idle
    // timeout was removed still carry one. Deleted so sign-out leaves nothing.
    await _secure.delete(StorageKeys.lastActivityAt);
  }

  /// Parses the `exp` claim of a JWT. Returns null for non-JWT / malformed
  /// inputs so opaque tokens fall through to the "treat as valid" path.
  static DateTime? _readJwtExpiry(String token) {
    final parts = token.split('.');
    if (parts.length != 3) return null;
    try {
      final padded = _padBase64(parts[1]);
      final json = utf8.decode(base64Url.decode(padded));
      final decoded = jsonDecode(json);
      if (decoded is! Map<String, dynamic>) return null;
      final exp = decoded['exp'];
      if (exp is! num) return null;
      return DateTime.fromMillisecondsSinceEpoch(
        exp.toInt() * 1000,
        isUtc: true,
      );
    } catch (_) {
      return null;
    }
  }

  static String _padBase64(String value) {
    final pad = (4 - value.length % 4) % 4;
    return value + ('=' * pad);
  }
}

@Riverpod(keepAlive: true)
SessionStore sessionStore(Ref ref) {
  return SessionStore(ref.watch(secureStorageProvider));
}

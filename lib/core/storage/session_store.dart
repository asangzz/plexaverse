import 'dart:async';
import 'dart:convert';

import 'package:clock/clock.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../config/app_config.dart';
import 'secure_storage.dart';
import 'storage_keys.dart';

part 'session_store.g.dart';

/// Single source of truth for the signed-in session (ProHealth §8, RULINGS
/// ruling 8): access/refresh tokens + the last-activity timestamp live here
/// on top of [SecureStorageService]. The old Drift `SessionsTable` is dropped
/// — nothing else stores the session.
///
/// Consumed by the auth interceptor and the auth feature. `touchActivity()`
/// is serialised through `_writeLock` (future-identity single-flight) so
/// concurrent 2xx responses can't race to a stale `lastActivityAt`. Token
/// freshness is validated against the JWT `exp` claim before the interceptor
/// attaches the Authorization header, with a small clock-skew margin.
///
/// All time reads go through `package:clock` so tests can inject a fixed now.
class SessionStore {
  SessionStore(this._secure);

  final SecureStorageService _secure;

  Future<void>? _writeLock;

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
    await touchActivity();
  }

  /// Updated on every 2xx response. Serialised so concurrent callers can't
  /// race the timestamp into an inconsistent state.
  Future<void> touchActivity() {
    final previous = _writeLock ?? Future<void>.value();
    final next = previous.then((_) {
      return _secure.write(
        StorageKeys.lastActivityAt,
        clock.now().toUtc().toIso8601String(),
      );
    });
    _writeLock = next.whenComplete(() {
      if (identical(_writeLock, next)) _writeLock = null;
    });
    return next;
  }

  Future<DateTime?> lastActivityAt() async {
    final raw = await _secure.read(StorageKeys.lastActivityAt);
    if (raw == null) return null;
    return DateTime.tryParse(raw);
  }

  /// True when the last successful API call is older than the configured idle
  /// timeout (§8). Drives the router idle-redirect.
  Future<bool> isIdleExpired() async {
    final last = await lastActivityAt();
    if (last == null) return false;
    return clock.now().toUtc().difference(last) > AppConfig.idleTimeout;
  }

  /// Called on sign-out. Wipes tokens + activity; the encrypted DB / media
  /// keys are intentionally NOT cleared here (they survive sign-out so a
  /// re-login on the same device reopens the same encrypted store).
  Future<void> clear() async {
    await _secure.delete(StorageKeys.accessToken);
    await _secure.delete(StorageKeys.refreshToken);
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

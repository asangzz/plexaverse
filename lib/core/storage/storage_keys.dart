import '../config/app_config.dart';

/// Centralised storage keys. Call sites read from here rather than embedding
/// raw string literals (ProHealth §2.5 `hardcoded_storage_key` convention).
///
/// Key naming pattern for NEW keys is `app.<domain>.<name>` (the ProHealth
/// idiom). The auth token / user-id VALUES are deliberately delegated to
/// [AppConfig] so they keep the pre-migration Plexaverse literals
/// (`access_token`, `refresh_token`, `user_id`) — existing installs keep
/// their persisted session across the restructure (see AppConfig comment).
class StorageKeys {
  const StorageKeys._();

  // -- SharedPreferences-style app state -------------------------------------
  static const String tenantKey = 'app.tenant.key';
  static const String lastSuccessfulSync = 'app.sync.last_success_at';

  // -- flutter_secure_storage — auth (values inherited from AppConfig) -------
  static const String accessToken = AppConfig.accessTokenKey;
  static const String refreshToken = AppConfig.refreshTokenKey;
  static const String userId = AppConfig.userIdKey;

  /// Last successful-activity timestamp, drives the idle-expiry redirect.
  static const String lastActivityAt = 'app.auth.last_activity_at';

  // -- flutter_secure_storage — at-rest encryption keys ----------------------

  /// 256-bit SQLCipher key for the encrypted Drift database (§8/§9). Held as
  /// 64 lowercase hex chars; regenerated if missing/invalid.
  static const String driftEncryptionKey = 'app.db.encryption_key';

  /// AES-256-GCM key for the at-rest media cache (§8). Deliberately distinct
  /// from [driftEncryptionKey] so a compromise of one doesn't disclose the
  /// other.
  static const String mediaEncryptionKey = 'app.media.encryption_key';
}

/// Global, non-flavor configuration. Values that vary per build flavor are
/// derived from [Env] (base URLs live in `ApiEnvironment`, mock selection in
/// `useFakeBackendProvider`). Everything else — timeouts, retry counts,
/// storage keys — lives here so call sites don't carry literals.
class AppConfig {
  const AppConfig._();

  static const String appName = 'Plexaverse';

  // -- Network tunables ------------------------------------------------------

  /// Dio connect timeout. 30s is generous on purpose: the dev backend can
  /// cold-start slowly, and the offline gate fast-fails before Dio ever
  /// waits this long when connectivity is known-down.
  static const Duration connectTimeout = Duration(seconds: 30);

  /// Dio receive timeout, matching [connectTimeout].
  static const Duration receiveTimeout = Duration(seconds: 30);

  /// Maximum attempts for retryable requests. Retry UX is owned by the app
  /// (Riverpod auto-retry is disabled in bootstrap), so this is the single
  /// knob for any explicit retry loop.
  static const int maxRetries = 3;

  // -- Session / storage / sync tunables -------------------------------------

  /// Idle window after which the router forces a re-auth / app unlock.
  /// Read by `SessionStore.isIdleExpired()` against `lastActivityAt`
  /// (ProHealth §8). 3h mirrors the reference default.
  static const Duration idleTimeout = Duration(hours: 3);

  /// How long an encrypted media blob may live in the on-disk cache before
  /// the boot-time `MediaCacheSweeper` is allowed to evict it — provided its
  /// `jobId` is not still referenced by a queued `SyncQueue.batchId`
  /// (ProHealth §7.7 / §11.2). 30 days mirrors the reference default.
  static const Duration mediaRetention = Duration(days: 30);

  /// Target cadence for background sync. Declared for parity with the
  /// reference (§7.8); no WorkManager/BGAppRefresh wiring exists yet — the
  /// `SyncEngine` drains in-process (resume-drain + connectivity-drain). Kept
  /// as documentation of intent so a later background-task phase has a knob.
  static const Duration backgroundSyncInterval = Duration(minutes: 15);

  // -- Storage keys ----------------------------------------------------------
  //
  // Key VALUES deliberately match the pre-migration Plexaverse literals so
  // existing installs keep their persisted session / preferences across the
  // restructure.

  /// flutter_secure_storage — access token (SessionStore).
  static const String accessTokenKey = 'access_token';

  /// flutter_secure_storage — refresh token (SessionStore).
  static const String refreshTokenKey = 'refresh_token';

  /// flutter_secure_storage — signed-in user id (SessionStore).
  static const String userIdKey = 'user_id';

  /// SharedPreferences — persisted theme mode (5-mode switcher, default dark).
  static const String themeModeKey = 'theme_mode';

  /// SharedPreferences — persisted locale (en/es/fr LocaleNotifier).
  static const String localeKey = 'locale';

  /// SharedPreferences — onboarding-completed flag read by the router
  /// redirect (splash → onboarding → login → home).
  static const String onboardingKey = 'onboarding_done';
}

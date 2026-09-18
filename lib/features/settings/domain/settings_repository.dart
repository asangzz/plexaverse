import 'dart:ui' show Locale;

import 'package:plexaverse/core/theme/app_theme_mode.dart';
import 'settings_profile.dart';
import 'subscription_info.dart';

export 'settings_profile.dart';
export 'subscription_info.dart';

/// Thrown when the profile header can't be loaded (fixture missing/corrupt or,
/// in a future API-backed build, transport failure). The Settings screen maps
/// it to a compact retry — theme/locale controls stay usable regardless, since
/// they are local-only and never depend on this fetch.
class SettingsProfileUnavailable implements Exception {
  const SettingsProfileUnavailable();
}

/// Thrown when the subscription snapshot can't be loaded (fixture missing/
/// corrupt or, in a future billing-API build, transport failure). The
/// Account page and Subscription sheet map it to a compact inline retry.
class SubscriptionInfoUnavailable implements Exception {
  const SubscriptionInfoUnavailable();
}

/// Seam between the Settings module and its storage.
///
/// Settings is **local-only**: theme mode and locale persist to
/// `SharedPreferences` (a preference, not a secret — same store ProHealth uses
/// for `BiometricPrefs`). The profile header is display data read from the
/// bundled mock fixture. There is no real backend for this feature in v1, so a
/// single prefs-backed implementation ([PrefsSettingsRepository]) serves every
/// flavor; the fixture read is gated only by asset availability.
abstract class SettingsRepository {
  /// The persisted theme mode, defaulting to [AppThemeMode.dark] when nothing
  /// has been stored (Plexaverse default-dark ruling).
  Future<AppThemeMode> loadThemeMode();

  /// Persist the chosen theme mode.
  Future<void> saveThemeMode(AppThemeMode mode);

  /// The persisted locale, defaulting to `en` when nothing has been stored.
  Future<Locale> loadLocale();

  /// Persist the chosen locale (stored by `languageCode`: en/es/fr).
  Future<void> saveLocale(Locale locale);

  /// The profile display bits shown in the Settings header.
  Future<SettingsProfile> fetchProfile();

  /// The plan + quota snapshot shown on the Account page (2374) and in the
  /// Subscription sheet (2375). Fixture-backed in v1, like [fetchProfile].
  Future<SubscriptionInfo> fetchSubscription();
}

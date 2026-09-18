import 'dart:ui' show Locale;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/config/app_config.dart';
import '../../../core/mock/mock_api.dart';
import 'package:plexaverse/core/theme/app_theme_mode.dart';
import '../domain/settings_repository.dart';

const String _kProfileAsset = 'assets/mock/settings/profile.json';
const String _kSubscriptionAsset = 'assets/mock/settings/subscription.json';

/// The only [SettingsRepository] implementation: theme mode + locale persist to
/// `SharedPreferences`, the profile header comes from the bundled fixture.
///
/// Unlike the network-backed features there is no Api/Fake split — Settings is
/// local-only in v1, so the same store serves mock / dev / staging / prod. The
/// key VALUES come from [AppConfig] so they match the pre-migration Plexaverse
/// literals (`theme_mode`, `locale`) and existing installs keep their
/// preference across the restructure.
class PrefsSettingsRepository implements SettingsRepository {
  const PrefsSettingsRepository();

  @override
  Future<AppThemeMode> loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(AppConfig.themeModeKey);
    if (saved == null) return AppThemeMode.dark;
    // Unknown/legacy value falls back to the default-dark ruling rather than
    // throwing — a corrupt pref must never brick the theme.
    return AppThemeMode.values.firstWhere(
      (e) => e.name == saved,
      orElse: () => AppThemeMode.dark,
    );
  }

  @override
  Future<void> saveThemeMode(AppThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConfig.themeModeKey, mode.name);
  }

  @override
  Future<Locale> loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(AppConfig.localeKey);
    if (saved == null) return const Locale('en');
    return Locale(saved);
  }

  @override
  Future<void> saveLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConfig.localeKey, locale.languageCode);
  }

  @override
  Future<SettingsProfile> fetchProfile() async {
    try {
      final json = await MockApi.loadObject(_kProfileAsset);
      return SettingsProfile.fromJson(json);
    } on Object {
      throw const SettingsProfileUnavailable();
    }
  }

  @override
  Future<SubscriptionInfo> fetchSubscription() async {
    try {
      final json = await MockApi.loadObject(_kSubscriptionAsset);
      return SubscriptionInfo.fromJson(json);
    } on Object {
      throw const SubscriptionInfoUnavailable();
    }
  }
}

/// Local-only feature, so a single implementation regardless of flavor. Kept as
/// a provider (not a bare `const`) so tests can `overrideWithValue` a fake and
/// so the mock/real switch can be introduced later without touching call sites.
final settingsRepositoryProvider = Provider<SettingsRepository>(
  (ref) => const PrefsSettingsRepository(),
);

import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:plexaverse/core/theme/app_theme_mode.dart';
import '../data/settings_repositories.dart';

part 'theme_controller.g.dart';

/// Owns the app-wide theme mode (5-mode switcher, **default dark**).
///
/// Ported from `lib/presentation/features/settings/providers/theme_provider.dart`
/// with the behaviour preserved exactly: `build()` returns [AppThemeMode.dark]
/// synchronously and kicks off an async load of the persisted value, so the
/// first frame is dark (Plexaverse default-dark ruling) and flips only if a
/// different mode was saved. Persistence moved behind [SettingsRepository]
/// (prefs-backed) instead of reading `SharedPreferences` inline, per the
/// feature-slice convention.
///
/// The root app widget (`bootstrap/plexaverse_app.dart`) watches this provider
/// (generated name `themeNotifierProvider`) to drive `MaterialApp.themeMode`
/// and pick between `AppTheme.dark/light/highContrastLight/highContrastDark`.
@Riverpod(keepAlive: true)
class ThemeNotifier extends _$ThemeNotifier {
  @override
  AppThemeMode build() {
    // Fire-and-forget the persisted read; the synchronous default keeps the
    // first frame dark. Matches the pre-migration `Future(_loadTheme)` idiom.
    Future(_load);
    return AppThemeMode.dark;
  }

  Future<void> _load() async {
    final mode = await ref.read(settingsRepositoryProvider).loadThemeMode();
    if (ref.mounted) state = mode;
  }

  /// Set and persist the theme mode (optimistic — the UI flips immediately).
  Future<void> setTheme(AppThemeMode mode) async {
    state = mode;
    await ref.read(settingsRepositoryProvider).saveThemeMode(mode);
  }

  /// Quick light/dark toggle (kept from the legacy notifier).
  void toggle() => setTheme(
        state == AppThemeMode.light ? AppThemeMode.dark : AppThemeMode.light,
      );
}

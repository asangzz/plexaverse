// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
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

@ProviderFor(ThemeNotifier)
final themeProvider = ThemeNotifierProvider._();

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
final class ThemeNotifierProvider
    extends $NotifierProvider<ThemeNotifier, AppThemeMode> {
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
  ThemeNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'themeProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$themeNotifierHash();

  @$internal
  @override
  ThemeNotifier create() => ThemeNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppThemeMode value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppThemeMode>(value),
    );
  }
}

String _$themeNotifierHash() => r'789eaac2e0ae574ba0b8e518a29240bf72f1e56c';

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

abstract class _$ThemeNotifier extends $Notifier<AppThemeMode> {
  AppThemeMode build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AppThemeMode, AppThemeMode>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AppThemeMode, AppThemeMode>,
              AppThemeMode,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

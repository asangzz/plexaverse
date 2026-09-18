// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'locale_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Owns the app-wide locale (en / es / fr), persisted across launches.
///
/// Ported from `lib/presentation/features/settings/providers/locale_provider.dart`
/// with behaviour preserved: `build()` returns `en` synchronously and kicks off
/// an async load of the saved `languageCode`. Persistence moved behind
/// [SettingsRepository] (prefs-backed) per the feature-slice convention.
///
/// The root app widget (`bootstrap/plexaverse_app.dart`) watches this provider
/// (generated name `localeNotifierProvider`) to drive `MaterialApp.locale`.

@ProviderFor(LocaleNotifier)
final localeProvider = LocaleNotifierProvider._();

/// Owns the app-wide locale (en / es / fr), persisted across launches.
///
/// Ported from `lib/presentation/features/settings/providers/locale_provider.dart`
/// with behaviour preserved: `build()` returns `en` synchronously and kicks off
/// an async load of the saved `languageCode`. Persistence moved behind
/// [SettingsRepository] (prefs-backed) per the feature-slice convention.
///
/// The root app widget (`bootstrap/plexaverse_app.dart`) watches this provider
/// (generated name `localeNotifierProvider`) to drive `MaterialApp.locale`.
final class LocaleNotifierProvider
    extends $NotifierProvider<LocaleNotifier, Locale> {
  /// Owns the app-wide locale (en / es / fr), persisted across launches.
  ///
  /// Ported from `lib/presentation/features/settings/providers/locale_provider.dart`
  /// with behaviour preserved: `build()` returns `en` synchronously and kicks off
  /// an async load of the saved `languageCode`. Persistence moved behind
  /// [SettingsRepository] (prefs-backed) per the feature-slice convention.
  ///
  /// The root app widget (`bootstrap/plexaverse_app.dart`) watches this provider
  /// (generated name `localeNotifierProvider`) to drive `MaterialApp.locale`.
  LocaleNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'localeProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$localeNotifierHash();

  @$internal
  @override
  LocaleNotifier create() => LocaleNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Locale value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Locale>(value),
    );
  }
}

String _$localeNotifierHash() => r'0781de433b7ed8f5d010fd60163cd6769bb32013';

/// Owns the app-wide locale (en / es / fr), persisted across launches.
///
/// Ported from `lib/presentation/features/settings/providers/locale_provider.dart`
/// with behaviour preserved: `build()` returns `en` synchronously and kicks off
/// an async load of the saved `languageCode`. Persistence moved behind
/// [SettingsRepository] (prefs-backed) per the feature-slice convention.
///
/// The root app widget (`bootstrap/plexaverse_app.dart`) watches this provider
/// (generated name `localeNotifierProvider`) to drive `MaterialApp.locale`.

abstract class _$LocaleNotifier extends $Notifier<Locale> {
  Locale build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Locale, Locale>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Locale, Locale>,
              Locale,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

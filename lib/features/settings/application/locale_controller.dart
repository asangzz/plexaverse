import 'dart:ui';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/settings_repositories.dart';

part 'locale_controller.g.dart';

/// Owns the app-wide locale (en / es / fr), persisted across launches.
///
/// Ported from `lib/presentation/features/settings/providers/locale_provider.dart`
/// with behaviour preserved: `build()` returns `en` synchronously and kicks off
/// an async load of the saved `languageCode`. Persistence moved behind
/// [SettingsRepository] (prefs-backed) per the feature-slice convention.
///
/// The root app widget (`bootstrap/plexaverse_app.dart`) watches this provider
/// (generated name `localeNotifierProvider`) to drive `MaterialApp.locale`.
@Riverpod(keepAlive: true)
class LocaleNotifier extends _$LocaleNotifier {
  /// The locales the app ships copy for. Mirrors `AppL10n.supportedLocales`
  /// and the finalized `lib/l10n/app_{en,es,fr}.arb` set.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('fr'),
  ];

  @override
  Locale build() {
    Future(_load);
    return const Locale('en');
  }

  Future<void> _load() async {
    final locale = await ref.read(settingsRepositoryProvider).loadLocale();
    if (ref.mounted) state = locale;
  }

  /// Set and persist the locale (optimistic — the UI switches immediately).
  Future<void> setLocale(Locale locale) async {
    state = locale;
    await ref.read(settingsRepositoryProvider).saveLocale(locale);
  }
}

import 'package:flutter/material.dart';

import 'app_feature.dart';

/// Per-tenant configuration. Hardcoded in [TenantCatalogue]. After AOT
/// compilation, values are embedded as native code and string literals —
/// no JSON file ships in the bundle (RULINGS §11).
///
/// Once freezed is wired, this may become `@freezed`. Hand-rolled for now so
/// the project compiles before `build_runner` is run (mirrors ProHealth's
/// freezed-pending convention).
@immutable
class TenantConfig {
  const TenantConfig({
    required this.key,
    required this.displayName,
    required this.apiBaseUrl,
    required this.theme,
    required this.assets,
    required this.features,
  });

  /// Customer key string, e.g. `"plexaverse"`. Normalised (trim+lowercase)
  /// on lookup.
  final String key;

  /// User-facing tenant name, e.g. `"Plexaverse"`.
  final String displayName;

  /// Per-tenant backend root URL.
  final String apiBaseUrl;

  /// Material 3 light + dark schemes.
  final TenantTheme theme;

  /// Paths to bundled images under `assets/tenants/<key>/`.
  final TenantAssets assets;

  /// `Map<AppFeature, bool>` listing every [AppFeature] with explicit
  /// true/false. [validateTenantFeatureMatrix] fails at startup if any value
  /// is missing.
  final Map<AppFeature, bool> features;

  bool isEnabled(AppFeature feature) => features[feature] ?? false;
}

@immutable
class TenantTheme {
  const TenantTheme({required this.light, required this.dark});

  final ColorScheme light;
  final ColorScheme dark;
}

@immutable
class TenantAssets {
  const TenantAssets({
    required this.logo,
    required this.logoDark,
    required this.splash,
    required this.loginBanner,
  });

  final String logo;
  final String logoDark;
  final String splash;
  final String loginBanner;
}

import '../theme/plexaverse_colors.dart';
import 'app_feature.dart';
import 'tenant_config.dart';

/// Hardcoded tenant catalogue (RULINGS §11).
///
/// Plexaverse ships a single **plexaverse** tenant so the multi-tenant
/// machinery ([TenantController], [FeatureGate], per-tenant theming + base
/// URL) stays fully exercisable without a tenant-selection screen. Add real
/// tenants by:
///   1. add the [AppFeature] value(s) if needed,
///   2. bundle assets under `assets/tenants/<key>/` and list them in pubspec,
///   3. add a [TenantConfig] entry below declaring every [AppFeature].
///
/// Config is compile-time (AOT-embedded) — no JSON in the bundle.
class TenantCatalogue {
  const TenantCatalogue._();

  /// Auto-selected on first launch by `bootstrap.dart` so the single-tenant
  /// build boots straight to onboarding / login with no tenant gate.
  static const String defaultKey = 'plexaverse';

  static final Map<String, TenantConfig> _tenants = <String, TenantConfig>{
    'plexaverse': TenantConfig(
      key: 'plexaverse',
      displayName: 'Plexaverse',
      // Live API. Flavored builds still route through ApiEnvironment for the
      // dev/staging/mock base URLs; this is the tenant's canonical prod root.
      apiBaseUrl: 'https://www.plexaverse.com/api/mobile/v1',
      // The Plexaverse brand schemes (violet #6C63FF, dark-default). Real
      // additional tenants would override with their own schemes.
      theme: TenantTheme(
        light: PlexaversePalette.lightScheme,
        dark: PlexaversePalette.darkScheme,
      ),
      assets: const TenantAssets(
        logo: 'assets/tenants/plexaverse/logo.png',
        logoDark: 'assets/tenants/plexaverse/logo_dark.png',
        splash: 'assets/tenants/plexaverse/splash.png',
        loginBanner: 'assets/tenants/plexaverse/login_banner.png',
      ),
      // Every AppFeature must be present with an explicit value — a missing
      // entry silently means "off" (see TenantConfig.isEnabled) and is what
      // validateTenantFeatureMatrix() exists to catch.
      features: const <AppFeature, bool>{
        AppFeature.posts: true,
        AppFeature.odyssey: true,
        AppFeature.analytics: true,
        AppFeature.studio: true,
        AppFeature.schedule: true,
        AppFeature.notifications: true,
        AppFeature.referrals: true,
      },
    ),
  };

  static TenantConfig? lookup(String key) => _tenants[key.trim().toLowerCase()];

  static Iterable<String> get knownKeys => _tenants.keys;

  /// True when the catalogue ships with no entries. Used by
  /// [TenantController.restore] to treat "stored key but empty catalogue" as
  /// "don't know yet" rather than wiping the persisted key.
  static bool get isEmpty => _tenants.isEmpty;
}

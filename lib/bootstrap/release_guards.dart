import '../core/config/env.dart';
import '../core/logging/app_logger.dart';
import '../core/security/jailbreak_detector.dart';
import '../core/tenant/catalogue.dart';
import '../core/tenant/tenant_controller.dart';

/// Assert that every tenant declares a value for every `AppFeature`. Run
/// inside an `assert(() { … }())` so it's compiled out of release. A missing
/// entry silently means "feature off" via `TenantConfig.isEnabled`'s null
/// fallback — exactly the drift the §11 rule exists to prevent.
void assertTenantCatalogueComplete() {
  final missing = validateTenantFeatureMatrix();
  if (missing.isEmpty) return;
  throw StateError(
    'Tenant catalogue is missing AppFeature entries: $missing',
  );
}

/// Trip-wire for the release-blocking placeholders flagged in the audit
/// (Talsec RASP config, tenant base URLs). Runs as a real check (NOT an
/// assert) so prod builds refuse to boot with placeholders, while non-prod
/// flavors skip it (RULINGS §12).
void assertReleaseConfigSane(Env env, AppLogger logger) {
  if (env != Env.prod) return;
  _assertTalsecConfigured(logger);
  _assertTenantUrlsConfigured(logger);
}

void _assertTalsecConfigured(AppLogger logger) {
  final config = buildTalsecConfig();
  final hasPlaceholderCert = config.androidConfig?.signingCertHashes.any(
        (hash) => hash.contains('REPLACE_WITH'),
      ) ??
      false;
  final hasPlaceholderTeam =
      config.iosConfig?.teamId.contains('REPLACE_WITH') ?? false;
  if (!hasPlaceholderCert && !hasPlaceholderTeam) return;
  const message =
      'Refusing to boot prod with placeholder Talsec config. '
      'Set real signingCertHashes / teamId (and register watcherMail at '
      'talsec.app) in core/security/jailbreak_detector.dart.';
  logger.error(message);
  throw StateError(message);
}

void _assertTenantUrlsConfigured(AppLogger logger) {
  final placeholders = <String>[];
  for (final key in TenantCatalogue.knownKeys) {
    final tenant = TenantCatalogue.lookup(key);
    if (tenant == null) continue;
    // Placeholder markers a real deployment would never contain.
    if (tenant.apiBaseUrl.contains('.example.') ||
        tenant.apiBaseUrl.contains('REPLACE_WITH')) {
      placeholders.add('$key=${tenant.apiBaseUrl}');
    }
  }
  if (placeholders.isEmpty) return;
  final message =
      'Refusing to boot prod with placeholder tenant API URLs: '
      '$placeholders. Update core/tenant/catalogue.dart with the real '
      'per-tenant apiBaseUrl values.';
  logger.error(message);
  throw StateError(message);
}

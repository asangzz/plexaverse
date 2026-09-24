import 'package:flutter/foundation.dart';

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
  // Debug builds are exempt, and the condition is `kDebugMode` rather than
  // `!kReleaseMode` on purpose: it is exactly the condition freeRASP itself
  // is configured with (`isProd: !kDebugMode`). In debug the integrity checks
  // do not run at all, so refusing to boot over their configuration blocks a
  // developer from pointing the app at production — which is an ordinary
  // thing to do and the only way to debug against it — while protecting
  // nothing. Profile builds are NOT exempt: freeRASP is live there.
  if (kDebugMode) return;
  _assertTalsecConfigured(logger);
  _assertTenantUrlsConfigured(logger);
}

void _assertTalsecConfigured(AppLogger logger) {
  final config = buildTalsecConfig();

  // Checked for the platform this build RUNS on, not across both halves.
  //
  // The two halves describe two different artifacts: an Android APK has no
  // Apple team id to set and an iOS build has no Android signing cert. Testing
  // both meant the Apple placeholder — which an Android release can never
  // fill in, because there is nothing to fill it in with — refused to boot a
  // correctly configured Android prod build. The guard is meant to stop a
  // release shipping with its own integrity checks unconfigured, not to hold
  // one platform hostage to the other's rollout.
  final bool isIOS = defaultTargetPlatform == TargetPlatform.iOS;
  final bool placeholder = isIOS
      ? config.iosConfig?.teamId.contains('REPLACE_WITH') ?? false
      : config.androidConfig?.signingCertHashes.any(
              (String hash) => hash.contains('REPLACE_WITH'),
            ) ??
            false;
  if (!placeholder) return;

  final String message = isIOS
      ? 'Refusing to boot prod with a placeholder Apple team id. Set the real '
            'teamId (and register watcherMail at talsec.app) in '
            'core/security/jailbreak_detector.dart.'
      : 'Refusing to boot prod with a placeholder signing cert hash. Pass the '
            'real one at build time: '
            '--dart-define=ANDROID_SIGNING_CERT_SHA256=<base64 of the 32 raw '
            'bytes of the certificate SHA-256>.';
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

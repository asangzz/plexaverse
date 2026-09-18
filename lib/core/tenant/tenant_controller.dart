import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../storage/storage_keys.dart';
import 'app_feature.dart';
import 'catalogue.dart';
import 'tenant_config.dart';

part 'tenant_controller.g.dart';

/// Holds the resolved tenant (`null` until resolved from the catalogue on
/// first launch). Persisted via SharedPreferences — wiped on uninstall on
/// both platforms.
///
/// The customer key is a routing identifier, not a credential, so it does
/// NOT live in flutter_secure_storage (RULINGS §11).
@Riverpod(keepAlive: true)
class TenantController extends _$TenantController {
  @override
  TenantConfig? build() => null;

  /// Called once from `bootstrap()` before the first frame so the router
  /// can read the resolved tenant on initial navigation. For the single
  /// `plexaverse` tenant, bootstrap seeds the default key when none is
  /// stored, then calls this.
  ///
  /// The catalogue lookup runs before the prefs delete so a transient
  /// failure (e.g. catalogue regenerating in the same release train)
  /// doesn't blow away a real key by mistake. We only wipe when the lookup
  /// deterministically returns null AND the catalogue actually loaded —
  /// empty catalogues are treated as "don't know" and kept.
  Future<void> restore() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(StorageKeys.tenantKey);
    if (stored == null) return;
    if (TenantCatalogue.isEmpty) return;
    final config = TenantCatalogue.lookup(stored);
    if (config == null) {
      await prefs.remove(StorageKeys.tenantKey);
      return;
    }
    state = config;
  }

  /// Returns true on success, false when the key is not in the catalogue.
  Future<bool> setKey(String key) async {
    final config = TenantCatalogue.lookup(key);
    if (config == null) return false;
    final prefs = await SharedPreferences.getInstance();
    // Write to disk first; if the write fails an exception propagates and
    // we don't update in-memory state, so a subsequent `restore()` won't
    // disagree with what's actually persisted.
    await prefs.setString(StorageKeys.tenantKey, config.key);
    state = config;
    return true;
  }

  /// Reserved for a future "switch tenant" flow. The current single-tenant
  /// policy preserves the tenant across sign-out.
  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(StorageKeys.tenantKey);
    state = null;
  }
}

/// Resolved tenant config. Throws if accessed before resolution — every
/// post-tenant-gate provider depends on this, and bootstrap guarantees the
/// tenant is set before the first frame (RULINGS §11).
@Riverpod(keepAlive: true)
TenantConfig tenantConfig(Ref ref) {
  final tenant = ref.watch(tenantControllerProvider);
  if (tenant == null) {
    throw StateError(
      'tenantConfigProvider read before tenant resolution. '
      'bootstrap() must resolve the tenant before the first frame.',
    );
  }
  return tenant;
}

/// Single answer to "is this feature on for the current tenant?" (RULINGS
/// §11). Every gate in the app reads from this.
@Riverpod(keepAlive: true)
bool isFeatureEnabled(Ref ref, AppFeature feature) {
  return ref.watch(tenantConfigProvider).isEnabled(feature);
}

/// Sanity-check that runs at startup. Every tenant must declare an explicit
/// true/false for every [AppFeature] value — a missing entry silently means
/// "off" via `isEnabled`'s null fallback, which is exactly the kind of
/// drift the §11 rule exists to prevent.
///
/// Returns the list of `tenantKey:feature` pairs missing from the catalogue.
/// Caller (bootstrap, in an assert) decides whether to crash.
List<String> validateTenantFeatureMatrix() {
  final missing = <String>[];
  for (final key in TenantCatalogue.knownKeys) {
    final config = TenantCatalogue.lookup(key);
    if (config == null) continue;
    for (final feature in AppFeature.values) {
      if (!config.features.containsKey(feature)) {
        missing.add('$key:${feature.name}');
      }
    }
  }
  return missing;
}

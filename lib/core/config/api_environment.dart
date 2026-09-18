import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'env.dart';

part 'api_environment.g.dart';

/// Single source of truth for the API base URL per environment.
///
/// Going live is config-only: set the real dev/staging URLs in
/// [_defaults] (or pass `--dart-define=API_BASE_URL=…` for a one-off /
/// CI override), and run the matching flavor (`main_dev` / `main_staging`
/// / `main_prod`). The flavor sets [Env], which selects the URL here and —
/// via `useFakeBackendProvider` — whether the real Dio repositories or the
/// bundled mock fixtures are used.
///
/// Base URL is intentionally env-derived (not per-tenant) for this
/// single-brand app; `TenantConfig` carries no API URL.
class ApiEnvironment {
  const ApiEnvironment._();

  /// Build-time override. Highest priority so CI / ad-hoc builds can point
  /// at any backend without code changes:
  /// `flutter run --dart-define=API_BASE_URL=https://…`.
  static const String _override = String.fromEnvironment('API_BASE_URL');

  /// Per-flavor base URLs.
  ///   mock    — unused (fake repos don't hit the network); kept valid as a
  ///             fallback so the Dio client always has a base.
  ///   dev     — the LOCAL backend. `10.0.2.2` is the Android emulator's
  ///             alias for the host machine; on a physical device override
  ///             with the host's LAN IP:
  ///             `--dart-define=API_BASE_URL=http://192.168.x.x:8443/api/mobile/v1`.
  ///   staging — placeholder until a staging deployment exists; release
  ///             guards refuse a prod boot on placeholder config, and the
  ///             staging flavor is dev-team-only.
  ///   prod    — the live API.
  static const Map<Env, String> _defaults = <Env, String>{
    Env.mock: 'http://localhost:8443/api/mobile/v1',
    Env.dev: 'https://dfy-plexaverse-lrthghbmsq-uc.a.run.app/api/mobile/v1', //'http://10.0.2.2:8443/api/mobile/v1',
    Env.staging: 'https://staging.plexaverse.com/api/mobile/v1',
    Env.prod: 'https://www.plexaverse.com/api/mobile/v1',
  };

  static String baseUrlFor(Env env) =>
      _override.isNotEmpty ? _override : _defaults[env]!;
}

/// The resolved API base URL for the current build. Consumed by the Dio
/// clients.
@Riverpod(keepAlive: true)
String apiBaseUrl(Ref ref) => ApiEnvironment.baseUrlFor(ref.watch(envProvider));

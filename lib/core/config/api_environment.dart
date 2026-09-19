import 'package:flutter/foundation.dart';
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
  ///
  ///   mock    — unused (fake repos don't hit the network); kept valid as a
  ///             fallback so the Dio client always has a base.
  ///   dev     — YOUR LOCAL Next.js server (`npm run dev`, port 3000). See
  ///             [_localDev] for why the host differs on Android.
  ///   staging — the SAME deployment prod uses, reached directly at its Cloud
  ///             Run origin instead of through the public domain. There is no
  ///             separate staging service, so this is not a third environment
  ///             — it is prod with Cloudflare taken out of the path, which is
  ///             what you want when diagnosing whether an edge rule is the
  ///             thing breaking a request.
  ///   prod    — the live API on the public domain.
  static String _defaultFor(Env env) => switch (env) {
        Env.mock => 'http://localhost:3000/api/mobile/v1',
        Env.dev => _localDev,
        Env.staging =>
          'https://dfy-plexaverse-lrthghbmsq-uc.a.run.app/api/mobile/v1',
        Env.prod => 'https://www.plexaverse.com/api/mobile/v1',
      };

  /// The local Next.js dev server, addressed the way each platform can reach it.
  ///
  /// `localhost` inside the Android emulator is the EMULATOR, not your Mac —
  /// `10.0.2.2` is its alias for the host loopback. The iOS simulator shares
  /// the host's network stack, so plain `localhost` is correct there. Getting
  /// this wrong produces a connection-refused that looks exactly like a server
  /// that is not running.
  ///
  /// On a PHYSICAL device neither works: pass your Mac's LAN address, e.g.
  /// `--dart-define=API_BASE_URL=http://192.168.1.16:3000/api/mobile/v1`.
  ///
  /// This is cleartext HTTP on purpose — it is localhost. iOS ATS and Android
  /// cleartext policy both block that by default, so each platform carries a
  /// LOCALHOST-ONLY exception (see ios/Runner/Info.plist and
  /// android/app/src/main/res/xml/network_security_config.xml). Neither
  /// exception permits cleartext to any other host.
  static String get _localDev => defaultTargetPlatform == TargetPlatform.android
      ? 'http://10.0.2.2:3000/api/mobile/v1'
      : 'http://localhost:3000/api/mobile/v1';

  static String baseUrlFor(Env env) =>
      _override.isNotEmpty ? _override : _defaultFor(env);
}

/// The resolved API base URL for the current build. Consumed by the Dio
/// clients.
@Riverpod(keepAlive: true)
String apiBaseUrl(Ref ref) => ApiEnvironment.baseUrlFor(ref.watch(envProvider));

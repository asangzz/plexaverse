import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'env.g.dart';

/// Build-time flavor. Selects the API the app talks to (see
/// `ApiEnvironment`) and whether the in-memory mocks or the real Dio
/// repositories are used (see [useFakeBackend]).
///
///   mock    — bundled JSON fixtures (assets/mock/), no backend needed
///   dev     — the local backend on your machine
///   staging — the staging API
///   prod    — the live plexaverse.com API
enum Env { mock, dev, staging, prod }

/// Overridden in `bootstrap()` from the flavored entry point.
@Riverpod(keepAlive: true)
Env env(Ref ref) {
  throw StateError('envProvider not overridden — bootstrap() must set it.');
}

/// True when the app should resolve fake / in-memory backend
/// implementations instead of hitting a real API. Drives the
/// `Fake* / Api*` selection in repository providers.
///
/// True only for the **mock** flavor — dev / staging / prod all talk to a
/// real API (just different base URLs). Override in tests by re-overriding
/// `envProvider` or this provider directly.
///
/// A build-time escape hatch can force either way without changing flavor
/// (e.g. point the dev flavor at the mocks, or the mock flavor at a real
/// API for a one-off):
///   --dart-define=USE_FAKE_BACKEND=true|false
@Riverpod(keepAlive: true)
bool useFakeBackend(Ref ref) {
  const override = String.fromEnvironment('USE_FAKE_BACKEND');
  if (override == 'true') return true;
  if (override == 'false') return false;
  return ref.watch(envProvider) == Env.mock;
}

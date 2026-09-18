// Staging flavor entry point (the staging API). The staging base URL is a
// placeholder until a staging deployment exists; the staging flavor is
// dev-team-only, and release_guards refuses a prod boot on placeholder config.
import 'bootstrap.dart';
import 'core/config/env.dart';

Future<void> main() => bootstrap(env: Env.staging);

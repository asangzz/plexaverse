// Mock flavor entry point: bundled JSON fixtures (assets/mock/), no backend
// needed. `useFakeBackendProvider` is true for Env.mock, so repository
// providers resolve their `Fake*` implementations. Handy for UI work,
// demos, and widget/golden tests without a live API.
import 'bootstrap.dart';
import 'core/config/env.dart';

Future<void> main() => bootstrap(env: Env.mock);

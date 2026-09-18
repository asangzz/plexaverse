// Development flavor entry point (the local backend at 10.0.2.2:8443 —
// the Android emulator's alias for the host machine; override with
// `--dart-define=API_BASE_URL=…` on a physical device).
import 'bootstrap.dart';
import 'core/config/env.dart';

Future<void> main() => bootstrap(env: Env.dev);

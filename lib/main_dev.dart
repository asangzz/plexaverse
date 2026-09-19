// Development flavor entry point.
//
// Talks to the Next.js server running on YOUR machine — `npm run dev` in the
// web repo, port 3000. The iOS simulator reaches it at localhost; the Android
// emulator needs 10.0.2.2 and `ApiEnvironment` picks that automatically. On a
// physical device pass your LAN address:
//   --dart-define=API_BASE_URL=http://192.168.1.16:3000/api/mobile/v1
//
// Production is the deployed API at https://www.plexaverse.com — see
// `main_prod.dart` and `ApiEnvironment._defaultFor`.
import 'bootstrap.dart';
import 'core/config/env.dart';

Future<void> main() => bootstrap(env: Env.dev);

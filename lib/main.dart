// Default entry point = production flavor (so an un-flavored `flutter build`
// targets the safe prod config, never the mocks). Flavored entry points live
// alongside: main_mock.dart, main_dev.dart, main_staging.dart, main_prod.dart.
//
// Flavor selection is purely which `-t lib/main_*.dart` target is built — all
// real boot logic lives in `bootstrap()`; there are no per-flavor code paths
// outside config resolution (bootstrap-flavors.md).
import 'bootstrap.dart';
import 'core/config/env.dart';

Future<void> main() => bootstrap(env: Env.prod);

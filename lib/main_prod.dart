// Production flavor entry point (the live plexaverse.com API). Identical in
// effect to `lib/main.dart`, which aliases prod so an un-flavored build is
// safe; this explicit target exists for symmetry with the other flavors and
// for CI pipelines that build every flavor by name.
import 'bootstrap.dart';
import 'core/config/env.dart';

Future<void> main() => bootstrap(env: Env.prod);

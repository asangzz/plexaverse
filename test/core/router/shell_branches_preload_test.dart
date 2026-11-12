import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:plexaverse/core/router/app_router.dart';
import 'package:plexaverse/core/router/route_paths.dart';
import 'package:plexaverse/core/router/zave_destinations.dart';
import 'package:plexaverse/core/router/zave_routes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Every shell branch preloads.
///
/// ## The bug this pins
///
/// `StatefulShellBranch.preload` defaults to false, which means a branch is
/// not BUILT until the first time it is navigated to. Every tab page opens
/// with `provider.when(loading: → skeleton)`, so building it on tap is the
/// moment its fetch starts — and the user got a bare grey skeleton with no
/// header for as long as the request took. Measured at 400-500ms against the
/// mock's own latency on a 20fps capture; worse against the real backend,
/// which is in Tokyo.
///
/// It read as a rendering glitch rather than as loading, because the page
/// being left was fully drawn and the page arriving was empty.
///
/// ## Why a test rather than a comment
///
/// The symptom is invisible on a fast connection and invisible to every
/// widget test, since nothing here asserts on timing. A single dropped
/// `preload: true` — in a merge, or in a fifth branch added later — brings it
/// straight back with nothing failing. This is the cheapest thing that
/// notices.
void main() {
  /// Walks the route tree and returns every StatefulShellBranch in it.
  List<StatefulShellBranch> branchesOf(List<RouteBase> routes) {
    final List<StatefulShellBranch> found = <StatefulShellBranch>[];
    void walk(List<RouteBase> rs) {
      for (final RouteBase r in rs) {
        if (r is StatefulShellRoute) found.addAll(r.branches);
        walk(r.routes);
      }
    }

    walk(routes);
    return found;
  }

  late ProviderContainer container;
  late GoRouter router;

  setUp(() {
    container = ProviderContainer();
    router = container.read(appRouterProvider);
  });

  tearDown(() => container.dispose());

  test('the shell has one branch per entry in tabRoutes', () {
    // Guards the other assertion: if the branch list and `tabRoutes` drift,
    // ZaveShellHost indexes into the wrong route name and the preload check
    // below covers a set that no longer matches the shell.
    expect(
      branchesOf(router.configuration.routes),
      hasLength(tabRoutes.length),
    );
  });

  test('each branch is its tabRoutes entry, in the same order', () {
    // ZaveShellHost names the current route as `tabRoutes[currentIndex]`, and
    // goes to a destination by its index in the same list. A branch out of
    // order opens the wrong screen from the sheet and highlights another.
    final List<StatefulShellBranch> branches = branchesOf(
      router.configuration.routes,
    );
    for (int i = 0; i < branches.length; i++) {
      final GoRoute root = branches[i].routes.whereType<GoRoute>().first;
      expect(root.path, tabRoutes[i], reason: 'branch $i');
    }
  });

  test('the contest is the first branch, where a signed-in user lands', () {
    // The web's home since 11 Nov 2026 (`/dashboard` forwards to it), with
    // the roadmap that used to be home right behind it.
    expect(tabRoutes.take(2), <String>[ZaveRoutes.contest, ZaveRoutes.roadmap]);
    expect(RoutePaths.home, tabRoutes.first);
  });

  test('every branch preloads, so no screen opens on a skeleton', () {
    final List<StatefulShellBranch> branches = branchesOf(
      router.configuration.routes,
    );

    for (int i = 0; i < branches.length; i++) {
      expect(
        branches[i].preload,
        isTrue,
        reason:
            'Branch $i (${tabRoutes[i]}) does not preload, so its page is '
            'built on first visit and shows a loading skeleton for the length '
            'of its fetch. Set preload: true.',
      );
    }
  });
}

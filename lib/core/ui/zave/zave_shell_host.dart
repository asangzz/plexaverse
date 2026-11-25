import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../access/feature_access.dart';
import '../../router/zave_destinations.dart';
import '../../router/zave_routes.dart';
import '../../../features/contest/application/contest_controllers.dart'
    show refreshContestStanding;
import '../../../features/home/application/home_controllers.dart'
    show levelsFinishedProvider;
import '../../../features/preferences/domain/user_preferences.dart';
import '../../../features/settings/application/settings_controllers.dart';
import '../../../features/settings/domain/settings_entities.dart';
import '../../../features/preferences/application/preferences_controller.dart';
import 'zave_shell.dart';

/// Binds [ZaveShell] to the app's state.
///
/// [ZaveShell] itself is deliberately dumb — it takes `role` and `brandType` as
/// plain values so it renders in a test without a session or a network. This is
/// the one place that reads them, and the one place that turns a route string
/// into navigation.
///
/// Both reads fail SOFT. If preferences or the account have not resolved yet,
/// the shell is handed nulls, which withholds brand- and admin-specific
/// destinations rather than guessing at them — showing a personal user a
/// company tab for one frame is a worse failure than showing four tabs for one
/// frame.
class ZaveShellHost extends ConsumerWidget {
  const ZaveShellHost({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final BrandType? brandType = ref
        .watch(preferencesControllerProvider)
        .whenOrNull(
          data: (UserPreferences p) =>
              p.isCompany ? BrandType.company : BrandType.personal,
        );

    final String? role = ref
        .watch(accountSnapshotProvider)
        .whenOrNull(data: (AccountSnapshot a) => a.user.role);

    final String currentRoute = tabRoutes[navigationShell.currentIndex];

    return ZaveShell(
      currentRoute: currentRoute,
      role: role,
      brandType: brandType,
      onNavigate: (String route) {
        final int branch = tabRoutes.indexOf(route);
        if (branch >= 0 && branch != navigationShell.currentIndex) {
          // The tabs are preloaded and stay mounted, so a tab coming back into
          // view shows what it read when it was first built. Two of them show
          // state another tab moves: a Sunday set-up level is done in the
          // Planner, and the roadmap's "levels finished" figures move with
          // every level. Re-read those on the way back (the web refetches on
          // mount).
          if (route == ZaveRoutes.contest) {
            refreshContestStanding(ref.invalidate);
          } else if (route == ZaveRoutes.roadmap) {
            ref.invalidate(levelsFinishedProvider);
          }
        }
        if (branch >= 0) {
          // A tab. `initialLocation: true` when re-tapping the current tab
          // pops that branch to its root, which is the platform convention.
          navigationShell.goBranch(
            branch,
            initialLocation: branch == navigationShell.currentIndex,
          );
        } else {
          // Anything else is a full-screen route pushed over the shell.
          context.push(route);
        }
      },
      child: navigationShell,
    );
  }
}

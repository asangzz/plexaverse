import 'package:flutter/material.dart';

import '../../access/feature_access.dart';
import '../../router/zave_destinations.dart';
import '../../theme/zave/zave.dart';
import 'zave_actions.dart';
import 'zave_ground.dart';
import 'zave_more_sheet.dart';

/// The signed-in app shell: the ground, the current screen, and two buttons.
///
/// Deliberately presentational — it takes [role] and [brandType] as values and
/// reports navigation through [onNavigate], so it renders in a widget test and
/// in the styleguide without a session, a network, or a router.
///
/// ## There is no bottom bar
///
/// There was one, carrying four of the web's sixteen sidebar entries while the
/// other twelve lived behind a More button — so the nav was split by a rule
/// ("which four?") that the product never actually had. Navigation is now two
/// floating buttons: Write, and More.
///
/// **The whole tree is in the sheet now, not the leftovers.** The sheet is
/// handed [visibleDestinations] rather than `moreDestinations`, because with
/// no bar there is nothing else to reach Home, Plan, Calendar or Posts with.
/// That is the property that keeps the app honest — no destination the web
/// offers this user is unreachable here — and it used to be split across two
/// surfaces that had to be kept covering it between them.
///
/// The four shell BRANCHES are unchanged: they still exist, still preload and
/// still keep their state in an IndexedStack. [tabRoutes] names them. They are
/// simply no longer drawn as tabs.
class ZaveShell extends StatelessWidget {
  const ZaveShell({
    required this.child,
    required this.currentRoute,
    required this.onNavigate,
    this.role,
    this.brandType,
    this.moreFooter,
    super.key,
  });

  /// The active screen.
  final Widget child;

  final String currentRoute;
  final ValueChanged<String> onNavigate;

  /// `'admin'` unlocks the admin-only destinations, exactly as on the web.
  final String? role;

  /// Null while preferences load — brand-specific destinations are withheld
  /// rather than guessed. See [isNavVisible].
  final BrandType? brandType;

  /// Sign-out and version, shown at the foot of the More sheet.
  final Widget? moreFooter;

  Future<void> _openMore(BuildContext context) async {
    // Every visible destination, not the bar's leftovers. The sheet is the
    // only way to anywhere now, so anything missing here is unreachable.
    final List<ZaveDestination> more = visibleDestinations(
      role: role,
      brandType: brandType,
    );
    final String? chosen = await ZaveMoreSheet.show(
      context,
      destinations: more,
      currentRoute: currentRoute,
      footer: moreFooter,
    );
    if (chosen != null) onNavigate(chosen);
  }

  @override
  Widget build(BuildContext context) {
    return ZaveGroundBox(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBody: true,
        // The bar used to absorb the bottom safe-area inset — it was built
        // `height: _height + bottomInset`. Pages pad their own scroll views by
        // a FIXED `ZaveSpace.section`, so with the bar gone nothing accounted
        // for the home indicator any more and the last line of every page ran
        // off the bottom edge.
        //
        // `bottom: true` puts that inset back, once, for every screen in the
        // shell. The page's own 72 then sits on top of it and clears the 56px
        // discs. The ground is OUTSIDE the Scaffold, so it still paints
        // edge-to-edge and nothing about the look changes — only the content
        // stops where it should.
        body: SafeArea(top: false, child: child),
        // Write stays rightmost: it is the primary action and the easiest
        // reach, which is the position it held in the centre of the bar. More
        // sits inboard of it rather than outboard so that relationship is not
        // inverted, even though More is now the more frequently pressed of
        // the two.
        floatingActionButton: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ZaveMoreButton(onPressed: () => _openMore(context)),
            SizedBox(width: ZaveSpace.md),
            ZaveComposeButton(
              onPressed: () => onNavigate(composeRouteFor(brandType)),
            ),
          ],
        ),
      ),
    );
  }
}

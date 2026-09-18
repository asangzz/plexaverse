import 'package:flutter/material.dart';

import '../../access/feature_access.dart';
import '../../router/zave_destinations.dart';
import 'zave_bottom_bar.dart';
import 'zave_ground.dart';
import 'zave_more_sheet.dart';

/// The signed-in app shell: the ground, the current screen, the bottom bar and
/// the More sheet.
///
/// Deliberately presentational — it takes [role] and [brandType] as values and
/// reports navigation through [onNavigate], so it renders in a widget test and
/// in the styleguide without a session, a network, or a router.
///
/// ## Why the nav is split rather than truncated
///
/// The web shows up to sixteen sidebar items. A bottom bar holds four. So the
/// tree is SPLIT: [tabRoutes] go in the bar, and everything else visible to
/// this user goes in the More sheet. The two together always cover
/// [visibleDestinations], which is the property that keeps the app honest — no
/// destination the web offers this user is unreachable here.
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

  /// Whether [route] is one the bottom bar itself highlights. The More button
  /// shows as selected for anything else.
  bool _isTabRoute(String route) => tabRoutes.contains(route);

  Future<void> _openMore(BuildContext context) async {
    final List<ZaveDestination> more = moreDestinations(
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
    final List<ZaveDestination> visible = visibleDestinations(
      role: role,
      brandType: brandType,
    );

    // Build the bar from the destination tree rather than a second hard-coded
    // list, so the two cannot drift. Order follows tabRoutes, not the tree.
    final List<ZaveBarItem> barItems = <ZaveBarItem>[
      for (final String route in tabRoutes)
        if (visible.any((ZaveDestination d) => d.route == route))
          ZaveBarItem(
            label: visible.firstWhere((ZaveDestination d) => d.route == route).label,
            icon: visible.firstWhere((ZaveDestination d) => d.route == route).icon,
            route: route,
          ),
    ];

    // The More button rides in the bar as a final entry so it shares the tab
    // metrics exactly.
    final List<ZaveBarItem> withMore = <ZaveBarItem>[
      ...barItems.take(2),
      ...barItems.skip(2),
      const ZaveBarItem(
        label: 'More',
        icon: Icons.more_horiz,
        route: _moreSentinel,
      ),
    ];

    return ZaveGroundBox(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBody: true,
        body: child,
        bottomNavigationBar: ZaveBottomBar(
          items: withMore,
          currentRoute: _isTabRoute(currentRoute) ? currentRoute : _moreSentinel,
          onSelect: (String route) {
            if (route == _moreSentinel) {
              _openMore(context);
            } else {
              onNavigate(route);
            }
          },
          compose: ZaveComposeButton(
            onPressed: () => onNavigate(composeRouteFor(brandType)),
          ),
        ),
      ),
    );
  }

  /// Not a real route — it only tells the bar which entry opens the sheet.
  static const String _moreSentinel = '__more__';
}

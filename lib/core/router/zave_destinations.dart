import 'package:flutter/material.dart';

import '../access/feature_access.dart';
import 'zave_routes.dart';

/// One navigable destination, mirroring a `NavItem` in the web sidebar.
class ZaveDestination {
  const ZaveDestination({
    required this.label,
    required this.route,
    required this.icon,
    required this.visibility,
    this.group = '',
  });

  /// The label the web uses, verbatim. Do not rename on mobile — a user who
  /// learns "Plan" on the web must find "Plan" here.
  final String label;

  final String route;
  final IconData icon;
  final NavVisibility visibility;

  /// The web sidebar's group header this belongs to.
  final String group;
}

/// The navigation tree, ported 1:1 from `navGroups` in the web's
/// `components/automate/Sidebar.tsx` — same order, same labels, same routes,
/// same `visibility` flags.
///
/// Read [zaveDestinations] as the source of truth and derive the bottom bar
/// from it (see [tabRoutes]) rather than hand-listing tabs, so the two cannot
/// drift.
const List<ZaveDestination> zaveDestinations = <ZaveDestination>[
  // ── Overview ──
  ZaveDestination(
    label: 'Home',
    route: ZaveRoutes.dashboard,
    icon: Icons.home_outlined,
    visibility: NavVisibility.both,
    group: 'Overview',
  ),
  ZaveDestination(
    label: 'Analytics',
    route: ZaveRoutes.companyAnalytics,
    icon: Icons.insights_outlined,
    visibility: NavVisibility.company,
    group: 'Overview',
  ),
  ZaveDestination(
    label: 'Inbox',
    route: ZaveRoutes.companyAutoComment,
    icon: Icons.forum_outlined,
    visibility: NavVisibility.company,
    group: 'Overview',
  ),

  // ── Creation ──
  ZaveDestination(
    label: 'Plan',
    route: ZaveRoutes.planner,
    icon: Icons.grid_view_outlined,
    visibility: NavVisibility.both,
    group: 'Creation',
  ),
  ZaveDestination(
    label: 'Write',
    route: ZaveRoutes.create,
    icon: Icons.edit_outlined,
    visibility: NavVisibility.personal,
    group: 'Creation',
  ),
  ZaveDestination(
    label: 'Write',
    route: ZaveRoutes.companyPost,
    icon: Icons.edit_outlined,
    visibility: NavVisibility.company,
    group: 'Creation',
  ),
  ZaveDestination(
    label: 'Studio',
    route: ZaveRoutes.studio,
    icon: Icons.brush_outlined,
    visibility: NavVisibility.admin,
    group: 'Creation',
  ),
  ZaveDestination(
    label: 'Reimagine',
    route: ZaveRoutes.reimagine,
    icon: Icons.auto_awesome_outlined,
    visibility: NavVisibility.admin,
    group: 'Creation',
  ),
  ZaveDestination(
    label: 'Templates',
    route: ZaveRoutes.templateCreator,
    icon: Icons.dashboard_customize_outlined,
    visibility: NavVisibility.admin,
    group: 'Creation',
  ),
  ZaveDestination(
    label: 'Festive',
    route: ZaveRoutes.festive,
    icon: Icons.celebration_outlined,
    visibility: NavVisibility.admin,
    group: 'Creation',
  ),

  // ── Growth & Tools ──
  ZaveDestination(
    label: 'Advocacy',
    route: ZaveRoutes.companyAdvocacy,
    icon: Icons.campaign_outlined,
    visibility: NavVisibility.admin,
    group: 'Growth & Tools',
  ),

  // ── Management ──
  ZaveDestination(
    label: 'Persona',
    route: ZaveRoutes.persona,
    icon: Icons.face_outlined,
    visibility: NavVisibility.both,
    group: 'Management',
  ),
  ZaveDestination(
    label: 'Posts',
    route: ZaveRoutes.posts,
    icon: Icons.article_outlined,
    visibility: NavVisibility.both,
    group: 'Management',
  ),
  ZaveDestination(
    label: 'Calendar',
    route: ZaveRoutes.calendar,
    icon: Icons.calendar_today_outlined,
    visibility: NavVisibility.both,
    group: 'Management',
  ),
  ZaveDestination(
    label: 'Accounts',
    route: ZaveRoutes.accounts,
    icon: Icons.link_outlined,
    visibility: NavVisibility.admin,
    group: 'Management',
  ),
  ZaveDestination(
    label: 'Settings',
    route: ZaveRoutes.settings,
    icon: Icons.settings_outlined,
    visibility: NavVisibility.both,
    group: 'Management',
  ),
];

/// The four routes promoted to the bottom bar, in bar order.
///
/// A desktop sidebar lists sixteen things; a phone's bottom bar cannot, so the
/// tree above is split rather than truncated — these four sit in the bar, and
/// **every remaining visible destination appears in the More sheet**. Nothing
/// the web shows a user is unreachable here.
///
/// These four are the ones a user touches daily: Home is the habit surface,
/// Plan is the week, Calendar is the schedule, Posts is the library. Write is
/// deliberately NOT among them — it is the primary action, so it gets the
/// centre compose button ([composeRouteFor]) instead of a tab.
const List<String> tabRoutes = <String>[
  ZaveRoutes.dashboard,
  ZaveRoutes.planner,
  ZaveRoutes.calendar,
  ZaveRoutes.posts,
];

/// Which compose screen the centre button opens.
///
/// The web has two nav items both labelled "Write", split by brand
/// (`/create` for personal, `/company-post` for company). One button, two
/// destinations — same rule.
String composeRouteFor(BrandType? brandType) =>
    brandType == BrandType.company ? ZaveRoutes.companyPost : ZaveRoutes.create;

/// The destinations visible to this user, in web sidebar order.
List<ZaveDestination> visibleDestinations({
  required String? role,
  required BrandType? brandType,
}) => zaveDestinations
    .where(
      (ZaveDestination d) => isNavVisible(
        visibility: d.visibility,
        role: role,
        brandType: brandType,
      ),
    )
    .toList(growable: false);

/// The visible destinations that are NOT in the bottom bar — the More sheet's
/// contents, still grouped and ordered as the web sidebar groups them.
List<ZaveDestination> moreDestinations({
  required String? role,
  required BrandType? brandType,
}) => visibleDestinations(role: role, brandType: brandType)
    .where((ZaveDestination d) => !tabRoutes.contains(d.route))
    .toList(growable: false);

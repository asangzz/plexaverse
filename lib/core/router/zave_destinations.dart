import 'package:flutter/material.dart';

import '../access/feature_access.dart';
import '../ui/app_icons.dart';
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
    // The signed-in home since 11 Nov 2026, and where the English lesson
    // lives — the contest's daily path. The web's `IconTarget`.
    label: 'Contest',
    route: ZaveRoutes.contest,
    icon: AppIcons.bullseye,
    visibility: NavVisibility.both,
    group: 'Overview',
  ),
  ZaveDestination(
    // The 1000-day roadmap — what "Home" showed until the contest took the
    // home slot. The web's tooltip names it in full: "LinkedIn Personal
    // Branding Roadmap".
    label: 'Roadmap',
    route: ZaveRoutes.roadmap,
    icon: AppIcons.roadmap,
    visibility: NavVisibility.both,
    group: 'Overview',
  ),
  ZaveDestination(
    label: 'Analytics',
    route: ZaveRoutes.companyAnalytics,
    icon: AppIcons.insights,
    visibility: NavVisibility.company,
    group: 'Overview',
  ),
  ZaveDestination(
    label: 'Inbox',
    route: ZaveRoutes.companyAutoComment,
    icon: AppIcons.forum,
    visibility: NavVisibility.company,
    group: 'Overview',
  ),

  // ── Creation ──
  ZaveDestination(
    label: 'Plan',
    route: ZaveRoutes.planner,
    icon: AppIcons.grid,
    visibility: NavVisibility.both,
    group: 'Creation',
  ),
  ZaveDestination(
    label: 'Write',
    route: ZaveRoutes.create,
    icon: AppIcons.edit,
    visibility: NavVisibility.personal,
    group: 'Creation',
  ),
  ZaveDestination(
    label: 'Write',
    route: ZaveRoutes.companyPost,
    icon: AppIcons.edit,
    visibility: NavVisibility.company,
    group: 'Creation',
  ),
  ZaveDestination(
    label: 'Studio',
    route: ZaveRoutes.studio,
    icon: AppIcons.brush,
    visibility: NavVisibility.admin,
    group: 'Creation',
  ),
  ZaveDestination(
    label: 'Reimagine',
    route: ZaveRoutes.reimagine,
    icon: AppIcons.sparkle,
    visibility: NavVisibility.admin,
    group: 'Creation',
  ),
  ZaveDestination(
    label: 'Templates',
    route: ZaveRoutes.templateCreator,
    icon: AppIcons.grid,
    visibility: NavVisibility.admin,
    group: 'Creation',
  ),
  ZaveDestination(
    label: 'Festive',
    route: ZaveRoutes.festive,
    icon: AppIcons.celebrate,
    visibility: NavVisibility.admin,
    group: 'Creation',
  ),

  // ── Growth & Tools ──
  ZaveDestination(
    label: 'Advocacy',
    route: ZaveRoutes.companyAdvocacy,
    icon: AppIcons.campaign,
    visibility: NavVisibility.admin,
    group: 'Growth & Tools',
  ),

  // ── Management ──
  ZaveDestination(
    label: 'Persona',
    route: ZaveRoutes.persona,
    icon: AppIcons.face,
    visibility: NavVisibility.both,
    group: 'Management',
  ),
  ZaveDestination(
    label: 'Posts',
    route: ZaveRoutes.posts,
    icon: AppIcons.article,
    visibility: NavVisibility.both,
    group: 'Management',
  ),
  ZaveDestination(
    label: 'Calendar',
    route: ZaveRoutes.calendar,
    icon: AppIcons.calendar,
    visibility: NavVisibility.both,
    group: 'Management',
  ),
  ZaveDestination(
    label: 'Accounts',
    route: ZaveRoutes.accounts,
    icon: AppIcons.link,
    visibility: NavVisibility.admin,
    group: 'Management',
  ),
  ZaveDestination(
    label: 'Settings',
    route: ZaveRoutes.settings,
    icon: AppIcons.settings,
    visibility: NavVisibility.both,
    group: 'Management',
  ),
];

/// The five routes that get their own shell BRANCH, in branch order.
///
/// Four of them were the bottom bar's tabs; the bar is gone and every
/// destination now lives in the More sheet. These keep a branch anyway, and
/// the distinction is state, not navigation: a branch is an entry in the
/// shell's IndexedStack, so its page stays built and keeps its scroll
/// position, filters and in-progress edits while you are elsewhere. They also
/// preload, so none of them opens on a skeleton — see `app_router.dart`.
///
/// These five earn it because they are the ones a user returns to within a
/// session: the Contest is the daily habit and the home, the Roadmap is the
/// journey it sits on, Plan is the week, Calendar is the schedule, Posts is
/// the library. Everything else is pushed over the shell and rebuilt on each
/// visit, which is the right trade for a screen you open once and leave.
///
/// The first entry is where a signed-in user lands. It is the web's home since
/// 11 Nov 2026, when `/dashboard` began forwarding to the contest.
///
/// **The name is kept deliberately.** `ZaveShellHost` indexes this list to
/// name the current route, the order must match the branch order in
/// `app_router.dart`, and a test pins the two together — renaming it to
/// `branchRoutes` would be more accurate and would touch every one of those
/// call sites for a word. If you do rename it, rename it everywhere in one go.
const List<String> tabRoutes = <String>[
  ZaveRoutes.contest,
  ZaveRoutes.roadmap,
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

// `moreDestinations` lived here — visibleDestinations minus the bar's four.
// It went with the bar. The sheet is now handed `visibleDestinations` whole,
// because it is the only way to anywhere: subtracting the four branch routes
// would have made every branch route unreachable.

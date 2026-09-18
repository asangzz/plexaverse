import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../responsive/screen_util.dart';
import '../../theme/skin_colors.dart';
import '../motion/app_haptics.dart';
import '../skin/create_sheet.dart';
import '../skin/skin_fab.dart';

/// The signed-in four-tab shell scaffold (HeyGen re-skin, screenshot 2353).
/// Hosts the [StatefulNavigationShell] body and the bottom navigation:
///
///   Home 0 · Videos 1 · Avatars 2 · Timeline 3 · [SkinFab +] (5th slot, not
///   a branch)
///
/// Branch order is canonical and MUST match `RoutePaths` and the
/// `StatefulShellRoute.indexedStack` branches in `app_router.dart`. The
/// white circular FAB is **not** a branch — it opens the Create sheet
/// (screenshot 2377) via [showCreateSheet].
///
/// Pixel notes from 2353: bar bg #151515 edge-to-edge with NO top divider,
/// five equal slots (FAB slot centre lands at 9/10 width now that a 4th tab
/// was added ahead of it), 24dp icons over 12sp labels, active = white
/// filled glyph, inactive = #8A8A8A outline glyph, FAB Ø≈38 white circle
/// with a hand-painted plus.
class AppScaffold extends StatelessWidget {
  const AppScaffold({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: _SkinBottomNav(
        selectedIndex: navigationShell.currentIndex,
        onTap: (i) {
          AppHaptics.selection();
          // goBranch with initialLocation only when re-tapping the current
          // branch pops it to its root — the go_router idiom.
          navigationShell.goBranch(
            i,
            initialLocation: i == navigationShell.currentIndex,
          );
        },
        onFabTap: () {
          AppHaptics.light();
          showCreateSheet(context);
        },
      ),
    );
  }
}

/// HeyGen-style bottom navigation:
/// Home | Videos | Avatars | Timeline | [SkinFab +].
class _SkinBottomNav extends StatelessWidget {
  const _SkinBottomNav({
    required this.selectedIndex,
    required this.onTap,
    required this.onFabTap,
  });

  final int selectedIndex;
  final ValueChanged<int> onTap;
  final VoidCallback onFabTap;

  /// Bar content height in design dp (icon 24 + gap + 12sp label + padding).
  static const double _barHeight = 64;

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom;

    return Container(
      height: _barHeight.h + bottomPad,
      padding: EdgeInsets.only(bottom: bottomPad),
      // Edge-to-edge #151515, no divider (spec Shell section).
      color: SkinColors.navBg,
      child: Row(
        children: <Widget>[
          _NavItem(
            activeIcon: Icons.home,
            inactiveIcon: Icons.home_outlined,
            label: 'Home',
            isSelected: selectedIndex == 0,
            onTap: () => onTap(0),
          ),
          _NavItem(
            activeIcon: Icons.smart_display,
            inactiveIcon: Icons.smart_display_outlined,
            label: 'Videos',
            isSelected: selectedIndex == 1,
            onTap: () => onTap(1),
          ),
          _NavItem(
            activeIcon: Icons.people_alt,
            inactiveIcon: Icons.people_alt_outlined,
            label: 'Avatars',
            isSelected: selectedIndex == 2,
            onTap: () => onTap(2),
          ),
          _NavItem(
            activeIcon: Icons.timeline,
            inactiveIcon: Icons.timeline_outlined,
            label: 'Timeline',
            isSelected: selectedIndex == 3,
            onTap: () => onTap(3),
          ),
          // 5th slot — the white Create FAB, vertically centred in the bar.
          // Measured Ø≈38 with a ~16dp plus glyph in 2353 (both scale via .r
          // inside SkinFab).
          Expanded(
            child: Center(
              child: SkinFab(
                onTap: onFabTap,
                size: 38,
                glyphSize: 16,
                strokeWidth: 2.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.activeIcon,
    required this.inactiveIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final IconData activeIcon;
  final IconData inactiveIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? Colors.white : SkinColors.navInactive;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              child: Icon(
                isSelected ? activeIcon : inactiveIcon,
                key: ValueKey<bool>(isSelected),
                color: color,
                size: 24.r,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              style: GoogleFonts.urbanist(
                fontSize: 12.sp,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

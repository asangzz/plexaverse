import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/responsive/screen_util.dart';
import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/skin_colors.dart';
import '../../../../core/ui/motion/spring_press.dart';
import '../../../../core/ui/skin/home_background.dart';
import '../../../../core/ui/skin/pill_tab_bar.dart';
import '../widgets/make_video_tab.dart';
import '../widgets/translate_video_tab.dart';
import '../widgets/video_tools_tab.dart';

/// Home — HeyGen-style re-skin (screenshots 2353 / 2372 / 2373).
///
/// Full-screen [HomeBackground] (fitted three-layer gradient: indigo→black
/// base + violet top-right glow + teal-blue left glow, see the painter);
/// "Home" 28sp bold with a gear
/// button (translucent 40 circle) that pushes [RoutePaths.account]; a
/// [SkinPillTabBar] with three tabs whose bodies swap instantly with a
/// subtle cross-fade: [MakeVideoTab], [TranslateVideoTab], [VideoToolsTab].
///
/// The old dashboard content (streak hero / KPI grid / recent posts) is
/// replaced wholesale; `dashboard_controller.dart` and the home repository
/// remain on disk but are no longer referenced by this page. Static
/// presentation config only — no provider behind the tabs.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const List<String> _tabs = [
    'Make video',
    'Translate video',
    'Video tools',
  ];

  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SkinColors.deepNavy,
      body: Stack(
        children: [
          // Full-screen fitted background (2353): vertical indigo→black base
          // + elliptical violet glow (top-right) + teal-blue glow (left).
          // Painter constants are least-squares fitted to the reference PNG —
          // see HomeBackgroundPainter. Content scrolls over it.
          const Positioned.fill(child: HomeBackground()),
          SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _HomeHeader(),
                SizedBox(height: 14.h),
                SkinPillTabBar(
                  tabs: _tabs,
                  selectedIndex: _selectedTab,
                  onChanged: (i) => setState(() => _selectedTab = i),
                ),
                SizedBox(height: 14.h),
                // Instant swap with a subtle cross-fade between tab bodies.
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 180),
                    switchInCurve: Curves.easeOut,
                    switchOutCurve: Curves.easeIn,
                    layoutBuilder: (currentChild, previousChildren) => Stack(
                      alignment: Alignment.topCenter,
                      children: [...previousChildren, ?currentChild],
                    ),
                    child: KeyedSubtree(
                      key: ValueKey<int>(_selectedTab),
                      child: switch (_selectedTab) {
                        1 => const TranslateVideoTab(),
                        2 => const VideoToolsTab(),
                        _ => const MakeVideoTab(),
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// "Home" 28sp bold on the left (H20) + gear in a translucent 40 circle on
/// the right, navigating to the Account page (2353).
class _HomeHeader extends StatelessWidget {
  const _HomeHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 10.h, 16.w, 0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Home',
              style: GoogleFonts.sora(
                fontSize: 28.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                height: 1.2,
              ),
            ),
          ),
          SpringPress(
            child: GestureDetector(
              onTap: () => context.push(RoutePaths.account),
              behavior: HitTestBehavior.opaque,
              child: Container(
                width: 40.r,
                height: 40.r,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.10),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.settings_rounded,
                  size: 20.r,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

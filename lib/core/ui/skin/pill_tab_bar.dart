import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../responsive/screen_util.dart';
import '../../theme/skin_colors.dart';
import '../motion/spring_press.dart';

/// Horizontal pill tab row — the Home "Make video / Translate video /
/// Video tools" selector in screenshots 2353 (Make video active) and 2376
/// header ("Translate video" active).
///
/// Active tab: stadium container, 1px white-24% border, white-8% fill,
/// white 15sp semibold label, height ~36. Inactive tabs: bare text in
/// #8B87A8 (no container). The row scrolls horizontally when labels
/// overflow the screen width.
class SkinPillTabBar extends StatelessWidget {
  const SkinPillTabBar({
    required this.tabs,
    required this.selectedIndex,
    required this.onChanged,
    this.padding,
    super.key,
  });

  /// Tab labels in display order.
  final List<String> tabs;

  /// Index of the currently selected tab.
  final int selectedIndex;

  /// Called with the tapped tab index.
  final ValueChanged<int> onChanged;

  /// Outer padding for the scrollable row — defaults to H16.
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: padding ?? EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: tabs.length,
        separatorBuilder: (_, _) => SizedBox(width: 8.w),
        itemBuilder: (context, i) {
          final active = i == selectedIndex;
          return SpringPress(
            child: GestureDetector(
              onTap: () => onChanged(i),
              behavior: HitTestBehavior.opaque,
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 18.w),
                decoration: active
                    ? BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(18.r),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.24),
                          width: 1,
                        ),
                      )
                    : null,
                child: Text(
                  tabs[i],
                  style: GoogleFonts.urbanist(
                    fontSize: 15.sp,
                    fontWeight: active ? FontWeight.w600 : FontWeight.w500,
                    color: active ? Colors.white : SkinColors.pillInactiveText,
                    height: 1.2,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

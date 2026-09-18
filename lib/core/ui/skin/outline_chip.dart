import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../responsive/screen_util.dart';
import '../../theme/skin_colors.dart';
import '../motion/spring_press.dart';

/// Outline filter chip — the "Avatar Video / Video Translation / Video
/// Agent / Motion…" chips in the Videos tab header (screenshot 2354).
///
/// Stadium shape, 1px #6E7288 border, transparent fill, label #C9CCD6
/// 14sp, height 34. Chips sit in a horizontally scrolling row with a 10dp
/// gap (the row itself is composed by the screen).
class SkinOutlineChip extends StatelessWidget {
  const SkinOutlineChip({required this.label, this.onTap, super.key});

  /// Chip caption, e.g. "Avatar Video".
  final String label;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final chip = Container(
      height: 34.h,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(17.r),
        border: Border.all(color: SkinColors.chipBorder, width: 1),
      ),
      child: Text(
        label,
        style: GoogleFonts.urbanist(
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          color: SkinColors.chipText,
          height: 1.2,
        ),
      ),
    );

    if (onTap == null) return chip;
    return SpringPress(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: chip,
      ),
    );
  }
}

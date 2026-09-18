import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../responsive/screen_util.dart';
import '../../theme/skin_colors.dart';

/// Small gold status badge — "Avatar IV" / "Draft" on the Videos tab
/// (screenshot 2354) and "Seedance 2.0" above the Cinematic Clip title on
/// Home (screenshot 2353).
///
/// Gold text #E8B54B on muted-brown #3A3123, radius 6, 12sp semibold,
/// padding 8×3 — per the heygen-ui-spec token block.
class GoldBadge extends StatelessWidget {
  const GoldBadge(this.label, {super.key});

  /// Badge caption, e.g. "Avatar IV", "Draft", "Seedance 2.0".
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: SkinColors.badgeGoldBg,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        label,
        style: GoogleFonts.urbanist(
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          color: SkinColors.badgeGold,
          height: 1.2,
        ),
      ),
    );
  }
}

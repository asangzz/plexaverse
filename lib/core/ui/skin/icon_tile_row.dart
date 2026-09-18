import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../responsive/screen_util.dart';
import '../../theme/skin_colors.dart';
import '../motion/spring_press.dart';

/// Icon-tile list row — the sheet rows in the Video Translation sheet
/// (screenshot 2376: "Upload video / Record video / Upload video URL" on
/// #202020 with purple #2B2233 icon tiles and #E081FF glyphs) and the
/// Create sheet (screenshot 2377: "Clone Yourself" … on teal #17242B with
/// cyan tiles; "Photo to Video" … on olive #222B22 with lime→green
/// gradient glyphs, via [iconGradient]).
///
/// Per spec: height-72 card ([radius] 24 in 2376, 16 in 2377), 44×44 r12
/// icon tile on the left, white title (15sp semibold, optional inline
/// [titleBadge] like the gold "Seedance 2.0" chip next to "Cinematic Clip"
/// in 2377), grey subtitle, chevron on the right (hideable — 2377 rows
/// have none).
class SkinIconTileRow extends StatelessWidget {
  const SkinIconTileRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.backgroundColor = SkinColors.vtRowBg,
    this.tileColor = SkinColors.vtTilePurpleBg,
    this.iconColor = SkinColors.vtIconPurple,
    this.iconGradient,
    this.radius = 16,
    this.titleBadge,
    this.showChevron = true,
    this.onTap,
    super.key,
  });

  /// Glyph inside the 44×44 tile.
  final IconData icon;

  final String title;
  final String subtitle;

  /// Row card fill — [SkinColors.vtRowBg] (2376) or
  /// [SkinColors.createRowTeal] / [SkinColors.createRowGreen] (2377).
  final Color backgroundColor;

  /// Icon tile fill — [SkinColors.vtTilePurpleBg] / [SkinColors.tileCyanBg]
  /// / [SkinColors.tileGreenBg].
  final Color tileColor;

  /// Glyph color — [SkinColors.vtIconPurple] / [SkinColors.tileCyanIcon]
  /// (ignored when [iconGradient] is set).
  final Color iconColor;

  /// When set, the glyph is painted with this gradient via a [ShaderMask]
  /// (the lime→green Create-video icons in 2377).
  final Gradient? iconGradient;

  /// Row card corner radius in design dp (24 in 2376, 16 in 2377).
  final double radius;

  /// Optional inline badge after the title (e.g. `GoldBadge('Seedance 2.0')`).
  final Widget? titleBadge;

  /// Whether to draw the trailing chevron (2376 yes, 2377 no).
  final bool showChevron;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    Widget glyph = Icon(
      icon,
      size: 22.r,
      color: iconGradient == null ? iconColor : Colors.white,
    );
    if (iconGradient != null) {
      glyph = ShaderMask(
        blendMode: BlendMode.srcIn,
        shaderCallback: (bounds) => iconGradient!.createShader(bounds),
        child: glyph,
      );
    }

    final row = Container(
      height: 72.h,
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(radius.r),
      ),
      child: Row(
        children: [
          Container(
            width: 44.r,
            height: 44.r,
            decoration: BoxDecoration(
              color: tileColor,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: glyph,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.urbanist(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          height: 1.25,
                        ),
                      ),
                    ),
                    if (titleBadge != null) ...[
                      SizedBox(width: 8.w),
                      titleBadge!,
                    ],
                  ],
                ),
                SizedBox(height: 3.h),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.urbanist(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w400,
                    color: SkinColors.dateGrey,
                    height: 1.25,
                  ),
                ),
              ],
            ),
          ),
          if (showChevron) ...[
            SizedBox(width: 8.w),
            Icon(
              Icons.chevron_right_rounded,
              size: 22.r,
              color: SkinColors.dateGrey,
            ),
          ],
        ],
      ),
    );

    if (onTap == null) return row;
    return SpringPress(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: row,
      ),
    );
  }
}

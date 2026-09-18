import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

import '../../responsive/screen_util.dart';
import '../../theme/skin_colors.dart';

/// Square video thumbnail with an optional duration chip — the 64×64 row
/// thumbs on the Videos tab (screenshot 2354, e.g. "00:08" on Quick Avatar
/// Video) and, sized down, the 48dp Recent Activity thumbs in the
/// Subscription sheet (2375).
///
/// Rounded 12, [CachedNetworkImage] with a dark shimmer placeholder; the
/// duration chip sits inside the bottom-left corner: black 60% pill r6,
/// white 11sp label.
class SkinVideoThumb extends StatelessWidget {
  const SkinVideoThumb({
    required this.imageUrl,
    this.duration,
    this.size = 64,
    this.radius = 12,
    super.key,
  });

  /// Network thumbnail URL (fixtures use picsum seeds).
  final String imageUrl;

  /// Optional "mm:ss" caption, e.g. "00:08"; chip hidden when null.
  final String? duration;

  /// Square edge in design dp.
  final double size;

  /// Corner radius in design dp.
  final double radius;

  @override
  Widget build(BuildContext context) {
    final edge = size.r;
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius.r),
      child: SizedBox(
        width: edge,
        height: edge,
        child: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              placeholder: (_, _) => Shimmer.fromColors(
                baseColor: SkinColors.recentThumbBg,
                highlightColor: SkinColors.quotaTrackGrey,
                child: const ColoredBox(color: SkinColors.recentThumbBg),
              ),
              errorWidget: (_, _, _) =>
                  const ColoredBox(color: SkinColors.recentThumbBg),
            ),
            if (duration != null)
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: EdgeInsets.all(4.r),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 4.w,
                      vertical: 1.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.60),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Text(
                      duration!,
                      style: GoogleFonts.urbanist(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        height: 1.2,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

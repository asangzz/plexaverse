import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

import '../../responsive/screen_util.dart';
import '../../theme/skin_colors.dart';
import '../motion/spring_press.dart';
import 'accent_border_card.dart';

/// Home feature card — the full-width navy cards on every Home tab:
/// screenshot 2353 ("Photo to Video" … cyan gradient titles), 2372
/// ("Video Dubbing" — green titles + green thumbnail accent) and 2373
/// ("Instant Highlights" — magenta titles + magenta thumbnail accent).
///
/// Layout per spec: r16 card filled with translucent steel-blue glass
/// ([SkinColors.glassCardBlue], #0D3753 @29%) so the fitted page background
/// shows through — cards read darker toward the bottom of the screen;
/// left thumbnail ~34% of the card width, full ~130dp height, flush to the
/// rounded left edge; right column with an optional [badge] (gold
/// "Seedance 2.0"), the [title] widget (pass a [GradientText] or a colored
/// [Text] per tab) and a grey 15sp [subtitle], all padded 16.
///
/// The thumbnail's accent — a hairline [AccentBorderCard] border plus a
/// matching-color inner shadow, no outer glow — always matches the card's
/// own [title] color: the Make video cyan gradient ([accentGradientColors]),
/// or a flat [accentColor] (Translate green, Video tools magenta). Exactly
/// one of the two must be supplied.
class SkinFeatureCard extends StatelessWidget {
  const SkinFeatureCard({
    required this.thumbnailUrl,
    required this.title,
    required this.subtitle,
    this.badge,
    this.accentColor,
    this.accentGradientColors,
    this.accentBorderWidth = 1.0,
    this.height = 130,
    this.onTap,
    super.key,
  }) : assert(
         (accentColor == null) != (accentGradientColors == null),
         'Supply exactly one of accentColor or accentGradientColors',
       );

  /// Network image for the left thumbnail.
  final String thumbnailUrl;

  /// Title widget — a [GradientText] on Make video, a green/magenta [Text]
  /// on the other tabs (17sp bold).
  final Widget title;

  /// Grey subtitle copy under the title.
  final String subtitle;

  /// Optional badge shown above the title (e.g. `GoldBadge('Seedance 2.0')`).
  final Widget? badge;

  /// Flat thumbnail accent (border + inner shadow) — matches the title
  /// color exactly (Translate = [SkinColors.translateGreen], Video tools =
  /// [SkinColors.toolsMagenta]).
  final Color? accentColor;

  /// 2-stop gradient thumbnail accent — Make video's cyan title gradient
  /// ([SkinColors.titleGradStart] → [SkinColors.titleGradEnd]).
  final List<Color>? accentGradientColors;

  /// Border stroke width in design dp — "very thin" (Make video, ~1.0) vs
  /// "very very thin" (Translate / Video tools, ~0.6).
  final double accentBorderWidth;

  /// Card height in design dp (~130 in the screenshots).
  final double height;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final card = Container(
      height: height.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        // Translucent glass fill — the page background must show through
        // (fitted #0D3753 @ alpha 0.29, see SkinColors.glassCardBlue).
        color: SkinColors.glassCardBlue,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final thumbWidth = constraints.maxWidth * 0.34;
          final thumb = AccentBorderCard(
            color: accentColor,
            gradientColors: accentGradientColors,
            borderWidth: accentBorderWidth,
            child: CachedNetworkImage(
              imageUrl: thumbnailUrl,
              width: thumbWidth,
              height: height.h,
              fit: BoxFit.cover,
              placeholder: (_, _) => Shimmer.fromColors(
                baseColor: SkinColors.cardNavyEnd,
                highlightColor: SkinColors.cardNavyStart,
                child: const ColoredBox(color: SkinColors.cardNavyEnd),
              ),
              errorWidget: (_, _, _) =>
                  const ColoredBox(color: SkinColors.cardNavyEnd),
            ),
          );
          return Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(width: thumbWidth, child: thumb),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (badge != null) ...[badge!, SizedBox(height: 6.h)],
                      title,
                      SizedBox(height: 4.h),
                      Text(
                        subtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.urbanist(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w400,
                          color: SkinColors.subtitleGrey,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );

    if (onTap == null) return card;
    return SpringPress(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: card,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/responsive/screen_util.dart';
import '../../../../core/theme/skin_colors.dart';
import '../../../../core/ui/skin/feature_card.dart';
import '../../../../core/ui/skin/gold_badge.dart';
import '../../../../core/ui/skin/gradient_text.dart';

/// Home — "Make video" tab body (screenshot 2353).
///
/// Four full-width [SkinFeatureCard]s with cyan-gradient titles
/// (#3FC0E7 → #149CC5 via [GradientText]); "Cinematic Clip" carries the
/// gold "Seedance 2.0" badge above its title. Each thumbnail carries a
/// hairline border + matching inner shadow in that same cyan gradient
/// (no outer glow) — the accent always matches the title color. Static
/// presentation config per spec — no repository behind these cards.
class MakeVideoTab extends StatelessWidget {
  const MakeVideoTab({super.key});

  static const List<({String title, String subtitle, String seed})> _cards = [
    (
      title: 'Photo to Video',
      subtitle: 'Turn any photo into an avatar video',
      seed: 'plexa-photo-to-video',
    ),
    (
      title: 'Prompt to Video',
      subtitle: 'Turn any idea into a compelling video',
      seed: 'plexa-prompt-to-video',
    ),
    (
      title: 'Cinematic Clip',
      subtitle: 'Cast your avatar in a cinematic scene',
      seed: 'plexa-cinematic-clip',
    ),
    (
      title: 'Script to Video',
      subtitle: 'Write a script and pick a speaker',
      seed: 'plexa-script-to-video',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 24.h),
      itemCount: _cards.length,
      separatorBuilder: (_, _) => SizedBox(height: 14.h),
      itemBuilder: (context, i) {
        final card = _cards[i];
        return SkinFeatureCard(
          thumbnailUrl: 'https://picsum.photos/seed/${card.seed}/300/400',
          badge: card.title == 'Cinematic Clip'
              ? const GoldBadge('Seedance 2.0')
              : null,
          accentGradientColors: const [
            SkinColors.titleGradStart,
            SkinColors.titleGradEnd,
          ],
          accentBorderWidth: 1.0,
          title: GradientText(
            card.title,
            style: GoogleFonts.urbanist(
              fontSize: 17.sp,
              fontWeight: FontWeight.w700,
              height: 1.2,
            ),
          ),
          subtitle: card.subtitle,
          onTap: () {}, // Creation flows are out of scope for the re-skin.
        );
      },
    );
  }
}

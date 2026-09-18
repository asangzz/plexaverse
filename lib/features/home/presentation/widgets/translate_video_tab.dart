import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/responsive/screen_util.dart';
import '../../../../core/theme/skin_colors.dart';
import '../../../../core/ui/skin/feature_card.dart';
import 'video_translation_sheet.dart';

/// Home — "Translate video" tab body (screenshot 2372).
///
/// Two [SkinFeatureCard]s with green #85E8A1 titles; each thumbnail gets a
/// hairline green border + matching inner shadow (no outer glow) in that
/// same title color. Tapping "Video Dubbing" opens the Video Translation
/// bottom sheet (screenshot 2376).
class TranslateVideoTab extends StatelessWidget {
  const TranslateVideoTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 24.h),
      children: [
        SkinFeatureCard(
          thumbnailUrl:
              'https://picsum.photos/seed/plexa-video-dubbing/300/400',
          accentColor: SkinColors.translateGreen,
          accentBorderWidth: 0.6,
          title: Text('Video Dubbing', style: _titleStyle),
          subtitle: 'Translate any video into 100+ languages',
          onTap: () => showVideoTranslationSheet(context),
        ),
        SizedBox(height: 14.h),
        SkinFeatureCard(
          thumbnailUrl:
              'https://picsum.photos/seed/plexa-audio-dubbing/300/400',
          accentColor: SkinColors.translateGreen,
          accentBorderWidth: 0.6,
          title: Text('Audio Dubbing', style: _titleStyle),
          subtitle: 'Dub the audio, keep the video',
          onTap: () {}, // Creation flows are out of scope for the re-skin.
        ),
      ],
    );
  }

  static TextStyle get _titleStyle => GoogleFonts.urbanist(
    fontSize: 17.sp,
    fontWeight: FontWeight.w700,
    color: SkinColors.translateGreen,
    height: 1.2,
  );
}

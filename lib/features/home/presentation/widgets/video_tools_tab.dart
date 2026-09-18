import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/responsive/screen_util.dart';
import '../../../../core/theme/skin_colors.dart';
import '../../../../core/ui/skin/feature_card.dart';

/// Home — "Video tools" tab body (screenshot 2373).
///
/// Two [SkinFeatureCard]s with magenta #EE7FFF titles; each thumbnail gets
/// a hairline magenta border + matching inner shadow (no outer glow) in
/// that same title color — [SkinColors.toolsMagenta], not the retired
/// `toolsPurpleGlow`, so the accent matches the title exactly.
class VideoToolsTab extends StatelessWidget {
  const VideoToolsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 24.h),
      children: [
        SkinFeatureCard(
          thumbnailUrl:
              'https://picsum.photos/seed/plexa-instant-highlights/300/400',
          accentColor: SkinColors.toolsMagenta,
          accentBorderWidth: 0.6,
          title: Text('Instant Highlights', style: _titleStyle),
          subtitle: 'Extract highlight clips from your video',
          onTap: () {}, // Creation flows are out of scope for the re-skin.
        ),
        SizedBox(height: 14.h),
        SkinFeatureCard(
          thumbnailUrl: 'https://picsum.photos/seed/plexa-motion-cut/300/400',
          accentColor: SkinColors.toolsMagenta,
          accentBorderWidth: 0.6,
          title: Text('Motion Cut', style: _titleStyle),
          subtitle: 'Create a stylized avatar video with captions',
          onTap: () {}, // Creation flows are out of scope for the re-skin.
        ),
      ],
    );
  }

  static TextStyle get _titleStyle => GoogleFonts.urbanist(
    fontSize: 17.sp,
    fontWeight: FontWeight.w700,
    color: SkinColors.toolsMagenta,
    height: 1.2,
  );
}

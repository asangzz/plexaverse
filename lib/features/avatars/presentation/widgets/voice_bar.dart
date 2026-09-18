import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/responsive/screen_util.dart';
import '../../../../core/theme/skin_colors.dart';
import '../../../../core/ui/motion/spring_press.dart';

/// The floating voice bar pinned above the bottom nav on the Avatars tab
/// (screenshot 2369): a near-black stadium (`voiceBarBg` @92%) carrying a
/// brand-cyan play circle, the avatar name over its voice name, and an
/// "Edit voice" outline pill on the right.
///
/// Measured off the reference at the 360dp design grid: bar h54 / r27 with
/// the Ø34 play circle inset 8 from the left, and the h34 pill (white 10%
/// fill, white 18% hairline) inset 10 from the right.
class VoiceBar extends StatelessWidget {
  const VoiceBar({
    required this.name,
    required this.voiceName,
    this.onPlay,
    this.onEditVoice,
    super.key,
  });

  /// Bold headline — the avatar's display name ("Ruchika").
  final String name;

  /// Grey caption — the bound voice's name (also "Ruchika" in the fixture).
  final String voiceName;

  /// Voice preview playback; dead surface (no press response) when null.
  final VoidCallback? onPlay;

  /// Opens the voice editor; dead surface when null.
  final VoidCallback? onEditVoice;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54.h,
      padding: EdgeInsets.only(left: 8.w, right: 10.w),
      decoration: BoxDecoration(
        color: SkinColors.voiceBarBg.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(27.r),
      ),
      child: Row(
        children: <Widget>[
          _PlayCircle(onPlay: onPlay),
          SizedBox(width: 11.w),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.urbanist(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  voiceName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.urbanist(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: SkinColors.dateGrey,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          _EditVoicePill(onEditVoice: onEditVoice),
        ],
      ),
    );
  }
}

/// Ø34 brand-cyan circle with a white play triangle.
class _PlayCircle extends StatelessWidget {
  const _PlayCircle({this.onPlay});

  final VoidCallback? onPlay;

  @override
  Widget build(BuildContext context) {
    return SpringPress(
      enabled: onPlay != null,
      child: GestureDetector(
        onTap: onPlay,
        behavior: HitTestBehavior.opaque,
        child: Container(
          width: 34.r,
          height: 34.r,
          decoration: const BoxDecoration(
            color: SkinColors.brandCyan,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.play_arrow_rounded,
            size: 22.r,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

/// "Edit voice" — h34 stadium, white 10% fill with a white 18% hairline,
/// outline pencil + 14sp semibold label.
class _EditVoicePill extends StatelessWidget {
  const _EditVoicePill({this.onEditVoice});

  final VoidCallback? onEditVoice;

  @override
  Widget build(BuildContext context) {
    return SpringPress(
      enabled: onEditVoice != null,
      child: GestureDetector(
        onTap: onEditVoice,
        behavior: HitTestBehavior.opaque,
        child: Container(
          height: 34.h,
          padding: EdgeInsets.symmetric(horizontal: 13.w),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.10),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.18),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(17.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(Icons.edit_outlined, size: 14.r, color: Colors.white),
              SizedBox(width: 6.w),
              Text(
                'Edit voice',
                style: GoogleFonts.urbanist(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

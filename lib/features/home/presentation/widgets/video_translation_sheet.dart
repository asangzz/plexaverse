import 'package:flutter/material.dart';

import '../../../../core/responsive/screen_util.dart';
import '../../../../core/theme/skin_colors.dart';
import '../../../../core/ui/skin/icon_tile_row.dart';
import '../../../../core/ui/skin/sheet_scaffold.dart';

/// Opens the Video Translation bottom sheet (screenshot 2376) over the
/// dimmed Home screen. Root navigator so the sheet covers the tab bar.
Future<void> showVideoTranslationSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    useRootNavigator: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: 0.6),
    builder: (context) => const VideoTranslationSheet(),
  );
}

/// Video Translation sheet body (screenshot 2376): #161616 surface, X on
/// the left with a centered "Video Translation" title, then three
/// [SkinIconTileRow]s (#202020 r24 h72, gap 12, purple #2B2233 icon tiles
/// with #E081FF line glyphs, chevrons) — Upload video / Record video /
/// Upload video URL.
class VideoTranslationSheet extends StatelessWidget {
  const VideoTranslationSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    return SkinSheetScaffold(
      backgroundColor: SkinColors.vtSheetBg,
      header: SkinSheetHeader.closeLeading,
      title: 'Video Translation',
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 20.h + bottomInset),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SkinIconTileRow(
              icon: Icons.smart_display_outlined,
              title: 'Upload video',
              subtitle: 'Choose a video from your gallery',
              radius: 24,
              onTap: () {}, // Upload flow is out of scope for the re-skin.
            ),
            SizedBox(height: 12.h),
            SkinIconTileRow(
              icon: Icons.videocam_outlined,
              title: 'Record video',
              subtitle: 'Record yourself using your camera',
              radius: 24,
              onTap: () {}, // Record flow is out of scope for the re-skin.
            ),
            SizedBox(height: 12.h),
            SkinIconTileRow(
              icon: Icons.link_rounded,
              title: 'Upload video URL',
              subtitle: 'Upload a link of your video',
              radius: 24,
              onTap: () {}, // URL flow is out of scope for the re-skin.
            ),
          ],
        ),
      ),
    );
  }
}

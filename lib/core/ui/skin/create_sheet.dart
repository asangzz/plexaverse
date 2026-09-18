import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../responsive/screen_util.dart';
import '../../theme/skin_colors.dart';
import 'gold_badge.dart';
import 'icon_tile_row.dart';
import 'sheet_scaffold.dart';

/// Opens the Create bottom sheet (screenshot 2377) — launched from the FAB.
///
/// Per spec: ~92% screen height, background [SkinColors.sheetDarkest]
/// (#151515), 24-radius top corners with a drag handle and no title row
/// ([SkinSheetHeader.none]). Static content only — every row is a tappable
/// no-op that simply closes the sheet for now.
Future<void> showCreateSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const FractionallySizedBox(
      heightFactor: 0.92,
      alignment: Alignment.bottomCenter,
      child: _CreateSheetBody(),
    ),
  );
}

/// Sheet content per screenshot 2377, top to bottom:
///
///  * "Create avatars" section header
///    - Clone Yourself (cyan tile) / Design an Avatar (cyan-blue tile)
///  * "Create videos" section header
///    - caps label "TALKING HEAD AVATAR VIDEOS" + 5 green-tile rows
///      (Cinematic Clip carries an inline "Seedance 2.0" [GoldBadge])
///    - caps label "PROMOTIONAL VIDEOS" + UGC Ad row
///
/// Two row tints per 2377: the avatar rows sit on dark-teal #17242B with a
/// teal #224C59 tile and a cyan #39B1E0 line glyph; the video rows sit on
/// dark-olive #222B22 with an olive #364227 tile and a FILLED glyph carrying
/// the lime→green gradient (#CFFC58 → #56D273, ShaderMask).
///
/// Material icon stand-ins for the screenshot glyphs (closest match, since
/// the originals are custom artwork):
///  * Clone Yourself — person bust in a frame with a sparkle →
///    [Icons.face_retouching_natural] (face with sparkle).
///  * Design an Avatar — diagonal magic wand with tiny x-sparkles →
///    [Icons.auto_fix_normal] (wand, single sparkle).
///  * Photo to Video — overlapping photo + play tiles with a swap arrow →
///    [Icons.video_camera_back_rounded] (photo + video camera composite).
///  * Quick Avatar Video — filled person bust in a rounded square →
///    [Icons.portrait_rounded].
///  * Prompt to Video — thick marker-wand with two sparkles →
///    [Icons.auto_fix_high] (wand with sparkles).
///  * Motion Cut — pencil at 45° → [Icons.edit] (filled per 2377).
///  * Cinematic Clip — stacked overlapping media frames →
///    [Icons.perm_media] (filled per 2377).
///  * UGC Ad — shopping tote bag → [Icons.shopping_bag] (filled per 2377).
class _CreateSheetBody extends StatelessWidget {
  const _CreateSheetBody();

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewPaddingOf(context).bottom;

    return SkinSheetScaffold(
      backgroundColor: SkinColors.sheetDarkest,
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, bottomInset + 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SectionHeader('Create avatars'),
            SizedBox(height: 14.h),
            _row(
              context,
              icon: Icons.face_retouching_natural,
              title: 'Clone Yourself',
              subtitle: 'Record yourself to create a realistic avatar',
              avatarRow: true,
            ),
            SizedBox(height: 12.h),
            _row(
              context,
              icon: Icons.auto_fix_normal,
              title: 'Design an Avatar',
              subtitle: 'Generate avatar from a prompt',
              avatarRow: true,
            ),
            SizedBox(height: 24.h),
            const _SectionHeader('Create videos'),
            SizedBox(height: 16.h),
            const _CapsLabel('TALKING HEAD AVATAR VIDEOS'),
            SizedBox(height: 12.h),
            _row(
              context,
              icon: Icons.video_camera_back_rounded,
              title: 'Photo to Video',
              subtitle: 'Turn any photo into an avatar video',
            ),
            SizedBox(height: 12.h),
            _row(
              context,
              icon: Icons.portrait_rounded,
              title: 'Quick Avatar Video',
              subtitle: 'Quickly create single-scene avatar video',
            ),
            SizedBox(height: 12.h),
            _row(
              context,
              icon: Icons.auto_fix_high,
              title: 'Prompt to Video',
              subtitle: 'Turn any idea into a compelling video',
            ),
            SizedBox(height: 12.h),
            _row(
              context,
              icon: Icons.edit,
              title: 'Motion Cut',
              subtitle: 'Create a stylized avatar video with captions',
            ),
            SizedBox(height: 12.h),
            _row(
              context,
              icon: Icons.perm_media,
              title: 'Cinematic Clip',
              subtitle: 'Cast your avatar in a cinematic scene',
              titleBadge: const GoldBadge('Seedance 2.0'),
            ),
            SizedBox(height: 20.h),
            const _CapsLabel('PROMOTIONAL VIDEOS'),
            SizedBox(height: 12.h),
            _row(
              context,
              icon: Icons.shopping_bag,
              title: 'UGC Ad',
              subtitle: 'Create an ad showcasing your product',
            ),
          ],
        ),
      ),
    );
  }

  /// A Create-sheet row, no chevron (2377 rows have none). Video rows
  /// (default) are dark-olive with a lime→green gradient glyph; the two
  /// [avatarRow]s are dark-teal with a solid cyan line glyph. Tapping is a
  /// no-op for now: it just closes the sheet.
  Widget _row(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    bool avatarRow = false,
    Widget? titleBadge,
  }) {
    return SkinIconTileRow(
      icon: icon,
      title: title,
      subtitle: subtitle,
      backgroundColor:
          avatarRow ? SkinColors.createRowTeal : SkinColors.createRowGreen,
      tileColor: avatarRow ? SkinColors.tileCyanBg : SkinColors.tileGreenBg,
      iconColor: SkinColors.tileCyanIcon,
      iconGradient: avatarRow
          ? null
          : const LinearGradient(
              colors: [SkinColors.limeGradStart, SkinColors.limeGradEnd],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
      titleBadge: titleBadge,
      showChevron: false,
      onTap: () => Navigator.of(context).pop(),
    );
  }
}

/// "Create avatars" / "Create videos" section header — 22sp bold white.
/// Headers use Sora per the spec's typography note (body stays Urbanist).
class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.sora(
        fontSize: 22.sp,
        fontWeight: FontWeight.w700,
        color: Colors.white,
        height: 1.2,
      ),
    );
  }
}

/// Caps group label ("TALKING HEAD AVATAR VIDEOS" / "PROMOTIONAL VIDEOS") —
/// 12sp semibold #7A7A7A with 1.2 letter-spacing, per spec.
class _CapsLabel extends StatelessWidget {
  const _CapsLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.urbanist(
        fontSize: 12.sp,
        fontWeight: FontWeight.w600,
        color: SkinColors.capsLabelGrey,
        letterSpacing: 1.2,
        height: 1.2,
      ),
    );
  }
}

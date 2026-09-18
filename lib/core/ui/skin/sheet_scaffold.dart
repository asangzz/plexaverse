import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../responsive/screen_util.dart';
import '../../theme/skin_colors.dart';

/// Header layout variants for [SkinSheetScaffold].
enum SkinSheetHeader {
  /// Drag handle only — the Create sheet (screenshot 2377).
  none,

  /// X in a circle on the left, title centered — the Video Translation
  /// sheet (screenshot 2376).
  closeLeading,

  /// Title on the left, X on the right — the Subscription sheet
  /// (screenshot 2375).
  closeTrailing,
}

/// Bottom-sheet chrome shared by the Subscription (2375), Video
/// Translation (2376) and Create (2377) sheets.
///
/// Per spec: 24-radius top corners, centered #4A4A4A drag handle (32×4
/// r2), then one of three [SkinSheetHeader] title rows, then the caller's
/// [child]. Background color varies per sheet (#151515 / #161616) so it
/// is a required parameter.
///
/// Use inside `showModalBottomSheet(backgroundColor: Colors.transparent)`
/// so this widget owns the rounded surface.
class SkinSheetScaffold extends StatelessWidget {
  const SkinSheetScaffold({
    required this.backgroundColor,
    required this.child,
    this.header = SkinSheetHeader.none,
    this.title,
    this.onClose,
    super.key,
  }) : assert(
         header == SkinSheetHeader.none || title != null,
         'title is required when a header row is shown',
       );

  /// Sheet surface — [SkinColors.sheetDarkest] (Subscription/Create) or
  /// [SkinColors.vtSheetBg] (Video Translation).
  final Color backgroundColor;

  /// Sheet body, placed below the handle/header. The caller supplies its
  /// own scrolling/padding.
  final Widget child;

  final SkinSheetHeader header;

  /// Header title text (16–17sp semibold white, per variant).
  final String? title;

  /// Close-button action; defaults to `Navigator.pop`.
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      child: ColoredBox(
        color: backgroundColor,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle — 32×4 r2 #4A4A4A, 8dp below the top edge.
            Padding(
              padding: EdgeInsets.only(top: 8.h),
              child: Container(
                width: 32.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: SkinColors.dragHandle,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            if (header != SkinSheetHeader.none) _buildHeader(context),
            Flexible(child: child),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final close = _CloseButton(
      onTap: onClose ?? () => Navigator.of(context).pop(),
    );

    switch (header) {
      case SkinSheetHeader.closeLeading:
        // 2376 — X left, centered 16sp semibold title.
        return Padding(
          padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 8.h),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Align(alignment: Alignment.centerLeft, child: close),
              Text(
                title!,
                style: GoogleFonts.urbanist(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  height: 1.2,
                ),
              ),
            ],
          ),
        );
      case SkinSheetHeader.closeTrailing:
        // 2375 — 17sp semibold title left, X right.
        return Padding(
          padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 8.h),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title!,
                  style: GoogleFonts.urbanist(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
              ),
              close,
            ],
          ),
        );
      case SkinSheetHeader.none:
        return const SizedBox.shrink();
    }
  }
}

/// Round close (X) button used by both header variants — 32 circle,
/// white-10% fill, white 18 glyph (matches the X chips in 2375/2376).
class _CloseButton extends StatelessWidget {
  const _CloseButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 32.r,
        height: 32.r,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.10),
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.close_rounded, size: 18.r, color: Colors.white),
      ),
    );
  }
}

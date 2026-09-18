import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/network/internet_monitor.dart';
import '../../../../core/responsive/screen_util.dart';
import '../../../../core/theme/skin_colors.dart';
import '../../../../core/ui/motion/spring_press.dart';
import '../../../../core/ui/skin/page_background.dart';
import '../../../../core/ui/widgets/network_error_view.dart';
import '../../../../core/ui/widgets/skeleton_box.dart';
import '../../application/avatars_controller.dart';
import '../../domain/avatars_repository.dart';
import '../widgets/voice_bar.dart';

// Grid geometry measured off the reference screenshot (2369) on the 360dp
// design grid: 12 outer margin, 12 gaps, r20 cards, cell 162×288.
const double _kGridMargin = 12;
const double _kGridGap = 12;
const double _kCardRadius = 20;
const double _kCardAspectRatio = 162 / 288;

/// Avatars tab (screenshot 2369).
///
/// deepNavy background; the identity header pill (circle photo, name,
/// "21 looks", swap circle); a 2-column portrait grid whose first cell is
/// the green→cyan "Add look" card and the rest are look photos with a
/// kebab circle; and the floating [VoiceBar] pinned above the bottom nav
/// (the grid scrolls behind it).
///
/// `AsyncValue` drives the designed states: loading → skeleton (no layout
/// shift), error → shared network-error view (online-first; auto-reloads
/// when connectivity returns), data → the tab.
class AvatarsPage extends ConsumerWidget {
  const AvatarsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Online-first recovery: if the load failed and connectivity returns,
    // re-fire it without requiring a manual retry.
    ref.listen<InternetStatus>(internetMonitorProvider, (previous, next) {
      final wasOffline = previous?.isOffline ?? false;
      if (wasOffline &&
          !next.isOffline &&
          ref.read(avatarsControllerProvider).hasError) {
        ref.invalidate(avatarsControllerProvider);
      }
    });

    final overview = ref.watch(avatarsControllerProvider);
    return Scaffold(
      backgroundColor: SkinColors.deepNavy,
      body: Stack(
        children: [
          // Diagonal navy→black background fitted to the reference set
          // (shared with the Videos and Account screens — SkinPageBackground).
          const Positioned.fill(child: SkinPageBackground()),
          SafeArea(
            bottom: false,
            child: overview.when(
              loading: () => const _AvatarsSkeleton(),
              error: (_, _) => NetworkErrorView(
                onRetry: () {
                  ref.read(internetMonitorProvider.notifier).recheck();
                  ref.invalidate(avatarsControllerProvider);
                },
              ),
              data: (data) =>
                  _AvatarsBody(profile: data.profile, looks: data.looks),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Data state ──────────────────────────────────────────────────────────────

/// Header pill + grid, with the voice bar floating over the grid's bottom.
class _AvatarsBody extends StatelessWidget {
  const _AvatarsBody({required this.profile, required this.looks});

  final AvatarProfile profile;
  final List<AvatarLook> looks;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 12.h),
              child: _ProfileHeaderPill(profile: profile),
            ),
            Expanded(child: _LooksGrid(looks: looks)),
          ],
        ),
        Positioned(
          left: 16.w,
          right: 16.w,
          bottom: 12.h,
          child: VoiceBar(
            name: profile.name,
            voiceName: profile.voiceName,
            // TODO(avatars): wire voice preview + editor when they ship.
            onPlay: () {},
            onEditVoice: () {},
          ),
        ),
      ],
    );
  }
}

/// The identity pill: Ø36 photo in a white ring, bold name over the grey
/// looks count, and the swap circle on the right (h44 stadium on
/// `backCircleBg` with a white 8% hairline).
class _ProfileHeaderPill extends StatelessWidget {
  const _ProfileHeaderPill({required this.profile});

  final AvatarProfile profile;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44.h,
      padding: EdgeInsets.only(left: 4.w, right: 6.w),
      decoration: BoxDecoration(
        color: SkinColors.backCircleBg,
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(22.r),
      ),
      child: Row(
        children: <Widget>[
          _ProfilePhoto(imageUrl: profile.avatarUrl),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  profile.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.urbanist(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
                Text(
                  profile.looksLabel,
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
          const _SwapCircle(),
        ],
      ),
    );
  }
}

/// Circle profile photo with a thin white ring.
class _ProfilePhoto extends StatelessWidget {
  const _ProfilePhoto({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36.r,
      height: 36.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 1.5),
      ),
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.cover,
          placeholder: (_, _) => const _ShimmerFill(),
          errorWidget: (_, _, _) =>
              const ColoredBox(color: SkinColors.cardNavyStart),
        ),
      ),
    );
  }
}

/// Ø32 white-10% circle with the swap (repeat) glyph — switches between
/// avatar profiles.
class _SwapCircle extends StatelessWidget {
  const _SwapCircle();

  @override
  Widget build(BuildContext context) {
    return SpringPress(
      child: GestureDetector(
        // TODO(avatars): wire the avatar-profile switcher when it ships.
        onTap: () {},
        behavior: HitTestBehavior.opaque,
        child: Container(
          width: 32.r,
          height: 32.r,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.10),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.repeat_rounded, size: 18.r, color: Colors.white),
        ),
      ),
    );
  }
}

/// 2-column portrait grid: leading "Add look" gradient card, then the look
/// photos. Bottom padding keeps the last row clear of the floating voice
/// bar (54 + 12 margin + breathing room).
class _LooksGrid extends StatelessWidget {
  const _LooksGrid({required this.looks});

  final List<AvatarLook> looks;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.fromLTRB(_kGridMargin.w, 0, _kGridMargin.w, 90.h),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: _kGridGap.w,
        mainAxisSpacing: _kGridGap.w,
        childAspectRatio: _kCardAspectRatio,
      ),
      itemCount: looks.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) return const _AddLookCard();
        return _LookCard(look: looks[index - 1]);
      },
    );
  }
}

/// Leading grid cell — vertical green→cyan gradient with a thin white plus
/// above "Add look" (plus sits a touch above the card's centre, matching
/// the reference).
class _AddLookCard extends StatelessWidget {
  const _AddLookCard();

  @override
  Widget build(BuildContext context) {
    return SpringPress(
      child: GestureDetector(
        // TODO(avatars): wire look capture/upload when it ships.
        onTap: () {},
        behavior: HitTestBehavior.opaque,
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[
                SkinColors.addLookGradStart,
                SkinColors.addLookGradEnd,
              ],
            ),
            borderRadius: BorderRadius.circular(_kCardRadius.r),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CustomPaint(
                size: Size.square(26.r),
                painter: _ThinPlusPainter(strokeWidth: 2.4.r),
              ),
              SizedBox(height: 20.h),
              Text(
                'Add look',
                style: GoogleFonts.urbanist(
                  fontSize: 17.sp,
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

/// Thin white `+` with rounded caps — lighter-weight than any Material
/// icon glyph, matching the reference's hairline plus.
class _ThinPlusPainter extends CustomPainter {
  const _ThinPlusPainter({required this.strokeWidth});

  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final center = size.center(Offset.zero);
    canvas
      ..drawLine(Offset(center.dx, 0), Offset(center.dx, size.height), paint)
      ..drawLine(Offset(0, center.dy), Offset(size.width, center.dy), paint);
  }

  @override
  bool shouldRepaint(_ThinPlusPainter oldDelegate) =>
      oldDelegate.strokeWidth != strokeWidth;
}

/// One look photo card: full-bleed image (dark shimmer while loading) with
/// the kebab in a Ø32 black-40% circle inset 10 from the top-right.
class _LookCard extends StatelessWidget {
  const _LookCard({required this.look});

  final AvatarLook look;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(_kCardRadius.r),
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          CachedNetworkImage(
            imageUrl: look.thumbnailUrl,
            fit: BoxFit.cover,
            placeholder: (_, _) => const _ShimmerFill(),
            errorWidget: (_, _, _) =>
                const ColoredBox(color: SkinColors.cardNavyStart),
          ),
          Positioned(
            top: 10.r,
            right: 10.r,
            child: SpringPress(
              child: GestureDetector(
                // TODO(avatars): wire the look actions menu when it ships.
                onTap: () {},
                behavior: HitTestBehavior.opaque,
                child: Container(
                  width: 32.r,
                  height: 32.r,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.40),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.more_horiz,
                    size: 18.r,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Dark navy shimmer used while network images resolve — fills whatever
/// box it is given (grid cells, the header circle).
class _ShimmerFill extends StatelessWidget {
  const _ShimmerFill();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: SkinColors.cardNavyStart,
      highlightColor: SkinColors.backCircleBg,
      child: const ColoredBox(color: SkinColors.cardNavyStart),
    );
  }
}

// ── Loading state ───────────────────────────────────────────────────────────

/// Skeleton mirroring the loaded layout (header pill + grid cells) so
/// nothing shifts when the data lands. The pill uses the shared pulsing
/// [SkeletonBox]; the grid cells shimmer like the image placeholders they
/// become.
class _AvatarsSkeleton extends StatelessWidget {
  const _AvatarsSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 12.h),
          child: const SkeletonBox(height: 44, radius: 22),
        ),
        Expanded(
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.fromLTRB(_kGridMargin.w, 0, _kGridMargin.w, 0),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: _kGridGap.w,
              mainAxisSpacing: _kGridGap.w,
              childAspectRatio: _kCardAspectRatio,
            ),
            itemCount: 4,
            itemBuilder: (_, _) => ClipRRect(
              borderRadius: BorderRadius.circular(_kCardRadius.r),
              child: const _ShimmerFill(),
            ),
          ),
        ),
      ],
    );
  }
}

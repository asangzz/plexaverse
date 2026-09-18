import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/network/internet_monitor.dart';
import '../../../../core/responsive/screen_util.dart';
import '../../../../core/theme/skin_colors.dart';
import '../../../../core/ui/motion/spring_press.dart';
import '../../../../core/ui/skin/gold_badge.dart';
import '../../../../core/ui/skin/outline_chip.dart';
import '../../../../core/ui/skin/page_background.dart';
import '../../../../core/ui/skin/video_thumb.dart';
import '../../../../core/ui/widgets/network_error_view.dart';
import '../../../../core/ui/widgets/skeleton_box.dart';
import '../../application/videos_controller.dart';
import '../../domain/videos_repository.dart';

/// Category filter chips above the list (screenshot 2354 — "Motion Cut"
/// runs off the right edge, the row H-scrolls).
const List<String> _kFilterChips = <String>[
  'Avatar Video',
  'Video Translation',
  'Video Agent',
  'Motion Cut',
];

/// Videos tab — the video library (screenshot 2354).
///
/// deepNavy background; fixed "Videos" 28sp Sora-bold header; below it one
/// scroll view carrying the H-scroll outline-chip row, the "+ New folder"
/// pill button and the video rows (64dp thumb with duration chip, title,
/// date, optional gold badge, kebab).
///
/// `AsyncValue` drives the designed states: loading → skeleton rows (no
/// layout shift), error → shared network-error view (online-first;
/// auto-reloads when connectivity returns), data → the list.
class VideosPage extends ConsumerWidget {
  const VideosPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Online-first recovery: if the load failed and connectivity returns,
    // re-fire it without requiring a manual retry.
    ref.listen<InternetStatus>(internetMonitorProvider, (previous, next) {
      final wasOffline = previous?.isOffline ?? false;
      if (wasOffline &&
          !next.isOffline &&
          ref.read(videosControllerProvider).hasError) {
        ref.invalidate(videosControllerProvider);
      }
    });

    final videos = ref.watch(videosControllerProvider);
    return Scaffold(
      backgroundColor: SkinColors.deepNavy,
      body: Stack(
        children: [
          // Diagonal navy→black background fitted to 2354 (shared with the
          // Avatars and Account screens — see SkinPageBackground).
          const Positioned.fill(child: SkinPageBackground()),
          SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 20.w, top: 12.h, right: 20.w),
                  child: Text(
                    'Videos',
                    style: GoogleFonts.sora(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      height: 1.2,
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                Expanded(
                  child: videos.when(
                    loading: () => const _VideosSkeleton(),
                    error: (_, _) => NetworkErrorView(
                      onRetry: () {
                        ref.read(internetMonitorProvider.notifier).recheck();
                        ref.invalidate(videosControllerProvider);
                      },
                    ),
                    data: (items) => _VideosList(items: items),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Data state ──────────────────────────────────────────────────────────────

/// Chips + "+ New folder" + rows in one scroll view under the fixed header.
class _VideosList extends StatelessWidget {
  const _VideosList({required this.items});

  final List<VideoItem> items;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.only(bottom: 24.h),
      children: <Widget>[
        const _FilterChipsRow(),
        SizedBox(height: 16.h),
        const _NewFolderButton(),
        SizedBox(height: 8.h),
        for (final item in items) _VideoRow(item: item),
      ],
    );
  }
}

/// The horizontally scrolling outline-chip row.
class _FilterChipsRow extends StatelessWidget {
  const _FilterChipsRow();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: <Widget>[
          for (var i = 0; i < _kFilterChips.length; i++) ...<Widget>[
            if (i > 0) SizedBox(width: 10.w),
            SkinOutlineChip(label: _kFilterChips[i], onTap: () {}),
          ],
        ],
      ),
    );
  }
}

/// "+ New folder" — full-width h48 r24 pill on #212444 (spec `newFolderBg`).
class _NewFolderButton extends StatelessWidget {
  const _NewFolderButton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: SpringPress(
        child: GestureDetector(
          // TODO(videos): wire folder creation when the backend ships.
          onTap: () {},
          behavior: HitTestBehavior.opaque,
          child: Container(
            height: 48.h,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: SkinColors.newFolderBg,
              borderRadius: BorderRadius.circular(24.r),
            ),
            child: Text(
              '+ New folder',
              style: GoogleFonts.urbanist(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                height: 1.2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// One library row: 64×64 thumb (duration chip inside), title 16sp
/// semibold, date 13sp grey, optional gold badge, kebab at the right.
class _VideoRow extends StatelessWidget {
  const _VideoRow({required this.item});

  final VideoItem item;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 92.h,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Row(
          children: <Widget>[
            SkinVideoThumb(
              imageUrl: item.thumbnailUrl,
              duration: item.durationLabel,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.urbanist(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      height: 1.2,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    item.dateLabel,
                    style: GoogleFonts.urbanist(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      color: SkinColors.dateGrey,
                      height: 1.2,
                    ),
                  ),
                  if (item.badgeLabel != null) ...<Widget>[
                    SizedBox(height: 6.h),
                    GoldBadge(item.badgeLabel!),
                  ],
                ],
              ),
            ),
            SizedBox(width: 8.w),
            Icon(Icons.more_vert, size: 20.r, color: SkinColors.kebabGrey),
          ],
        ),
      ),
    );
  }
}

// ── Loading state ───────────────────────────────────────────────────────────

/// Skeleton mirroring the loaded layout (chips → button → rows) so nothing
/// shifts when the data lands. Static under Reduce Motion via [SkeletonBox].
class _VideosSkeleton extends StatelessWidget {
  const _VideosSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      children: <Widget>[
        Row(
          children: <Widget>[
            for (var i = 0; i < 3; i++) ...<Widget>[
              if (i > 0) SizedBox(width: 10.w),
              const SkeletonBox(height: 34, width: 104, radius: 17),
            ],
          ],
        ),
        SizedBox(height: 16.h),
        const SkeletonBox(height: 48, radius: 24),
        SizedBox(height: 8.h),
        for (var i = 0; i < 5; i++)
          SizedBox(
            height: 92.h,
            child: Row(
              children: <Widget>[
                const SkeletonBox(height: 64, width: 64, radius: 12),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SkeletonBox(height: 16, width: 160, radius: 6),
                      SizedBox(height: 8.h),
                      const SkeletonBox(height: 12, width: 96, radius: 6),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

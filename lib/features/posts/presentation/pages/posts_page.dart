import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../core/responsive/screen_util.dart';
import '../../../../core/theme/plexaverse_colors.dart';
import '../../../../core/ui/widgets/glass_card.dart';
import '../../../../core/ui/widgets/status_badge.dart';
import '../../application/posts_controllers.dart';
import '../../domain/post_entity.dart';
import '../posts_context_ext.dart';
import '../post_status_ui.dart';
import '../widgets/post_detail_sheet.dart';

// ── Page ──────────────────────────────────────────────────────────────────────

/// The Posts tab (shell branch 1). Watches the reactive Drift-backed posts
/// stream and post counts; filters are pure client-side state (no pagination,
/// per `feature-orders-products.md`). Visuals ported verbatim from the
/// layer-first `presentation/features/posts/pages/posts_page.dart`.
class PostsPage extends ConsumerStatefulWidget {
  const PostsPage({super.key});

  @override
  ConsumerState<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends ConsumerState<PostsPage> {
  // 0=All, 1=Published, 2=Scheduled, 3=Draft, 4=Failed
  int _selectedFilter = 0;

  static const _filterStatuses = <PostStatus?>[
    null, // All
    PostStatus.published,
    PostStatus.scheduled,
    PostStatus.draft,
    PostStatus.failed,
  ];

  static const _filterLabels = <String>[
    'All',
    'Published',
    'Scheduled',
    'Drafts',
    'Failed',
  ];

  List<PostEntity> _filtered(List<PostEntity> all) {
    final status = _filterStatuses[_selectedFilter];
    if (status == null) return all;
    return all.where((p) => p.status == status).toList();
  }

  @override
  Widget build(BuildContext context) {
    final allPostsAsync = ref.watch(allPostsProvider);
    final countsAsync = ref.watch(postCountsProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: allPostsAsync.when(
        loading: () => _buildShell(context, countsAsync, [], loading: true),
        error: (err, _) =>
            _buildShell(context, countsAsync, [], error: err.toString()),
        data: (posts) => _buildShell(context, countsAsync, posts),
      ),
    );
  }

  Widget _buildShell(
    BuildContext context,
    AsyncValue<Map<PostStatus, int>> countsAsync,
    List<PostEntity> allPosts, {
    bool loading = false,
    String? error,
  }) {
    final counts = countsAsync.maybeWhen(
      data: (c) => c,
      orElse: () => <PostStatus, int>{},
    );
    final total = counts.values.fold(0, (a, b) => a + b);
    final visible = _filtered(allPosts);

    return CustomScrollView(
      slivers: [
        // ── App bar ──────────────────────────────────────────────────────────
        SliverAppBar(
          pinned: true,
          elevation: 0,
          scrolledUnderElevation: 0,
          titleSpacing: 16,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Posts',
                style: GoogleFonts.sora(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: context.colors.onSurface,
                  height: 1.1,
                ),
              ),
              Text(
                loading ? 'Loading…' : '$total total',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: context.colors.onSurface.withValues(alpha: 0.5),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.search_rounded, size: 22.r),
              color: context.colors.onSurface.withValues(alpha: 0.7),
              onPressed: () => context.showSnackBar('Search coming soon'),
            ),
            IconButton(
              icon: Icon(Icons.tune_rounded, size: 22.r),
              color: context.colors.onSurface.withValues(alpha: 0.7),
              onPressed: () => context.showSnackBar('Filters coming soon'),
            ),
            SizedBox(width: 4.w),
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(52.h),
            child: _FilterChipsRow(
              labels: List.generate(
                _filterLabels.length,
                (i) {
                  final label = _filterLabels[i];
                  final status = _filterStatuses[i];
                  final count = status == null ? total : (counts[status] ?? 0);
                  return '$label ($count)';
                },
              ),
              selectedIndex: _selectedFilter,
              onSelected: (i) => setState(() => _selectedFilter = i),
            ),
          ),
        ),

        // ── Body ─────────────────────────────────────────────────────────────
        if (loading)
          SliverPadding(
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
            sliver: const SliverToBoxAdapter(
              child: Center(child: CircularProgressIndicator()),
            ),
          )
        else if (error != null)
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(32.r),
              child: Text(
                'Failed to load posts\n$error',
                textAlign: TextAlign.center,
                style:
                    TextStyle(fontSize: 13.sp, color: PlexaversePalette.error),
              ),
            ),
          )
        else if (visible.isEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(32.r),
              child: GlassCard(
                padding: EdgeInsets.all(24.r),
                child: Column(
                  children: [
                    Text('✍️', style: TextStyle(fontSize: 32.sp)),
                    SizedBox(height: 8.h),
                    Text(
                      'No ${_filterLabels[_selectedFilter].toLowerCase()} posts',
                      style: GoogleFonts.sora(
                          fontSize: 15.sp, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Create your first post and earn +50 XP',
                      style: TextStyle(
                          fontSize: 13.sp,
                          color: context.colors.onSurface
                              .withValues(alpha: 0.55)),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          )
        else
          SliverPadding(
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, index) => _PostCard(post: visible[index]),
                childCount: visible.length,
              ),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10.w,
                mainAxisSpacing: 10.h,
                childAspectRatio: 0.78,
              ),
            ),
          ),
      ],
    );
  }
}

// ── Filter chips row ──────────────────────────────────────────────────────────

class _FilterChipsRow extends StatelessWidget {
  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const _FilterChipsRow({
    required this.labels,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final borderColor =
        isDark ? const Color(0x1FFFFFFF) : const Color(0x1A000000);

    return Container(
      height: 52.h,
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: borderColor, width: 0.5)),
      ),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        itemCount: labels.length,
        separatorBuilder: (_, _) => SizedBox(width: 8.w),
        itemBuilder: (context, index) {
          final isSelected = selectedIndex == index;
          return GestureDetector(
            onTap: () => onSelected(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: isSelected
                    ? PlexaversePalette.primary
                    : (isDark
                        ? const Color(0x14FFFFFF)
                        : const Color(0x0D000000)),
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: isSelected ? PlexaversePalette.primary : borderColor,
                  width: 1,
                ),
              ),
              child: Text(
                labels[index],
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected
                      ? Colors.white
                      : context.colors.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ── Post card ─────────────────────────────────────────────────────────────────

class _PostCard extends StatelessWidget {
  final PostEntity post;
  const _PostCard({required this.post});

  static List<Color> _gradientForStatus(PostStatus status) => switch (status) {
        PostStatus.published => [
            const Color(0xFF6C63FF),
            const Color(0xFF4B44CC)
          ],
        PostStatus.scheduled => [
            const Color(0xFFFFC107),
            const Color(0xFFFF8F00)
          ],
        PostStatus.draft => [const Color(0xFF757575), const Color(0xFF424242)],
        PostStatus.failed => [const Color(0xFFE53935), const Color(0xFFB71C1C)],
      };

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GlassCard(
          radius: 16,
          padding: EdgeInsets.all(12.r),
          onTap: () => showPostDetail(context, post),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Type icon
              Container(
                width: 40.r,
                height: 40.r,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: _gradientForStatus(post.status),
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Center(
                  child: Text(
                    post.initials,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              Expanded(
                child: Text(
                  post.preview,
                  style: TextStyle(
                      fontSize: 12.sp,
                      color: context.colors.onSurface.withValues(alpha: 0.85),
                      height: 1.45),
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(height: 8.h),
              _cardBottom(context, post),
            ],
          ),
        ),
        // Status badge overlay
        Positioned(
          top: 10.h,
          right: 10.w,
          child: StatusBadge(
            label: post.status.label,
            variant: postStatusVariant(post.status),
          ),
        ),
      ],
    );
  }

  Widget _cardBottom(BuildContext context, PostEntity post) {
    final muted = context.colors.onSurface.withValues(alpha: 0.45);
    return switch (post.status) {
      PostStatus.published => Row(
          children: [
            Icon(Icons.visibility_outlined, size: 12.r, color: muted),
            SizedBox(width: 3.w),
            Text(
              post.metrics?.impressionsFormatted ?? '—',
              style: TextStyle(
                  fontSize: 11.sp, color: muted, fontWeight: FontWeight.w500),
            ),
            SizedBox(width: 10.w),
            Icon(Icons.thumb_up_outlined, size: 12.r, color: muted),
            SizedBox(width: 3.w),
            Text(
              post.metrics?.engagementsFormatted ?? '—',
              style: TextStyle(
                  fontSize: 11.sp, color: muted, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      PostStatus.scheduled => Row(
          children: [
            Icon(Icons.calendar_today_outlined,
                size: 11.r, color: PlexaversePalette.warning),
            SizedBox(width: 4.w),
            Flexible(
              child: Text(
                post.scheduledAt != null
                    ? DateFormat('EEE h:mma').format(post.scheduledAt!)
                    : 'Scheduled',
                style: TextStyle(
                    fontSize: 11.sp,
                    color: PlexaversePalette.warning,
                    fontWeight: FontWeight.w600),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      PostStatus.draft => Row(
          children: [
            Icon(Icons.edit_outlined, size: 11.r, color: muted),
            SizedBox(width: 4.w),
            Text('Draft',
                style: TextStyle(
                    fontSize: 11.sp,
                    color: muted,
                    fontWeight: FontWeight.w500)),
          ],
        ),
      PostStatus.failed => TextButton(
          onPressed: () => showPostDetail(context, post),
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            'Retry →',
            style: TextStyle(
                fontSize: 11.sp,
                color: PlexaversePalette.error,
                fontWeight: FontWeight.w700),
          ),
        ),
    };
  }
}

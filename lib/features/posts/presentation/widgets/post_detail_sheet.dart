import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../core/responsive/screen_util.dart';
import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/plexaverse_colors.dart';
import '../../../../core/ui/widgets/glass_card.dart';
import '../../../../core/ui/widgets/status_badge.dart';
import '../../data/posts_repositories.dart';
import '../../domain/posts_repository.dart';
import '../post_status_ui.dart';
import '../posts_context_ext.dart';

// ── Public helper ─────────────────────────────────────────────────────────────

void showPostDetail(BuildContext context, PostEntity post) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black54,
    builder: (_) => PostDetailSheet(post: post),
  );
}

// ── Sheet ─────────────────────────────────────────────────────────────────────

/// Post detail / actions bottom sheet. Ported from the legacy
/// `presentation/features/posts/widgets/post_detail_sheet.dart`; hooks_riverpod
/// → ConsumerStatefulWidget, dartz `.fold()` → try/catch on the single
/// [PostsUnavailable] sentinel, and mutations routed through
/// `postsRepositoryProvider` (which enqueues on the SyncEngine offline queue).
class PostDetailSheet extends ConsumerStatefulWidget {
  final PostEntity post;
  const PostDetailSheet({super.key, required this.post});

  @override
  ConsumerState<PostDetailSheet> createState() => _PostDetailSheetState();
}

class _PostDetailSheetState extends ConsumerState<PostDetailSheet> {
  bool _actionLoading = false;

  // ── Colours per status ────────────────────────────────────────────────────
  //
  // Status colour lives in `StatusBadge`/`postStatusVariant` now (see the
  // header); the header avatar keeps a distinct gradient treatment.

  List<Color> _statusGradient(PostStatus s) => switch (s) {
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

  // ── Actions ───────────────────────────────────────────────────────────────

  Future<void> _publishNow() async {
    setState(() => _actionLoading = true);
    try {
      await ref.read(postsRepositoryProvider).publishNow(widget.post.id);
      if (!mounted) return;
      setState(() => _actionLoading = false);
      context.showSnackBar('Published!');
      Navigator.of(context).pop();
    } on PostsUnavailable {
      if (!mounted) return;
      setState(() => _actionLoading = false);
      context.showSnackBar('Failed to publish', isError: true);
    }
  }

  Future<void> _retryPost() async {
    setState(() => _actionLoading = true);
    try {
      await ref.read(postsRepositoryProvider).retryPost(widget.post.id);
      if (!mounted) return;
      setState(() => _actionLoading = false);
      context.showSnackBar('Retrying in 5 minutes…');
      Navigator.of(context).pop();
    } on PostsUnavailable {
      if (!mounted) return;
      setState(() => _actionLoading = false);
      context.showSnackBar('Retry failed', isError: true);
    }
  }

  Future<void> _deletePost() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(ctx).colorScheme.surface,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        title: Text(
          'Delete post?',
          style: GoogleFonts.sora(fontWeight: FontWeight.w700, fontSize: 16.sp),
        ),
        content: Text(
          'This cannot be undone.',
          style: TextStyle(
              fontSize: 14.sp,
              color: context.colors.onSurface.withValues(alpha: 0.6)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text('Cancel', style: TextStyle(fontSize: 14.sp)),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(
              'Delete',
              style: TextStyle(
                  fontSize: 14.sp,
                  color: PlexaversePalette.error,
                  fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    setState(() => _actionLoading = true);
    try {
      await ref.read(postsRepositoryProvider).deletePost(widget.post.id);
      if (!mounted) return;
      setState(() => _actionLoading = false);
      context.showSnackBar('Post deleted');
      Navigator.of(context).pop();
    } on PostsUnavailable {
      if (!mounted) return;
      setState(() => _actionLoading = false);
      context.showSnackBar('Delete failed', isError: true);
    }
  }

  void _editPost() {
    Navigator.of(context).pop();
    context.push(RoutePaths.createPost, extra: widget.post);
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    final isDark = context.isDark;
    final sheetBg = isDark
        ? const Color(0xFF1A1A2E)
        : Theme.of(context).colorScheme.surface;
    final muted = context.colors.onSurface.withValues(alpha: 0.5);

    return DraggableScrollableSheet(
      initialChildSize: 0.72,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      snap: true,
      snapSizes: const [0.72, 0.95],
      builder: (_, scrollCtrl) => Container(
        decoration: BoxDecoration(
          color: sheetBg,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 30,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Column(
          children: [
            // Drag handle
            Padding(
              padding: EdgeInsets.only(top: 12.h, bottom: 4.h),
              child: Container(
                width: 36.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: context.colors.onSurface.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),

            // Scrollable body
            Expanded(
              child: CustomScrollView(
                controller: scrollCtrl,
                slivers: [
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 24.h),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        _buildHeader(post),
                        SizedBox(height: 20.h),
                        if (post.hookLine != null &&
                            post.hookLine!.isNotEmpty) ...[
                          _buildHookLine(post.hookLine!),
                          SizedBox(height: 12.h),
                        ],
                        _buildContent(post.content),
                        SizedBox(height: 20.h),
                        if (post.status == PostStatus.published &&
                            post.metrics != null)
                          _buildMetricsCard(post.metrics!),
                        if (post.status == PostStatus.scheduled &&
                            post.scheduledAt != null)
                          _buildScheduleCard(post.scheduledAt!),
                        if (post.status == PostStatus.failed &&
                            post.errorMessage != null)
                          _buildErrorCard(post.errorMessage!),
                        SizedBox(height: 12.h),
                        _buildMeta(post, muted),
                        SizedBox(height: 24.h),
                        _buildActions(post),
                        // Bottom safe-area padding
                        SizedBox(
                            height: MediaQuery.of(context).padding.bottom +
                                8.h),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Header ────────────────────────────────────────────────────────────────

  Widget _buildHeader(PostEntity post) {
    return Row(
      children: [
        Container(
          width: 44.r,
          height: 44.r,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: _statusGradient(post.status),
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Center(
            child: Text(
              post.initials,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700),
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post.platform.toUpperCase(),
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  color: context.colors.onSurface.withValues(alpha: 0.5),
                  letterSpacing: 1.2,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                _dateLabel(post),
                style: TextStyle(
                    fontSize: 12.sp,
                    color: context.colors.onSurface.withValues(alpha: 0.55)),
              ),
            ],
          ),
        ),
        StatusBadge(
          label: post.status.label,
          variant: postStatusVariant(post.status),
        ),
      ],
    );
  }

  String _dateLabel(PostEntity post) {
    final fmt = DateFormat('EEE, MMM d · h:mma');
    if (post.status == PostStatus.published && post.publishedAt != null) {
      return 'Published ${fmt.format(post.publishedAt!)}';
    }
    if (post.status == PostStatus.scheduled && post.scheduledAt != null) {
      return 'Scheduled for ${fmt.format(post.scheduledAt!)}';
    }
    return 'Updated ${fmt.format(post.updatedAt)}';
  }

  // ── Hook line ─────────────────────────────────────────────────────────────

  Widget _buildHookLine(String hook) {
    return GlassCard(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 3.w,
            height: 40.h,
            decoration: BoxDecoration(
              color: PlexaversePalette.primary,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hook',
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: PlexaversePalette.primary,
                    letterSpacing: 0.8,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  hook,
                  style: GoogleFonts.sora(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: context.colors.onSurface,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Body content ──────────────────────────────────────────────────────────

  Widget _buildContent(String content) {
    return GlassCard(
      padding: EdgeInsets.all(16.r),
      child: SelectableText(
        content,
        style: TextStyle(
          fontSize: 14.sp,
          color: context.colors.onSurface.withValues(alpha: 0.85),
          height: 1.65,
        ),
      ),
    );
  }

  // ── Metrics ───────────────────────────────────────────────────────────────

  Widget _buildMetricsCard(PostMetricsEntity m) {
    return Column(
      children: [
        GlassCard(
          padding: EdgeInsets.all(16.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Performance',
                style: GoogleFonts.sora(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: context.colors.onSurface.withValues(alpha: 0.6),
                ),
              ),
              SizedBox(height: 14.h),
              Row(
                children: [
                  _MetricTile(
                    icon: Icons.visibility_outlined,
                    label: 'Impressions',
                    value: m.impressionsFormatted,
                  ),
                  _MetricTile(
                    icon: Icons.thumb_up_outlined,
                    label: 'Engagements',
                    value: m.engagementsFormatted,
                  ),
                  _MetricTile(
                    icon: Icons.favorite_border_rounded,
                    label: 'Likes',
                    value: '${m.likes}',
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Row(
                children: [
                  _MetricTile(
                    icon: Icons.chat_bubble_outline_rounded,
                    label: 'Comments',
                    value: '${m.comments}',
                  ),
                  _MetricTile(
                    icon: Icons.repeat_rounded,
                    label: 'Reposts',
                    value: '${m.reposts}',
                  ),
                  _MetricTile(
                    icon: Icons.percent_rounded,
                    label: 'Eng. Rate',
                    value: '${m.engagementRate.toStringAsFixed(1)}%',
                    highlight: true,
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 12.h),
      ],
    );
  }

  // ── Schedule card ─────────────────────────────────────────────────────────

  Widget _buildScheduleCard(DateTime scheduledAt) {
    return Column(
      children: [
        GlassCard(
          padding: EdgeInsets.all(16.r),
          child: Row(
            children: [
              Container(
                width: 40.r,
                height: 40.r,
                decoration: BoxDecoration(
                  color: PlexaversePalette.warning.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(Icons.schedule_rounded,
                    color: PlexaversePalette.warning, size: 20.r),
              ),
              SizedBox(width: 14.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Scheduled for',
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: context.colors.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    DateFormat('EEEE, MMMM d · h:mm a').format(scheduledAt),
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: PlexaversePalette.warning,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 12.h),
      ],
    );
  }

  // ── Error card ────────────────────────────────────────────────────────────

  Widget _buildErrorCard(String errorMessage) {
    return Column(
      children: [
        GlassCard(
          padding: EdgeInsets.all(16.r),
          bgOverride: PlexaversePalette.error.withValues(alpha: 0.08),
          borderOverride: PlexaversePalette.error.withValues(alpha: 0.25),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.error_outline_rounded,
                  color: PlexaversePalette.error, size: 20.r),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Publish failed',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: PlexaversePalette.error,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      errorMessage,
                      style: TextStyle(
                          fontSize: 12.sp,
                          color:
                              PlexaversePalette.error.withValues(alpha: 0.75)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 12.h),
      ],
    );
  }

  // ── Meta ──────────────────────────────────────────────────────────────────

  Widget _buildMeta(PostEntity post, Color muted) {
    final fmt = DateFormat('MMM d, yyyy · h:mm a');
    return Row(
      children: [
        Icon(Icons.access_time_rounded, size: 12.r, color: muted),
        SizedBox(width: 5.w),
        Text(
          'Created ${fmt.format(post.createdAt)}',
          style: TextStyle(fontSize: 11.sp, color: muted),
        ),
      ],
    );
  }

  // ── Actions ───────────────────────────────────────────────────────────────

  Widget _buildActions(PostEntity post) {
    if (_actionLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        // Primary action
        if (post.status == PostStatus.draft)
          _ActionButton(
            label: 'Publish Now',
            icon: Icons.rocket_launch_rounded,
            gradient: const [
              PlexaversePalette.primary,
              PlexaversePalette.primaryDark
            ],
            onTap: _publishNow,
          ),
        if (post.status == PostStatus.failed)
          _ActionButton(
            label: 'Retry Post',
            icon: Icons.refresh_rounded,
            gradient: const [PlexaversePalette.error, Color(0xFFB71C1C)],
            onTap: _retryPost,
          ),

        SizedBox(height: 10.h),

        // Secondary actions row
        Row(
          children: [
            Expanded(
              child: _OutlineButton(
                label: 'Edit',
                icon: Icons.edit_outlined,
                onTap: _editPost,
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: _OutlineButton(
                label: 'Copy',
                icon: Icons.copy_rounded,
                onTap: () {
                  Clipboard.setData(ClipboardData(text: post.content));
                  context.showSnackBar('Copied to clipboard');
                },
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: _OutlineButton(
                label: 'Delete',
                icon: Icons.delete_outline_rounded,
                color: PlexaversePalette.error,
                onTap: _deletePost,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ── Metric tile ───────────────────────────────────────────────────────────────

class _MetricTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool highlight;

  const _MetricTile({
    required this.icon,
    required this.label,
    required this.value,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    final color =
        highlight ? PlexaversePalette.primary : context.colors.onSurface;
    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 16.r, color: color.withValues(alpha: 0.65)),
          SizedBox(height: 4.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            label,
            style:
                TextStyle(fontSize: 9.sp, color: color.withValues(alpha: 0.5)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ── Gradient action button ─────────────────────────────────────────────────────

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final List<Color> gradient;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        onTap();
      },
      child: Container(
        height: 48.h,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: gradient),
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: gradient.first.withValues(alpha: 0.35),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 18.r),
            SizedBox(width: 8.w),
            Text(
              label,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Outline secondary button ───────────────────────────────────────────────────

class _OutlineButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color? color;
  final VoidCallback onTap;

  const _OutlineButton({
    required this.label,
    required this.icon,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final fg = color ?? context.colors.onSurface;
    final borderColor =
        isDark ? const Color(0x1FFFFFFF) : const Color(0x1A000000);

    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: Container(
        height: 42.h,
        decoration: BoxDecoration(
          color: isDark ? const Color(0x14FFFFFF) : const Color(0x06000000),
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
              color: color?.withValues(alpha: 0.35) ?? borderColor),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: fg, size: 15.r),
            SizedBox(width: 5.w),
            Text(
              label,
              style: TextStyle(
                  fontSize: 12.sp, color: fg, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

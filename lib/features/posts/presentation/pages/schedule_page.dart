import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/responsive/screen_util.dart';
import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/plexaverse_colors.dart';
import '../../../../core/ui/widgets/glass_card.dart';
import '../../../../core/ui/widgets/status_badge.dart';
import '../../application/posts_controllers.dart';
import '../../domain/post_entity.dart';
import '../post_status_ui.dart';
import '../posts_context_ext.dart';
import '../widgets/post_detail_sheet.dart';

// ── Week data helpers ─────────────────────────────────────────────────────────

class _DayData {
  final String abbrev;
  final int date;
  final DateTime dateTime;
  final bool hasPosts;

  const _DayData({
    required this.abbrev,
    required this.date,
    required this.dateTime,
    required this.hasPosts,
  });
}

List<_DayData> _buildWeek(DateTime anchor, List<PostEntity> posts) {
  // Start from Monday of anchor's week
  final monday = anchor.subtract(Duration(days: anchor.weekday - 1));
  const abbrevs = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  return List.generate(7, (i) {
    final day = monday.add(Duration(days: i));
    final dayStart = DateTime(day.year, day.month, day.day);
    final dayEnd = dayStart.add(const Duration(days: 1));

    final hasPosts = posts.any((p) {
      final dt = p.scheduledAt ?? p.publishedAt;
      if (dt == null) return false;
      return dt.isAfter(dayStart) && dt.isBefore(dayEnd);
    });

    return _DayData(
      abbrev: abbrevs[i],
      date: day.day,
      dateTime: day,
      hasPosts: hasPosts,
    );
  });
}

int _todayIndexInWeek(DateTime now) => now.weekday - 1; // Mon=0

// ── Page ──────────────────────────────────────────────────────────────────────

/// The content calendar — a full-screen route (`RoutePaths.schedule`) outside
/// the shell. Ported from the layer-first
/// `presentation/features/schedule/pages/schedule_page.dart`; hooks_riverpod →
/// ConsumerStatefulWidget, `allPostsProvider` sourced from the posts feature.
class SchedulePage extends ConsumerStatefulWidget {
  const SchedulePage({super.key});

  @override
  ConsumerState<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends ConsumerState<SchedulePage> {
  late int _selectedDayIndex;
  final _today = DateTime.now();

  static const _startHour = 6;
  static const _endHour = 22;

  @override
  void initState() {
    super.initState();
    _selectedDayIndex = _todayIndexInWeek(_today);
  }

  String _formatHour(int hour) {
    if (hour == 0) return '12 AM';
    if (hour < 12) return '$hour AM';
    if (hour == 12) return '12 PM';
    return '${hour - 12} PM';
  }

  /// Posts for the selected day (scheduled or published).
  List<PostEntity> _postsForDay(
      List<PostEntity> allPosts, DateTime selectedDay) {
    final dayStart =
        DateTime(selectedDay.year, selectedDay.month, selectedDay.day);
    final dayEnd = dayStart.add(const Duration(days: 1));
    return allPosts.where((p) {
      final dt = p.scheduledAt ?? p.publishedAt;
      if (dt == null) return false;
      return dt.isAfter(dayStart) && dt.isBefore(dayEnd);
    }).toList();
  }

  /// Find a post for a given hour in the day's posts.
  PostEntity? _postForHour(List<PostEntity> dayPosts, int hour) {
    for (final p in dayPosts) {
      final dt = p.scheduledAt ?? p.publishedAt;
      if (dt != null && dt.hour == hour) return p;
    }
    return null;
  }

  DateTime _slotDateTime(DateTime selectedDay, int hour) {
    return DateTime(selectedDay.year, selectedDay.month, selectedDay.day, hour);
  }

  @override
  Widget build(BuildContext context) {
    final allPostsAsync = ref.watch(allPostsProvider);
    final isDark = context.isDark;
    final borderColor =
        isDark ? const Color(0x1FFFFFFF) : const Color(0x1A000000);

    return allPostsAsync.when(
      loading: () => _buildScaffold(context, [], borderColor),
      error: (_, _) => _buildScaffold(context, [], borderColor),
      data: (posts) => _buildScaffold(context, posts, borderColor),
    );
  }

  Widget _buildScaffold(
      BuildContext context, List<PostEntity> allPosts, Color borderColor) {
    final weekDays = _buildWeek(_today, allPosts);
    final selectedDay = weekDays[_selectedDayIndex].dateTime;
    final dayPosts = _postsForDay(allPosts, selectedDay);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, size: 22.r),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(
          'Schedule',
          style: GoogleFonts.sora(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: context.colors.onSurface,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add_rounded, size: 24.r),
            color: PlexaversePalette.primary,
            onPressed: () => context.push(RoutePaths.createPost),
            tooltip: 'New post',
          ),
          SizedBox(width: 4.w),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(72.h),
          child: _WeekStrip(
            days: weekDays,
            selectedIndex: _selectedDayIndex,
            todayIndex: _todayIndexInWeek(_today),
            onDayTap: (i) => setState(() => _selectedDayIndex = i),
            borderColor: borderColor,
          ),
        ),
      ),

      body: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        itemCount: _endHour - _startHour + 1,
        itemBuilder: (context, index) {
          final hour = _startHour + index;
          final post = _postForHour(dayPosts, hour);
          final slotTime = _slotDateTime(selectedDay, hour);
          return _TimeSlotRow(
            timeLabel: _formatHour(hour),
            post: post,
            onEntryTap:
                post != null ? () => showPostDetail(context, post) : null,
            onEmptyTap: () {
              context.push(RoutePaths.createPost, extra: slotTime);
            },
          );
        },
      ),
    );
  }
}

// ── Week strip ────────────────────────────────────────────────────────────────

class _WeekStrip extends StatelessWidget {
  final List<_DayData> days;
  final int selectedIndex;
  final int todayIndex;
  final ValueChanged<int> onDayTap;
  final Color borderColor;

  const _WeekStrip({
    required this.days,
    required this.selectedIndex,
    required this.todayIndex,
    required this.onDayTap,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72.h,
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: borderColor, width: 0.5)),
      ),
      child: Row(
        children: List.generate(days.length, (i) {
          final day = days[i];
          final isSelected = i == selectedIndex;
          final isToday = i == todayIndex;

          return Expanded(
            child: GestureDetector(
              onTap: () => onDayTap(i),
              behavior: HitTestBehavior.opaque,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    day.abbrev,
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: isSelected
                          ? PlexaversePalette.primary
                          : isToday
                              ? context.colors.onSurface
                                  .withValues(alpha: 0.7)
                              : context.colors.onSurface
                                  .withValues(alpha: 0.4),
                      fontWeight: isSelected || isToday
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 32.r,
                    height: 32.r,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? PlexaversePalette.primary
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(16.r),
                      border: isToday && !isSelected
                          ? Border.all(
                              color: PlexaversePalette.primary
                                  .withValues(alpha: 0.5))
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        '${day.date}',
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                          color: isSelected
                              ? Colors.white
                              : context.colors.onSurface
                                  .withValues(alpha: 0.85),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  AnimatedOpacity(
                    opacity: day.hasPosts ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: Container(
                      width: 5.r,
                      height: 5.r,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.white
                            : PlexaversePalette.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ── Time slot row ─────────────────────────────────────────────────────────────

class _TimeSlotRow extends StatelessWidget {
  final String timeLabel;
  final PostEntity? post;
  final VoidCallback? onEntryTap;
  final VoidCallback onEmptyTap;

  const _TimeSlotRow({
    required this.timeLabel,
    required this.post,
    required this.onEmptyTap,
    this.onEntryTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Time label
            SizedBox(
              width: 44.w,
              child: Padding(
                padding: EdgeInsets.only(top: 10.h),
                child: Text(
                  timeLabel,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: context.colors.onSurface.withValues(alpha: 0.4),
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ),
            SizedBox(width: 12.w),

            // Divider + slot content
            Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 14.h),
                    child: Divider(
                      height: 1,
                      thickness: 0.5,
                      color: context.colors.onSurface.withValues(alpha: 0.1),
                    ),
                  ),
                  SizedBox(height: 6.h),
                  if (post != null)
                    _ScheduledEntryCard(post: post!, onTap: onEntryTap ?? () {})
                  else
                    _EmptySlot(onTap: onEmptyTap),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Scheduled entry card ──────────────────────────────────────────────────────

class _ScheduledEntryCard extends StatelessWidget {
  final PostEntity post;
  final VoidCallback onTap;

  const _ScheduledEntryCard({required this.post, required this.onTap});

  List<Color> get _gradient => switch (post.status) {
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

  Color get _accentColor => switch (post.status) {
        PostStatus.published => PlexaversePalette.primary,
        PostStatus.scheduled => PlexaversePalette.warning,
        PostStatus.failed => PlexaversePalette.error,
        PostStatus.draft => PlexaversePalette.grey600,
      };

  @override
  Widget build(BuildContext context) {
    final statusLabel = post.status.label;

    return SizedBox(
      height: 64.h,
      child: GlassCard(
        radius: 12,
        borderOverride: _accentColor.withValues(alpha: 0.4),
        onTap: onTap,
        child: Row(
          children: [
            // Left accent border
            Container(
              width: 3.w,
              decoration: BoxDecoration(
                color: _accentColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.r),
                  bottomLeft: Radius.circular(12.r),
                ),
              ),
            ),
            SizedBox(width: 10.w),

            // Icon
            Container(
              width: 32.r,
              height: 32.r,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: _gradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Center(
                child: Text(
                  post.initials,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w700),
                ),
              ),
            ),
            SizedBox(width: 10.w),

            // Title + subtitle
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.preview,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: context.colors.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    '${post.platform.substring(0, 1).toUpperCase()}${post.platform.substring(1)} · $statusLabel',
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: context.colors.onSurface.withValues(alpha: 0.45),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),

            // Status badge
            StatusBadge(
              label: statusLabel,
              variant: postStatusVariant(post.status),
            ),
            SizedBox(width: 10.w),
          ],
        ),
      ),
    );
  }
}

// ── Empty slot ────────────────────────────────────────────────────────────────

class _EmptySlot extends StatelessWidget {
  final VoidCallback onTap;
  const _EmptySlot({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: isDark ? const Color(0x1AFFFFFF) : const Color(0x1A000000),
            width: 1.5,
          ),
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.add_circle_outline_rounded,
                size: 14.r,
                color: context.colors.onSurface.withValues(alpha: 0.25),
              ),
              SizedBox(width: 4.w),
              Text(
                'Tap to schedule',
                style: TextStyle(
                  fontSize: 11.sp,
                  color: context.colors.onSurface.withValues(alpha: 0.25),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

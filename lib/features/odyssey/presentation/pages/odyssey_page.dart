import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/responsive/screen_util.dart';
import '../../../../core/theme/plexaverse_colors.dart';
import '../../../../core/ui/widgets/glass_card.dart';
import '../../application/odyssey_controllers.dart';
import '../../domain/mission_entity.dart';
import '../../domain/user_stats_entity.dart';

// ── Page ──────────────────────────────────────────────────────────────────────

/// Odyssey gamification screen: XP hero card + animated mission path.
///
/// Ported from `presentation/features/odyssey/pages/odyssey_page.dart`. Visuals
/// are unchanged (RULINGS: product UI stays); imports were rewired to the
/// core/feature layers and colours read from [PlexaversePalette] (the raw
/// brand tokens, formerly `AppColors`).
class OdysseyPage extends ConsumerStatefulWidget {
  const OdysseyPage({super.key});

  @override
  ConsumerState<OdysseyPage> createState() => _OdysseyPageState();
}

class _OdysseyPageState extends ConsumerState<OdysseyPage>
    with TickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final statsAsync = ref.watch(userStatsProvider);
    final missionsAsync = ref.watch(missionsProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          // ── AppBar ──────────────────────────────────────────────────────────
          SliverAppBar(
            pinned: true,
            elevation: 0,
            scrolledUnderElevation: 0,
            titleSpacing: 16.w,
            title: statsAsync.when(
              data: (stats) => Row(
                children: [
                  Icon(Icons.rocket_launch_rounded,
                      color: PlexaversePalette.primary, size: 22.r),
                  SizedBox(width: 8.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Odyssey',
                        style: GoogleFonts.sora(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: onSurface,
                          height: 1.1,
                        ),
                      ),
                      Text(
                        'Level ${stats.level} · ${stats.levelTitle}',
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: onSurface.withValues(alpha: 0.55),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              loading: () => Row(
                children: [
                  Icon(Icons.rocket_launch_rounded,
                      color: PlexaversePalette.primary, size: 22.r),
                  SizedBox(width: 8.w),
                  Text(
                    'Odyssey',
                    style: GoogleFonts.sora(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: onSurface,
                      height: 1.1,
                    ),
                  ),
                ],
              ),
              error: (_, _) => Row(
                children: [
                  Icon(Icons.rocket_launch_rounded,
                      color: PlexaversePalette.primary, size: 22.r),
                  SizedBox(width: 8.w),
                  Text(
                    'Odyssey',
                    style: GoogleFonts.sora(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: onSurface,
                      height: 1.1,
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.emoji_events_outlined,
                    color: PlexaversePalette.warning, size: 24.r),
                onPressed: () {},
              ),
              SizedBox(width: 8.w),
            ],
          ),

          // ── Content ─────────────────────────────────────────────────────────
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            sliver: statsAsync.when(
              loading: () => const SliverToBoxAdapter(
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (err, _) => SliverToBoxAdapter(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.r),
                    child: Text(
                      'Failed to load stats: $err',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: PlexaversePalette.error,
                      ),
                    ),
                  ),
                ),
              ),
              data: (stats) => SliverList(
                delegate: SliverChildListDelegate([
                  SizedBox(height: 16.h),

                  // ── XP Hero Card ───────────────────────────────────────────
                  _XpHeroCard(stats: stats),

                  SizedBox(height: 24.h),

                  // ── Section title ──────────────────────────────────────────
                  Text(
                    'Mission Path',
                    style: GoogleFonts.sora(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: onSurface,
                    ),
                  ),

                  SizedBox(height: 16.h),

                  // ── Mission list ───────────────────────────────────────────
                  missionsAsync.when(
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (err, _) => Center(
                      child: Text(
                        'Failed to load missions: $err',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: PlexaversePalette.error,
                        ),
                      ),
                    ),
                    data: (missionList) => _MissionList(
                      missions: missionList,
                      pulseAnimation: _pulseAnimation,
                    ),
                  ),

                  SizedBox(height: 24.h),
                ]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── XP Hero Card ──────────────────────────────────────────────────────────────

class _XpHeroCard extends StatelessWidget {
  final UserStatsEntity stats;

  const _XpHeroCard({required this.stats});

  @override
  Widget build(BuildContext context) {
    // XP within the current level (each level = 2000 XP)
    const xpPerLevel = 2000;
    final xpInLevel = stats.xp % xpPerLevel;
    final xpProgress = (xpInLevel / xpPerLevel).clamp(0.0, 1.0);

    return GradientCard(
      colors: const [
        PlexaversePalette.primary,
        PlexaversePalette.primaryDark,
        Color(0xFF2D1B88),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      radius: 20,
      padding: EdgeInsets.all(20.r),
      shadows: [
        BoxShadow(
          color: PlexaversePalette.primary.withValues(alpha: 0.4),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ],
      child: Row(
        children: [
          // Left: level + title
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Level ${stats.level}',
                  style: GoogleFonts.sora(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    height: 1.1,
                  ),
                ),
                SizedBox(height: 4.h),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.w,
                    vertical: 3.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    stats.levelTitle,
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Middle: circular XP ring
          Expanded(
            flex: 4,
            child: Center(
              child: SizedBox(
                width: 90.r,
                height: 90.r,
                child: CustomPaint(
                  painter: _XpRingPainter(progress: xpProgress),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '$xpInLevel',
                          style: GoogleFonts.sora(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            height: 1.1,
                          ),
                        ),
                        Text(
                          '/ $xpPerLevel XP',
                          style: TextStyle(
                            fontSize: 9.sp,
                            color: Colors.white.withValues(alpha: 0.7),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Right: streak + weekly badges
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _HeroBadge(emoji: '🔥', label: '${stats.streakDays}'),
                SizedBox(height: 8.h),
                _HeroBadge(
                  emoji: '📅',
                  label: '${stats.weeklyXp} / ${stats.weeklyXpGoal} XP',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── XP Ring painter ───────────────────────────────────────────────────────────

class _XpRingPainter extends CustomPainter {
  final double progress;

  const _XpRingPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 16.r) / 2;
    const strokeWidth = 8.0;

    // Background arc
    final bgPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi,
      false,
      bgPaint,
    );

    // Progress arc
    final progressPaint = Paint()
      ..color = PlexaversePalette.secondary
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(_XpRingPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

// ── Hero badge ────────────────────────────────────────────────────────────────

class _HeroBadge extends StatelessWidget {
  final String emoji;
  final String label;

  const _HeroBadge({required this.emoji, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        '$emoji $label',
        style: TextStyle(
          fontSize: 11.sp,
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// ── Mission list with connector line ─────────────────────────────────────────

class _MissionList extends StatelessWidget {
  final List<MissionEntity> missions;
  final Animation<double> pulseAnimation;

  const _MissionList({
    required this.missions,
    required this.pulseAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Vertical connector line — behind nodes, starts at first node center
        Positioned(
          left: 31.w, // aligns with center of 32px circle (16px + 16px card padding)
          top: 28.h,
          bottom: 28.h,
          child: Container(
            width: 2.w,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  PlexaversePalette.success,
                  PlexaversePalette.success,
                  PlexaversePalette.primary,
                  PlexaversePalette.grey600.withValues(alpha: 0.4),
                  PlexaversePalette.grey600.withValues(alpha: 0.2),
                ],
                stops: const [0.0, 0.35, 0.55, 0.75, 1.0],
              ),
            ),
          ),
        ),

        // Mission cards
        Column(
          children: List.generate(missions.length, (i) {
            final mission = missions[i];
            return Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: _MissionCard(
                mission: mission,
                pulseAnimation: mission.isActive ? pulseAnimation : null,
              ),
            );
          }),
        ),
      ],
    );
  }
}

// ── Single mission card ───────────────────────────────────────────────────────

class _MissionCard extends StatelessWidget {
  final MissionEntity mission;
  final Animation<double>? pulseAnimation;

  const _MissionCard({required this.mission, this.pulseAnimation});

  Color get _borderColor {
    return switch (mission.status) {
      MissionStatus.done => PlexaversePalette.success,
      MissionStatus.active => PlexaversePalette.primary,
      MissionStatus.next => PlexaversePalette.grey600.withValues(alpha: 0.4),
      MissionStatus.locked => PlexaversePalette.grey600.withValues(alpha: 0.3),
    };
  }

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final isLocked = mission.isLocked;

    return Opacity(
      opacity: isLocked ? 0.5 : 1.0,
      child: GlassCard(
        padding: EdgeInsets.all(16.r),
        borderOverride: _borderColor,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Status circle
            _StatusCircle(mission: mission, pulseAnimation: pulseAnimation),

            SizedBox(width: 12.w),

            // Center: title + description + optional progress bar
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mission.title,
                    style: GoogleFonts.urbanist(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: onSurface,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    mission.description,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: onSurface.withValues(alpha: 0.55),
                      height: 1.3,
                    ),
                  ),
                  if (mission.isActive) ...[
                    SizedBox(height: 8.h),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4.r),
                      child: LinearProgressIndicator(
                        value: mission.progressFraction,
                        backgroundColor:
                            PlexaversePalette.primary.withValues(alpha: 0.15),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                            PlexaversePalette.primary),
                        minHeight: 6.h,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '${mission.progress} / ${mission.total}',
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: PlexaversePalette.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            SizedBox(width: 8.w),

            // Right: XP badge + start button for active
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _XpBadge(mission: mission),
                if (mission.isActive) ...[
                  SizedBox(height: 8.h),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            PlexaversePalette.primary,
                            PlexaversePalette.primaryDark,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        'START →',
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Status circle ─────────────────────────────────────────────────────────────

class _StatusCircle extends StatelessWidget {
  final MissionEntity mission;
  final Animation<double>? pulseAnimation;

  const _StatusCircle({required this.mission, this.pulseAnimation});

  @override
  Widget build(BuildContext context) {
    final size = 32.r;

    if (mission.isCompleted) {
      return Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          color: PlexaversePalette.success,
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.check_rounded, color: Colors.white, size: 18.r),
      );
    }

    if (mission.isActive && pulseAnimation != null) {
      return AnimatedBuilder(
        animation: pulseAnimation!,
        builder: (context, child) {
          return Transform.scale(
            scale: pulseAnimation!.value,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    PlexaversePalette.primary,
                    PlexaversePalette.primaryDark,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: PlexaversePalette.primary.withValues(
                        alpha: 0.5 * pulseAnimation!.value),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Icon(Icons.play_arrow_rounded,
                  color: Colors.white, size: 18.r),
            ),
          );
        },
      );
    }

    // next or locked
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: PlexaversePalette.grey600.withValues(alpha: 0.5),
          width: 2,
        ),
      ),
      child: Icon(
        Icons.lock_outline_rounded,
        color: PlexaversePalette.grey600,
        size: 16.r,
      ),
    );
  }
}

// ── XP badge ──────────────────────────────────────────────────────────────────

class _XpBadge extends StatelessWidget {
  final MissionEntity mission;

  const _XpBadge({required this.mission});

  @override
  Widget build(BuildContext context) {
    if (mission.isCompleted) {
      return Text(
        'earned',
        style: TextStyle(
          fontSize: 11.sp,
          color: PlexaversePalette.success,
          fontWeight: FontWeight.w600,
        ),
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: PlexaversePalette.primary.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: PlexaversePalette.primary.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Text(
        '+${mission.xpReward} XP',
        style: TextStyle(
          fontSize: 11.sp,
          color: PlexaversePalette.primary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

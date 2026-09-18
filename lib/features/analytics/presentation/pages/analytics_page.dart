import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/network/internet_monitor.dart';
import '../../../../core/responsive/screen_util.dart';
import '../../../../core/theme/plexaverse_colors.dart';
import '../../../../core/ui/widgets/glass_card.dart';
import '../../../../core/ui/widgets/network_error_view.dart';
import '../../application/analytics_controller.dart';
import '../../domain/analytics_entity.dart';

// ── Analytics page ────────────────────────────────────────────────────────────
//
// Ported from `lib/presentation/features/analytics/pages/analytics_page.dart`.
// Visuals are unchanged (RULINGS: product UI stays); the plumbing was rewired
// to the feature slice: watches `analyticsControllerProvider` instead of the
// posts-layer `analyticsDataProvider`, reads colours from `context.brand` /
// the `ColorScheme` instead of the legacy `AppColors`, uses the core
// `screen_util` `.sp/.w/.h/.r` extensions, and adds the shared
// `NetworkErrorView` error state + offline-recovery listener that every
// data-backed feature page installs.
//
// TODO(l10n): the analytics-specific copy below ('Analytics', 'Total
// Impressions', 'Top Post This Week', etc.) is hardcoded English pending the
// analytics ARB keys (not part of the finalized Plexaverse l10n). These were
// literals in the pre-migration page too.

class AnalyticsPage extends ConsumerStatefulWidget {
  const AnalyticsPage({super.key});

  @override
  ConsumerState<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends ConsumerState<AnalyticsPage> {
  int _selectedRange = 0; // 0=7D, 1=14D, 2=30D, 3=90D

  static const _ranges = ['7D', '14D', '30D', '90D'];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    // Offline-recovery: when connectivity returns and the load had failed,
    // re-run the controller so the screen recovers without a manual retry.
    ref.listen<InternetStatus>(internetMonitorProvider, (previous, next) {
      final wasOffline = previous?.isOffline ?? false;
      if (wasOffline &&
          !next.isOffline &&
          ref.read(analyticsControllerProvider).hasError) {
        ref.invalidate(analyticsControllerProvider);
      }
    });

    final analyticsAsync = ref.watch(analyticsControllerProvider);

    return Scaffold(
      backgroundColor: scheme.surface,
      body: CustomScrollView(
        slivers: [
          // ── App bar ────────────────────────────────────────────────────────
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
                  'Analytics',
                  style: GoogleFonts.sora(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    color: scheme.onSurface,
                    height: 1.1,
                  ),
                ),
                Text(
                  'Last 7 days',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: scheme.onSurface.withValues(alpha: 0.5),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.share_outlined, size: 22.r),
                color: scheme.onSurface.withValues(alpha: 0.7),
                onPressed: () => _snack(context, 'Sharing analytics…'),
              ),
              _DateRangeButton(
                onTap: () => _snack(context, 'Opening date range picker'),
              ),
              SizedBox(width: 8.w),
            ],
          ),

          // ── Range pills ────────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: _RangePillsRow(
              ranges: _ranges,
              selectedIndex: _selectedRange,
              onSelected: (i) => setState(() => _selectedRange = i),
            ),
          ),

          // ── Content ────────────────────────────────────────────────────────
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            sliver: analyticsAsync.when(
              loading: () => SliverToBoxAdapter(
                child: Column(
                  children: [
                    SizedBox(height: 16.h),
                    // Hero card shimmer
                    Container(
                      height: 220.h,
                      decoration: BoxDecoration(
                        color: scheme.onSurface.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    // Sub-metrics shimmer
                    Row(
                      children: List.generate(
                        3,
                        (i) => Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(right: i < 2 ? 8.w : 0),
                            child: Container(
                              height: 90.h,
                              decoration: BoxDecoration(
                                color:
                                    scheme.onSurface.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              error: (_, _) => SliverFillRemaining(
                hasScrollBody: false,
                child: NetworkErrorView(
                  onRetry: () {
                    ref.read(internetMonitorProvider.notifier).recheck();
                    ref.invalidate(analyticsControllerProvider);
                  },
                ),
              ),
              data: (analytics) => SliverList(
                delegate: SliverChildListDelegate([
                  SizedBox(height: 16.h),

                  // Hero metric card
                  _HeroMetricCard(analytics: analytics),

                  SizedBox(height: 16.h),

                  // Sub-metrics row
                  _SubMetricsRow(analytics: analytics),

                  SizedBox(height: 16.h),

                  // Top performer
                  _TopPerformerCard(analytics: analytics),

                  SizedBox(height: 16.h),

                  // Best times
                  _BestTimesCard(analytics: analytics),

                  SizedBox(height: 32.h),
                ]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static void _snack(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}

// ── Date range button ─────────────────────────────────────────────────────────

class _DateRangeButton extends StatelessWidget {
  final VoidCallback onTap;

  const _DateRangeButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
        margin: EdgeInsets.only(right: 4.w),
        decoration: BoxDecoration(
          color: primary.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: primary.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.calendar_month_outlined, size: 13.r, color: primary),
            SizedBox(width: 4.w),
            Text(
              'May 14–21',
              style: TextStyle(
                fontSize: 11.sp,
                color: primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Range pills row ───────────────────────────────────────────────────────────

class _RangePillsRow extends StatelessWidget {
  final List<String> ranges;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const _RangePillsRow({
    required this.ranges,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return SizedBox(
      height: 44.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        itemCount: ranges.length,
        separatorBuilder: (_, _) => SizedBox(width: 8.w),
        itemBuilder: (context, i) {
          final isSelected = i == selectedIndex;
          return GestureDetector(
            onTap: () => onSelected(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 5.h),
              decoration: BoxDecoration(
                color: isSelected
                    ? primary
                    : primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: isSelected
                      ? primary
                      : primary.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Text(
                ranges[i],
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected
                      ? Colors.white
                      : primary.withValues(alpha: 0.8),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ── Hero metric card ──────────────────────────────────────────────────────────

class _HeroMetricCard extends StatelessWidget {
  final AnalyticsEntity analytics;

  const _HeroMetricCard({required this.analytics});

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    final scheme = Theme.of(context).colorScheme;
    final chartData = analytics.impressionSeries.isNotEmpty
        ? analytics.impressionSeries
        : const [0.2, 0.8, 0.6, 1.0, 0.85, 0.9, 0.7];

    final deltaPositive = analytics.impressionsDelta >= 0;

    return GradientCard(
      colors: [scheme.primary, brand.primaryDark],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      radius: 20,
      padding: EdgeInsets.all(20.r),
      shadows: [
        BoxShadow(
          color: scheme.primary.withValues(alpha: 0.35),
          blurRadius: 24,
          offset: const Offset(0, 10),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label
          Text(
            'Total Impressions',
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.white.withValues(alpha: 0.7),
              fontWeight: FontWeight.w500,
              letterSpacing: 0.3,
            ),
          ),
          SizedBox(height: 6.h),

          // Big number
          Text(
            analytics.formattedImpressions,
            style: GoogleFonts.sora(
              fontSize: 40.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              height: 1.05,
            ),
          ),
          SizedBox(height: 6.h),

          // Delta row
          Row(
            children: [
              Container(
                width: 18.r,
                height: 18.r,
                decoration: BoxDecoration(
                  color: (deltaPositive ? brand.success : scheme.error)
                      .withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Icon(
                  deltaPositive
                      ? Icons.arrow_upward_rounded
                      : Icons.arrow_downward_rounded,
                  size: 12.r,
                  color: deltaPositive ? brand.success : scheme.error,
                ),
              ),
              SizedBox(width: 6.w),
              Text(
                '${analytics.impressionsDeltaLabel} vs last period',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: deltaPositive ? brand.success : scheme.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),

          // Line chart
          SizedBox(
            width: double.infinity,
            height: 80.h,
            child: CustomPaint(
              painter: _LineChartPainter(data: chartData),
            ),
          ),

          SizedBox(height: 8.h),

          // Day labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
                .map(
                  (d) => Text(
                    d,
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: Colors.white.withValues(alpha: 0.45),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

// ── Line chart painter ────────────────────────────────────────────────────────

class _LineChartPainter extends CustomPainter {
  final List<double> data;

  const _LineChartPainter({required this.data});

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final minVal = data.reduce((a, b) => a < b ? a : b);
    final maxVal = data.reduce((a, b) => a > b ? a : b);
    final range = (maxVal - minVal).clamp(1.0, double.infinity);

    // Map data to canvas coordinates
    final List<Offset> points = [];
    for (int i = 0; i < data.length; i++) {
      final x = i / (data.length - 1) * size.width;
      final normalized = (data[i] - minVal) / range;
      final y =
          size.height - normalized * size.height * 0.9 - size.height * 0.05;
      points.add(Offset(x, y));
    }

    // Build smooth cubic bezier path
    final linePath = Path();
    linePath.moveTo(points[0].dx, points[0].dy);

    for (int i = 0; i < points.length - 1; i++) {
      final p0 = i > 0 ? points[i - 1] : points[i];
      final p1 = points[i];
      final p2 = points[i + 1];
      final p3 = i + 2 < points.length ? points[i + 2] : p2;

      // Catmull-Rom → Bezier control points
      final cp1x = p1.dx + (p2.dx - p0.dx) / 6;
      final cp1y = p1.dy + (p2.dy - p0.dy) / 6;
      final cp2x = p2.dx - (p3.dx - p1.dx) / 6;
      final cp2y = p2.dy - (p3.dy - p1.dy) / 6;

      linePath.cubicTo(cp1x, cp1y, cp2x, cp2y, p2.dx, p2.dy);
    }

    // Fill area under the line with gradient
    final fillPath = Path.from(linePath);
    fillPath.lineTo(size.width, size.height);
    fillPath.lineTo(0, size.height);
    fillPath.close();

    final fillPaint = Paint()
      ..shader = ui.Gradient.linear(
        const Offset(0, 0),
        Offset(0, size.height),
        [
          Colors.white.withValues(alpha: 0.18),
          Colors.white.withValues(alpha: 0.0),
        ],
      )
      ..style = PaintingStyle.fill;

    canvas.drawPath(fillPath, fillPaint);

    // Draw the line on top
    final linePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.75)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(linePath, linePaint);

    // Draw dots at each data point
    final dotPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    for (final pt in points) {
      canvas.drawCircle(pt, 3.0, dotPaint);
    }
  }

  @override
  bool shouldRepaint(_LineChartPainter oldDelegate) =>
      oldDelegate.data != data;
}

// ── Sub-metrics row ───────────────────────────────────────────────────────────

class _SubMetricsRow extends StatelessWidget {
  final AnalyticsEntity analytics;

  const _SubMetricsRow({required this.analytics});

  @override
  Widget build(BuildContext context) {
    final metrics = [
      _MetricData(
        label: 'Reactions',
        value: '${analytics.reactions}',
        delta:
            '${analytics.reactionsDelta >= 0 ? '+' : ''}${analytics.reactionsDelta.toStringAsFixed(0)}%',
        positive: analytics.reactionsDelta >= 0,
      ),
      _MetricData(
        label: 'Comments',
        value: '${analytics.comments}',
        delta:
            '${analytics.commentsDelta >= 0 ? '+' : ''}${analytics.commentsDelta.toStringAsFixed(0)}%',
        positive: analytics.commentsDelta >= 0,
      ),
      _MetricData(
        label: 'Reposts',
        value: '${analytics.reposts}',
        delta:
            '${analytics.repostsDelta >= 0 ? '+' : ''}${analytics.repostsDelta.toStringAsFixed(0)}%',
        positive: analytics.repostsDelta >= 0,
      ),
    ];

    return Row(
      children: metrics
          .map(
            (m) => Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: m == metrics.last ? 0 : 8.w,
                ),
                child: _SubMetricCard(data: m),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _MetricData {
  final String label;
  final String value;
  final String delta;
  final bool positive;

  const _MetricData({
    required this.label,
    required this.value,
    required this.delta,
    required this.positive,
  });
}

class _SubMetricCard extends StatelessWidget {
  final _MetricData data;

  const _SubMetricCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    final scheme = Theme.of(context).colorScheme;
    final deltaColor = data.positive ? brand.success : scheme.error;

    return GlassCard(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data.label,
            style: TextStyle(
              fontSize: 11.sp,
              color: scheme.onSurface.withValues(alpha: 0.5),
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            data.value,
            style: GoogleFonts.sora(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: scheme.onSurface,
              height: 1.1,
            ),
          ),
          SizedBox(height: 4.h),
          Row(
            children: [
              Icon(
                data.positive
                    ? Icons.arrow_upward_rounded
                    : Icons.arrow_downward_rounded,
                size: 11.r,
                color: deltaColor,
              ),
              SizedBox(width: 2.w),
              Text(
                data.delta,
                style: TextStyle(
                  fontSize: 11.sp,
                  color: deltaColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Top performer card ────────────────────────────────────────────────────────

class _TopPerformerCard extends StatelessWidget {
  final AnalyticsEntity analytics;

  const _TopPerformerCard({required this.analytics});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final muted = scheme.onSurface.withValues(alpha: 0.5);
    final top = analytics.topPost;

    return GlassCard(
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('🏆', style: TextStyle(fontSize: 16.sp)),
              SizedBox(width: 6.w),
              Text(
                'Top Post This Week',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: muted,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Text(
            top?.preview ??
                'No published posts yet — publish your first post to see insights here.',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: scheme.onSurface,
              height: 1.4,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              _TopStatPill(
                icon: Icons.visibility_outlined,
                label: top != null
                    ? '${_formatCount(top.impressions)} impressions'
                    : '0 impressions',
              ),
              SizedBox(width: 8.w),
              _TopStatPill(
                icon: Icons.favorite_outline_rounded,
                label: top != null
                    ? '${_formatCount(top.engagements)} engagements'
                    : '0 engagements',
              ),
              SizedBox(width: 8.w),
              _TopStatPill(
                icon: Icons.percent_rounded,
                label: top != null
                    ? '${(top.engagementRate * 100).toStringAsFixed(1)}% rate'
                    : '0% rate',
                highlight: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  static String _formatCount(int n) {
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}K';
    return '$n';
  }
}

class _TopStatPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool highlight;

  const _TopStatPill({
    required this.icon,
    required this.label,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    final scheme = Theme.of(context).colorScheme;
    // `info` is the closest brand token to the legacy `AppColors.secondary`
    // used for the highlighted "rate" pill.
    final color =
        highlight ? brand.info : scheme.onSurface.withValues(alpha: 0.55);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: highlight
            ? brand.info.withValues(alpha: 0.1)
            : scheme.onSurface.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11.r, color: color),
          SizedBox(width: 3.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 10.sp,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Best times card ───────────────────────────────────────────────────────────

class _BestTimesCard extends StatelessWidget {
  final AnalyticsEntity analytics;

  const _BestTimesCard({required this.analytics});

  static const _dayLabels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final primary = scheme.primary;
    final weekdayData = analytics.weekdayImpressions;

    // Compute normalized bar heights (0.0–1.0)
    final maxVal =
        weekdayData.isEmpty ? 1 : weekdayData.reduce((a, b) => a > b ? a : b);
    final barHeights =
        weekdayData.map((v) => maxVal > 0 ? v / maxVal : 0.0).toList();

    // Find peak index
    int peakIndex = 0;
    for (int i = 1; i < weekdayData.length; i++) {
      if (weekdayData[i] > weekdayData[peakIndex]) peakIndex = i;
    }

    return GlassCard(
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Best Post Times',
            style: GoogleFonts.sora(
              fontSize: 15.sp,
              fontWeight: FontWeight.w700,
              color: scheme.onSurface,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Based on your audience engagement patterns',
            style: TextStyle(
              fontSize: 11.sp,
              color: scheme.onSurface.withValues(alpha: 0.45),
            ),
          ),
          SizedBox(height: 20.h),

          // Bar chart
          SizedBox(
            height: 80.h,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(barHeights.length, (i) {
                final isPeak = i == peakIndex;
                final barH = barHeights[i] * 80.h;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeOutCubic,
                      width: 28.w,
                      height: barH,
                      decoration: BoxDecoration(
                        color: isPeak
                            ? primary
                            : scheme.onSurface.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(6.r),
                        ),
                        boxShadow: isPeak
                            ? [
                                BoxShadow(
                                  color: primary.withValues(alpha: 0.4),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),

          SizedBox(height: 8.h),

          // Day labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_dayLabels.length, (i) {
              final isPeak = i == peakIndex;
              return SizedBox(
                width: 28.w,
                child: Text(
                  _dayLabels[i],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: isPeak
                        ? primary
                        : scheme.onSurface.withValues(alpha: 0.4),
                    fontWeight: isPeak ? FontWeight.w700 : FontWeight.w400,
                  ),
                ),
              );
            }),
          ),

          SizedBox(height: 14.h),

          // Peak indicator row
          Row(
            children: [
              Container(
                width: 8.r,
                height: 8.r,
                decoration: BoxDecoration(
                  color: primary,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 6.w),
              Expanded(
                child: Text(
                  peakIndex < _dayLabels.length
                      ? '${_dayLabels[peakIndex]} is your peak engagement day'
                      : 'Post consistently to discover your peak day',
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: scheme.onSurface.withValues(alpha: 0.6),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

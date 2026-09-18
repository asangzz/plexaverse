import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/responsive/screen_util.dart';
import '../../../../core/theme/skin_colors.dart';
import '../../../../core/ui/skin/segmented_quota_bar.dart';
import '../../../../core/ui/skin/sheet_scaffold.dart';
import '../../application/subscription_controller.dart';
import '../../domain/subscription_info.dart';
import 'subscription_plan_card.dart';

/// Opens the Subscription bottom sheet (screenshot 2375) over the current
/// route — near-full-height, #151515 surface, "Subscription" title left +
/// close on the right.
Future<void> showSubscriptionSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const SubscriptionSheet(),
  );
}

/// Subscription sheet body — pixel-matched to 2375:
///  * blue gradient plan card (gem + "Creator" + "Manage subscription");
///  * "Included in your plan" 13sp brand-cyan label;
///  * ONE grouped #212121 r16 card with hairline dividers between the
///    Credit Usage (#454545 track, brand-cyan used fill, "Monthly Plan
///    Credits" / "600 credits"), Digital Twin ([SegmentedQuotaBar] 5
///    segments 1 filled, "Fixed quota", "4 avatar slots remaining"),
///    Photo Avatars ("Unlimited") and Recent Activity sections.
class SubscriptionSheet extends ConsumerWidget {
  const SubscriptionSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sub = ref.watch(subscriptionControllerProvider);
    final info = sub.value;

    return SkinSheetScaffold(
      backgroundColor: SkinColors.sheetDarkest,
      header: SkinSheetHeader.closeTrailing,
      title: 'Subscription',
      child: ListView(
        padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
        children: [
          // Gradient plan card — fixture-shaped fallbacks while the mock
          // repository's simulated latency resolves keep the sheet stable.
          SubscriptionPlanCard(
            planName: info?.planName ?? 'Creator',
            source: info?.source ?? 'From Plexaverse web app',
            buttonLabel: 'Manage subscription',
            onButtonTap: () {},
          ),
          SizedBox(height: 20.h),
          Text(
            'Included in your plan',
            style: GoogleFonts.urbanist(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: SkinColors.brandCyan,
              height: 1.2,
            ),
          ),
          SizedBox(height: 12.h),
          sub.when(
            data: (info) => _PlanCard(info: info),
            loading: () => SizedBox(
              height: 280.h,
              child: const Center(
                child: CircularProgressIndicator(color: SkinColors.brandCyan),
              ),
            ),
            error: (_, _) => _RetryBlock(
              onRetry: () => ref.invalidate(subscriptionControllerProvider),
            ),
          ),
        ],
      ),
    );
  }
}

/// The single grouped card: sections divided by 1px white-8% hairlines
/// (2375 shows one continuous #212121 surface, not separate cards).
class _PlanCard extends StatelessWidget {
  const _PlanCard({required this.info});

  final SubscriptionInfo info;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: SkinColors.sheetDark,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CreditUsageSection(info: info),
          const _SectionDivider(),
          _DigitalTwinSection(info: info),
          const _SectionDivider(),
          _SectionHeaderRow(
            icon: Icons.recent_actors_outlined,
            title: 'Photo Avatars',
            trailing: 'Unlimited',
            padding: EdgeInsets.fromLTRB(16.w, 22.h, 16.w, 22.h),
          ),
          const _SectionDivider(),
          _RecentActivitySection(activity: info.recentActivity),
        ],
      ),
    );
  }
}

class _CreditUsageSection extends StatelessWidget {
  const _CreditUsageSection({required this.info});

  final SubscriptionInfo info;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeaderRow(
            icon: Icons.toll_rounded,
            title: 'Credit Usage',
            trailing: info.creditsRemainingLabel,
          ),
          SizedBox(height: 18.h),
          // Used-credits fill (brand cyan, both ends rounded) on the
          // #454545 track — h16 r8 per spec.
          SizedBox(
            height: 16.h,
            width: double.infinity,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: SkinColors.quotaTrackGrey,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: info.usedFraction.clamp(0.0, 1.0),
                  heightFactor: 1,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: SkinColors.brandCyan,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 18.h),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Monthly Plan Credits',
                  style: GoogleFonts.urbanist(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
              ),
              Text(
                info.creditsTotalLabel,
                style: GoogleFonts.urbanist(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  color: SkinColors.navInactive,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DigitalTwinSection extends StatelessWidget {
  const _DigitalTwinSection({required this.info});

  final SubscriptionInfo info;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeaderRow(
            icon: Icons.account_box_outlined,
            title: 'Digital Twin',
            trailing: 'Fixed quota',
          ),
          SizedBox(height: 18.h),
          SegmentedQuotaBar(
            segments: info.avatarSlotsTotal,
            filled: info.avatarSlotsUsed,
          ),
          SizedBox(height: 14.h),
          Text(
            info.avatarSlotsLabel,
            style: GoogleFonts.urbanist(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: SkinColors.navInactive,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _RecentActivitySection extends StatelessWidget {
  const _RecentActivitySection({required this.activity});

  final List<SubscriptionActivity> activity;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeaderRow(
            icon: Icons.access_time_rounded,
            title: 'Recent Activity',
          ),
          SizedBox(height: 6.h),
          for (var i = 0; i < activity.length; i++) ...[
            if (i > 0)
              Padding(
                padding: EdgeInsets.only(left: 60.w),
                child: Container(
                  height: 1,
                  color: Colors.white.withValues(alpha: 0.06),
                ),
              ),
            _ActivityRow(item: activity[i]),
          ],
        ],
      ),
    );
  }
}

/// Icon + 16sp title + optional grey trailing label — the header line of
/// each grouped-card section.
class _SectionHeaderRow extends StatelessWidget {
  const _SectionHeaderRow({
    required this.icon,
    required this.title,
    this.trailing,
    this.padding,
  });

  final IconData icon;
  final String title;
  final String? trailing;

  /// Non-null when the header is the whole section (Photo Avatars).
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final row = Row(
      children: [
        Icon(icon, size: 20.r, color: Colors.white),
        SizedBox(width: 10.w),
        Expanded(
          child: Text(
            title,
            style: GoogleFonts.urbanist(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              height: 1.2,
            ),
          ),
        ),
        if (trailing != null)
          Text(
            trailing!,
            style: GoogleFonts.urbanist(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: SkinColors.navInactive,
              height: 1.2,
            ),
          ),
      ],
    );

    if (padding == null) return row;
    return Padding(padding: padding!, child: row);
  }
}

/// One Recent Activity row — 48 #3A3A3C r8 thumb (duration chip on video
/// items), title + "3h ago · Video" meta, "-3 credits" delta on the right.
class _ActivityRow extends StatelessWidget {
  const _ActivityRow({required this.item});

  final SubscriptionActivity item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Row(
        children: [
          SizedBox(
            width: 48.r,
            height: 48.r,
            child: Stack(
              children: [
                Container(
                  width: 48.r,
                  height: 48.r,
                  decoration: BoxDecoration(
                    color: SkinColors.recentThumbBg,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    Icons.image_outlined,
                    size: 20.r,
                    color: Colors.white.withValues(alpha: 0.45),
                  ),
                ),
                if (item.durationLabel != null)
                  Positioned(
                    left: 0,
                    bottom: 0,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 5.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.75),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(8.r),
                          topRight: Radius.circular(6.r),
                        ),
                      ),
                      child: Text(
                        item.durationLabel!,
                        style: GoogleFonts.urbanist(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          height: 1.15,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.urbanist(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    height: 1.25,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  item.metaLine,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.urbanist(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: SkinColors.navInactive,
                    height: 1.25,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 10.w),
          Text(
            item.creditsLabel,
            style: GoogleFonts.urbanist(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: SkinColors.navInactive,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

/// Compact inline retry for a failed fixture load (auto-retry is globally
/// disabled — recovery is explicit).
class _RetryBlock extends StatelessWidget {
  const _RetryBlock({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.r),
      decoration: BoxDecoration(
        color: SkinColors.sheetDark,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          Text(
            "Couldn't load your plan details.",
            style: GoogleFonts.urbanist(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: SkinColors.navInactive,
            ),
          ),
          SizedBox(height: 12.h),
          TextButton(
            onPressed: onRetry,
            child: Text(
              'Retry',
              style: GoogleFonts.urbanist(
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
                color: SkinColors.brandCyan,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Full-bleed 1px hairline between grouped-card sections (2375 shows one
/// continuous surface split by faint lighter lines).
class _SectionDivider extends StatelessWidget {
  const _SectionDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      width: double.infinity,
      color: Colors.white.withValues(alpha: 0.08),
    );
  }
}

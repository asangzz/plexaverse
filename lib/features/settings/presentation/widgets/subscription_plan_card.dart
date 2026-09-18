import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/responsive/screen_util.dart';
import '../../../../core/theme/skin_colors.dart';
import '../../../../core/ui/motion/spring_press.dart';

/// The blue-gradient plan card shared by the Account page (screenshot 2374:
/// gem + "Creator" + Credit Usage progress + "Manage plan details") and the
/// Subscription sheet (screenshot 2375: gem + "Creator" + "Manage
/// subscription", no credit section).
///
/// Per spec: gradient #0185C9 (top-left) → #022255 (bottom-right), r20,
/// padding 16. The credit block (coins icon + "453 remaining" + white
/// progress on a white-25% track, h6 r3) renders only when
/// [showCreditUsage] is true; the progress FILL is the credits USED
/// fraction (≈25% for 453-of-600 remaining, matching both screenshots).
class SubscriptionPlanCard extends StatelessWidget {
  const SubscriptionPlanCard({
    required this.planName,
    required this.source,
    required this.buttonLabel,
    this.onButtonTap,
    this.showCreditUsage = false,
    this.creditsRemaining = 0,
    this.creditsTotal = 0,
    super.key,
  });

  /// "Creator" — 20sp extra-bold white next to the gold gem.
  final String planName;

  /// "From Plexaverse web app" — 13sp white, right-aligned.
  final String source;

  /// "Manage plan details" (2374) / "Manage subscription" (2375).
  final String buttonLabel;

  final VoidCallback? onButtonTap;

  /// Whether to render the Credit Usage row + progress (2374 yes, 2375 no).
  final bool showCreditUsage;

  final int creditsRemaining;
  final int creditsTotal;

  double get _usedFraction {
    if (creditsTotal <= 0) return 0;
    final used = (creditsTotal - creditsRemaining).clamp(0, creditsTotal);
    return used / creditsTotal;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [SkinColors.subGradStart, SkinColors.subGradEnd],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gem + plan name + provenance (top row of both screenshots).
          Row(
            children: [
              Icon(Icons.diamond, size: 22.r, color: SkinColors.badgeGold),
              SizedBox(width: 8.w),
              Text(
                planName,
                style: GoogleFonts.sora(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  height: 1.15,
                ),
              ),
              const Spacer(),
              Text(
                source,
                style: GoogleFonts.urbanist(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withValues(alpha: 0.95),
                  height: 1.2,
                ),
              ),
            ],
          ),
          if (showCreditUsage) ...[
            SizedBox(height: 18.h),
            Row(
              children: [
                Icon(Icons.toll_rounded, size: 17.r, color: Colors.white),
                SizedBox(width: 8.w),
                Text(
                  'Credit Usage',
                  style: GoogleFonts.urbanist(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
                const Spacer(),
                Text(
                  '$creditsRemaining remaining',
                  style: GoogleFonts.urbanist(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withValues(alpha: 0.65),
                    height: 1.2,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            // White used-credits fill on a white-25% track (h6 r3).
            ClipRRect(
              borderRadius: BorderRadius.circular(3.r),
              child: SizedBox(
                height: 6.h,
                width: double.infinity,
                child: ColoredBox(
                  color: Colors.white.withValues(alpha: 0.25),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: FractionallySizedBox(
                      widthFactor: _usedFraction.clamp(0.0, 1.0),
                      heightFactor: 1,
                      child: const ColoredBox(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ],
          SizedBox(height: 16.h),
          // "Manage …" pill — h44 r22, white-18% fill, 15sp bold label.
          SpringPress(
            enabled: onButtonTap != null,
            child: GestureDetector(
              onTap: onButtonTap,
              behavior: HitTestBehavior.opaque,
              child: Container(
                height: 44.h,
                width: double.infinity,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(22.r),
                ),
                child: Text(
                  buttonLabel,
                  style: GoogleFonts.urbanist(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    height: 1.2,
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

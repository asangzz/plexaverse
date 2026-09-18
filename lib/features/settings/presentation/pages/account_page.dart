import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../../core/responsive/screen_util.dart';
import '../../../../core/theme/skin_colors.dart';
import '../../../../core/ui/motion/spring_press.dart';
import '../../../../core/ui/skin/page_background.dart';
import '../../../auth/application/sign_out_controller.dart';
import '../../application/subscription_controller.dart';
import '../widgets/subscription_plan_card.dart';
import '../widgets/subscription_sheet.dart';

/// Account page — HeyGen-style re-skin, screenshot 2374. Route '/account',
/// pushed from the Home gear (root-level slide-in, hence the back circle
/// with `context.pop()`).
///
/// Layout per spec: deep-navy canvas with a soft blue ambient glow behind
/// the top, back chevron in a white-13% glass circle + centered "Account"
/// 18sp semibold, cyan 13sp section labels, the blue-gradient subscription
/// card (gem + "Creator" + Credit Usage + white progress + "Manage plan
/// details" → Subscription sheet), then white-11% glass r14 h56 rows
/// (translucent over the diagonal gradient, so lower rows read darker —
/// top row samples #1F2038, bottom #1B1B1F in 2374) grouped as Email /
/// App Feedback / Help / Actions, with "Log out" in #DE1111 wired to the
/// single sign-out path, and a live package_info_plus version footer.
class AccountPage extends ConsumerWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Fixture-shaped fallbacks keep the card pixel-stable while the mock
    // repository's simulated latency resolves.
    final sub = ref.watch(subscriptionControllerProvider).value;

    return Scaffold(
      backgroundColor: SkinColors.deepNavy,
      body: Stack(
        children: [
          // Diagonal navy→black background fitted to 2374 (shared with the
          // Videos and Avatars tabs — see SkinPageBackground). The screen
          // reads lighter at the top because of this gradient, not a glow.
          const Positioned.fill(child: SkinPageBackground()),
          SafeArea(
            child: Column(
              children: [
                const _AccountHeader(),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 12.h),
                    children: [
                      const _SectionLabel('Subscription', topGap: 8),
                      SubscriptionPlanCard(
                        planName: sub?.planName ?? 'Creator',
                        source: sub?.source ?? 'From Plexaverse web app',
                        buttonLabel: 'Manage plan details',
                        showCreditUsage: true,
                        creditsRemaining: sub?.creditsRemaining ?? 453,
                        creditsTotal: sub?.creditsTotal ?? 600,
                        onButtonTap: () => showSubscriptionSheet(context),
                      ),
                      const _SectionLabel('Email'),
                      const _AccountRow(
                        // TODO(auth): surface the signed-in user's email once
                        // an auth-session user provider exists — SessionStore
                        // only persists tokens and AuthUser is not retained
                        // after sign-in, so this stays the 2374 placeholder.
                        label: 'plexaverse@gmail.com',
                        showChevron: false,
                      ),
                      const _SectionLabel('App Feedback'),
                      _AccountRow(
                        label: 'Tell us what you think \u{1F64F}',
                        onTap: () {},
                      ),
                      const _SectionLabel('Help'),
                      _AccountRow(label: 'FAQ', onTap: () {}),
                      SizedBox(height: 6.h),
                      _AccountRow(label: 'Pricing Info', onTap: () {}),
                      const _SectionLabel('Actions'),
                      _AccountRow(label: 'Reset Password', onTap: () {}),
                      SizedBox(height: 6.h),
                      _AccountRow(label: 'Privacy & Security', onTap: () {}),
                      SizedBox(height: 6.h),
                      _AccountRow(label: 'Delete my account', onTap: () {}),
                      SizedBox(height: 6.h),
                      _AccountRow(
                        label: 'Log out',
                        labelColor: SkinColors.logoutRed,
                        onTap: () => _confirmLogout(context, ref),
                      ),
                      SizedBox(height: 24.h),
                      const _VersionFooter(),
                      SizedBox(height: 8.h),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmLogout(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: const Text('Log out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogCtx, true),
            child: const Text('Log out'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      // The SINGLE sign-out path — clears the session and flips the auth
      // gate; the router redirect navigates to /login, so no context.go here.
      await ref.read(signOutControllerProvider.notifier).signOut();
    }
  }
}

/// Back circle (40, white 13% glass) + centered "Account" title (2374
/// header).
class _AccountHeader extends StatelessWidget {
  const _AccountHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 8.h),
      child: SizedBox(
        height: 44.h,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: SpringPress(
                child: GestureDetector(
                  onTap: () => context.pop(),
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    width: 40.r,
                    height: 40.r,
                    decoration: const BoxDecoration(
                      color: SkinColors.glassCircleWhite,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 18.r,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            Text(
              'Account',
              style: GoogleFonts.sora(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 13sp semibold brand-cyan group label ("Subscription", "Email", …).
class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text, {this.topGap = 24});

  final String text;

  /// Design-dp gap above the label (24 per spec; 8 for the first group).
  final double topGap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: topGap.h, bottom: 8.h, left: 2.w),
      child: Text(
        text,
        style: GoogleFonts.urbanist(
          fontSize: 13.sp,
          fontWeight: FontWeight.w600,
          color: SkinColors.brandCyan,
          height: 1.2,
        ),
      ),
    );
  }
}

/// One white-11% glass r14 h56 list row (translucent over the page
/// gradient) — white 15sp label + #6E7288 chevron (chevron hidden on the
/// Email value row; label red on "Log out").
class _AccountRow extends StatelessWidget {
  const _AccountRow({
    required this.label,
    this.labelColor = Colors.white,
    this.showChevron = true,
    this.onTap,
  });

  final String label;
  final Color labelColor;
  final bool showChevron;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final row = Container(
      height: 56.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: SkinColors.glassRowWhite,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.urbanist(
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
                color: labelColor,
                height: 1.2,
              ),
            ),
          ),
          if (showChevron)
            Icon(
              Icons.chevron_right_rounded,
              size: 22.r,
              color: SkinColors.chipBorder,
            ),
        ],
      ),
    );

    if (onTap == null) return row;
    return SpringPress(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: row,
      ),
    );
  }
}

/// "Version: 1.0.8 (115)" — live values via package_info_plus (async).
class _VersionFooter extends StatelessWidget {
  const _VersionFooter();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PackageInfo>(
      future: PackageInfo.fromPlatform(),
      builder: (context, snap) {
        final info = snap.data;
        return Text(
          info == null ? '' : 'Version: ${info.version} (${info.buildNumber})',
          textAlign: TextAlign.center,
          style: GoogleFonts.urbanist(
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
            color: SkinColors.dateGrey,
            height: 1.2,
          ),
        );
      },
    );
  }
}

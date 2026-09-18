import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/ui/zave/zave_kit.dart';
import '../../application/pricing_controller.dart';
import '../../domain/pricing.dart';
import '../widgets/plan_card.dart';
import '../widgets/referral_card.dart';
import '../widgets/xp_budget_card.dart';

/// **Pricing** — the web's `/pricing`.
///
/// Geo-priced: `GET /geo/pricing` answers with the user's currency and the two
/// plan prices, and the plan catalogue itself is static content copied verbatim
/// from the web's `PLANS` array.
///
/// ## The one thing this screen cannot do
///
/// It cannot take money. Both Razorpay routes exist server-side, but the value
/// they return is an order / subscription id that only the Razorpay **checkout
/// SDK** can open, and the app does not ship `razorpay_flutter`. Creating an
/// order from here would leave a paid-for-nothing order row behind and show the
/// user a button that visibly does nothing.
///
/// So the CTA is rendered, disabled, with the reason written underneath. That
/// is the same call the Settings slice made for Slack and Google Calendar, and
/// the precedent this codebase has already set: an honest disabled control
/// beats a dead one.
///
/// ## Two smaller departures from the web, both forced
///
///   • The web badges the free tier "Claimed" / "No card needed" from
///     `welcomeXpClaimed`. The mobile `/user/xp` route does not return that
///     field (it re-shapes the payload to `{balance, transactions, config}`),
///     so the card states the grant neutrally instead of guessing which half of
///     the branch this user is in.
///   • The web decides `/month` vs `/purchase` from `GET /api/payment/config`.
///     There is no mobile mirror of that route, so the price carries no billing
///     period at all rather than an invented one.
class PricingPage extends ConsumerWidget {
  const PricingPage({super.key});

  /// Shown under every disabled CTA. One sentence, and it says where to go.
  static const String checkoutNote =
      'Checkout opens on plexaverse.com — the payment sheet is not available '
      'in the app yet. Your plan and XP carry over the moment you pay.';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<PlanPricing> pricing = ref.watch(planPricingProvider);
    final AsyncValue<String?> brandType = ref.watch(pricingBrandTypeProvider);
    final AsyncValue<ReferralSummary> referral = ref.watch(
      referralControllerProvider,
    );

    return ZaveScaffold(
      title: 'Pricing',
      leading: ZaveIconButton(
        icon: const Icon(Icons.arrow_back),
        tooltip: 'Back',
        onPressed: () => context.pop(),
      ),
      body: RefreshIndicator(
        color: ZaveColors.white,
        backgroundColor: ZaveColors.deep,
        onRefresh: () async {
          ref
            ..invalidate(planPricingProvider)
            ..invalidate(pricingBrandTypeProvider)
            ..invalidate(referralControllerProvider);
          await ref.read(planPricingProvider.future);
        },
        child: ZaveScrollView(
          children: <Widget>[
            Text('Power up your LinkedIn growth', style: ZaveType.h2),
            SizedBox(height: ZaveSpace.md),
            Text(
              'XP never expires — it simply runs out when used. Top up only '
              'when you need more.',
              style: ZaveType.lead,
            ),

            SizedBox(height: ZaveSpace.lg),
            pricing.when(
              loading: () => const _PillSkeleton(),
              error: (Object e, StackTrace _) => const SizedBox.shrink(),
              data: (PlanPricing p) => Align(
                alignment: Alignment.centerLeft,
                child: ZavePill(
                  label: '${p.flag}  Prices in ${p.currency} · ${p.taxNote}',
                  color: ZaveColors.ink62,
                ),
              ),
            ),

            SizedBox(height: ZaveSpace.xl),
            const _FreeTierCard(),

            SizedBox(height: ZaveSpace.xl),
            pricing.when(
              loading: () => const _PlansSkeleton(),
              error: (Object e, StackTrace _) => _PricingError(
                onRetry: () => ref.invalidate(planPricingProvider),
              ),
              data: (PlanPricing p) => Column(
                children: <Widget>[
                  for (final PricingPlan plan in PricingPlan.forBrand(
                    brandType.value,
                  )) ...<Widget>[
                    PlanCard(
                      plan: plan,
                      pricing: p,
                      // Deliberately null — see the class doc.
                      onCheckout: null,
                      checkoutNote: checkoutNote,
                    ),
                    SizedBox(height: ZaveSpace.lg),
                  ],
                ],
              ),
            ),

            SizedBox(height: ZaveSpace.md),
            const XpBudgetCard(),

            SizedBox(height: ZaveSpace.xl),
            referral.when(
              loading: () => const _CardSkeleton(height: 200),
              error: (Object e, StackTrace _) => _ReferralError(
                onRetry: () => ref.invalidate(referralControllerProvider),
              ),
              data: (ReferralSummary summary) => ReferralCard(
                summary: summary,
                onGenerate: () =>
                    ref.read(referralControllerProvider.notifier).generate(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The free welcome grant.
///
/// Stated, not offered: the 2,500 XP lands on the FIRST LinkedIn connect
/// (`awardWelcomeXpIfFirstConnection` on the web), and without
/// `welcomeXpClaimed` this screen cannot tell whether that already happened.
/// So there is no "Get Started" / "Claimed" branch and no CTA — a sentence
/// that is true either way beats a button that might be a lie.
class _FreeTierCard extends StatelessWidget {
  const _FreeTierCard();

  @override
  Widget build(BuildContext context) {
    return ZaveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('FREE', style: ZaveType.kicker),
          SizedBox(height: ZaveSpace.md),
          Text(
            '${groupedNumber(kWelcomeXp)} XP free',
            style: ZaveType.h2.copyWith(color: ZaveColors.amber),
          ),
          SizedBox(height: ZaveSpace.md),
          Text(
            'Credited the first time you connect a LinkedIn account — about a '
            'week of automation. No card needed.',
            style: ZaveType.bodyMuted,
          ),
        ],
      ),
    );
  }
}

class _PricingError extends StatelessWidget {
  const _PricingError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return ZaveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              // Amber, not red: Zave has no red, and a failed fetch is "needs
              // attention", not a destructive state.
              const ZaveDot(ZaveColors.amber),
              SizedBox(width: ZaveSpace.sm),
              Text('COULD NOT LOAD', style: ZaveType.kicker),
            ],
          ),
          SizedBox(height: ZaveSpace.md),
          Text("Prices didn't load.", style: ZaveType.h3),
          SizedBox(height: ZaveSpace.sm),
          Text(
            'The plans are unchanged — only the localised prices are missing.',
            style: ZaveType.bodyMuted,
          ),
          SizedBox(height: ZaveSpace.lg),
          ZaveButton(label: 'Try again', onPressed: onRetry),
        ],
      ),
    );
  }
}

class _ReferralError extends StatelessWidget {
  const _ReferralError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return ZaveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              const ZaveDot(ZaveColors.amber),
              SizedBox(width: ZaveSpace.sm),
              Text('REFER & EARN', style: ZaveType.kicker),
            ],
          ),
          SizedBox(height: ZaveSpace.md),
          Text("Your referral code didn't load.", style: ZaveType.h3),
          SizedBox(height: ZaveSpace.lg),
          ZaveButton(label: 'Try again', onPressed: onRetry),
        ],
      ),
    );
  }
}

class _PlansSkeleton extends StatelessWidget {
  const _PlansSkeleton();

  @override
  Widget build(BuildContext context) => Column(
    children: <Widget>[
      const _CardSkeleton(height: 420),
      SizedBox(height: ZaveSpace.lg),
      const _CardSkeleton(height: 420),
    ],
  );
}

class _PillSkeleton extends StatelessWidget {
  const _PillSkeleton();

  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.centerLeft,
    child: Container(height: 40, width: 200, decoration: ZaveSurface.pill),
  );
}

class _CardSkeleton extends StatelessWidget {
  const _CardSkeleton({required this.height});

  final double height;

  @override
  Widget build(BuildContext context) =>
      Container(height: height, decoration: ZaveSurface.card);
}

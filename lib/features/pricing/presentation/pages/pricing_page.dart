import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/platform/checkout.dart';
import '../../../../core/ui/app_icons.dart';
import '../../../../core/ui/zave/zave_kit.dart';
import '../../application/pricing_controller.dart';
import '../../domain/pricing_repository.dart';
import '../widgets/plan_card.dart';
import '../widgets/referral_card.dart';
import '../widgets/allowances_card.dart';

/// **Pricing** — the web's `/pricing`.
///
/// Geo-priced: `GET /geo/pricing` answers with the user's currency and the two
/// plan prices, and the plan catalogue itself is static content copied verbatim
/// from the web's `PLANS` array.
///
/// A plan is described by what it includes — one allowance per AI feature, from
/// `GET /user/allowances` — not by XP. Wallet XP was retired on 10 Nov 2026;
/// "XP" in this app now means only the contest score, and this screen never
/// says it.
///
/// ## How a plan is bought
///
/// Each card is decided by its [PlanOffer] — the web's `decidePlanOffer`,
/// from `GET /geo/pricing` and `GET /payment/config`: UPI AutoPay where the
/// server quoted it (India, the personal plan), the 30-day pass everywhere
/// else (TOKEN_AUTOPAY_SPEC.md §4.1, §4.3). The checkout is
/// `razorpay_flutter`'s native sheet, run by [PlanCheckout] — the same code the
/// onboarding plan step runs. While the token rail is dark the server sends
/// no offer, and every card sells the pass.
///
/// A config that cannot be read, or an offer the server could not work out,
/// is a retry on the cards — never a fallback to the pass, because the server
/// may owe this person a free month. While UPI AutoPay is live the personal
/// card sells nothing and says where the mandate is managed.
class PricingPage extends ConsumerWidget {
  const PricingPage({super.key});

  /// Runs the checkout the card's [offer] describes and says what happened.
  ///
  /// Silence on a closed sheet — backing out of a payment is a decision, and
  /// the same rule the browser hand-off and the image picker follow.
  static Future<void> _buy(
    BuildContext context,
    WidgetRef ref,
    PlanOffer offer,
  ) async {
    final String? note = await ref
        .read(checkoutControllerProvider.notifier)
        .buy(offer);
    if (note == null || !context.mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(note, style: ZaveType.body)));
  }

  /// One plan's card, decided by its offer. Never decided on half an answer:
  /// the button waits for both the prices and the offer, and an offer that
  /// cannot be worked out is a retry.
  static Widget _card(
    BuildContext context,
    WidgetRef ref, {
    required PricingPlan plan,
    required PlanPricing pricing,
    required AsyncValue<PaymentConfig> config,
    required bool autopayLive,
    required bool? onDevice,
    required String? buying,
  }) {
    final PaymentConfig? answer = config.value;
    // Not decided until the device has said whether it can register UPI
    // AutoPay: a guess either way sells the wrong thing.
    final PlanOffer? offer = answer == null || onDevice == null
        ? null
        : PlanOffer.decide(
            pricing: pricing,
            config: answer,
            planType: plan.id,
            upiAutopayOnDevice: onDevice,
          );
    final bool failed =
        (config.hasError && !config.isLoading) ||
        (answer != null && onDevice != null && offer == null);
    return PlanCard(
      plan: plan,
      pricing: pricing,
      offer: offer,
      offerFailed: failed,
      onRetry: () => ref.invalidate(pricingPaymentConfigProvider),
      autopayLive: autopayLive && plan.id == PricingPlan.personal.id,
      busy: buying == plan.id,
      onCheckout: offer == null || buying != null
          ? null
          : () => _buy(context, ref, offer),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<PlanPricing> pricing = ref.watch(planPricingProvider);
    final AsyncValue<String?> brandType = ref.watch(pricingBrandTypeProvider);
    final AsyncValue<ReferralSummary> referral = ref.watch(
      referralControllerProvider,
    );
    // Never errors (it falls back to the static table), so only loading needs
    // a placeholder.
    final AsyncValue<AllowanceTable> allowances = ref.watch(
      planAllowancesProvider,
    );
    final AsyncValue<PaymentConfig> config = ref.watch(
      pricingPaymentConfigProvider,
    );
    // A failed status read is not "no mandate"; it only means the card
    // cannot say "UPI AutoPay is on". The server still refuses a second plan.
    final bool autopayLive =
        ref.watch(autopayStatusProvider).value?.live ?? false;
    // Never errors (a probe that cannot answer is the platform's answer);
    // null only while the device is being asked.
    final bool? onDevice = ref.watch(upiAutopayOnDeviceProvider).value;
    final String? buying = ref.watch(checkoutControllerProvider);

    return ZaveScaffold(
      largeTitle: 'Pricing',
      leading: ZaveIconButton(
        icon: const Icon(AppIcons.back),
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
            ..invalidate(planAllowancesProvider)
            ..invalidate(pricingPaymentConfigProvider)
            ..invalidate(autopayStatusProvider)
            ..invalidate(upiAutopayOnDeviceProvider)
            ..invalidate(referralControllerProvider);
          await ref.read(planPricingProvider.future);
        },
        child: ZaveScrollView(
          children: <Widget>[
            Text('Power up your LinkedIn growth', style: ZaveType.h2),
            SizedBox(height: ZaveSpace.md),
            Text(
              'One plan pays for every AI feature. Each feature has an '
              'allowance that resets daily or monthly.',
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
                    _card(
                      context,
                      ref,
                      plan: plan,
                      pricing: p,
                      config: config,
                      autopayLive: autopayLive,
                      onDevice: onDevice,
                      buying: buying,
                    ),
                    SizedBox(height: ZaveSpace.lg),
                  ],
                ],
              ),
            ),

            SizedBox(height: ZaveSpace.md),
            switch (allowances) {
              AsyncData<AllowanceTable>(:final AllowanceTable value) =>
                AllowancesCard(table: value),
              _ => const ZaveShimmer(child: ZaveSkeleton.block(height: 320)),
            },

            SizedBox(height: ZaveSpace.xl),
            referral.when(
              loading: () =>
                  const ZaveShimmer(child: ZaveSkeleton.block(height: 200)),
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

/// What is free without a plan.
///
/// There used to be a 2,500 XP welcome grant here. Wallet XP was retired and
/// the grant with it, so this states what never needed a plan, with no CTA —
/// anyone on this screen is signed in and already has it.
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
          Text('Roadmap, lessons and calendar', style: ZaveType.h2),
          SizedBox(height: ZaveSpace.md),
          Text(
            'Free without a card. AI writing, posters and the rest need a '
            'plan.',
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
              Text('REFER A FRIEND', style: ZaveType.kicker),
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
  Widget build(BuildContext context) => const ZaveShimmer(
    child: Column(
      children: <Widget>[
        // A plan card, in outline: the name, the price, and the four lines
        // of what you get. It was a featureless 420pt slab, which at this
        // height reads as a failed render rather than as a card coming.
        _PlanCardSkeleton(),
        SizedBox(height: 16),
        _PlanCardSkeleton(),
      ],
    ),
  );
}

class _PlanCardSkeleton extends StatelessWidget {
  const _PlanCardSkeleton();

  @override
  Widget build(BuildContext context) => ZaveCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const ZaveSkeleton.bar(width: 90),
        SizedBox(height: ZaveSpace.lg),
        const ZaveSkeleton.bar(widthFactor: 0.5, height: 34),
        SizedBox(height: ZaveSpace.xl),
        for (int i = 0; i < 5; i++) ...<Widget>[
          if (i > 0) SizedBox(height: ZaveSpace.md),
          ZaveSkeleton.bar(widthFactor: 0.9 - i * 0.08),
        ],
        SizedBox(height: ZaveSpace.xl),
        const ZaveSkeleton.bar(height: 44),
      ],
    ),
  );
}

class _PillSkeleton extends StatelessWidget {
  const _PillSkeleton();

  @override
  Widget build(BuildContext context) => const ZaveShimmer(
    child: Align(
      alignment: Alignment.centerLeft,
      child: ZaveSkeleton.bar(width: 200, height: 40),
    ),
  );
}

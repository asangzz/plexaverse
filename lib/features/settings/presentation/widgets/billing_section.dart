import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/router/zave_routes.dart';
import '../../../../core/ui/app_icons.dart';
// Re-exports `UserPreferences` alongside the Settings entities, so this file
// needs one import for both rather than two that overlap.
import '../../../../core/ui/zave/zave_kit.dart';
import '../../application/settings_controllers.dart';
import 'package:go_router/go_router.dart';
import '../../domain/settings_repository.dart';
import 'settings_section.dart';

/// **Plan & XP** — the Settings-side view of the web's `/pricing` page.
///
/// The web shows one card per plan and filters the list by `brandType`, so most
/// real users see exactly one; this shows that one directly. The price comes
/// from `GET /geo/pricing` and is never recomputed here — India is billed
/// inclusive of 18% GST while everywhere else is the INR base converted and
/// doubled, and re-deriving that on the client is how the two figures drift.
///
/// **Checkout is not ported.** The web runs Razorpay's `checkout.js`; the
/// mobile equivalent is the `razorpay_flutter` plugin, which is not in this
/// app's pubspec. `POST /subscription/create` and `POST /payment/create-order`
/// both exist and would work the moment the plugin lands — what is missing is
/// the sheet that takes the card, and there is no honest way to fake that.
class BillingSection extends ConsumerWidget {
  const BillingSection({required this.preferences, super.key});

  final UserPreferences preferences;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<AccountSnapshot> account = ref.watch(
      accountSnapshotProvider,
    );
    final AsyncValue<GeoPricing> pricing = ref.watch(geoPricingProvider);
    final AsyncValue<XpSummary> xp = ref.watch(xpSummaryProvider);

    if (account.hasError) {
      return SettingsSection(
        title: 'Plan & XP',
        child: SectionError(
          message: "We couldn't load your plan.",
          onRetry: () => ref.invalidate(accountSnapshotProvider),
        ),
      );
    }

    final AccountSnapshot? snapshot = account.value;
    if (snapshot == null) {
      return const SettingsSection(
        title: 'Plan & XP',
        child: SectionSkeleton(lines: 3),
      );
    }

    final SubscriptionState subscription = snapshot.subscription;
    final bool isCompany = preferences.isCompany;
    final GeoPricing? prices = pricing.value;

    return SettingsSection(
      title: 'Plan & XP',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      isCompany ? 'COMPANY' : 'PERSONAL',
                      style: ZaveType.kicker,
                    ),
                    SizedBox(height: ZaveSpace.xs),
                    // A dim bar, not an em-dash at heading size.
                    //
                    // Geo-pricing is a second request, so this is the state
                    // the panel opens in — and `—` set in h3 reads as a
                    // price of nothing rather than as a price on its way.
                    if (prices == null)
                      Container(
                        height: ZaveSpace.lg,
                        width: 110,
                        decoration: BoxDecoration(
                          color: ZaveGlass.hover,
                          borderRadius: ZaveRadius.pillBr,
                        ),
                      )
                    else
                      Text(
                        '${prices.symbol}'
                        '${prices.priceFor(isCompany: isCompany)}'
                        ' / month',
                        style: ZaveType.h3,
                      ),
                    if (prices != null) ...<Widget>[
                      SizedBox(height: ZaveSpace.xs),
                      Text(
                        '${prices.currency} · ${prices.taxNote}',
                        style: ZaveType.caption,
                      ),
                    ],
                  ],
                ),
              ),
              SizedBox(width: ZaveSpace.md),
              _StatusPill(subscription: subscription),
            ],
          ),

          if (pricing.hasError) ...<Widget>[
            SizedBox(height: ZaveSpace.md),
            const UnavailableNote(
              message:
                  'We could not read the price for your region just now. It '
                  'has not changed — this is a read that failed.',
            ),
          ],

          if (subscription.isActive &&
              subscription.currentPeriodEnd != null) ...<Widget>[
            SizedBox(height: ZaveSpace.md),
            Text(
              subscription.isRecurring
                  ? 'Renews on '
                        '${DateFormat.yMMMd().format(subscription.currentPeriodEnd!)}'
                        ' · cancel anytime'
                  : 'Active until '
                        '${DateFormat.yMMMd().format(subscription.currentPeriodEnd!)}',
              style: ZaveType.caption,
            ),
          ],

          const SettingsDivider(),

          Row(
            children: <Widget>[
              // Amber is the XP colour in Zave — "points, waiting".
              const ZaveDot(ZaveColors.amber),
              SizedBox(width: ZaveSpace.md),
              Expanded(
                child: Text(
                  'XP balance',
                  style: ZaveType.label.copyWith(color: ZaveColors.white),
                ),
              ),
              Text(switch (xp) {
                AsyncData<XpSummary>(:final XpSummary value) =>
                  NumberFormat.decimalPattern().format(value.balance),
                AsyncError<XpSummary>() => '—',
                _ => '…',
              }, style: ZaveType.h3.copyWith(color: ZaveColors.amber)),
            ],
          ),
          SizedBox(height: ZaveSpace.sm),
          Text(
            'XP never expires — it simply runs out when used. Top up only '
            'when you need more.',
            style: ZaveType.caption,
          ),

          SizedBox(height: ZaveSpace.lg),
          // Pricing owns the plan cards and the checkout sheet; this block
          // is the balance. Sending the user there beats a second copy of
          // the same purchase flow in Settings.
          Align(
            alignment: Alignment.centerLeft,
            child: ZaveButton(
              label: 'Plans and top-ups',
              icon: const Icon(AppIcons.bolt),
              onPressed: () => context.push(ZaveRoutes.pricing),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.subscription});

  final SubscriptionState subscription;

  @override
  Widget build(BuildContext context) {
    if (subscription.isActive) {
      return const ZavePill(
        label: 'Active',
        color: ZaveColors.mint,
        leading: ZaveDot(ZaveColors.green),
      );
    }
    // Not "failed" — a user who has never paid is waiting, not broken. Amber
    // carries both meanings in Zave, which has no red.
    return const ZavePill(
      label: 'No plan',
      color: ZaveColors.amber,
      leading: ZaveDot(ZaveColors.amber),
    );
  }
}

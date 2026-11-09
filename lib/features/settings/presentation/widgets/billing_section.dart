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

/// **Plan** — the Settings-side view of the web's `/pricing` page.
///
/// Plan status only. There is no XP balance here any more: wallet XP was
/// retired on 10 Nov 2026 and the plan itself pays for every AI feature, up
/// to a per-feature allowance. What the plan includes lives on Pricing, which
/// reads it from the server; repeating it here would be a second copy to keep
/// in step.
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

    if (account.hasError) {
      return SettingsSection(
        title: 'Plan',
        child: SectionError(
          message: "We couldn't load your plan.",
          onRetry: () => ref.invalidate(accountSnapshotProvider),
        ),
      );
    }

    final AccountSnapshot? snapshot = account.value;
    if (snapshot == null) {
      return const SettingsSection(
        title: 'Plan',
        child: SectionSkeleton(lines: 3),
      );
    }

    final SubscriptionState subscription = snapshot.subscription;
    final bool isCompany = preferences.isCompany;
    final GeoPricing? prices = pricing.value;

    return SettingsSection(
      title: 'Plan',
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
                      ZaveShimmer(
                        child: ZaveSkeleton.bar(
                          height: ZaveSpace.lg,
                          width: 110,
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
              (subscription.isRecurring
                      ? subscription.currentPeriodEnd
                      : subscription.endsAt) !=
                  null) ...<Widget>[
            SizedBox(height: ZaveSpace.md),
            Text(
              subscription.isRecurring
                  ? 'Renews on '
                        '${DateFormat.yMMMd().format(subscription.currentPeriodEnd!)}'
                        ' · cancel anytime'
                  : 'Active until '
                        '${DateFormat.yMMMd().format(subscription.endsAt!)}',
              style: ZaveType.caption,
            ),
          ],

          if (!subscription.isActive) ...<Widget>[
            SizedBox(height: ZaveSpace.md),
            Text(
              // Hedged while the server sends no entitlement verdict: a
              // 30-day pass and given plan time never set `status`, so this
              // branch also holds people whose AI features work. Telling them
              // they "need a plan" would be false.
              subscription.isUnknown
                  ? 'Your roadmap, lessons and calendar are free. AI writing, '
                        'posters and the rest come with a plan. A 30-day pass '
                        'or plan time given to you may not show here yet.'
                  : 'Your roadmap, lessons and calendar are free. AI writing, '
                        'posters and the rest come with a plan.',
              style: ZaveType.caption,
            ),
          ],

          SizedBox(height: ZaveSpace.lg),
          // Pricing owns the plan cards, what each plan includes, and the
          // checkout sheet. Sending the user there beats a second copy of the
          // same purchase flow in Settings.
          Align(
            alignment: Alignment.centerLeft,
            child: ZaveButton(
              label: subscription.isActive
                  ? 'What your plan includes'
                  : 'See plans',
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
      // Saying which kind of active this is tells the user whether they will
      // be charged again: a 30-day pass and given plan time do not renew.
      final String label;
      if (subscription.isRecurring) {
        label = 'Active';
      } else if (subscription.isGranted) {
        label = 'Plan time given';
      } else {
        label = '30-day pass';
      }
      return ZavePill(
        label: label,
        color: ZaveColors.mint,
        leading: const ZaveDot(ZaveColors.green),
      );
    }
    // Not "failed" — a user who has never paid is waiting, not broken. Amber
    // carries both meanings in Zave, which has no red.
    //
    // "No plan" only when it is safe to say: the server said so, or the
    // status is the never-paid / ended default. A cancelled subscriber may
    // still hold a pass we cannot see, so that reads as what we do know.
    final String label;
    if (subscription.entitled == false ||
        subscription.status == null ||
        subscription.status == 'inactive') {
      label = 'No plan';
    } else {
      label = 'Not renewing';
    }
    return ZavePill(
      label: label,
      color: ZaveColors.amber,
      leading: const ZaveDot(ZaveColors.amber),
    );
  }
}

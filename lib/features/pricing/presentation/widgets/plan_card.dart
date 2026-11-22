import 'package:flutter/material.dart';

import '../../../../core/ui/app_icons.dart';
import '../../../../core/ui/zave/zave_kit.dart';
import '../../domain/plan_offer.dart';
import '../../domain/pricing.dart';

/// One plan, priced for this user's country.
///
/// ## What the web does that this deliberately does not
///
/// The web gives each plan a house colour — indigo for Personal, green for
/// Company — and paints the card background, border, glow, tick marks and CTA
/// gradient with it. Zave's first rule is that **colour only ever names a
/// status**, and "which plan you are looking at" is not a status. So both cards
/// are ordinary glass at the same fill step, and the only colour on them is
/// blue on the CTA — [ZaveColors.blue] is the upgrade path.
///
/// The card no longer carries an XP figure. A plan used to credit 11,000 wallet
/// XP; since 10 Nov 2026 it pays for every AI feature directly, up to the
/// allowances listed once under the cards.
///
/// Depth is the fill step, never a shadow, so the web's `0 20px 60px` glow and
/// its top hairline gradient are dropped rather than approximated.
///
/// ## How it is paid
///
/// The card is decided by its [offer] — the web's `decidePlanOffer`: UPI
/// AutoPay where the server quoted it (India, personal), the 30-day pass
/// everywhere else, in the words of `autopay_copy.dart` (§4.4). Until the
/// offer is in, the button waits; when it cannot be worked out, the button is
/// a retry — never a guess at the pass, because the server may owe this
/// person a free month. While a mandate is live ([autopayLive]) there is
/// nothing to buy, and the card says where the mandate is managed.
class PlanCard extends StatelessWidget {
  const PlanCard({
    required this.plan,
    required this.pricing,
    required this.offer,
    required this.onCheckout,
    this.offerFailed = false,
    this.onRetry,
    this.autopayLive = false,
    this.busy = false,
    super.key,
  });

  final PricingPlan plan;
  final PlanPricing pricing;

  /// Null while the offer is loading, or when it could not be worked out
  /// ([offerFailed]).
  final PlanOffer? offer;

  /// Starts the checkout the [offer] describes. Null disables the button.
  final VoidCallback? onCheckout;

  /// The offer could not be read or worked out: the button is a retry.
  final bool offerFailed;
  final VoidCallback? onRetry;

  /// UPI AutoPay is running on this account (the personal plan).
  final bool autopayLive;

  /// This card's checkout is open.
  final bool busy;

  @override
  Widget build(BuildContext context) {
    final PlanOffer? offer = this.offer;
    final PlanOffer? autopay = offer != null && offer.recurring ? offer : null;
    final ({String pill, String line, String cta, String ctaNote})? card =
        autopay == null ? null : autopayCardCopy(autopay);
    final String? kept = autopay == null || autopayLive
        ? null
        : keptFreeMonthLine(autopay);
    // The figure is the offer's once it is in; until then the localised
    // price, which is the same number for everyone but an autopay offer.
    final String symbol = offer?.symbol ?? pricing.symbol;
    final String figure = offer != null
        ? inr(offer.price)
        : groupedNumber(pricing.priceFor(plan.id));

    return ZaveCard(
      size: ZaveCardSize.large,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (plan.badge != null) ...<Widget>[
            ZavePill(
              label: plan.badge!,
              color: ZaveColors.peri,
              leading: const ZaveDot(ZaveColors.peri),
            ),
            SizedBox(height: ZaveSpace.lg),
          ],
          Text(plan.label, style: ZaveType.kicker),
          SizedBox(height: ZaveSpace.sm),
          Text(plan.tagline, style: ZaveType.bodyMuted),

          SizedBox(height: ZaveSpace.xl),

          // ── Price ──
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: <Widget>[
              Text(
                symbol,
                style: ZaveType.h3.copyWith(color: ZaveColors.ink50),
              ),
              SizedBox(width: ZaveSpace.xs),
              Flexible(
                child: Text(
                  figure,
                  style: ZaveType.hero,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: ZaveSpace.sm),
          Text(pricing.taxNote, style: ZaveType.caption),

          // How it is paid: UPI AutoPay as the server quoted it, or the
          // 30-day pass. Said only once the offer is in.
          if (offer != null) ...<Widget>[
            SizedBox(height: ZaveSpace.lg),
            // A Wrap, not a Row: "First 30 days free" beside "UPI Autopay ·
            // ₹1 today, refunded" does not fit a phone's card width, and the
            // line drops under the pill rather than overflowing.
            Wrap(
              spacing: ZaveSpace.md,
              runSpacing: ZaveSpace.sm,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: <Widget>[
                ZavePill(
                  label: card?.pill ?? '30-day pass',
                  color: ZaveColors.ink62,
                ),
                Text(
                  card?.line ?? 'Paid once, no renewal',
                  style: ZaveType.caption,
                  maxLines: 2,
                ),
              ],
            ),
          ],
          // The owner rule of 21 Nov 2026: a free month kept after a stop,
          // and how to continue.
          if (kept != null) ...<Widget>[
            SizedBox(height: ZaveSpace.md),
            Text(kept, style: ZaveType.label),
          ],
          if (offerFailed) ...<Widget>[
            SizedBox(height: ZaveSpace.lg),
            Text(
              'We could not load your price. Try again in a moment.',
              style: ZaveType.caption,
            ),
          ],

          // The competitor anchor is an INR comparison. Quoting rupees at
          // someone paying in dollars is noise, so the web gates it on India
          // and so does this.
          if (plan.comparator != null && pricing.isIndia) ...<Widget>[
            SizedBox(height: ZaveSpace.md),
            Text('vs. ${plan.comparator!}', style: ZaveType.caption),
          ],

          SizedBox(height: ZaveSpace.xl),
          Container(height: 1, color: ZaveColors.rule),
          SizedBox(height: ZaveSpace.xl),

          // ── Features ──
          for (final String feature in plan.features)
            if (feature == PricingPlan.inheritanceRow)
              Padding(
                padding: EdgeInsets.only(
                  top: ZaveSpace.sm,
                  bottom: ZaveSpace.md,
                ),
                child: Text(
                  '+ ${PricingPlan.inheritanceRow.toUpperCase()}',
                  style: ZaveType.kicker.copyWith(color: ZaveColors.peri),
                ),
              )
            else
              _FeatureRow(label: feature),

          for (final String locked in plan.lockedFeatures)
            _FeatureRow(label: locked, locked: true),

          SizedBox(height: ZaveSpace.xl),

          // ── CTA ──
          if (autopayLive)
            // UPI AutoPay is running: nothing to buy here, and the server
            // would refuse a second plan. Say where it is managed instead.
            _AutopayLiveNote()
          else if (offerFailed)
            ZaveButton(label: 'Try again', onPressed: onRetry, expand: true)
          else
            ZaveButton.brand(
              label: busy
                  ? 'Opening'
                  : offer == null
                  ? 'Loading…'
                  : card != null
                  ? card.cta
                  : 'Get the 30-day pass · ${offer.priceLabel}',
              busy: busy,
              onPressed: offer == null || busy ? null : onCheckout,
              expand: true,
            ),
          if (card != null && !autopayLive && !busy) ...<Widget>[
            SizedBox(height: ZaveSpace.md),
            Center(
              child: Text(
                card.ctaNote,
                style: ZaveType.caption,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// The card's foot while UPI AutoPay runs — the web's "UPI AutoPay is on".
class _AutopayLiveNote extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(ZaveSpace.lg),
      decoration: BoxDecoration(
        color: ZaveGlass.rest,
        border: Border.all(color: ZaveGlass.restBorder),
        borderRadius: ZaveRadius.cardBr,
      ),
      child: Column(
        children: <Widget>[
          Text('UPI AutoPay is on', style: ZaveType.label),
          SizedBox(height: ZaveSpace.xs),
          Text(
            'Your next payment and Stop autopay are in Settings → Billing.',
            style: ZaveType.caption,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// One feature line. Included features tick; locked ones are struck through at
/// the faintest legible ink step, exactly as on the web.
class _FeatureRow extends StatelessWidget {
  const _FeatureRow({required this.label, this.locked = false});

  final String label;
  final bool locked;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: ZaveSpace.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(
            locked ? AppIcons.close : AppIcons.check,
            // Green is "done / included"; a locked line is inert, so it takes
            // the faintest ink step rather than a warning colour.
            color: locked ? ZaveColors.ink35 : ZaveColors.green,
            size: 18,
          ),
          SizedBox(width: ZaveSpace.md),
          Expanded(
            child: Text(
              label,
              style: locked
                  ? ZaveType.label.copyWith(
                      color: ZaveColors.ink35,
                      decoration: TextDecoration.lineThrough,
                      decorationColor: ZaveColors.ink35,
                    )
                  : ZaveType.label,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../../core/ui/zave/zave_kit.dart';
import '../../domain/pricing.dart';

/// One plan, priced for this user's country.
///
/// ## What the web does that this deliberately does not
///
/// The web gives each plan a house colour — indigo for Personal, green for
/// Company — and paints the card background, border, glow, tick marks and CTA
/// gradient with it. Zave's first rule is that **colour only ever names a
/// status**, and "which plan you are looking at" is not a status. So both cards
/// are ordinary glass at the same fill step, and the only colour on them is:
///
///   • amber on the XP line — amber means points, everywhere in this app;
///   • blue on the CTA — [ZaveColors.blue] is the XP / upgrade path and buying
///     XP is the only thing it exists for.
///
/// Depth is the fill step, never a shadow, so the web's `0 20px 60px` glow and
/// its top hairline gradient are dropped rather than approximated.
class PlanCard extends StatelessWidget {
  const PlanCard({
    required this.plan,
    required this.pricing,
    required this.onCheckout,
    this.checkoutNote,
    super.key,
  });

  final PricingPlan plan;
  final PlanPricing pricing;

  /// Null disables the CTA. It is null in this build — see [checkoutNote] and
  /// the repository's note on why checkout cannot complete in the app.
  final VoidCallback? onCheckout;

  /// The honest sentence under a disabled CTA. Shown only when [onCheckout] is
  /// null.
  final String? checkoutNote;

  @override
  Widget build(BuildContext context) {
    final int price = pricing.priceFor(plan.id);

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
                pricing.symbol,
                style: ZaveType.h3.copyWith(color: ZaveColors.ink50),
              ),
              SizedBox(width: ZaveSpace.xs),
              Flexible(
                child: Text(
                  groupedNumber(price),
                  style: ZaveType.hero,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: ZaveSpace.sm),
          Text(pricing.taxNote, style: ZaveType.caption),

          SizedBox(height: ZaveSpace.lg),
          Row(
            children: <Widget>[
              ZavePill(
                label: '+${groupedNumber(plan.xp)} XP',
                color: ZaveColors.amber,
                leading: const ZaveDot(ZaveColors.amber),
              ),
              SizedBox(width: ZaveSpace.md),
              Flexible(
                child: Text(
                  '~34 days of automation',
                  style: ZaveType.caption,
                  maxLines: 2,
                ),
              ),
            ],
          ),

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
          ZaveButton.brand(
            label:
                'Get ${groupedNumber(plan.xp)} XP · ${pricing.symbol}'
                '${groupedNumber(price)}',
            onPressed: onCheckout,
            expand: true,
          ),
          if (onCheckout == null && checkoutNote != null) ...<Widget>[
            SizedBox(height: ZaveSpace.md),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Amber, not red: Zave has no red, and "you have to do this
                // elsewhere" is a waiting state, not a failure.
                Padding(
                  padding: EdgeInsets.only(top: ZaveSpace.xs + 2),
                  child: const ZaveDot(ZaveColors.amber),
                ),
                SizedBox(width: ZaveSpace.sm),
                Expanded(child: Text(checkoutNote!, style: ZaveType.caption)),
              ],
            ),
          ],
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
            locked ? Icons.close_rounded : Icons.check_rounded,
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

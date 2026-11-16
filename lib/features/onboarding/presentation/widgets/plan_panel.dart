import 'package:flutter/material.dart';

import '../../../../core/ui/app_icons.dart';
import '../../../../core/ui/zave/zave_kit.dart';
import '../../../pricing/domain/plan_offer.dart';

/// The plan step — the web's `components/onboarding/PlanStep.tsx`.
///
/// A panel, not a chip row: it carries a price, a list and a button, and a
/// commitment is not something to read at chip width.
///
/// **One control, and no skip.** That is the point of the step. A "maybe
/// later" would put a user into the product with no plan, where every feature
/// refuses them — worse than being asked plainly, once.
///
/// **The ₹5 is said out loud.** Razorpay's own workflow for a mandate with a
/// future first charge takes ₹5 to verify it and refunds it. A person told
/// there would be no charge who then sees one on their statement has been told
/// something untrue by their new subscription, on day one, about money — so
/// it gets a line of its own, on the autopay path only: the pass has no
/// mandate, and repeating it there would describe a refund that is not coming.
class PlanPanel extends StatelessWidget {
  const PlanPanel({
    required this.offer,
    required this.failed,
    required this.busy,
    required this.error,
    required this.onStart,
    required this.onRetry,
    super.key,
  });

  /// Null while the region and the autopay switch are still being read.
  final PlanOffer? offer;

  /// They could not be read. Only a retry is offered.
  final bool failed;

  /// The sheet is open, or its result is being verified.
  final bool busy;

  /// Why the last attempt did not finish.
  final String? error;

  final VoidCallback onStart;
  final VoidCallback onRetry;

  /// What the plan pays for — the web's `INCLUDED`, verbatim.
  static const List<String> included = <String>[
    'Posts written and published for you',
    'Your weekly plan, article and video scripts',
    'Business English practice with Plexa',
  ];

  /// The web's `#e5484d` — the one red this product uses for "this did not
  /// work", as the contest's wrong answers do.
  static const Color _alert = Color(0xFFE5484D);

  @override
  Widget build(BuildContext context) {
    final PlanOffer? offer = this.offer;
    final bool recurring = offer?.recurring ?? false;

    return Container(
      padding: EdgeInsets.all(ZaveSpace.xl),
      decoration: BoxDecoration(
        color: ZaveGlass.rest,
        border: Border.all(color: ZaveGlass.restBorder),
        borderRadius: ZaveRadius.cardBr,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (offer != null)
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: <Widget>[
                Text(recurring ? 'Free' : offer.priceLabel, style: ZaveType.h2),
                SizedBox(width: ZaveSpace.sm),
                Flexible(
                  child: Text(
                    recurring
                        ? 'for $kFreeFirstMonthDays days'
                        : 'for one month',
                    style: ZaveType.bodyMuted,
                  ),
                ),
              ],
            ),
          if (offer != null) SizedBox(height: ZaveSpace.sm),
          // Nothing to say about terms when the region could not be read —
          // the failure line below is the whole story there.
          if (!failed)
            Text(
              _terms(offer),
              style: ZaveType.label.copyWith(
                fontWeight: FontWeight.w400,
                color: ZaveColors.ink62,
                height: 1.6,
              ),
            ),
          if (recurring) ...<Widget>[
            SizedBox(height: ZaveSpace.sm),
            Text(
              'To verify the mandate your bank places a ₹5 charge now and '
              'Razorpay refunds it automatically. Your first real payment is '
              'on day $kFreeFirstMonthDays.',
              style: ZaveType.caption.copyWith(height: 1.6),
            ),
          ],
          SizedBox(height: ZaveSpace.lg),
          for (final String item in included)
            Padding(
              padding: EdgeInsets.only(bottom: ZaveSpace.sm),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: Icon(
                      AppIcons.check,
                      size: 16,
                      color: ZaveColors.mint,
                    ),
                  ),
                  SizedBox(width: ZaveSpace.sm),
                  Expanded(
                    child: Text(
                      item,
                      style: ZaveType.label.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          if (error != null) ...<Widget>[
            SizedBox(height: ZaveSpace.sm),
            Semantics(
              liveRegion: true,
              child: Text(
                error!,
                style: ZaveType.label.copyWith(color: _alert),
              ),
            ),
          ],
          if (failed) ...<Widget>[
            SizedBox(height: ZaveSpace.sm),
            Semantics(
              liveRegion: true,
              child: Text(
                'We could not work out your region. Try again — starting now '
                'could put you on the wrong plan.',
                style: ZaveType.label.copyWith(color: _alert),
              ),
            ),
          ],
          SizedBox(height: ZaveSpace.lg),
          // Blue: this is the billing path, the one thing ZaveColors.blue is
          // reserved for. Disabled until the offer is in — falling back to
          // India on a missing answer is the bug the web's step shipped with.
          if (failed)
            ZaveButton(
              kind: ZaveButtonKind.ghost,
              expand: true,
              label: 'Try again',
              onPressed: onRetry,
            )
          else
            ZaveButton(
              kind: ZaveButtonKind.brand,
              expand: true,
              busy: busy,
              label: busy
                  ? 'Opening'
                  : offer == null
                  ? 'Start my plan'
                  : recurring
                  ? 'Start my free month'
                  : 'Pay ${offer.priceLabel} for this month',
              onPressed: offer == null ? null : onStart,
            ),
          // Which kind of payment this is, once it is known — not before.
          if (offer != null) ...<Widget>[
            SizedBox(height: ZaveSpace.md),
            Text(
              // No "cancel from Settings": the product offers no
              // cancellation (owner's call, 17 Nov 2026). A mandate can still
              // be cancelled at the bank or UPI app, and the terms above say
              // what that costs.
              recurring
                  ? 'Secured by Razorpay.'
                  : 'Secured by Razorpay. One payment — nothing recurring.',
              textAlign: TextAlign.center,
              style: ZaveType.caption,
            ),
          ],
        ],
      ),
    );
  }

  /// The line under the price, per path.
  static String _terms(PlanOffer? offer) {
    if (offer == null) return 'Working out your price…';
    if (offer.recurring) {
      return 'Then ${offer.priceLabel} a month, taken automatically. '
          'Cancelling the autopay ends your free month straight away.';
    }
    return 'One month of everything below. We cannot set up autopay in your '
        'country yet, so there is nothing to cancel — come back and pay '
        'again when the month is up.';
  }
}

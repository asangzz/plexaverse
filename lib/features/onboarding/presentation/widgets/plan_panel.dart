import 'package:flutter/material.dart';

import '../../../../core/ui/app_icons.dart';
import '../../../../core/ui/zave/zave_kit.dart';
import '../../../pricing/domain/plan_offer.dart';

/// The plan step — the web's `components/onboarding/PlanStep.tsx`.
///
/// A panel, not a chip row: it carries a price, a list and a button, and a
/// commitment is not something to read at chip width.
///
/// **What is offered is the server's call.** The panel renders the UPI
/// AutoPay registration `/payment/config` quoted for this user
/// (TOKEN_AUTOPAY_SPEC.md §3.2, §4.1): a free month for ₹1 (refunded), a ₹1
/// registration whose first debit waits for a plan they already have, or ₹399
/// that IS month 1 for someone whose free month is spent. No offer — the rail
/// is dark, the company plan, outside India — and it is the 30-day pass. The
/// words for each are the web's (`autopay_copy.dart`).
///
/// **One control, and no skip.** That is the point of the step. A "maybe
/// later" would put a user into the product with no plan, where every feature
/// refuses them — worse than being asked plainly, once.
///
/// **The ₹1 is said out loud.** Setting up UPI AutoPay takes a ₹1 payment,
/// refunded automatically. A person told there would be no charge who then
/// sees one on their statement has been told something untrue on day one,
/// about money — so it gets a line of its own, on the autopay path only.
///
/// **Stop autopay exists, and the panel says what stopping does.** Settings →
/// Billing → Stop autopay, or the UPI app. In the free month a stop KEEPS the
/// rest of the month and nothing is taken (the owner rule of 21 Nov 2026);
/// after it, continuing means setting AutoPay up again with ₹399 — and a user
/// in that state is told so here. It never says "cancel any time": the word
/// is "stop".
class PlanPanel extends StatelessWidget {
  const PlanPanel({
    required this.offer,
    required this.failed,
    required this.busy,
    required this.error,
    required this.onStart,
    required this.onRetry,
    this.sheetUnfinished = false,
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

  /// A UPI AutoPay sheet was opened and did not finish (closed or failed).
  /// The step has no skip, so the panel then names the way out.
  final bool sheetUnfinished;

  /// What a closed or failed UPI AutoPay sheet is followed by. On the autopay
  /// path only: the pass needs no UPI app. The web's checkout offers a QR
  /// code any phone's UPI app can scan, which is the way through for a phone
  /// whose UPI app never opened; once AutoPay is set up there, this button
  /// finds the plan and moves on.
  static const String wayOut =
      'Did your UPI app not open? Try again, or set up AutoPay on '
      'plexaverse.com from a computer — scan the QR code there with the UPI '
      'app on your phone, then come back and tap the button again.';

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
    final PlanOffer? autopay = offer != null && offer.recurring ? offer : null;
    final ({String figure, String caption})? headline = autopay == null
        ? null
        : autopayHeadline(autopay);
    final String? kept = autopay == null ? null : keptFreeMonthLine(autopay);
    final String? oneRupee = autopay == null ? null : registrationLine(autopay);

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
                Text(headline?.figure ?? offer.priceLabel, style: ZaveType.h2),
                SizedBox(width: ZaveSpace.sm),
                Flexible(
                  child: Text(
                    headline?.caption ?? 'for one month',
                    style: ZaveType.bodyMuted,
                  ),
                ),
              ],
            ),
          if (offer != null) SizedBox(height: ZaveSpace.sm),
          // The owner rule of 21 Nov 2026: a free month kept after a stop is
          // said wherever the plan is offered, with how to continue.
          if (kept != null) ...<Widget>[
            Text(kept, style: ZaveType.label.copyWith(height: 1.6)),
            SizedBox(height: ZaveSpace.sm),
          ],
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
          // The registration payment (₹1), and whether it comes back. Not on
          // the pass (no mandate), and not on a ₹399 registration, which is
          // the plan itself and is in the terms above.
          if (oneRupee != null) ...<Widget>[
            SizedBox(height: ZaveSpace.sm),
            Text(oneRupee, style: ZaveType.caption.copyWith(height: 1.6)),
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
                  : autopay != null
                  ? autopayCta(autopay)
                  : 'Pay ${offer.priceLabel} for this month',
              onPressed: offer == null ? null : onStart,
            ),
          if (autopay != null && sheetUnfinished && !busy) ...<Widget>[
            SizedBox(height: ZaveSpace.md),
            Text(wayOut, style: ZaveType.caption.copyWith(height: 1.6)),
          ],
          // Which kind of payment this is, once it is known — not before.
          if (offer != null) ...<Widget>[
            SizedBox(height: ZaveSpace.md),
            Text(
              // No "cancel from Settings": the control is Stop autopay
              // (Settings → Billing), and the terms above say what stopping
              // does in the free month.
              autopay != null
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
    if (offer.recurring) return autopayTerms(offer);
    // India gets the pass whenever UPI Autopay is not offered (switched off,
    // or not this plan). "Not in your country" would be untrue there.
    if (offer.isIndia) {
      return 'One month of everything below, paid once. Autopay is not '
          'available right now, so nothing renews — come back and pay again '
          'when the month is up.';
    }
    return 'One month of everything below. We cannot set up autopay in your '
        'country yet, so there is nothing to cancel — come back and pay '
        'again when the month is up.';
  }
}

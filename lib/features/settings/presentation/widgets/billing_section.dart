import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/router/zave_routes.dart';
import '../../../../core/ui/app_icons.dart';
// Re-exports `UserPreferences` alongside the Settings entities, so this file
// needs one import for both rather than two that overlap.
import '../../../../core/ui/zave/zave_kit.dart';
import '../../../pricing/application/billing_state_controller.dart';
import '../../../pricing/application/plan_checkout.dart';
import '../../../pricing/application/pricing_controller.dart';
import '../../../pricing/domain/pricing_repository.dart';
import '../../../pricing/presentation/widgets/billing_state_picker.dart';
import '../../application/settings_controllers.dart';
import '../../domain/settings_repository.dart';
import 'billing_state_row.dart';
import 'settings_section.dart';
import 'tax_documents_list.dart';

/// **Billing** — the plan, and the account's UPI AutoPay mandate with the
/// user's own **Stop autopay** (TOKEN_AUTOPAY_SPEC.md §4.3, §4.4, D17).
///
/// Plan status first: no XP balance (wallet XP was retired on 10 Nov 2026;
/// the plan pays for every AI feature, up to a per-feature allowance), and
/// the price from `GET /geo/pricing`, never recomputed here.
///
/// **Checkout lives on Pricing.** The `razorpay_flutter` sheet runs there and
/// in the onboarding plan step (`PlanCheckout`); this section links to it —
/// except while a mandate is live, when there is nothing to buy and the
/// server would refuse a second plan.
///
/// **Stop autopay is owed, not offered.** NPCI's UPI circular 14.21 requires
/// a merchant-side way to stop UPI AutoPay, so the 17 Nov "no cancellation"
/// rule was reversed for it on 21 Nov 2026. The control is the web's
/// `BillingPanel`, with the same two-step confirm, and the confirm says
/// exactly what happens (the owner rule of 21 Nov 2026):
///   - in the free month: they keep it to its end and nothing is charged;
///     after it, using the plan again means setting AutoPay up again with a
///     payment;
///   - after a payment: they keep the plan to the end of what they paid for,
///     and nothing more is taken.
/// The word is "stop", never "cancel any time".
///
/// **AutoPay off is never a dead end.** Once it is off — stopped here, in the
/// UPI app, at the bank — the section says how long the plan still runs and
/// offers the way back on the registration the server quotes now: for a kept
/// free month that is the ₹399 paid registration whose month starts where
/// the free month ends.
///
/// **The buyer's GST State** ([BillingStateRow]): shown and changeable for an
/// India account, and asked inline before the way back registers UPI
/// AutoPay when none is on record (source `checkout`).
///
/// **Tax invoices last** ([TaxDocumentsList], §5.9): the GST invoices, credit
/// notes and refund vouchers, each opened in the app. Nothing shows until
/// there is a document, so a dark rail leaves the section as it was.
class BillingSection extends ConsumerWidget {
  const BillingSection({required this.preferences, super.key});

  final UserPreferences preferences;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<AccountSnapshot> account = ref.watch(
      accountSnapshotProvider,
    );
    final AsyncValue<GeoPricing> pricing = ref.watch(geoPricingProvider);
    final AsyncValue<AutopayStatus> autopay = ref.watch(autopayStatusProvider);

    if (account.hasError) {
      return SettingsSection(
        title: 'Billing',
        child: SectionError(
          message: "We couldn't load your plan.",
          onRetry: () => ref.invalidate(accountSnapshotProvider),
        ),
      );
    }

    final AccountSnapshot? snapshot = account.value;
    if (snapshot == null) {
      return const SettingsSection(
        title: 'Billing',
        child: SectionSkeleton(lines: 3),
      );
    }

    final SubscriptionState subscription = snapshot.subscription;
    final bool isCompany = preferences.isCompany;
    final GeoPricing? prices = pricing.value;
    final AutopayStatus? mandate = autopay.value;
    // Nothing below that depends on the mandate is decided before the status
    // has answered — not while it loads, and not when it failed.
    final bool statusAnswered = autopay.hasValue && !autopay.hasError;
    // A UPI AutoPay account speaks through the mandate panel below, which
    // knows whether anything renews; the generic line would say "Renews on"
    // about a mandate that was stopped (a stopped row with paid time left
    // still reads `subscription_active`).
    final bool onToken = mandate?.isToken ?? false;
    final bool live = mandate?.live ?? false;
    // Pricing is linked only once the status has answered and says no
    // mandate is live. Not while loading — a live mandate must not flash a
    // link to buy a second plan — and not on a failed read, where a live
    // mandate is as likely as not (the web shows no link there either).
    final bool linkPricing = statusAnswered && !live;
    final DateTime? until = subscription.isRecurring
        ? subscription.currentPeriodEnd
        : subscription.endsAt;

    return SettingsSection(
      title: 'Billing',
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
                    // A dim bar, not an em-dash at heading size: geo-pricing
                    // is a second request, so this is the state the panel
                    // opens in.
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

          if (statusAnswered &&
              !onToken &&
              subscription.isActive &&
              until != null) ...<Widget>[
            SizedBox(height: ZaveSpace.md),
            Text(
              subscription.isRecurring
                  ? 'Renews on ${DateFormat.yMMMd().format(until)}'
                  : 'Active until ${DateFormat.yMMMd().format(until)}',
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

          // The mandate, Stop autopay, and the way back once it is off.
          if (mandate != null && onToken) ...<Widget>[
            SizedBox(height: ZaveSpace.lg),
            Container(height: 1, color: ZaveColors.rule),
            SizedBox(height: ZaveSpace.lg),
            AutopayPanel(status: mandate),
          ],
          // An unreadable status still says where to go: the UPI app always
          // works.
          if (autopay.hasError && !autopay.isLoading) ...<Widget>[
            SizedBox(height: ZaveSpace.md),
            const UnavailableNote(
              message:
                  'We could not load your billing details. You can also stop '
                  'your UPI AutoPay in your UPI app.',
            ),
            SizedBox(height: ZaveSpace.sm),
            ZaveButton(
              label: 'Try again',
              onPressed: () => ref.invalidate(autopayStatusProvider),
            ),
          ],

          // Pricing owns the plan cards, what each plan includes, and the
          // checkout sheet. Never while a mandate is live: there is nothing
          // to buy, and the way to manage it is right here.
          if (linkPricing) ...<Widget>[
            SizedBox(height: ZaveSpace.lg),
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

          // The State every GST invoice names — India only.
          const BillingStateRow(),

          // The GST documents — nothing at all until there is one.
          const TaxDocumentsList(),
        ],
      ),
    );
  }
}

/// The account's UPI AutoPay mandate — the web's `BillingPanel`. Its invoice
/// list is [TaxDocumentsList], at the foot of [BillingSection], so a mandate
/// read that fails (which hides this panel) does not hide the documents.
///
/// Shows the next payment (amount and date, from `GET /autopay/status`), how
/// long the plan runs, and Stop autopay with its two-step confirm while the
/// mandate can still debit (`canStop`). Once AutoPay is off it offers the
/// way back — but not straight after a stop made here, which would offer to
/// undo, in the same breath, what the user just chose.
///
/// The way back asks the buyer's GST State first when none is on record
/// (they finished onboarding before it was asked): the picker takes the
/// button's place, and the registration opens once it is saved.
class AutopayPanel extends ConsumerStatefulWidget {
  const AutopayPanel({required this.status, super.key});

  final AutopayStatus status;

  @override
  ConsumerState<AutopayPanel> createState() => _AutopayPanelState();
}

class _AutopayPanelState extends ConsumerState<AutopayPanel> {
  bool _confirming = false;
  StopAutopayResult? _stopped;

  /// The way back's result: a set-up mandate, or one confirming with the bank.
  String? _restarted;
  String? _restartError;
  bool _restarting = false;

  /// The web's `#e5484d` — the one red this product uses for "this did not
  /// work", as the plan step's errors do.
  static const Color _alert = Color(0xFFE5484D);

  /// This panel's key on [BillingStateAsk].
  static const String _stateAskKey = 'settings:restart';

  Future<void> _stop() async {
    final StopAutopayResult? result = await ref
        .read(stopAutopayControllerProvider.notifier)
        .stop();
    if (!mounted || result == null) return;
    // The plan the account reads changes with the mandate.
    ref.invalidate(accountSnapshotProvider);
    setState(() {
      _stopped = result;
      _confirming = false;
    });
  }

  Future<void> _restart(PlanOffer offer) async {
    setState(() {
      _restarting = true;
      _restartError = null;
    });
    final PlanCheckoutOutcome outcome = await ref
        .read(planCheckoutProvider)
        .registerAutopay(planType: 'personal', countryCode: offer.countryCode);
    if (!mounted) return;
    String? done;
    String? error;
    bool offerStale = false;
    bool askedState = false;
    switch (outcome) {
      case PlanCheckoutStateNeeded():
        // Nothing was opened: the State is asked in the button's place.
        askedState = true;
        ref.read(billingStateAskProvider.notifier).ask(_stateAskKey);
      case PlanCheckoutDismissed():
        break;
      case PlanCheckoutFailed(:final String message, offerStale: final bool s):
        error = message;
        offerStale = s;
      case PlanCheckoutDone():
        done = 'Autopay is set up.';
      case PlanCheckoutPending():
        done = AutopayCheckoutCopy.requested;
      case PlanCheckoutAlreadyActive():
        break;
    }
    setState(() {
      _restarting = false;
      _restarted = done;
      _restartError = error;
    });
    if (offerStale) {
      // AUTOPAY_DISABLED: what this panel offers is out of date. Read it
      // again, so the button turns into what the server sells now instead of
      // failing the same way on every tap.
      ref
        ..invalidate(autopayRestartOfferProvider)
        ..invalidate(pricingPaymentConfigProvider);
    }
    if (error == null && !askedState) {
      ref
        ..invalidate(autopayStatusProvider)
        ..invalidate(autopayRestartOfferProvider)
        ..invalidate(pricingPaymentConfigProvider)
        ..invalidate(planAllowancesProvider)
        ..invalidate(accountSnapshotProvider)
        // A paid registration is invoiced in the transaction that applies it.
        ..invalidate(taxDocumentsProvider);
    }
  }

  @override
  Widget build(BuildContext context) {
    final AutopayStatus data = widget.status;
    final StopAutopayResult? stopped = _stopped;
    final AsyncValue<StopAutopayResult?> stopState = ref.watch(
      stopAutopayControllerProvider,
    );
    final bool askingState = ref.watch(billingStateAskProvider) == _stateAskKey;

    // AutoPay is off: what the server would register now (the way back),
    // read only then.
    final bool autopayOff = data.isToken && !data.canStop && stopped == null;
    final AsyncValue<PlanOffer?>? restartOffer = autopayOff
        ? ref.watch(autopayRestartOfferProvider)
        : null;
    final PlanOffer? offer = restartOffer?.value;
    final PlanOffer? restart = offer != null && offer.recurring ? offer : null;

    // The NEXT payment: one period's frozen amount (a test lever's ₹1, a
    // discounted debit). Never what starting again costs.
    final int? amountPaise = data.nextChargeAmountPaise;
    final String? amount = amountPaise == null
        ? null
        : rupeesFromPaise(amountPaise);
    // What setting AutoPay up again costs: the plan, from the server.
    final int? planPaise = data.monthlyPaise;
    final String? planAmount = planPaise == null
        ? null
        : rupeesFromPaise(planPaise);
    final DateTime? trialEnds = data.trialEndsAt;
    final DateTime? access = data.accessUntil;
    // A pass or a grant that runs past the free month (a referral month, an
    // admin grant): the plan does not end with the free month, and neither
    // the summary nor the confirm may say it does.
    final bool runsPastFreeMonth =
        data.inTrial &&
        trialEnds != null &&
        access != null &&
        access.isAfter(trialEnds);

    final String summary = _summary(
      data,
      stopped: stopped,
      restart: restart,
      amount: amount,
      planAmount: planAmount,
      runsPastFreeMonth: runsPastFreeMonth,
    );
    final bool planOver = !data.canStop && !data.inTrial && access == null;
    // AutoPay off with a debit already announced: the way back waits for it
    // to settle (the pass and a new registration are both refused until
    // then), so the section says that instead of offering a dead button.
    final bool settling = autopayOff && data.debitInFlight;
    final bool inFlight = stopped?.debitInFlight ?? false;
    final bool canStop = stopped == null && data.canStop;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('UPI AUTOPAY', style: ZaveType.kicker),
        SizedBox(height: ZaveSpace.xs),
        Semantics(
          liveRegion: stopped != null,
          child: Text(summary, style: ZaveType.label),
        ),

        if (canStop && data.tokenStatus == 'paused') ...<Widget>[
          SizedBox(height: ZaveSpace.sm),
          Text(
            'AutoPay is paused in your UPI app. Nothing is taken while it is '
            'paused.',
            style: ZaveType.caption,
          ),
        ],

        if (inFlight || settling) ...<Widget>[
          SizedBox(height: ZaveSpace.sm),
          UnavailableNote(
            message:
                'A payment your UPI app already announced may still go '
                'through. If it does, we refund it in full.'
                '${settling ? ' You can continue once it has settled.' : ''}',
          ),
        ],

        if (canStop && !_confirming) ...<Widget>[
          SizedBox(height: ZaveSpace.md),
          ZaveButton(
            label: 'Stop autopay',
            onPressed: () {
              ref.read(stopAutopayControllerProvider.notifier).reset();
              setState(() => _confirming = true);
            },
          ),
        ],

        if (canStop && _confirming) ...<Widget>[
          SizedBox(height: ZaveSpace.md),
          _StopConfirm(
            consequence: _consequence(
              data,
              planAmount: planAmount,
              runsPastFreeMonth: runsPastFreeMonth,
            ),
            busy: stopState.isLoading,
            error: stopState.hasError
                ? stopAutopayErrorMessage(stopState.error!)
                : null,
            onStop: _stop,
            onKeep: () => setState(() => _confirming = false),
          ),
        ],

        if (autopayOff && _restarted != null) ...<Widget>[
          SizedBox(height: ZaveSpace.md),
          Semantics(
            liveRegion: true,
            child: Text(_restarted!, style: ZaveType.label),
          ),
        ],

        if (autopayOff &&
            _restarted == null &&
            restart != null &&
            !settling) ...<Widget>[
          SizedBox(height: ZaveSpace.md),
          Text(autopayTerms(restart), style: ZaveType.caption),
          if (registrationLine(restart) != null) ...<Widget>[
            SizedBox(height: ZaveSpace.xs),
            Text(registrationLine(restart)!, style: ZaveType.caption),
          ],
          if (_restartError != null) ...<Widget>[
            SizedBox(height: ZaveSpace.sm),
            Semantics(
              liveRegion: true,
              child: Text(
                _restartError!,
                style: ZaveType.label.copyWith(color: _alert),
              ),
            ),
          ],
          SizedBox(height: ZaveSpace.md),
          if (askingState)
            BillingStateForm(
              source: BillingStateSource.checkout,
              showQuestion: true,
              submitLabel: 'Save and continue',
              submitKind: ZaveButtonKind.brand,
              onSaved: (SavedBillingState _) {
                ref.read(billingStateAskProvider.notifier).clear();
                _restart(restart);
              },
              onCancel: () =>
                  ref.read(billingStateAskProvider.notifier).clear(),
            )
          else
            ZaveButton.brand(
              label: _restarting ? 'Opening' : _restartLabel(restart),
              busy: _restarting,
              onPressed: _restarting ? null : () => _restart(restart),
            ),
        ],

        // A way back the server refused as out of date (AUTOPAY_DISABLED):
        // the offer is read again and may no longer be UPI AutoPay, but the
        // sentence saying why stays.
        if (autopayOff &&
            _restarted == null &&
            restart == null &&
            _restartError != null) ...<Widget>[
          SizedBox(height: ZaveSpace.sm),
          Semantics(
            liveRegion: true,
            child: Text(
              _restartError!,
              style: ZaveType.label.copyWith(color: _alert),
            ),
          ),
        ],

        if (autopayOff &&
            _restarted == null &&
            (restartOffer?.hasError ?? false) &&
            !(restartOffer?.isLoading ?? false)) ...<Widget>[
          SizedBox(height: ZaveSpace.sm),
          ZaveButton(
            label: 'We could not load how to continue. Try again',
            onPressed: () => ref.invalidate(autopayRestartOfferProvider),
          ),
        ],

        // No autopay offer (the rail is off, or not India) and nothing left:
        // the 30-day pass. Never while a mandate is live — this needs
        // AutoPay off.
        if (autopayOff &&
            _restarted == null &&
            !settling &&
            planOver &&
            offer != null &&
            !offer.recurring) ...<Widget>[
          SizedBox(height: ZaveSpace.sm),
          Text(
            'Get a 30-day pass to keep using the plan.',
            style: ZaveType.caption,
          ),
        ],

        SizedBox(height: ZaveSpace.md),
        Text(
          'You can also stop AutoPay in your UPI app, at your bank, or by '
          'writing to us — see the refund and cancellation policy on '
          'plexaverse.com.',
          style: ZaveType.caption,
        ),
      ],
    );
  }

  /// The line under "UPI AUTOPAY" — the web's `BillingPanel` summary.
  static String _summary(
    AutopayStatus data, {
    required StopAutopayResult? stopped,
    required PlanOffer? restart,
    required String? amount,
    required String? planAmount,
    required bool runsPastFreeMonth,
  }) {
    if (stopped != null) {
      return 'Autopay is stopped. Your UPI app may take a few minutes to show '
          'it.';
    }
    final DateTime? next = data.nextChargeAt;
    final DateTime? trialEnds = data.trialEndsAt;
    final DateTime? access = data.accessUntil;
    final String payment = amount == null ? 'payment' : 'payment of $amount';
    if (data.canStop) {
      if (data.inTrial && trialEnds != null) {
        return next != null
            ? 'Free month until ${istDay(trialEnds)}. First $payment on '
                  '${istDay(next)}.'
            : 'Free month until ${istDay(trialEnds)}.';
      }
      return next != null
          ? 'Next $payment on ${istDay(next)}.'
          : 'UPI AutoPay is on.';
    }
    if (data.inTrial && trialEnds != null) {
      if (runsPastFreeMonth) {
        return 'AutoPay is off. Your free month ends on ${istDay(trialEnds)}, '
            'and your plan runs until ${istDay(access!)}. Nothing more is '
            'taken.';
      }
      final String? kept = restart == null ? null : keptFreeMonthLine(restart);
      // The owner rule's own words, with the plan's price from the status.
      return kept ??
          'AutoPay is off. Your free month ends on ${istDay(trialEnds)} — set '
              'up AutoPay${planAmount == null ? '' : ' with $planAmount'} to '
              'continue.';
    }
    if (access != null) {
      return 'AutoPay is off. You keep your plan until ${istDay(access)}. '
          'Nothing more is taken.';
    }
    if (restart != null) {
      // Nothing left: the kept free month (or the paid time) has run out.
      return keptFreeMonthLine(restart) ??
          'AutoPay is off and your plan has ended. Set up AutoPay with '
              '${restart.priceLabel} to continue.';
    }
    return 'AutoPay is off. Nothing more is taken.';
  }

  /// What the confirm promises — the server keeps exactly this.
  ///
  /// [planAmount] is the plan a new registration is for (`monthlyPaise`):
  /// starting again is the ₹399 paid registration, whatever the next
  /// period's charge happens to be frozen at.
  static String _consequence(
    AutopayStatus data, {
    required String? planAmount,
    required bool runsPastFreeMonth,
  }) {
    final DateTime? trialEnds = data.trialEndsAt;
    final DateTime? access = data.accessUntil;
    final String again = planAmount == null
        ? 'setting up AutoPay again'
        : 'setting up AutoPay with a payment of $planAmount';
    if (data.inTrial && trialEnds != null) {
      return runsPastFreeMonth
          ? 'You keep your free month until ${istDay(trialEnds)} and your '
                'plan until ${istDay(access!)}, and nothing is charged. After '
                'that, using the plan again means $again.'
          : 'You keep your free month until ${istDay(trialEnds)}, and nothing '
                'is charged. After it ends, using the plan again means $again.';
    }
    if (access != null) {
      return 'You keep the plan until ${istDay(access)}. Nothing more is '
          'taken.';
    }
    return 'Nothing more is taken.';
  }

  /// The way back's button: the registration's own amount for `paid`.
  static String _restartLabel(PlanOffer o) {
    if (o.kind == MandateKind.paid) {
      return 'Set up AutoPay with ₹${inr(o.registrationRupees)}';
    }
    if (o.kind == MandateKind.trial && o.registrationRefunded) {
      return 'Start my free month';
    }
    return 'Set up AutoPay';
  }
}

/// The second step of Stop autopay — the web's alert dialog, inline.
class _StopConfirm extends StatelessWidget {
  const _StopConfirm({
    required this.consequence,
    required this.busy,
    required this.error,
    required this.onStop,
    required this.onKeep,
  });

  final String consequence;
  final bool busy;
  final String? error;
  final VoidCallback onStop;
  final VoidCallback onKeep;

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
      child: Semantics(
        container: true,
        label: 'Stop autopay?',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Stop autopay?', style: ZaveType.label),
            SizedBox(height: ZaveSpace.xs),
            Text(consequence, style: ZaveType.caption),
            if (error != null) ...<Widget>[
              SizedBox(height: ZaveSpace.sm),
              Semantics(
                liveRegion: true,
                child: Text(
                  error!,
                  style: ZaveType.label.copyWith(
                    color: _AutopayPanelState._alert,
                  ),
                ),
              ),
            ],
            SizedBox(height: ZaveSpace.md),
            Wrap(
              spacing: ZaveSpace.md,
              runSpacing: ZaveSpace.sm,
              children: <Widget>[
                ZaveButton(
                  label: busy ? 'Stopping…' : 'Stop autopay',
                  busy: busy,
                  onPressed: busy ? null : onStop,
                ),
                ZaveButton(
                  label: 'Keep autopay',
                  onPressed: busy ? null : onKeep,
                ),
              ],
            ),
          ],
        ),
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
      if (subscription.isTrial) {
        label = 'Free month';
      } else if (subscription.isRecurring) {
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

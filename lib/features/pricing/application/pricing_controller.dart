import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/platform/checkout.dart';
import '../data/pricing_repositories.dart';
import '../domain/pricing_repository.dart';
import 'billing_state_controller.dart';
import 'plan_checkout.dart';

part 'pricing_controller.g.dart';

// Pricing is ONE SCREEN MADE OF INDEPENDENT BLOCKS — the price list, the plan
// gate, what a plan includes, the referral card — so it is modelled as small
// providers rather than one snapshot. The web reaches the same shape with one
// hook per resource, and the reason is worth repeating: a referral read that
// 500s must not take the price list down with it.

/// Localised plan prices — and, on this screen, the region every card's
/// offer and checkout country are decided from.
///
/// NO `?country=`: the server reads the edge's country, exactly as for the
/// onboarding plan step and Settings' way back ([autopayRestartOffer]). The
/// region now picks the payment instrument, not only a displayed price — India
/// gets UPI AutoPay and a free month, everywhere else the international pass —
/// and the phone's locale is a LANGUAGE setting: "English (United States)" is
/// an ordinary choice in India, and reading it here sold an Indian user the
/// international pass and skipped their free month, while onboarding and
/// Settings offered the same person UPI AutoPay.
@riverpod
Future<PlanPricing> planPricing(Ref ref) =>
    ref.watch(pricingRepositoryProvider).fetchPricing();

/// Which plans this account may buy.
///
/// Its own provider rather than a field on [planPricing] so a slow or failed
/// preferences read delays the GATE, not the prices. Null while loading and
/// null on failure both mean "show everything", which is the web's own
/// behaviour before `brandType` arrives.
@riverpod
Future<String?> pricingBrandType(Ref ref) =>
    ref.watch(pricingRepositoryProvider).fetchBrandType();

/// What every plan includes, per AI feature.
///
/// Never errors: a failed read falls back to [AllowanceTable.fallback], the
/// static list that mirrors the web's defaults. The block exists to say what a
/// plan buys, and a user deciding whether to pay should not see that sentence
/// replaced by a retry button. An empty live answer falls back too — a plan
/// that includes nothing is never the truth.
@riverpod
Future<AllowanceTable> planAllowances(Ref ref) async {
  try {
    final List<Allowance> rows = await ref
        .watch(pricingRepositoryProvider)
        .fetchAllowances();
    if (rows.isEmpty) return AllowanceTable.fallback;
    return AllowanceTable(rows: rows, live: true);
  } on Object {
    return AllowanceTable.fallback;
  }
}

/// The referral code and its lifetime counters.
@riverpod
class ReferralController extends _$ReferralController {
  @override
  Future<ReferralSummary> build() =>
      ref.watch(pricingRepositoryProvider).fetchReferral();

  /// Issues a code. Idempotent server-side — it returns the existing unused
  /// code rather than minting a second active one, so a double-tap is safe.
  Future<void> generate() async {
    state = const AsyncLoading<ReferralSummary>();
    state = await AsyncValue.guard<ReferralSummary>(
      () => ref.read(pricingRepositoryProvider).generateReferralCode(),
    );
  }
}

/// `GET /payment/config` — this user's UPI AutoPay offer (TOKEN_AUTOPAY_SPEC
/// §4.1). Its own provider so a failed read is a retry on the plan cards
/// only, never a fallback to the pass: the server may owe this person a free
/// month.
@riverpod
Future<PaymentConfig> pricingPaymentConfig(Ref ref) =>
    ref.watch(pricingRepositoryProvider).fetchPaymentConfig();

/// `GET /autopay/status` — the account's UPI AutoPay mandate: the next
/// payment, how long the plan runs, and whether Stop autopay applies. Read by
/// Settings → Billing, and by Pricing so a live mandate is never sold a
/// second plan.
@riverpod
Future<AutopayStatus> autopayStatus(Ref ref) =>
    ref.watch(pricingRepositoryProvider).fetchAutopayStatus();

/// `GET /billing/invoices` — the user's GST tax invoices, credit notes and
/// refund vouchers (TOKEN_AUTOPAY_SPEC.md §5.9), for Settings → Billing. Its
/// own provider so a failed read is a retry on the list only.
@riverpod
Future<List<TaxDocument>> taxDocuments(Ref ref) =>
    ref.watch(pricingRepositoryProvider).fetchTaxDocuments();

/// One document's printable page, fetched with the bearer token. Disposed
/// with the sheet that shows it: a tax document is read when it is opened,
/// never kept in memory behind the list.
@riverpod
Future<String> taxDocumentHtml(Ref ref, String id) =>
    ref.watch(pricingRepositoryProvider).fetchTaxDocumentHtml(id);

/// The way back once AutoPay is off (Settings → Billing): the personal offer
/// the server would register NOW, decided like the onboarding plan step's —
/// the region from the server's edge, not the device locale. Null when what
/// is offered is not UPI AutoPay (the rail is dark, or not India). Throws
/// when it cannot be worked out, so the section shows a retry.
@riverpod
Future<PlanOffer?> autopayRestartOffer(Ref ref) async {
  final PricingRepository repo = ref.watch(pricingRepositoryProvider);
  final Future<bool> onDevice = ref.watch(upiAutopayOnDeviceProvider.future);
  final (PlanPricing pricing, PaymentConfig config) = await (
    repo.fetchPricing(),
    repo.fetchPaymentConfig(),
  ).wait;
  final PlanOffer? offer = PlanOffer.decide(
    pricing: pricing,
    config: config,
    planType: 'personal',
    upiAutopayOnDevice: await onDevice,
  );
  if (offer == null) throw const PricingUnavailable();
  return offer;
}

/// Everything a new or ended plan changes: the offer, the mandate, the
/// allowances every gate answers from, the prices, and the tax documents.
void invalidatePlanState(Ref ref) {
  ref
    ..invalidate(planPricingProvider)
    ..invalidate(pricingBrandTypeProvider)
    ..invalidate(planAllowancesProvider)
    ..invalidate(pricingPaymentConfigProvider)
    ..invalidate(autopayStatusProvider)
    ..invalidate(autopayRestartOfferProvider)
    // A paid registration is invoiced in the same transaction that applies it.
    ..invalidate(taxDocumentsProvider);
}

/// What the Pricing screen says once a checkout settles — the web's
/// `SUCCESS_COPY`, one sentence each.
abstract final class PlanResultCopy {
  static const String pass = 'You are on the plan. Welcome aboard.';
  static const String mandate =
      'Autopay is set up. Your plan is active — every feature is yours to use.';
  static const String already =
      'You already have a plan, so there is nothing to set up.';
}

/// Buying a plan from the Pricing screen.
///
/// The create → sheet → verify sequence is [PlanCheckout]'s, shared with the
/// onboarding plan step; this dispatches on the [PlanOffer] (UPI AutoPay or
/// the 30-day pass), turns the outcome into the screen's message, and
/// refreshes what a new plan changes.
///
/// The state is the plan id whose checkout is open, so a second tap cannot
/// open a second sheet.
///
/// An India buyer with no GST State on record is asked it first: the
/// checkout answers [PlanCheckoutStateNeeded], this marks the card
/// ([BillingStateAsk]), and the page runs [buy] again once it is saved.
@riverpod
class CheckoutController extends _$CheckoutController {
  @override
  String? build() => null;

  /// Returns a message to show, or null when there is nothing to say
  /// (the user closed the sheet — their decision, not an error).
  Future<String?> buy(PlanOffer offer) async {
    if (state != null) return null;
    state = offer.planType;
    try {
      final PlanCheckout checkout = ref.read(planCheckoutProvider);
      final PlanCheckoutOutcome outcome = offer.recurring
          ? await checkout.registerAutopay(
              planType: offer.planType,
              countryCode: offer.countryCode,
            )
          : await checkout.payForMonth(
              planType: offer.planType,
              countryCode: offer.countryCode,
            );
      if (!ref.mounted) return null;

      switch (outcome) {
        case PlanCheckoutStateNeeded():
          // Nothing was opened. The card asks the State in place of its
          // button; nothing to say.
          ref.read(billingStateAskProvider.notifier).ask(offer.planType);
          return null;
        case PlanCheckoutDismissed():
          return null;
        case PlanCheckoutFailed(:final String message, :final bool offerStale):
          // AUTOPAY_DISABLED: the card's offer is the pass now.
          if (offerStale) invalidatePlanState(ref);
          return message;
        case PlanCheckoutDone():
          invalidatePlanState(ref);
          return offer.recurring ? PlanResultCopy.mandate : PlanResultCopy.pass;
        case PlanCheckoutPending():
          invalidatePlanState(ref);
          return AutopayCheckoutCopy.requested;
        case PlanCheckoutAlreadyActive(:final String? message):
          invalidatePlanState(ref);
          return message ?? PlanResultCopy.already;
      }
    } finally {
      if (ref.mounted) state = null;
    }
  }
}

/// Stop autopay, from Settings → Billing (TOKEN_AUTOPAY_SPEC.md D17).
///
/// The server stops the database first and then tells Razorpay; a success
/// always means nothing more will be debited. The state is the last result
/// (null before any stop); an error carries the server's sentence when it
/// sent one ([stopAutopayErrorMessage]).
@riverpod
class StopAutopayController extends _$StopAutopayController {
  @override
  FutureOr<StopAutopayResult?> build() => null;

  /// Returns the result, or null when the stop failed (the state holds why).
  Future<StopAutopayResult?> stop() async {
    state = const AsyncLoading<StopAutopayResult?>();
    final AsyncValue<StopAutopayResult?> next =
        await AsyncValue.guard<StopAutopayResult?>(
          () => ref.read(pricingRepositoryProvider).stopAutopay(),
        );
    if (!ref.mounted) return next.value;
    state = next;
    if (next.hasValue) invalidatePlanState(ref);
    return next.value;
  }

  /// Back to "nothing tried yet" — a fresh confirm shows no old error.
  void reset() => state = const AsyncData<StopAutopayResult?>(null);
}

/// What a failed stop says: the server's sentence, else a fallback that still
/// says where else it can be done.
String stopAutopayErrorMessage(Object error) =>
    PlanCheckout.serverMessage(error) ??
    'We could not stop autopay just now. Try again, or stop it in your UPI '
        'app.';

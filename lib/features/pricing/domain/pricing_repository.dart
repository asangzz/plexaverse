import 'allowance.dart';
import 'autopay.dart';
import 'billing_state.dart';
import 'plan_offer.dart';
import 'pricing.dart';
import 'tax_document.dart';

export 'allowance.dart';
export 'autopay.dart';
export 'billing_state.dart';
export 'plan_offer.dart';
export 'pricing.dart';
export 'tax_document.dart';

/// Thrown when a pricing read cannot be satisfied.
///
/// One const sentinel for the whole slice, matching planner / settings: the UI
/// never branches on a typed error taxonomy, only on "this block did not load",
/// and each block renders its own retry.
class PricingUnavailable implements Exception {
  const PricingUnavailable();
}

/// Seam between the plan screens (Pricing, and onboarding's plan step) and the
/// mobile API.
///
/// Checkout is the server half only — open the UPI AutoPay registration or the
/// pass order, then verify what the Razorpay sheet returned. The sheet itself
/// is `core/platform/checkout.dart`, and the three are run in order by
/// `PlanCheckout`.
///
/// There is no Razorpay SUBSCRIPTION here any more: Subscriptions are disabled
/// on the account (21 Nov 2026), and the server answers `/subscription/*`
/// with AUTOPAY_DISABLED for the builds that still call it. Autopay is a UPI
/// AutoPay mandate on Razorpay Recurring Payments (TOKEN_AUTOPAY_SPEC.md).
abstract class PricingRepository {
  /// Localised plan prices. Leave [countryCode] out wherever the answer
  /// decides what is SOLD: the server then reads the edge's country (and
  /// defaults to `IN`). A phone's locale is a language setting, not where
  /// its owner is.
  Future<PlanPricing> fetchPricing({String? countryCode});

  /// The one field of `GET /user/preferences` this screen needs: which plan
  /// the account is even allowed to buy.
  ///
  /// Null means "not answered yet" — a brand-new user with no preferences row,
  /// or a read that failed. Both render BOTH plans, which is the web's own
  /// null-brandType branch rather than a guess.
  Future<String?> fetchBrandType();

  /// `GET /user/allowances` — what the plan includes per AI feature, and how
  /// much of each this user has used this period.
  ///
  /// Throws [PricingUnavailable] on any failure; the provider, not the
  /// repository, decides to fall back to [Allowance.defaults], so a test can
  /// still tell a live answer from the fallback.
  Future<List<Allowance>> fetchAllowances();

  /// `GET /referral` — the active code plus lifetime counters.
  Future<ReferralSummary> fetchReferral();

  /// `POST /referral` — issues a code, or returns the existing unused one.
  /// The server never hands out two active codes at once, so this is safe to
  /// re-tap.
  Future<ReferralSummary> generateReferralCode();

  /// `GET /payment/config` — this user's UPI AutoPay offer, or none
  /// (TOKEN_AUTOPAY_SPEC.md §4.1). Throws [PricingUnavailable] when it cannot
  /// be read at all; "could not work out the offer" is
  /// [PaymentConfig.tokenOfferUnavailable], not a throw.
  Future<PaymentConfig> fetchPaymentConfig();

  /// `POST /autopay/create` — open a UPI AutoPay registration.
  ///
  /// [copyVersion] is the checkout copy this build showed
  /// ([kAutopayCheckoutCopyVersion]). THROWS on an empty `orderId` or
  /// `customerId` (see [MandateIntent.fromJson]); a refusal (409
  /// ALREADY_SUBSCRIBED / MANDATE_PENDING / MANDATE_IN_PROGRESS, 400
  /// AUTOPAY_DISABLED) arrives as the `DioException` whose `error` carries
  /// the code and the server's sentence.
  Future<MandateIntent> createMandate({
    required String planType,
    required String countryCode,
    required String copyVersion,
  });

  /// `POST /autopay/verify` — the sheet's result, checked by the server
  /// (signature first, then Razorpay's own record of the payment). A 400
  /// with an [AutopayRefusals] sentence means the payment set nothing up.
  Future<MandateVerification> verifyMandate({
    required String orderId,
    required String paymentId,
    required String signature,
  });

  /// `POST /autopay/stop` — the user's own Stop autopay (D17). The database
  /// stops first, then Razorpay is told; a 404 means there is no UPI
  /// AutoPay on the account.
  Future<StopAutopayResult> stopAutopay();

  /// `GET /autopay/status` — the mandate, the next payment and how long the
  /// plan runs. Throws [PricingUnavailable] on any failure.
  Future<AutopayStatus> fetchAutopayStatus();

  /// `GET /billing/invoices` — the user's GST tax invoices, credit notes and
  /// refund vouchers, newest first (TOKEN_AUTOPAY_SPEC.md §5.9).
  ///
  /// Empty for nearly everyone while the rail is dark: documents exist only
  /// for UPI AutoPay payments. A 404 (a server older than the route) and a
  /// 401 read as empty, as the web's list does; anything else unreadable
  /// throws [PricingUnavailable].
  Future<List<TaxDocument>> fetchTaxDocuments();

  /// `GET /billing/invoices/[id]` — that document as the printable HTML page
  /// the web serves, fetched WITH the bearer token (the route needs it, so
  /// the page is never handed to a browser). Throws [PricingUnavailable] on
  /// any failure, including a body that is not a page.
  Future<String> fetchTaxDocumentHtml(String id);

  /// `GET /user/billing-state` — the buyer's GST State on record, and the
  /// State the server's edge would pre-select. Throws [PricingUnavailable]
  /// on any failure — including a server older than the route — which every
  /// caller reads as "do not ask", never as "do not let them pay".
  Future<BillingState> fetchBillingState();

  /// `PUT /user/billing-state` — the buyer's own choice, and where it was
  /// made. A refusal (400 VALIDATION_FAILED) arrives as the `DioException`
  /// whose `error` carries the server's sentence; a body with no State
  /// throws a [StateError].
  Future<SavedBillingState> saveBillingState({
    required String stateCode,
    required BillingStateSource source,
  });

  /// `POST /payment/create-order` — a one-time 30-day pass, wherever UPI
  /// AutoPay is not offered. Priced by the server from [countryCode].
  Future<OrderIntent> createOrder({
    required String planType,
    required String countryCode,
  });

  /// `POST /payment/verify` — the pass's signature, checked by the server.
  /// Returns true when the server accepted it.
  Future<bool> verifyOrder({
    required String orderId,
    required String paymentId,
    required String signature,
  });
}

/// What the payment sheet needs for a one-time pass.
class OrderIntent {
  const OrderIntent({
    required this.orderId,
    required this.keyId,
    required this.amount,
    required this.currency,
  });

  final String orderId;

  /// Absent when Razorpay is not configured — the caller must refuse to open
  /// a sheet it cannot identify rather than send an empty key and get an
  /// opaque SDK error.
  final String? keyId;

  /// In the currency's minor unit (paise, cents), as the sheet takes it.
  final int amount;
  final String currency;
}

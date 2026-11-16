import 'allowance.dart';
import 'plan_offer.dart';
import 'pricing.dart';

export 'allowance.dart';
export 'plan_offer.dart';
export 'pricing.dart';

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
/// Checkout is the server half only — create the mandate or the order, then
/// verify what the Razorpay sheet returned. The sheet itself is
/// `core/platform/checkout.dart`, and the three are run in order by
/// `PlanCheckout`.
abstract class PricingRepository {
  /// Localised plan prices. [countryCode] is the device's region; the server
  /// defaults to `IN` when it is absent or unrecognised.
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

  /// Opens a Razorpay subscription mandate for [planType] and returns what
  /// the payment sheet needs.
  Future<CheckoutIntent> createSubscription({
    required String planType,
    String? countryCode,
  });

  /// Hands the sheet's result to the server, which checks the signature
  /// before activating anything.
  ///
  /// NOTHING is trusted from the device here — a paid-looking response from
  /// the sheet is a claim, and this is the call that turns it into a fact.
  /// Returns true when the server accepted it.
  Future<bool> verifySubscription({
    required String paymentId,
    required String subscriptionId,
    required String signature,
  });

  /// `GET /payment/config` — whether autopay can complete in each region.
  Future<PaymentConfig> fetchPaymentConfig();

  /// `POST /payment/create-order` — a one-time 30-day pass, for where autopay
  /// cannot complete. Priced by the server from [countryCode].
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

/// What the payment sheet needs to open.
class CheckoutIntent {
  const CheckoutIntent({
    required this.subscriptionId,
    required this.keyId,
    required this.amount,
    required this.currency,
  });

  final String subscriptionId;

  /// From the server, per order. Absent when Razorpay is not configured —
  /// the caller must refuse to open a sheet it cannot identify rather than
  /// send an empty key and get an opaque SDK error.
  final String? keyId;
  final int amount;
  final String currency;
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

  /// Absent when Razorpay is not configured — see [CheckoutIntent.keyId].
  final String? keyId;

  /// In the currency's minor unit (paise, cents), as the sheet takes it.
  final int amount;
  final String currency;
}

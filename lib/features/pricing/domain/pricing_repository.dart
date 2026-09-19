import 'pricing.dart';

export 'pricing.dart';

/// Thrown when a pricing read cannot be satisfied.
///
/// One const sentinel for the whole slice, matching planner / settings: the UI
/// never branches on a typed error taxonomy, only on "this block did not load",
/// and each block renders its own retry.
class PricingUnavailable implements Exception {
  const PricingUnavailable();
}

/// Seam between the Pricing screen and the mobile API.
///
/// ## What is deliberately absent: checkout
///
/// There is no `startCheckout`. Both money routes exist
/// (`POST /subscription/create`, `POST /payment/create-order`) and both return
/// a Razorpay order/subscription id that is worthless without the Razorpay
/// **checkout SDK** to hand it to. The app does not ship `razorpay_flutter`
/// and this slice may not add a dependency, so creating an order here would
/// take the user's money-intent and drop it on the floor — a charge that never
/// opens, or worse, an order row with no payment against it.
///
/// So the screen renders the plans and says plainly that checkout happens on
/// the web. That is the same call the Settings slice made for Slack and Google
/// Calendar: a button that cannot finish what it starts is worse than an honest
/// sentence. See the summary for the dependency this needs.
///
/// ## What is absent because the ROUTE is absent
///
/// The web decides subscribe-vs-one-time from `GET /api/payment/config`
/// (`{indiaAutopay, intlAutopay}`). There is no mobile mirror of it, so this
/// app cannot tell a user whether their region is billed monthly or per
/// purchase. The price is therefore labelled neutrally rather than `/month`.
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

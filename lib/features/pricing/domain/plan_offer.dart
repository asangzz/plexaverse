import 'pricing.dart';

/// Days of the free first month — the server's `FREE_FIRST_MONTH_DAYS`
/// (`lib/services/subscription-policy.ts`). Display only: the server decides
/// when the first charge falls, and a returning customer gets no second trial.
const int kFreeFirstMonthDays = 30;

/// `GET /payment/config` — whether autopay can complete, per region.
class PaymentConfig {
  const PaymentConfig({required this.indiaAutopay, required this.intlAutopay});

  factory PaymentConfig.fromJson(Map<String, dynamic> json) => PaymentConfig(
    // Only an explicit true. A missing flag is not a yes: offering autopay
    // where it cannot complete is the wall the web's plan step was rebuilt
    // to avoid.
    indiaAutopay: json['indiaAutopay'] == true,
    intlAutopay: json['intlAutopay'] == true,
  );

  final bool indiaAutopay;
  final bool intlAutopay;
}

/// What the onboarding plan step offers this account — the web's `PlanStep`,
/// decided before anything is shown.
///
/// Autopay where it works, a 30-day pass where it does not. India registers a
/// mandate and gets the first month free; everywhere else buys one month at a
/// time, because there is no mandate to charge later — and so no free month
/// either: a trial with nothing to collect at the end of it is a month given
/// away.
class PlanOffer {
  const PlanOffer({
    required this.planType,
    required this.countryCode,
    required this.recurring,
    required this.price,
    required this.symbol,
  });

  /// [planType] follows the brand: the Company plan is closed to new signups,
  /// and the server refuses a plan that disagrees with `brandType` anyway.
  factory PlanOffer.decide({
    required PlanPricing pricing,
    required PaymentConfig config,
    required String planType,
  }) {
    final bool recurring = pricing.isIndia
        ? config.indiaAutopay
        : config.intlAutopay;
    return PlanOffer(
      planType: planType,
      countryCode: pricing.countryCode,
      recurring: recurring,
      // A subscription is always charged in rupees, so autopay is priced from
      // the rupee amount and shown with ₹ wherever the subscriber is. The
      // fallback is only reached on a server older than that field, where it
      // is still right for India — the one region autopay is on.
      price: recurring
          ? pricing.subscriptionAmountInr[planType] ??
                pricing.priceFor(planType)
          : pricing.priceFor(planType),
      symbol: recurring ? '₹' : pricing.symbol,
    );
  }

  /// `'personal'` | `'company'`.
  final String planType;

  /// Sent back with the checkout. The server prices from it and defaults to
  /// India without it — which is how every international signup was once
  /// created as an India subscription, silently.
  final String countryCode;

  /// An autopay mandate (true) or a one-time 30-day pass (false).
  final bool recurring;

  /// After the free month when [recurring]; the pass itself when not.
  final int price;
  final String symbol;

  /// `₹399`, `$10`.
  String get priceLabel => '$symbol${groupedNumber(price)}';
}

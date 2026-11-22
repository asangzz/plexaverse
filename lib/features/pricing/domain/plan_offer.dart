import 'autopay_copy.dart';
import 'pricing.dart';

export 'autopay_copy.dart';

/// Which UPI AutoPay checkout copy this build shows — the web's
/// `AUTOPAY_CHECKOUT_COPY_VERSION` (`lib/plan-offer.ts`), sent back with every
/// registration and stored on the mandate as the record of what the user was
/// told before approving it (TOKEN_AUTOPAY_SPEC.md §3.3 step 7).
///
/// The sentences in `autopay_copy.dart` are the web's, word for word, so the
/// version is the web's too. Change both together: the server refuses a
/// version it does not know rather than store one that describes nothing, and
/// it must keep accepting this one for as long as this build is in the stores.
const String kAutopayCheckoutCopyVersion = 'upi-autopay-2026-11-21';

/// The registration the server would open for this user (TOKEN_AUTOPAY_SPEC.md
/// §3.2): `trial` (a free month for ₹1), `deferred` (₹1 now, the first debit
/// after a plan they already have) or `paid` (₹399 that IS month 1 — the free
/// month is once per account).
enum MandateKind {
  trial,
  deferred,
  paid;

  static MandateKind? parse(Object? wire) => switch (wire) {
    'trial' => MandateKind.trial,
    'deferred' => MandateKind.deferred,
    'paid' => MandateKind.paid,
    _ => null,
  };
}

/// `tokenOffer` from `GET /payment/config` — the server's `TokenOffer`
/// (`lib/services/autopay.service.ts`). Amounts in paise, dates as instants.
class TokenOffer {
  const TokenOffer({
    required this.kind,
    required this.registrationPaise,
    required this.registrationRefunded,
    required this.monthlyPaise,
    required this.maxAmountPaise,
    required this.freeDays,
    required this.copyVersion,
    this.firstChargeAt,
    this.mandateExpiresAt,
    this.keptTrialEndsAt,
    this.summary = '',
  });

  final MandateKind kind;

  /// What the UPI app takes at registration: 100 (₹1), or the plan for `paid`.
  final int registrationPaise;

  /// The ₹1 comes back automatically (`trial` / `deferred`).
  final bool registrationRefunded;
  final int monthlyPaise;
  final int maxAmountPaise;

  /// `trial` / `deferred`: the first monthly debit. `paid`: where the month
  /// the registration pays for starts, when later than now; else null.
  final DateTime? firstChargeAt;

  /// `trial` only: whole days until the first debit; else 0.
  final int freeDays;
  final DateTime? mandateExpiresAt;
  final String copyVersion;

  /// A free month kept after AutoPay was stopped (the owner rule of 21 Nov
  /// 2026), past or still running; null otherwise.
  final DateTime? keptTrialEndsAt;

  /// The server's one sentence for this offer.
  final String summary;

  /// A whole offer, or null for the server's explicit "no offer" — never half
  /// of one. Throws [FormatException] on anything malformed: a missing
  /// `firstChargeAt` would be a first payment "on Invalid Date", and a missing
  /// amount a checkout for ₹NaN (the web's `usePlanOffer` checks the same
  /// fields).
  static TokenOffer? parse(Object? wire) {
    if (wire == null) return null;
    if (wire is! Map) throw const FormatException('tokenOffer');
    final MandateKind? kind = MandateKind.parse(wire['kind']);
    final int? registration = _count(wire['registrationPaise']);
    final int? monthly = _count(wire['monthlyPaise']);
    final int? max = _count(wire['maxAmountPaise']);
    final int? freeDays = _count(wire['freeDays']);
    final Object? refunded = wire['registrationRefunded'];
    final Object? copyVersion = wire['copyVersion'];
    final (bool, DateTime?) first = _instant(wire['firstChargeAt']);
    final (bool, DateTime?) expires = _instant(wire['mandateExpiresAt']);
    final (bool, DateTime?) kept = _instant(wire['keptTrialEndsAt']);
    if (kind == null ||
        registration == null ||
        monthly == null ||
        max == null ||
        freeDays == null ||
        refunded is! bool ||
        copyVersion is! String ||
        !first.$1 ||
        !expires.$1 ||
        !kept.$1) {
      throw const FormatException('tokenOffer');
    }
    final Object? summary = wire['summary'];
    return TokenOffer(
      kind: kind,
      registrationPaise: registration,
      registrationRefunded: refunded,
      monthlyPaise: monthly,
      maxAmountPaise: max,
      freeDays: freeDays,
      copyVersion: copyVersion,
      firstChargeAt: first.$2,
      mandateExpiresAt: expires.$2,
      keptTrialEndsAt: kept.$2,
      summary: summary is String ? summary : '',
    );
  }

  static int? _count(Object? v) =>
      v is num && v.isFinite && v >= 0 && v == v.roundToDouble()
      ? v.toInt()
      : null;

  /// (valid, value): null and absent are valid and mean "none".
  static (bool, DateTime?) _instant(Object? v) {
    if (v == null) return (true, null);
    if (v is! String) return (false, null);
    final DateTime? at = DateTime.tryParse(v);
    return (at != null, at);
  }
}

/// `GET /payment/config` — the UPI AutoPay answer (TOKEN_AUTOPAY_SPEC.md §4.1):
///
///     { indiaAutopay: false, intlAutopay: false, indiaTokenAutopay,
///       tokenOffer: {…} | null, tokenOfferUnavailable?: true }
///
/// [indiaAutopay] / [intlAutopay] belong to Razorpay Subscriptions, which are
/// off for good. The server keeps them, always false, for SHIPPED builds
/// (which read nothing else and so sell the 30-day pass). They are parsed and
/// never decide anything here — [PlanOffer.decide] reads only the token
/// fields.
class PaymentConfig {
  const PaymentConfig({
    this.indiaAutopay = false,
    this.intlAutopay = false,
    this.indiaTokenAutopay = false,
    this.tokenOffer,
    this.tokenOfferUnavailable = false,
  });

  factory PaymentConfig.fromJson(Map<String, dynamic> json) {
    TokenOffer? offer;
    bool unavailable = json['tokenOfferUnavailable'] == true;
    try {
      // An absent key is a server older than the token rail: no offer, so
      // the pass — exactly what this build sold before it. Half an offer is
      // not that: it is "could not work it out", a retry.
      offer = TokenOffer.parse(json['tokenOffer']);
    } on FormatException {
      unavailable = true;
    }
    return PaymentConfig(
      indiaAutopay: json['indiaAutopay'] == true,
      intlAutopay: json['intlAutopay'] == true,
      indiaTokenAutopay: json['indiaTokenAutopay'] == true,
      tokenOffer: unavailable ? null : offer,
      tokenOfferUnavailable: unavailable,
    );
  }

  /// Legacy (Razorpay Subscriptions). Never read by [PlanOffer.decide].
  final bool indiaAutopay;

  /// Legacy (Razorpay Subscriptions). Never read by [PlanOffer.decide].
  final bool intlAutopay;

  /// New India registrations are open (the admin switch AND the server's
  /// code gate). Informational: the offer itself is what decides.
  final bool indiaTokenAutopay;

  /// This user's registration, or null: no autopay for them, so the pass.
  final TokenOffer? tokenOffer;

  /// The offer could not be worked out just now. Never the pass — someone
  /// owed a free month would be charged ₹399 for nothing. A retry.
  final bool tokenOfferUnavailable;
}

/// What the plan step and the Pricing screen offer — the web's `PlanOffer`
/// (`lib/plan-offer.ts`), decided before anything is shown.
///
/// UPI AutoPay where the server quoted it (India, personal), a 30-day pass
/// everywhere else. The kinds of registration and the words for each are the
/// web's; `autopay_copy.dart` holds the sentences.
class PlanOffer {
  const PlanOffer({
    required this.planType,
    required this.countryCode,
    required this.isIndia,
    required this.recurring,
    required this.price,
    required this.symbol,
    this.kind,
    this.freeDays = 0,
    this.firstChargeAt,
    this.registrationRupees = 0,
    this.registrationRefunded = false,
    this.maxRupees = 0,
    this.keptTrialEndsAt,
    this.copyVersion,
    this.summary,
  });

  /// `recurring = India && personal && tokenOffer != null` — the one rule
  /// (TOKEN_AUTOPAY_SPEC.md §4.1). Company always gets the pass (a ₹399
  /// mandate cannot debit ₹1,199), and outside India there is no autopay, so
  /// no free month either.
  ///
  /// Returns NULL when India's personal offer could not be worked out
  /// (`tokenOfferUnavailable`): the caller shows a retry, never the pass.
  ///
  /// [upiAutopayOnDevice] false (a platform that cannot register UPI AutoPay,
  /// see `upiAutopayOnDeviceProvider`) ignores the offer and sells the pass —
  /// the same as the rail being dark.
  ///
  /// [planType] follows the brand: the Company plan is closed to new signups,
  /// and the server refuses a plan that disagrees with `brandType` anyway.
  static PlanOffer? decide({
    required PlanPricing pricing,
    required PaymentConfig config,
    required String planType,
    bool upiAutopayOnDevice = true,
  }) {
    if (pricing.isIndia && planType == 'personal' && upiAutopayOnDevice) {
      if (config.tokenOfferUnavailable) return null;
      final TokenOffer? t = config.tokenOffer;
      if (t != null) {
        return PlanOffer(
          planType: planType,
          countryCode: pricing.countryCode,
          isIndia: true,
          recurring: true,
          // Amounts are the server's, never a constant here.
          price: t.monthlyPaise / 100,
          symbol: '₹',
          kind: t.kind,
          freeDays: t.freeDays,
          firstChargeAt: t.firstChargeAt,
          registrationRupees: t.registrationPaise / 100,
          registrationRefunded: t.registrationRefunded,
          maxRupees: t.maxAmountPaise / 100,
          keptTrialEndsAt: t.keptTrialEndsAt,
          copyVersion: t.copyVersion,
          summary: t.summary,
        );
      }
    }
    return PlanOffer(
      planType: planType,
      countryCode: pricing.countryCode,
      isIndia: pricing.isIndia,
      recurring: false,
      price: pricing.priceFor(planType),
      symbol: pricing.symbol,
    );
  }

  /// `'personal'` | `'company'`.
  final String planType;

  /// Sent back with the checkout. The server prices from it and refuses an
  /// absent one — an absent country is how every international signup was
  /// once created as an India subscription, silently.
  final String countryCode;
  final bool isIndia;

  /// A UPI AutoPay registration (true) or a one-time 30-day pass (false).
  final bool recurring;

  /// The monthly plan when [recurring]; the pass itself when not. In major
  /// units (rupees, dollars).
  final num price;
  final String symbol;

  // ── UPI AutoPay only (null / zero on the pass) ──

  final MandateKind? kind;

  /// `trial` only: whole days until the first debit; else 0.
  final int freeDays;

  /// `trial` / `deferred`: the first monthly debit. `paid`: where the month
  /// the registration pays for starts when that is later than now; else null.
  final DateTime? firstChargeAt;

  /// What the UPI app takes at registration, in rupees: 1, or the plan for
  /// `paid`.
  final num registrationRupees;

  /// The ₹1 comes back automatically (`trial` / `deferred`).
  final bool registrationRefunded;

  /// The most any one debit may take, in rupees.
  final num maxRupees;

  /// A free month kept after AutoPay was stopped; else null.
  final DateTime? keptTrialEndsAt;
  final String? copyVersion;

  /// The server's one sentence for the offer.
  final String? summary;

  /// `₹399`, `$10`.
  String get priceLabel => '$symbol${inr(price)}';
}

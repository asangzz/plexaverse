import 'package:freezed_annotation/freezed_annotation.dart';

part 'pricing.freezed.dart';
part 'pricing.g.dart';

/// Localised plan pricing — the payload of `GET /geo/pricing`.
///
/// The web reads the same route and calls the type `GeoPricing`. This slice
/// keeps its own copy rather than importing the Settings slice's: Settings
/// models the two numbers its billing ROW needs, and a feature reaching into a
/// sibling feature's `domain/` is the coupling the slice layout exists to
/// prevent. The shared model that would justify one copy is `preferences/`,
/// which is domain-only by design; pricing is not that.
///
/// The country is decided by the DEVICE LOCALE, not by an IP lookup — the
/// mobile route takes `?country=` precisely so the client can answer that
/// question itself, and an IP guess on a phone is wrong as often as it is
/// right (roaming, VPN, carrier egress abroad).
@freezed
abstract class PlanPricing with _$PlanPricing {
  const PlanPricing._();

  const factory PlanPricing({
    @Default('IN') String countryCode,
    @Default('India') String countryName,
    @Default('INR') String currency,
    @Default('₹') String symbol,
    @Default(0) int personalPrice,
    @Default(0) int companyPrice,
    @Default(true) bool isIndia,

    /// How many minor units make one major unit. Razorpay charges in paise /
    /// cents, so the checkout amount is `price * subunitMultiplier`.
    @Default(100) int subunitMultiplier,
  }) = _PlanPricing;

  factory PlanPricing.fromJson(Map<String, dynamic> json) =>
      _$PlanPricingFromJson(json);

  /// The price of one catalogue plan in this country.
  int priceFor(String planId) =>
      planId == PricingPlan.company.id ? companyPrice : personalPrice;

  /// The tax line under the price. India's figure is inclusive; every other
  /// country's is not, and saying which is the difference between a correct
  /// price and a surprise at checkout.
  String get taxNote => isIndia ? 'incl. 18% GST' : '18% GST excluded';

  /// The ISO country code as a flag emoji, the way the web's `countryFlag()`
  /// builds it: each letter offset into the regional-indicator block.
  String get flag => countryCode
      .toUpperCase()
      .codeUnits
      .map((int c) => String.fromCharCode(0x1F1E6 - 65 + c))
      .join();
}

/// Referral state — `GET /referral`.
///
/// Not `json_serializable`: the wire shape nests the counters under `stats`
/// (and carries a `recentReferrals` array this screen does not render), so the
/// mapping is written out in [fromWire] rather than bent into annotations.
@freezed
abstract class ReferralSummary with _$ReferralSummary {
  const ReferralSummary._();

  const factory ReferralSummary({
    /// Null until the user generates one. That is the empty state, not an
    /// error.
    String? code,
    @Default(0) int totalReferrals,
    @Default(0) int totalXpEarned,
  }) = _ReferralSummary;

  static ReferralSummary fromWire(Map<String, dynamic> json) {
    final Object? stats = json['stats'];
    final Map<String, dynamic> s = stats is Map<String, dynamic>
        ? stats
        : const <String, dynamic>{};
    return ReferralSummary(
      code: json['code'] as String?,
      totalReferrals: (s['totalReferrals'] as num?)?.toInt() ?? 0,
      // The server spells this one with a capital XP.
      totalXpEarned: (s['totalXPEarned'] as num?)?.toInt() ?? 0,
    );
  }

  bool get hasCode => code != null && code!.isNotEmpty;
}

/// One plan in the catalogue.
///
/// The plans themselves are **static content**, exactly as on the web: the
/// `PLANS` array in `app/(dashboard)/pricing/page.tsx` is hard-coded and only
/// the PRICE comes from the server. Copy is reproduced verbatim so the two
/// surfaces cannot quietly disagree about what a plan includes.
///
/// The web's per-plan `theme` block (accent hex, glow, gradient button) is
/// deliberately NOT ported. Zave's first rule is that colour only ever names a
/// status, so a plan does not get a house colour; both cards are ordinary glass
/// and the only colour on them is amber for XP (points) on the XP badge and
/// blue on the CTA (the XP / upgrade path, which is the one thing
/// [ZaveColors.blue] is reserved for).
class PricingPlan {
  const PricingPlan._({
    required this.id,
    required this.label,
    required this.tagline,
    required this.xp,
    required this.popular,
    required this.badge,
    required this.features,
    required this.lockedFeatures,
    required this.comparator,
  });

  /// `'personal'` | `'company'` — the same values `UserPreferences.brandType`
  /// carries, which is what lets the screen show only the plan the user's
  /// account type can actually buy.
  final String id;
  final String label;
  final String tagline;
  final int xp;
  final bool popular;

  /// `'Most Advanced'` on the company plan, null on personal.
  final String? badge;

  final List<String> features;

  /// Rendered struck-through and dimmed: what this plan does NOT include.
  final List<String> lockedFeatures;

  /// The competitor anchor line. Shown only in India — it is an INR
  /// comparison, and quoting rupees at someone paying in dollars is noise.
  final String? comparator;

  /// The separator row inside [features]. The web renders this one entry as a
  /// kicker rather than a ticked line; matching on the string is how it does
  /// it, and re-deriving it here keeps the arrays byte-identical.
  static const String inheritanceRow = 'Everything in Personal, plus:';

  static const PricingPlan personal = PricingPlan._(
    id: 'personal',
    label: 'PERSONAL',
    tagline: 'For professionals & thought leaders',
    xp: 11000,
    popular: false,
    badge: null,
    features: <String>[
      '11,000 XP — No expiry',
      'Daily AI Post + Image generation',
      'AI comment drafts (15/day)',
      'AI connection messages (10/day)',
      '66-Day Gamified Roadmap',
      'AI Profile Optimizer',
      'Post Analytics Dashboard',
      'Smart post scheduling & calendar',
    ],
    lockedFeatures: <String>[
      'Community Inbox',
      'Company Page Analytics',
      'Company Post AI Generator',
    ],
    comparator: null,
  );

  static const PricingPlan company = PricingPlan._(
    id: 'company',
    label: 'COMPANY',
    tagline: 'For brands & marketing teams',
    xp: 11000,
    popular: true,
    badge: 'Most Advanced',
    features: <String>[
      '11,000 XP — No expiry',
      inheritanceRow,
      'Company Post AI Generator',
      'Community Inbox (AI comment replies)',
      'Company Page Analytics',
      'Priority Support — 24h response',
    ],
    lockedFeatures: <String>[],
    comparator: 'Taplio Pro: ₹16,600/mo · Shield: ₹2,080/mo',
  );

  static const List<PricingPlan> all = <PricingPlan>[personal, company];

  /// The plans a user with this `brandType` can buy.
  ///
  /// Null brandType returns both — that is the web's own behaviour while
  /// preferences are still loading, not a mobile invention.
  static List<PricingPlan> forBrand(String? brandType) => brandType == null
      ? all
      : all.where((PricingPlan p) => p.id == brandType).toList(growable: false);
}

/// One row of the "Daily XP Budget" table.
///
/// Static content on the web too. The emoji are dropped: Zave names things with
/// Manrope, not with pictograms, and the numbers are the point of this block.
class XpBudgetItem {
  const XpBudgetItem({
    required this.task,
    required this.cost,
    required this.note,
  });

  final String task;
  final int cost;
  final String note;

  static const List<XpBudgetItem> all = <XpBudgetItem>[
    XpBudgetItem(task: 'AI Post', cost: 150, note: 'Text + image'),
    XpBudgetItem(task: 'Comments', cost: 75, note: '15 drafted'),
    XpBudgetItem(task: 'Connections', cost: 60, note: '10 messages'),
    XpBudgetItem(task: 'Extra Step', cost: 100, note: 'Varies per task'),
  ];
}

/// The free welcome grant, credited the first time a LinkedIn account is
/// connected. `REGISTRATION_XP` in the web's `lib/xp-constants.ts`.
const int kWelcomeXp = 2500;

/// The referral bonus both sides receive.
const int kReferralXp = 2500;

/// `11000` → `11,000`.
///
/// The web leans on `Number.toLocaleString()`. `intl`'s `NumberFormat` would
/// localise the SEPARATOR as well, which would make these figures disagree with
/// the server-rendered ones elsewhere in the product — so the grouping is done
/// by hand, in the one style the whole app uses.
String groupedNumber(int value) {
  final String digits = value.abs().toString();
  final StringBuffer out = StringBuffer(value < 0 ? '-' : '');
  for (int i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) out.write(',');
    out.write(digits[i]);
  }
  return out.toString();
}

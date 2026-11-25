/// The consistency reward (owner, 25 Nov 2026; CONSISTENCY_BILLING.md): an
/// opt-in for India UPI AutoPay members. With "Use my consistency to set my
/// monthly price" on, the monthly debit is priced from the learner's own
/// consistency, never below ₹1 and never above the plan price, fixed 72h
/// before each debit.
///
/// BILLING COPY, NOT GAME COPY. Nothing in or near a price says XP, level,
/// streak, points, score, game, play, win or prize — a run of days is "days
/// in a row" (test/features/pricing/consistency_reward_test.dart scans it).
///
/// THE WORDS ARE THE SERVER'S. The headline, the switch's label, the why and
/// the conditions are sent by `GET /billing/consistency-reward` and shown
/// verbatim: they are the words the consent is recorded under, so the app
/// carries no copy of them that could drift. Only the lines that state a
/// figure or a date (the next debit, the estimate) are built here, word for
/// word with the web's `lib/consistency-reward-copy.ts`.
///
/// Every reader here is tolerant: a malformed field is absent, and an absent
/// or non-live reward shows nothing about a discount.
library;

import 'autopay_copy.dart' show istDay, rupeesFromPaise;

/// The consent purpose the switch records (`consistency_pricing`).
const String kConsistencyPricingPurpose = 'consistency_pricing';

/// The consent list's line for the purpose while it is off and the reward is
/// offered here — granted only beside the reward it explains. The web's
/// `REWARD_GRANT_IN_CONTEXT_LINE`.
const String kRewardGrantInContextLine =
    'Turn this on in Settings → Billing, where the consistency reward is '
    'explained. You can switch it off here at any time.';

/// The consent list's line when there is no switch to send them to (no live
/// UPI AutoPay mandate, or the reward is not on). The web's
/// `REWARD_NOT_OFFERED_LINE`.
const String kRewardNotOfferedLine =
    'Available to members on UPI AutoPay in India when the consistency reward '
    'is on. You can switch it off here at any time.';

DateTime? _instant(Object? v) => v is String ? DateTime.tryParse(v) : null;

int? _int(Object? v) => v is num && v.isFinite ? v.toInt() : null;

String? _string(Object? v) => v is String && v.isNotEmpty ? v : null;

/// `consistencyReward` on `GET /autopay/status`: whether the reward applies to
/// this account now (`live`), the switch as the server has it, and — once the
/// coming debit is priced — how it was priced and the one-line breakdown.
class ConsistencyRewardStatus {
  const ConsistencyRewardStatus({
    required this.live,
    this.consented = false,
    this.staleConsent = false,
    this.minDays = 0,
    this.thresholdPct,
    this.pricing,
    this.breakdown,
  });

  /// Null for anything that is not an object with a boolean `live`.
  static ConsistencyRewardStatus? tryParse(Object? raw) {
    if (raw is! Map) return null;
    final Object? live = raw['live'];
    if (live is! bool) return null;
    final Object? pricing = raw['pricing'];
    return ConsistencyRewardStatus(
      live: live,
      consented: raw['consented'] == true,
      staleConsent: raw['staleConsent'] == true,
      minDays: _int(raw['minDays']) ?? 0,
      thresholdPct: _int(raw['thresholdPct']),
      pricing: pricing == 'consistency' || pricing == 'base'
          ? pricing as String
          : null,
      breakdown: _string(raw['breakdown']),
    );
  }

  /// The reward applies to the account now (mode `on`, or `shadow` for a test
  /// account). When false, nothing about a discount is shown.
  final bool live;
  final bool consented;

  /// A yes given under words that have since changed: it does not count.
  final bool staleConsent;

  /// The fewest counted days a month needs before it can lower the price.
  final int minDays;
  final int? thresholdPct;

  /// `consistency` | `base` once the coming debit is priced, else null.
  final String? pricing;

  /// The one-line breakdown of a fixed price.
  final String? breakdown;
}

/// A fixed price on the consistency card's `price`.
class FixedDebitPrice {
  const FixedDebitPrice({
    required this.amountPaise,
    this.basePaise,
    this.breakdown,
  });

  final int amountPaise;
  final int? basePaise;
  final String? breakdown;
}

/// An estimate before the fix — always labelled one where it is shown.
class EstimatedDebitPrice {
  const EstimatedDebitPrice({
    required this.amountPaise,
    this.basePaise,
    this.reason = '',
    this.countedDays = 0,
  });

  final int amountPaise;
  final int? basePaise;

  /// Why the estimate is what it is — `min_days` means too few days counted.
  final String reason;
  final int countedDays;
}

/// `price` on `GET /contest/consistency` (additive, 25 Nov 2026): the coming
/// debit's fixed price, or a live estimate before it is fixed.
class ConsistencyPrice {
  const ConsistencyPrice({
    required this.live,
    this.consented = false,
    this.staleConsent = false,
    this.minDays = 0,
    this.nextDebitAt,
    this.fixesAt,
    this.fixed,
    this.estimate,
    this.fixing = false,
  });

  /// Null for anything that is not an object with a boolean `live`.
  static ConsistencyPrice? tryParse(Object? raw) {
    if (raw is! Map) return null;
    final Object? live = raw['live'];
    if (live is! bool) return null;
    final Object? f = raw['fixed'];
    final Object? e = raw['estimate'];
    final int? fixedPaise = f is Map ? _int(f['amountPaise']) : null;
    final int? estimatePaise = e is Map ? _int(e['amountPaise']) : null;
    return ConsistencyPrice(
      live: live,
      consented: raw['consented'] == true,
      staleConsent: raw['staleConsent'] == true,
      minDays: _int(raw['minDays']) ?? 0,
      nextDebitAt: _instant(raw['nextDebitAt']),
      fixesAt: _instant(raw['fixesAt']),
      fixed: f is Map && fixedPaise != null
          ? FixedDebitPrice(
              amountPaise: fixedPaise,
              basePaise: _int(f['basePaise']),
              breakdown: _string(f['breakdown']),
            )
          : null,
      estimate: e is Map && estimatePaise != null
          ? EstimatedDebitPrice(
              amountPaise: estimatePaise,
              basePaise: _int(e['basePaise']),
              reason: _string(e['reason']) ?? '',
              countedDays: _int(e['countedDays']) ?? 0,
            )
          : null,
      fixing: raw['fixing'] == true,
    );
  }

  final bool live;
  final bool consented;
  final bool staleConsent;
  final int minDays;

  /// The coming debit's date (its period start).
  final DateTime? nextDebitAt;

  /// When its price is (or was) fixed: 72h before it.
  final DateTime? fixesAt;
  final FixedDebitPrice? fixed;
  final EstimatedDebitPrice? estimate;

  /// Past the fix instant and not fixed yet (the server is retrying): no
  /// figure is shown.
  final bool fixing;
}

/// Where the section is drawn — a save's error is shown only where the tap
/// happened.
enum RewardSurface { billing, card }

/// The words shown beside the switch — the server's, verbatim.
class ConsistencyRewardWords {
  const ConsistencyRewardWords({
    required this.headline,
    required this.label,
    required this.consentText,
    required this.why,
    required this.conditions,
    required this.appliesFromNextLine,
  });

  /// Null unless every word the switch needs is there: the yes is only as good
  /// as the words it was given to, so the switch is never drawn half-worded.
  static ConsistencyRewardWords? tryParse(Object? raw) {
    if (raw is! Map) return null;
    final String? headline = _string(raw['headline']);
    final String? label = _string(raw['label']);
    final String? why = _string(raw['why']);
    final Object? list = raw['conditions'];
    if (headline == null || label == null || why == null || list is! List) {
      return null;
    }
    return ConsistencyRewardWords(
      headline: headline,
      label: label,
      consentText: _string(raw['consentText']) ?? '',
      why: why,
      conditions: <String>[
        for (final Object? c in list)
          if (_string(c) case final String s) s,
      ],
      appliesFromNextLine: _string(raw['appliesFromNextLine']) ?? '',
    );
  }

  final String headline;
  final String label;
  final String consentText;
  final String why;
  final List<String> conditions;

  /// Under the switch once the coming debit is priced: a yes now counts from
  /// the debit after it.
  final String appliesFromNextLine;
}

/// `GET /billing/consistency-reward` (and every `PUT`'s answer).
class ConsistencyRewardConsent {
  const ConsistencyRewardConsent({
    required this.consented,
    required this.staleConsent,
    required this.wordsVersion,
    required this.words,
  });

  /// Throws [FormatException] on a body the switch cannot be drawn from.
  factory ConsistencyRewardConsent.fromJson(Map<String, dynamic> json) {
    final ConsistencyRewardWords? words = ConsistencyRewardWords.tryParse(
      json['words'],
    );
    final String? version = _string(json['wordsVersion']);
    final Object? consented = json['consented'];
    if (words == null || version == null || consented is! bool) {
      throw const FormatException('consistency reward: incomplete body');
    }
    return ConsistencyRewardConsent(
      consented: consented,
      staleConsent: json['staleConsent'] == true,
      wordsVersion: version,
      words: words,
    );
  }

  /// "Use my consistency to set my monthly price" is on (a current yes).
  final bool consented;

  /// An earlier yes under words that have since changed: shown off, offered
  /// again.
  final bool staleConsent;

  /// The notice date of [words] — sent back with a yes, so the yes is
  /// recorded under exactly the words shown.
  final String wordsVersion;
  final ConsistencyRewardWords words;
}

/// A yes refused because the words changed (409 UPDATE_REQUIRED): show
/// [message], then read the words again.
class ConsistencyRewardUpdateRequired implements Exception {
  const ConsistencyRewardUpdateRequired(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Any other refusal of the switch, with the sentence to show.
class ConsistencyRewardFailure implements Exception {
  const ConsistencyRewardFailure([this.message = kRewardSaveFailed]);

  final String message;

  @override
  String toString() => message;
}

/// The web's fallback when a save fails with no sentence of its own.
const String kRewardSaveFailed =
    'We could not save that just now. Try again.';

// ─── The debit line ──────────────────────────────────────────────────────────

/// `nextDebitLine`: "Next debit: ₹80 on 25 Dec" — once the price is fixed.
String nextDebitLine(int paise, DateTime at) =>
    'Next debit: ${rupeesFromPaise(paise)} on ${istDay(at)}';

/// `estimateLine`: "Next debit: about ₹80 on 25 Dec (estimate)".
String estimateLine(int paise, DateTime at) =>
    'Next debit: about ${rupeesFromPaise(paise)} on ${istDay(at)} (estimate)';

/// `ESTIMATE_NOTE`, under an estimate.
const String kEstimateNote =
    'An estimate from your consistency so far. The price is fixed 3 days '
    'before the debit.';

/// Under the switch when an earlier yes was given to words since changed.
const String kStaleConsentLine =
    'We changed what this means, so your earlier yes no longer counts. Read it '
    'again below.';

/// "Switch it on before 22 Dec for your next debit." — before the price is
/// fixed, when the switch is off.
String switchOnBeforeLine(DateTime fixesAt) =>
    'Switch it on before ${istDay(fixesAt)} for your next debit.';

/// The line (and the note under it) the section states about the coming
/// debit, or null when it states none. The web's `ConsistencyRewardSection`:
///
///   fixed            "Next debit: ₹X on 25 Dec", the breakdown under it
///   estimate         only with the switch on: "Next debit: about ₹X on
///                    25 Dec (estimate)", and when it becomes the price
///   fixing           "Next debit on 25 Dec — its price is being fixed." —
///                    no figure while the server is still fixing it
class RewardDebit {
  const RewardDebit({required this.line, this.note});

  final String line;
  final String? note;

  ///
  /// [consented] is the switch as drawn; [estimateConsented] the consent the
  /// estimate was computed under (the meter's own `price.consented`). Both
  /// must hold: the two are read separately, and an estimate made with the
  /// switch off is the plan price, never "an estimate from your consistency".
  static RewardDebit? of({
    required DateTime? nextDebitAt,
    required FixedDebitPrice? fixed,
    required EstimatedDebitPrice? estimate,
    required bool consented,
    required bool fixing,
    required int minDays,
    bool? estimateConsented,
  }) {
    final DateTime? at = nextDebitAt;
    if (at == null) return null;
    if (fixed != null) {
      return RewardDebit(
        line: nextDebitLine(fixed.amountPaise, at),
        note: fixed.breakdown,
      );
    }
    if (fixing) {
      return RewardDebit(
        line: 'Next debit on ${istDay(at)} — its price is being fixed.',
      );
    }
    if (estimate != null &&
        consented &&
        estimateConsented != false &&
        estimate.reason != 'no_consent') {
      final String days = estimate.reason == 'min_days'
          ? ' So far ${estimate.countedDays} of the $minDays days a reward '
                'needs are counted.'
          : '';
      return RewardDebit(
        line: estimateLine(estimate.amountPaise, at),
        note: '$kEstimateNote$days',
      );
    }
    return null;
  }
}

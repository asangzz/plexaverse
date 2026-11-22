import 'plan_offer.dart';

// The sentences about UPI AutoPay — the web's `lib/plan-offer.ts`, word for
// word, so the app and the web say the same thing about money
// (TOKEN_AUTOPAY_SPEC.md §4.4). Change both together, and bump
// [kAutopayCheckoutCopyVersion] with them when the checkout copy changes.
//
// None says "cancel any time" (test/features/pricing/no_cancel_promise_test):
// the control is Stop autopay. None says "nothing is charged": the
// registration takes ₹1 (or ₹399) on the spot. Every amount comes from the
// server's offer, status or order — never a constant here.

/// `16 Dec`, in India time — the date format every autopay sentence uses.
///
/// The web's `toLocaleDateString('en-IN', {day: 'numeric', month: 'short',
/// timeZone: 'Asia/Kolkata'})`, which spells September "Sept". India has no
/// daylight saving, so IST is a fixed +05:30.
String istDay(DateTime when) {
  final DateTime ist = when.toUtc().add(const Duration(hours: 5, minutes: 30));
  return '${ist.day} ${_months[ist.month - 1]}';
}

const List<String> _months = <String>[
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sept',
  'Oct',
  'Nov',
  'Dec',
];

/// `399`, `1,199`, `1,23,456`, `399.5` — an amount as the web writes it
/// (`toLocaleString('en-IN', {maximumFractionDigits: 2})`): Indian grouping,
/// at most two decimals, no trailing zeros.
String inr(num amount) {
  final int hundredths = (amount * 100).round();
  final bool negative = hundredths < 0;
  final int abs = hundredths.abs();
  final String whole = _indianGrouping((abs ~/ 100).toString());
  final int fraction = abs % 100;
  String out = whole;
  if (fraction != 0) {
    String f = fraction.toString().padLeft(2, '0');
    if (f.endsWith('0')) f = f.substring(0, 1);
    out = '$out.$f';
  }
  return negative ? '-$out' : out;
}

String _indianGrouping(String digits) {
  if (digits.length <= 3) return digits;
  final String last3 = digits.substring(digits.length - 3);
  String rest = digits.substring(0, digits.length - 3);
  final List<String> pairs = <String>[];
  while (rest.length > 2) {
    pairs.insert(0, rest.substring(rest.length - 2));
    rest = rest.substring(0, rest.length - 2);
  }
  if (rest.isNotEmpty) pairs.insert(0, rest);
  return '${pairs.join(',')},$last3';
}

/// `₹399` from paise.
String rupeesFromPaise(int paise) => '₹${inr(paise / 100)}';

const String _stopLine =
    'You can stop autopay at any time in Settings → Billing or in your UPI app.';
const String _noticeLine = 'with a notice before each payment.';

bool _isFuture(DateTime? at, DateTime now) => at != null && at.isAfter(now);

/// The free month a stopped AutoPay leaves behind (the owner rule of 21 Nov
/// 2026): "AutoPay is off. Your free month ends on … — set up AutoPay with
/// ₹399 to continue." Null when there is none.
String? keptFreeMonthLine(PlanOffer o, {DateTime? now}) {
  final DateTime? kept = o.keptTrialEndsAt;
  if (!o.recurring || kept == null) return null;
  final String verb = _isFuture(kept, now ?? DateTime.now()) ? 'ends' : 'ended';
  return 'AutoPay is off. Your free month $verb on ${istDay(kept)} — set up '
      'AutoPay with ₹${inr(o.price)} to continue.';
}

/// What the plan costs and when, under the price: the terms of the mandate,
/// how to stop it, and — in the free month — what a stop does (the owner rule
/// of 21 Nov 2026: the rest of the month is kept and nothing is taken).
String autopayTerms(PlanOffer o, {DateTime? now}) {
  final String price = '₹${inr(o.price)}';
  switch (o.kind) {
    case MandateKind.trial:
      return 'Then $price a month by UPI Autopay, $_noticeLine $_stopLine If '
          'you stop it during your free month, you keep the rest of the month '
          'and no payment is taken.';
    case MandateKind.deferred:
      final DateTime? first = o.firstChargeAt;
      final String until = first != null
          ? 'Your current plan runs until ${istDay(first)}. '
          : '';
      return '${until}Then $price a month by UPI Autopay, $_noticeLine '
          '$_stopLine';
    case MandateKind.paid:
    case null:
      final String today = '₹${inr(o.registrationRupees)} today';
      final DateTime? first = o.firstChargeAt;
      final String from = _isFuture(first, now ?? DateTime.now())
          ? ' pays for a month from ${istDay(first!)}'
          : '';
      return '$today$from, then $price a month by UPI Autopay, $_noticeLine '
          '$_stopLine';
  }
}

/// The registration payment, said out loud (D5): the ₹1 the UPI app takes
/// now, whether it comes back, the mandate's ceiling and the first debit. Null
/// for `paid`, whose ₹399 is the plan itself and is already in the terms.
///
/// A KEPT ₹1 IS SAID TO BE KEPT, nothing more: no debit is reduced by it, so
/// "it counts towards your plan" would promise a credit no code gives.
String? registrationLine(PlanOffer o) {
  if (!o.recurring || o.kind == MandateKind.paid) return null;
  final String now = '₹${inr(o.registrationRupees)}';
  final String back = o.registrationRefunded
      ? 'To set up autopay your UPI app takes $now now, and we refund it '
            'automatically.'
      : 'To set up autopay your UPI app takes $now now, which is not refunded.';
  final DateTime? first = o.firstChargeAt;
  final String firstPayment = first != null
      ? ', and your first payment of ₹${inr(o.price)} is on ${istDay(first)}'
      : '';
  return '$back You approve payments of up to ₹${inr(o.maxRupees)} a '
      'month$firstPayment.';
}

/// The big figure and its caption ("Free" + "for {freeDays} days", and the
/// other kinds).
({String figure, String caption}) autopayHeadline(PlanOffer o) {
  final String price = '₹${inr(o.price)}';
  final DateTime? first = o.firstChargeAt;
  switch (o.kind) {
    case MandateKind.trial:
      if (o.registrationRefunded) {
        return (figure: 'Free', caption: 'for ${o.freeDays} days');
      }
      final String from = first != null ? ' from ${istDay(first)}' : '';
      return (
        figure: '₹${inr(o.registrationRupees)} today',
        caption: 'then $price a month$from',
      );
    case MandateKind.deferred:
      return (
        figure: price,
        caption: first != null ? 'a month from ${istDay(first)}' : 'a month',
      );
    case MandateKind.paid:
    case null:
      return (figure: price, caption: 'a month');
  }
}

/// The plan step's button.
String autopayCta(PlanOffer o) {
  if (o.kind == MandateKind.trial && o.registrationRefunded) {
    return 'Start my free month';
  }
  if (o.kind == MandateKind.paid) {
    return 'Set up autopay · ₹${inr(o.registrationRupees)}';
  }
  return 'Set up autopay';
}

/// A Pricing card's pill, the line beside it, the button and the line under
/// it. "Free" only where it is free: a trial whose ₹1 is KEPT costs ₹1, and
/// pairing a kept charge with "free" is exactly what D5 warns about.
({String pill, String line, String cta, String ctaNote}) autopayCardCopy(
  PlanOffer o,
) {
  final String price = '₹${inr(o.price)}';
  final bool free = o.kind == MandateKind.trial && o.registrationRefunded;
  final String registration = '₹${inr(o.registrationRupees)}';
  final DateTime? first = o.firstChargeAt;
  String pill = 'UPI Autopay';
  final String line;
  switch (o.kind) {
    case MandateKind.trial:
      pill = free
          ? 'First ${o.freeDays} days free'
          : 'First ${o.freeDays} days for $registration';
      line =
          'UPI Autopay · $registration today'
          '${o.registrationRefunded ? ', refunded' : ', not refunded'}';
    case MandateKind.deferred:
      line = first != null
          ? 'First payment on ${istDay(first)}'
          : 'First payment when your plan ends';
    case MandateKind.paid:
    case null:
      line = '$registration today';
  }
  String cta = 'Set up autopay · $price/mo';
  if (o.kind == MandateKind.trial) {
    cta = free ? 'Start my free month' : 'Set up autopay';
  }
  return (
    pill: pill,
    line: line,
    cta: cta,
    ctaNote: o.kind == MandateKind.trial && first != null
        ? 'Then $price a month from ${istDay(first)}'
        : 'Then every month',
  );
}

/// What Razorpay's sheet says under "Plexaverse", from the ORDER the server
/// just opened rather than the offer the screen showed — the order is what
/// the UPI app is about to be asked for. Amounts in paise.
String autopayCheckoutDescription({
  required MandateKind? kind,
  required int amountPaise,
  required int monthlyPaise,
  required DateTime? firstChargeAt,
  required bool registrationRefunded,
}) {
  final String monthly = '${rupeesFromPaise(monthlyPaise)} a month';
  if (kind == MandateKind.paid) return 'UPI Autopay: $monthly';
  final String today =
      '${rupeesFromPaise(amountPaise)} today'
      '${registrationRefunded ? ' (refunded)' : ''}';
  return firstChargeAt != null
      ? 'UPI Autopay: $today, $monthly from ${istDay(firstChargeAt)}'
      : 'UPI Autopay: $today, then $monthly';
}

/// What Plexa says on entering the plan step — the web's `planStepLine`.
///
/// Free first, where it is free, and the date of the first payment, so the
/// first debit is never a surprise. It does NOT say "nothing is charged": the
/// UPI app takes ₹1 (refunded), and the panel right under the line says so.
/// Anything else — the pass, a ₹399 registration, a kept ₹1, an offer that
/// could not be worked out — gets no promise about price, only why the ask
/// exists.
String planStepLine(PlanOffer? offer) {
  final DateTime? first = offer?.firstChargeAt;
  if (offer != null &&
      offer.recurring &&
      offer.kind == MandateKind.trial &&
      offer.registrationRefunded &&
      first != null) {
    return 'One thing before I start writing: your first month is free. Set '
        'up UPI autopay now and your first payment is on ${istDay(first)}.';
  }
  return "One thing before I start writing: your plan — it's what pays for "
      'the posts I write and publish for you.';
}

/// How the plan step ended, as far as the thread is concerned.
///
/// [mandatePending]: the UPI app took the registration but the bank has not
/// confirmed the mandate yet. The step still moves on — the webhook or the
/// sync task completes it — and the echo says it is being confirmed.
enum PlanStepOutcome { mandate, mandatePending, pass, already }

/// The user's echoed turn once the plan is settled — what actually happened.
/// On autopay that is a mandate, not a payment (unless the registration was
/// the ₹399 month itself, `kind` not `trial`).
({String text, String badge}) planDoneEcho(
  PlanStepOutcome outcome, {
  MandateKind? kind,
}) => switch (outcome) {
  PlanStepOutcome.mandate => (
    text: 'Autopay set up',
    badge: kind != null && kind != MandateKind.trial
        ? 'Plan active'
        : 'Free month started',
  ),
  PlanStepOutcome.mandatePending => (
    text: 'Autopay requested',
    badge: 'Confirming with your bank',
  ),
  PlanStepOutcome.pass => (text: 'Paid for this month', badge: 'Plan active'),
  PlanStepOutcome.already => (
    text: 'I already have a plan',
    badge: 'Plan active',
  ),
};

/// `/autopay/verify`'s 400 sentences for a payment that set NOTHING up — the
/// web's `AUTOPAY_REGISTRATION_REFUSALS`. The checkout's own fallback ("…it
/// will appear here shortly. There is no need to pay again.") says the
/// opposite, so these must reach the user as they are.
abstract final class AutopayRefusals {
  /// The attempt was voided (a changed quote, another window): refund-only.
  static const String closed =
      'This autopay setup was no longer open, so nothing was set up. The '
      'payment will be refunded in full.';

  /// The captured amount was not the quoted one: refund-only.
  static const String mismatched =
      'The amount paid did not match this autopay setup, so nothing was set '
      'up. It will be refunded in full.';

  /// Razorpay says the payment failed.
  static const String failed =
      'Your UPI app did not complete the payment, so nothing was set up. Try '
      'again.';

  /// Razorpay says the payment was refunded before we recorded it.
  static const String refunded =
      'This payment was refunded, so nothing was set up. Try again.';

  static const Set<String> all = <String>{closed, mismatched, failed, refunded};

  /// Is this verify sentence one for a payment that set nothing up?
  static bool isRefusal(String? sentence) =>
      sentence != null && all.contains(sentence);
}

/// The checkout's sentences — the web's `useAutopayCheckout` constants.
abstract final class AutopayCheckoutCopy {
  /// 409 MANDATE_IN_PROGRESS: another window holds the open registration.
  static const String inProgress =
      'Autopay is being set up in another window. Try again in a minute.';

  /// 400 AUTOPAY_DISABLED, when the server sent no sentence of its own.
  static const String disabled =
      'Autopay is not available right now. You can pay for one month instead.';

  /// The registration may well have gone through — the UPI app took the
  /// payment and only OUR confirmation is missing. So this never says "try
  /// again": a second attempt would be a second payment.
  static const String unconfirmed =
      'We could not confirm your autopay yet. If your UPI app shows it as set '
      'up, it will appear here shortly. There is no need to pay again.';

  /// A registration confirming with the bank, said once the step moves on.
  static const String requested =
      'Autopay requested. We are confirming it with your bank — there is no '
      'need to pay again.';
}

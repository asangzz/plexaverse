import 'plan_offer.dart';

// UPI AutoPay (the token rail) as the app sees it — the bodies of the four
// `/autopay/*` mobile routes (TOKEN_AUTOPAY_SPEC.md §3.3, §3.4, §3.7, §3.11).
// Every amount here is the server's, in paise.

DateTime? _instant(Object? v) => v is String ? DateTime.tryParse(v) : null;

int? _paise(Object? v) => v is num && v.isFinite ? v.toInt() : null;

String? _nonEmpty(Object? v) => v is String && v.isNotEmpty ? v : null;

/// `POST /autopay/create` — the registration ORDER the sheet opens: an order
/// with a customer and `recurring: '1'`, never a Razorpay Subscription.
class MandateIntent {
  const MandateIntent({
    required this.orderId,
    required this.customerId,
    required this.keyId,
    required this.amountPaise,
    required this.currency,
    required this.monthlyPaise,
    required this.maxAmountPaise,
    required this.registrationRefunded,
    this.kind,
    this.firstChargeAt,
    this.freeDays = 0,
  });

  /// THROWS [StateError] on a missing or empty `orderId` or `customerId`.
  ///
  /// Never `?? ''`: a sheet opened on an empty order is an opaque SDK error
  /// at best, and at worst a payment Razorpay cannot tie to the mandate it
  /// was meant to register.
  factory MandateIntent.fromJson(Map<String, dynamic> json) {
    final String? orderId = _nonEmpty(json['orderId']);
    final String? customerId = _nonEmpty(json['customerId']);
    if (orderId == null) throw StateError('autopay/create returned no order');
    if (customerId == null) {
      throw StateError('autopay/create returned no customer');
    }
    return MandateIntent(
      orderId: orderId,
      customerId: customerId,
      keyId: _nonEmpty(json['keyId']),
      amountPaise: _paise(json['amount']) ?? 0,
      currency: _nonEmpty(json['currency']) ?? 'INR',
      monthlyPaise: _paise(json['monthlyAmount']) ?? 0,
      maxAmountPaise: _paise(json['maxAmount']) ?? 0,
      registrationRefunded: json['registrationRefunded'] == true,
      kind: MandateKind.parse(json['kind']),
      firstChargeAt: _instant(json['firstChargeAt']),
      freeDays: _paise(json['freeDays']) ?? 0,
    );
  }

  final String orderId;
  final String customerId;

  /// Absent when Razorpay is not configured — the caller refuses to open a
  /// sheet it cannot identify.
  final String? keyId;

  /// What the registration takes now: 100 (₹1), or the plan for `paid`.
  final int amountPaise;
  final String currency;
  final int monthlyPaise;
  final int maxAmountPaise;
  final bool registrationRefunded;
  final MandateKind? kind;
  final DateTime? firstChargeAt;
  final int freeDays;
}

/// `POST /autopay/verify` — what the server made of the sheet's result.
class MandateVerification {
  const MandateVerification({
    required this.success,
    this.pending = false,
    this.duplicate = false,
    this.kind,
    this.tokenStatus,
    this.firstChargeAt,
  });

  factory MandateVerification.fromJson(Map<String, dynamic> json) =>
      MandateVerification(
        // Only an explicit true. A missing field is not a yes.
        success: json['success'] == true,
        pending: json['pending'] == true,
        duplicate: json['duplicate'] == true,
        kind: MandateKind.parse(json['kind']),
        tokenStatus: json['tokenStatus'] as String?,
        firstChargeAt: _instant(json['firstChargeAt']),
      );

  final bool success;

  /// Still confirming with the bank: show that, never a retry.
  final bool pending;

  /// This payment set up nothing new — a mandate was already live. It is
  /// refunded in full, and the plan is the existing one's.
  final bool duplicate;
  final MandateKind? kind;

  /// `initiated` (the bank has not answered), `confirmed`, …
  final String? tokenStatus;
  final DateTime? firstChargeAt;

  /// The UPI app took the payment and the bank has not confirmed the mandate.
  bool get awaitingBank => pending || tokenStatus == 'initiated';
}

/// `GET /autopay/status` — what Settings → Billing shows (`AutopayStatus` on
/// the server).
class AutopayStatus {
  const AutopayStatus({
    this.rail,
    this.tokenStatus,
    this.canStop = false,
    this.stopped = false,
    this.nextChargeAt,
    this.nextChargeAmountPaise,
    this.monthlyPaise,
    this.accessUntil,
    this.inTrial = false,
    this.trialEndsAt,
    this.debitInFlight = false,
  });

  factory AutopayStatus.fromJson(Map<String, dynamic> json) => AutopayStatus(
    rail: json['rail'] as String?,
    tokenStatus: json['tokenStatus'] as String?,
    canStop: json['canStop'] == true,
    stopped: json['stopped'] == true,
    nextChargeAt: _instant(json['nextChargeAt']),
    nextChargeAmountPaise: _paise(json['nextChargeAmountPaise']),
    monthlyPaise: _paise(json['monthlyPaise']),
    accessUntil: _instant(json['accessUntil']),
    inTrial: json['inTrial'] == true,
    trialEndsAt: _instant(json['trialEndsAt']),
    debitInFlight: json['debitInFlight'] == true,
  );

  /// `'token'` (UPI AutoPay), `'subscription'` (legacy), or null (no row).
  final String? rail;
  final String? tokenStatus;

  /// The mandate can still debit: Stop autopay is offered.
  final bool canStop;

  /// There is a mandate and it is stopped (or being stopped).
  final bool stopped;
  final DateTime? nextChargeAt;

  /// The next period's frozen amount: a test lever's ₹1 or a discounted
  /// debit as readily as the plan. Says what the NEXT payment is, nothing
  /// else.
  final int? nextChargeAmountPaise;

  /// The monthly plan a UPI AutoPay registration is for — what "set up
  /// AutoPay again" costs. Null on a server older than this field, and with
  /// no token row.
  final int? monthlyPaise;

  /// How far the plan runs (paid time, the free month, passes and grants).
  final DateTime? accessUntil;

  /// The free month is running (or kept after a stop) and nothing is paid.
  final bool inTrial;
  final DateTime? trialEndsAt;

  /// A debit already announced to the user's UPI app is in flight.
  final bool debitInFlight;

  /// A UPI AutoPay account: the only kind Settings → Billing speaks about.
  bool get isToken => rail == 'token';

  /// A mandate that can still debit — the plan is running on UPI AutoPay.
  bool get live => isToken && canStop;
}

/// `POST /autopay/stop`. `stopped` always means nothing more will be debited;
/// `revokeConfirmed: false` only means Razorpay has not confirmed yet, and the
/// server keeps retrying.
class StopAutopayResult {
  const StopAutopayResult({
    this.stopped = true,
    this.revokeConfirmed = false,
    this.debitInFlight = false,
    this.alreadyStopped = false,
    this.inTrial = false,
    this.accessUntil,
  });

  factory StopAutopayResult.fromJson(Map<String, dynamic> json) =>
      StopAutopayResult(
        stopped: json['stopped'] == true,
        revokeConfirmed: json['revokeConfirmed'] == true,
        debitInFlight: json['debitInFlight'] == true,
        alreadyStopped: json['alreadyStopped'] == true,
        inTrial: json['inTrial'] == true,
        accessUntil: _instant(json['accessUntil']),
      );

  final bool stopped;
  final bool revokeConfirmed;

  /// A debit Razorpay already announced may still capture; it is refunded in
  /// full if it does.
  final bool debitInFlight;
  final bool alreadyStopped;
  final bool inTrial;
  final DateTime? accessUntil;
}

import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/failure.dart';
import '../../../core/platform/checkout.dart';
import '../data/pricing_repositories.dart';
import '../domain/pricing_repository.dart';

part 'plan_checkout.g.dart';

/// How buying a plan ended.
sealed class PlanCheckoutOutcome {
  const PlanCheckoutOutcome();
}

/// The server accepted the sheet's result.
///
/// For UPI AutoPay that is the MANDATE, and — unless [kind] is `paid` — not a
/// payment: in the free month nothing is debited until the first charge.
/// Anything gating on "has paid" reads the entitlement, not this.
class PlanCheckoutDone extends PlanCheckoutOutcome {
  const PlanCheckoutDone({this.kind});

  /// The registration's kind on the autopay path; null on the pass.
  final MandateKind? kind;
}

/// The UPI app took the registration, and the bank has not confirmed the
/// mandate yet — the token is `initiated`, the payment could not be read
/// yet, or (409 MANDATE_PENDING) a registration was already waiting on the
/// bank. Not a failure and never a retry: a second attempt would be a second
/// payment. The webhook or the server's sync completes it.
class PlanCheckoutPending extends PlanCheckoutOutcome {
  const PlanCheckoutPending();
}

/// The account already has a plan — a live mandate (409 `ALREADY_SUBSCRIBED`,
/// or verify's `duplicate`), or access a pass would overlap. The goal — a
/// plan — is already met, so this is not a failure: onboarding's plan step,
/// which has no skip, moves on instead of showing an error with no way past.
class PlanCheckoutAlreadyActive extends PlanCheckoutOutcome {
  const PlanCheckoutAlreadyActive({this.message});

  /// The server's own sentence, when it sent one.
  final String? message;
}

/// The buyer's GST State is not on record, and this payment is in India: ask
/// it first, then call the same method again. Nothing was opened and nothing
/// was charged.
///
/// Every GST invoice must name the buyer's State, collected "before making
/// any supplies" (Circular 242/36/2024-GST; the web's `useBillingStateGate`).
/// Asked once: after the save the State is on record and the next call goes
/// straight through.
class PlanCheckoutStateNeeded extends PlanCheckoutOutcome {
  const PlanCheckoutStateNeeded({this.suggestedStateCode});

  /// What the picker may start on — the server's reading of the region.
  /// Never saved for them.
  final String? suggestedStateCode;
}

/// The user closed the sheet. How a person says "not now" — no message,
/// because an error for a deliberate choice trains people to ignore errors.
class PlanCheckoutDismissed extends PlanCheckoutOutcome {
  const PlanCheckoutDismissed();
}

class PlanCheckoutFailed extends PlanCheckoutOutcome {
  const PlanCheckoutFailed(this.message, {this.offerStale = false});

  /// One finished sentence, safe to show.
  final String message;

  /// The offer the screen showed is out of date (400 AUTOPAY_DISABLED: it is
  /// the pass now). The caller reads the offer again, so a step with no skip
  /// is never left on a button that can only fail.
  final bool offerStale;
}

/// Buying a plan: ask the State if it is missing, open the registration or
/// the order, open the sheet, verify.
///
/// The web's `useAutopayCheckout` / `useOneTimeCheckout`, and one class for
/// the same reason the web made them one module: the Pricing screen, Settings
/// and the onboarding plan step ask the same question, and hand-written
/// copies of "create → open → verify" drift on which errors they swallow.
///
/// What the sheet returns is a CLAIM. The server checks the signature before
/// anything is activated, so a device that lies gets nothing.
///
/// **The buyer's GST State comes first** — here, so that no payment path can
/// forget it: a payment in India from an account with no State on record
/// answers [PlanCheckoutStateNeeded] before anything is opened, and every
/// caller's switch has to say what it does with that. Never a wall: when the
/// State cannot be read, the payment goes ahead — the server takes it and
/// flags its invoice, because our outage must not cost anyone the plan they
/// are paying for.
class PlanCheckout {
  const PlanCheckout(this._repo, this._sheet);

  final PricingRepository _repo;
  final CheckoutService _sheet;

  static const String _notConfigured =
      'Payments are not set up yet. Try again in a little while.';

  /// Ask the State first? Only for a payment in India (the one charged in
  /// rupees, a domestic supply) whose account has none on record. Read fresh
  /// each time, so a State saved anywhere — another screen, the web — counts
  /// at once.
  Future<PlanCheckoutStateNeeded?> _stateNeeded({required bool inIndia}) async {
    if (!inIndia) return null;
    final BillingState onRecord;
    try {
      onRecord = await _repo.fetchBillingState();
    } on Object {
      // Unreadable: pay. Only a known gap asks.
      return null;
    }
    if (!billingStateNeeded(isIndia: true, stateCode: onRecord.stateCode)) {
      return null;
    }
    return PlanCheckoutStateNeeded(
      suggestedStateCode: onRecord.suggestedStateCode,
    );
  }

  /// Registers UPI AutoPay (TOKEN_AUTOPAY_SPEC.md §3.3-§3.4): POST
  /// `/autopay/create`, open the sheet on that ORDER with its customer and
  /// `recurring: '1'`, then POST `/autopay/verify`.
  ///
  /// [countryCode] must be the region the offer was shown for — the server
  /// enforces India and refuses an absent one.
  ///
  /// The server's refusals, each its own path:
  ///   409 ALREADY_SUBSCRIBED  → [PlanCheckoutAlreadyActive];
  ///   409 MANDATE_PENDING     → [PlanCheckoutPending];
  ///   409 MANDATE_IN_PROGRESS → "set up in another window";
  ///   400 AUTOPAY_DISABLED    → [PlanCheckoutFailed] with the server's
  ///                             sentence and `offerStale`.
  /// And verify's: `duplicate` → already active; `pending` or a token still
  /// `initiated` → pending; a 400 that says the payment set nothing up
  /// ([AutopayRefusals]) is shown as it is; anything else unconfirmed is
  /// [AutopayCheckoutCopy.unconfirmed] ("no need to pay again").
  Future<PlanCheckoutOutcome> registerAutopay({
    required String planType,
    required String countryCode,
    String? email,
  }) async {
    // UPI AutoPay is India-only: the server refuses any other country.
    final PlanCheckoutStateNeeded? ask = await _stateNeeded(inIndia: true);
    if (ask != null) return ask;

    final MandateIntent intent;
    try {
      intent = await _repo.createMandate(
        planType: planType,
        countryCode: countryCode,
        copyVersion: kAutopayCheckoutCopyVersion,
      );
    } on Object catch (e) {
      final String? said = serverMessage(e);
      switch (errorCode(e)) {
        case 'ALREADY_SUBSCRIBED':
          return PlanCheckoutAlreadyActive(message: said);
        case 'MANDATE_PENDING':
          return const PlanCheckoutPending();
        case 'MANDATE_IN_PROGRESS':
          return PlanCheckoutFailed(said ?? AutopayCheckoutCopy.inProgress);
        case 'AUTOPAY_DISABLED':
          return PlanCheckoutFailed(
            said ?? AutopayCheckoutCopy.disabled,
            offerStale: true,
          );
      }
      return PlanCheckoutFailed(said ?? 'Could not start autopay.');
    }

    final String? keyId = intent.keyId;
    // Refuse rather than open a sheet we cannot identify: Razorpay's own
    // error for a missing key is opaque, and this one names the cause.
    if (keyId == null || keyId.isEmpty) {
      return const PlanCheckoutFailed(_notConfigured);
    }

    final CheckoutResult result = await _sheet.open(
      keyId: keyId,
      name: 'Plexaverse',
      // From the ORDER, not the offer: the order is what the UPI app is
      // about to be asked for.
      description: autopayCheckoutDescription(
        kind: intent.kind,
        amountPaise: intent.amountPaise,
        monthlyPaise: intent.monthlyPaise,
        firstChargeAt: intent.firstChargeAt,
        registrationRefunded: intent.registrationRefunded,
      ),
      orderId: intent.orderId,
      customerId: intent.customerId,
      recurring: true,
      email: email,
    );

    switch (result) {
      case CheckoutCancelled():
        return const PlanCheckoutDismissed();
      case CheckoutFailed(:final String? message):
        return PlanCheckoutFailed(
          message ?? 'That did not go through. Try again.',
        );
      case CheckoutPaid(:final String paymentId, :final String? signature):
        if (signature == null) {
          return const PlanCheckoutFailed(AutopayCheckoutCopy.unconfirmed);
        }
        final MandateVerification verified;
        try {
          verified = await _repo.verifyMandate(
            orderId: intent.orderId,
            paymentId: paymentId,
            signature: signature,
          );
        } on Object catch (e) {
          // A payment that set NOTHING up (voided attempt, wrong amount,
          // failed, refunded): the server's own sentence, because the
          // fallback — "it will appear here shortly, no need to pay again"
          // — is the opposite of true there. Anything else unconfirmed (a
          // 5xx, the network, a bad signature) keeps the fallback: the
          // payment may well be recorded yet.
          final String? said = serverMessage(e);
          if (AutopayRefusals.isRefusal(said)) return PlanCheckoutFailed(said!);
          return const PlanCheckoutFailed(AutopayCheckoutCopy.unconfirmed);
        }
        if (!verified.success) {
          return const PlanCheckoutFailed(AutopayCheckoutCopy.unconfirmed);
        }
        if (verified.duplicate) return const PlanCheckoutAlreadyActive();
        if (verified.awaitingBank) return const PlanCheckoutPending();
        return PlanCheckoutDone(kind: verified.kind ?? intent.kind);
    }
  }

  /// One month, paid once — wherever UPI AutoPay is not offered. No mandate,
  /// so nothing recurs and there is no free month.
  Future<PlanCheckoutOutcome> payForMonth({
    required String planType,
    required String countryCode,
    String? email,
  }) async {
    // The pass is priced from this region; only India's is a GST supply
    // to a buyer with a State.
    final PlanCheckoutStateNeeded? ask = await _stateNeeded(
      inIndia: countryCode.trim().toUpperCase() == 'IN',
    );
    if (ask != null) return ask;

    final OrderIntent order;
    try {
      order = await _repo.createOrder(
        planType: planType,
        countryCode: countryCode,
      );
    } on Object catch (e) {
      // A pass would overlap time the account already has (TOKEN_AUTOPAY_SPEC
      // D15): the plan is there, so on a step with no skip this moves on.
      if (errorCode(e) == 'ALREADY_SUBSCRIBED') {
        return PlanCheckoutAlreadyActive(message: serverMessage(e));
      }
      return PlanCheckoutFailed(
        serverMessage(e) ?? 'Could not start the payment.',
      );
    }

    final String? keyId = order.keyId;
    if (keyId == null || keyId.isEmpty) {
      return const PlanCheckoutFailed(_notConfigured);
    }

    final CheckoutResult result = await _sheet.open(
      keyId: keyId,
      name: 'Plexaverse',
      description: 'One month',
      amountInPaise: order.amount,
      orderId: order.orderId,
      email: email,
    );

    // Money DID move on this path — so this says to wait rather than to pay
    // again.
    const String unconfirmed =
        'We could not confirm your payment. If you were charged, it will land '
        'shortly.';

    switch (result) {
      case CheckoutCancelled():
        return const PlanCheckoutDismissed();
      case CheckoutFailed(:final String? message):
        return PlanCheckoutFailed(
          message ?? 'That payment did not go through.',
        );
      case CheckoutPaid(:final String paymentId, :final String? signature):
        if (signature == null) return const PlanCheckoutFailed(unconfirmed);
        try {
          final bool verified = await _repo.verifyOrder(
            orderId: order.orderId,
            paymentId: paymentId,
            signature: signature,
          );
          return verified
              ? const PlanCheckoutDone()
              : const PlanCheckoutFailed(unconfirmed);
        } on Object {
          return const PlanCheckoutFailed(unconfirmed);
        }
    }
  }

  /// The envelope's `error.code`, when the server sent one.
  static String? errorCode(Object e) {
    if (e is! DioException) return null;
    final Object? failure = e.error;
    return failure is Failure ? failure.errorCode : null;
  }

  /// The server's own sentence, when it sent one — the money routes answer
  /// with copy meant to be shown ("Your account is set to the company brand —
  /// please subscribe to the company plan.").
  static String? serverMessage(Object e) {
    if (e is! DioException) return null;
    final Object? failure = e.error;
    if (failure is Failure) {
      final String? message = failure.message;
      if (message != null && message.trim().isNotEmpty) return message.trim();
    }
    return null;
  }
}

@riverpod
PlanCheckout planCheckout(Ref ref) => PlanCheckout(
  ref.watch(pricingRepositoryProvider),
  ref.watch(checkoutProvider),
);

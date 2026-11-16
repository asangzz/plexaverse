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

/// The server accepted the sheet's signature.
///
/// For autopay that is the MANDATE, not a payment: with the free first month
/// the subscription waits, `authenticated`, until the first charge thirty days
/// later. Anything gating on "has paid" reads the entitlement, not this.
class PlanCheckoutDone extends PlanCheckoutOutcome {
  const PlanCheckoutDone();
}

/// The server refused because the account already has a live mandate or is
/// inside its free month (409 `ALREADY_SUBSCRIBED`). The goal — a plan — is
/// already met, so this is not a failure: onboarding's plan step, which has
/// no skip, moves on instead of showing an error with no way past it.
class PlanCheckoutAlreadyActive extends PlanCheckoutOutcome {
  const PlanCheckoutAlreadyActive();
}

/// The user closed the sheet. How a person says "not now" — no message,
/// because an error for a deliberate choice trains people to ignore errors.
class PlanCheckoutDismissed extends PlanCheckoutOutcome {
  const PlanCheckoutDismissed();
}

class PlanCheckoutFailed extends PlanCheckoutOutcome {
  const PlanCheckoutFailed(this.message);

  /// One finished sentence, safe to show.
  final String message;
}

/// Buying a plan: create the mandate or the order, open the sheet, verify.
///
/// The web's `useSubscriptionCheckout` / `useOneTimeCheckout`, and one class
/// for the same reason the web made them one hook: the Pricing screen and the
/// onboarding plan step ask the same question, and two hand-written copies of
/// "create → open → verify" drift on which errors they swallow — with the one
/// on the path a new user actually walks being the one nobody tests.
///
/// What the sheet returns is a CLAIM. The server checks the signature before
/// anything is activated, so a device that lies gets nothing.
class PlanCheckout {
  const PlanCheckout(this._repo, this._sheet);

  final PricingRepository _repo;
  final CheckoutService _sheet;

  static const String _notConfigured =
      'Payments are not set up yet. Try again in a little while.';

  /// The autopay mandate. [countryCode] must be the region the price was
  /// shown for — the server prices from it and defaults to India without it.
  Future<PlanCheckoutOutcome> subscribe({
    required String planType,
    String? countryCode,
    String? email,
  }) async {
    final CheckoutIntent intent;
    try {
      intent = await _repo.createSubscription(
        planType: planType,
        countryCode: countryCode,
      );
    } on Object catch (e) {
      if (_errorCode(e) == 'ALREADY_SUBSCRIBED') {
        return const PlanCheckoutAlreadyActive();
      }
      return PlanCheckoutFailed(
        _serverMessage(e) ?? 'Could not start the plan.',
      );
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
      description: 'Monthly plan — first month free',
      subscriptionId: intent.subscriptionId,
      email: email,
    );

    // Deliberately not "payment failed": with the free first month nothing was
    // charged, so telling someone to check their statement would send them
    // looking for a debit that does not exist.
    const String unconfirmed =
        'We could not confirm your autopay setup. Try again in a moment.';

    switch (result) {
      case CheckoutCancelled():
        return const PlanCheckoutDismissed();
      case CheckoutFailed(:final String? message):
        return PlanCheckoutFailed(
          message ?? 'That did not go through. Try again.',
        );
      case CheckoutPaid(:final String paymentId, :final String? signature):
        if (signature == null) return const PlanCheckoutFailed(unconfirmed);
        try {
          final bool verified = await _repo.verifySubscription(
            paymentId: paymentId,
            subscriptionId: intent.subscriptionId,
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

  /// One month, paid once — where autopay cannot complete. No mandate, so
  /// nothing recurs and there is no free month.
  Future<PlanCheckoutOutcome> payForMonth({
    required String planType,
    required String countryCode,
    String? email,
  }) async {
    final OrderIntent order;
    try {
      order = await _repo.createOrder(
        planType: planType,
        countryCode: countryCode,
      );
    } on Object catch (e) {
      return PlanCheckoutFailed(
        _serverMessage(e) ?? 'Could not start the payment.',
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

    // Money DID move on this path, unlike the mandate — so this says to wait
    // rather than to pay again.
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
  static String? _errorCode(Object e) {
    if (e is! DioException) return null;
    final Object? failure = e.error;
    return failure is Failure ? failure.errorCode : null;
  }

  /// The server's own sentence, when it sent one — the money routes answer
  /// with copy meant to be shown ("Your account is set to the company brand —
  /// please subscribe to the company plan.").
  static String? _serverMessage(Object e) {
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

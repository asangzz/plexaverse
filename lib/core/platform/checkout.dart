import 'dart:async';

import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'checkout.g.dart';

/// The Razorpay payment sheet, behind a Future.
///
/// A seam like `web_auth.dart` and `image_picking.dart`: the SDK is
/// callback-based and global, and a screen that wires `on(EVENT_*)` handlers
/// directly has to remember to `clear()` them or the next checkout fires the
/// previous screen's callbacks. Wrapping it in one awaited call makes that
/// impossible to forget.
///
/// Nothing here decides whether a payment is real. The signature returned by
/// the sheet is verified SERVER-side by `/payment/verify` — this class hands
/// it over and reports what the sheet said, no more.
sealed class CheckoutResult {
  const CheckoutResult();
}

/// The sheet reported success. NOT proof of payment — the caller must send
/// these to the server, which checks the signature before crediting anything.
class CheckoutPaid extends CheckoutResult {
  const CheckoutPaid({
    required this.paymentId,
    this.orderId,
    this.subscriptionId,
    this.signature,
  });

  final String paymentId;
  final String? orderId;
  final String? subscriptionId;
  final String? signature;
}

/// The user closed the sheet. A decision, not an error — callers stay silent,
/// the same rule the image picker and the OAuth hand-off follow.
class CheckoutCancelled extends CheckoutResult {
  const CheckoutCancelled();
}

class CheckoutFailed extends CheckoutResult {
  const CheckoutFailed({this.message});
  final String? message;
}

abstract class CheckoutService {
  /// Opens the sheet for a one-time order, or for a subscription mandate when
  /// [subscriptionId] is given instead of [orderId].
  Future<CheckoutResult> open({
    required String keyId,
    required String name,
    required String description,
    int? amountInPaise,
    String? orderId,
    String? subscriptionId,
    String? email,
    String? contact,
  });
}

class RazorpayCheckout implements CheckoutService {
  const RazorpayCheckout();

  /// Razorpay's own code for "user closed the sheet".
  static const int _cancelledByUser = 2;

  @override
  Future<CheckoutResult> open({
    required String keyId,
    required String name,
    required String description,
    int? amountInPaise,
    String? orderId,
    String? subscriptionId,
    String? email,
    String? contact,
  }) {
    final Completer<CheckoutResult> done = Completer<CheckoutResult>();
    final Razorpay razorpay = Razorpay();

    // One completion, whatever the SDK does. Razorpay can emit more than one
    // event for a single sheet (an external-wallet hop followed by a
    // success), and completing twice throws.
    void finish(CheckoutResult result) {
      if (done.isCompleted) return;
      razorpay.clear();
      done.complete(result);
    }

    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, (PaymentSuccessResponse r) {
      final String? paymentId = r.paymentId;
      if (paymentId == null) {
        finish(const CheckoutFailed());
        return;
      }
      finish(
        CheckoutPaid(
          paymentId: paymentId,
          orderId: r.orderId,
          subscriptionId: subscriptionId,
          signature: r.signature,
        ),
      );
    });

    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, (PaymentFailureResponse r) {
      finish(
        r.code == _cancelledByUser
            ? const CheckoutCancelled()
            : CheckoutFailed(message: r.message),
      );
    });

    // An external wallet hands off to another app; the outcome comes back
    // through the success/error events, so this is not a completion.
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, (ExternalWalletResponse _) {});

    try {
      razorpay.open(<String, dynamic>{
        'key': keyId,
        'name': name,
        'description': description,
        'amount': ?amountInPaise,
        'order_id': ?orderId,
        'subscription_id': ?subscriptionId,
        if (email != null || contact != null)
          'prefill': <String, dynamic>{'email': ?email, 'contact': ?contact},
      });
    } on Object {
      finish(const CheckoutFailed());
    }

    return done.future;
  }
}

@Riverpod(keepAlive: true)
CheckoutService checkout(Ref ref) => const RazorpayCheckout();

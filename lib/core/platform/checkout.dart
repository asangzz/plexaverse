import 'dart:async';

import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kReleaseMode;
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:url_launcher/url_launcher.dart' show canLaunchUrl;

import '../config/env.dart';

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
/// the sheet is verified SERVER-side (`/payment/verify`, `/autopay/verify`) —
/// this class hands it over and reports what the sheet said, no more.
sealed class CheckoutResult {
  const CheckoutResult();
}

/// The sheet reported success. NOT proof of payment — the caller must send
/// these to the server, which checks the signature before crediting anything.
class CheckoutPaid extends CheckoutResult {
  const CheckoutPaid({required this.paymentId, this.orderId, this.signature});

  final String paymentId;
  final String? orderId;
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

/// The options map the Razorpay sheet is opened with — pure, so the one thing
/// that decides what kind of payment the UPI app is asked for can be tested
/// without the SDK.
///
/// Two shapes, and nothing else:
///
/// * **The 30-day pass** — an order, with its `amount`.
/// * **A UPI AutoPay registration** ([recurring]) — an ORDER with a customer
///   and `recurring: '1'` (Razorpay Recurring Payments, TOKEN_AUTOPAY_SPEC.md
///   §3.3). No `amount`: the order carries it, and a second figure on the
///   client can only disagree. Never `subscription_id`: Razorpay
///   Subscriptions are disabled on the account, and a sheet opened on one
///   registers nothing. `contact` is never hidden or read-only — later debits
///   are sent to the number entered here (D18).
///
/// Throws [ArgumentError] for a recurring sheet with no order or customer:
/// opening one would register a mandate nobody can tie to an account.
Map<String, dynamic> checkoutOptions({
  required String keyId,
  required String name,
  required String description,
  int? amountInPaise,
  String? orderId,
  String? customerId,
  bool recurring = false,
  String? email,
  String? contact,
}) {
  if (recurring) {
    if (orderId == null || orderId.isEmpty) {
      throw ArgumentError.value(orderId, 'orderId', 'required for recurring');
    }
    if (customerId == null || customerId.isEmpty) {
      throw ArgumentError.value(
        customerId,
        'customerId',
        'required for recurring',
      );
    }
  }
  return <String, dynamic>{
    'key': keyId,
    'name': name,
    'description': description,
    if (!recurring) 'amount': ?amountInPaise,
    'order_id': ?orderId,
    if (recurring) 'customer_id': customerId,
    if (recurring) 'recurring': '1',
    if (email != null || contact != null)
      'prefill': <String, dynamic>{'email': ?email, 'contact': ?contact},
  };
}

abstract class CheckoutService {
  /// Opens the sheet for an order: the 30-day pass, or — with [recurring] and
  /// a [customerId] — a UPI AutoPay registration. See [checkoutOptions].
  Future<CheckoutResult> open({
    required String keyId,
    required String name,
    required String description,
    int? amountInPaise,
    String? orderId,
    String? customerId,
    bool recurring = false,
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
    String? customerId,
    bool recurring = false,
    String? email,
    String? contact,
  }) {
    final Map<String, dynamic> options;
    try {
      options = checkoutOptions(
        keyId: keyId,
        name: name,
        description: description,
        amountInPaise: amountInPaise,
        orderId: orderId,
        customerId: customerId,
        recurring: recurring,
        email: email,
        contact: contact,
      );
    } on ArgumentError {
      return Future<CheckoutResult>.value(const CheckoutFailed());
    }

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
          orderId: r.orderId ?? orderId,
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
      razorpay.open(options);
    } on Object {
      finish(const CheckoutFailed());
    }

    return done.future;
  }
}

/// The sheet in the `mock` flavour: answers "paid" at once.
///
/// The mock backend has no Razorpay account, and the real sheet given a fake
/// key fails inside the SDK with nothing to show for it — which would leave
/// the onboarding plan step, which has no skip, as a wall in the mock build.
/// Its fake repository accepts any signature, exactly as it accepts any
/// upload. A release build can never resolve this (see [checkout]).
///
/// It builds the same [checkoutOptions] the real sheet would, so a recurring
/// open with no customer fails here too instead of passing in the mock only.
class MockCheckout implements CheckoutService {
  const MockCheckout();

  @override
  Future<CheckoutResult> open({
    required String keyId,
    required String name,
    required String description,
    int? amountInPaise,
    String? orderId,
    String? customerId,
    bool recurring = false,
    String? email,
    String? contact,
  }) async {
    try {
      checkoutOptions(
        keyId: keyId,
        name: name,
        description: description,
        amountInPaise: amountInPaise,
        orderId: orderId,
        customerId: customerId,
        recurring: recurring,
        email: email,
        contact: contact,
      );
    } on ArgumentError {
      return const CheckoutFailed();
    }
    await Future<void>.delayed(const Duration(milliseconds: 600));
    return CheckoutPaid(
      paymentId: 'pay_mock',
      orderId: orderId,
      signature: 'sig_mock',
    );
  }
}

@Riverpod(keepAlive: true)
CheckoutService checkout(Ref ref) {
  final bool useFake = ref.watch(useFakeBackendProvider);
  assert(
    !(kReleaseMode && useFake),
    'useFakeBackend must be false in release builds.',
  );
  if (useFake && !kReleaseMode) return const MockCheckout();
  return const RazorpayCheckout();
}

/// Whether this build may register UPI AutoPay on iOS at all.
///
/// A UPI AutoPay registration is approved in a UPI app, which the Razorpay
/// sheet opens by its URL scheme. On iOS that needs the UPI apps' schemes in
/// `LSApplicationQueriesSchemes` (ios/Runner/Info.plist, added with this
/// build); Android's are made visible by the `<queries>` entry for `upi` in
/// android/app/src/main/AndroidManifest.xml.
///
/// This is the build-wide switch; [upiAutopayOnDevice] still asks each
/// device whether it has a UPI app to hand off to.
///
/// TODO(owner): confirm a ₹1 registration completes on a real iPhone during
/// the switch-on checks (TOKEN_AUTOPAY_SPEC.md §7), and check the scheme list
/// against Razorpay's current iOS UPI-Intent guide. If it does not, set this
/// to false: iOS then ignores the server's `tokenOffer` and sells the 30-day
/// pass, exactly as while the rail is dark — the plan step has no skip, so a
/// registration that cannot finish must never be the only thing it offers.
/// Still owed: a server-side switch for iOS (TOKEN_AUTOPAY_SPEC.md §4.3), so
/// turning it off does not wait for a store release.
///
/// TODO(owner): store billing rules for UPI AutoPay inside the app
/// (LEGAL_PHASE2 row 39). This build sells a RECURRING digital plan (UPI
/// AutoPay registration and monthly debits) through Razorpay, not Apple
/// In-App Purchase or Google Play Billing; earlier builds sold only a
/// one-time pass that way. Decide before submitting: a build that only links
/// out (reader / external-link entitlement where eligible), Play's
/// alternative or user-choice billing in India, or iOS selling nothing in-app
/// (this constant false, and no pass). Record the decision here.
const bool kUpiAutopayOnIos = true;

/// The UPI apps' URL schemes iOS is asked about — exactly the
/// `LSApplicationQueriesSchemes` list in ios/Runner/Info.plist: iOS answers
/// "no" for any scheme not declared there, whatever is installed.
const List<String> kUpiAppSchemesIos = <String>[
  'tez',
  'phonepe',
  'paytmmp',
  'bhim',
  'credpay',
  'upi',
];

/// Does this device have a UPI app the Razorpay sheet can hand off to?
///
/// A seam like [CheckoutService]: the real one asks the platform, the mock
/// flavour's (and tests') answers without one.
abstract class UpiAppProbe {
  /// True when a UPI app can be opened, false when none can, null when the
  /// device could not say.
  Future<bool?> anyUpiApp();
}

/// Asks the platform with `canLaunchUrl`: on iOS over [kUpiAppSchemesIos],
/// on Android for `upi://pay` (any UPI app answers that intent).
class LauncherUpiAppProbe implements UpiAppProbe {
  const LauncherUpiAppProbe();

  @override
  Future<bool?> anyUpiApp() async {
    final List<Uri> asks = defaultTargetPlatform == TargetPlatform.iOS
        ? <Uri>[for (final String s in kUpiAppSchemesIos) Uri.parse('$s://')]
        : <Uri>[Uri.parse('upi://pay')];
    try {
      for (final Uri uri in asks) {
        if (await canLaunchUrl(uri)) return true;
      }
      return false;
    } on Object {
      return null;
    }
  }
}

/// The mock flavour's probe: the mock backend's sheet answers "paid" with no
/// UPI app at all (see [MockCheckout]), so a simulator without one still
/// shows the UPI AutoPay path the mock exists to demonstrate.
class AssumeUpiApp implements UpiAppProbe {
  const AssumeUpiApp();

  @override
  Future<bool?> anyUpiApp() async => true;
}

@Riverpod(keepAlive: true)
UpiAppProbe upiAppProbe(Ref ref) {
  final bool useFake = ref.watch(useFakeBackendProvider);
  if (useFake && !kReleaseMode) return const AssumeUpiApp();
  return const LauncherUpiAppProbe();
}

/// Can this device register UPI AutoPay? Decided per device, at run time:
///
///   * the platform must be able to at all — Android, or iOS while
///     [kUpiAutopayOnIos]; anywhere else (desktop, web) there is no UPI app;
///   * and a UPI app must be there to approve the mandate in ([UpiAppProbe]).
///     An iPhone with none, or with only apps whose schemes are not declared,
///     or an Android phone with none, would open a sheet with nowhere to
///     approve — and the onboarding plan step has no skip. Those devices
///     ignore the server's `tokenOffer` and sell the 30-day pass, exactly as
///     while the rail is dark.
///
/// A probe that cannot answer keeps the platform's answer (as before the
/// probe existed). Asked again each time it is needed, so installing a UPI
/// app takes effect without restarting the app.
Future<bool> canRegisterUpiAutopay(UpiAppProbe probe) async {
  final bool platform = switch (defaultTargetPlatform) {
    TargetPlatform.android => true,
    TargetPlatform.iOS => kUpiAutopayOnIos,
    _ => false,
  };
  if (!platform) return false;
  return await probe.anyUpiApp() ?? true;
}

/// [canRegisterUpiAutopay] for a screen to watch.
@riverpod
Future<bool> upiAutopayOnDevice(Ref ref) =>
    canRegisterUpiAutopay(ref.watch(upiAppProbeProvider));

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/core/platform/checkout.dart';

class _Probe implements UpiAppProbe {
  const _Probe(this.found);
  final bool? found;

  @override
  Future<bool?> anyUpiApp() async => found;
}

/// What the Razorpay sheet is opened with (TOKEN_AUTOPAY_SPEC.md §4.3): a UPI
/// AutoPay registration is an ORDER with a customer and `recurring: '1'` —
/// Razorpay Recurring Payments — and never a Subscription, which is disabled
/// on the account and registers nothing.
void main() {
  group('a UPI AutoPay registration', () {
    final Map<String, dynamic> options = checkoutOptions(
      keyId: 'rzp_live_x',
      name: 'Plexaverse',
      description: 'UPI Autopay: ₹1 today (refunded), ₹399 a month from 16 Dec',
      // A caller passing an amount anyway must not get it through.
      amountInPaise: 100,
      orderId: 'order_1',
      customerId: 'cust_1',
      recurring: true,
      email: 'a@b.c',
    );

    test('carries the order, the customer and recurring "1"', () {
      expect(options['order_id'], 'order_1');
      expect(options['customer_id'], 'cust_1');
      expect(options['recurring'], '1');
      expect(options['key'], 'rzp_live_x');
    });

    test('never a subscription_id, and no amount (the order carries it)', () {
      expect(options.containsKey('subscription_id'), isFalse);
      expect(options.containsKey('amount'), isFalse);
    });

    test('never hides the contact field: later debits go to that number', () {
      final Object? prefill = options['prefill'];
      expect(prefill, <String, dynamic>{'email': 'a@b.c'});
      expect(options.containsKey('readonly'), isFalse);
      expect(options.containsKey('hidden'), isFalse);
    });

    test('refuses to open without an order or a customer', () {
      expect(
        () => checkoutOptions(
          keyId: 'k',
          name: 'Plexaverse',
          description: 'd',
          orderId: 'order_1',
          recurring: true,
        ),
        throwsArgumentError,
      );
      expect(
        () => checkoutOptions(
          keyId: 'k',
          name: 'Plexaverse',
          description: 'd',
          orderId: '',
          customerId: 'cust_1',
          recurring: true,
        ),
        throwsArgumentError,
      );
    });
  });

  test(
    'the 30-day pass is an order with its amount, and nothing recurring',
    () {
      final Map<String, dynamic> options = checkoutOptions(
        keyId: 'k',
        name: 'Plexaverse',
        description: 'One month',
        amountInPaise: 39900,
        orderId: 'order_2',
      );
      expect(options['order_id'], 'order_2');
      expect(options['amount'], 39900);
      expect(options.containsKey('customer_id'), isFalse);
      expect(options.containsKey('recurring'), isFalse);
      expect(options.containsKey('subscription_id'), isFalse);
      expect(options.containsKey('prefill'), isFalse);
    },
  );

  test('the mock sheet refuses a registration with no customer too', () async {
    final CheckoutResult result = await const MockCheckout().open(
      keyId: 'k',
      name: 'Plexaverse',
      description: 'd',
      orderId: 'order_1',
      recurring: true,
    );
    expect(result, isA<CheckoutFailed>());
  });

  group('can this device register UPI AutoPay', () {
    tearDown(() => debugDefaultTargetPlatformOverride = null);

    Future<bool> on(TargetPlatform p, bool? found) {
      debugDefaultTargetPlatformOverride = p;
      return canRegisterUpiAutopay(_Probe(found));
    }

    test('only with a UPI app to approve the mandate in', () async {
      expect(await on(TargetPlatform.android, true), isTrue);
      expect(await on(TargetPlatform.android, false), isFalse);
      expect(await on(TargetPlatform.iOS, true), kUpiAutopayOnIos);
      expect(await on(TargetPlatform.iOS, false), isFalse);
    });

    test('a probe that cannot answer keeps the platform\'s answer', () async {
      expect(await on(TargetPlatform.android, null), isTrue);
      expect(await on(TargetPlatform.iOS, null), kUpiAutopayOnIos);
    });

    test('never where there is no UPI app to hand off to', () async {
      for (final TargetPlatform p in <TargetPlatform>[
        TargetPlatform.macOS,
        TargetPlatform.windows,
        TargetPlatform.linux,
        TargetPlatform.fuchsia,
      ]) {
        expect(await on(p, true), isFalse, reason: p.name);
      }
    });

    test('iOS asks exactly the schemes Info.plist declares', () {
      // iOS answers "no" for any scheme missing from the plist, whatever is
      // installed — so the two lists must not drift apart.
      final String plist = File('ios/Runner/Info.plist').readAsStringSync();
      final RegExpMatch? block = RegExp(
        r'<key>LSApplicationQueriesSchemes</key>\s*<array>(.*?)</array>',
        dotAll: true,
      ).firstMatch(plist);
      expect(block, isNotNull);
      final List<String> declared = <String>[
        for (final RegExpMatch m in RegExp(
          r'<string>([^<]+)</string>',
        ).allMatches(block!.group(1)!))
          m.group(1)!,
      ];
      expect(kUpiAppSchemesIos, declared);
    });
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:plexaverse/core/config/env.dart';
import 'package:plexaverse/core/platform/checkout.dart';
import 'package:plexaverse/features/pricing/data/pricing_repositories.dart';
import 'package:plexaverse/features/pricing/domain/pricing_repository.dart';
import 'package:plexaverse/features/pricing/presentation/pages/pricing_page.dart';

/// The Pricing screen, read for what it SAYS: a plan is described by what it
/// includes, the referral promises the referrer a month, wallet XP appears
/// nowhere — and each card is sold as the server's offer decides
/// (TOKEN_AUTOPAY_SPEC.md §4.1, §4.4): UPI AutoPay where it is quoted, the
/// 30-day pass everywhere else, a retry when it cannot be worked out. An
/// India buyer with no GST State on record is asked it on the card first.

/// The mock backend with the payment config and the mandate status scripted,
/// recording which checkout each tap opened.
class _Pricing extends FakePricingRepository {
  _Pricing({this.config, this.status = const AutopayStatus()});

  /// Null: the fake's own (a free-month offer).
  final PaymentConfig? config;
  final AutopayStatus status;
  final List<String> mandatesFor = <String>[];
  final List<String> ordersFor = <String>[];

  /// The `?country=` each price read sent (null: none).
  final List<String?> pricedFor = <String?>[];

  @override
  Future<PlanPricing> fetchPricing({String? countryCode}) {
    pricedFor.add(countryCode);
    return super.fetchPricing(countryCode: countryCode);
  }

  @override
  Future<PaymentConfig> fetchPaymentConfig() =>
      config == null ? super.fetchPaymentConfig() : Future.value(config);

  @override
  Future<AutopayStatus> fetchAutopayStatus() async => status;

  @override
  Future<MandateIntent> createMandate({
    required String planType,
    required String countryCode,
    required String copyVersion,
  }) {
    mandatesFor.add(countryCode);
    return super.createMandate(
      planType: planType,
      countryCode: countryCode,
      copyVersion: copyVersion,
    );
  }

  @override
  Future<OrderIntent> createOrder({
    required String planType,
    required String countryCode,
  }) {
    ordersFor.add(countryCode);
    return super.createOrder(planType: planType, countryCode: countryCode);
  }
}

/// A device asked whether it has a UPI app, answering as scripted.
class _Probe implements UpiAppProbe {
  const _Probe(this.found);
  final bool? found;

  @override
  Future<bool?> anyUpiApp() async => found;
}

class _Sheet implements CheckoutService {
  final List<bool> recurring = <bool>[];
  final List<String?> customers = <String?>[];

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
    this.recurring.add(recurring);
    customers.add(customerId);
    return CheckoutPaid(paymentId: 'pay_1', orderId: orderId, signature: 's');
  }
}

void main() {
  late _Sheet sheet;

  Future<void> pump(
    WidgetTester tester, {
    _Pricing? pricing,
    UpiAppProbe? probe,
  }) async {
    // Tall enough that the lazily built scroll view builds every block — the
    // assertions read the whole screen, not the first fold.
    tester.view.physicalSize = const Size(402, 8000) * 3;
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    sheet = _Sheet();
    final GoRouter router = GoRouter(
      routes: <RouteBase>[
        GoRoute(path: '/', builder: (_, _) => const PricingPage()),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      ProviderScope(
        retry: (int _, Object _) => null,
        overrides: [
          envProvider.overrideWithValue(Env.mock),
          checkoutProvider.overrideWithValue(sheet),
          if (probe != null) upiAppProbeProvider.overrideWithValue(probe),
          if (pricing != null)
            pricingRepositoryProvider.overrideWithValue(pricing),
        ],
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await settle(tester);
  }

  /// Every string on screen, scrolled or not.
  List<String> allText(WidgetTester tester) => <String>[
    for (final Text t in tester.widgetList<Text>(
      find.byType(Text, skipOffstage: false),
    ))
      t.data ?? t.textSpan?.toPlainText() ?? '',
  ];

  testWidgets('Pricing lists what a plan includes and never says XP', (
    WidgetTester tester,
  ) async {
    await pump(tester);

    final List<String> text = allText(tester);
    expect(text, contains('WHAT EVERY PLAN INCLUDES'));
    expect(text, contains('Posts'));
    expect(text, contains('Carousels'));
    expect(text, contains('4 a month'));
    // The mock has one post used today.
    expect(text, contains('2 left today'));
    expect(
      text,
      contains('Get a month free when a friend you refer subscribes'),
    );
    expect(text, contains('Roadmap, lessons and calendar'));

    for (final String line in text) {
      expect(RegExp(r'\bXP\b').hasMatch(line), isFalse, reason: line);
      expect(line.toLowerCase().contains('top up'), isFalse, reason: line);
    }
  });

  /// An account that declared its State in onboarding: the checkout opens
  /// at once.
  Future<_Pricing> declared(_Pricing pricing) async {
    await pricing.saveBillingState(
      stateCode: '29',
      source: BillingStateSource.onboarding,
    );
    return pricing;
  }

  testWidgets('a free-month offer reads as one, and sets up UPI AutoPay on '
      'an order with a customer', (WidgetTester tester) async {
    final _Pricing pricing = await declared(_Pricing());
    await pump(tester, pricing: pricing);

    final List<String> text = allText(tester);
    expect(text, contains('First 30 days free'));
    expect(text, contains('UPI Autopay · ₹1 today, refunded'));
    expect(text, contains('Start my free month'));
    expect(
      text.any((String l) => l.startsWith('Then ₹399 a month from ')),
      isTrue,
    );
    // The old Subscriptions copy is gone.
    expect(text, isNot(contains('Monthly plan')));
    expect(text, isNot(contains('Renews every month')));
    expect(text.any((String l) => l.startsWith('Subscribe')), isFalse);

    await tester.tap(find.text('Start my free month'));
    await settle(tester);
    expect(pricing.mandatesFor, <String>['IN']);
    expect(pricing.ordersFor, isEmpty);
    expect(sheet.recurring, <bool>[true]);
    expect(sheet.customers, <String?>['cust_mock']);
    expect(
      find.text(
        'Autopay is set up. Your plan is active — every feature is yours to '
        'use.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('the offer is decided from the server\'s country, never the '
      'phone\'s locale', (WidgetTester tester) async {
    // "English (United States)" is an ordinary setting in India: sending the
    // locale's region sold Indians the international pass and skipped their
    // free month, while onboarding and Settings offered them UPI AutoPay.
    tester.platformDispatcher.localeTestValue = const Locale('en', 'US');
    addTearDown(tester.platformDispatcher.clearLocaleTestValue);
    final _Pricing pricing = _Pricing();
    await pump(tester, pricing: pricing);

    expect(pricing.pricedFor, isNotEmpty);
    expect(pricing.pricedFor.every((String? c) => c == null), isTrue);
    expect(allText(tester), contains('Start my free month'));
  });

  testWidgets('a phone with no UPI app to approve in sells the 30-day pass, '
      'whatever the server offers', (WidgetTester tester) async {
    final _Pricing pricing = await declared(_Pricing());
    await pump(tester, pricing: pricing, probe: const _Probe(false));

    final List<String> text = allText(tester);
    expect(text, contains('Get the 30-day pass · ₹399'));
    expect(text, isNot(contains('Start my free month')));

    await tester.tap(find.text('Get the 30-day pass · ₹399'));
    await settle(tester);
    expect(pricing.ordersFor, <String>['IN']);
    expect(pricing.mandatesFor, isEmpty);
  });

  testWidgets('a probe that cannot answer keeps the platform\'s answer', (
    WidgetTester tester,
  ) async {
    await pump(tester, pricing: _Pricing(), probe: const _Probe(null));
    expect(allText(tester), contains('Start my free month'));
  });

  testWidgets('a dark server (no offer) sells the 30-day pass, as before', (
    WidgetTester tester,
  ) async {
    final _Pricing pricing = await declared(
      _Pricing(config: const PaymentConfig()),
    );
    await pump(tester, pricing: pricing);

    final List<String> text = allText(tester);
    expect(text, contains('30-day pass'));
    expect(text, contains('Paid once, no renewal'));
    expect(text, contains('Get the 30-day pass · ₹399'));
    expect(text, isNot(contains('Start my free month')));

    await tester.tap(find.text('Get the 30-day pass · ₹399'));
    await settle(tester);
    expect(pricing.ordersFor, <String>['IN']);
    expect(pricing.mandatesFor, isEmpty);
    expect(sheet.recurring, <bool>[false]);
  });

  testWidgets('the legacy autopay flags alone never sell autopay', (
    WidgetTester tester,
  ) async {
    // What a server before the token rail said: Subscriptions "on". This
    // build must not open a subscription — they are disabled at Razorpay.
    await pump(
      tester,
      pricing: _Pricing(
        config: const PaymentConfig(indiaAutopay: true, intlAutopay: true),
      ),
    );
    final List<String> text = allText(tester);
    expect(text, contains('Get the 30-day pass · ₹399'));
    expect(text, isNot(contains('UPI Autopay · ₹1 today, refunded')));
  });

  testWidgets('an offer that could not be worked out is a retry, never the '
      'pass', (WidgetTester tester) async {
    final _Pricing pricing = _Pricing(
      config: const PaymentConfig(tokenOfferUnavailable: true),
    );
    await pump(tester, pricing: pricing);

    final List<String> text = allText(tester);
    expect(text, contains('Try again'));
    expect(
      text,
      contains('We could not load your price. Try again in a moment.'),
    );
    expect(text, isNot(contains('Get the 30-day pass · ₹399')));
    expect(text, isNot(contains('Start my free month')));
  });

  testWidgets('an India buyer with no State is asked it on the card before '
      'the checkout opens — once', (WidgetTester tester) async {
    final _Pricing pricing = _Pricing();
    await pump(tester, pricing: pricing);

    await tester.tap(find.text('Start my free month'));
    await settle(tester);
    // Nothing opened yet: the State is asked in the button's place,
    // pre-selected from the region.
    expect(pricing.mandatesFor, isEmpty);
    expect(sheet.recurring, isEmpty);
    expect(find.text('Which State are you in?'), findsOneWidget);
    expect(find.text('It is printed on your GST invoices.'), findsOneWidget);
    expect(find.text('Maharashtra'), findsOneWidget);
    expect(find.text('Start my free month'), findsNothing);

    await tester.tap(find.text('Save and continue'));
    await settle(tester);
    final BillingState saved = await pricing.fetchBillingState();
    expect(saved.stateCode, '27');
    expect(saved.source, BillingStateSource.checkout);
    // Then the checkout the buyer pressed, without a second tap.
    expect(pricing.mandatesFor, <String>['IN']);
    expect(sheet.recurring, <bool>[true]);
    expect(find.text('Which State are you in?'), findsNothing);
  });

  testWidgets('Cancel on the State drops the payment, not the page', (
    WidgetTester tester,
  ) async {
    final _Pricing pricing = _Pricing();
    await pump(tester, pricing: pricing);

    await tester.tap(find.text('Start my free month'));
    await settle(tester);
    await tester.tap(find.text('Cancel'));
    await settle(tester);
    expect(find.text('Which State are you in?'), findsNothing);
    expect(find.text('Start my free month'), findsOneWidget);
    expect(pricing.mandatesFor, isEmpty);
    expect((await pricing.fetchBillingState()).stateCode, isNull);
  });

  testWidgets('a live mandate sells nothing and says where it is managed', (
    WidgetTester tester,
  ) async {
    await pump(
      tester,
      pricing: _Pricing(
        config: const PaymentConfig(indiaTokenAutopay: true),
        status: const AutopayStatus(rail: 'token', canStop: true),
      ),
    );
    final List<String> text = allText(tester);
    expect(text, contains('UPI AutoPay is on'));
    expect(
      text,
      contains('Your next payment and Stop autopay are in Settings → Billing.'),
    );
    expect(text, isNot(contains('Get the 30-day pass · ₹399')));
  });
}

/// The fakes answer after a delay; step past it rather than settle, in case
/// anything on the page loops.
Future<void> settle(WidgetTester tester) async {
  for (int i = 0; i < 16; i++) {
    await tester.pump(const Duration(milliseconds: 120));
  }
}

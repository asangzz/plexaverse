import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:plexaverse/core/network/failure.dart';
import 'package:plexaverse/core/platform/checkout.dart';
import 'package:plexaverse/features/pricing/data/pricing_repositories.dart';
import 'package:plexaverse/features/pricing/domain/pricing_repository.dart';
import 'package:plexaverse/features/settings/application/settings_controllers.dart';
import 'package:plexaverse/features/settings/domain/settings_repository.dart';
import 'package:plexaverse/features/settings/presentation/widgets/billing_section.dart';

/// The Settings billing section: the plan's status, and — on a UPI AutoPay
/// account — the mandate with the user's own Stop autopay
/// (TOKEN_AUTOPAY_SPEC.md D17, §4.4). Wallet XP was retired on 10 Nov 2026,
/// so there is no balance, no "top up", and no "XP" anywhere. And the
/// buyer's GST State: shown, changeable, and asked before the way back pays.

/// The pricing backend for this section: the mandate's status as scripted,
/// the stop as the server answers it, and the offer the way back reads.
class _Billing extends FakePricingRepository {
  _Billing({this.status = const AutopayStatus(), this.after, this.offer});

  AutopayStatus status;

  /// What the status reads once a stop has gone through.
  final AutopayStatus? after;

  /// The registration the server would open now (the way back).
  final TokenOffer? offer;

  StopAutopayResult stopResult = const StopAutopayResult(revokeConfirmed: true);

  /// The server's 500 sentence for the next stop, if any.
  String? stopFails;
  int stops = 0;
  int creates = 0;
  int configReads = 0;

  /// The next registration is refused with 400 AUTOPAY_DISABLED, and the
  /// config read after it offers no UPI AutoPay.
  bool closeRegistrations = false;

  @override
  Future<AutopayStatus> fetchAutopayStatus() async => status;

  @override
  Future<StopAutopayResult> stopAutopay() async {
    stops++;
    final String? fails = stopFails;
    if (fails != null) {
      final RequestOptions request = RequestOptions(path: '/autopay/stop');
      throw DioException(
        requestOptions: request,
        response: Response<dynamic>(requestOptions: request, statusCode: 500),
        error: ServerFailure(message: fails, errorCode: 'INTERNAL'),
      );
    }
    if (after != null) status = after!;
    return stopResult;
  }

  @override
  Future<PlanPricing> fetchPricing({String? countryCode}) async =>
      const PlanPricing(personalPrice: 399, companyPrice: 1199);

  @override
  Future<PaymentConfig> fetchPaymentConfig() async {
    configReads++;
    final TokenOffer? now = creates > 0 && closeRegistrations ? null : offer;
    return PaymentConfig(indiaTokenAutopay: now != null, tokenOffer: now);
  }

  @override
  Future<MandateIntent> createMandate({
    required String planType,
    required String countryCode,
    required String copyVersion,
  }) async {
    creates++;
    if (closeRegistrations) {
      final RequestOptions request = RequestOptions(path: '/autopay/create');
      throw DioException(
        requestOptions: request,
        response: Response<dynamic>(requestOptions: request, statusCode: 400),
        error: const ServerFailure(
          message:
              'Autopay is not available right now. You can pay for one month '
              'instead.',
          errorCode: 'AUTOPAY_DISABLED',
        ),
      );
    }
    return super.createMandate(
      planType: planType,
      countryCode: countryCode,
      copyVersion: copyVersion,
    );
  }
}

// 16 Dec 2026 and 16 Jan 2027, 10:00 IST.
final DateTime _dec16 = DateTime.utc(2026, 12, 16, 4, 30);
final DateTime _jan16 = DateTime.utc(2027, 1, 16, 4, 30);

void main() {
  late _Billing billing;

  Future<List<String>> pump(
    WidgetTester tester,
    SubscriptionState subscription, {
    _Billing? repo,
  }) async {
    billing = repo ?? _Billing();
    await tester.pumpWidget(
      ProviderScope(
        retry: (int _, Object _) => null,
        overrides: [
          pricingRepositoryProvider.overrideWithValue(billing),
          // No platform here: the device is taken to have a UPI app, and
          // the sheet is the mock flavour's.
          upiAppProbeProvider.overrideWithValue(const AssumeUpiApp()),
          checkoutProvider.overrideWithValue(const MockCheckout()),
          accountSnapshotProvider.overrideWith(
            (Ref ref) async => AccountSnapshot(
              user: const AccountIdentity(id: 'u1', name: 'A', email: 'a@b.c'),
              subscription: subscription,
            ),
          ),
          geoPricingProvider.overrideWith(
            (Ref ref) async =>
                const GeoPricing(personalPrice: 399, companyPrice: 1199),
          ),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: BillingSection(preferences: UserPreferences()),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump();
    await tester.pump();
    return texts(tester);
  }

  void expectNoXp(List<String> text) {
    for (final String line in text) {
      expect(RegExp(r'\bXP\b').hasMatch(line), isFalse, reason: line);
      expect(line.toLowerCase().contains('top up'), isFalse, reason: line);
      expect(line.toLowerCase().contains('top-up'), isFalse, reason: line);
    }
  }

  /// No promise of a way to cancel: the word for this control is "stop".
  void expectNoCancelPromise(List<String> text) {
    for (final String line in text) {
      expect(
        RegExp(
          r'cancel\s+any\s*time|cancel\s+from\s+settings',
          caseSensitive: false,
        ).hasMatch(line),
        isFalse,
        reason: line,
      );
    }
  }

  testWidgets('a recurring plan reads Active and renews', (
    WidgetTester tester,
  ) async {
    final List<String> text = await pump(
      tester,
      SubscriptionState(
        status: 'active',
        paymentMode: 'subscription',
        currentPeriodEnd: DateTime(2026, 12, 1),
      ),
    );
    expect(text, contains('Billing'));
    expect(text, contains('Active'));
    expect(text.any((String l) => l.startsWith('Renews on')), isTrue);
    expectNoCancelPromise(text);
    expect(text, contains('What your plan includes'));
    expectNoXp(text);
  });

  testWidgets('a one-time purchase reads as a 30-day pass', (
    WidgetTester tester,
  ) async {
    final List<String> text = await pump(
      tester,
      SubscriptionState(
        status: 'active',
        paymentMode: 'onetime',
        currentPeriodEnd: DateTime(2026, 12, 1),
      ),
    );
    expect(text, contains('30-day pass'));
    expect(text.any((String l) => l.startsWith('Active until')), isTrue);
    // No mandate on the account: nothing to stop.
    expect(text, isNot(contains('Stop autopay')));
    expectNoXp(text);
  });

  testWidgets('no plan says what is free and offers plans', (
    WidgetTester tester,
  ) async {
    final List<String> text = await pump(tester, const SubscriptionState());
    expect(text, contains('No plan'));
    expect(text, contains('See plans'));
    // Without a server verdict a pass holder looks exactly like this, so the
    // caption must not claim AI features are unavailable.
    expect(text.any((String l) => l.contains('need a plan')), isFalse);
    expect(text.any((String l) => l.contains('may not show here yet')), isTrue);
    expectNoXp(text);
  });

  testWidgets('a cancelled subscriber is not told they have no plan', (
    WidgetTester tester,
  ) async {
    final List<String> text = await pump(
      tester,
      const SubscriptionState(status: 'cancelled', paymentMode: 'subscription'),
    );
    expect(text, contains('Not renewing'));
    expect(text, isNot(contains('No plan')));
    expectNoXp(text);
  });

  testWidgets('a pass holder the server calls entitled reads as active', (
    WidgetTester tester,
  ) async {
    // status stays 'inactive': a pass never writes it. The verdict decides.
    final List<String> text = await pump(
      tester,
      SubscriptionState(
        status: 'inactive',
        entitled: true,
        entitlementReason: 'recent_purchase',
        accessEndsAt: DateTime(2026, 12, 5),
      ),
    );
    expect(text, contains('30-day pass'));
    expect(text, isNot(contains('No plan')));
    expect(text.any((String l) => l.startsWith('Active until')), isTrue);
    expect(text, contains('What your plan includes'));
    expectNoXp(text);
  });

  testWidgets('given plan time reads as given, with its end date', (
    WidgetTester tester,
  ) async {
    final List<String> text = await pump(
      tester,
      SubscriptionState(
        entitled: true,
        entitlementReason: 'granted',
        accessEndsAt: DateTime(2026, 12, 10),
      ),
    );
    expect(text, contains('Plan time given'));
    expect(text.any((String l) => l.startsWith('Active until')), isTrue);
    expectNoXp(text);
  });

  testWidgets('a server "not entitled" says no plan plainly', (
    WidgetTester tester,
  ) async {
    final List<String> text = await pump(
      tester,
      const SubscriptionState(
        status: 'cancelled',
        entitled: false,
        entitlementReason: 'lapsed',
      ),
    );
    expect(text, contains('No plan'));
    expect(
      text.any((String l) => l.contains('may not show here yet')),
      isFalse,
    );
    expect(text, contains('See plans'));
    expectNoXp(text);
  });

  group('UPI AutoPay', () {
    const SubscriptionState trial = SubscriptionState(
      status: 'active',
      paymentMode: 'subscription',
      entitled: true,
      entitlementReason: 'subscription_trial',
    );

    AutopayStatus liveTrial() => AutopayStatus(
      rail: 'token',
      tokenStatus: 'confirmed',
      canStop: true,
      nextChargeAt: _dec16,
      nextChargeAmountPaise: 39900,
      monthlyPaise: 39900,
      accessUntil: _dec16,
      inTrial: true,
      trialEndsAt: _dec16,
    );

    testWidgets('the free month says the first payment, its amount and date, '
        'and links nowhere to buy', (WidgetTester tester) async {
      final List<String> text = await pump(
        tester,
        trial,
        repo: _Billing(status: liveTrial()),
      );
      expect(text, contains('Free month'));
      expect(
        text,
        contains('Free month until 16 Dec. First payment of ₹399 on 16 Dec.'),
      );
      expect(text, contains('Stop autopay'));
      // The 17 Nov sentence is false under the owner rule of 21 Nov 2026.
      expect(
        text,
        isNot(
          contains(
            'Cancelling the autopay ends your free month straight away.',
          ),
        ),
      );
      // No link to Pricing while a mandate is live.
      expect(text, isNot(contains('What your plan includes')));
      expect(text, isNot(contains('See plans')));
      expectNoCancelPromise(text);
      expectNoXp(text);
    });

    testWidgets('Stop autopay asks first, says the free month is kept, and '
        'stops only on the second press', (WidgetTester tester) async {
      final _Billing repo = _Billing(
        status: liveTrial(),
        after: AutopayStatus(
          rail: 'token',
          tokenStatus: 'cancelled',
          stopped: true,
          accessUntil: _dec16,
          inTrial: true,
          trialEndsAt: _dec16,
        ),
        offer: TokenOffer(
          kind: MandateKind.paid,
          registrationPaise: 39900,
          registrationRefunded: false,
          monthlyPaise: 39900,
          maxAmountPaise: 39900,
          freeDays: 0,
          copyVersion: kAutopayCheckoutCopyVersion,
          firstChargeAt: _dec16,
          keptTrialEndsAt: _dec16,
        ),
      );
      await pump(tester, trial, repo: repo);

      // Step one: the button opens the confirm and stops nothing.
      await tester.tap(find.text('Stop autopay'));
      await tester.pump();
      expect(repo.stops, 0);
      List<String> text = texts(tester);
      expect(text, contains('Stop autopay?'));
      expect(
        text,
        contains(
          'You keep your free month until 16 Dec, and nothing is charged. '
          'After it ends, using the plan again means setting up AutoPay with '
          'a payment of ₹399.',
        ),
      );
      expect(text, contains('Keep autopay'));

      // "Keep autopay" backs out without a call.
      await tester.tap(find.text('Keep autopay'));
      await tester.pump();
      expect(repo.stops, 0);
      expect(texts(tester), isNot(contains('Stop autopay?')));

      // Step two: confirm.
      await tester.tap(find.text('Stop autopay'));
      await tester.pump();
      await tester.tap(find.text('Stop autopay').last);
      await tester.pump();
      await tester.pump();
      await tester.pump();
      expect(repo.stops, 1);
      text = texts(tester);
      expect(
        text,
        contains(
          'Autopay is stopped. Your UPI app may take a few minutes to show it.',
        ),
      );
      // Not offered the way back in the same breath as the stop.
      expect(text, isNot(contains('Set up AutoPay with ₹399')));
      expect(text, isNot(contains('Stop autopay')));
      expectNoCancelPromise(text);
    });

    testWidgets('after a payment, the confirm keeps the plan to the end of '
        'the paid period', (WidgetTester tester) async {
      await pump(
        tester,
        const SubscriptionState(
          status: 'active',
          entitled: true,
          entitlementReason: 'subscription_active',
        ),
        repo: _Billing(
          status: AutopayStatus(
            rail: 'token',
            tokenStatus: 'confirmed',
            canStop: true,
            nextChargeAt: _jan16,
            nextChargeAmountPaise: 39900,
            accessUntil: _jan16,
          ),
        ),
      );
      expect(texts(tester), contains('Next payment of ₹399 on 16 Jan.'));
      // A token row says nothing generic about renewing: the panel does.
      expect(texts(tester).any((String l) => l.startsWith('Renews on')), false);

      await tester.tap(find.text('Stop autopay'));
      await tester.pump();
      expect(
        texts(tester),
        contains('You keep the plan until 16 Jan. Nothing more is taken.'),
      );
    });

    testWidgets('a stop with a debit already announced says it is refunded '
        'if it lands', (WidgetTester tester) async {
      final _Billing repo = _Billing(status: liveTrial())
        ..stopResult = const StopAutopayResult(debitInFlight: true);
      await pump(tester, trial, repo: repo);
      await tester.tap(find.text('Stop autopay'));
      await tester.pump();
      await tester.tap(find.text('Stop autopay').last);
      await tester.pump();
      await tester.pump();
      expect(
        texts(tester),
        contains(
          'A payment your UPI app already announced may still go through. If '
          'it does, we refund it in full.',
        ),
      );
    });

    testWidgets('a failed stop says why and keeps the confirm open', (
      WidgetTester tester,
    ) async {
      final _Billing repo = _Billing(status: liveTrial())
        ..stopFails =
            'We could not stop autopay just now. Try again, or stop it in '
            'your UPI app.';
      await pump(tester, trial, repo: repo);
      await tester.tap(find.text('Stop autopay'));
      await tester.pump();
      await tester.tap(find.text('Stop autopay').last);
      await tester.pump();
      await tester.pump();
      expect(repo.stops, 1);
      final List<String> text = texts(tester);
      expect(text, contains('Stop autopay?'));
      expect(
        text,
        contains(
          'We could not stop autopay just now. Try again, or stop it in your '
          'UPI app.',
        ),
      );
    });

    testWidgets('AutoPay off in a kept free month: how long it runs, and the '
        '₹399 way back', (WidgetTester tester) async {
      final DateTime soon = DateTime.now().add(const Duration(days: 10));
      final _Billing repo = _Billing(
        status: AutopayStatus(
          rail: 'token',
          tokenStatus: 'cancelled',
          stopped: true,
          accessUntil: soon,
          inTrial: true,
          trialEndsAt: soon,
        ),
        offer: TokenOffer(
          kind: MandateKind.paid,
          registrationPaise: 39900,
          registrationRefunded: false,
          monthlyPaise: 39900,
          maxAmountPaise: 39900,
          freeDays: 0,
          copyVersion: kAutopayCheckoutCopyVersion,
          firstChargeAt: soon,
          keptTrialEndsAt: soon,
        ),
      );
      final List<String> text = await pump(tester, trial, repo: repo);
      expect(
        text,
        contains(
          'AutoPay is off. Your free month ends on ${istDay(soon)} — set up '
          'AutoPay with ₹399 to continue.',
        ),
      );
      expect(text, contains('Set up AutoPay with ₹399'));
      expect(text, isNot(contains('Stop autopay')));
      // AutoPay is off, so Pricing may be linked again.
      expect(text, contains('What your plan includes'));
      expectNoCancelPromise(text);
    });

    testWidgets('the Stop confirm quotes the plan, never a ₹1 next charge', (
      WidgetTester tester,
    ) async {
      // A test lever brought the first debit forward at ₹1: that is the NEXT
      // payment, not what starting again costs.
      await pump(
        tester,
        trial,
        repo: _Billing(
          status: AutopayStatus(
            rail: 'token',
            tokenStatus: 'confirmed',
            canStop: true,
            nextChargeAt: _dec16,
            nextChargeAmountPaise: 100,
            monthlyPaise: 39900,
            accessUntil: _dec16,
            inTrial: true,
            trialEndsAt: _dec16,
          ),
        ),
      );
      expect(
        texts(tester),
        contains('Free month until 16 Dec. First payment of ₹1 on 16 Dec.'),
      );
      await tester.tap(find.text('Stop autopay'));
      await tester.pump();
      final List<String> text = texts(tester);
      expect(
        text,
        contains(
          'You keep your free month until 16 Dec, and nothing is charged. '
          'After it ends, using the plan again means setting up AutoPay with '
          'a payment of ₹399.',
        ),
      );
      expect(text.any((String l) => l.contains('a payment of ₹1.')), isFalse);
    });

    testWidgets('a kept free month with no UPI AutoPay to offer back still '
        'says the ₹399 it takes to continue', (WidgetTester tester) async {
      final DateTime soon = DateTime.now().add(const Duration(days: 10));
      final List<String> text = await pump(
        tester,
        trial,
        // No offer: the rail is dark, so the way back reads as the pass.
        repo: _Billing(
          status: AutopayStatus(
            rail: 'token',
            tokenStatus: 'cancelled',
            stopped: true,
            monthlyPaise: 39900,
            accessUntil: soon,
            inTrial: true,
            trialEndsAt: soon,
          ),
        ),
      );
      expect(
        text,
        contains(
          'AutoPay is off. Your free month ends on ${istDay(soon)} — set up '
          'AutoPay with ₹399 to continue.',
        ),
      );
    });

    testWidgets('a way back refused as AUTOPAY_DISABLED reads the offer '
        'again instead of failing on every tap', (WidgetTester tester) async {
      final DateTime soon = DateTime.now().add(const Duration(days: 10));
      final _Billing repo = _Billing(
        status: AutopayStatus(
          rail: 'token',
          tokenStatus: 'cancelled',
          stopped: true,
          monthlyPaise: 39900,
          accessUntil: soon,
          inTrial: true,
          trialEndsAt: soon,
        ),
        offer: TokenOffer(
          kind: MandateKind.paid,
          registrationPaise: 39900,
          registrationRefunded: false,
          monthlyPaise: 39900,
          maxAmountPaise: 39900,
          freeDays: 0,
          copyVersion: kAutopayCheckoutCopyVersion,
          firstChargeAt: soon,
          keptTrialEndsAt: soon,
        ),
      )..closeRegistrations = true;
      // Declared in onboarding: the registration opens without a State ask.
      await repo.saveBillingState(
        stateCode: '29',
        source: BillingStateSource.onboarding,
      );
      await pump(tester, trial, repo: repo);
      expect(texts(tester), contains('Set up AutoPay with ₹399'));
      final int readsBefore = repo.configReads;

      await tester.tap(find.text('Set up AutoPay with ₹399'));
      for (int i = 0; i < 6; i++) {
        await tester.pump();
      }

      expect(repo.creates, 1);
      expect(repo.configReads, greaterThan(readsBefore));
      final List<String> text = texts(tester);
      // The button that can only fail is gone; the reason stays.
      expect(text, isNot(contains('Set up AutoPay with ₹399')));
      expect(
        text,
        contains(
          'Autopay is not available right now. You can pay for one month '
          'instead.',
        ),
      );
      expectNoCancelPromise(text);
    });

    testWidgets('an unreadable status says neither "Renews on" nor links to '
        'Pricing — a live mandate is as likely as not', (
      WidgetTester tester,
    ) async {
      final List<String> text = await pump(
        tester,
        SubscriptionState(
          status: 'active',
          paymentMode: 'subscription',
          entitled: true,
          entitlementReason: 'subscription_active',
          currentPeriodEnd: DateTime(2027, 1, 16),
        ),
        repo: _Unreadable(),
      );
      expect(text.any((String l) => l.startsWith('Renews on')), isFalse);
      expect(text, isNot(contains('What your plan includes')));
      expect(text, isNot(contains('See plans')));
    });

    testWidgets('an unreadable status still says where AutoPay can be '
        'stopped', (WidgetTester tester) async {
      final List<String> text = await pump(tester, trial, repo: _Unreadable());
      expect(
        text,
        contains(
          'We could not load your billing details. You can also stop your '
          'UPI AutoPay in your UPI app.',
        ),
      );
      expect(text, contains('Try again'));
    });
  });

  group('the buyer\'s GST State', () {
    const SubscriptionState trial = SubscriptionState(
      status: 'active',
      paymentMode: 'subscription',
      entitled: true,
      entitlementReason: 'subscription_trial',
    );

    /// Past the fake backend's latency and the sheet's slide.
    Future<void> step(WidgetTester tester) async {
      for (int i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 200));
      }
    }

    testWidgets('an India account with none sees it is not set, and adds it '
        'from Settings', (WidgetTester tester) async {
      final _Billing repo = _Billing();
      List<String> text = await pump(
        tester,
        const SubscriptionState(),
        repo: repo,
      );
      expect(text, contains('YOUR STATE'));
      expect(text, contains('Not set yet'));
      expect(
        text,
        contains(
          'It is printed on your GST invoices. Changing it applies to '
          'invoices issued from now on; invoices already issued keep the '
          'State they were issued with.',
        ),
      );

      await tester.tap(find.text('Add your State'));
      await step(tester);
      // Pre-selected from the region; nothing saved yet.
      expect(find.text('Maharashtra'), findsOneWidget);
      expect((await repo.fetchBillingState()).stateCode, isNull);

      // A different choice, from the sheet of States.
      await tester.tap(
        find.byKey(const ValueKey<String>('billing-state-field')),
      );
      await step(tester);
      await tester.tap(find.text('Bihar'));
      await step(tester);
      await tester.tap(find.text('Save'));
      await step(tester);

      final BillingState saved = await repo.fetchBillingState();
      expect(saved.stateCode, '10');
      expect(saved.source, BillingStateSource.settings);
      text = texts(tester);
      expect(text, contains('Bihar'));
      expect(text, contains('Saved.'));
      expect(text, contains('Change State'));
    });

    testWidgets('a buyer abroad with no State is shown none', (
      WidgetTester tester,
    ) async {
      final List<String> text = await pump(
        tester,
        const SubscriptionState(),
        repo: _Abroad(),
      );
      expect(text, isNot(contains('YOUR STATE')));
      expect(text, isNot(contains('Add your State')));
    });

    testWidgets('the way back asks the State first, then opens the '
        'registration — once', (WidgetTester tester) async {
      final DateTime soon = DateTime.now().add(const Duration(days: 10));
      final _Billing repo = _Billing(
        status: AutopayStatus(
          rail: 'token',
          tokenStatus: 'cancelled',
          stopped: true,
          monthlyPaise: 39900,
          accessUntil: soon,
          inTrial: true,
          trialEndsAt: soon,
        ),
        offer: TokenOffer(
          kind: MandateKind.paid,
          registrationPaise: 39900,
          registrationRefunded: false,
          monthlyPaise: 39900,
          maxAmountPaise: 39900,
          freeDays: 0,
          copyVersion: kAutopayCheckoutCopyVersion,
          firstChargeAt: soon,
          keptTrialEndsAt: soon,
        ),
      );
      await pump(tester, trial, repo: repo);

      await tester.tap(find.text('Set up AutoPay with ₹399'));
      await step(tester);
      expect(repo.creates, 0);
      expect(find.text('Which State are you in?'), findsOneWidget);
      expect(find.text('Set up AutoPay with ₹399'), findsNothing);

      await tester.tap(find.text('Save and continue'));
      await step(tester);
      final BillingState saved = await repo.fetchBillingState();
      expect(saved.stateCode, '27');
      expect(saved.source, BillingStateSource.checkout);
      expect(repo.creates, 1);
      expect(find.text('Which State are you in?'), findsNothing);
    });
  });
}

/// An account outside India, with no State on record.
class _Abroad extends _Billing {
  @override
  Future<BillingState> fetchBillingState() async =>
      const BillingState(isIndia: false);
}

class _Unreadable extends _Billing {
  @override
  Future<AutopayStatus> fetchAutopayStatus() async =>
      throw const PricingUnavailable();
}

/// Every string on screen.
List<String> texts(WidgetTester tester) => <String>[
  for (final Text t in tester.widgetList<Text>(find.byType(Text)))
    t.data ?? t.textSpan?.toPlainText() ?? '',
];

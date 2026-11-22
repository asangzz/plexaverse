import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/features/pricing/domain/pricing_repository.dart';

/// The offer rule and its words (TOKEN_AUTOPAY_SPEC.md §4.1, §4.4) — the
/// web's `__tests__/lib/plan-offer.test.ts`, for the app.
///
/// `recurring = India && personal && tokenOffer != null`, and nothing else:
/// the legacy `indiaAutopay` / `intlAutopay` flags belong to Razorpay
/// Subscriptions and never decide anything.

const PlanPricing _india = PlanPricing(personalPrice: 399, companyPrice: 1199);
const PlanPricing _us = PlanPricing(
  countryCode: 'US',
  countryName: 'United States',
  currency: 'USD',
  symbol: r'$',
  personalPrice: 10,
  companyPrice: 29,
  isIndia: false,
);

// 16 Dec 2026, 10:00 IST.
final DateTime _dec16 = DateTime.utc(2026, 12, 16, 4, 30);

TokenOffer _offer({
  MandateKind kind = MandateKind.trial,
  int registrationPaise = 100,
  bool refunded = true,
  int freeDays = 30,
  DateTime? firstChargeAt,
  DateTime? kept,
}) => TokenOffer(
  kind: kind,
  registrationPaise: registrationPaise,
  registrationRefunded: refunded,
  monthlyPaise: 39900,
  maxAmountPaise: 39900,
  freeDays: freeDays,
  copyVersion: kAutopayCheckoutCopyVersion,
  firstChargeAt: firstChargeAt ?? _dec16,
  keptTrialEndsAt: kept,
);

PlanOffer _autopay(TokenOffer t) => PlanOffer.decide(
  pricing: _india,
  config: PaymentConfig(indiaTokenAutopay: true, tokenOffer: t),
  planType: 'personal',
)!;

void main() {
  group('PlanOffer.decide', () {
    test('the legacy indiaAutopay flag alone is the pass', () {
      final PlanOffer? o = PlanOffer.decide(
        pricing: _india,
        config: const PaymentConfig(indiaAutopay: true, intlAutopay: true),
        planType: 'personal',
      );
      expect(o?.recurring, isFalse);
      expect(o?.priceLabel, '₹399');
    });

    test('no offer (the rail is dark) is the pass, exactly as before', () {
      final PlanOffer? o = PlanOffer.decide(
        pricing: _india,
        config: const PaymentConfig(),
        planType: 'personal',
      );
      expect(o?.recurring, isFalse);
    });

    test('India, personal, an offer: UPI AutoPay, priced from the offer', () {
      final PlanOffer o = _autopay(_offer());
      expect(o.recurring, isTrue);
      expect(o.kind, MandateKind.trial);
      expect(o.countryCode, 'IN');
      expect(o.price, 399);
      expect(o.registrationRupees, 1);
      expect(o.maxRupees, 399);
      expect(o.freeDays, 30);
      expect(o.firstChargeAt, _dec16);
      expect(o.registrationRefunded, isTrue);
    });

    test('company always gets the pass, even with an offer', () {
      final PlanOffer? o = PlanOffer.decide(
        pricing: _india,
        config: PaymentConfig(tokenOffer: _offer()),
        planType: 'company',
      );
      expect(o?.recurring, isFalse);
      expect(o?.priceLabel, '₹1,199');
    });

    test('outside India: the pass in local currency, whatever the offer', () {
      final PlanOffer? o = PlanOffer.decide(
        pricing: _us,
        config: PaymentConfig(tokenOffer: _offer()),
        planType: 'personal',
      );
      expect(o?.recurring, isFalse);
      expect(o?.priceLabel, r'$10');
      expect(o?.countryCode, 'US');
    });

    test('an offer that could not be worked out is a retry (null), never '
        'the pass', () {
      expect(
        PlanOffer.decide(
          pricing: _india,
          config: const PaymentConfig(tokenOfferUnavailable: true),
          planType: 'personal',
        ),
        isNull,
      );
      // ...but only where autopay could be the answer.
      expect(
        PlanOffer.decide(
          pricing: _us,
          config: const PaymentConfig(tokenOfferUnavailable: true),
          planType: 'personal',
        )?.recurring,
        isFalse,
      );
    });

    test('a device that cannot register UPI AutoPay sells the pass', () {
      final PlanOffer? o = PlanOffer.decide(
        pricing: _india,
        config: PaymentConfig(tokenOffer: _offer()),
        planType: 'personal',
        upiAutopayOnDevice: false,
      );
      expect(o?.recurring, isFalse);
    });
  });

  group('PaymentConfig.fromJson', () {
    test('a dark server: both legacy flags false and no offer', () {
      final PaymentConfig c = PaymentConfig.fromJson(<String, dynamic>{
        'indiaAutopay': false,
        'intlAutopay': false,
        'indiaTokenAutopay': false,
        'tokenOffer': null,
      });
      expect(c.tokenOffer, isNull);
      expect(c.tokenOfferUnavailable, isFalse);
    });

    test('a server older than the token rail reads as no offer', () {
      final PaymentConfig c = PaymentConfig.fromJson(<String, dynamic>{
        'indiaAutopay': true,
        'intlAutopay': false,
      });
      expect(c.tokenOffer, isNull);
      expect(c.tokenOfferUnavailable, isFalse);
      expect(c.indiaAutopay, isTrue);
    });

    test('a whole offer is read field by field', () {
      final PaymentConfig c = PaymentConfig.fromJson(<String, dynamic>{
        'indiaAutopay': false,
        'intlAutopay': false,
        'indiaTokenAutopay': true,
        'tokenOffer': <String, dynamic>{
          'kind': 'deferred',
          'registrationPaise': 100,
          'registrationRefunded': true,
          'monthlyPaise': 39900,
          'maxAmountPaise': 39900,
          'firstChargeAt': '2026-12-16T04:30:00.000Z',
          'freeDays': 0,
          'mandateExpiresAt': '2029-11-22T00:00:00.000Z',
          'copyVersion': 'upi-autopay-2026-11-21',
          'keptTrialEndsAt': null,
          'summary': 'Your current plan runs until 16 Dec.',
        },
      });
      expect(c.indiaTokenAutopay, isTrue);
      expect(c.tokenOffer?.kind, MandateKind.deferred);
      expect(c.tokenOffer?.firstChargeAt, _dec16);
      expect(c.tokenOffer?.summary, 'Your current plan runs until 16 Dec.');
    });

    test('half an offer is "could not work it out", not the pass', () {
      final PaymentConfig c = PaymentConfig.fromJson(<String, dynamic>{
        'indiaTokenAutopay': true,
        'tokenOffer': <String, dynamic>{'kind': 'trial', 'monthlyPaise': 39900},
      });
      expect(c.tokenOffer, isNull);
      expect(c.tokenOfferUnavailable, isTrue);
    });

    test('tokenOfferUnavailable is a retry', () {
      final PaymentConfig c = PaymentConfig.fromJson(<String, dynamic>{
        'indiaAutopay': false,
        'intlAutopay': false,
        'indiaTokenAutopay': false,
        'tokenOffer': null,
        'tokenOfferUnavailable': true,
      });
      expect(c.tokenOfferUnavailable, isTrue);
    });
  });

  group('the words (the web\'s lib/plan-offer.ts)', () {
    test('dates are IST, the web way: "16 Dec", and "Sept"', () {
      expect(istDay(_dec16), '16 Dec');
      // 23:00 UTC on 30 Sept is already 1 Oct in India.
      expect(istDay(DateTime.utc(2026, 9, 30, 23)), '1 Oct');
      expect(istDay(DateTime.utc(2026, 9, 16, 6)), '16 Sept');
    });

    test('amounts: Indian grouping, at most two decimals', () {
      expect(inr(399), '399');
      expect(inr(1199), '1,199');
      expect(inr(123456), '1,23,456');
      expect(inr(399.5), '399.5');
      expect(inr(1), '1');
    });

    test('a refunded free month: Free for N days, the ₹1 said out loud', () {
      final PlanOffer o = _autopay(_offer(freeDays: 12));
      expect(autopayHeadline(o), (figure: 'Free', caption: 'for 12 days'));
      expect(
        registrationLine(o),
        'To set up autopay your UPI app takes ₹1 now, and we refund it '
        'automatically. You approve payments of up to ₹399 a month, and your '
        'first payment of ₹399 is on 16 Dec.',
      );
      expect(autopayCta(o), 'Start my free month');
      expect(
        planStepLine(o),
        'One thing before I start writing: your first month is free. Set up '
        'UPI autopay now and your first payment is on 16 Dec.',
      );
    });

    test('the trial terms keep the rest of the month on a stop', () {
      final String terms = autopayTerms(_autopay(_offer()));
      expect(terms, contains('by UPI Autopay, with a notice before each'));
      expect(
        terms,
        contains(
          'You can stop autopay at any time in Settings → Billing or in your '
          'UPI app.',
        ),
      );
      expect(
        terms,
        contains(
          'If you stop it during your free month, you keep the rest of the '
          'month and no payment is taken.',
        ),
      );
      expect(terms, isNot(contains('ends your free month straight away')));
    });

    test('a kept ₹1 is said to be kept, and never called free', () {
      final PlanOffer o = _autopay(_offer(refunded: false));
      expect(
        registrationLine(o),
        startsWith(
          'To set up autopay your UPI app takes ₹1 now, which is not '
          'refunded.',
        ),
      );
      expect(autopayHeadline(o), (
        figure: '₹1 today',
        caption: 'then ₹399 a month from 16 Dec',
      ));
      expect(autopayCardCopy(o).pill, 'First 30 days for ₹1');
      expect(autopayCta(o), 'Set up autopay');
      expect(planStepLine(o), isNot(contains('free')));
    });

    test('the Pricing card for a free month', () {
      expect(autopayCardCopy(_autopay(_offer())), (
        pill: 'First 30 days free',
        line: 'UPI Autopay · ₹1 today, refunded',
        cta: 'Start my free month',
        ctaNote: 'Then ₹399 a month from 16 Dec',
      ));
    });

    test('a paid registration (the free month is spent): ₹399 now, no ₹1 '
        'line', () {
      final PlanOffer o = _autopay(
        _offer(
          kind: MandateKind.paid,
          registrationPaise: 39900,
          refunded: false,
          freeDays: 0,
          firstChargeAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
      );
      expect(registrationLine(o), isNull);
      expect(autopayCta(o), 'Set up autopay · ₹399');
      expect(
        autopayTerms(o),
        startsWith('₹399 today, then ₹399 a month by UPI Autopay'),
      );
      expect(autopayCardCopy(o).cta, 'Set up autopay · ₹399/mo');
    });

    test('a kept free month says how to continue (the owner rule)', () {
      final DateTime soon = DateTime.now().add(const Duration(days: 5));
      final PlanOffer o = _autopay(
        _offer(
          kind: MandateKind.paid,
          registrationPaise: 39900,
          refunded: false,
          freeDays: 0,
          firstChargeAt: soon,
          kept: soon,
        ),
      );
      expect(
        keptFreeMonthLine(o),
        'AutoPay is off. Your free month ends on ${istDay(soon)} — set up '
        'AutoPay with ₹399 to continue.',
      );
      final DateTime past = DateTime.now().subtract(const Duration(days: 2));
      expect(
        keptFreeMonthLine(_autopay(_offer(kind: MandateKind.paid, kept: past))),
        startsWith('AutoPay is off. Your free month ended on'),
      );
    });

    test('the sheet describes the order, not the offer', () {
      expect(
        autopayCheckoutDescription(
          kind: MandateKind.trial,
          amountPaise: 100,
          monthlyPaise: 39900,
          firstChargeAt: _dec16,
          registrationRefunded: true,
        ),
        'UPI Autopay: ₹1 today (refunded), ₹399 a month from 16 Dec',
      );
      expect(
        autopayCheckoutDescription(
          kind: MandateKind.paid,
          amountPaise: 39900,
          monthlyPaise: 39900,
          firstChargeAt: null,
          registrationRefunded: false,
        ),
        'UPI Autopay: ₹399 a month',
      );
    });

    test('the thread\'s echo per outcome', () {
      expect(planDoneEcho(PlanStepOutcome.mandate, kind: MandateKind.trial), (
        text: 'Autopay set up',
        badge: 'Free month started',
      ));
      expect(planDoneEcho(PlanStepOutcome.mandate, kind: MandateKind.paid), (
        text: 'Autopay set up',
        badge: 'Plan active',
      ));
      expect(planDoneEcho(PlanStepOutcome.mandatePending), (
        text: 'Autopay requested',
        badge: 'Confirming with your bank',
      ));
    });

    test('the pass and an unworked-out offer promise nothing about price', () {
      final PlanOffer? pass = PlanOffer.decide(
        pricing: _india,
        config: const PaymentConfig(),
        planType: 'personal',
      );
      const String plain =
          "One thing before I start writing: your plan — it's what pays for "
          'the posts I write and publish for you.';
      expect(planStepLine(pass), plain);
      expect(planStepLine(null), plain);
      expect(keptFreeMonthLine(pass!), isNull);
      expect(registrationLine(pass), isNull);
    });
  });
}

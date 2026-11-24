import 'dart:async';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/core/access/company_brand.dart';
import 'package:plexaverse/core/config/env.dart';
import 'package:plexaverse/core/network/failure.dart';
import 'package:plexaverse/core/platform/checkout.dart';
import 'package:plexaverse/core/platform/file_picking.dart';
import 'package:plexaverse/core/platform/image_picking.dart';
import 'package:plexaverse/features/contest/domain/levels_words.dart';
import 'package:plexaverse/features/onboarding/application/onboarding_chat_controller.dart';
import 'package:plexaverse/features/onboarding/data/onboarding_repositories.dart';
import 'package:plexaverse/features/onboarding/domain/onboarding_repository.dart';
import 'package:plexaverse/features/onboarding/presentation/widgets/plan_panel.dart';
import 'package:plexaverse/features/pricing/data/pricing_repositories.dart';
import 'package:plexaverse/features/pricing/domain/pricing_repository.dart';

/// The onboarding runs in the web's order, on both paths.
///
/// This is the test the step ORDER lives in. The app's onboarding once asked
/// role, goal and voice before LinkedIn, had no CV import and no company
/// logo, poster or document — a different flow from the web's under the same
/// name. Each list below is the web's `OnboardingChat` path, read off its
/// `advance(...)` calls; if the web changes, change it there and here.
///
/// Runs on the in-memory fakes (the mock flavour's backend), with the pickers
/// replaced so a "file" is chosen without a platform channel, and the payment
/// sheet replaced so a plan is bought without Razorpay.
///
/// The company brand is closed to new signups, so the brand question is not
/// asked; the company tests reopen it to walk the path that stays intact for
/// the day it does.
class _Files implements FilePickingService {
  @override
  Future<FilePickResult> pick({required List<String> extensions}) async =>
      PickedFile(
        bytes: Uint8List(16),
        name: extensions.contains('pdf') ? 'profile.pdf' : 'logo.png',
      );
}

class _Images implements ImagePickingService {
  @override
  Future<ImagePickResult> pick(ImageSourceKind source) async =>
      PickedImage(bytes: Uint8List(16), name: 'shot.png');

  @override
  Future<List<PickedImage>> pickMany({required int limit}) async =>
      <PickedImage>[
        PickedImage(bytes: Uint8List(16), name: 'a.png'),
        PickedImage(bytes: Uint8List(16), name: 'b.png'),
      ];
}

/// The payment sheet, scripted: answers [next], and records what it opened.
class _Sheet implements CheckoutService {
  CheckoutResult next = const CheckoutPaid(
    paymentId: 'pay_1',
    signature: 'sig_1',
  );
  final List<String?> opened = <String?>[];

  /// Whether each opened sheet was a UPI AutoPay registration.
  final List<bool> recurring = <bool>[];

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
    opened.add(orderId);
    this.recurring.add(recurring);
    return next;
  }
}

/// The mock pricing backend, from somewhere other than India — or nowhere
/// readable at all.
class _Pricing extends FakePricingRepository {
  _Pricing({this.abroad = false, this.unreadable = false});

  final bool abroad;
  bool unreadable;

  /// The server's 409 ALREADY_SUBSCRIBED on the next registration.
  bool alreadySubscribed = false;

  /// The server's 409 MANDATE_PENDING on the next registration.
  bool mandatePending = false;

  /// What `/autopay/verify` says of the bank's answer.
  String verifiedTokenStatus = 'confirmed';

  /// The token rail switched off: the server sends no offer.
  bool dark = false;

  /// The rail is switched off between the offer and the tap: the next
  /// registration answers 400 AUTOPAY_DISABLED, and the offer turns dark.
  bool switchedOff = false;
  final List<String> ordersFor = <String>[];
  final List<String> mandatesFor = <String>[];

  /// `GET /user/billing-state` fails while set.
  bool stateUnreadable = false;

  /// The next State save fails with the server's 500 sentence, when set.
  String? stateSaveFails;

  /// Every State save, as `code:source`.
  final List<String> stateSaves = <String>[];

  @override
  Future<BillingState> fetchBillingState() async {
    if (stateUnreadable) throw const PricingUnavailable();
    return super.fetchBillingState();
  }

  @override
  Future<SavedBillingState> saveBillingState({
    required String stateCode,
    required BillingStateSource source,
  }) async {
    stateSaves.add('$stateCode:${source.wire}');
    final String? fails = stateSaveFails;
    if (fails != null) {
      stateSaveFails = null;
      final RequestOptions request = RequestOptions(
        path: '/user/billing-state',
      );
      throw DioException(
        requestOptions: request,
        response: Response<dynamic>(requestOptions: request, statusCode: 500),
        error: ServerFailure(message: fails, errorCode: 'INTERNAL'),
      );
    }
    return super.saveBillingState(stateCode: stateCode, source: source);
  }

  @override
  Future<PlanPricing> fetchPricing({String? countryCode}) async {
    if (unreadable) throw const PricingUnavailable();
    if (!abroad) return super.fetchPricing(countryCode: countryCode);
    return const PlanPricing(
      countryCode: 'US',
      countryName: 'United States',
      currency: 'USD',
      symbol: r'$',
      personalPrice: 10,
      companyPrice: 29,
      isIndia: false,
      subscriptionAmountInr: <String, int>{'personal': 798, 'company': 2398},
    );
  }

  @override
  Future<PaymentConfig> fetchPaymentConfig() async {
    // What a dark server answers (TOKEN_RAIL_READY false): both legacy flags
    // false and no offer.
    if (dark) return const PaymentConfig();
    return super.fetchPaymentConfig();
  }

  @override
  Future<MandateIntent> createMandate({
    required String planType,
    required String countryCode,
    required String copyVersion,
  }) {
    mandatesFor.add(countryCode);
    if (switchedOff) {
      dark = true;
      final RequestOptions request = RequestOptions(path: '/autopay/create');
      return Future<MandateIntent>.error(
        DioException(
          requestOptions: request,
          response: Response<dynamic>(requestOptions: request, statusCode: 400),
          error: const ClientFailure(
            message:
                'Autopay is not available right now. You can pay for one '
                'month instead.',
            errorCode: 'AUTOPAY_DISABLED',
          ),
        ),
      );
    }
    if (alreadySubscribed || mandatePending) {
      final RequestOptions request = RequestOptions(path: '/autopay/create');
      return Future<MandateIntent>.error(
        DioException(
          requestOptions: request,
          response: Response<dynamic>(requestOptions: request, statusCode: 409),
          error: alreadySubscribed
              ? const ClientFailure(
                  message:
                      'You already have a plan, so there is nothing to set up.',
                  errorCode: 'ALREADY_SUBSCRIBED',
                )
              : const ClientFailure(
                  message:
                      'Your autopay is being confirmed with your bank. This '
                      'can take a few minutes, and there is no need to set it '
                      'up again.',
                  errorCode: 'MANDATE_PENDING',
                ),
        ),
      );
    }
    return super.createMandate(
      planType: planType,
      countryCode: countryCode,
      copyVersion: copyVersion,
    );
  }

  @override
  Future<MandateVerification> verifyMandate({
    required String orderId,
    required String paymentId,
    required String signature,
  }) async {
    await super.verifyMandate(
      orderId: orderId,
      paymentId: paymentId,
      signature: signature,
    );
    return MandateVerification(
      success: true,
      kind: MandateKind.trial,
      tokenStatus: verifiedTokenStatus,
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

/// An account that already has a plan — a free month started on an earlier
/// run of the chat.
class _Subscribed extends FakeOnboardingRepository {
  const _Subscribed();

  @override
  Future<PlanHolder> fetchPlanHolder() async => const PlanHolder(hasPlan: true);
}

void main() {
  late ProviderContainer container;
  late _Sheet sheet;
  late List<OnboardingStep> visited;

  OnboardingChatController chat() =>
      container.read(onboardingChatControllerProvider.notifier);
  OnboardingChatState state() =>
      container.read(onboardingChatControllerProvider);

  /// Lets Plexa finish typing. Her lines are timers, so the fake clock has to
  /// move — generously, because a step can say two lines after a slow upload.
  Future<void> settle(WidgetTester tester) async {
    for (int i = 0; i < 8; i++) {
      await tester.pump(const Duration(seconds: 1));
    }
  }

  /// Starts the chat and records every step it enters, in order.
  Future<void> open(
    WidgetTester tester, {
    bool companyOpen = false,
    PricingRepository? pricing,
    OnboardingRepository? onboarding,
    UpiAppProbe? probe,
  }) async {
    sheet = _Sheet();
    container = ProviderContainer(
      overrides: [
        envProvider.overrideWithValue(Env.mock),
        filePickingProvider.overrideWithValue(_Files()),
        imagePickingProvider.overrideWithValue(_Images()),
        checkoutProvider.overrideWithValue(sheet),
        companyBrandOpenProvider.overrideWithValue(companyOpen),
        if (probe != null) upiAppProbeProvider.overrideWithValue(probe),
        if (pricing != null)
          pricingRepositoryProvider.overrideWithValue(pricing),
        if (onboarding != null)
          onboardingRepositoryProvider.overrideWithValue(onboarding),
      ],
    );
    addTearDown(container.dispose);
    visited = <OnboardingStep>[];
    container.listen<OnboardingChatState>(onboardingChatControllerProvider, (
      OnboardingChatState? _,
      OnboardingChatState next,
    ) {
      if (visited.isEmpty || visited.last != next.step) visited.add(next.step);
    }, fireImmediately: true);
    await settle(tester);
  }

  Future<void> act(WidgetTester tester, Future<void> Function() step) async {
    unawaited(step());
    await settle(tester);
  }

  testWidgets('personal, CV skipped: role, then a written sample', (
    WidgetTester tester,
  ) async {
    await open(tester);
    await act(tester, () => chat().acknowledgeWelcome());
    await act(tester, () => chat().connectLinkedin());
    await act(tester, () => chat().saveBillingState('27'));
    await act(tester, () => chat().startPlan());
    await act(tester, () => chat().skipCv());
    await act(tester, () => chat().pickRole('Software Engineer'));
    await act(tester, () => chat().chooseWrite());
    await act(
      tester,
      () => chat().submitVoiceSample(
        'Short sentences. One idea per line. No throat-clearing.',
      ),
    );

    expect(visited, <OnboardingStep>[
      OnboardingStep.welcome,
      OnboardingStep.connect,
      OnboardingStep.billingState,
      OnboardingStep.plan,
      OnboardingStep.cvUpload,
      OnboardingStep.currentRole,
      OnboardingStep.styleChoice,
      OnboardingStep.styleWrite,
      OnboardingStep.finish,
      // Owner, 24 Nov 2026: after the save, how the levels work.
      OnboardingStep.levelsIntro,
    ]);
    expect(state().answers.cv?.profession, 'Software Engineer');
    expect(state().answers.usedCvUpload, isFalse);
    // Saved, but not handed over until "Start Level 1": the levels are
    // explained first.
    expect(state().completed, isFalse);
    final List<String> said = <String>[
      for (final ChatMessage m in state().messages)
        if (m.role == ChatRole.bot) m.text,
    ];
    // Every intro line, last — however many there are (the paid condition
    // was added in review, 24 Nov 2026).
    expect(
      said.sublist(said.length - kLevelsIntroLines.length),
      kLevelsIntroLines,
    );
    await act(tester, () => chat().startLevels());
    expect(state().messages.last.text, kLevelsIntroStart);
    expect(state().completed, isTrue);
  });

  testWidgets('personal, CV imported: straight to the voice, via screenshots', (
    WidgetTester tester,
  ) async {
    await open(tester);
    await act(tester, () => chat().acknowledgeWelcome());
    await act(tester, () => chat().connectLinkedin());
    await act(tester, () => chat().saveBillingState('27'));
    await act(tester, () => chat().startPlan());
    await act(tester, () => chat().uploadCv());
    await act(tester, () => chat().chooseScreenshots());
    await act(tester, () => chat().uploadScreenshots());

    expect(visited, <OnboardingStep>[
      OnboardingStep.welcome,
      OnboardingStep.connect,
      OnboardingStep.billingState,
      OnboardingStep.plan,
      OnboardingStep.cvUpload,
      OnboardingStep.styleChoice,
      OnboardingStep.styleScreenshots,
      OnboardingStep.finish,
      OnboardingStep.levelsIntro,
    ]);
    expect(state().answers.usedCvUpload, isTrue);
    expect(state().answers.cv?.headline, isNotNull);
  });

  testWidgets(
    'company (reopened): page, logo, poster, document, details, then the voice',
    (WidgetTester tester) async {
      await open(tester, companyOpen: true);
      await act(tester, () => chat().acknowledgeWelcome());
      await act(tester, () => chat().pickBrand(BrandChoice.company));
      await act(tester, () => chat().connectLinkedin());
      await act(tester, () => chat().saveBillingState('27'));
      await act(tester, () => chat().startPlan());
      await act(tester, () => chat().pickCompanyPage('1234567', 'Plexaverse'));
      await act(tester, () => chat().uploadLogo());
      await act(tester, () => chat().skipPosterStyle());
      // The mock document has no website, so it is too thin to write from.
      await act(tester, () => chat().uploadCompanyDoc());
      await act(
        tester,
        () => chat().submitCompanyDetails(
          description: 'Acme builds payment infrastructure for small shops.',
          industry: 'FinTech',
          tagline: '',
          features: <String>['Checkout links'],
          website: 'acme.in',
        ),
      );
      await act(tester, () => chat().skipScreenshots());
      await act(
        tester,
        () => chat().submitVoiceSample(
          'We ship payments that just work, so shops can sell.',
        ),
      );

      expect(visited, <OnboardingStep>[
        OnboardingStep.welcome,
        OnboardingStep.brand,
        OnboardingStep.connect,
        OnboardingStep.billingState,
        OnboardingStep.plan,
        OnboardingStep.companyPage,
        OnboardingStep.companyLogo,
        OnboardingStep.posterStyle,
        OnboardingStep.companyDoc,
        OnboardingStep.companyDetails,
        OnboardingStep.styleChoice,
        OnboardingStep.styleWrite,
        OnboardingStep.finish,
        OnboardingStep.levelsIntro,
      ]);
      expect(state().answers.companyLogoUrl, isNotNull);
      expect(state().answers.companyDoc?.website, 'acme.in');
      // The typed feature first, then the document's, deduplicated.
      expect(state().answers.companyDoc?.features.first, 'Checkout links');
    },
  );

  testWidgets('company with no usable page can switch to a personal brand', (
    WidgetTester tester,
  ) async {
    await open(tester, companyOpen: true);
    await act(tester, () => chat().acknowledgeWelcome());
    await act(tester, () => chat().pickBrand(BrandChoice.company));
    await act(tester, () => chat().connectLinkedin());
    await act(tester, () => chat().saveBillingState('27'));
    await act(tester, () => chat().startPlan());
    await act(tester, () => chat().switchToPersonal());
    await act(tester, () => chat().connectLinkedin());

    // The second pass goes through the State step without a word: the
    // State is on record now.
    expect(visited.skip(2), <OnboardingStep>[
      OnboardingStep.connect,
      OnboardingStep.billingState,
      OnboardingStep.plan,
      OnboardingStep.companyPage,
      OnboardingStep.connect,
      OnboardingStep.billingState,
      OnboardingStep.plan,
    ]);
    expect(
      state().messages.where(
        (ChatMessage m) => m.text == OnboardingChatController.billingStateAsk,
      ),
      hasLength(1),
    );
    expect(state().answers.brand, BrandChoice.personal);
  });

  testWidgets('connecting says who connected, and asks the web\'s line', (
    WidgetTester tester,
  ) async {
    await open(tester);
    await act(tester, () => chat().acknowledgeWelcome());
    final List<String> lines = state().messages
        .map((ChatMessage m) => m.text)
        .toList();
    // No XP promise: connecting pays nothing since wallet XP was retired.
    expect(
      lines.last,
      "I'll publish on your behalf and learn from your existing posts.",
    );

    await act(tester, () => chat().connectLinkedin());
    expect(
      state().messages.map((ChatMessage m) => m.text),
      contains('Connected as Asang Borkar'),
    );
  });

  testWidgets('the brand question is not asked while the company brand is '
      'closed', (WidgetTester tester) async {
    await open(tester);
    await act(tester, () => chat().acknowledgeWelcome());

    expect(visited, <OnboardingStep>[
      OnboardingStep.welcome,
      OnboardingStep.connect,
    ]);
    // Set outright, as the web does, so the finish writes `personal` even
    // over a row an earlier run left saying `company`.
    expect(state().answers.brand, BrandChoice.personal);
    expect(
      state().answers.toPreferencesPatch()['brandType'],
      BrandChoice.personal.id,
    );
  });

  group('the plan', () {
    /// To the plan step, through the State step where it asks — a no-op
    /// everywhere it does not (abroad, an unreadable region, a plan held).
    Future<void> toPlan(WidgetTester tester) async {
      await act(tester, () => chat().acknowledgeWelcome());
      await act(tester, () => chat().connectLinkedin());
      await act(tester, () => chat().saveBillingState('27'));
    }

    testWidgets('India: free first, a UPI AutoPay mandate, and the thread '
        'says so', (WidgetTester tester) async {
      final _Pricing pricing = _Pricing();
      await open(tester, pricing: pricing);
      await toPlan(tester);

      expect(state().step, OnboardingStep.plan);
      expect(state().planOffer?.recurring, isTrue);
      expect(state().planOffer?.kind, MandateKind.trial);
      expect(state().planOffer?.priceLabel, '₹399');
      expect(
        state().messages.last.text,
        OnboardingChatController.planAsk(state().planOffer),
      );
      expect(state().messages.last.text, contains('first month is free'));
      // The first payment's DATE, as the server quoted it — not "day 30".
      expect(
        state().messages.last.text,
        contains(istDay(state().planOffer!.firstChargeAt!)),
      );
      // The ₹1 registration is a charge; the line must not deny it.
      expect(state().messages.last.text, isNot(contains('nothing is charged')));

      await act(tester, () => chat().startPlan());
      expect(pricing.mandatesFor, <String>['IN']);
      expect(pricing.ordersFor, isEmpty);
      // An ORDER with a customer and `recurring` — never a subscription.
      expect(sheet.opened, <String?>['order_mock_mandate']);
      expect(sheet.recurring, <bool>[true]);
      final ChatMessage echo = state().messages.firstWhere(
        (ChatMessage m) =>
            m.role == ChatRole.user && m.text == 'Autopay set up',
      );
      expect(echo.badge, 'Free month started');
      expect(state().step, OnboardingStep.cvUpload);
    });

    testWidgets('a registration still confirming with the bank moves on and '
        'says so', (WidgetTester tester) async {
      final _Pricing pricing = _Pricing()..verifiedTokenStatus = 'initiated';
      await open(tester, pricing: pricing);
      await toPlan(tester);

      await act(tester, () => chat().startPlan());
      expect(pricing.mandatesFor, <String>['IN']);
      expect(state().planError, isNull);
      final ChatMessage echo = state().messages.firstWhere(
        (ChatMessage m) =>
            m.role == ChatRole.user && m.text == 'Autopay requested',
      );
      expect(echo.badge, 'Confirming with your bank');
      expect(state().step, OnboardingStep.cvUpload);
    });

    testWidgets('a registration already waiting on the bank (409) moves on '
        'without a second sheet', (WidgetTester tester) async {
      final _Pricing pricing = _Pricing()..mandatePending = true;
      await open(tester, pricing: pricing);
      await toPlan(tester);

      await act(tester, () => chat().startPlan());
      expect(sheet.opened, isEmpty);
      expect(state().planError, isNull);
      expect(
        state().messages.map((ChatMessage m) => m.text),
        contains('Autopay requested'),
      );
      expect(state().step, OnboardingStep.cvUpload);
    });

    testWidgets('autopay switched off after the offer: says so, and the '
        'step becomes the pass instead of a dead end', (
      WidgetTester tester,
    ) async {
      final _Pricing pricing = _Pricing()..switchedOff = true;
      await open(tester, pricing: pricing);
      await toPlan(tester);
      expect(state().planOffer?.recurring, isTrue);

      await act(tester, () => chat().startPlan());
      expect(sheet.opened, isEmpty);
      expect(state().step, OnboardingStep.plan);
      expect(
        state().planError,
        'Autopay is not available right now. You can pay for one month '
        'instead.',
      );
      expect(state().planOffer?.recurring, isFalse);
      expect(state().planOfferFailed, isFalse);

      await act(tester, () => chat().startPlan());
      expect(pricing.ordersFor, <String>['IN']);
      expect(state().step, OnboardingStep.cvUpload);
    });

    testWidgets('while the rail is dark (no offer) India buys the pass, as '
        'before', (WidgetTester tester) async {
      final _Pricing pricing = _Pricing()..dark = true;
      await open(tester, pricing: pricing);
      await toPlan(tester);

      expect(state().planOffer?.recurring, isFalse);
      expect(state().planOffer?.priceLabel, '₹399');
      expect(state().messages.last.text, isNot(contains('free')));

      await act(tester, () => chat().startPlan());
      expect(pricing.mandatesFor, isEmpty);
      expect(pricing.ordersFor, <String>['IN']);
      expect(sheet.recurring, <bool>[false]);
      expect(
        state().messages.map((ChatMessage m) => m.text),
        contains('Paid for this month'),
      );
    });

    testWidgets('abroad: one month paid once, in dollars, nothing recurring', (
      WidgetTester tester,
    ) async {
      final _Pricing pricing = _Pricing(abroad: true);
      await open(tester, pricing: pricing);
      await toPlan(tester);

      expect(state().planOffer?.recurring, isFalse);
      expect(state().planOffer?.priceLabel, r'$10');
      expect(state().messages.last.text, isNot(contains('free')));

      await act(tester, () => chat().startPlan());
      // The region goes back with the order — without it the server prices
      // the order as India.
      expect(pricing.ordersFor, <String>['US']);
      expect(pricing.mandatesFor, isEmpty);
      expect(
        state().messages.map((ChatMessage m) => m.text),
        contains('Paid for this month'),
      );
      expect(state().step, OnboardingStep.cvUpload);
    });

    testWidgets('an account that already has a plan is not asked again', (
      WidgetTester tester,
    ) async {
      await open(tester, onboarding: const _Subscribed());
      await toPlan(tester);

      // Past the State AND the plan: there is nothing to pay, and the State
      // is asked before the next payment instead.
      expect(visited, <OnboardingStep>[
        OnboardingStep.welcome,
        OnboardingStep.connect,
        OnboardingStep.billingState,
        OnboardingStep.cvUpload,
      ]);
      expect(sheet.opened, isEmpty);
      expect(
        state().messages.map((ChatMessage m) => m.text),
        isNot(contains(OnboardingChatController.planAsk(null))),
      );
      expect(
        state().messages.map((ChatMessage m) => m.text),
        isNot(contains(OnboardingChatController.billingStateAsk)),
      );
    });

    testWidgets('an unreadable region blocks the button, never guesses India', (
      WidgetTester tester,
    ) async {
      final _Pricing pricing = _Pricing(unreadable: true);
      await open(tester, pricing: pricing);
      await toPlan(tester);

      expect(state().planOffer, isNull);
      expect(state().planOfferFailed, isTrue);
      await act(tester, () => chat().startPlan());
      expect(sheet.opened, isEmpty);
      expect(state().step, OnboardingStep.plan);

      pricing.unreadable = false;
      await act(tester, () => chat().retryPlanOffer());
      expect(state().planOfferFailed, isFalse);
      expect(state().planOffer?.recurring, isTrue);
    });

    testWidgets('closing the sheet says nothing; a failure says why', (
      WidgetTester tester,
    ) async {
      await open(tester);
      await toPlan(tester);

      sheet.next = const CheckoutCancelled();
      await act(tester, () => chat().startPlan());
      expect(state().step, OnboardingStep.plan);
      expect(state().planError, isNull);
      expect(state().planBusy, isFalse);

      sheet.next = const CheckoutFailed(message: 'Card declined');
      await act(tester, () => chat().startPlan());
      expect(state().step, OnboardingStep.plan);
      expect(state().planError, 'Card declined');

      sheet.next = const CheckoutPaid(paymentId: 'pay_2', signature: 'sig_2');
      await act(tester, () => chat().startPlan());
      expect(state().step, OnboardingStep.cvUpload);
    });

    testWidgets('a phone with no UPI app is sold the pass, never a mandate '
        'it has nowhere to approve', (WidgetTester tester) async {
      final _Pricing pricing = _Pricing();
      await open(tester, pricing: pricing, probe: const _Probe(false));
      await toPlan(tester);

      expect(state().planOffer?.recurring, isFalse);
      expect(state().planOffer?.priceLabel, '₹399');
      await act(tester, () => chat().startPlan());
      expect(pricing.mandatesFor, isEmpty);
      expect(pricing.ordersFor, <String>['IN']);
      expect(sheet.recurring, <bool>[false]);
      expect(state().step, OnboardingStep.cvUpload);
    });

    testWidgets('a closed or failed UPI AutoPay sheet leaves a way out named '
        '— the step has no skip', (WidgetTester tester) async {
      await open(tester);
      await toPlan(tester);
      expect(state().planSheetUnfinished, isFalse);

      sheet.next = const CheckoutCancelled();
      await act(tester, () => chat().startPlan());
      expect(state().planError, isNull);
      expect(state().planSheetUnfinished, isTrue);

      sheet.next = const CheckoutFailed(message: 'UPI app not found');
      await act(tester, () => chat().startPlan());
      expect(state().planSheetUnfinished, isTrue);

      sheet.next = const CheckoutPaid(paymentId: 'pay_2', signature: 'sig_2');
      await act(tester, () => chat().startPlan());
      expect(state().step, OnboardingStep.cvUpload);
    });

    testWidgets('the panel says the way out on UPI AutoPay only', (
      WidgetTester tester,
    ) async {
      // Built here, not read off the fake backend: its latency is a timer,
      // which a widget test's clock would never let finish.
      const PlanPricing india = PlanPricing(
        personalPrice: 399,
        companyPrice: 1199,
        isIndia: true,
      );
      final PlanOffer autopay = PlanOffer.decide(
        pricing: india,
        config: PaymentConfig(
          indiaTokenAutopay: true,
          tokenOffer: TokenOffer(
            kind: MandateKind.trial,
            registrationPaise: 100,
            registrationRefunded: true,
            monthlyPaise: 39900,
            maxAmountPaise: 39900,
            freeDays: 30,
            copyVersion: kAutopayCheckoutCopyVersion,
            firstChargeAt: DateTime.utc(2026, 12, 22, 4, 30),
          ),
        ),
        planType: 'personal',
      )!;
      final PlanOffer pass = PlanOffer.decide(
        pricing: india,
        config: const PaymentConfig(),
        planType: 'personal',
      )!;
      expect(autopay.recurring, isTrue);
      expect(pass.recurring, isFalse);

      Future<void> panel(PlanOffer offer, {required bool unfinished}) =>
          tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: SingleChildScrollView(
                  child: PlanPanel(
                    offer: offer,
                    failed: false,
                    busy: false,
                    error: null,
                    sheetUnfinished: unfinished,
                    onStart: () {},
                    onRetry: () {},
                  ),
                ),
              ),
            ),
          );

      await panel(autopay, unfinished: false);
      expect(find.text(PlanPanel.wayOut), findsNothing);
      await panel(autopay, unfinished: true);
      expect(find.text(PlanPanel.wayOut), findsOneWidget);
      // The pass needs no UPI app.
      await panel(pass, unfinished: true);
      expect(find.text(PlanPanel.wayOut), findsNothing);
    });

    testWidgets('a plan set up elsewhere since the step opened moves them on', (
      WidgetTester tester,
    ) async {
      final _Pricing pricing = _Pricing()..alreadySubscribed = true;
      await open(tester, pricing: pricing);
      await toPlan(tester);

      await act(tester, () => chat().startPlan());
      // The server's 409 is not an error on a step with no skip.
      expect(state().planError, isNull);
      expect(sheet.opened, isEmpty);
      final ChatMessage echo = state().messages.firstWhere(
        (ChatMessage m) =>
            m.role == ChatRole.user && m.text == 'I already have a plan',
      );
      expect(echo.badge, 'Plan active');
      expect(state().step, OnboardingStep.cvUpload);
    });

    testWidgets('skipping the connect does not skip the plan', (
      WidgetTester tester,
    ) async {
      await open(tester);
      await act(tester, () => chat().acknowledgeWelcome());
      // A failed attempt is what unlocks "I'll connect later".
      container.read(onboardingChatControllerProvider.notifier).state = state()
          .copyWith(connectFailed: true);
      await act(tester, () => chat().skipConnect());
      // Nor the State that comes before it.
      expect(state().step, OnboardingStep.billingState);
      await act(tester, () => chat().saveBillingState('27'));
      expect(state().step, OnboardingStep.plan);
    });
  });

  group('the buyer\'s GST State', () {
    Future<void> toState(WidgetTester tester) async {
      await act(tester, () => chat().acknowledgeWelcome());
      await act(tester, () => chat().connectLinkedin());
    }

    List<String> said() =>
        state().messages.map((ChatMessage m) => m.text).toList();

    testWidgets('India: asked once, straight before the plan, pre-selected '
        'from the region and saved only on the tap', (
      WidgetTester tester,
    ) async {
      final _Pricing pricing = _Pricing();
      await open(tester, pricing: pricing);
      await toState(tester);

      expect(state().step, OnboardingStep.billingState);
      expect(visited.sublist(visited.length - 2), <OnboardingStep>[
        OnboardingStep.connect,
        OnboardingStep.billingState,
      ]);
      // The web's line, word for word.
      expect(
        said().last,
        'Which State are you in? It is printed on your GST '
        'invoices.',
      );
      // The server's reading of the region pre-selects; nothing is saved
      // until the buyer taps.
      expect(state().billingStatePreset, '27');
      expect(pricing.stateSaves, isEmpty);

      await act(tester, () => chat().saveBillingState('29'));
      expect(pricing.stateSaves, <String>['29:onboarding']);
      final ChatMessage echo = state().messages.lastWhere(
        (ChatMessage m) => m.role == ChatRole.user,
      );
      expect(echo.text, 'Karnataka');
      expect(echo.badge, 'State saved');
      expect(state().step, OnboardingStep.plan);
      expect(said().last, OnboardingChatController.planAsk(state().planOffer));

      // Asked once: the checkout opens with no second ask.
      await act(tester, () => chat().startPlan());
      expect(state().planAskingState, isFalse);
      expect(sheet.opened, hasLength(1));
      expect(pricing.stateSaves, hasLength(1));
      expect(
        said().where(
          (String l) => l == OnboardingChatController.billingStateAsk,
        ),
        hasLength(1),
      );
      expect(state().step, OnboardingStep.cvUpload);
    });

    testWidgets('the picker cannot submit an empty or unknown State', (
      WidgetTester tester,
    ) async {
      final _Pricing pricing = _Pricing();
      await open(tester, pricing: pricing);
      await toState(tester);

      for (final String code in <String>['', '  ', '97', '00', 'MH']) {
        await act(tester, () => chat().saveBillingState(code));
      }
      expect(pricing.stateSaves, isEmpty);
      expect(state().step, OnboardingStep.billingState);
      expect(state().billingStateSaving, isFalse);
    });

    testWidgets('a buyer outside India is never asked', (
      WidgetTester tester,
    ) async {
      final _Pricing pricing = _Pricing(abroad: true);
      await open(tester, pricing: pricing);
      await toState(tester);

      expect(state().step, OnboardingStep.plan);
      expect(said(), isNot(contains(OnboardingChatController.billingStateAsk)));

      await act(tester, () => chat().startPlan());
      expect(state().planAskingState, isFalse);
      expect(pricing.ordersFor, <String>['US']);
      expect(pricing.stateSaves, isEmpty);
      expect(state().step, OnboardingStep.cvUpload);
    });

    testWidgets('a State already on record is not asked again', (
      WidgetTester tester,
    ) async {
      final _Pricing pricing = _Pricing();
      await pricing.saveBillingState(
        stateCode: '07',
        source: BillingStateSource.settings,
      );
      await open(tester, pricing: pricing);
      await toState(tester);

      expect(state().step, OnboardingStep.plan);
      expect(said(), isNot(contains(OnboardingChatController.billingStateAsk)));
      await act(tester, () => chat().startPlan());
      expect(sheet.opened, hasLength(1));
      expect(pricing.stateSaves, <String>['07:settings']);
    });

    testWidgets('a State that cannot be read steps aside, and the plan step '
        'asks it inline before the checkout opens', (
      WidgetTester tester,
    ) async {
      final _Pricing pricing = _Pricing()..stateUnreadable = true;
      await open(tester, pricing: pricing);
      await toState(tester);

      // Our outage is never a dead end: on to the plan without a word.
      expect(state().step, OnboardingStep.plan);
      expect(said(), isNot(contains(OnboardingChatController.billingStateAsk)));

      // Readable again by the time they press: the checkout asks first.
      pricing.stateUnreadable = false;
      await act(tester, () => chat().startPlan());
      expect(state().planAskingState, isTrue);
      expect(state().billingStatePreset, '27');
      expect(sheet.opened, isEmpty);
      expect(pricing.mandatesFor, isEmpty);

      await act(tester, () => chat().saveCheckoutState('29'));
      expect(pricing.stateSaves, <String>['29:checkout']);
      expect(state().planAskingState, isFalse);
      expect(sheet.opened, hasLength(1));
      expect(pricing.mandatesFor, <String>['IN']);
      expect(state().step, OnboardingStep.cvUpload);
    });

    testWidgets('a State that still cannot be read lets the payment go ahead', (
      WidgetTester tester,
    ) async {
      final _Pricing pricing = _Pricing()..stateUnreadable = true;
      await open(tester, pricing: pricing);
      await toState(tester);

      await act(tester, () => chat().startPlan());
      expect(state().planAskingState, isFalse);
      expect(sheet.opened, hasLength(1));
      expect(state().step, OnboardingStep.cvUpload);
    });

    testWidgets('Cancel on the inline ask drops the payment, not the step', (
      WidgetTester tester,
    ) async {
      final _Pricing pricing = _Pricing()..stateUnreadable = true;
      await open(tester, pricing: pricing);
      await toState(tester);
      pricing.stateUnreadable = false;

      await act(tester, () => chat().startPlan());
      expect(state().planAskingState, isTrue);
      chat().cancelCheckoutState();
      await settle(tester);
      expect(state().planAskingState, isFalse);
      expect(state().step, OnboardingStep.plan);
      expect(sheet.opened, isEmpty);
      expect(pricing.stateSaves, isEmpty);
    });

    testWidgets('a failed save says why and keeps the question up', (
      WidgetTester tester,
    ) async {
      final _Pricing pricing = _Pricing()
        ..stateSaveFails = 'Could not save your State. Try again.';
      await open(tester, pricing: pricing);
      await toState(tester);

      await act(tester, () => chat().saveBillingState('29'));
      expect(state().step, OnboardingStep.billingState);
      expect(
        state().billingStateError,
        'Could not save your State. Try again.',
      );
      expect(state().billingStateSaving, isFalse);

      await act(tester, () => chat().saveBillingState('29'));
      expect(state().billingStateError, isNull);
      expect(state().step, OnboardingStep.plan);
    });
  });
}

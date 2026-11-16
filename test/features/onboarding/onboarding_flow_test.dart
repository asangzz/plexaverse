import 'dart:async';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/core/access/company_brand.dart';
import 'package:plexaverse/core/config/env.dart';
import 'package:plexaverse/core/network/failure.dart';
import 'package:plexaverse/core/platform/checkout.dart';
import 'package:plexaverse/core/platform/file_picking.dart';
import 'package:plexaverse/core/platform/image_picking.dart';
import 'package:plexaverse/features/onboarding/application/onboarding_chat_controller.dart';
import 'package:plexaverse/features/onboarding/data/onboarding_repositories.dart';
import 'package:plexaverse/features/onboarding/domain/onboarding_repository.dart';
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
  }) async {
    opened.add(subscriptionId ?? orderId);
    return next;
  }
}

/// The mock pricing backend, from somewhere other than India — or nowhere
/// readable at all.
class _Pricing extends FakePricingRepository {
  _Pricing({this.abroad = false, this.unreadable = false});

  final bool abroad;
  bool unreadable;

  /// The server's 409 ALREADY_SUBSCRIBED on the next mandate.
  bool alreadySubscribed = false;
  final List<String> ordersFor = <String>[];
  final List<String?> subscriptionsFor = <String?>[];

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
  Future<CheckoutIntent> createSubscription({
    required String planType,
    String? countryCode,
  }) {
    subscriptionsFor.add(countryCode);
    if (alreadySubscribed) {
      final RequestOptions request = RequestOptions(
        path: '/subscription/create',
      );
      return Future<CheckoutIntent>.error(
        DioException(
          requestOptions: request,
          response: Response<dynamic>(requestOptions: request, statusCode: 409),
          error: const ClientFailure(
            message: 'You already have a plan, so there is nothing to set up.',
            errorCode: 'ALREADY_SUBSCRIBED',
          ),
        ),
      );
    }
    return super.createSubscription(
      planType: planType,
      countryCode: countryCode,
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
  }) async {
    sheet = _Sheet();
    container = ProviderContainer(
      overrides: [
        envProvider.overrideWithValue(Env.mock),
        filePickingProvider.overrideWithValue(_Files()),
        imagePickingProvider.overrideWithValue(_Images()),
        checkoutProvider.overrideWithValue(sheet),
        companyBrandOpenProvider.overrideWithValue(companyOpen),
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
      OnboardingStep.plan,
      OnboardingStep.cvUpload,
      OnboardingStep.currentRole,
      OnboardingStep.styleChoice,
      OnboardingStep.styleWrite,
      OnboardingStep.finish,
    ]);
    expect(state().answers.cv?.profession, 'Software Engineer');
    expect(state().answers.usedCvUpload, isFalse);
    expect(state().completed, isTrue);
  });

  testWidgets('personal, CV imported: straight to the voice, via screenshots', (
    WidgetTester tester,
  ) async {
    await open(tester);
    await act(tester, () => chat().acknowledgeWelcome());
    await act(tester, () => chat().connectLinkedin());
    await act(tester, () => chat().startPlan());
    await act(tester, () => chat().uploadCv());
    await act(tester, () => chat().chooseScreenshots());
    await act(tester, () => chat().uploadScreenshots());

    expect(visited, <OnboardingStep>[
      OnboardingStep.welcome,
      OnboardingStep.connect,
      OnboardingStep.plan,
      OnboardingStep.cvUpload,
      OnboardingStep.styleChoice,
      OnboardingStep.styleScreenshots,
      OnboardingStep.finish,
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
        OnboardingStep.plan,
        OnboardingStep.companyPage,
        OnboardingStep.companyLogo,
        OnboardingStep.posterStyle,
        OnboardingStep.companyDoc,
        OnboardingStep.companyDetails,
        OnboardingStep.styleChoice,
        OnboardingStep.styleWrite,
        OnboardingStep.finish,
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
    await act(tester, () => chat().startPlan());
    await act(tester, () => chat().switchToPersonal());
    await act(tester, () => chat().connectLinkedin());

    expect(visited.skip(2), <OnboardingStep>[
      OnboardingStep.connect,
      OnboardingStep.plan,
      OnboardingStep.companyPage,
      OnboardingStep.connect,
      OnboardingStep.plan,
    ]);
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
    Future<void> toPlan(WidgetTester tester) async {
      await act(tester, () => chat().acknowledgeWelcome());
      await act(tester, () => chat().connectLinkedin());
    }

    testWidgets('India: free first, a mandate, and the thread says so', (
      WidgetTester tester,
    ) async {
      final _Pricing pricing = _Pricing();
      await open(tester, pricing: pricing);
      await toPlan(tester);

      expect(state().step, OnboardingStep.plan);
      expect(state().planOffer?.recurring, isTrue);
      expect(state().planOffer?.priceLabel, '₹399');
      expect(
        state().messages.last.text,
        OnboardingChatController.planAsk(state().planOffer),
      );
      expect(state().messages.last.text, contains('first month is free'));
      // The ₹5 mandate check is a charge; the line must not deny it.
      expect(state().messages.last.text, isNot(contains('nothing is charged')));

      await act(tester, () => chat().startPlan());
      expect(pricing.subscriptionsFor, <String?>['IN']);
      expect(pricing.ordersFor, isEmpty);
      final ChatMessage echo = state().messages.firstWhere(
        (ChatMessage m) =>
            m.role == ChatRole.user && m.text == 'Autopay set up',
      );
      expect(echo.badge, 'Free month started');
      expect(state().step, OnboardingStep.cvUpload);
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
      expect(pricing.subscriptionsFor, isEmpty);
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

      expect(visited, <OnboardingStep>[
        OnboardingStep.welcome,
        OnboardingStep.connect,
        OnboardingStep.plan,
        OnboardingStep.cvUpload,
      ]);
      expect(sheet.opened, isEmpty);
      expect(
        state().messages.map((ChatMessage m) => m.text),
        isNot(contains(OnboardingChatController.planAsk(null))),
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
      expect(state().step, OnboardingStep.plan);
    });
  });
}

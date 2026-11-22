import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/core/network/failure.dart';
import 'package:plexaverse/core/platform/checkout.dart';
import 'package:plexaverse/features/pricing/application/plan_checkout.dart';
import 'package:plexaverse/features/pricing/data/pricing_repositories.dart';
import 'package:plexaverse/features/pricing/domain/pricing_repository.dart';

/// `PlanCheckout.registerAutopay` — the web's `useAutopayCheckout`, for the
/// app (TOKEN_AUTOPAY_SPEC.md §4.2-§4.3): each server refusal its own path,
/// and a payment the server cannot confirm yet never told to pay again.

DioException _refused(int status, String code, String message) {
  final RequestOptions request = RequestOptions(path: '/autopay/create');
  return DioException(
    requestOptions: request,
    response: Response<dynamic>(requestOptions: request, statusCode: status),
    error: status >= 500
        ? ServerFailure(message: message, errorCode: code, statusCode: status)
        : ClientFailure(message: message, errorCode: code, statusCode: status),
  );
}

class _Repo extends FakePricingRepository {
  /// Thrown by the next create, when set.
  Object? createFails;

  /// What create answers (overrides the fake's).
  MandateIntent? intent;

  /// What verify answers, or throws.
  MandateVerification verification = const MandateVerification(
    success: true,
    kind: MandateKind.trial,
    tokenStatus: 'confirmed',
  );
  Object? verifyFails;

  final List<String> copyVersions = <String>[];
  final List<String> countries = <String>[];
  final List<String> verifiedOrders = <String>[];

  @override
  Future<MandateIntent> createMandate({
    required String planType,
    required String countryCode,
    required String copyVersion,
  }) async {
    countries.add(countryCode);
    copyVersions.add(copyVersion);
    final Object? fails = createFails;
    if (fails != null) throw fails;
    return intent ??
        MandateIntent(
          orderId: 'order_1',
          customerId: 'cust_1',
          keyId: 'rzp_live_x',
          amountPaise: 100,
          currency: 'INR',
          monthlyPaise: 39900,
          maxAmountPaise: 39900,
          registrationRefunded: true,
          kind: MandateKind.trial,
          firstChargeAt: DateTime.utc(2026, 12, 16, 4, 30),
          freeDays: 30,
        );
  }

  @override
  Future<MandateVerification> verifyMandate({
    required String orderId,
    required String paymentId,
    required String signature,
  }) async {
    verifiedOrders.add(orderId);
    final Object? fails = verifyFails;
    if (fails != null) throw fails;
    return verification;
  }
}

class _Sheet implements CheckoutService {
  CheckoutResult next = const CheckoutPaid(paymentId: 'pay_1', signature: 's');
  final List<Map<String, Object?>> opened = <Map<String, Object?>>[];

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
    opened.add(<String, Object?>{
      'orderId': orderId,
      'customerId': customerId,
      'recurring': recurring,
      'amount': amountInPaise,
      'description': description,
    });
    return next;
  }
}

void main() {
  late _Repo repo;
  late _Sheet sheet;
  late PlanCheckout checkout;

  setUp(() {
    repo = _Repo();
    sheet = _Sheet();
    checkout = PlanCheckout(repo, sheet);
  });

  Future<PlanCheckoutOutcome> register() =>
      checkout.registerAutopay(planType: 'personal', countryCode: 'IN');

  test(
    'sets up a mandate: an order with its customer, recurring, verified',
    () async {
      final PlanCheckoutOutcome outcome = await register();
      expect(outcome, isA<PlanCheckoutDone>());
      expect((outcome as PlanCheckoutDone).kind, MandateKind.trial);
      expect(repo.countries, <String>['IN']);
      expect(repo.copyVersions, <String>[kAutopayCheckoutCopyVersion]);
      expect(sheet.opened.single['orderId'], 'order_1');
      expect(sheet.opened.single['customerId'], 'cust_1');
      expect(sheet.opened.single['recurring'], isTrue);
      expect(sheet.opened.single['amount'], isNull);
      // The sheet describes the ORDER the server opened.
      expect(
        sheet.opened.single['description'],
        'UPI Autopay: ₹1 today (refunded), ₹399 a month from 16 Dec',
      );
      expect(repo.verifiedOrders, <String>['order_1']);
    },
  );

  test(
    '409 ALREADY_SUBSCRIBED is the plan already active, not a failure',
    () async {
      repo.createFails = _refused(
        409,
        'ALREADY_SUBSCRIBED',
        'You already have a plan, so there is nothing to set up.',
      );
      final PlanCheckoutOutcome outcome = await register();
      expect(outcome, isA<PlanCheckoutAlreadyActive>());
      expect(
        (outcome as PlanCheckoutAlreadyActive).message,
        'You already have a plan, so there is nothing to set up.',
      );
      expect(sheet.opened, isEmpty);
    },
  );

  test(
    '409 MANDATE_PENDING is pending: confirming, never a second sheet',
    () async {
      repo.createFails = _refused(
        409,
        'MANDATE_PENDING',
        'Your autopay is being confirmed with your bank.',
      );
      expect(await register(), isA<PlanCheckoutPending>());
      expect(sheet.opened, isEmpty);
    },
  );

  test(
    '409 MANDATE_IN_PROGRESS says another window is setting it up',
    () async {
      repo.createFails = _refused(409, 'MANDATE_IN_PROGRESS', '');
      final PlanCheckoutOutcome outcome = await register();
      expect(
        (outcome as PlanCheckoutFailed).message,
        'Autopay is being set up in another window. Try again in a minute.',
      );
      expect(outcome.offerStale, isFalse);
    },
  );

  test('400 AUTOPAY_DISABLED shows the server\'s sentence and marks the '
      'offer stale', () async {
    repo.createFails = _refused(
      400,
      'AUTOPAY_DISABLED',
      'Autopay is not available right now. You can pay for one month instead.',
    );
    final PlanCheckoutOutcome outcome = await register();
    expect(
      (outcome as PlanCheckoutFailed).message,
      'Autopay is not available right now. You can pay for one month instead.',
    );
    expect(outcome.offerStale, isTrue);
    expect(sheet.opened, isEmpty);
  });

  test(
    'an empty order or customer from the server never opens a sheet',
    () async {
      repo.createFails = StateError('autopay/create returned no customer');
      final PlanCheckoutOutcome outcome = await register();
      expect(outcome, isA<PlanCheckoutFailed>());
      expect(sheet.opened, isEmpty);
    },
  );

  test('no Razorpay key: refused before the sheet', () async {
    repo.intent = const MandateIntent(
      orderId: 'order_1',
      customerId: 'cust_1',
      keyId: null,
      amountPaise: 100,
      currency: 'INR',
      monthlyPaise: 39900,
      maxAmountPaise: 39900,
      registrationRefunded: true,
    );
    expect(await register(), isA<PlanCheckoutFailed>());
    expect(sheet.opened, isEmpty);
  });

  test('verify: a token still initiated, or pending, is pending', () async {
    repo.verification = const MandateVerification(
      success: true,
      tokenStatus: 'initiated',
    );
    expect(await register(), isA<PlanCheckoutPending>());

    repo.verification = const MandateVerification(success: true, pending: true);
    expect(await register(), isA<PlanCheckoutPending>());
  });

  test(
    'verify: a duplicate payment means the plan was already set up',
    () async {
      repo.verification = const MandateVerification(
        success: true,
        duplicate: true,
        tokenStatus: 'confirmed',
      );
      expect(await register(), isA<PlanCheckoutAlreadyActive>());
    },
  );

  test(
    'verify: a payment that set nothing up says so in the server\'s words',
    () async {
      repo.verifyFails = _refused(
        400,
        'VALIDATION_FAILED',
        AutopayRefusals.failed,
      );
      final PlanCheckoutOutcome outcome = await register();
      expect((outcome as PlanCheckoutFailed).message, AutopayRefusals.failed);
    },
  );

  test('verify: anything else unconfirmed never says "try again"', () async {
    repo.verifyFails = _refused(500, 'INTERNAL', 'Something broke');
    final PlanCheckoutOutcome outcome = await register();
    expect(
      (outcome as PlanCheckoutFailed).message,
      'We could not confirm your autopay yet. If your UPI app shows it as set '
      'up, it will appear here shortly. There is no need to pay again.',
    );

    repo
      ..verifyFails = null
      ..verification = const MandateVerification(success: false);
    expect(
      ((await register()) as PlanCheckoutFailed).message,
      AutopayCheckoutCopy.unconfirmed,
    );
  });

  test('a closed sheet is silence; no verify', () async {
    sheet.next = const CheckoutCancelled();
    expect(await register(), isA<PlanCheckoutDismissed>());
    expect(repo.verifiedOrders, isEmpty);
  });

  test('the pass: ALREADY_SUBSCRIBED from create-order moves on, with the '
      'server\'s sentence', () async {
    final _PassRefused passRepo = _PassRefused();
    final PlanCheckoutOutcome outcome = await PlanCheckout(
      passRepo,
      sheet,
    ).payForMonth(planType: 'personal', countryCode: 'IN');
    expect(outcome, isA<PlanCheckoutAlreadyActive>());
    expect(
      (outcome as PlanCheckoutAlreadyActive).message,
      'You already have a plan through UPI AutoPay, so there is nothing to '
      'buy right now.',
    );
    expect(sheet.opened, isEmpty);
  });
}

class _PassRefused extends FakePricingRepository {
  @override
  Future<OrderIntent> createOrder({
    required String planType,
    required String countryCode,
  }) async => throw _refused(
    409,
    'ALREADY_SUBSCRIBED',
    'You already have a plan through UPI AutoPay, so there is nothing to buy '
        'right now.',
  );
}

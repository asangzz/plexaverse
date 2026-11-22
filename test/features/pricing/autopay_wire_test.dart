import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/core/network/api_paths.dart';
import 'package:plexaverse/core/network/dio_client.dart';
import 'package:plexaverse/core/network/failure.dart';
import 'package:plexaverse/core/network/interceptors/error_interceptor.dart';
import 'package:plexaverse/features/pricing/application/plan_checkout.dart';
import 'package:plexaverse/features/pricing/data/pricing_repositories.dart';
import 'package:plexaverse/features/pricing/domain/pricing_repository.dart';

/// The four `/autopay/*` mobile routes and the payment config as the server
/// answers them (`app/api/mobile/v1/autopay/*`, `payment/config` on the web):
/// the body inside `data`, a refusal as `{error: {code, message}}`.
class _Canned implements HttpClientAdapter {
  _Canned(this.status, this.body);

  final int status;
  final Object body;
  final List<RequestOptions> seen = <RequestOptions>[];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    seen.add(options);
    return ResponseBody.fromString(
      jsonEncode(body),
      status,
      headers: <String, List<String>>{
        Headers.contentTypeHeader: <String>[Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

(ApiPricingRepository, _Canned) _repo(int status, Object body) {
  final _Canned adapter = _Canned(status, body);
  final Dio dio = Dio(BaseOptions(baseUrl: 'https://example.test'))
    ..httpClientAdapter = adapter
    ..interceptors.add(ErrorInterceptor());
  return (ApiPricingRepository(DioClient(dio)), adapter);
}

Map<String, dynamic> _ok(Object data) => <String, dynamic>{
  'data': data,
  'error': null,
};

Map<String, dynamic> _created({String? orderId, String? customerId}) =>
    <String, dynamic>{
      'orderId': ?orderId,
      'customerId': ?customerId,
      'keyId': 'rzp_live_x',
      'amount': 100,
      'currency': 'INR',
      'recurring': '1',
      'kind': 'trial',
      'firstChargeAt': '2026-12-16T04:30:00.000Z',
      'monthlyAmount': 39900,
      'maxAmount': 39900,
      'mandateExpiresAt': '2029-11-22T00:00:00.000Z',
      'freeDays': 30,
      'registrationRefunded': true,
      'reused': false,
    };

void main() {
  test('create posts the plan, the country and the copy version', () async {
    final (ApiPricingRepository repo, _Canned wire) = _repo(
      200,
      _ok(_created(orderId: 'order_1', customerId: 'cust_1')),
    );
    final MandateIntent intent = await repo.createMandate(
      planType: 'personal',
      countryCode: 'IN',
      copyVersion: kAutopayCheckoutCopyVersion,
    );
    expect(wire.seen.single.path, ApiPaths.autopayCreate);
    expect(wire.seen.single.data, <String, dynamic>{
      'planType': 'personal',
      'countryCode': 'IN',
      'copyVersion': 'upi-autopay-2026-11-21',
    });
    expect(intent.orderId, 'order_1');
    expect(intent.customerId, 'cust_1');
    expect(intent.amountPaise, 100);
    expect(intent.kind, MandateKind.trial);
  });

  test(
    'create THROWS on an empty order or customer — never `?? \'\'`',
    () async {
      for (final Map<String, dynamic> body in <Map<String, dynamic>>[
        _created(customerId: 'cust_1'),
        _created(orderId: '', customerId: 'cust_1'),
        _created(orderId: 'order_1'),
        _created(orderId: 'order_1', customerId: ''),
      ]) {
        final (ApiPricingRepository repo, _) = _repo(200, _ok(body));
        await expectLater(
          repo.createMandate(
            planType: 'personal',
            countryCode: 'IN',
            copyVersion: kAutopayCheckoutCopyVersion,
          ),
          throwsStateError,
          reason: '$body',
        );
      }
    },
  );

  test('a refusal carries the server\'s code and sentence', () async {
    final (ApiPricingRepository repo, _) = _repo(409, <String, dynamic>{
      'data': null,
      'error': <String, dynamic>{
        'code': 'MANDATE_PENDING',
        'message': 'Your autopay is being confirmed with your bank.',
      },
    });
    try {
      await repo.createMandate(
        planType: 'personal',
        countryCode: 'IN',
        copyVersion: kAutopayCheckoutCopyVersion,
      );
      fail('expected a refusal');
    } on DioException catch (e) {
      expect(PlanCheckout.errorCode(e), 'MANDATE_PENDING');
      expect(
        PlanCheckout.serverMessage(e),
        'Your autopay is being confirmed with your bank.',
      );
      expect(e.error, isA<ClientFailure>());
    }
  });

  test('verify posts the three Razorpay fields and reads pending', () async {
    final (ApiPricingRepository repo, _Canned wire) = _repo(
      200,
      _ok(<String, dynamic>{
        'success': true,
        'pending': true,
        'duplicate': false,
        'kind': 'trial',
        'tokenStatus': 'initiated',
        'firstChargeAt': '2026-12-16T04:30:00.000Z',
        'paidThrough': null,
        'xpAwarded': 0,
        'newBalance': null,
      }),
    );
    final MandateVerification v = await repo.verifyMandate(
      orderId: 'order_1',
      paymentId: 'pay_1',
      signature: 'sig_1',
    );
    expect(wire.seen.single.path, ApiPaths.autopayVerify);
    expect(wire.seen.single.data, <String, dynamic>{
      'razorpayOrderId': 'order_1',
      'razorpayPaymentId': 'pay_1',
      'razorpaySignature': 'sig_1',
    });
    expect(v.success, isTrue);
    expect(v.awaitingBank, isTrue);
  });

  test('status and stop read the server\'s fields', () async {
    final (ApiPricingRepository status, _) = _repo(
      200,
      _ok(<String, dynamic>{
        'rail': 'token',
        'tokenStatus': 'confirmed',
        'canStop': true,
        'stopped': false,
        'nextChargeAt': '2026-12-16T04:30:00.000Z',
        'nextChargeAmountPaise': 100,
        'monthlyPaise': 39900,
        'accessUntil': '2026-12-16T04:30:00.000Z',
        'inTrial': true,
        'trialEndsAt': '2026-12-16T04:30:00.000Z',
        'debitInFlight': false,
      }),
    );
    final AutopayStatus s = await status.fetchAutopayStatus();
    expect(s.live, isTrue);
    // Two figures, never confused: the next period's frozen amount (a test
    // lever's ₹1 here) and the plan a new registration is for.
    expect(s.nextChargeAmountPaise, 100);
    expect(s.monthlyPaise, 39900);
    expect(s.inTrial, isTrue);

    final (ApiPricingRepository stop, _Canned wire) = _repo(
      200,
      _ok(<String, dynamic>{
        'stopped': true,
        'revokeConfirmed': false,
        'debitInFlight': true,
        'alreadyStopped': false,
        'inTrial': true,
        'accessUntil': '2026-12-16T04:30:00.000Z',
      }),
    );
    final StopAutopayResult r = await stop.stopAutopay();
    expect(wire.seen.single.path, ApiPaths.autopayStop);
    expect(wire.seen.single.method, 'POST');
    expect(r.stopped, isTrue);
    expect(r.debitInFlight, isTrue);
  });

  test('an unreadable status is PricingUnavailable', () async {
    final (ApiPricingRepository repo, _) = _repo(500, <String, dynamic>{
      'data': null,
      'error': <String, dynamic>{'code': 'INTERNAL', 'message': 'x'},
    });
    await expectLater(
      repo.fetchAutopayStatus(),
      throwsA(isA<PricingUnavailable>()),
    );
  });

  test('the config the server sends while dark sells the pass', () async {
    final (ApiPricingRepository repo, _) = _repo(
      200,
      _ok(<String, dynamic>{
        'indiaAutopay': false,
        'intlAutopay': false,
        'indiaTokenAutopay': false,
        'tokenOffer': null,
      }),
    );
    final PaymentConfig c = await repo.fetchPaymentConfig();
    expect(c.tokenOffer, isNull);
    expect(c.tokenOfferUnavailable, isFalse);
    expect(
      PlanOffer.decide(
        pricing: const PlanPricing(personalPrice: 399),
        config: c,
        planType: 'personal',
      )?.recurring,
      isFalse,
    );
  });
}

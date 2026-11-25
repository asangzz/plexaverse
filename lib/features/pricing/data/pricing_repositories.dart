import 'package:dio/dio.dart'
    show DioException, Options, RequestOptions, Response, ResponseType;
import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/env.dart';
import '../../../core/network/api_paths.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/network/failure.dart';
import '../domain/consistency_reward.dart';
import '../domain/pricing_repository.dart';

/// Dio-backed [PricingRepository].
///
/// [DioClient] already unwraps the `{data, error, meta}` envelope, so on
/// success `response.data` is the inner object.
class ApiPricingRepository implements PricingRepository {
  const ApiPricingRepository(this._client);

  final DioClient _client;

  @override
  Future<PlanPricing> fetchPricing({String? countryCode}) async {
    try {
      final response = await _client.get<Map<String, dynamic>>(
        ApiPaths.geoPricing,
        queryParameters: countryCode == null
            ? null
            : <String, dynamic>{'country': countryCode},
      );
      final Map<String, dynamic>? data = response.data;
      if (data == null) throw const PricingUnavailable();
      return PlanPricing.fromJson(data);
    } on PricingUnavailable {
      rethrow;
    } on Object {
      throw const PricingUnavailable();
    }
  }

  @override
  Future<String?> fetchBrandType() async {
    try {
      final response = await _client.get<Map<String, dynamic>>(
        ApiPaths.userPreferences,
      );
      final Map<String, dynamic>? data = response.data;
      // `{exists: false}` is the server's sentinel for a user who has not
      // onboarded. Not an error, and not a brand either.
      if (data == null || data['exists'] != true) return null;
      return data['brandType'] as String?;
    } on Object {
      // Deliberately swallowed: a failed brandType read must not take the
      // price list down with it. Both plans then render, which is a superset
      // of the truth rather than a wrong subset.
      return null;
    }
  }

  @override
  Future<List<Allowance>> fetchAllowances() async {
    try {
      final response = await _client.get<Map<String, dynamic>>(
        ApiPaths.userAllowances,
      );
      final Map<String, dynamic>? data = response.data;
      if (data == null) throw const PricingUnavailable();
      return Allowance.listFromJson(data);
    } on PricingUnavailable {
      rethrow;
    } on Object {
      throw const PricingUnavailable();
    }
  }

  @override
  Future<ReferralSummary> fetchReferral() async {
    try {
      final response = await _client.get<Map<String, dynamic>>(
        ApiPaths.referral,
      );
      final Map<String, dynamic>? data = response.data;
      if (data == null) return const ReferralSummary();
      return ReferralSummary.fromWire(data);
    } on Object {
      throw const PricingUnavailable();
    }
  }

  @override
  Future<ReferralSummary> generateReferralCode() async {
    try {
      final response = await _client.post<Map<String, dynamic>>(
        ApiPaths.referral,
      );
      // POST answers `{code}` only — no counters. Re-read rather than
      // inventing zeroes, which would blank a returning user's referral count.
      final String? code = response.data?['code'] as String?;
      final ReferralSummary current = await fetchReferral();
      return current.code == null && code != null
          ? current.copyWith(code: code)
          : current;
    } on PricingUnavailable {
      rethrow;
    } on Object {
      throw const PricingUnavailable();
    }
  }

  @override
  Future<PaymentConfig> fetchPaymentConfig() async {
    try {
      final response = await _client.get<Map<String, dynamic>>(
        ApiPaths.paymentConfig,
      );
      final Map<String, dynamic>? data = response.data;
      if (data == null) throw const PricingUnavailable();
      return PaymentConfig.fromJson(data);
    } on PricingUnavailable {
      rethrow;
    } on Object {
      throw const PricingUnavailable();
    }
  }

  @override
  Future<MandateIntent> createMandate({
    required String planType,
    required String countryCode,
    required String copyVersion,
  }) async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiPaths.autopayCreate,
      data: <String, dynamic>{
        'planType': planType,
        'countryCode': countryCode,
        'copyVersion': copyVersion,
      },
    );
    final Map<String, dynamic>? data = response.data;
    if (data == null) throw StateError('autopay/create returned nothing');
    // Throws on an empty order or customer — never `?? ''`.
    return MandateIntent.fromJson(data);
  }

  @override
  Future<MandateVerification> verifyMandate({
    required String orderId,
    required String paymentId,
    required String signature,
  }) async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiPaths.autopayVerify,
      data: <String, dynamic>{
        'razorpayOrderId': orderId,
        'razorpayPaymentId': paymentId,
        'razorpaySignature': signature,
      },
    );
    final Map<String, dynamic>? data = response.data;
    if (data == null) return const MandateVerification(success: false);
    return MandateVerification.fromJson(data);
  }

  @override
  Future<StopAutopayResult> stopAutopay() async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiPaths.autopayStop,
    );
    final Map<String, dynamic>? data = response.data;
    if (data == null) throw StateError('autopay/stop returned nothing');
    return StopAutopayResult.fromJson(data);
  }

  @override
  Future<AutopayStatus> fetchAutopayStatus() async {
    try {
      final response = await _client.get<Map<String, dynamic>>(
        ApiPaths.autopayStatus,
      );
      final Map<String, dynamic>? data = response.data;
      if (data == null) throw const PricingUnavailable();
      return AutopayStatus.fromJson(data);
    } on PricingUnavailable {
      rethrow;
    } on Object {
      throw const PricingUnavailable();
    }
  }

  @override
  Future<ConsistencyRewardConsent> fetchConsistencyReward() async {
    try {
      final response = await _client.get<Map<String, dynamic>>(
        ApiPaths.billingConsistencyReward,
      );
      final Map<String, dynamic>? data = response.data;
      if (data == null) throw const PricingUnavailable();
      return ConsistencyRewardConsent.fromJson(data);
    } on PricingUnavailable {
      rethrow;
    } on Object {
      // A 404 (a server older than the route), a 401, a malformed body: the
      // section is simply not shown — it never blocks Billing.
      throw const PricingUnavailable();
    }
  }

  @override
  Future<ConsistencyRewardConsent> setConsistencyReward({
    required bool consented,
    String? wordsVersion,
  }) async {
    try {
      final response = await _client.put<Map<String, dynamic>>(
        ApiPaths.billingConsistencyReward,
        data: <String, dynamic>{
          'consented': consented,
          // Only with a yes: a withdrawal never needs the words (DPDP s6(4)).
          if (consented) 'wordsVersion': wordsVersion,
        },
      );
      final Map<String, dynamic>? data = response.data;
      if (data == null) throw const ConsistencyRewardFailure();
      return ConsistencyRewardConsent.fromJson(data);
    } on DioException catch (e) {
      final Object? failure = e.error;
      final String? message = failure is Failure ? failure.message : null;
      final String? code = failure is Failure ? failure.errorCode : null;
      if (code == 'UPDATE_REQUIRED') {
        throw ConsistencyRewardUpdateRequired(
          message == null || message.isEmpty
              ? 'The words have changed — read them again below, then '
                    'switch it on.'
              : message,
        );
      }
      throw ConsistencyRewardFailure(
        message == null || message.isEmpty ? kRewardSaveFailed : message,
      );
    } on ConsistencyRewardFailure {
      rethrow;
    } on Object {
      throw const ConsistencyRewardFailure();
    }
  }

  @override
  Future<List<TaxDocument>> fetchTaxDocuments() async {
    try {
      final response = await _client.get<Map<String, dynamic>>(
        ApiPaths.billingInvoices,
      );
      final Map<String, dynamic>? data = response.data;
      if (data == null) throw const PricingUnavailable();
      return TaxDocument.listFromJson(data);
    } on DioException catch (e) {
      // A server older than the route answers 404, and a signed-out read
      // 401: neither has documents to show, and neither is worth an error
      // under every user's billing section (the web reads 401 as empty too).
      if (e.error is NotFoundFailure || e.error is AuthFailure) {
        return const <TaxDocument>[];
      }
      throw const PricingUnavailable();
    } on PricingUnavailable {
      rethrow;
    } on Object {
      throw const PricingUnavailable();
    }
  }

  @override
  Future<String> fetchTaxDocumentHtml(String id) async {
    try {
      // Plain: the success body is the page itself, not the JSON envelope.
      // [DioClient] passes a non-Map body through untouched.
      final response = await _client.get<String>(
        ApiPaths.billingInvoice(id),
        options: Options(responseType: ResponseType.plain),
      );
      final String? html = response.data;
      // A body that is not markup is not the document, whatever its status.
      if (html == null || !html.trimLeft().startsWith('<')) {
        throw const PricingUnavailable();
      }
      return html;
    } on PricingUnavailable {
      rethrow;
    } on Object {
      throw const PricingUnavailable();
    }
  }

  @override
  Future<BillingState> fetchBillingState() async {
    try {
      final response = await _client.get<Map<String, dynamic>>(
        ApiPaths.userBillingState,
      );
      final Map<String, dynamic>? data = response.data;
      if (data == null) throw const PricingUnavailable();
      return BillingState.fromJson(data);
    } on PricingUnavailable {
      rethrow;
    } on Object {
      throw const PricingUnavailable();
    }
  }

  @override
  Future<SavedBillingState> saveBillingState({
    required String stateCode,
    required BillingStateSource source,
  }) async {
    // Not wrapped: the server's 400 carries the sentence to show.
    final response = await _client.put<Map<String, dynamic>>(
      ApiPaths.userBillingState,
      data: <String, dynamic>{'stateCode': stateCode, 'source': source.wire},
    );
    final Map<String, dynamic>? data = response.data;
    if (data == null) throw StateError('user/billing-state returned nothing');
    return SavedBillingState.fromJson(data);
  }

  @override
  Future<OrderIntent> createOrder({
    required String planType,
    required String countryCode,
  }) async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiPaths.paymentCreateOrder,
      data: <String, dynamic>{'planId': planType, 'countryCode': countryCode},
    );
    final Map<String, dynamic>? data = response.data;
    final String? orderId = data?['orderId'] as String?;
    if (data == null || orderId == null || orderId.isEmpty) {
      throw StateError('payment/create-order returned no order');
    }
    return OrderIntent(
      orderId: orderId,
      keyId: data['keyId'] as String?,
      amount: (data['amount'] as num?)?.toInt() ?? 0,
      currency: (data['currency'] as String?) ?? 'INR',
    );
  }

  @override
  Future<bool> verifyOrder({
    required String orderId,
    required String paymentId,
    required String signature,
  }) async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiPaths.paymentVerify,
      data: <String, dynamic>{
        'razorpayOrderId': orderId,
        'razorpayPaymentId': paymentId,
        'razorpaySignature': signature,
      },
    );
    return response.data?['success'] == true;
  }
}

/// In-memory [PricingRepository] for the `mock` flavor.
///
/// Shaped like an Indian account with a referral code already issued, so the
/// populated branch of every block on the screen is exercisable without a
/// backend.
class FakePricingRepository implements PricingRepository {
  FakePricingRepository();

  static const Duration _latency = Duration(milliseconds: 350);

  ReferralSummary _referral = const ReferralSummary(
    code: 'PLEXA-7F2K',
    totalReferrals: 3,
  );

  @override
  Future<PlanPricing> fetchPricing({String? countryCode}) async {
    await Future<void>.delayed(_latency);
    return const PlanPricing(
      personalPrice: 399,
      companyPrice: 1199,
      subscriptionAmountInr: <String, int>{'personal': 399, 'company': 1199},
    );
  }

  @override
  Future<String?> fetchBrandType() async {
    await Future<void>.delayed(_latency);
    return 'personal';
  }

  /// The static table, with today's use filled in on two rows — enough for
  /// the "left today" branch to render without a backend.
  @override
  Future<List<Allowance>> fetchAllowances() async {
    await Future<void>.delayed(_latency);
    final DateTime tomorrow = DateTime.now().add(const Duration(days: 1));
    return <Allowance>[
      for (final Allowance a in Allowance.defaults)
        Allowance(
          key: a.key,
          label: a.label,
          limit: a.limit,
          period: a.period,
          used: switch (a.key) {
            'ai_generate_post' => 1,
            'ai_generate_comment' => 6,
            _ => 0,
          },
          remaining: switch (a.key) {
            'ai_generate_post' => a.limit - 1,
            'ai_generate_comment' => a.limit - 6,
            _ => a.limit,
          },
          resetsAt: tomorrow,
        ),
    ];
  }

  @override
  Future<ReferralSummary> fetchReferral() async {
    await Future<void>.delayed(_latency);
    return _referral;
  }

  @override
  Future<ReferralSummary> generateReferralCode() async {
    await Future<void>.delayed(_latency);
    _referral = _referral.copyWith(code: 'PLEXA-7F2K');
    return _referral;
  }

  /// The mock account's UPI AutoPay, as the fake server sees it: none yet,
  /// then live once a registration is verified, then stopped. The offer,
  /// the status and the checkout all read it, so the mock build walks the
  /// whole rail without a backend.
  _MockMandate _mandate = _MockMandate.none;
  DateTime? _trialEndsAt;

  /// A new account in India, on a rail that is switched on: the legacy flags
  /// false (as the server now always sends them) and a free-month offer.
  /// Once the mock mandate is live there is no offer (the server's
  /// registration guard); once it is stopped in the free month, the ₹399
  /// paid registration that starts where the kept month ends.
  @override
  Future<PaymentConfig> fetchPaymentConfig() async {
    await Future<void>.delayed(_latency);
    final DateTime now = DateTime.now();
    return switch (_mandate) {
      _MockMandate.none => PaymentConfig(
        indiaTokenAutopay: true,
        tokenOffer: TokenOffer(
          kind: MandateKind.trial,
          registrationPaise: 100,
          registrationRefunded: true,
          monthlyPaise: 39900,
          maxAmountPaise: 39900,
          freeDays: 30,
          firstChargeAt: now.add(const Duration(days: 30)),
          mandateExpiresAt: now.add(const Duration(days: 3 * 365)),
          copyVersion: kAutopayCheckoutCopyVersion,
        ),
      ),
      _MockMandate.live => const PaymentConfig(indiaTokenAutopay: true),
      _MockMandate.stopped => PaymentConfig(
        indiaTokenAutopay: true,
        tokenOffer: TokenOffer(
          kind: MandateKind.paid,
          registrationPaise: 39900,
          registrationRefunded: false,
          monthlyPaise: 39900,
          maxAmountPaise: 39900,
          freeDays: 0,
          firstChargeAt: _trialEndsAt,
          mandateExpiresAt: now.add(const Duration(days: 3 * 365)),
          copyVersion: kAutopayCheckoutCopyVersion,
          keptTrialEndsAt: _trialEndsAt,
        ),
      ),
    };
  }

  @override
  Future<MandateIntent> createMandate({
    required String planType,
    required String countryCode,
    required String copyVersion,
  }) async {
    await Future<void>.delayed(_latency);
    final bool paid = _mandate == _MockMandate.stopped;
    // A key, so the plan can be set up in the mock flavour: its sheet is
    // `MockCheckout`, which never reaches Razorpay with it.
    return MandateIntent(
      orderId: 'order_mock_mandate',
      customerId: 'cust_mock',
      keyId: 'rzp_test_mock',
      amountPaise: paid ? 39900 : 100,
      currency: 'INR',
      monthlyPaise: 39900,
      maxAmountPaise: 39900,
      registrationRefunded: !paid,
      kind: paid ? MandateKind.paid : MandateKind.trial,
      firstChargeAt: paid
          ? _trialEndsAt
          : DateTime.now().add(const Duration(days: 30)),
      freeDays: paid ? 0 : 30,
    );
  }

  @override
  Future<MandateVerification> verifyMandate({
    required String orderId,
    required String paymentId,
    required String signature,
  }) async {
    await Future<void>.delayed(_latency);
    final MandateKind kind = _mandate == _MockMandate.stopped
        ? MandateKind.paid
        : MandateKind.trial;
    _trialEndsAt ??= DateTime.now().add(const Duration(days: 30));
    _mandate = _MockMandate.live;
    if (kind == MandateKind.paid) {
      final int seq = _documents.length + 1;
      _documents.add(
        TaxDocument(
          id: 'inv_mock_$seq',
          kind: TaxDocumentKind.invoice,
          number: 'PX/2627/${seq.toString().padLeft(6, '0')}',
          issuedAt: DateTime.now(),
          totalPaise: 39900,
          periodFrom: _trialEndsAt,
        ),
      );
    }
    return MandateVerification(
      success: true,
      kind: kind,
      tokenStatus: 'confirmed',
      firstChargeAt: _trialEndsAt,
    );
  }

  @override
  Future<StopAutopayResult> stopAutopay() async {
    await Future<void>.delayed(_latency);
    final bool already = _mandate == _MockMandate.stopped;
    _mandate = _MockMandate.stopped;
    return StopAutopayResult(
      revokeConfirmed: true,
      alreadyStopped: already,
      inTrial: true,
      accessUntil: _trialEndsAt,
    );
  }

  // ── The consistency reward ───────────────────────────────────────────────

  /// The switch, as the fake server holds it. Never on until switched on.
  bool _rewardConsented = false;

  /// The words the server sends — a copy for the mock flavor only, kept here
  /// beside the fake server it stands in for (the real app shows the
  /// server's). Built as the route builds them, at its default 75% / 20 days.
  static const ConsistencyRewardWords _rewardWords = ConsistencyRewardWords(
    headline:
        'Consistency reward — the more consistently you build your brand, the '
        'less you pay.',
    label: 'Use my consistency to set my monthly price',
    consentText:
        'Use my consistency to set my monthly price: my own consistency '
        'record sets my next UPI AutoPay debit, never below ₹1 and never '
        'above the plan price. Leave it off and you pay the plan price',
    why:
        'We look only at your own record: the share of what each day’s lesson '
        'and LinkedIn tasks offered that you completed (right answers in the '
        'lesson count), the days in a row you finished the day’s lesson, and '
        'any claims our team removed as not genuine. The more consistent you '
        'are, the lower your next debit — never below ₹1, never above the plan '
        'price. Leave it off and you pay the plan price. Switch it off any '
        'time: the next month not yet priced goes back to the plan price.',
    conditions: <String>[
      'India, on UPI AutoPay, with “Use my consistency to set my monthly '
          'price” switched on.',
      'At least 20 days of your consistency counted in the month.',
      'At 75% consistency or more, your discount is your consistency — and '
          'every 10 days in a row adds 1%.',
      'Never below ₹1, never above the plan price. The price is fixed 3 days '
          'before each debit, and the notice says it.',
      '3 claims found not genuine in a month cancel that month’s reward.',
    ],
    appliesFromNextLine:
        'Switching it on now applies from the debit after this one.',
  );

  static const String _rewardWordsVersion = '2026-11-25';

  ConsistencyRewardConsent _rewardNow() => ConsistencyRewardConsent(
    consented: _rewardConsented,
    staleConsent: false,
    wordsVersion: _rewardWordsVersion,
    words: _rewardWords,
  );

  @override
  Future<ConsistencyRewardConsent> fetchConsistencyReward() async {
    await Future<void>.delayed(_latency);
    return _rewardNow();
  }

  @override
  Future<ConsistencyRewardConsent> setConsistencyReward({
    required bool consented,
    String? wordsVersion,
  }) async {
    await Future<void>.delayed(_latency);
    // The server's rule: a yes only under the words it was given to.
    if (consented && wordsVersion != _rewardWordsVersion) {
      throw const ConsistencyRewardUpdateRequired(
        'The words have changed — read them again below, then switch it on.',
      );
    }
    _rewardConsented = consented;
    return _rewardNow();
  }

  @override
  Future<AutopayStatus> fetchAutopayStatus() async {
    await Future<void>.delayed(_latency);
    return switch (_mandate) {
      _MockMandate.none => const AutopayStatus(),
      _MockMandate.live => AutopayStatus(
        rail: 'token',
        tokenStatus: 'confirmed',
        canStop: true,
        nextChargeAt: _trialEndsAt,
        nextChargeAmountPaise: 39900,
        monthlyPaise: 39900,
        accessUntil: _trialEndsAt,
        inTrial: true,
        trialEndsAt: _trialEndsAt,
        // The reward as the server shows it for a test account in `shadow`:
        // live, the coming debit not priced yet (the plan price is the most
        // it can be).
        nextChargePriceFixed: false,
        nextChargeBasePaise: 39900,
        consistencyReward: ConsistencyRewardStatus(
          live: true,
          consented: _rewardConsented,
          minDays: 20,
          thresholdPct: 75,
        ),
      ),
      _MockMandate.stopped => AutopayStatus(
        rail: 'token',
        tokenStatus: 'cancelled',
        stopped: true,
        monthlyPaise: 39900,
        accessUntil: _trialEndsAt,
        inTrial: true,
        trialEndsAt: _trialEndsAt,
      ),
    };
  }

  /// The mock account's tax documents, as the fake server would have issued
  /// them: an invoice for each verified PAID registration (a `paid`
  /// registration and its invoice commit together, §5.9), none for a free
  /// month. Empty answers at once, so a test that never pays waits on no
  /// timer.
  final List<TaxDocument> _documents = <TaxDocument>[];

  @override
  Future<List<TaxDocument>> fetchTaxDocuments() async {
    if (_documents.isEmpty) return const <TaxDocument>[];
    await Future<void>.delayed(_latency);
    return List<TaxDocument>.unmodifiable(_documents.reversed);
  }

  @override
  Future<String> fetchTaxDocumentHtml(String id) async {
    await Future<void>.delayed(_latency);
    final TaxDocument? doc = _documents
        .where((TaxDocument d) => d.id == id)
        .firstOrNull;
    if (doc == null) throw const PricingUnavailable();
    return '<!DOCTYPE html><html><body><div>'
        '<h1>Tax Invoice</h1>'
        '<div><strong>No. ${doc.number}</strong></div>'
        '<table><tr><td>Taxable value</td><td>₹338.14</td></tr>'
        '<tr><td>IGST @ 18%</td><td>₹60.86</td></tr>'
        '<tr><td><strong>Total (incl. GST)</strong></td>'
        '<td><strong>${documentRupees(doc.totalPaise)}</strong></td></tr>'
        '</table>'
        '<div>This is a computer-generated document and needs no '
        'signature.</div>'
        '</div></body></html>';
  }

  /// The mock account's GST State: an account in India that has not said
  /// yet, so the mock build walks onboarding's State step and the checkout's
  /// inline ask. The edge "suggests" Maharashtra, as Cloudflare's region
  /// would. Answers at once, as the empty document list does, so a test that
  /// never asks waits on no timer.
  String? _stateCode;
  BillingStateSource? _stateSource;
  DateTime? _stateDeclaredAt;

  @override
  Future<BillingState> fetchBillingState() async => BillingState(
    stateCode: _stateCode,
    stateName: billingStateName(_stateCode),
    declaredAt: _stateDeclaredAt,
    source: _stateSource,
    isIndia: true,
    suggestedStateCode: '27',
  );

  /// Refuses what the server refuses: a code that is not a State or UT.
  @override
  Future<SavedBillingState> saveBillingState({
    required String stateCode,
    required BillingStateSource source,
  }) async {
    if (!isBillingStateCode(stateCode)) {
      final RequestOptions request = RequestOptions(
        path: ApiPaths.userBillingState,
      );
      throw DioException(
        requestOptions: request,
        response: Response<dynamic>(requestOptions: request, statusCode: 400),
        error: const ValidationFailure(
          message: 'Choose your State or Union Territory from the list.',
          errorCode: 'VALIDATION_FAILED',
        ),
      );
    }
    _stateCode = stateCode;
    _stateSource = source;
    _stateDeclaredAt = DateTime.now();
    return SavedBillingState(
      stateCode: stateCode,
      stateName: billingStateName(stateCode)!,
      declaredAt: _stateDeclaredAt,
      source: source,
    );
  }

  @override
  Future<OrderIntent> createOrder({
    required String planType,
    required String countryCode,
  }) async {
    await Future<void>.delayed(_latency);
    return const OrderIntent(
      orderId: 'order_mock',
      keyId: 'rzp_test_mock',
      amount: 1000,
      currency: 'USD',
    );
  }

  @override
  Future<bool> verifyOrder({
    required String orderId,
    required String paymentId,
    required String signature,
  }) async {
    await Future<void>.delayed(_latency);
    return true;
  }
}

enum _MockMandate { none, live, stopped }

/// Mock ↔ real switch on `useFakeBackend`. A release build can never resolve
/// the fake — the assert mirrors every other slice.
final Provider<PricingRepository> pricingRepositoryProvider =
    Provider<PricingRepository>((Ref ref) {
      final bool useFake = ref.watch(useFakeBackendProvider);
      assert(
        !(kReleaseMode && useFake),
        'useFakeBackend must be false in release builds.',
      );
      if (useFake && !kReleaseMode) return FakePricingRepository();
      return ApiPricingRepository(ref.watch(dioClientProvider));
    });

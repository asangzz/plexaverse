import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/env.dart';
import '../../../core/network/api_paths.dart';
import '../../../core/network/dio_client.dart';
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
      // inventing zeroes, which would blank a returning user's earned total.
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
  Future<CheckoutIntent> createSubscription({
    required String planType,
    String? countryCode,
  }) async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiPaths.subscriptionCreate,
      data: <String, dynamic>{
        'planType': planType,
        'countryCode': ?countryCode,
      },
    );
    final Map<String, dynamic>? data = response.data;
    if (data == null) throw StateError('subscription/create returned nothing');
    return CheckoutIntent(
      subscriptionId: (data['subscriptionId'] as String?) ?? '',
      keyId: data['keyId'] as String?,
      amount: (data['amount'] as num?)?.toInt() ?? 0,
      currency: (data['currency'] as String?) ?? 'INR',
    );
  }

  @override
  Future<bool> verifySubscription({
    required String paymentId,
    required String subscriptionId,
    required String signature,
  }) async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiPaths.subscriptionVerify,
      data: <String, dynamic>{
        'razorpayPaymentId': paymentId,
        'razorpaySubscriptionId': subscriptionId,
        'razorpaySignature': signature,
      },
    );
    // Only an explicit success counts. A missing field is not a yes.
    return response.data?['success'] == true ||
        response.data?['verified'] == true;
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
    totalXpEarned: 7500,
  );

  @override
  Future<PlanPricing> fetchPricing({String? countryCode}) async {
    await Future<void>.delayed(_latency);
    return const PlanPricing(personalPrice: 299, companyPrice: 1199);
  }

  @override
  Future<String?> fetchBrandType() async {
    await Future<void>.delayed(_latency);
    return 'personal';
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

  @override
  Future<CheckoutIntent> createSubscription({
    required String planType,
    String? countryCode,
  }) async {
    await Future<void>.delayed(_latency);
    // No keyId: the mock must exercise the "Razorpay not configured" branch
    // rather than hand the sheet a fake key and get an opaque SDK error.
    return const CheckoutIntent(
      subscriptionId: 'sub_mock',
      keyId: null,
      amount: 29900,
      currency: 'INR',
    );
  }

  @override
  Future<bool> verifySubscription({
    required String paymentId,
    required String subscriptionId,
    required String signature,
  }) async {
    await Future<void>.delayed(_latency);
    return true;
  }
}

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

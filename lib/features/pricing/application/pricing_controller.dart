import 'dart:ui' show PlatformDispatcher;

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/pricing_repositories.dart';
import '../domain/pricing_repository.dart';

part 'pricing_controller.g.dart';

// Pricing is ONE SCREEN MADE OF INDEPENDENT BLOCKS — the price list, the plan
// gate, the referral card — so it is modelled as three small providers rather
// than one snapshot. The web reaches the same shape with one hook per resource,
// and the reason is worth repeating: a referral read that 500s must not take
// the price list down with it.

/// Localised plan prices.
///
/// The country comes from the device locale. The mobile route accepts
/// `?country=` precisely so the client can answer that itself; the web's
/// IP-based chain is not reproduced because an IP guess on a phone is wrong as
/// often as it is right.
@riverpod
Future<PlanPricing> planPricing(Ref ref) {
  final String? country = PlatformDispatcher.instance.locale.countryCode;
  return ref
      .watch(pricingRepositoryProvider)
      .fetchPricing(countryCode: country);
}

/// Which plans this account may buy.
///
/// Its own provider rather than a field on [planPricing] so a slow or failed
/// preferences read delays the GATE, not the prices. Null while loading and
/// null on failure both mean "show everything", which is the web's own
/// behaviour before `brandType` arrives.
@riverpod
Future<String?> pricingBrandType(Ref ref) =>
    ref.watch(pricingRepositoryProvider).fetchBrandType();

/// The referral code and its lifetime counters.
@riverpod
class ReferralController extends _$ReferralController {
  @override
  Future<ReferralSummary> build() =>
      ref.watch(pricingRepositoryProvider).fetchReferral();

  /// Issues a code. Idempotent server-side — it returns the existing unused
  /// code rather than minting a second active one, so a double-tap is safe.
  Future<void> generate() async {
    state = const AsyncLoading<ReferralSummary>();
    state = await AsyncValue.guard<ReferralSummary>(
      () => ref.read(pricingRepositoryProvider).generateReferralCode(),
    );
  }
}

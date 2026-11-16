import 'dart:ui' show PlatformDispatcher;

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/pricing_repositories.dart';
import '../domain/pricing_repository.dart';
import 'plan_checkout.dart';

part 'pricing_controller.g.dart';

// Pricing is ONE SCREEN MADE OF INDEPENDENT BLOCKS — the price list, the plan
// gate, what a plan includes, the referral card — so it is modelled as small
// providers rather than one snapshot. The web reaches the same shape with one
// hook per resource, and the reason is worth repeating: a referral read that
// 500s must not take the price list down with it.

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

/// What every plan includes, per AI feature.
///
/// Never errors: a failed read falls back to [AllowanceTable.fallback], the
/// static list that mirrors the web's defaults. The block exists to say what a
/// plan buys, and a user deciding whether to pay should not see that sentence
/// replaced by a retry button. An empty live answer falls back too — a plan
/// that includes nothing is never the truth.
@riverpod
Future<AllowanceTable> planAllowances(Ref ref) async {
  try {
    final List<Allowance> rows = await ref
        .watch(pricingRepositoryProvider)
        .fetchAllowances();
    if (rows.isEmpty) return AllowanceTable.fallback;
    return AllowanceTable(rows: rows, live: true);
  } on Object {
    return AllowanceTable.fallback;
  }
}

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

/// Buying a plan from the Pricing screen.
///
/// The create → sheet → verify sequence is [PlanCheckout]'s, shared with the
/// onboarding plan step; this only turns its outcome into the screen's
/// message and refreshes what a new plan changes.
@riverpod
class CheckoutController extends _$CheckoutController {
  @override
  void build() {}

  /// Returns a message to show, or null when there is nothing to say
  /// (the user closed the sheet — their decision, not an error).
  Future<String?> buy({required String planType, String? countryCode}) async {
    final PlanCheckoutOutcome outcome = await ref
        .read(planCheckoutProvider)
        .subscribe(planType: planType, countryCode: countryCode);

    switch (outcome) {
      case PlanCheckoutDismissed():
        return null;
      case PlanCheckoutFailed(:final String message):
        return message;
      case PlanCheckoutDone():
        // The plan lives on the user row, which several screens branch on,
        // and it changes what every allowance gate answers.
        ref.invalidate(planPricingProvider);
        ref.invalidate(pricingBrandTypeProvider);
        ref.invalidate(planAllowancesProvider);
        return 'You are on the plan. Welcome aboard.';
      case PlanCheckoutAlreadyActive():
        ref.invalidate(planAllowancesProvider);
        return 'You already have a plan — manage it from Settings.';
    }
  }
}

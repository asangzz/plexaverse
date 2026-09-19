import 'dart:ui' show PlatformDispatcher;

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/pricing_repositories.dart';
import '../domain/pricing_repository.dart';
import '../../../core/platform/checkout.dart';

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

/// Buying a plan: create the mandate, open the sheet, verify the result.
///
/// The three steps are one controller because they are one act, and the
/// middle one is the only part that happens on the device. What the sheet
/// returns is a CLAIM — the server checks the signature before anything is
/// activated, so a device that lies gets nothing.
@riverpod
class CheckoutController extends _$CheckoutController {
  @override
  void build() {}

  /// Returns a message to show, or null when there is nothing to say
  /// (the user closed the sheet — their decision, not an error).
  Future<String?> buy({required String planType, String? countryCode}) async {
    final PricingRepository repo = ref.read(pricingRepositoryProvider);

    final CheckoutIntent intent;
    try {
      intent = await repo.createSubscription(
        planType: planType,
        countryCode: countryCode,
      );
    } on Object {
      return "We couldn't start checkout. Try again.";
    }

    final String? keyId = intent.keyId;
    if (keyId == null || keyId.isEmpty) {
      // Refuse rather than open a sheet we cannot identify: Razorpay's own
      // error for a missing key is opaque, and this one names the cause.
      return 'Payments are not configured yet. Please try from the web app.';
    }

    final CheckoutResult result = await ref.read(checkoutProvider).open(
      keyId: keyId,
      name: 'Plexaverse',
      description: planType,
      subscriptionId: intent.subscriptionId,
    );

    switch (result) {
      case CheckoutCancelled():
        return null;
      case CheckoutFailed(:final String? message):
        return message ?? 'That payment did not go through.';
      case CheckoutPaid(
          :final String paymentId,
          :final String? signature,
        ):
        if (signature == null) {
          // Without a signature the server cannot prove the payment. Say so
          // rather than reporting success the ledger will not agree with.
          return 'Payment taken, but we could not confirm it. '
              'Contact support if your plan does not appear.';
        }
        try {
          final bool verified = await repo.verifySubscription(
            paymentId: paymentId,
            subscriptionId: intent.subscriptionId,
            signature: signature,
          );
          if (!verified) {
            return 'We could not verify that payment. Nothing was charged to '
                'your plan — contact support if you were billed.';
          }
        } on Object {
          return 'Payment taken. Confirming it failed — your plan will '
              'activate shortly, or contact support.';
        }
        // The plan lives on the user row, which several screens branch on.
        ref.invalidate(planPricingProvider);
        ref.invalidate(pricingBrandTypeProvider);
        return 'You are on the plan. Welcome aboard.';
    }
  }
}

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/pricing_repositories.dart';
import '../domain/pricing_repository.dart';
import 'plan_checkout.dart';

part 'billing_state_controller.g.dart';

// The buyer's GST State (`domain/billing_state.dart`) outside onboarding:
// Settings → Billing shows and changes it, and the Pricing screen and
// Settings' way back ask it inline when a payment answers
// [PlanCheckoutStateNeeded]. Onboarding's chat owns its own step — its State
// lives in the conversation's state, like every other answer there.

/// `GET /user/billing-state` — the State on record, and what the picker
/// starts on. Its own provider so an unreadable read hides the Settings row
/// only; the payment paths read fresh through [PlanCheckout].
@riverpod
Future<BillingState> billingState(Ref ref) =>
    ref.watch(pricingRepositoryProvider).fetchBillingState();

/// Saving the buyer's State from one place ([BillingStateSource]): the
/// in-flight flag and the failure live here, never on the picker, so a
/// rebuilt or disposed picker cannot lose either. Null before any save.
@riverpod
class BillingStateSave extends _$BillingStateSave {
  @override
  FutureOr<SavedBillingState?> build(BillingStateSource source) => null;

  /// Saves [stateCode] and returns what the server recorded, or null when it
  /// did not (the state holds why). Refuses an empty or unknown code without
  /// a request — the picker cannot submit one either.
  Future<SavedBillingState?> save(String stateCode) async {
    if (!isBillingStateCode(stateCode) || state.isLoading) return null;
    state = const AsyncLoading<SavedBillingState?>();
    final AsyncValue<SavedBillingState?> next =
        await AsyncValue.guard<SavedBillingState?>(
          () => ref
              .read(pricingRepositoryProvider)
              .saveBillingState(stateCode: stateCode, source: source),
        );
    if (!ref.mounted) return next.value;
    state = next;
    // Settings' row reads the State it now shows from the server.
    if (next.hasValue) ref.invalidate(billingStateProvider);
    return next.value;
  }

  /// Back to "nothing tried yet" — a reopened picker shows no old error.
  void reset() => state = const AsyncData<SavedBillingState?>(null);
}

/// What a failed save says: the server's sentence (a 400 names what was
/// wrong), else [kBillingStateSaveFailed].
String billingStateSaveError(Object error) =>
    PlanCheckout.serverMessage(error) ?? kBillingStateSaveFailed;

/// Which payment control is waiting on the State — the web's
/// `useBillingStateGate().askingFor`. Set when a checkout answered
/// [PlanCheckoutStateNeeded]; cleared by a save (the caller then runs the
/// same checkout again) or a cancel (the payment is dropped, not the page).
@riverpod
class BillingStateAsk extends _$BillingStateAsk {
  @override
  String? build() => null;

  void ask(String key) => state = key;

  void clear() => state = null;
}

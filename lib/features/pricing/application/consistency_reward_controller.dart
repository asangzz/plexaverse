import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../contest/application/contest_controllers.dart'
    show contestConsistencyProvider;
import '../../settings/application/settings_controllers.dart'
    show consentControllerProvider;
import '../data/pricing_repositories.dart';
import '../domain/consistency_reward.dart';
import 'pricing_controller.dart' show autopayStatusProvider;

part 'consistency_reward_controller.g.dart';

/// `GET /billing/consistency-reward` — the switch as the server has it and the
/// words to show beside it, verbatim (the words the consent is recorded
/// under). Read when the section is shown, never polled (the route's bucket is
/// AUTH, 5 a minute). An error of any kind — a 404 from a server older than
/// the route included — means the section is not shown.
@riverpod
class ConsistencyRewardConsentController
    extends _$ConsistencyRewardConsentController {
  @override
  Future<ConsistencyRewardConsent> build() =>
      ref.watch(pricingRepositoryProvider).fetchConsistencyReward();

  /// A PUT answers the GET body: that is the switch's state now.
  void replace(ConsistencyRewardConsent next) =>
      state = AsyncData<ConsistencyRewardConsent>(next);
}

/// Where the switch's save stands. Held here, not in the widget, so a save
/// survives the section being scrolled away or rebuilt mid-request.
class RewardSave {
  const RewardSave({this.saving = false, this.error, this.surface});

  final bool saving;

  /// The sentence to show for the last refusal, or null.
  final String? error;

  /// Where the tap that produced [error] happened: shown only there.
  final RewardSurface? surface;
}

/// The switch's save: `PUT /billing/consistency-reward`.
///
/// Kept alive: a save that lands after the section is gone must still refresh
/// the billing status, the card and the consent list, or they would show the
/// switch as it was.
@Riverpod(keepAlive: true)
class ConsistencyRewardSaveController
    extends _$ConsistencyRewardSaveController {
  @override
  RewardSave build() => const RewardSave();

  /// Switches the reward on or off.
  ///
  /// A yes is sent with the `wordsVersion` of the words on screen — the yes
  /// counts only under the words it was given to. A 409 UPDATE_REQUIRED (the
  /// words changed under the screen) shows the server's sentence and reads
  /// the words again, so the switch is offered beside the new ones. A
  /// withdrawal needs nothing but `consented: false`.
  Future<void> set(bool on, {required RewardSurface surface}) async {
    if (state.saving) return;
    final AsyncValue<ConsistencyRewardConsent> words = ref.read(
      consistencyRewardConsentControllerProvider,
    );
    final ConsistencyRewardConsent? shown = words.value;
    if (on && (shown == null || words.isLoading || words.hasError)) {
      // Never a yes to words that are not (or no longer) the server's: while
      // they are being re-read, or could not be, the version on screen may
      // be the one just refused.
      state = RewardSave(error: kRewardSaveFailed, surface: surface);
      return;
    }
    state = RewardSave(saving: true, surface: surface);
    try {
      final ConsistencyRewardConsent next = await ref
          .read(pricingRepositoryProvider)
          .setConsistencyReward(
            consented: on,
            wordsVersion: on ? shown!.wordsVersion : null,
          );
      if (!ref.mounted) return;
      ref
          .read(consistencyRewardConsentControllerProvider.notifier)
          .replace(next);
      state = const RewardSave();
      // Every surface that shows the switch, or a price it sets: the billing
      // status, the consistency card and Settings' consent list (the web's
      // useSetConsistencyReward invalidates the same three).
      ref
        ..invalidate(autopayStatusProvider)
        ..invalidate(contestConsistencyProvider)
        ..invalidate(consentControllerProvider);
    } on ConsistencyRewardUpdateRequired catch (e) {
      if (!ref.mounted) return;
      state = RewardSave(error: e.message, surface: surface);
      ref.invalidate(consistencyRewardConsentControllerProvider);
    } on Object catch (e) {
      if (!ref.mounted) return;
      state = RewardSave(
        error: e is ConsistencyRewardFailure ? e.message : kRewardSaveFailed,
        surface: surface,
      );
      // The request may have reached the server before the answer was lost
      // (a timeout, a dropped connection, a 5xx after the write): redraw the
      // switch from what the server holds rather than from the guess.
      ref.invalidate(consistencyRewardConsentControllerProvider);
    }
  }
}

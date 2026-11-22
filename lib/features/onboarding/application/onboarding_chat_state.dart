import 'package:freezed_annotation/freezed_annotation.dart';

import '../../pricing/domain/plan_offer.dart';
import '../domain/onboarding_repository.dart';

part 'onboarding_chat_state.freezed.dart';

/// Everything the onboarding screen renders from.
///
/// One immutable value rather than a dozen `useState`s (the web has twenty-odd,
/// which is how a parked timer from an abandoned step managed to pour a line
/// into a fresh thread there before a generation counter was added). Here the
/// counter lives in the controller and this object holds only what is drawn.
@freezed
abstract class OnboardingChatState with _$OnboardingChatState {
  const OnboardingChatState._();

  const factory OnboardingChatState({
    @Default(<ChatMessage>[]) List<ChatMessage> messages,
    @Default(OnboardingStep.welcome) OnboardingStep step,

    /// Plexa is composing. Drives the typing bubble, and — on a panel step —
    /// replaces the composer with the typing hint so nobody types into a
    /// half-asked question.
    @Default(false) bool isBotTyping,
    @Default(OnboardingAnswers()) OnboardingAnswers answers,

    /// The voice composer's text, hoisted out of the widget.
    ///
    /// The web hoists it for a specific reason worth keeping: a too-short draft
    /// is rejected by sending a bot line, which flips [isBotTyping], which
    /// swaps the composer for the typing hint — wiping what the user typed and
    /// asking them to retry into an emptied box.
    @Default('') String voiceDraft,
    @Default(false) bool isFinalising,

    /// The finalise failed and the user is being offered a retry. The only
    /// state that changes the finish step's lane.
    /// True once a LinkedIn connect attempt has failed or been cancelled.
    ///
    /// Gates the "I'll connect later" escape on the connect step — the ONE
    /// place this flow knowingly differs from the web, which has no escape at
    /// all. Connecting stays mandatory until the OAuth trip has actually been
    /// tried and not worked: requiring it unconditionally would trap a user
    /// whose browser hand-off fails (the app's LinkedIn redirect depends on a
    /// portal setting the web does not) behind a step they cannot pass.
    @Default(false) bool connectFailed,

    /// The connected LinkedIn profile's name, for the web's
    /// "Connected as {name}" line.
    String? linkedinName,

    /// What the plan step offers. Null until the region and the autopay
    /// switch have both been read — the button stays disabled until then,
    /// because a guess here does not fail, it succeeds at the wrong price.
    PlanOffer? planOffer,

    /// The region or the autopay switch could not be read. The step offers a
    /// retry and nothing else: starting without them could put the user on
    /// the wrong plan.
    @Default(false) bool planOfferFailed,

    /// The Razorpay sheet is open, or its result is being verified.
    @Default(false) bool planBusy,

    /// Why the last attempt did not finish, in one sentence. Not set when the
    /// sheet was simply closed.
    String? planError,

    /// A UPI AutoPay sheet was opened on this step and did not finish —
    /// closed, or failed. The panel then names the way out, since the step
    /// has no skip and a UPI app that never opened looks exactly like this.
    @Default(false) bool planSheetUnfinished,
    @Default(false) bool finaliseError,

    /// The preferences write succeeded. The page watches this and hands over to
    /// the router; nothing else is allowed to navigate.
    @Default(false) bool completed,

    /// The user has sent at least one message. Only used to drop the "Tap to
    /// send" hint above the first chip row, exactly as the web does.
    @Default(false) bool hasUserSent,

    /// The greeting name. Null until `/auth/me` answers; the greeting falls
    /// back to "there" the way the web's does with a nameless session.
    String? firstName,
  }) = _OnboardingChatState;

  /// Where this step's control lives — see [OnboardingStep.lane].
  OnboardingLane get lane => step.lane(finaliseError: finaliseError);
}

import 'package:freezed_annotation/freezed_annotation.dart';

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

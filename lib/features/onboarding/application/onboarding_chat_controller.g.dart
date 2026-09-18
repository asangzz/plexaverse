// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_chat_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Drives the onboarding conversation.
///
/// The web's `OnboardingChat` keeps all of this inside the component; here the
/// conversation is a controller so the screen is a pure function of
/// [OnboardingChatState] and the script can be exercised without a widget tree.
///
/// ## The generation counter is not optional
///
/// Every bot line is a timer. A line parked in a timer belongs to the step that
/// started it, and a user who taps faster than the cadence moves the thread on
/// underneath it. [_generation] is bumped on EVERY step transition, and a line
/// whose generation has moved on simply never lands. The web learned this the
/// hard way — its CTA used to be far enough from the thread that nobody tapped
/// fast enough to notice.
///
/// The bump lives on the transition, not on step entry, for the same reason it
/// does there: a line sent immediately AFTER an advance (the finalise failure
/// message) must capture the post-bump generation or it is swallowed, and that
/// message is the only explanation the user gets.

@ProviderFor(OnboardingChatController)
final onboardingChatControllerProvider = OnboardingChatControllerProvider._();

/// Drives the onboarding conversation.
///
/// The web's `OnboardingChat` keeps all of this inside the component; here the
/// conversation is a controller so the screen is a pure function of
/// [OnboardingChatState] and the script can be exercised without a widget tree.
///
/// ## The generation counter is not optional
///
/// Every bot line is a timer. A line parked in a timer belongs to the step that
/// started it, and a user who taps faster than the cadence moves the thread on
/// underneath it. [_generation] is bumped on EVERY step transition, and a line
/// whose generation has moved on simply never lands. The web learned this the
/// hard way — its CTA used to be far enough from the thread that nobody tapped
/// fast enough to notice.
///
/// The bump lives on the transition, not on step entry, for the same reason it
/// does there: a line sent immediately AFTER an advance (the finalise failure
/// message) must capture the post-bump generation or it is swallowed, and that
/// message is the only explanation the user gets.
final class OnboardingChatControllerProvider
    extends $NotifierProvider<OnboardingChatController, OnboardingChatState> {
  /// Drives the onboarding conversation.
  ///
  /// The web's `OnboardingChat` keeps all of this inside the component; here the
  /// conversation is a controller so the screen is a pure function of
  /// [OnboardingChatState] and the script can be exercised without a widget tree.
  ///
  /// ## The generation counter is not optional
  ///
  /// Every bot line is a timer. A line parked in a timer belongs to the step that
  /// started it, and a user who taps faster than the cadence moves the thread on
  /// underneath it. [_generation] is bumped on EVERY step transition, and a line
  /// whose generation has moved on simply never lands. The web learned this the
  /// hard way — its CTA used to be far enough from the thread that nobody tapped
  /// fast enough to notice.
  ///
  /// The bump lives on the transition, not on step entry, for the same reason it
  /// does there: a line sent immediately AFTER an advance (the finalise failure
  /// message) must capture the post-bump generation or it is swallowed, and that
  /// message is the only explanation the user gets.
  OnboardingChatControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'onboardingChatControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$onboardingChatControllerHash();

  @$internal
  @override
  OnboardingChatController create() => OnboardingChatController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OnboardingChatState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OnboardingChatState>(value),
    );
  }
}

String _$onboardingChatControllerHash() =>
    r'425946fbfe46f33941a46fe361fe645d8d055439';

/// Drives the onboarding conversation.
///
/// The web's `OnboardingChat` keeps all of this inside the component; here the
/// conversation is a controller so the screen is a pure function of
/// [OnboardingChatState] and the script can be exercised without a widget tree.
///
/// ## The generation counter is not optional
///
/// Every bot line is a timer. A line parked in a timer belongs to the step that
/// started it, and a user who taps faster than the cadence moves the thread on
/// underneath it. [_generation] is bumped on EVERY step transition, and a line
/// whose generation has moved on simply never lands. The web learned this the
/// hard way — its CTA used to be far enough from the thread that nobody tapped
/// fast enough to notice.
///
/// The bump lives on the transition, not on step entry, for the same reason it
/// does there: a line sent immediately AFTER an advance (the finalise failure
/// message) must capture the post-bump generation or it is swallowed, and that
/// message is the only explanation the user gets.

abstract class _$OnboardingChatController
    extends $Notifier<OnboardingChatState> {
  OnboardingChatState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<OnboardingChatState, OnboardingChatState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<OnboardingChatState, OnboardingChatState>,
              OnboardingChatState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/ui/app_icons.dart';
import '../../../../core/ui/zave/zave_kit.dart';
import '../../../auth/application/sign_out_controller.dart';
import '../../application/onboarding_chat_controller.dart';
import '../../application/onboarding_controller.dart';
import '../../domain/onboarding_repository.dart';
import '../widgets/chat_lane.dart';
import '../widgets/onboarding_chrome.dart';
import '../widgets/reply_lane.dart';
import '../widgets/role_picker.dart';
import '../widgets/tone_panel.dart';
import '../widgets/upload_panels.dart';

/// The onboarding chat — progress row, thread and dock — the conversational
/// setup every new account goes through. The web counterpart is
/// `components/onboarding/OnboardingChat.tsx`.
///
/// It has no page of its own: `PlexaJourneyPage` runs it under the mascot, at
/// `/onboarding` and at `/plexa`, as the web's `PlexaJourney` does. `lead` and
/// [showBotAvatar] are that page's hooks — the web's props of the same names.
///
/// ## The two lanes
///
/// A step is answered either with a tap, or with a picker or a form, and the
/// control lives in a different place for each — see [OnboardingStep.lane]. A
/// tap-answer is rendered in the USER's lane as the message it is about to
/// become; a panel is pinned in the bottom band. Panels never go inline: a
/// tall form at the end of a scrolling thread gets its submit button
/// auto-scrolled into view and its first field pushed off the top.
///
/// Clears whatever is above it with [ZaveScaffold.contentTop]: a scaffold's
/// header when there is one, otherwise the status bar.
class OnboardingChatBody extends ConsumerStatefulWidget {
  const OnboardingChatBody({
    this.lead,
    this.showBotAvatar = true,
    this.onCompleted,
    super.key,
  });

  /// Placed at the start of the progress row. `/plexa` puts an empty, measured
  /// box here and flies the mascot into it.
  final Widget? lead;

  /// Plexa's avatar beside her messages. Off when the mascot is on screen.
  final bool showBotAvatar;

  /// Called once the chat has finished, after the onboarding gate has been
  /// released. `/onboarding` leaves this null: releasing the gate is what moves
  /// it on. Anywhere else the gate does not apply, so the host has to leave by
  /// itself.
  final VoidCallback? onCompleted;

  @override
  ConsumerState<OnboardingChatBody> createState() => _OnboardingChatBodyState();
}

class _OnboardingChatBodyState extends ConsumerState<OnboardingChatBody> {
  final ScrollController _thread = ScrollController();

  @override
  void dispose() {
    _thread.dispose();
    super.dispose();
  }

  /// Keeps the newest line in view.
  ///
  /// Post-frame because the line that triggered this has not been laid out yet,
  /// so `maxScrollExtent` is still the old one.
  void _pinToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_thread.hasClients) return;
      _thread.animateTo(
        _thread.position.maxScrollExtent,
        duration: ZaveMotion.fast,
        curve: ZaveMotion.curve,
      );
    });
  }

  Future<void> _confirmLogout() async {
    // The web's escape hatch — `window.confirm('Log out of Plexaverse?')`. It
    // is the only practical way to switch accounts on a phone, where clearing
    // a session by hand is not an option.
    final bool confirmed =
        await showDialog<bool>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Log out of Plexaverse?'),
            content: const Text(
              "Your answers so far aren't saved yet — you'll start setup again "
              'next time you sign in.',
            ),
            actions: <Widget>[
              ZaveButton(
                label: 'Stay',
                onPressed: () => Navigator.of(context).pop(false),
              ),
              ZaveButton(
                kind: ZaveButtonKind.primarySmall,
                label: 'Log out',
                onPressed: () => Navigator.of(context).pop(true),
              ),
            ],
          ),
        ) ??
        false;

    if (!confirmed || !mounted) return;
    await ref.read(signOutControllerProvider.notifier).signOut();
  }

  @override
  Widget build(BuildContext context) {
    final OnboardingChatState chat = ref.watch(
      onboardingChatControllerProvider,
    );

    ref.listen<OnboardingChatState>(onboardingChatControllerProvider, (
      OnboardingChatState? previous,
      OnboardingChatState next,
    ) {
      if (previous?.messages.length != next.messages.length ||
          previous?.isBotTyping != next.isBotTyping ||
          previous?.step != next.step) {
        _pinToEnd();
      }
      // Handing over is declarative: completing flips the gate the router
      // listens to and the redirect fires. No `context.go` here — a page that
      // navigates itself is how two sources of truth for "where am I" start.
      if (next.completed && previous?.completed != true) {
        ref.read(onboardingControllerProvider.notifier).complete();
        widget.onCompleted?.call();
      }
    });

    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(
            ZaveSpace.gutter,
            ZaveScaffold.contentTop(context) + ZaveSpace.md,
            ZaveSpace.gutter,
            ZaveSpace.md,
          ),
          child: Row(
            children: <Widget>[
              if (widget.lead != null) ...<Widget>[
                widget.lead!,
                SizedBox(width: ZaveSpace.md),
              ],
              Expanded(
                child: OnboardingProgress(
                  percent: chat.step.progressPercent(
                    company: chat.answers.brand == BrandChoice.company,
                  ),
                ),
              ),
              SizedBox(width: ZaveSpace.md),
              ZaveIconButton(
                icon: const Icon(AppIcons.logout),
                tooltip: 'Log out',
                onPressed: _confirmLogout,
              ),
            ],
          ),
        ),
        Expanded(
          child: _Thread(
            controller: _thread,
            chat: chat,
            showBotAvatar: widget.showBotAvatar,
          ),
        ),
        OnboardingDock(child: _DockControl(chat: chat)),
      ],
    );
  }
}

/// The conversation.
class _Thread extends StatelessWidget {
  const _Thread({
    required this.controller,
    required this.chat,
    required this.showBotAvatar,
  });

  final ScrollController controller;
  final OnboardingChatState chat;
  final bool showBotAvatar;

  @override
  Widget build(BuildContext context) {
    final List<ChatMessage> messages = chat.messages;
    // One extra row for the typing bubble. It is part of the thread, not the
    // dock, because it is Plexa's turn and Plexa's turns live in the thread.
    final int count = messages.length + (chat.isBotTyping ? 1 : 0);

    return ListView.builder(
      controller: controller,
      padding: EdgeInsets.fromLTRB(
        ZaveSpace.gutter,
        ZaveSpace.md,
        ZaveSpace.gutter,
        ZaveSpace.xl,
      ),
      itemCount: count,
      itemBuilder: (BuildContext context, int index) {
        if (index >= messages.length) {
          return TypingRow(
            grouped: messages.isNotEmpty && messages.last.role == ChatRole.bot,
            showBotAvatar: showBotAvatar,
          );
        }
        final ChatMessage message = messages[index];
        // Consecutive lines from one speaker drop the avatar and the eyebrow,
        // so a two-line answer reads as one turn.
        final bool grouped =
            index > 0 && messages[index - 1].role == message.role;
        return ChatMessageRow(
          message: message,
          grouped: grouped,
          showBotAvatar: showBotAvatar,
        );
      },
    );
  }
}

/// Whichever control this step is answered with — the web's `StepInputArea`,
/// step for step.
class _DockControl extends ConsumerWidget {
  const _DockControl({required this.chat});

  final OnboardingChatState chat;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    OnboardingChatController controller() =>
        ref.read(onboardingChatControllerProvider.notifier);

    // A panel step waits for Plexa to finish. A reply step does NOT: the
    // typing bubble directly above the chips already says everything a second
    // spinner would, and a chip row that disappears mid-sentence reads as the
    // question being withdrawn.
    if (chat.isBotTyping && chat.lane == OnboardingLane.panel) {
      return const DockHint(text: 'Plexa is typing…');
    }

    // Only until the user has sent something — after that the gesture has been
    // learned and the hint is noise.
    final String? hint = chat.hasUserSent ? null : 'Tap to send';

    return switch (chat.step) {
      OnboardingStep.welcome => ReplyLane(
        hint: hint,
        chips: <Widget>[
          // First person, because it answers the greeting's "Ready?" — and
          // because it is echoed verbatim as the user's own bubble.
          ReplyChip(label: "I'm ready", onTap: controller().acknowledgeWelcome),
        ],
      ),
      OnboardingStep.brand => ReplyLane(
        hint: hint,
        chips: <Widget>[
          for (final BrandChoice brand in BrandChoice.values)
            ReplyChip(
              label: brand.label,
              onTap: () => controller().pickBrand(brand),
            ),
        ],
      ),
      OnboardingStep.connect => ReplyLane(
        hint: hint,
        chips: <Widget>[
          ReplyChip(
            label: 'Connect LinkedIn',
            onTap: () => controller().connectLinkedin(),
          ),
          // Only after an attempt has actually failed — see
          // OnboardingChatState.connectFailed.
          if (chat.connectFailed)
            ReplySkipChip(
              label: "I'll connect later",
              onTap: () => controller().skipConnect(),
            ),
        ],
      ),
      OnboardingStep.companyPage => CompanyPagePanel(
        load: controller().companyPages,
        onPick: (String id, String name) =>
            controller().pickCompanyPage(id, name),
        onReconnect: () => controller().reconnectCompany(),
        onSwitchToPersonal: () => controller().switchToPersonal(),
      ),
      OnboardingStep.companyLogo => UploadPanel(
        icon: AppIcons.upload,
        title: 'Choose your logo',
        hint: 'Transparent PNG works best · PNG / JPG · required',
        onPick: () => controller().uploadLogo(),
      ),
      OnboardingStep.posterStyle => UploadPanel(
        icon: AppIcons.image,
        title: 'Choose an existing poster to match',
        hint: "PNG / JPG · I'll match its theme & colors",
        onPick: () => controller().uploadPosterStyle(),
        skipLabel: 'Skip — use a default style',
        onSkip: () => controller().skipPosterStyle(),
      ),
      OnboardingStep.cvUpload => UploadPanel(
        icon: AppIcons.attach,
        title: 'Choose your LinkedIn PDF',
        hint: 'PDF only · max 5 MB',
        onPick: () => controller().uploadCv(),
        skipLabel: 'Skip for now',
        onSkip: () => controller().skipCv(),
      ),
      OnboardingStep.currentRole => RolePicker(
        hint: hint,
        onPick: (String role) => controller().pickRole(role),
      ),
      OnboardingStep.companyDoc => UploadPanel(
        icon: AppIcons.attach,
        title: 'Choose your company document',
        hint: 'Deck · one-pager · About page · PDF only · max 5 MB',
        onPick: () => controller().uploadCompanyDoc(),
        skipLabel: "Skip — I'll tell you directly",
        onSkip: () => controller().skipCompanyDoc(),
      ),
      OnboardingStep.companyDetails => CompanyDetailsPanel(
        doc: chat.answers.companyDoc,
        onSubmit: controller().submitCompanyDetails,
      ),
      OnboardingStep.styleChoice => ReplyLane(
        hint: hint,
        chips: <Widget>[
          ReplyChip(
            label: 'Upload screenshots',
            onTap: () => controller().chooseScreenshots(),
          ),
          ReplyChip(
            label: 'Write a sample',
            onTap: () => controller().chooseWrite(),
          ),
          ReplySkipChip(
            label: 'No screenshots handy',
            onTap: () => controller().skipScreenshots(),
          ),
        ],
      ),
      OnboardingStep.styleScreenshots => UploadPanel(
        icon: AppIcons.image,
        title: 'Choose screenshots',
        hint: 'PNG / JPG · up to 5 images',
        onPick: () => controller().uploadScreenshots(),
        skipLabel: 'Skip',
        onSkip: () => controller().skipScreenshots(),
      ),
      // Still no skip — deliberate. This is the last place the user's own
      // voice can be captured.
      OnboardingStep.styleWrite => TonePanel(
        value: chat.voiceDraft,
        onChanged: controller().setVoiceDraft,
        onSubmit: (String text) => controller().submitVoiceSample(text),
      ),
      OnboardingStep.finish =>
        chat.finaliseError
            ? ReplyLane(
                chips: <Widget>[
                  ReplyChip(
                    label: 'Try again',
                    onTap: () => controller().retryFinalise(),
                  ),
                  ReplySkipChip(
                    label: 'Skip to dashboard',
                    onTap: controller().skipToDashboard,
                  ),
                ],
              )
            : const DockHint(text: 'Setting things up…'),
    };
  }
}

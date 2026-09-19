import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

/// `/onboarding` — Plexa Setup, the conversational flow that configures a new
/// account.
///
/// The web counterpart is `components/onboarding/OnboardingChat.tsx`, rendered
/// full-screen by `app/(dashboard)/onboarding/page.tsx` — no sidebar, no mobile
/// header, no guides, because the one thing to do on this screen is answer the
/// question on it.
///
/// ## The two lanes
///
/// A step is answered either with a tap or by typing, and the control lives in
/// a different place for each — see [OnboardingStep.lane]. A tap-answer is
/// rendered in the USER's lane as the message it is about to become; a typed
/// answer is a panel pinned in the bottom band. Panels never go inline: a tall
/// form at the end of a scrolling thread gets its submit button auto-scrolled
/// into view and its first field pushed off the top.
///
/// ## What this screen is NOT
///
/// It is not the app's old first-run carousel (`onboarding_page.dart`), which
/// has no web counterpart at all. The two currently coexist because the router
/// — which this slice does not own — still points `/onboarding` at the
/// carousel and gates it on a local SharedPreferences flag AHEAD of auth,
/// whereas this screen is post-auth and gated on
/// `UserPreferences.onboardingCompleted`, exactly as the web is. Repointing the
/// route and moving the gate is an orchestrator change, and it is reported
/// rather than made here.
class OnboardingChatPage extends StatelessWidget {
  const OnboardingChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ZaveScaffold(
      title: 'Plexa setup',
      // The body is a separate widget so it is built BELOW the scaffold, where
      // ZaveScaffold.contentTop resolves to the real header height. Read from
      // this build's context it would silently return the status-bar inset and
      // the first line of the thread would render under the header.
      body: _OnboardingBody(),
    );
  }
}

class _OnboardingBody extends ConsumerStatefulWidget {
  const _OnboardingBody();

  @override
  ConsumerState<_OnboardingBody> createState() => _OnboardingBodyState();
}

class _OnboardingBodyState extends ConsumerState<_OnboardingBody> {
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
              Expanded(
                child: OnboardingProgress(percent: chat.step.progressPercent),
              ),
              SizedBox(width: ZaveSpace.md),
              ZaveIconButton(
                icon: const Icon(Icons.logout),
                tooltip: 'Log out',
                onPressed: _confirmLogout,
              ),
            ],
          ),
        ),
        Expanded(
          child: _Thread(controller: _thread, chat: chat),
        ),
        OnboardingDock(child: _DockControl(chat: chat)),
      ],
    );
  }
}

/// The conversation.
class _Thread extends StatelessWidget {
  const _Thread({required this.controller, required this.chat});

  final ScrollController controller;
  final OnboardingChatState chat;

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
          );
        }
        final ChatMessage message = messages[index];
        // Consecutive lines from one speaker drop the avatar and the eyebrow,
        // so a two-line answer reads as one turn.
        final bool grouped =
            index > 0 && messages[index - 1].role == message.role;
        return ChatMessageRow(message: message, grouped: grouped);
      },
    );
  }
}

/// Whichever control this step is answered with.
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
          ReplyChip(
            // First person, because it answers the greeting's "Ready?" — and
            // because it is echoed verbatim as the user's own bubble.
            label: "I'm ready",
            onTap: controller().acknowledgeWelcome,
          ),
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
      OnboardingStep.role => RolePicker(
        hint: hint,
        onPick: (String role) => controller().pickRole(role),
      ),
      OnboardingStep.goal => ReplyLane(
        hint: hint,
        chips: <Widget>[
          for (final OnboardingGoal goal in OnboardingGoal.values)
            ReplyChip(
              label: goal.label,
              onTap: () => controller().pickGoal(goal),
            ),
        ],
      ),
      OnboardingStep.connect => ReplyLane(
        hint: hint,
        chips: <Widget>[
          ReplyChip(
            label: chat.connectFailed ? 'Try again' : 'Connect LinkedIn',
            onTap: () => controller().connectLinkedin(),
          ),
          // Only after an attempt has actually failed — see
          // OnboardingChatState.connectFailed.
          if (chat.connectFailed)
            ReplyChip(
              label: "I'll connect later",
              onTap: () => controller().skipConnect(),
            ),
        ],
      ),
      OnboardingStep.voice => TonePanel(
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

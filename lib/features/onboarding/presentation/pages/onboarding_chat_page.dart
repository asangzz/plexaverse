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
import '../../../settings/domain/settings_repository.dart';

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
                child: OnboardingProgress(
                  percent: chat.step.progressPercent(
                    company: chat.answers.brand == BrandChoice.company,
                  ),
                ),
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
      // The pages come from the connected account, so they are fetched when
      // the step is reached rather than held in chat state — a list that can
      // fail needs somewhere to show the failure.
      OnboardingStep.companyPage => _CompanyPageChips(hint: hint),
      OnboardingStep.companyDetails => _CompanyDetailsPanel(
        answers: chat.answers,
        onChanged: controller().setCompanyDraft,
        onSubmit: controller().submitCompanyDetails,
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

/// The company pages the connected account administers, as reply chips.
///
/// Fetched here rather than held in chat state: the list comes from LinkedIn
/// through the connected account, so it can be slow, empty, or refused — and
/// a control that can fail needs somewhere of its own to say so.
///
/// The server answers three ways and all three are reachable. A live list, a
/// single already-saved page, or nothing at all with `needsManualInput` when
/// `rw_organization_admin` was never granted. For that last group there is
/// no chip to tap, so the escape is the only way through and is always
/// offered rather than being revealed after a failure.
class _CompanyPageChips extends ConsumerStatefulWidget {
  const _CompanyPageChips({required this.hint});

  final String? hint;

  @override
  ConsumerState<_CompanyPageChips> createState() => _CompanyPageChipsState();
}

class _CompanyPageChipsState extends ConsumerState<_CompanyPageChips> {
  late Future<CompanyPageOptions> _pages;

  @override
  void initState() {
    super.initState();
    _pages = ref.read(onboardingChatControllerProvider.notifier).companyPages();
  }

  @override
  Widget build(BuildContext context) {
    final OnboardingChatController controller =
        ref.read(onboardingChatControllerProvider.notifier);

    return FutureBuilder<CompanyPageOptions>(
      future: _pages,
      builder: (BuildContext context, AsyncSnapshot<CompanyPageOptions> snap) {
        final List<CompanyPage> pages =
            snap.data?.pages ?? const <CompanyPage>[];
        return ReplyLane(
          hint: widget.hint,
          chips: <Widget>[
            if (snap.connectionState == ConnectionState.waiting)
              const ReplyChip(label: 'Looking…', onTap: null)
            else ...<Widget>[
              for (final CompanyPage page in pages)
                ReplyChip(
                  label: page.name,
                  onTap: () => controller.pickCompanyPage(page.id, page.name),
                ),
              // Always present: for an account that administers no pages it
              // is the only way forward, and for one that does it is still a
              // legitimate "not now".
              ReplyChip(
                label: "I'll pick it later",
                onTap: controller.skipCompanyPage,
              ),
            ],
          ],
        );
      },
    );
  }
}

/// The company document — what the company does, its industry, its tagline.
///
/// A panel rather than chips because it is three fields, and the dock's
/// panel lane exists precisely so a tall form does not get auto-scrolled
/// into a thread.
///
/// Only the description is required. Industry and tagline sharpen what gets
/// written but a company without a tagline should not be blocked from
/// finishing setup over one.
class _CompanyDetailsPanel extends StatefulWidget {
  const _CompanyDetailsPanel({
    required this.answers,
    required this.onChanged,
    required this.onSubmit,
  });

  final OnboardingAnswers answers;
  final void Function({String? description, String? industry, String? tagline})
      onChanged;
  final VoidCallback onSubmit;

  @override
  State<_CompanyDetailsPanel> createState() => _CompanyDetailsPanelState();
}

class _CompanyDetailsPanelState extends State<_CompanyDetailsPanel> {
  /// Seeded from the answers so a field survives a rebuild — the thread
  /// above this panel grows while the user is typing in it.
  late final TextEditingController _description =
      TextEditingController(text: widget.answers.companyDescription);
  late final TextEditingController _industry =
      TextEditingController(text: widget.answers.companyIndustry);
  late final TextEditingController _tagline =
      TextEditingController(text: widget.answers.companyTagline);

  @override
  void dispose() {
    _description.dispose();
    _industry.dispose();
    _tagline.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ZaveField(
          controller: _description,
          hint: 'What the company does, in two sentences',
          maxLines: 3,
          onChanged: (String v) => widget.onChanged(description: v),
        ),
        SizedBox(height: ZaveSpace.md),
        ZaveField(
          controller: _industry,
          hint: 'Industry (optional)',
          onChanged: (String v) => widget.onChanged(industry: v),
        ),
        SizedBox(height: ZaveSpace.md),
        ZaveField(
          controller: _tagline,
          hint: 'Tagline (optional)',
          onChanged: (String v) => widget.onChanged(tagline: v),
        ),
        SizedBox(height: ZaveSpace.lg),
        ZaveButton.primary(
          label: 'That is us',
          expand: true,
          onPressed: widget.onSubmit,
        ),
      ],
    );
  }
}

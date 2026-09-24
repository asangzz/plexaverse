import 'dart:async' show unawaited;
import 'dart:math' as math;

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../preferences/application/preferences_controller.dart';
import '../../settings/data/settings_repositories.dart';
import '../../settings/domain/settings_repository.dart';
import '../data/onboarding_repositories.dart';
import '../domain/onboarding_repository.dart';
import 'onboarding_chat_state.dart';
import '../../../core/platform/image_picking.dart';

export 'onboarding_chat_state.dart';

part 'onboarding_chat_controller.g.dart';

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
@riverpod
class OnboardingChatController extends _$OnboardingChatController {
  /// Web `BOT_DELAY_MS`.
  static const Duration _botDelay = Duration(milliseconds: 700);

  /// Web `SEQ_FIRST_MS` / `SEQ_NEXT_MS` — a multi-line answer lands faster on
  /// its first line and slower on the rest, so it reads as one thought being
  /// finished rather than two separate ones.
  static const Duration _seqFirst = Duration(milliseconds: 600);
  static const Duration _seqNext = Duration(milliseconds: 950);

  /// Web: the pause between "your dashboard is ready" and the redirect. Long
  /// enough to read the line, short enough not to feel stuck.
  static const Duration _handover = Duration(milliseconds: 1100);

  /// The shortest writing sample that tells us anything. Web: `< 20` is
  /// rejected with a nudge rather than saved.
  static const int _minVoiceSample = 20;

  int _generation = 0;
  bool _disposed = false;
  final math.Random _random = math.Random();

  @override
  OnboardingChatState build() {
    ref.onDispose(() => _disposed = true);
    // The greeting and the first line cannot be produced during build — a
    // notifier may not write its own state while building — so both are
    // scheduled onto the next microtask.
    Future<void>.microtask(_open);
    return const OnboardingChatState();
  }

  OnboardingRepository get _repo => ref.read(onboardingRepositoryProvider);

  /// The connect step borrows the Settings slice's browser hand-off rather
  /// than duplicating it — see [connectLinkedin].
  SettingsRepository get _settings => ref.read(settingsRepositoryProvider);

  /// True while the state this code is about to write is still the state the
  /// screen is showing.
  bool _current(int generation) => !_disposed && generation == _generation;

  Future<void> _open() async {
    final String? name = await _repo.fetchDisplayName();
    if (_disposed) return;
    if (name != null && name.trim().isNotEmpty) {
      state = state.copyWith(firstName: name.trim().split(' ').first);
    }
    await _enter(OnboardingStep.welcome);
  }

  // ── Thread primitives ─────────────────────────────────────────────────────

  String _newId() =>
      '${DateTime.now().microsecondsSinceEpoch}-${_random.nextInt(0xFFFF)}';

  void _push(ChatMessage message) {
    state = state.copyWith(messages: <ChatMessage>[...state.messages, message]);
  }

  /// Plexa types, pauses, then speaks.
  Future<void> _sendBot(String text, [Duration delay = _botDelay]) async {
    final int generation = _generation;
    state = state.copyWith(isBotTyping: true);
    await Future<void>.delayed(delay);
    if (!_current(generation)) return;
    state = state.copyWith(isBotTyping: false);
    _push(ChatMessage(id: _newId(), role: ChatRole.bot, text: text));
  }

  Future<void> _sendBotSequence(List<String> lines) async {
    final int generation = _generation;
    for (int i = 0; i < lines.length; i++) {
      if (!_current(generation)) return;
      await _sendBot(lines[i], i == 0 ? _seqFirst : _seqNext);
    }
  }

  /// The user's turn lands in the thread verbatim.
  ///
  /// On a reply step this is the string that was on the chip the user just
  /// tapped: the chip and the bubble it becomes carry the same text in the same
  /// lane, which is what makes the tap read as sending rather than as
  /// configuring something.
  void _echoUser(String text, {String? badge}) {
    _push(
      ChatMessage(id: _newId(), role: ChatRole.user, text: text, badge: badge),
    );
    if (!state.hasUserSent) state = state.copyWith(hasUserSent: true);
  }

  /// Moves to [next] and speaks its lines. Every transition goes through here.
  Future<void> _enter(OnboardingStep next) async {
    _generation += 1;
    state = state.copyWith(step: next, isBotTyping: false);
    await _sendBotSequence(next.botLines(state.firstName ?? 'there'));
    if (next == OnboardingStep.finish && !_disposed) await _finalise();
  }

  // ── The script ────────────────────────────────────────────────────────────

  /// "I'm ready" — the user's own line, answering the greeting's "Ready?".
  Future<void> acknowledgeWelcome() async {
    if (state.step != OnboardingStep.welcome) return;
    _echoUser("I'm ready");
    await _enter(OnboardingStep.brand);
  }

  Future<void> pickBrand(BrandChoice brand) async {
    if (state.step != OnboardingStep.brand) return;
    _echoUser(brand.label);
    state = state.copyWith(answers: state.answers.copyWith(brand: brand));
    await _enter(OnboardingStep.role);
  }

  /// The four common roles and the free-text "Other…" answer both land here.
  ///
  /// Seeding the profession matters more than it looks: without it the column
  /// silently defaulted to "Professional" on the web, which drove a wrong
  /// roadmap and off-target posts for every user who skipped the CV import.
  Future<void> pickRole(String role) async {
    if (state.step != OnboardingStep.role) return;
    final String trimmed = role.trim();
    if (trimmed.isEmpty) return;

    _echoUser(trimmed, badge: 'Role set');
    state = state.copyWith(answers: state.answers.copyWith(role: trimmed));

    // Deliberately NOT awaited before advancing. The analysis only enriches the
    // preferences write at the end, and making the user wait on a model call
    // between two chip taps would be the slowest moment in the whole flow for
    // something they never see.
    unawaited(_analyseRole(trimmed));

    await _enter(OnboardingStep.goal);
  }

  Future<void> _analyseRole(String role) async {
    final ProfessionAnalysis? analysis = await _repo.analyzeProfession(role);
    if (_disposed || analysis == null) return;
    state = state.copyWith(
      answers: state.answers.copyWith(
        // The server falls back to the literal 'Professional' when it cannot
        // read the headline. That is the exact value this step exists to avoid
        // writing, so the user's own words win over it.
        profession: analysis.profession.trim().isEmpty
            ? role
            : analysis.profession,
        industry: analysis.industry,
        postCategories: analysis.suggestedCategories,
      ),
    );
  }

  Future<void> pickGoal(OnboardingGoal goal) async {
    if (state.step != OnboardingStep.goal) return;
    _echoUser(goal.label);
    state = state.copyWith(answers: state.answers.copyWith(goal: goal));
    await _enter(OnboardingStep.voice);
  }

  /// The web's `style-screenshots` branch: read the voice out of pictures
  /// of posts instead of typing a sample.
  ///
  /// Restored because it was only ever missing for want of a picker. The
  /// extracted text becomes the sample and goes through the SAME
  /// [submitVoiceSample] path — it is saved, echoed and advanced from
  /// identically, so the two branches cannot diverge on what happens after.
  Future<void> useStyleScreenshots() async {
    if (state.step != OnboardingStep.voice) return;
    final ImagePickResult picked =
        await ref.read(imagePickingProvider).pick(ImageSourceKind.gallery);
    if (picked is! PickedImage) {
      // Cancelled, or the picker failed. Backing out is a decision; a real
      // failure still leaves the typing box, which is the other way through.
      return;
    }

    _echoUser('A screenshot of how I write');
    state = state.copyWith(isBotTyping: true);
    final String? extracted = await _repo.analyzeStyleScreenshots(
      <PickedImage>[picked],
    );
    if (_disposed) return;
    state = state.copyWith(isBotTyping: false);

    if (extracted == null) {
      await _sendBot(
        "I couldn't read a writing style out of that one. Try another "
        'screenshot, or just type a couple of sentences.',
      );
      return;
    }

    await _sendBot('Got it — this is what I picked up:\n\n$extracted');
    await submitVoiceSample(extracted);
  }

  /// Keeps the composer's text, so a rejected draft survives the typing hint.
  void setVoiceDraft(String value) => state = state.copyWith(voiceDraft: value);

  /// The writing sample.
  ///
  /// There is no skip, and that is deliberate on the web too: auto-learning a
  /// voice from someone's existing LinkedIn posts needs the `r_member_social`
  /// scope, which the product does not hold, so "skip — learn from my posts"
  /// was a promise that could not be kept and left those users with generic
  /// output forever.
  Future<void> submitVoiceSample(String text) async {
    if (state.step != OnboardingStep.voice) return;
    final String trimmed = text.trim();
    if (trimmed.length < _minVoiceSample) {
      await _sendBot(
        'A bit more would help — aim for 2 short sentences in your real voice.',
      );
      return;
    }

    // Cleared only on success — a rejected draft stays in the box.
    state = state.copyWith(
      voiceDraft: '',
      answers: state.answers.copyWith(voiceSample: trimmed),
    );
    _echoUser(trimmed);

    state = state.copyWith(isBotTyping: true);
    final String? failure = await _repo.saveStyleSample(trimmed);
    if (_disposed) return;
    state = state.copyWith(isBotTyping: false);

    if (failure == null) {
      await _sendBot(
        "Saved. I'll match this voice in everything I generate for you.",
      );
    } else {
      // Advances anyway. Losing the sample costs the first few posts' voice,
      // which the product then picks up from the user's real posts; blocking
      // the finish on it would cost them the whole setup.
      await _sendBot(
        "Couldn't save that — $failure. I'll pick up your voice from your "
        'first few posts instead.',
      );
    }
    await _enter(OnboardingStep.connect);
  }

  // ── Connect LinkedIn ──────────────────────────────────────────────────────

  /// Runs the LinkedIn browser hand-off, then advances.
  ///
  /// Deliberately reuses `SettingsRepository.connectLinkedin` rather than
  /// adding a second implementation to this slice. The hand-off is a PKCE-less
  /// OAuth trip through the system browser with a `plexaverse://` return, and
  /// two copies of that drift — the copy that drifts then fails at LinkedIn
  /// rather than anywhere a stack trace helps.
  ///
  /// `type` is derived from the brand answer, so a company-brand user connects
  /// the account that administers their pages.
  Future<void> connectLinkedin() async {
    if (state.step != OnboardingStep.connect) return;
    _echoUser('Connect LinkedIn');
    state = state.copyWith(isBotTyping: true);

    final String type =
        state.answers.brand == BrandChoice.company ? 'company' : 'personal';
    final ConnectOutcome outcome =
        await _settings.connectLinkedin(type: type);
    if (_disposed) return;
    state = state.copyWith(isBotTyping: false);

    switch (outcome) {
      case ConnectSucceeded():
        state = state.copyWith(connectFailed: false);
        await _sendBot('Connected.');
        await _afterConnect();
      case ConnectCancelled():
        // Backing out of the browser is a decision, not an error — but the
        // step still has to be answered, so say why it matters and offer the
        // escape rather than silently re-asking.
        state = state.copyWith(connectFailed: true);
        await _sendBot(
          "No account connected yet. Without one I can write your posts but "
          "nothing can publish — you can connect now, or do it later from "
          "Settings.",
        );
      case ConnectFailed(:final String? message):
        state = state.copyWith(connectFailed: true);
        await _sendBot(
          message ?? "That didn't go through. Try again, or connect later "
              'from Settings.',
        );
    }
  }

  /// The escape, unlocked only after a failed attempt. See
  /// [OnboardingChatState.connectFailed] for why it is not offered up front.
  Future<void> skipConnect() async {
    if (state.step != OnboardingStep.connect || !state.connectFailed) return;
    _echoUser("I'll connect later");
    await _sendBot(
      'Fine — Settings › Connected Accounts, whenever you are ready.',
    );
    await _afterConnect();
  }

  /// The one place the flow forks.
  ///
  /// A company brand needs a page to publish to and a document to write
  /// from; without them `brandType: 'company'` is a setting with nothing
  /// behind it, and every company surface renders empty. A personal brand
  /// has nothing further to answer.
  Future<void> _afterConnect() => _enter(
        state.answers.brand == BrandChoice.company
            ? OnboardingStep.companyPage
            : OnboardingStep.finish,
      );

  // ── Company brand ─────────────────────────────────────────────────────────

  /// The pages the connected account administers, for the chips.
  ///
  /// Reuses the Settings repository rather than a second copy: the route
  /// answers three different ways (a live list, one saved page, or nothing
  /// with `needsManualInput` when the scope was never granted) and handling
  /// that twice is how the two would come to disagree.
  Future<CompanyPageOptions> companyPages() =>
      _settings.fetchCompanyPages();

  Future<void> pickCompanyPage(String id, String name) async {
    if (state.step != OnboardingStep.companyPage) return;
    _echoUser(name);
    state = state.copyWith(isBotTyping: true);

    // Saved now rather than at finalise: this write goes to the LinkedIn
    // ACCOUNT row, not the preferences patch, so it is not something the
    // single finalise write can carry.
    String? failure;
    try {
      await _settings.setCompanyPage(id);
    } on Object {
      failure = "I couldn't save that page.";
    }
    if (_disposed) return;
    state = state.copyWith(
      isBotTyping: false,
      answers: state.answers.copyWith(
        companyPageId: failure == null ? id : null,
        companyPageName: failure == null ? name : null,
      ),
    );

    if (failure != null) {
      await _sendBot('$failure Try again, or pick a different one.');
      return;
    }
    await _enter(OnboardingStep.companyDetails);
  }

  /// No page to choose — the account administers none, or the scope was
  /// never granted. Moves on rather than trapping the user on a list that
  /// will never populate; Settings can link one later.
  Future<void> skipCompanyPage() async {
    if (state.step != OnboardingStep.companyPage) return;
    _echoUser("I'll pick it later");
    await _sendBot(
      'Fine — Settings › Connected Accounts when you know which page.',
    );
    await _enter(OnboardingStep.companyDetails);
  }

  void setCompanyDraft({
    String? description,
    String? industry,
    String? tagline,
  }) =>
      state = state.copyWith(
        answers: state.answers.copyWith(
          companyDescription: description ?? state.answers.companyDescription,
          companyIndustry: industry ?? state.answers.companyIndustry,
          companyTagline: tagline ?? state.answers.companyTagline,
        ),
      );

  Future<void> submitCompanyDetails() async {
    if (state.step != OnboardingStep.companyDetails) return;
    final String description = (state.answers.companyDescription ?? '').trim();
    if (description.length < 20) {
      await _sendBot(
        'A little more — two sentences on what the company actually does is '
        'enough for me to write from.',
      );
      return;
    }
    _echoUser(description);
    await _enter(OnboardingStep.finish);
  }

  // ── Finish ────────────────────────────────────────────────────────────────

  /// One awaited write, then a fire-and-forget seed, then the handover.
  ///
  /// The order matters: `/ai/suggest-topics` reads the profession and industry
  /// from the preferences row, so it can only run after the row exists. The web
  /// has the same constraint on `derive-audience`, and awaits it for the same
  /// reason — firing it alongside the write loses the race about half the time.
  Future<void> _finalise() async {
    if (state.isFinalising) return;
    state = state.copyWith(isFinalising: true, finaliseError: false);

    try {
      await _repo.completeOnboarding(state.answers.toPreferencesPatch());
    } on OnboardingUnavailable catch (e) {
      if (_disposed) return;
      state = state.copyWith(isFinalising: false, finaliseError: true);
      final String reason = e.reason == null ? '' : ' (${e.reason})';
      await _sendBot(
        'I hit a snag saving your setup$reason. Try again, or head to your '
        'dashboard and finish later.',
      );
      return;
    }
    if (_disposed) return;

    // That PATCH is what set `onboardingCompleted` on the server, and the
    // router's onboarding gate reads exactly that field — out of a cache
    // still holding the `false` it was built with. Without this, the chat
    // says "taking you there now", flips the device flag, and the guard sends
    // the user straight back into the chat they just finished.
    //
    // Dropped here rather than after the handover so the refetch overlaps the
    // closing lines: by the time the gate flips the answer has usually landed,
    // and when it has not the guard holds the splash instead of guessing.
    ref.invalidate(preferencesControllerProvider);

    // The post-finalise fan-out: grounding, audience, week one, the roadmap and
    // topics. It runs in the background so the handover is not held up, but
    // each piece matters — without the roadmap the home screen is empty, and
    // without the week plan the planner is.
    unawaited(
      _repo.seedAfterOnboarding(
        profession: state.answers.profession,
        industry: state.answers.industry,
        brandType: (state.answers.brand ?? BrandChoice.personal).name,
      ),
    );

    await _sendBot(
      'Your dashboard is ready — taking you there now.',
      const Duration(milliseconds: 600),
    );
    await Future<void>.delayed(_handover);
    if (_disposed) return;
    state = state.copyWith(completed: true);
  }

  /// "Try again" after a failed finalise.
  Future<void> retryFinalise() async {
    if (state.isFinalising) return;
    _echoUser('Try again');
    state = state.copyWith(finaliseError: false);
    await _finalise();
  }

  /// "Skip to dashboard" after a failed finalise.
  ///
  /// The server-side `onboardingCompleted` stays false, so the setup is still
  /// outstanding and will be asked for again — this only stops the user being
  /// trapped on a screen whose one exit is a call that keeps failing.
  void skipToDashboard() {
    _echoUser('Skip to dashboard', badge: 'Skipped');
    state = state.copyWith(completed: true);
  }
}

import 'dart:async' show unawaited;
import 'dart:math' as math;

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../preferences/application/preferences_controller.dart';
import '../../settings/data/settings_repositories.dart';
import '../../settings/domain/settings_repository.dart';
import '../data/onboarding_repositories.dart';
import '../domain/onboarding_repository.dart';
import 'onboarding_chat_state.dart';
import 'welcome_bonus.dart';
import '../../../core/platform/file_picking.dart';
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
    final List<String> lines = next == OnboardingStep.companyDetails
        ? <String>[companyDetailsAsk(state.answers.companyDoc)]
        : next.botLines(
            firstName: state.firstName ?? 'there',
            company: state.answers.isCompany,
          );
    await _sendBotSequence(lines);
    if (next == OnboardingStep.finish && !_disposed) await _finalise();
  }

  /// The company-details line, which names only what is missing — the web's
  /// `company-details` entry message, verbatim.
  ///
  /// A different lead-in for "skipped the upload" and "uploaded but thin".
  static String companyDetailsAsk(CompanyDoc? doc) {
    final CompanyDocGaps gaps = CompanyDocGaps.of(doc);
    final List<String> asks = <String>[
      if (gaps.needDescription) 'what you do',
      if (gaps.needIndustry) 'your industry',
      if (gaps.needFeatures) 'your products',
      if (gaps.needWebsite) 'your website',
    ];
    final String askLine = asks.isEmpty ? 'a few details' : asks.join(', ');
    final String intro = doc != null
        ? 'Your document was thin on'
        : "Then I'll need";
    return '$intro $askLine. These keep every post on your real products, '
        'not generic filler.';
  }

  /// The step's real answer arrives as an uploaded file; bad picks are
  /// answered by Plexa rather than by the upload failing.
  bool _isPdf(PickedFile f) => f.extension == 'pdf';

  bool _isImage(PickedFile f) => const <String>{
    'png',
    'jpg',
    'jpeg',
    'webp',
    'gif',
    'heic',
  }.contains(f.extension);

  Future<PickedFile?> _pick(List<String> extensions) async {
    final FilePickResult picked = await ref
        .read(filePickingProvider)
        .pick(extensions: extensions);
    // Cancelled, or the picker failed: backing out is a decision, and a real
    // failure leaves the same control on screen to try again.
    return picked is PickedFile ? picked : null;
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
    await _enter(OnboardingStep.connect);
  }

  // ── Connect LinkedIn ──────────────────────────────────────────────────────

  /// Runs the LinkedIn browser hand-off, then advances.
  ///
  /// Reuses `SettingsRepository.connectLinkedin` rather than a second copy:
  /// the hand-off is an OAuth trip through the system browser with a
  /// `plexaverse://` return, and two copies of that drift.
  ///
  /// `type` is derived from the brand answer, so a company-brand user connects
  /// the account that administers their pages.
  Future<void> connectLinkedin() async {
    if (state.step != OnboardingStep.connect) return;
    _echoUser('Opening LinkedIn…');
    state = state.copyWith(isBotTyping: true);

    final String type = state.answers.isCompany ? 'company' : 'personal';
    final ConnectOutcome outcome = await _settings.connectLinkedin(type: type);
    if (_disposed) return;
    state = state.copyWith(isBotTyping: false);

    switch (outcome) {
      case ConnectSucceeded():
        await _connected(type);
      case ConnectCancelled():
      case ConnectFailed():
        state = state.copyWith(connectFailed: true);
        await _sendBot(
          "Hmm, that LinkedIn connection didn't complete. Let's try again — "
          "tap Connect when you're ready.",
        );
    }
  }

  /// The web's `verifyLinkedInConnection`: the server is the source of truth
  /// for who connected, so the name in "Connected as …" is read back from it.
  Future<void> _connected(String type) async {
    String? name;
    try {
      final List<LinkedinAccount> accounts = await _settings
          .fetchLinkedinAccounts();
      // The account this connect was for — the web asks the server for
      // `?type=company` or `?type=personal`, so the name shown is the one
      // just connected, not an older account of the other kind.
      bool ofType(LinkedinAccount a) =>
          (type == 'company') == (a.appType == 'company');
      final LinkedinAccount? account =
          accounts.where(ofType).firstOrNull ?? accounts.firstOrNull;
      name = account?.profileName;
    } on Object {
      // The connect itself succeeded; a failed read only costs the name.
    }
    if (_disposed) return;
    // The server credited the welcome bonus on this connect; the screen
    // celebrates it once it sees the fresh transaction.
    ref.invalidate(welcomeBonusProvider);
    state = state.copyWith(connectFailed: false, linkedinName: name);
    _echoUser(
      name == null ? 'Connected' : 'Connected as $name',
      badge: 'LinkedIn linked',
    );
    await _enter(
      state.answers.isCompany
          ? OnboardingStep.companyPage
          : OnboardingStep.cvUpload,
    );
  }

  /// "I'll connect later" — offered only after a failed attempt. The one
  /// deliberate difference from the web; see
  /// [OnboardingChatState.connectFailed].
  Future<void> skipConnect() async {
    if (state.step != OnboardingStep.connect || !state.connectFailed) return;
    _echoUser("I'll connect later", badge: 'Skipped');
    await _enter(
      state.answers.isCompany
          ? OnboardingStep.companyPage
          : OnboardingStep.cvUpload,
    );
  }

  // ── Company page ──────────────────────────────────────────────────────────

  /// The pages the connected account administers.
  Future<CompanyPageOptions> companyPages() => _settings.fetchCompanyPages();

  Future<void> pickCompanyPage(String id, String name) async {
    if (state.step != OnboardingStep.companyPage) return;
    _echoUser(name, badge: 'Page selected');
    state = state.copyWith(
      answers: state.answers.copyWith(companyPageId: id, companyPageName: name),
    );
    // Persisting the page is what actually links a company brand — the
    // server credits the welcome XP here. Not awaited, as on the web.
    unawaited(_savePage(id));
    await _enter(OnboardingStep.companyLogo);
  }

  Future<void> _savePage(String id) async {
    try {
      await _settings.setCompanyPage(id);
      // A company brand's bonus is credited here, not on the connect.
      if (!_disposed) ref.invalidate(welcomeBonusProvider);
    } on Object {
      // The finalise write carries the page id too.
    }
  }

  /// No usable page on this account → connect a different company account.
  Future<void> reconnectCompany() async {
    if (state.step != OnboardingStep.companyPage) return;
    _echoUser('Connect another company profile', badge: 'Reconnect');
    state = state.copyWith(connectFailed: false, linkedinName: null);
    await _enter(OnboardingStep.connect);
  }

  /// No usable page on this account → be a personal brand instead.
  Future<void> switchToPersonal() async {
    if (state.step != OnboardingStep.companyPage) return;
    _echoUser('Switch to personal brand', badge: 'Switched');
    state = state.copyWith(
      connectFailed: false,
      linkedinName: null,
      answers: state.answers.copyWith(brand: BrandChoice.personal),
    );
    await _enter(OnboardingStep.connect);
  }

  // ── Company logo & poster style ───────────────────────────────────────────

  /// Required. Stored without a re-encode, so a transparent PNG stays
  /// transparent on every poster.
  Future<void> uploadLogo() async {
    if (state.step != OnboardingStep.companyLogo) return;
    final PickedFile? file = await _pick(const <String>[
      'png',
      'jpg',
      'jpeg',
      'webp',
    ]);
    if (file == null || _disposed) return;
    if (!_isImage(file)) {
      await _sendBot(
        "That doesn't look like an image — upload a PNG or JPG logo.",
      );
      return;
    }
    if (file.bytes.length > 8 * 1024 * 1024) {
      await _sendBot('That file is over 8MB — try a smaller export.');
      return;
    }
    _echoUser(file.name, badge: 'Logo uploaded');
    state = state.copyWith(isBotTyping: true);
    try {
      final String url = await _repo.uploadLogo(file);
      if (_disposed) return;
      state = state.copyWith(
        isBotTyping: false,
        answers: state.answers.copyWith(companyLogoUrl: url),
      );
      await _sendBot(
        "Perfect — your logo's locked in and I'll brand your posters with it.",
      );
      await _enter(OnboardingStep.posterStyle);
    } on OnboardingUnavailable catch (e) {
      if (_disposed) return;
      state = state.copyWith(isBotTyping: false);
      await _sendBot(
        "I couldn't save that logo — ${e.reason ?? 'Upload failed'}. Try "
        'another image.',
      );
    }
  }

  /// Optional — skipping it gets a strong default style at generation time.
  Future<void> uploadPosterStyle() async {
    if (state.step != OnboardingStep.posterStyle) return;
    final PickedFile? file = await _pick(const <String>[
      'png',
      'jpg',
      'jpeg',
      'webp',
    ]);
    if (file == null || _disposed) return;
    if (!_isImage(file)) {
      await _sendBot(
        "That doesn't look like an image — upload a PNG or JPG poster, or skip.",
      );
      return;
    }
    if (file.bytes.length > 8 * 1024 * 1024) {
      await _sendBot('That file is over 8MB — try a smaller export, or skip.');
      return;
    }
    _echoUser(file.name, badge: 'Poster uploaded');
    state = state.copyWith(isBotTyping: true);
    try {
      final PosterStyle style = await _repo.analyzePosterStyle(file);
      if (_disposed) return;
      state = state.copyWith(
        isBotTyping: false,
        answers: state.answers.copyWith(posterStyle: style),
      );
      final String theme = style.theme == 'light' ? 'light' : 'dark';
      final String accent = style.primaryColor == null
          ? ''
          : ' and ${style.primaryColor} accent';
      await _sendBot(
        "Nice — I'll match your $theme style$accent on the posters I create.",
      );
      await _enter(OnboardingStep.companyDoc);
    } on OnboardingUnavailable catch (e) {
      if (_disposed) return;
      state = state.copyWith(isBotTyping: false);
      await _sendBot(
        "I couldn't read that poster — ${e.reason ?? 'Analysis failed'}. You "
        "can try another, or skip and I'll use a strong default.",
      );
    }
  }

  Future<void> skipPosterStyle() async {
    if (state.step != OnboardingStep.posterStyle) return;
    _echoUser('Skip — use a default style', badge: 'Skipped');
    await _enter(OnboardingStep.companyDoc);
  }

  // ── CV (personal) ─────────────────────────────────────────────────────────

  Future<void> uploadCv() async {
    if (state.step != OnboardingStep.cvUpload) return;
    final PickedFile? file = await _pick(const <String>['pdf']);
    if (file == null || _disposed) return;
    if (!_isPdf(file)) {
      await _sendBot(
        "That doesn't look like a PDF — try saving your LinkedIn profile to "
        'PDF first.',
      );
      return;
    }
    if (file.bytes.length > 5 * 1024 * 1024) {
      await _sendBot('That file is over 5MB — could you try a smaller export?');
      return;
    }
    _echoUser(file.name, badge: 'Uploaded');
    state = state.copyWith(isBotTyping: true);
    try {
      final ParsedCv cv = await _repo.parseCv(file);
      if (_disposed) return;
      state = state.copyWith(
        isBotTyping: false,
        answers: state.answers.copyWith(cv: cv, usedCvUpload: true),
      );
      final String? headline = cv.headline;
      await _sendBot(
        headline != null
            ? 'Got it — I can see you\'re "$headline". I\'ll use this to make '
                  'sure everything sounds like you.'
            : "All read — I've absorbed your background and experience.",
      );
      await _enter(OnboardingStep.styleChoice);
    } on OnboardingUnavailable catch (e) {
      if (_disposed) return;
      state = state.copyWith(isBotTyping: false);
      await _sendBot(
        "I couldn't read that one — ${e.reason ?? 'Upload failed'}. Try "
        'another PDF, or skip below to keep moving.',
      );
    }
  }

  /// No CV means no profession, so the current role is asked for instead of
  /// silently defaulting to "Professional".
  Future<void> skipCv() async {
    if (state.step != OnboardingStep.cvUpload) return;
    _echoUser('Skip for now', badge: 'Skipped');
    await _enter(OnboardingStep.currentRole);
  }

  /// The four common roles and the free-text "Other…" answer both land here.
  Future<void> pickRole(String role) async {
    if (state.step != OnboardingStep.currentRole) return;
    final String trimmed = role.trim();
    if (trimmed.isEmpty) return;
    _echoUser(trimmed, badge: 'Role set');
    // The web seeds `parsedCV = { profession }`, so the finalise write cannot
    // tell — and does not need to — which way the profession arrived.
    state = state.copyWith(
      answers: state.answers.copyWith(
        cv: ParsedCv(
          headline: state.answers.cv?.headline,
          profession: trimmed,
          industry: state.answers.cv?.industry,
          summary: state.answers.cv?.summary,
          skills: state.answers.cv?.skills,
          positions: state.answers.cv?.positions,
          education: state.answers.cv?.education,
        ),
      ),
    );
    await _enter(OnboardingStep.styleChoice);
  }

  // ── Company document & details ────────────────────────────────────────────

  Future<void> uploadCompanyDoc() async {
    if (state.step != OnboardingStep.companyDoc) return;
    final PickedFile? file = await _pick(const <String>['pdf']);
    if (file == null || _disposed) return;
    if (!_isPdf(file)) {
      await _sendBot(
        "That doesn't look like a PDF — export your doc to PDF and try again, "
        'or skip below.',
      );
      return;
    }
    if (file.bytes.length > 5 * 1024 * 1024) {
      await _sendBot('That file is over 5MB — could you try a smaller export?');
      return;
    }
    _echoUser(file.name, badge: 'Uploaded');
    state = state.copyWith(isBotTyping: true);
    try {
      final CompanyDoc doc = await _repo.parseCompanyDoc(file);
      if (_disposed) return;
      state = state.copyWith(
        isBotTyping: false,
        answers: state.answers.copyWith(companyDoc: doc),
      );
      if (CompanyDocGaps.of(doc).sufficient) {
        await _sendBot(
          'Got it — "${doc.description}". I\'ll use this to keep every post '
          'on-brand.',
        );
        await _enter(OnboardingStep.styleChoice);
      } else {
        // Not enough to write from — ask for the gaps rather than fall back to
        // generic content.
        await _enter(OnboardingStep.companyDetails);
      }
    } on OnboardingUnavailable catch (e) {
      if (_disposed) return;
      state = state.copyWith(isBotTyping: false);
      await _sendBot(
        "I couldn't read that one — ${e.reason ?? 'Upload failed'}. Try "
        'another PDF, or skip and tell me about your company instead.',
      );
    }
  }

  Future<void> skipCompanyDoc() async {
    if (state.step != OnboardingStep.companyDoc) return;
    _echoUser("Skip — I'll tell you directly", badge: 'Skipped');
    await _enter(OnboardingStep.companyDetails);
  }

  /// The details form, merged over whatever the document did say. The web's
  /// `handleCompanyDetailsSubmit`: features the user typed come first, then
  /// any the document had, deduplicated, at most twenty.
  Future<void> submitCompanyDetails({
    required String description,
    required String industry,
    required String tagline,
    required List<String> features,
    required String website,
  }) async {
    if (state.step != OnboardingStep.companyDetails) return;
    final CompanyDoc? doc = state.answers.companyDoc;
    String cap(String v, int max) => v.length <= max ? v : v.substring(0, max);
    final List<String> mergedFeatures = <String>{
      for (final String f in <String>[...features, ...?doc?.features])
        if (f.trim().isNotEmpty) f.trim(),
    }.take(20).toList();
    final CompanyDoc merged = CompanyDoc(
      description: cap(description.trim(), 2000),
      industry: cap(industry.trim(), 200),
      tagline: cap(
        tagline.trim().isNotEmpty ? tagline.trim() : (doc?.tagline ?? ''),
        300,
      ),
      features: mergedFeatures,
      website: cap(
        website.trim().isNotEmpty ? website.trim() : (doc?.website ?? ''),
        200,
      ),
    );
    state = state.copyWith(answers: state.answers.copyWith(companyDoc: merged));
    _echoUser('Company details added', badge: 'Saved');
    await _enter(OnboardingStep.styleChoice);
  }

  // ── Voice ─────────────────────────────────────────────────────────────────

  Future<void> chooseScreenshots() async {
    if (state.step != OnboardingStep.styleChoice) return;
    _echoUser('Upload screenshots');
    await _enter(OnboardingStep.styleScreenshots);
  }

  Future<void> chooseWrite() async {
    if (state.step != OnboardingStep.styleChoice) return;
    _echoUser('Write a sample');
    await _enter(OnboardingStep.styleWrite);
  }

  /// Screenshots are optional — a written sample is not. Skipping them falls
  /// through to the written sample, never past it: learning a voice from
  /// someone's LinkedIn history needs a scope the product does not hold.
  Future<void> skipScreenshots() async {
    if (state.step != OnboardingStep.styleChoice &&
        state.step != OnboardingStep.styleScreenshots) {
      return;
    }
    _echoUser("I'll type a sample instead", badge: 'Skipped screenshots');
    await _enter(OnboardingStep.styleWrite);
  }

  /// Up to five screenshots of the user's own posts.
  Future<void> uploadScreenshots() async {
    if (state.step != OnboardingStep.styleScreenshots) return;
    final List<PickedImage> images = await ref
        .read(imagePickingProvider)
        .pickMany(limit: 5);
    if (images.isEmpty || _disposed) return;
    _echoUser(
      '${images.length} screenshot${images.length > 1 ? 's' : ''}',
      badge: 'Uploaded',
    );
    state = state.copyWith(isBotTyping: true);
    final String? read = await _repo.analyzeStyleScreenshots(images);
    if (_disposed) return;
    state = state.copyWith(isBotTyping: false);
    if (read == null) {
      await _sendBot(
        'Hmm, I had trouble reading those — Analysis failed. Want to write a '
        'quick sample instead?',
      );
      await _enter(OnboardingStep.styleWrite);
      return;
    }
    await _sendBot(
      "Perfect — I've picked up your tone, vocabulary and post structure. "
      "I'll write in your voice from here.",
    );
    await _enter(OnboardingStep.finish);
  }

  /// Keeps the composer's text, so a rejected draft survives the typing hint.
  void setVoiceDraft(String value) => state = state.copyWith(voiceDraft: value);

  /// The written sample. No skip — this is the last place the voice can be
  /// captured.
  Future<void> submitVoiceSample(String text) async {
    if (state.step != OnboardingStep.styleWrite) return;
    final String trimmed = text.trim();
    if (trimmed.length < _minVoiceSample) {
      await _sendBot(
        'A bit more would help — aim for 2 short sentences in your real voice.',
      );
      return;
    }

    // Cleared only on success — a rejected draft stays in the box.
    state = state.copyWith(voiceDraft: '');
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
      // Advances anyway, as the web does: losing the sample costs the first
      // few posts' voice; blocking the finish on it would cost the setup.
      await _sendBot(
        "Couldn't save that — $failure. I'll pick up your voice from your "
        'first few posts instead.',
      );
    }
    await _enter(OnboardingStep.finish);
  }

  // ── Finish ────────────────────────────────────────────────────────────────

  /// One awaited write, then a fire-and-forget seed, then the handover.
  ///
  /// The order matters: `derive-audience` and the roadmap read the
  /// preferences row this write creates, so the seed runs after it, never
  /// beside it.
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
    unawaited(_repo.seedAfterOnboarding(state.answers));

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

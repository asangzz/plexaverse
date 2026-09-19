/// The onboarding script — the steps, their lanes, and every line Plexa says.
///
/// Ported from `components/onboarding/OnboardingChat.tsx` (the LIVE onboarding;
/// `components/automate/PersonalizedOnboarding.tsx` and its two children are
/// dead code with zero importers and are deliberately NOT ported — porting them
/// would give the app a second, contradictory onboarding design).
///
/// ## Which of the web's steps are here
///
/// The web runs two branches — personal and company — over eighteen declared
/// steps, of which three are hidden behind two `false` feature flags. Of the
/// rest, the ones that survive on mobile today are the ones the mobile API and
/// this app's dependencies can actually serve:
///
/// | Web step | Here | Why |
/// |---|---|---|
/// | `welcome` | [OnboardingStep.welcome] | — |
/// | `brand` | [OnboardingStep.brand] | — |
/// | `current-role` | [OnboardingStep.role] | The web reaches it only when the CV upload is SKIPPED. Here it is the primary profession capture, because the CV path needs a file picker this app does not depend on. |
/// | `style-choice` / `style-write` | [OnboardingStep.voice] | Collapsed to one step: the screenshot branch needs an image picker. |
/// | `finish` | [OnboardingStep.finish] | — |
/// | — | [OnboardingStep.goal] | **Added.** See the note on [OnboardingStep.goal]. |
/// | `connect-linkedin` | [OnboardingStep.connect] | Present. It was omitted on the grounds that OAuth "belongs to the accounts surface" — true in isolation, and wrong in consequence: a user who onboarded on their phone reached the dashboard with no LinkedIn account, so nothing could publish and the entire product was inert for them. |
/// | `cv-upload`, `company-doc` | absent | Both take a PDF, which needs `file_picker`; `image_picker` cannot open documents. |
/// | `style-screenshots` | folded into [OnboardingStep.voice] | Present as the second branch of the voice step rather than a step of its own — the web splits them only because its choice screen has to ask which one you want first, and a button beside the text box asks the same question in less space. |
/// | `company-page` | [OnboardingStep.companyPage] | Present. |
/// | `company-about`, `company-details` | [OnboardingStep.companyDetails] | Collapsed to one form. The web splits them because it parses an uploaded company document first and asks the user to confirm what it read; there is no document picker here yet, so there is nothing to confirm — only fields to fill. |
/// | `company-logo`, `poster-style` | absent | Need an upload route (`/upload/asset`) and a poster-style analyser that the mobile API does not expose. |
/// | `content-mode`, `target-role`, `who-you-serve` | absent | Hidden on the web too (`TRANSFORMATION_ONBOARDING_ENABLED` / `AUDIENCE_ONBOARDING_ENABLED` are both `false`), so their absence here MATCHES the web as it ships. |
///
/// Every omission is reported rather than faked: a step that cannot complete is
/// worse than a step that is not offered.
enum OnboardingStep {
  welcome,
  brand,

  /// The web's `current-role`. Sets `profession`, which decides the plan.
  role,

  /// **Not a web step.** The web hard-codes the goal at finalise time
  /// (`goals: [brandType === 'company' ? 'brand_building' : 'thought_leadership']`)
  /// because its own roadmap generator only ever reads `goals[0]`. Asking for
  /// it is a deliberate departure: `UserPreferences.goals` is a real column the
  /// roadmap and the planner both read, and the five ids offered here are the
  /// exact five the web's `getGoalLabel` and its milestone table understand —
  /// so nothing downstream sees a value it cannot handle.
  goal,

  /// The web's `style-choice`, `style-write` AND `style-screenshots`,
  /// collapsed into one panel: type a sample, or hand over a screenshot and
  /// let `/ai/analyze-style-screenshot` read the voice out of it. Both
  /// branches end in a real sample, so neither is a skip.
  voice,

  /// The web's `connect-linkedin`, and the one step whose absence broke the
  /// product: without a connected account there is nothing to publish to, so
  /// every downstream surface — planner, posts, auto-post — is inert.
  ///
  /// Runs the same browser hand-off the Settings screen uses
  /// (`SettingsRepository.connectLinkedin`) rather than a second copy of it.
  connect,

  /// **Company brand only.** Which LinkedIn page the account will publish to.
  ///
  /// Sits after [connect] because the list comes from the pages the connected
  /// account administers — there is nothing to choose from before that.
  ///
  /// Skipping it is what made "Company brand" produce an account the web
  /// flow cannot: `brandType: 'company'` with no page, so company posts had
  /// nowhere to go and every company surface was inert.
  companyPage,

  /// **Company brand only.** The company document — what the company does,
  /// its industry and its tagline — which anchors every generated post.
  companyDetails,
  finish;

  /// True for the two steps only a company brand ever sees.
  bool get isCompanyOnly =>
      this == OnboardingStep.companyPage ||
      this == OnboardingStep.companyDetails;

  /// How this step is answered — with a tap, or by typing.
  ///
  /// This is the web's `stepLane`, and the distinction is load-bearing:
  ///
  ///  * **reply** — a chip row in the USER's lane at the end of the thread. A
  ///    choice IS the user's next message, so the control lives where that
  ///    message will appear. It stays live while Plexa is still typing, because
  ///    the typing bubble directly above it already says what a second spinner
  ///    would.
  ///  * **panel** — a composer in the bottom band, full width, with its own
  ///    scroll. Panels never go inline: a tall form at the end of a scrolling
  ///    thread gets its submit button auto-scrolled into view and its first
  ///    field pushed off the top.
  ///
  /// [finish] is the one step whose lane depends on state — the normal finish
  /// is a centred progress hint, and only a FAILED finalise offers chips.
  OnboardingLane lane({bool finaliseError = false}) => switch (this) {
    OnboardingStep.welcome ||
    OnboardingStep.brand ||
    OnboardingStep.role ||
    OnboardingStep.goal ||
    OnboardingStep.connect ||
    OnboardingStep.companyPage => OnboardingLane.reply,
    OnboardingStep.companyDetails => OnboardingLane.panel,
    OnboardingStep.voice => OnboardingLane.panel,
    OnboardingStep.finish =>
      finaliseError ? OnboardingLane.reply : OnboardingLane.panel,
  };

  /// The next step, or null at the end. Linear: unlike the web there is no
  /// company branch here, because none of the company-only steps survived the
  /// mobile cut (see the table above).
  OnboardingStep? get next {
    final int i = OnboardingStep.values.indexOf(this);
    return i == OnboardingStep.values.length - 1
        ? null
        : OnboardingStep.values[i + 1];
  }

  /// `progressPct` from the web: the bar never reads below 5%, so step one
  /// still looks like progress rather than like nothing has happened.
  /// [company] must be passed so a PERSONAL user still reaches 100%.
  ///
  /// The two company steps are in the enum but not in a personal user's
  /// path, and counting them would leave that user's bar stuck in the
  /// eighties at the moment they finish — a progress bar that never fills
  /// reads as something having gone wrong.
  int progressPercent({required bool company}) {
    final List<OnboardingStep> path = company
        ? OnboardingStep.values
        : OnboardingStep.values
              .where((OnboardingStep s) => !s.isCompanyOnly)
              .toList(growable: false);
    final int idx = path.indexOf(this);
    // A company-only step on a personal path cannot happen, but if it ever
    // did, reporting the last known position beats reporting -1.
    if (idx < 0) return 100;
    final double pct = (idx + 1) / path.length * 100;
    final int rounded = pct.round();
    return rounded < 5 ? 5 : rounded;
  }

  /// What Plexa says on entering this step.
  ///
  /// Verbatim from the web wherever a counterpart exists. The governing copy
  /// rule, stated in the web source: *"the dock control below already says what
  /// it is… Say only what the control cannot: why the ask exists, and what it
  /// changes."*
  List<String> botLines(String firstName) => switch (this) {
    OnboardingStep.welcome => <String>[
      "Hey $firstName — I'm Plexa. A few questions, then I write and publish "
          'your LinkedIn posts. Ready?',
    ],
    OnboardingStep.brand => <String>[
      'Personal brand, or a company page you manage?',
    ],
    OnboardingStep.role => <String>[
      "What's your current role? It sets the plan I build for you.",
    ],
    // No web counterpart (the web never asks). Written to the same rule: it
    // says why the ask exists and what it changes, and nothing about the chips.
    OnboardingStep.goal => <String>[
      'And what should these posts be doing for you? It picks the arc I plan.',
    ],
    OnboardingStep.voice => <String>[
      'Now your voice — so posts read like you wrote them.',
    ],
    // Same rule as the rest: the chip says "Connect LinkedIn", so the line
    // says what the chip cannot — that this is the step which makes every
    // other one mean something.
    OnboardingStep.connect => <String>[
      'Now connect LinkedIn. Until you do I can write your posts, but '
          'nothing can publish.',
    ],
    OnboardingStep.companyPage => <String>[
      'Which company page am I posting to?',
    ],
    OnboardingStep.companyDetails => <String>[
      'Tell me what the company does — this anchors every post I write, so '
          'a couple of honest sentences beat a polished one.',
    ],
    OnboardingStep.finish => <String>[
      "That's everything, $firstName. Building your roadmap now…",
    ],
  };
}

/// Where this step's control lives. See [OnboardingStep.lane].
enum OnboardingLane { reply, panel }

/// The brand-type answer. Mirrors `UserPreferences.brandType` on the web.
enum BrandChoice {
  personal('personal', 'Personal brand'),
  company('company', 'Company brand');

  const BrandChoice(this.id, this.label);

  /// The value written to `preferences.brandType`.
  final String id;

  /// The chip label, which is ALSO the user's echoed message — the chip and
  /// the bubble it becomes carry the same string, verbatim.
  final String label;

  /// `preferences.priority`, which the web derives from the same answer.
  String get priority =>
      this == BrandChoice.company ? 'company_brand' : 'personal_brand';
}

/// The four highest-coverage roles, plus a free-text escape.
///
/// `COMMON_ROLES` from the web, in its order and its wording. The web's comment
/// explains why the list exists at all: without it the profession silently
/// defaulted to "Professional", which drove a wrong roadmap and off-target
/// posts.
const List<String> kCommonRoles = <String>[
  'Software Engineer',
  'Founder / Entrepreneur',
  'Sales & Business Development',
  'Marketing & Content',
];

/// What the user wants the posts to do.
///
/// The ids are the web's — `getGoalLabel` in `app/api/ai/generate-roadmap` and
/// `MILESTONE_DEFINITIONS` in `app/api/user/roadmap` both key off exactly these
/// five strings, and the labels are that map's labels. Sending anything else
/// would fall through to a generic milestone set.
enum OnboardingGoal {
  thoughtLeadership('thought_leadership', 'Thought Leadership'),
  jobOpportunities('job_opportunities', 'Career Growth'),
  networking('networking', 'Professional Networking'),
  brandBuilding('brand_building', 'Personal Brand Building'),
  learnShare('learn_share', 'Learning & Knowledge Sharing');

  const OnboardingGoal(this.id, this.label);

  final String id;
  final String label;
}

/// The three tone samples offered above the voice composer.
///
/// `TONE_PRESETS` from `components/chat/PlexaChatKit.tsx`, samples verbatim.
/// Tapping one fills the composer with its sample, exactly as on the web — the
/// preset is a starting draft the user edits, not a mode they select.
enum TonePreset {
  analytical(
    'Analytical',
    'While remote work presents collaboration challenges, structured '
        'organisations maintain culture through deliberate communication.',
  ),
  energetic(
    'Energetic',
    'Total myth! 🛑 Remote work just forces us to be more intentional. My team '
        "has never been closer. It's all about how you manage it!",
  ),
  punchy(
    'Short & punchy',
    'Disagree. Bad management kills culture. Remote work just highlights it.',
  );

  const TonePreset(this.title, this.sample);

  final String title;
  final String sample;
}

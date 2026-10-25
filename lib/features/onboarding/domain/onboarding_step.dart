/// The onboarding script — the steps, their lanes, and every line Plexa says.
///
/// A port of `components/onboarding/OnboardingChat.tsx`, step for step. The
/// web is the source of truth for the ORDER, the BRANCHES and the COPY; read
/// that file before changing any of them here, and change both.
///
/// ## The two paths
///
/// ```
/// personal: welcome → brand → connect → cvUpload ─┬──────────────→ styleChoice ┬→ styleScreenshots ┬→ finish
///                                                  └→ currentRole ─┘            └→ styleWrite ───────┘
///                                                     (CV skipped)
///
/// company:  welcome → brand → connect → companyPage → companyLogo → posterStyle → companyDoc ┬──────────────────→ styleChoice → …
///                                                                                              └→ companyDetails ─┘
///                                                                                       (doc skipped or too thin)
/// ```
///
/// LinkedIn comes second, straight after the brand, on both paths: a company
/// brand cannot pick a page before it, and every later step is worth less to a
/// user who cannot publish.
///
/// ## What the web has that is not here
///
/// `company-about` (declared but unreachable on the web — nothing advances to
/// it), and `content-mode`, `target-role` and `who-you-serve`, which the web
/// hides behind `TRANSFORMATION_ONBOARDING_ENABLED` and
/// `AUDIENCE_ONBOARDING_ENABLED`, both `false`. Their absence here matches the
/// web as it ships; if either flag flips, port the step then.
enum OnboardingStep {
  welcome,
  brand,

  /// `connect-linkedin`. Required — there is no skip, on either platform: a
  /// successful connect is the only way forward.
  connect,

  /// Company only: which LinkedIn page to grow.
  companyPage,

  /// Company only: the logo every generated poster carries. Required.
  companyLogo,

  /// Company only: a poster the company already made, to match. Optional.
  posterStyle,

  /// Personal only: the LinkedIn profile PDF. Optional.
  cvUpload,

  /// Personal only, and only when the CV was skipped: without it the
  /// profession silently defaulted to "Professional", which drove a wrong
  /// roadmap and off-target posts.
  currentRole,

  /// Company only: a company document. Optional — skipping it, or uploading
  /// one too thin to write from, leads to [companyDetails].
  companyDoc,

  /// Company only: the details the document did not supply.
  companyDetails,

  /// How the voice is captured: screenshots, or a written sample.
  styleChoice,
  styleScreenshots,

  /// The written sample. No skip — it is the last place the voice can be
  /// captured.
  styleWrite,
  finish;

  /// How this step is answered — with a tap, or by typing.
  ///
  /// This is the web's `stepLane`, and the distinction is load-bearing:
  ///
  ///  * **reply** — a chip row in the USER's lane at the end of the thread. A
  ///    choice IS the user's next message, so the control lives where that
  ///    message will appear. It stays live while Plexa is still typing,
  ///    because the typing bubble directly above it already says what a
  ///    second spinner would.
  ///  * **panel** — a picker or a form in the bottom band, full width, with
  ///    its own scroll. Panels never go inline: a tall form at the end of a
  ///    scrolling thread gets its submit button auto-scrolled into view and
  ///    its first field pushed off the top.
  ///
  /// [finish] is the one step whose lane depends on state — the normal finish
  /// is a centred progress hint, and only a FAILED finalise offers chips.
  OnboardingLane lane({bool finaliseError = false}) => switch (this) {
    OnboardingStep.welcome ||
    OnboardingStep.brand ||
    OnboardingStep.connect ||
    OnboardingStep.currentRole ||
    OnboardingStep.styleChoice => OnboardingLane.reply,
    OnboardingStep.finish =>
      finaliseError ? OnboardingLane.reply : OnboardingLane.panel,
    _ => OnboardingLane.panel,
  };

  /// The web's `progressPct`.
  ///
  /// Each path counts only its own milestones; the branch steps report the
  /// milestone they belong to, so the bar neither jumps nor stalls on them.
  /// Never below 5%, so step one still looks like progress.
  int progressPercent({required bool company}) {
    final List<OnboardingStep> order = company
        ? const <OnboardingStep>[
            OnboardingStep.welcome,
            OnboardingStep.brand,
            OnboardingStep.connect,
            OnboardingStep.companyPage,
            OnboardingStep.companyLogo,
            OnboardingStep.posterStyle,
            OnboardingStep.companyDoc,
            OnboardingStep.styleChoice,
            OnboardingStep.finish,
          ]
        : const <OnboardingStep>[
            OnboardingStep.welcome,
            OnboardingStep.brand,
            OnboardingStep.connect,
            OnboardingStep.cvUpload,
            OnboardingStep.styleChoice,
            OnboardingStep.finish,
          ];
    final OnboardingStep resolved = switch (this) {
      OnboardingStep.styleScreenshots ||
      OnboardingStep.styleWrite => OnboardingStep.styleChoice,
      OnboardingStep.companyDetails => OnboardingStep.companyDoc,
      OnboardingStep.currentRole => OnboardingStep.cvUpload,
      _ => this,
    };
    final int idx = order.indexOf(resolved);
    final int pct = ((idx + 1) / order.length * 100).round();
    return pct < 5 ? 5 : pct;
  }

  /// What Plexa says on entering this step, verbatim from the web.
  ///
  /// The web's copy rule: *"the dock control below already says what it is…
  /// Say only what the control cannot: why the ask exists, and what it
  /// changes."* [companyDetails] is absent: its line depends on which fields
  /// are missing, so the controller writes it (see `companyDetailsAsk`).
  List<String> botLines({
    required String firstName,
    required bool company,
  }) => switch (this) {
    OnboardingStep.welcome => <String>[
      "Hey $firstName — I'm Plexa. A few questions, then I write and publish "
          'your LinkedIn posts. Ready?',
    ],
    OnboardingStep.brand => <String>[
      'Personal brand, or a company page you manage?',
    ],
    // The XP figure survives HERE and nowhere else — this is the one screen
    // where it can change what the user does next.
    OnboardingStep.connect => <String>[
      company
          ? 'Connect LinkedIn so I can load the company pages you manage. '
                '+$kRegistrationXpLabel XP on connect.'
          : "I'll publish on your behalf and learn from your existing posts. "
                '+$kRegistrationXpLabel XP on connect.',
    ],
    OnboardingStep.companyPage => <String>['Which page do you want to grow?'],
    // The only step with two lines: the second is a procedure the user has to
    // leave the app to follow, and nothing in the dock can carry it.
    OnboardingStep.cvUpload => <String>[
      'Your LinkedIn PDF gives me your headline, skills and experience — so '
          'the posts sound like you.',
      'On LinkedIn: your profile → "More" → "Save to PDF".',
    ],
    OnboardingStep.currentRole => <String>[
      "What's your current role? It sets the plan I build for you.",
    ],
    OnboardingStep.companyLogo => <String>[
      'Your logo goes on every poster I generate.',
    ],
    OnboardingStep.posterStyle => <String>[
      "Made a poster before? I'll match its colors and layout.",
    ],
    OnboardingStep.companyDoc => <String>[
      'A company document tells me what you actually sell, so posts stay '
          'specific.',
    ],
    OnboardingStep.companyDetails => const <String>[],
    OnboardingStep.styleChoice => <String>[
      'Now your voice — so posts read like you wrote them.',
    ],
    OnboardingStep.styleScreenshots => <String>[
      "Posts you wrote yourself — I'll read the tone and rhythm.",
    ],
    OnboardingStep.styleWrite => <String>[
      "I do need this one — it's what makes every post sound like you.",
    ],
    OnboardingStep.finish => <String>[
      "That's everything, $firstName. Building your roadmap now…",
    ],
  };
}

/// The welcome bonus credited on the first LinkedIn connect — the web's
/// `REGISTRATION_XP` (2500), formatted as `toLocaleString()` prints it.
const String kRegistrationXpLabel = '2,500';

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
/// `COMMON_ROLES` from the web, in its order and its wording.
const List<String> kCommonRoles = <String>[
  'Software Engineer',
  'Founder / Entrepreneur',
  'Sales & Business Development',
  'Marketing & Content',
];

/// The three tone samples offered above the writing-sample composer.
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

import 'dart:ui' show Color;

/// Zave colour tokens — the single source of truth for the app's palette.
///
/// Ported 1:1 from the web app's `:root` block in `app/globals.css`. "Zave" is
/// the internal codename for the visual language; the product is still
/// Plexaverse. Every value here has a `--zv-*` counterpart on the web, and the
/// two must not drift: if you change a value, change it on both sides.
///
/// The governing rule of this palette, stated in the web source and repeated
/// here because it is easy to violate by accident:
///
///   **Colour names a status, with exactly one exception.**
///
/// A green thing is done; an amber thing is waiting; a blue thing is on the
/// XP / upgrade path. Ordinary surfaces are white at a low opacity over the
/// ground — never a custom grey. If you find yourself reaching for a colour to
/// make something "pop", reach for a fill step in [ZaveGlass] instead.
///
/// The exception is [violet], the primary action. It is a brand tint and it is
/// meant to be: the Aura reference this palette was retuned against leads with
/// a violet CTA, and that is the single loudest thing about how it feels. One
/// exception, written down, is a palette. Two is a mood board.
class ZaveColors {
  const ZaveColors._();

  // ── Ground ────────────────────────────────────────────────────────────────
  // The surfaces the app is painted ON: a violet-tinted near-black at the top
  // falling to an almost neutral black at the foot.
  //
  // Every value below was SAMPLED from the Aura reference, not chosen by eye.
  // Three independent screens in that set agree: the top sits around #15122E
  // (#190F3E where the bloom is strongest), the middle passes through #1D142C,
  // and the foot lands on #0F0E13. The family is violet, and it is far darker
  // than the navy this palette used to be.

  /// `--zv-void` — pure black. The landing page's top, and nothing else.
  static const Color void_ = Color(0xFF000000);

  /// The app base — the violet-tinted dark every signed-in screen starts on.
  static const Color midnight = Color(0xFF14102A);

  /// One step up from the ground. The fill for surfaces that sit OVER the lit
  /// top of a screen and must not disappear into it: dialogs, sheets, refresh
  /// spinners.
  static const Color deep = Color(0xFF191430);

  /// The ground's hold line — where the violet stops and the fall to black
  /// begins. Kept close to [midnight] on purpose: measured against the
  /// reference, a wash that starts descending at 30% is already too dark by
  /// the upper middle of the screen. The reference holds its colour to roughly
  /// the waist and then drops.
  static const Color dusk = Color(0xFF15112A);

  /// The page foot. Sampled at #0F0E13: near-black, with barely any violet
  /// left. Not [void_] — pure black goes flat under these glass cards and
  /// their hairlines stop reading.
  static const Color pitch = Color(0xFF0F0E13);

  /// The bloom. Radial-glow only — never a fill. Sampled from the reference's
  /// primary action, which is the same violet the bloom is made of.
  static const Color glow = Color(0xFF5B3BD1);

  /// Hero base.
  static const Color horizon = Color(0xFF241A52);

  // ── Signal ────────────────────────────────────────────────────────────────
  // Each of these means one thing. The comment IS the contract.

  /// `--zv-green` — done, published.
  static const Color green = Color(0xFF00DC82);

  /// `--zv-mint` — green when it has to sit on a dark surface and stay legible.
  static const Color mint = Color(0xFF6EE7B7);

  /// `--zv-amber` — points, waiting.
  static const Color amber = Color(0xFFFFD166);

  /// The primary action. Sampled at #5E3DE6 off the reference's own filled
  /// card — sixty-three thousand pixels of it, so this is the value rather
  /// than the #5939CF read earlier off a low-resolution button.
  ///
  /// This is the one place the palette's "colour only names a status" rule is
  /// deliberately broken, and it is broken because the reference breaks it:
  /// its hero action is violet, not white. Everything else still earns its
  /// colour by meaning.
  static const Color violet = Color(0xFF5E3DE6);

  /// [violet] lifted, for the pressed state and for text that has to stay
  /// legible on a dark surface.
  static const Color violetLift = Color(0xFF7B5CE8);

  // ── Lavender ──────────────────────────────────────────────────────────────
  // The reference's second voice, and it is a GRADIENT rather than a colour:
  // pink-lavender falling to periwinkle. It is what a selected chip is filled
  // with and what a big readout numeral is painted with, and using either end
  // on its own loses the thing that makes them recognisable.
  //
  // Both ends sampled: the "All" chip runs #DCBEFE → #AFB1FC across its width,
  // and the `67` numeral runs the same ramp down its height.

  /// The warm end — pink-lavender.
  static const Color lavenderHi = Color(0xFFDCBEFE);

  /// The cool end — periwinkle.
  static const Color lavenderLo = Color(0xFFAFB1FC);

  /// `--zv-blue` — the XP path. Reserved for XP and upgrade actions
  /// (`ZaveButtonKind.brand`), which is why it did NOT become the violet
  /// above: XP has to stay distinguishable from an ordinary primary action.
  static const Color blue = Color(0xFF2F3AF7);

  /// `--zv-peri` — links and kickers (periwinkle).
  static const Color peri = Color(0xFFAEB4FF);

  /// `--zv-sched` — queued / scheduled.
  static const Color scheduled = Color(0xFF8B92F5);

  /// `--zv-ink` — text ON white. The counterpart to a solid-white surface:
  /// a white pill button carries `ink` letters, never black ones.
  static const Color ink = Color(0xFF06103A);

  // ── Ink: white at opacity ─────────────────────────────────────────────────
  // Text hierarchy is built by fading white, not by picking greys. Five steps,
  // and a sixth for hairlines.

  /// `--zv-ink-85` — primary body text where pure white would glare.
  static const Color ink85 = Color(0xD9FFFFFF);

  /// `--zv-ink-62` — secondary / lead copy. The most-used body colour.
  static const Color ink62 = Color(0x9EFFFFFF);

  /// `--zv-ink-50` — tertiary.
  static const Color ink50 = Color(0x80FFFFFF);

  /// `--zv-ink-45` — kickers, labels.
  static const Color ink45 = Color(0x73FFFFFF);

  /// `--zv-ink-35` — placeholders, the faintest legible step.
  static const Color ink35 = Color(0x59FFFFFF);

  /// `--zv-rule` — hairlines and default chip borders.
  static const Color rule = Color(0x1FFFFFFF);

  /// Pure white. Used as a *surface* (the one primary action per screen) far
  /// more often than as text — see [ink] for its text partner.
  static const Color white = Color(0xFFFFFFFF);
}

/// Glass fill steps — `--zv-rest` / `--zv-hover` / `--zv-now` and their borders.
///
/// Depth in this system comes from the FILL STEP, never from a shadow. There
/// are exactly three steps and each one is a state, not a size:
///
///   • [rest]  — the default surface for a card, row or field.
///   • [hover] — pointer-over on web; on touch this is the PRESSED state.
///   • [now]   — "this is the one happening now" (today's row, the active slot).
///
/// Do not invent a fourth step, and do not add a `BoxShadow` to lift a card.
/// If a surface needs to read as raised, move it up a step.
class ZaveGlass {
  const ZaveGlass._();

  /// `--zv-rest` — rgba(255,255,255,0.05)
  static const Color rest = Color(0x0DFFFFFF);

  /// `--zv-rest-bd` — rgba(255,255,255,0.09)
  static const Color restBorder = Color(0x17FFFFFF);

  /// `--zv-hover` — rgba(255,255,255,0.09). On touch, the pressed state.
  static const Color hover = Color(0x17FFFFFF);

  /// `--zv-hover-bd` — rgba(255,255,255,0.16)
  static const Color hoverBorder = Color(0x29FFFFFF);

  /// `--zv-now` — rgba(255,255,255,0.12). Reserved for the current item.
  static const Color now = Color(0x1FFFFFFF);

  /// `--zv-now-bd` — rgba(255,255,255,0.28)
  static const Color nowBorder = Color(0x47FFFFFF);

  // ── Component-local fills ────────────────────────────────────────────────
  // A handful of web classes use a fill that is deliberately half a step off
  // the scale above. They are named here rather than written as literals at
  // the call site, so they stay greppable and cannot quietly multiply.

  /// `.zv-input` background — rgba(255,255,255,0.06)
  static const Color inputFill = Color(0x0FFFFFFF);

  /// `.zv-input` border — rgba(255,255,255,0.10)
  static const Color inputBorder = Color(0x1AFFFFFF);

  /// `.zv-input:focus` border — rgba(255,255,255,0.30). Focus BRIGHTENS the
  /// border; it never draws a platform focus ring.
  static const Color inputBorderFocused = Color(0x4DFFFFFF);

  /// `.field` / `.chip` / `.pill` background — rgba(255,255,255,0.07)
  static const Color controlFill = Color(0x12FFFFFF);

  /// `.pill` / `.iconBtn` border — rgba(255,255,255,0.13)
  static const Color controlBorder = Color(0x21FFFFFF);

  /// `.chip:hover` / `.iconBtn:hover` background — rgba(255,255,255,0.14)
  static const Color controlFillHover = Color(0x24FFFFFF);

  /// `.row` background — rgba(255,255,255,0.06)
  static const Color rowFill = Color(0x0FFFFFFF);

  /// `.row` border — rgba(255,255,255,0.10)
  static const Color rowBorder = Color(0x1AFFFFFF);

  /// `.btnGhost` background — rgba(255,255,255,0.08)
  static const Color ghostFill = Color(0x14FFFFFF);

  /// Sticky header fill — rgba(5,10,36,0.78), i.e. [ZaveColors.midnight] at
  /// 78%. Pair with an 18px backdrop blur.
  static const Color headerFill = Color(0xC714102A);

  /// Header bottom hairline — rgba(255,255,255,0.08)
  static const Color headerBorder = Color(0x14FFFFFF);

  /// `.mono` code-block fill — rgba(0,0,0,0.35)
  static const Color codeFill = Color(0x59000000);
}

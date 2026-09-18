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
///   **Colour only ever names a status.**
///
/// Nothing is tinted for decoration. A green thing is done; an amber thing is
/// waiting; a blue thing is on the XP / upgrade path. Ordinary surfaces are
/// white at a low opacity over the midnight ground — never a custom grey, and
/// never a brand tint. If you find yourself reaching for a colour to make
/// something "pop", reach for a fill step in [ZaveGlass] instead.
class ZaveColors {
  const ZaveColors._();

  // ── Ground ────────────────────────────────────────────────────────────────
  // The surfaces the app is painted ON. `midnight` is the app base; `deep` is
  // the foot of a long page, reached by gradient, never by a hard edge.

  /// `--zv-void` — the landing page's top. Pure black.
  static const Color void_ = Color(0xFF000000);

  /// `--zv-midnight` — the app base. Every signed-in screen starts here.
  static const Color midnight = Color(0xFF050A24);

  /// `--zv-deep` — the page foot, as the bottom stop of the ground gradient.
  static const Color deep = Color(0xFF071445);

  /// `--zv-glow` — radial-glow only. Never use this as a fill: it exists to be
  /// blurred into the top-left of the ground and nothing else.
  static const Color glow = Color(0xFF0D2A9E);

  /// `--zv-horizon` — hero base.
  static const Color horizon = Color(0xFF0A1F8A);

  // ── Signal ────────────────────────────────────────────────────────────────
  // Each of these means one thing. The comment IS the contract.

  /// `--zv-green` — done, published.
  static const Color green = Color(0xFF00DC82);

  /// `--zv-mint` — green when it has to sit on a dark surface and stay legible.
  static const Color mint = Color(0xFF6EE7B7);

  /// `--zv-amber` — points, waiting.
  static const Color amber = Color(0xFFFFD166);

  /// `--zv-blue` — brand / the XP path. This is the ONLY brand-coloured fill,
  /// and it is reserved for XP and upgrade actions (see `ZaveButtonStyle.brand`).
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
  static const Color headerFill = Color(0xC7050A24);

  /// Header bottom hairline — rgba(255,255,255,0.08)
  static const Color headerBorder = Color(0x14FFFFFF);

  /// `.mono` code-block fill — rgba(0,0,0,0.35)
  static const Color codeFill = Color(0x59000000);
}

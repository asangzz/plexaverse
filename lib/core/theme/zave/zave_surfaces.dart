import 'package:flutter/widgets.dart';

import 'zave_colors.dart';
import 'zave_geometry.dart';

/// Ready-made Zave surface decorations.
///
/// Every surface in this system is the same recipe — a white fill at a low
/// opacity, a slightly brighter white hairline, and a radius chosen by what the
/// element is — so it is written once here rather than re-derived per screen.
///
/// **Depth is still the fill step** ([ZaveGlass.rest] → [ZaveGlass.hover] →
/// [ZaveGlass.now]). Do not add a `BoxShadow` to lift a card; if a surface
/// needs to read as raised, move it up a step.
///
/// The one shadow in the system is [ZaveShadow.bloom], and it is not a lift —
/// it is light. The primary action is a saturated violet on a near-black
/// ground, and in the Aura reference that violet spills onto the ground around
/// it. Nothing else casts anything.
class ZaveSurface {
  const ZaveSurface._();

  static BoxDecoration _glass(Color fill, Color border, double radius) =>
      BoxDecoration(
        color: fill,
        border: Border.all(color: border, width: 1),
        borderRadius: BorderRadius.circular(radius),
      );

  /// `.card` — the default card. rest fill, rest border, r24.
  static BoxDecoration get card =>
      _glass(ZaveGlass.rest, ZaveGlass.restBorder, ZaveRadius.card);

  /// `.cardLg` — r28.
  static BoxDecoration get cardLg =>
      _glass(ZaveGlass.rest, ZaveGlass.restBorder, ZaveRadius.cardLg);

  /// `.zv-row` — the compact in-app row. r20.
  static BoxDecoration get cardCompact =>
      _glass(ZaveGlass.rest, ZaveGlass.restBorder, ZaveRadius.cardCompact);

  /// `.zv-panel` / `.listRow` at rest — r22. The canonical in-app panel.
  static BoxDecoration get listRow =>
      _glass(ZaveGlass.rest, ZaveGlass.restBorder, ZaveRadius.cardMd);

  /// `.listRow:hover` — on a touch device this is the PRESSED state.
  static BoxDecoration get listRowPressed =>
      _glass(ZaveGlass.hover, ZaveGlass.hoverBorder, ZaveRadius.cardMd);

  /// `.row` — r18, a half-step fill of its own.
  static BoxDecoration get row =>
      _glass(ZaveGlass.rowFill, ZaveGlass.rowBorder, ZaveRadius.cardSm);

  /// `.rowNow` — "this is the one happening now". The only correct use of the
  /// [ZaveGlass.now] step: today's row, the active slot, the live item.
  static BoxDecoration get rowNow =>
      _glass(ZaveGlass.now, ZaveGlass.nowBorder, ZaveRadius.cardSm);

  /// `.zv-input` at rest.
  static BoxDecoration get input =>
      _glass(ZaveGlass.inputFill, ZaveGlass.inputBorder, ZaveRadius.input);

  /// `.zv-input:focus` — focus BRIGHTENS the border. Never draw a platform
  /// focus ring on top of this.
  static BoxDecoration get inputFocused => _glass(
    ZaveGlass.inputFill,
    ZaveGlass.inputBorderFocused,
    ZaveRadius.input,
  );

  /// `.field` — the larger field variant, r18.
  static BoxDecoration get field =>
      _glass(ZaveGlass.controlFill, ZaveColors.rule, ZaveRadius.cardSm);

  /// `.chip` unselected.
  static BoxDecoration get chip => _glass(
    ZaveGlass.controlFill,
    ZaveColors.rule,
    ZaveRadius.pill,
  );

  /// `.chipOn` — selected INVERTS to solid white with ink text. A selected chip
  /// is never merely tinted, and never underlined.
  static BoxDecoration get chipSelected =>
      _glass(ZaveColors.white, ZaveColors.white, ZaveRadius.pill);

  /// `.pill` — a static (non-selectable) pill.
  static BoxDecoration get pill => _glass(
    ZaveGlass.controlFill,
    ZaveGlass.controlBorder,
    ZaveRadius.pill,
  );

  /// `.iconBtn` — a 38px circle.
  static BoxDecoration get iconButton => BoxDecoration(
    color: ZaveGlass.controlFill,
    border: Border.all(color: ZaveGlass.controlBorder, width: 1),
    shape: BoxShape.circle,
  );

  /// `.navItem` at rest.
  static BoxDecoration get navItem => BoxDecoration(
    borderRadius: BorderRadius.circular(ZaveRadius.navItem),
  );

  /// `.navItemOn` — the active nav item inverts to solid white, exactly like a
  /// selected chip.
  static BoxDecoration get navItemSelected => BoxDecoration(
    color: ZaveColors.white,
    borderRadius: BorderRadius.circular(ZaveRadius.navItem),
  );

  /// `.mono` — the code / readout block.
  static BoxDecoration get codeBlock =>
      _glass(ZaveGlass.codeFill, ZaveGlass.restBorder, ZaveRadius.input);

  /// The sticky header: midnight at 78% over an 18px backdrop blur, with a
  /// single bottom hairline. Pair with a [BackdropFilter] — the colour alone is
  /// not the effect.
  static BoxDecoration get header => BoxDecoration(
    color: ZaveGlass.headerFill,
    border: Border(
      bottom: BorderSide(color: ZaveGlass.headerBorder, width: 1),
    ),
  );

  /// The blur sigma behind [header] — CSS `backdrop-filter: blur(18px)`.
  ///
  /// CSS blur radius and Gaussian sigma are not the same quantity: a CSS blur
  /// of N maps to sigma N/2. 18px therefore becomes sigma 9, which is why this
  /// is a named constant and not an inline `18`.
  static const double headerBlurSigma = 9;
}

/// The app ground — the gradient every signed-in screen is painted on.
///
/// Two layers: a vertical wash, and one violet bloom over it.
///
/// The bloom is **top-left and appears exactly once**. Do not repeat it
/// further down a scroll view: the whole point of a single light source is
/// that the page has a top.
///
/// This no longer matches the web's `.root`, which is still on the navy wash.
/// The two were ported 1:1 and have now deliberately diverged — the app was
/// retuned against the Aura reference and the web has not been.
class ZaveGround {
  const ZaveGround._();

  /// The base vertical wash: violet-tinted dark at the top, near-black at the
  /// foot, holding the lit colour through the top third.
  ///
  /// It once ran midnight → deep across the whole height, and `deep` was the
  /// BRIGHTER of the two — so the page grew more saturated the further down it
  /// went, which on a phone is most of what you see. The shape here is the
  /// opposite and it is the shape the Aura reference has: a lit top, then a
  /// fall away to almost nothing.
  static const LinearGradient base = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[ZaveColors.midnight, ZaveColors.dusk, ZaveColors.pitch],
    stops: <double>[0.0, 0.45, 1.0],
  );

  /// The bloom, over [base].
  ///
  /// Same geometry as before — a wide ellipse centred above the top-left of
  /// the viewport, so what a screen actually shows is its tail rather than its
  /// core. Only the hue changed, from the old navy to [ZaveColors.glow]. The
  /// geometry was tuned against a real screen and is worth keeping; the colour
  /// is what makes it read as violet.
  static const RadialGradient bloom = RadialGradient(
    center: Alignment(-0.64, -1.12),
    radius: 1.1,
    colors: <Color>[
      Color(0x8C5B3BD1),
      Color(0x005B3BD1),
    ],
    stops: <double>[0.0, 0.62],
  );

  /// Deprecated alias for [bloom], kept so existing call sites keep compiling.
  /// New code should say [bloom].
  static const RadialGradient glow = bloom;
}

/// The only shadow in the system.
///
/// Not a lift — light. [ZaveColors.violet] is a saturated fill on a near-black
/// ground, and in the Aura reference it spills onto the ground around it. That
/// spill is what stops the primary action reading as a sticker laid on the
/// page.
///
/// Nothing else in the app casts anything. A card that needs to look raised
/// moves up a [ZaveGlass] step instead — see the rule on [ZaveSurface].
class ZaveShadow {
  const ZaveShadow._();

  /// Under a violet primary action. No offset: light spills in every
  /// direction, and an offset would read as a drop shadow, which is the thing
  /// this system does not have.
  static List<BoxShadow> get bloom => const <BoxShadow>[
    BoxShadow(
      color: Color(0x665939CF),
      blurRadius: 24,
      spreadRadius: -4,
    ),
  ];
}

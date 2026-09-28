import 'package:flutter/widgets.dart';

import 'zave_colors.dart';
import 'zave_edge.dart';
import 'zave_geometry.dart';

/// Ready-made Zave surface decorations.
///
/// Every surface is the same recipe — a translucent white pane that falls off
/// across its own face, a hairline that is bright where the light hits it, and
/// a radius chosen by what the element is — written once here rather than
/// re-derived per screen.
///
/// **Depth is still the fill step** ([ZaveFill.rest] → [ZaveFill.hover] →
/// [ZaveFill.now]). Do not add a `BoxShadow` to lift a card; if a surface
/// needs to read as raised, move it up a step.
///
/// ## What changed, and what did not
///
/// The ladder did not change. Each rung did: a rung used to be one flat
/// alpha, and is now a short gradient with the same average, plus a
/// [ZaveEdgeBorder] instead of a uniform hairline. Nothing got brighter
/// overall — the light was redistributed toward the top-left, where
/// [ZaveGround.bloom] already is.
///
/// That is the whole of "glass": a flat 5% wash inside a flat 9% outline is a
/// rectangle of lighter paint, and the same quantity of light with a falloff
/// on it is a pane. It costs one gradient and one shader stroke per surface,
/// and no blur — real [BackdropFilter] is reserved for the few surfaces that
/// actually sit over moving content (see [header]), because a blur per row in
/// a scrolling list is how a list stops being 60fps.
///
/// The one shadow in the system is [ZaveShadow.bloom], and it is not a lift —
/// it is light. The primary action is a saturated violet on a near-black
/// ground, and in the Aura reference that violet spills onto the ground around
/// it. Nothing else casts anything.
class ZaveSurface {
  const ZaveSurface._();

  static BoxDecoration _glass(
    Gradient fill,
    Gradient edge,
    double radius, {
    Gradient? bevel,
  }) => BoxDecoration(
    gradient: fill,
    border: ZaveEdgeBorder(gradient: edge, highlight: bevel),
    borderRadius: BorderRadius.circular(radius),
  );

  /// `.card` — the default card. rest fill, rest border, r24.
  static BoxDecoration get card => _glass(
    ZaveFill.rest,
    ZaveEdge.rest,
    ZaveRadius.card,
    bevel: ZaveEdge.bevel,
  );

  /// `.cardLg` — r28.
  static BoxDecoration get cardLg => _glass(
    ZaveFill.rest,
    ZaveEdge.rest,
    ZaveRadius.cardLg,
    bevel: ZaveEdge.bevel,
  );

  /// `.zv-row` — the compact in-app row. r20.
  static BoxDecoration get cardCompact => _glass(
    ZaveFill.rest,
    ZaveEdge.rest,
    ZaveRadius.cardCompact,
    bevel: ZaveEdge.bevel,
  );

  /// `.zv-panel` / `.listRow` at rest — r22. The canonical in-app panel.
  static BoxDecoration get listRow => _glass(
    ZaveFill.rest,
    ZaveEdge.rest,
    ZaveRadius.cardMd,
    bevel: ZaveEdge.bevel,
  );

  /// `.listRow:hover` — on a touch device this is the PRESSED state.
  static BoxDecoration get listRowPressed => _glass(
    ZaveFill.hover,
    ZaveEdge.hover,
    ZaveRadius.cardMd,
    bevel: ZaveEdge.bevel,
  );

  /// `.row` — r18, a half-step fill of its own.
  static BoxDecoration get row =>
      _glass(ZaveFill.row, ZaveEdge.control, ZaveRadius.cardSm);

  /// `.rowNow` — "this is the one happening now". The only correct use of the
  /// [ZaveGlass.now] step: today's row, the active slot, the live item.
  static BoxDecoration get rowNow => _glass(
    ZaveFill.now,
    ZaveEdge.now,
    ZaveRadius.cardSm,
    bevel: ZaveEdge.bevelNow,
  );

  /// `.zv-input` at rest.
  static BoxDecoration get input =>
      _glass(ZaveFill.input, ZaveEdge.control, ZaveRadius.input);

  /// `.zv-input:focus` — focus BRIGHTENS the border. Never draw a platform
  /// focus ring on top of this.
  static BoxDecoration get inputFocused =>
      _glass(ZaveFill.input, ZaveEdge.focused, ZaveRadius.input);

  /// `.field` — the larger field variant, r18.
  static BoxDecoration get field =>
      _glass(ZaveFill.control, ZaveEdge.control, ZaveRadius.cardSm);

  /// `.chip` unselected.
  static BoxDecoration get chip =>
      _glass(ZaveFill.control, ZaveEdge.control, ZaveRadius.pill);

  /// `.chipOn` — selected fills with the lavender ramp and takes ink letters.
  ///
  /// It was solid white. The reference's selected chip is a gradient, and the
  /// difference is not decoration: a flat white pill and the white primary
  /// button were the same object, so "selected" and "the action" looked
  /// identical. Now the action is violet and selection is lavender, and
  /// neither can be mistaken for the other.
  ///
  /// Still an inversion, still never a tint or an underline.
  static BoxDecoration get chipSelected => BoxDecoration(
    gradient: ZaveAccent.lavender,
    borderRadius: BorderRadius.circular(ZaveRadius.pill),
  );

  /// `.pill` — a static (non-selectable) pill.
  static BoxDecoration get pill =>
      _glass(ZaveFill.control, ZaveEdge.control, ZaveRadius.pill);

  /// `.iconBtn` — a 38px circle.
  static BoxDecoration get iconButton => BoxDecoration(
    gradient: ZaveFill.control,
    border: ZaveEdgeBorder(gradient: ZaveEdge.control),
    shape: BoxShape.circle,
  );

  /// `.navItem` at rest.
  static BoxDecoration get navItem =>
      BoxDecoration(borderRadius: BorderRadius.circular(ZaveRadius.navItem));

  /// `.navItemOn` — the active nav item inverts to solid white, exactly like a
  /// selected chip.
  static BoxDecoration get navItemSelected => BoxDecoration(
    color: ZaveColors.white,
    borderRadius: BorderRadius.circular(ZaveRadius.navItem),
  );

  /// `.mono` — the code / readout block.
  static BoxDecoration get codeBlock =>
      _glass(ZaveFill.code, ZaveEdge.rest, ZaveRadius.input);

  /// The sticky header: midnight at 78% over an 18px backdrop blur, with a
  /// single bottom hairline. Pair with a [BackdropFilter] — the colour alone is
  /// not the effect.
  static BoxDecoration get header => BoxDecoration(
    color: ZaveGlass.headerFill,
    border: Border(bottom: BorderSide(color: ZaveGlass.headerBorder, width: 1)),
  );

  /// The blur sigma behind [header] — CSS `backdrop-filter: blur(18px)`.
  ///
  /// CSS blur radius and Gaussian sigma are not the same quantity: a CSS blur
  /// of N maps to sigma N/2. 18px therefore becomes sigma 9, which is why this
  /// is a named constant and not an inline `18`.
  static const double headerBlurSigma = 9;
}

/// The pane fills — each depth step as a lit surface rather than a flat wash.
///
/// Every one runs top-left to bottom-right, aimed at [ZaveGround.bloom], and
/// every one averages the flat alpha it replaces. `rest` was a uniform 5%; it
/// is now 8% falling to 3%. The card is not brighter, it is *lit* — which is
/// the difference between a rectangle of lighter paint and a pane of glass.
///
/// Keeping the averages is what lets this change ship everywhere at once
/// without re-balancing a single screen: contrast against text, against the
/// ground, and between adjacent steps all land where they already were.
class ZaveFill {
  const ZaveFill._();

  static LinearGradient _pane(int hi, int lo) => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[Color(hi), Color(lo)],
  );

  /// Replaces [ZaveGlass.rest] (5%). 8% → 3%.
  static final LinearGradient rest = _pane(0x14FFFFFF, 0x08FFFFFF);

  /// Replaces [ZaveGlass.hover] (9%). 13% → 5%.
  static final LinearGradient hover = _pane(0x21FFFFFF, 0x0DFFFFFF);

  /// Replaces [ZaveGlass.now] (12%). 17% → 7%.
  static final LinearGradient now = _pane(0x2BFFFFFF, 0x12FFFFFF);

  /// Replaces [ZaveGlass.controlFill] (7%). 10% → 4%.
  static final LinearGradient control = _pane(0x1AFFFFFF, 0x0AFFFFFF);

  /// Replaces [ZaveGlass.inputFill] (6%). 9% → 3%.
  static final LinearGradient input = _pane(0x17FFFFFF, 0x08FFFFFF);

  /// Replaces [ZaveGlass.rowFill] (6%). Same range as [input]; a row and a
  /// field sit at the same depth and always did.
  static final LinearGradient row = _pane(0x17FFFFFF, 0x08FFFFFF);

  /// Replaces [ZaveGlass.codeFill] — a readout is a WELL, not a pane, so this
  /// one runs the other way: darkest where the light would be. It is the only
  /// inverted surface in the system, and that is what makes a code block read
  /// as cut into the card rather than laid on it.
  static final LinearGradient code = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: const <Color>[Color(0x66000000), Color(0x40000000)],
  );
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
      // Raised from 0x8C. The bloom used to fall on flat surfaces that could
      // not show it; now that every pane has an edge aimed at it, there is
      // something for the extra light to land on.
      Color(0xA35B3BD1),
      Color(0x005B3BD1),
    ],
    stops: <double>[0.0, 0.66],
  );

  /// The counter-light, bottom-right, under everything else.
  ///
  /// ## This is not a second bloom
  ///
  /// The rule above still holds: the KEY light appears once, at the top-left,
  /// and must not be repeated down a scroll view. This is a fill light, which
  /// is a different instrument. A key light alone gives you a lit top and a
  /// dead bottom — on a phone, where most of the viewport is below the key's
  /// falloff, that dead bottom is most of what the user looks at, and it is
  /// why the lower half of every screen read as flat black.
  ///
  /// So it is dim (a sixth of the key), cool where the key is warm-violet, and
  /// anchored at the opposite corner. Those three together are what keep it
  /// reading as the same room lit from one side rather than as two lamps: a
  /// fill light that competes with the key does not add depth, it removes it.
  ///
  /// Like the key, it is fixed to the viewport and does not scroll.
  static const RadialGradient counter = RadialGradient(
    center: Alignment(0.92, 1.05),
    radius: 1.0,
    colors: <Color>[Color(0x24AFB1FC), Color(0x00AFB1FC)],
    stops: <double>[0.0, 0.68],
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
    BoxShadow(color: Color(0x665939CF), blurRadius: 24, spreadRadius: -4),
  ];
}

/// The lavender ramp — the reference's second voice.
///
/// One gradient, two uses: the fill of a selected chip, and the paint of a big
/// readout numeral (through a `ShaderMask`). Both sampled from the reference,
/// which runs the same ramp across a chip's width and down a numeral's height.
class ZaveAccent {
  const ZaveAccent._();

  /// Pink-lavender to periwinkle. Diagonal, so it reads on a wide pill and on
  /// a tall glyph without needing two definitions.
  static const LinearGradient lavender = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[ZaveColors.lavenderHi, ZaveColors.lavenderLo],
  );

  /// The violet fill of a "this is the one" card, with a little depth across
  /// it. Flat #5E3DE6 is correct for a pill; across a card the size of the
  /// reference's Next Training tile it goes plastic.
  static const LinearGradient violetCard = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[Color(0xFF6A4BEE), Color(0xFF5433D8)],
  );
}

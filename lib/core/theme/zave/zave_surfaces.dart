import 'package:flutter/widgets.dart';

import 'zave_colors.dart';
import 'zave_geometry.dart';

/// Ready-made Zave surface decorations.
///
/// Every surface in this system is the same recipe — a white fill at a low
/// opacity, a slightly brighter white hairline, and a radius chosen by what the
/// element is — so it is written once here rather than re-derived per screen.
///
/// **There are no shadows.** Depth is the fill step ([ZaveGlass.rest] →
/// [ZaveGlass.hover] → [ZaveGlass.now]) and nothing else. The one place a
/// shadow appears in the whole system is the white primary button's hover lift
/// on the web, which has no touch equivalent and is intentionally not ported.
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

  /// `.zv-card` — the compact in-app card. r20.
  static BoxDecoration get cardCompact =>
      _glass(ZaveGlass.rest, ZaveGlass.restBorder, ZaveRadius.cardCompact);

  /// `.listRow` at rest — r22.
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
/// Ported from `.root` in the web's `zave.module.css`:
///
/// ```css
/// background:
///   radial-gradient(1100px 700px at 18% -6%, rgba(13,42,158,0.55) 0%, transparent 62%),
///   linear-gradient(180deg, var(--zv-midnight) 0%, var(--zv-deep) 100%);
/// ```
///
/// The glow is **top-left and appears exactly once**. Do not repeat it further
/// down a scroll view: the whole point of a single light source is that the
/// page has a top.
class ZaveGround {
  const ZaveGround._();

  /// The base vertical wash: midnight at the top, deep at the foot.
  static const LinearGradient base = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[ZaveColors.midnight, ZaveColors.deep],
  );

  /// The single top-left glow, laid over [base].
  ///
  /// The web's ellipse is 1100x700 centred at (18%, -6%) — wider than it is
  /// tall and mostly above the viewport. [RadialGradient] is circular, so the
  /// shape is reproduced by [radius] plus a horizontal [transform] rather than
  /// by the radius alone.
  static const RadialGradient glow = RadialGradient(
    center: Alignment(-0.64, -1.12), // 18% across, -6% down, in (-1..1) space
    radius: 1.1,
    colors: <Color>[
      Color(0x8C0D2A9E), // --zv-glow at 55%
      Color(0x000D2A9E), // transparent at the 62% stop
    ],
    stops: <double>[0.0, 0.62],
  );
}

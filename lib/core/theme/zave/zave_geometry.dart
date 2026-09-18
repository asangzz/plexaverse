import 'package:flutter/widgets.dart';

import '../../responsive/screen_util.dart';

/// Zave corner radii — ported from the web's Zave classes.
///
/// The governing rule, stated in the web source as "radius scales with the
/// element": a bigger surface gets a bigger corner. There is no single global
/// radius. Pick by what the thing IS, not by how it looks today.
///
/// Pressables are the exception and they are absolute: **every button, chip,
/// pill and tab is a full pill.** Never a rounded rectangle.
class ZaveRadius {
  const ZaveRadius._();

  /// `.cardLg` — 28. Marketing / hero cards.
  static double get cardLg => 28.r;

  /// `.card` — 24. The default card.
  static double get card => 24.r;

  /// `.zv-panel` (globals) / `.listRow` / `.cardMd` — 22. The canonical in-app
  /// panel, and the list/day row.
  static double get cardMd => 22.r;

  /// `.zv-row` (globals) — 20. The compact in-app row.
  static double get cardCompact => 20.r;

  /// `.cardSm` / `.field` / `.row` — 18. Tasks, cells, fields, rows.
  static double get cardSm => 18.r;

  /// `.zv-input` (globals) — 16. Also `.navItem` and the `.mono` block.
  static double get input => 16.r;

  /// `.navItem` — 16.
  static double get navItem => 16.r;

  /// Full pill. Buttons, chips, tabs, switches — no exceptions.
  static const double pill = 9999;

  static BorderRadius get cardLgBr => BorderRadius.circular(cardLg);
  static BorderRadius get cardBr => BorderRadius.circular(card);
  static BorderRadius get cardMdBr => BorderRadius.circular(cardMd);
  static BorderRadius get cardCompactBr => BorderRadius.circular(cardCompact);
  static BorderRadius get cardSmBr => BorderRadius.circular(cardSm);
  static BorderRadius get inputBr => BorderRadius.circular(input);
  static BorderRadius get pillBr => BorderRadius.circular(pill);
}

/// Zave spacing — the padding figures the web's Zave classes actually use.
///
/// These are NOT a generic 4/8/12/16 ramp. They are the real numbers from the
/// component rules, kept as named constants so a screen reads like the CSS it
/// is porting rather than like a pile of magic numbers.
class ZaveSpace {
  const ZaveSpace._();

  // Generic ramp, for gaps the component rules do not pin down.
  static double get xs => 4.w;
  static double get sm => 8.w;
  static double get md => 12.w;
  static double get lg => 16.w;
  static double get xl => 24.w;
  static double get xxl => 32.w;

  /// `.wrap` at the mobile breakpoint — 20px side gutter.
  ///
  /// The desktop value is 40px; a phone renders the `@media (max-width: 899px)`
  /// branch, so 20 is what a phone user sees.
  static double get gutter => 20.w;

  /// `.section` — 72px of vertical breathing room between major blocks.
  static double get section => 72.h;

  /// `.zv-row` padding — 20 vertical / 24 horizontal, 18 gap. The default
  /// padding for an in-app panel too; `.zv-panel` sets no padding of its own.
  static EdgeInsets get cardPad =>
      EdgeInsets.symmetric(vertical: 20.h, horizontal: 24.w);
  static double get cardGap => 18.w;

  /// `.row` padding — 18 / 20.
  static EdgeInsets get rowPad =>
      EdgeInsets.symmetric(vertical: 18.h, horizontal: 20.w);

  /// `.listRow` padding — 22 / 24, 20 gap.
  static EdgeInsets get listRowPad =>
      EdgeInsets.symmetric(vertical: 22.h, horizontal: 24.w);
  static double get listRowGap => 20.w;

  /// `.navItem` padding — 14 / 18, 14 gap.
  static EdgeInsets get navItemPad =>
      EdgeInsets.symmetric(vertical: 14.h, horizontal: 18.w);
  static double get navItemGap => 14.w;

  /// `.field` padding — 18 / 22.
  static EdgeInsets get fieldPad =>
      EdgeInsets.symmetric(vertical: 18.h, horizontal: 22.w);

  /// `.zv-input` padding — 16 / 20.
  static EdgeInsets get inputPad =>
      EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w);

  /// `.btnPrimary` padding — 21 / 40.
  static EdgeInsets get btnPrimaryPad =>
      EdgeInsets.symmetric(vertical: 21.h, horizontal: 40.w);

  /// `.btnPrimarySm` padding — 15 / 26.
  static EdgeInsets get btnPrimarySmPad =>
      EdgeInsets.symmetric(vertical: 15.h, horizontal: 26.w);

  /// `.btnGhost` padding — 13 / 26.
  static EdgeInsets get btnGhostPad =>
      EdgeInsets.symmetric(vertical: 13.h, horizontal: 26.w);

  /// `.btnBrand` padding — 15 / 28.
  static EdgeInsets get btnBrandPad =>
      EdgeInsets.symmetric(vertical: 15.h, horizontal: 28.w);

  /// `.chip` padding — 11 / 20.
  static EdgeInsets get chipPad =>
      EdgeInsets.symmetric(vertical: 11.h, horizontal: 20.w);

  /// `.pill` padding — 10 / 18.
  static EdgeInsets get pillPad =>
      EdgeInsets.symmetric(vertical: 10.h, horizontal: 18.w);

  /// `.iconBtn` — a 38px circle.
  static double get iconBtn => 38.r;

  /// `.dot` — the 9px status dot.
  static double get dot => 9.r;

  /// `.zv-switch` — 52 x 30 with a 22px knob inset 3px.
  static double get switchWidth => 52.w;
  static double get switchHeight => 30.h;
  static double get switchKnob => 22.r;
  static double get switchInset => 3.r;

  /// Minimum tap target. Material's floor — several Zave controls are smaller
  /// than this on the web (the 38px icon button, the 30px switch), so wrap
  /// them in a target of at least this size rather than shrinking the visual.
  static const double minTapTarget = 48;
}

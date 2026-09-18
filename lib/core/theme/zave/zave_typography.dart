import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../responsive/screen_util.dart';
import 'zave_colors.dart';

/// Zave typography — ported from the web app's Zave type scale
/// (`app/zave-style-guide/zave.module.css` and the `.zv-h` rule in
/// `app/globals.css`).
///
/// ## Two faces, and the rule that separates them
///
///   • **Manrope 800, tight** NAMES things — headings, nav labels, button
///     labels, kickers, numbers. Always heavy (w700/w800), always negatively
///     tracked, always short.
///   • **Urbanist** READS — body copy, leads, field text, list content.
///
/// Sora is deliberately absent. The pre-alignment Flutter app paired Sora with
/// Urbanist, but Sora appears nowhere in the web app; it was an artifact of the
/// reference skin this app was cloned from. Do not reintroduce it.
///
/// ## Sizes are the web's MOBILE sizes, not its desktop sizes
///
/// The web is responsive, and its `@media (max-width: 899px)` block shrinks the
/// two largest roles (hero 88→52, h2 44→34). A phone renders that branch, so
/// those are the sizes a phone user actually sees — and therefore the sizes
/// this app must match. Every other role has one size at every width on the
/// web, so it carries over unchanged.
///
/// ## Tracking
///
/// CSS tracks in `em` (a multiple of the font size); Flutter tracks in logical
/// pixels. [_track] does the conversion, so the `em` figure in each doc comment
/// can be compared against the CSS directly.
class ZaveType {
  const ZaveType._();

  /// CSS `letter-spacing` in `em` → Flutter `letterSpacing` in logical pixels.
  static double _track(double em, double fontSizePx) => em * fontSizePx;

  // ── Manrope — the naming face ─────────────────────────────────────────────

  /// `.hero` at the mobile breakpoint — 52px / 800 / -0.04em / lh 1.0.
  /// One per screen at most. The desktop web value is 88px.
  static TextStyle get hero => GoogleFonts.manrope(
    fontSize: 52.sp,
    fontWeight: FontWeight.w800,
    letterSpacing: _track(-0.04, 52.sp),
    height: 1.0,
    color: ZaveColors.white,
  );

  /// `.h2` at the mobile breakpoint — 34px / 800 / -0.035em / lh 1.05.
  /// The screen title. The desktop web value is 44px.
  static TextStyle get h2 => GoogleFonts.manrope(
    fontSize: 34.sp,
    fontWeight: FontWeight.w800,
    letterSpacing: _track(-0.035, 34.sp),
    height: 1.05,
    color: ZaveColors.white,
  );

  /// `.h3` — 20px / 800 / -0.02em. Card and section headings.
  static TextStyle get h3 => GoogleFonts.manrope(
    fontSize: 20.sp,
    fontWeight: FontWeight.w800,
    letterSpacing: _track(-0.02, 20.sp),
    height: 1.2,
    color: ZaveColors.white,
  );

  /// `.kicker` — 13px / 700 / +0.16em / UPPERCASE / ink-45.
  ///
  /// Transform the string yourself (`'Overview'.toUpperCase()`); Flutter has no
  /// `text-transform`, and silently upper-casing inside a style would break
  /// anything that reads the text back (tests, semantics, copy-to-clipboard).
  static TextStyle get kicker => GoogleFonts.manrope(
    fontSize: 13.sp,
    fontWeight: FontWeight.w700,
    letterSpacing: _track(0.16, 13.sp),
    color: ZaveColors.ink45,
  );

  /// `.num` — the kicker's metrics in periwinkle. Section numbers, counters.
  static TextStyle get num => GoogleFonts.manrope(
    fontSize: 13.sp,
    fontWeight: FontWeight.w700,
    letterSpacing: _track(0.16, 13.sp),
    color: ZaveColors.peri,
  );

  /// `.navItem` — 16px / 600. Navigation labels.
  static TextStyle get navLabel => GoogleFonts.manrope(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    color: ZaveColors.ink62,
  );

  /// `.btnPrimary` label — 19px / 700.
  static TextStyle get buttonLarge => GoogleFonts.manrope(
    fontSize: 19.sp,
    fontWeight: FontWeight.w700,
    color: ZaveColors.ink,
  );

  /// `.btnPrimarySm` / `.btnGhost` label — 16px / 700.
  static TextStyle get button => GoogleFonts.manrope(
    fontSize: 16.sp,
    fontWeight: FontWeight.w700,
  );

  /// `.btnBrand` label — 15px / 700. The XP / upgrade path only.
  static TextStyle get buttonBrand => GoogleFonts.manrope(
    fontSize: 15.sp,
    fontWeight: FontWeight.w700,
    color: ZaveColors.white,
  );

  // ── Urbanist — the reading face ───────────────────────────────────────────

  /// `.lead` — 18px / lh 1.6 / ink-62. The paragraph under a heading.
  static TextStyle get lead => GoogleFonts.urbanist(
    fontSize: 18.sp,
    fontWeight: FontWeight.w400,
    height: 1.6,
    color: ZaveColors.ink62,
  );

  /// Body — 17px, matching `.field` and `.zv-input` so typed text and static
  /// text share a size.
  static TextStyle get body => GoogleFonts.urbanist(
    fontSize: 17.sp,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: ZaveColors.ink85,
  );

  /// Body, de-emphasised — the same metrics at ink-62.
  static TextStyle get bodyMuted => body.copyWith(color: ZaveColors.ink62);

  /// `.chip` / `.pill` label — 15px / 600.
  static TextStyle get label => GoogleFonts.urbanist(
    fontSize: 15.sp,
    fontWeight: FontWeight.w600,
    color: ZaveColors.ink85,
  );

  /// Small supporting text — 13px / ink-50. Metadata, timestamps, helper text.
  static TextStyle get caption => GoogleFonts.urbanist(
    fontSize: 13.sp,
    fontWeight: FontWeight.w500,
    color: ZaveColors.ink50,
  );

  /// `.mono` — 13px / lh 1.7 / ink-62, on the [ZaveGlass.codeFill] block.
  /// Also the face for the Season 2 dashboard's monospaced readouts.
  static TextStyle get mono => GoogleFonts.jetBrainsMono(
    fontSize: 13.sp,
    height: 1.7,
    color: ZaveColors.ink62,
  );

  /// Space Grotesk — used by the Season 2 dashboard and the Season 1 roadmap
  /// for their instrument-panel numerals. Not part of the core Zave scale;
  /// scoped to those two surfaces so it does not leak into ordinary screens.
  static TextStyle spaceGrotesk({
    required double size,
    FontWeight weight = FontWeight.w700,
    Color color = ZaveColors.white,
    double? tracking,
  }) => GoogleFonts.spaceGrotesk(
    fontSize: size.sp,
    fontWeight: weight,
    color: color,
    letterSpacing: tracking,
  );
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../responsive/screen_util.dart';

/// Typography tokens for the Plexaverse brand.
///
/// The brand pairs two Google Fonts families (RULINGS.md — product identity
/// kept), mapped onto the Material 3 type roles:
///   - **Sora** (bold, expressive) — `display*` / `headline*`: the wordmark,
///     screen titles, and section headings.
///   - **Urbanist** (clean, readable) — `title* / body* / label*`: body
///     copy, list content, field labels, button labels, nav labels.
///
/// Sizes/weights/line-heights are ported verbatim from the legacy
/// `lib/theme/app_text_styles.dart` (`AppTextStyles`), but every `fontSize`
/// is scaled with `.sp` against the 360-wide design frame so type stays
/// proportional across devices. The OS Dynamic Type setting is applied on
/// top by the framework (see [ScreenUtil]).
///
/// [base] is a getter (not a `const`) — following the ProHealth reference —
/// so it re-evaluates each time the theme is rebuilt, which the app root
/// does on every metrics change, picking up the live `.sp` scale factor.
///
/// Colours are left off the roles here; `AppTheme` composes the scheme
/// `onSurface` colour globally so the same type scale serves every one of
/// the five theme modes (light / dark / high-contrast). This differs from
/// the ProHealth reference (light-only brief, baked heading colours) because
/// Plexaverse is a multi-mode, dark-default brand.
class AppTextTheme {
  const AppTextTheme._();

  static TextTheme get base => TextTheme(
    // ---- Sora — display & headline (bold, expressive) ----
    displayLarge: GoogleFonts.sora(
      fontSize: 57.sp,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.25,
      height: 1.12,
    ),
    displayMedium: GoogleFonts.sora(
      fontSize: 45.sp,
      fontWeight: FontWeight.w700,
      letterSpacing: 0,
      height: 1.16,
    ),
    headlineLarge: GoogleFonts.sora(
      fontSize: 32.sp,
      fontWeight: FontWeight.w700,
      letterSpacing: 0,
      height: 1.25,
    ),
    headlineMedium: GoogleFonts.sora(
      fontSize: 28.sp,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
      height: 1.29,
    ),
    headlineSmall: GoogleFonts.sora(
      fontSize: 24.sp,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
      height: 1.33,
    ),
    // ---- Urbanist — titles ----
    titleLarge: GoogleFonts.urbanist(
      fontSize: 22.sp,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
      height: 1.27,
    ),
    titleMedium: GoogleFonts.urbanist(
      fontSize: 16.sp,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.15,
      height: 1.5,
    ),
    titleSmall: GoogleFonts.urbanist(
      fontSize: 14.sp,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
      height: 1.43,
    ),
    // ---- Urbanist — body ----
    bodyLarge: GoogleFonts.urbanist(
      fontSize: 16.sp,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.5,
      height: 1.5,
    ),
    bodyMedium: GoogleFonts.urbanist(
      fontSize: 14.sp,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
      height: 1.43,
    ),
    bodySmall: GoogleFonts.urbanist(
      fontSize: 12.sp,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.4,
      height: 1.33,
    ),
    // ---- Urbanist — labels (colourless; components drive foreground) ----
    labelLarge: GoogleFonts.urbanist(
      fontSize: 14.sp,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.1,
      height: 1.43,
    ),
    labelMedium: GoogleFonts.urbanist(
      fontSize: 12.sp,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
      height: 1.33,
    ),
    labelSmall: GoogleFonts.urbanist(
      fontSize: 11.sp,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
      height: 1.45,
    ),
  );

  // ---- Per-style getters ----------------------------------------------
  // Ported verbatim from the legacy `lib/theme/app_text_styles.dart`
  // (`AppTextStyles`) so call sites that need a single role token (e.g. the
  // auth screen) read the exact same Sora/Urbanist size/weight/height as the
  // matching role in [base] — zero visual change. Widgets that theme through
  // `Theme.of(context).textTheme` should keep using [base]; these getters are
  // for the handful of screens that reference a role directly.

  static TextStyle get displayLarge => GoogleFonts.sora(
        fontSize: 57.sp,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.25,
        height: 1.12,
      );

  static TextStyle get displayMedium => GoogleFonts.sora(
        fontSize: 45.sp,
        fontWeight: FontWeight.w700,
        letterSpacing: 0,
        height: 1.16,
      );

  static TextStyle get headlineLarge => GoogleFonts.sora(
        fontSize: 32.sp,
        fontWeight: FontWeight.w700,
        letterSpacing: 0,
        height: 1.25,
      );

  static TextStyle get headlineMedium => GoogleFonts.sora(
        fontSize: 28.sp,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        height: 1.29,
      );

  static TextStyle get headlineSmall => GoogleFonts.sora(
        fontSize: 24.sp,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        height: 1.33,
      );

  static TextStyle get titleLarge => GoogleFonts.urbanist(
        fontSize: 22.sp,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        height: 1.27,
      );

  static TextStyle get titleMedium => GoogleFonts.urbanist(
        fontSize: 16.sp,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15,
        height: 1.5,
      );

  static TextStyle get titleSmall => GoogleFonts.urbanist(
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        height: 1.43,
      );

  static TextStyle get bodyLarge => GoogleFonts.urbanist(
        fontSize: 16.sp,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        height: 1.5,
      );

  static TextStyle get bodyMedium => GoogleFonts.urbanist(
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        height: 1.43,
      );

  static TextStyle get bodySmall => GoogleFonts.urbanist(
        fontSize: 12.sp,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
        height: 1.33,
      );

  static TextStyle get labelLarge => GoogleFonts.urbanist(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        height: 1.43,
      );

  static TextStyle get labelSmall => GoogleFonts.urbanist(
        fontSize: 11.sp,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        height: 1.45,
      );
}

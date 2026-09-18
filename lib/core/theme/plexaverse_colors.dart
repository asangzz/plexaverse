import 'package:flutter/material.dart';

/// Plexaverse brand colour foundation.
///
/// The app ships a single, fixed Material 3 brand (violet, `#6C63FF`) with a
/// **dark-default** identity. This file follows the ProHealth reference's
/// three-layer structure, re-skinned with the Plexaverse token VALUES
/// (RULINGS.md: architecture = ProHealth, product identity = Plexaverse):
///
///   1. [PlexaversePalette] — the raw design-token hexes, one-to-one with
///      the values that lived in the legacy `lib/theme/app_colors.dart`
///      (`AppColors`). Reference these only when building schemes /
///      extensions; widgets read from the `ColorScheme` or the
///      [PlexaverseColors] extension instead.
///   2. [PlexaversePalette.darkScheme] / [lightScheme] — the M3
///      `ColorScheme`s. Because Plexaverse is dark-default, `darkScheme` is
///      the designed surface (hand-built to reproduce the exact brand hexes)
///      and `lightScheme` is a seeded companion built off the same violet
///      seed. The high-contrast schemes live in `AppTheme`.
///   3. [PlexaverseColors] — a [ThemeExtension] carrying the semantic brand
///      tokens that have no home in `ColorScheme`: the primary-dark shade,
///      the glass-card fill/border pair, the FAB gradient stops, the
///      status palette (success / warning / info), hairline / divider greys
///      and the page canvas.
///
/// Access the extension ergonomically via `context.brand` (see
/// [PlexaverseColorsX]).
class PlexaversePalette {
  const PlexaversePalette._();

  // ---- Brand violet (legacy `AppColors.primary` / `primaryDark`) ----
  static const Color primary = Color(0xFF6C63FF); // ★ brand primary
  static const Color primaryDark = Color(0xFF4B44CC); // pressed / gradient end
  static const Color secondary = Color(0xFF03DAC6); // teal accent

  // ---- Neutrals (legacy `AppColors.grey*`) ----
  static const Color grey50 = Color(0xFFFAFAFA);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey600 = Color(0xFF757575);
  static const Color grey800 = Color(0xFF424242);
  static const Color grey900 = Color(0xFF212121);

  // ---- Status — full-strength foreground colours (legacy semantics) ----
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFE53935);
  static const Color info = Color(0xFF2196F3);

  // ---- Light surfaces ----
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color backgroundLight = Color(0xFFF8F9FA);

  // ---- Dark surfaces (the default identity) ----
  static const Color surfaceDark = Color(0xFF1E1E2E);
  static const Color backgroundDark = Color(0xFF121212);

  /// Elevated dark bar background (legacy nav-bar / FAB rail tone).
  static const Color barDark = Color(0xFF1A1A2E);

  // ---- Glassmorphism tokens (legacy GlassCard rgba pairs) ----
  static const Color glassFillDark = Color(0x0AFFFFFF); // rgba(255,255,255,.04)
  static const Color glassBorderDark = Color(0x1FFFFFFF); // rgba(255,255,255,.12)
  static const Color glassFillLight = Color(0x0A000000); // rgba(0,0,0,.04)
  static const Color glassBorderLight = Color(0x1A000000); // rgba(0,0,0,.10)

  // ---- Brutalist light mode (auth screen — kept, do not redesign) ----
  static const Color brutalistBg = Color(0xFFF5F4EF); // warm parchment
  static const Color brutalistInk = Color(0xFF18181B); // near-black ink

  // ---- High contrast light (WCAG AAA — 7:1+ ratio) ----
  static const Color hcBackground = Color(0xFFFFFFFF);
  static const Color hcSurface = Color(0xFFFFFFFF);
  static const Color hcOnBackground = Color(0xFF000000);
  static const Color hcPrimary = Color(0xFF0000CC);
  static const Color hcSecondary = Color(0xFF006600);
  static const Color hcError = Color(0xFFBB0000);
  static const Color hcBorder = Color(0xFF000000);

  // ---- High contrast dark (WCAG AAA — 7:1+ ratio) ----
  static const Color hcBackgroundDark = Color(0xFF000000);
  static const Color hcSurfaceDark = Color(0xFF000000);
  static const Color hcOnBackgroundDark = Color(0xFFFFFFFF);
  static const Color hcPrimaryDark = Color(0xFF66B2FF);
  static const Color hcSecondaryDark = Color(0xFF66FF66);
  static const Color hcErrorDark = Color(0xFFFF6666);
  static const Color hcBorderDark = Color(0xFFFFFFFF);

  /// Hand-built dark scheme — the default Plexaverse surface. Exact brand
  /// hexes so violet reads true on the deep-charcoal canvas (a `fromSeed`
  /// dark scheme drifts the primary toward grey-lilac).
  static final ColorScheme darkScheme = ColorScheme.fromSeed(
    seedColor: primary,
    brightness: Brightness.dark,
    primary: primary,
    secondary: secondary,
    error: error,
    surface: surfaceDark,
  );

  /// Seeded light companion — same violet seed, light brightness. Kept as a
  /// coherent alternate (the switcher offers it) rather than a bespoke
  /// second design.
  static final ColorScheme lightScheme = ColorScheme.fromSeed(
    seedColor: primary,
    brightness: Brightness.light,
    primary: primary,
    secondary: secondary,
    error: error,
    surface: surfaceLight,
  );
}

/// Semantic brand tokens that sit outside the M3 `ColorScheme`. Register the
/// [light] / [dark] instances in `ThemeData.extensions` and read them via
/// `context.brand`.
///
/// Mirrors ProHealth's `ProHealthColors` extension, re-skinned to the
/// Plexaverse palette. Widgets never read raw hexes — they read this or the
/// `ColorScheme`.
@immutable
class PlexaverseColors extends ThemeExtension<PlexaverseColors> {
  const PlexaverseColors({
    required this.primaryDark,
    required this.glassFill,
    required this.glassBorder,
    required this.fabGradientStart,
    required this.fabGradientEnd,
    required this.success,
    required this.warning,
    required this.info,
    required this.hairline,
    required this.divider,
    required this.canvas,
    required this.barBackground,
  });

  /// Pressed / hover shade of the primary violet, also the FAB gradient end.
  final Color primaryDark;

  /// Glassmorphic card fill (legacy `GlassCard` bg token).
  final Color glassFill;

  /// Glassmorphic card 1px border (legacy `GlassCard` border token).
  final Color glassBorder;

  /// Center-FAB gradient stops (legacy bottom-nav FAB).
  final Color fabGradientStart;
  final Color fabGradientEnd;

  final Color success;
  final Color warning;
  final Color info;

  /// 1px card / container border.
  final Color hairline;

  /// Low-emphasis row divider.
  final Color divider;

  /// Page background behind cards / sheets (the scaffold canvas).
  final Color canvas;

  /// Elevated bar / rail background (nav bar, FAB rail).
  final Color barBackground;

  /// 15%-opacity tint of a status colour — the fill behind a status badge.
  /// Pairs the colour with an icon + text per the "colour never alone" rule.
  Color tint(Color statusColor) => statusColor.withValues(alpha: 0.15);

  /// Dark variant — the default identity.
  static const PlexaverseColors dark = PlexaverseColors(
    primaryDark: PlexaversePalette.primaryDark,
    glassFill: PlexaversePalette.glassFillDark,
    glassBorder: PlexaversePalette.glassBorderDark,
    fabGradientStart: PlexaversePalette.primary,
    fabGradientEnd: PlexaversePalette.primaryDark,
    success: PlexaversePalette.success,
    warning: PlexaversePalette.warning,
    info: PlexaversePalette.info,
    hairline: PlexaversePalette.glassBorderDark,
    divider: PlexaversePalette.grey800,
    canvas: PlexaversePalette.backgroundDark,
    barBackground: PlexaversePalette.barDark,
  );

  /// Light companion.
  static const PlexaverseColors light = PlexaverseColors(
    primaryDark: PlexaversePalette.primaryDark,
    glassFill: PlexaversePalette.glassFillLight,
    glassBorder: PlexaversePalette.glassBorderLight,
    fabGradientStart: PlexaversePalette.primary,
    fabGradientEnd: PlexaversePalette.primaryDark,
    success: PlexaversePalette.success,
    warning: PlexaversePalette.warning,
    info: PlexaversePalette.info,
    hairline: PlexaversePalette.grey200,
    divider: PlexaversePalette.grey200,
    canvas: PlexaversePalette.backgroundLight,
    barBackground: PlexaversePalette.surfaceLight,
  );

  @override
  PlexaverseColors copyWith({
    Color? primaryDark,
    Color? glassFill,
    Color? glassBorder,
    Color? fabGradientStart,
    Color? fabGradientEnd,
    Color? success,
    Color? warning,
    Color? info,
    Color? hairline,
    Color? divider,
    Color? canvas,
    Color? barBackground,
  }) {
    return PlexaverseColors(
      primaryDark: primaryDark ?? this.primaryDark,
      glassFill: glassFill ?? this.glassFill,
      glassBorder: glassBorder ?? this.glassBorder,
      fabGradientStart: fabGradientStart ?? this.fabGradientStart,
      fabGradientEnd: fabGradientEnd ?? this.fabGradientEnd,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      info: info ?? this.info,
      hairline: hairline ?? this.hairline,
      divider: divider ?? this.divider,
      canvas: canvas ?? this.canvas,
      barBackground: barBackground ?? this.barBackground,
    );
  }

  @override
  PlexaverseColors lerp(ThemeExtension<PlexaverseColors>? other, double t) {
    if (other is! PlexaverseColors) return this;
    return PlexaverseColors(
      primaryDark: Color.lerp(primaryDark, other.primaryDark, t)!,
      glassFill: Color.lerp(glassFill, other.glassFill, t)!,
      glassBorder: Color.lerp(glassBorder, other.glassBorder, t)!,
      fabGradientStart: Color.lerp(fabGradientStart, other.fabGradientStart, t)!,
      fabGradientEnd: Color.lerp(fabGradientEnd, other.fabGradientEnd, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      info: Color.lerp(info, other.info, t)!,
      hairline: Color.lerp(hairline, other.hairline, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      canvas: Color.lerp(canvas, other.canvas, t)!,
      barBackground: Color.lerp(barBackground, other.barBackground, t)!,
    );
  }
}

/// Ergonomic access to the [PlexaverseColors] extension: `context.brand`.
/// Falls back to [PlexaverseColors.dark] (the default identity) if the
/// extension is somehow not registered, so call sites never null-check.
extension PlexaverseColorsX on BuildContext {
  PlexaverseColors get brand =>
      Theme.of(this).extension<PlexaverseColors>() ?? PlexaverseColors.dark;
}

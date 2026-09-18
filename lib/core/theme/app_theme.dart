// `morphingButtonShape` is hidden: Plexaverse ships its own copy in
// core/ui/widgets/pressable_scale.dart (imported below), and the expressive_m3
// export of the same name would otherwise make the reference ambiguous.
import 'package:expressive_m3/expressive_m3.dart' hide morphingButtonShape;
import 'package:flutter/material.dart';

import '../responsive/screen_util.dart';
import '../ui/widgets/pressable_scale.dart';
import 'app_radius.dart';
import 'app_spacing.dart';
import 'app_text_theme.dart';
import 'plexaverse_colors.dart';

/// Material 3 theme builder for the Plexaverse brand.
///
/// Follows the ProHealth reference STRUCTURE — a private `_build(scheme,
/// brand)` composes `ThemeData` with `useMaterial3: true`, sets every M3
/// component default globally so stock widgets render on-brand with zero
/// per-call styling, registers [PlexaverseColors] as a theme extension
/// (read via `context.brand`), and installs the M3 Expressive page
/// transitions — re-skinned to the Plexaverse VALUES (violet `#6C63FF`,
/// Sora + Urbanist, dark default).
///
/// Plexaverse keeps its FIVE theme modes (RULINGS.md — product identity):
///   - [dark] — the **default** identity,
///   - [light] — a coherent seeded companion,
///   - [highContrastLight] / [highContrastDark] — WCAG AAA (7:1+) surfaces
///     with square-ish corners and heavy borders.
///
/// **Responsive:** dimensions are scaled against the 360-wide design frame
/// via the `.r` / `.w` / `.h` extensions and `.sp` (type, in [AppTextTheme]).
/// Because the scale factor is read at build time, the app root rebuilds the
/// theme on every metrics change so the values track rotation / resize.
class AppTheme {
  const AppTheme._();

  /// The default Plexaverse theme (dark identity).
  static ThemeData get dark =>
      _build(PlexaversePalette.darkScheme, PlexaverseColors.dark);

  /// Light companion.
  static ThemeData get light =>
      _build(PlexaversePalette.lightScheme, PlexaverseColors.light);

  /// WCAG AAA high-contrast light.
  static ThemeData get highContrastLight =>
      _buildHighContrast(Brightness.light);

  /// WCAG AAA high-contrast dark.
  static ThemeData get highContrastDark =>
      _buildHighContrast(Brightness.dark);

  static ThemeData _build(ColorScheme scheme, PlexaverseColors brand) {
    final text = AppTextTheme.base;

    return ThemeData(
      useMaterial3: true,
      brightness: scheme.brightness,
      colorScheme: scheme,
      textTheme: text,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      // M3 Expressive shared-axis (horizontal) page transitions across every
      // route, applied globally so every go_router push uses them —
      // emphasized easing, Reduce Motion honoured.
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: <TargetPlatform, PageTransitionsBuilder>{
          TargetPlatform.android: ExpressivePageTransitionsBuilder(),
          TargetPlatform.iOS: ExpressivePageTransitionsBuilder(),
        },
      ),
      scaffoldBackgroundColor: brand.canvas,
      // Brand tokens + the M3 Expressive emphasized type scale, derived from
      // the app's own (Sora / Urbanist) text theme so the brand fonts are
      // kept — read via `EmphasizedTextTheme.maybeOf(context)`.
      extensions: <ThemeExtension<dynamic>>[
        brand,
        EmphasizedTextTheme.of(text),
      ],

      // ---- App bar ----
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        titleTextStyle: text.titleLarge?.copyWith(color: scheme.onSurface),
        iconTheme: IconThemeData(color: scheme.onSurface, size: 22.r),
      ),

      // ---- FilledButton (primary CTA) ----
      // Shape is a WidgetStateProperty (M3E press morph): the pill corner
      // springs in to a rounded-rect while pressed. Every button gets the
      // expressive press response with no per-call-site wiring.
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          minimumSize: Size(64.w, AppSpacing.minTapTarget.h),
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.xl.w,
            vertical: AppSpacing.sm.h,
          ),
          textStyle: text.labelLarge,
        ).copyWith(shape: _pressMorphShape),
      ),

      // ---- ElevatedButton (legacy primary — kept full-width friendly) ----
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          elevation: 0,
          minimumSize: Size(64.w, AppSpacing.minTapTarget.h),
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.xl.w,
            vertical: AppSpacing.sm.h,
          ),
          textStyle: text.labelLarge,
        ).copyWith(shape: _pressMorphShape),
      ),

      // ---- OutlinedButton (secondary) ----
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: scheme.primary,
          minimumSize: Size(64.w, AppSpacing.minTapTarget.h),
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.xl.w,
            vertical: AppSpacing.sm.h,
          ),
          side: BorderSide(color: scheme.primary, width: 1.5),
          textStyle: text.labelLarge,
        ).copyWith(shape: _pressMorphShape),
      ),

      // ---- TextButton (tertiary / link) ----
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: scheme.primary,
          minimumSize: Size(48.w, 44.h),
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.md.w),
          textStyle: text.labelLarge,
        ).copyWith(shape: _pressMorphShape),
      ),

      // ---- TextField ----
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerHighest,
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppSpacing.lg.w,
          vertical: AppSpacing.lg.h,
        ),
        border: _fieldBorder(Colors.transparent, 0),
        enabledBorder: _fieldBorder(Colors.transparent, 0),
        focusedBorder: _fieldBorder(scheme.primary, 2),
        errorBorder: _fieldBorder(scheme.error, 1.5),
        focusedErrorBorder: _fieldBorder(scheme.error, 2),
        labelStyle: text.titleSmall,
        floatingLabelStyle: text.titleSmall?.copyWith(color: scheme.primary),
        hintStyle: text.bodyLarge?.copyWith(color: scheme.onSurfaceVariant),
        errorStyle: text.bodySmall?.copyWith(
          color: scheme.error,
          fontWeight: FontWeight.w500,
        ),
      ),

      // ---- Card (subtle hairline, no elevation — legacy Plexaverse look) ----
      cardTheme: CardThemeData(
        color: scheme.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.symmetric(vertical: AppSpacing.sm.h),
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.xl.r),
          side: BorderSide(color: brand.hairline),
        ),
      ),

      // ---- NavigationBar (M3 pill indicator; the 5-tab shell uses a custom
      // bar, but stock NavigationBar still renders on-brand where used) ----
      navigationBarTheme: NavigationBarThemeData(
        height: 64.h,
        backgroundColor: brand.barBackground,
        surfaceTintColor: Colors.transparent,
        indicatorColor: scheme.primaryContainer,
        elevation: 0,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            size: 22.r,
            color: states.contains(WidgetState.selected)
                ? scheme.primary
                : scheme.onSurfaceVariant,
          ),
        ),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? text.labelSmall?.copyWith(
                  color: scheme.primary,
                  fontWeight: FontWeight.w600,
                )
              : text.labelSmall?.copyWith(color: scheme.onSurfaceVariant),
        ),
      ),

      // ---- Chips ----
      chipTheme: ChipThemeData(
        backgroundColor: scheme.surface,
        selectedColor: scheme.primaryContainer,
        side: BorderSide(color: scheme.outlineVariant),
        labelStyle: text.bodyMedium,
        secondaryLabelStyle: text.bodyMedium,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.xxl.r),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.md.w,
          vertical: AppSpacing.sm.h,
        ),
      ),

      // ---- Bottom sheet ----
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: scheme.surface,
        modalBackgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        showDragHandle: true,
        dragHandleColor: brand.hairline,
        elevation: 0,
        modalElevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular((AppRadius.xxl - 4).r),
          ),
        ),
      ),

      // ---- Dialog ----
      dialogTheme: DialogThemeData(
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.xl.r),
        ),
        titleTextStyle: text.headlineSmall?.copyWith(color: scheme.onSurface),
        contentTextStyle: text.bodyMedium?.copyWith(color: scheme.onSurface),
      ),

      // ---- Dividers / list rows ----
      dividerTheme: DividerThemeData(
        color: brand.divider,
        thickness: 1,
        space: 1,
      ),
      listTileTheme: ListTileThemeData(
        iconColor: scheme.onSurfaceVariant,
        minTileHeight: 56.h,
        contentPadding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
        titleTextStyle: text.titleMedium?.copyWith(color: scheme.onSurface),
        subtitleTextStyle: text.bodySmall?.copyWith(
          color: scheme.onSurfaceVariant,
        ),
      ),

      // ---- SnackBar ----
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: scheme.inverseSurface,
        contentTextStyle: text.bodyMedium?.copyWith(
          color: scheme.onInverseSurface,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg.r),
        ),
      ),

      // ---- Progress indicators (M3 Expressive look) ----
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: scheme.primary,
        // Sanctioned opt-in for the M3 Expressive indicator look; deprecated
        // only because it becomes the default in a later release.
        // ignore: deprecated_member_use
        year2023: false,
        strokeCap: StrokeCap.round,
      ),

      iconTheme: IconThemeData(color: scheme.onSurface, size: 22.r),
    );
  }

  /// The M3 Expressive button press morph, shared by all button kinds: pill
  /// (`xxl`) at rest, springing in to `lg` while pressed. A getter (not a
  /// const) because the radii scale responsively via `.r`.
  static WidgetStateProperty<OutlinedBorder> get _pressMorphShape =>
      morphingButtonShape(
        restRadius: AppRadius.xxl.r,
        pressedRadius: AppRadius.lg.r,
      );

  static OutlineInputBorder _fieldBorder(Color color, double width) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.lg.r),
      borderSide: color == Colors.transparent
          ? BorderSide.none
          : BorderSide(color: color, width: width),
    );
  }

  // ---- High-contrast (WCAG AAA) — legacy Plexaverse structure kept, sharing
  // the Sora/Urbanist type scale and the press-morph shapes. Heavy borders,
  // squared corners, no elevation. ----
  static ThemeData _buildHighContrast(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final bg = isDark
        ? PlexaversePalette.hcBackgroundDark
        : PlexaversePalette.hcBackground;
    final onBg = isDark
        ? PlexaversePalette.hcOnBackgroundDark
        : PlexaversePalette.hcOnBackground;
    final primary = isDark
        ? PlexaversePalette.hcPrimaryDark
        : PlexaversePalette.hcPrimary;
    final secondary = isDark
        ? PlexaversePalette.hcSecondaryDark
        : PlexaversePalette.hcSecondary;
    final error = isDark
        ? PlexaversePalette.hcErrorDark
        : PlexaversePalette.hcError;
    final border = isDark
        ? PlexaversePalette.hcBorderDark
        : PlexaversePalette.hcBorder;
    const borderWidth = 2.0;
    final text = AppTextTheme.base;
    final onFill = isDark ? Colors.black : Colors.white;

    final scheme = ColorScheme(
      brightness: brightness,
      primary: primary,
      onPrimary: onFill,
      primaryContainer: primary.withValues(alpha: 0.15),
      onPrimaryContainer: primary,
      secondary: secondary,
      onSecondary: onFill,
      secondaryContainer: secondary.withValues(alpha: 0.15),
      onSecondaryContainer: secondary,
      tertiary: secondary,
      onTertiary: onFill,
      tertiaryContainer: secondary.withValues(alpha: 0.15),
      onTertiaryContainer: secondary,
      error: error,
      onError: onFill,
      errorContainer: error.withValues(alpha: 0.15),
      onErrorContainer: error,
      surface: bg,
      onSurface: onBg,
      onSurfaceVariant: onBg,
      surfaceContainerHighest: bg,
      outline: border,
      outlineVariant: border.withValues(alpha: 0.6),
      shadow: Colors.transparent,
      scrim: Colors.black.withValues(alpha: 0.7),
      inverseSurface: onBg,
      onInverseSurface: bg,
      inversePrimary: primary,
      surfaceTint: Colors.transparent,
    );

    // Reuse the brand extension (dark/light) for glass/status tokens; the
    // hairline/divider are overridden to the high-contrast border.
    final brand = (isDark ? PlexaverseColors.dark : PlexaverseColors.light)
        .copyWith(hairline: border, divider: border, canvas: bg);

    OutlineInputBorder hcBorder(Color c, double w) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.sm.r),
      borderSide: BorderSide(color: c, width: w),
    );

    ButtonStyle hcSquareShape(ButtonStyle style) => style.copyWith(
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm.r),
        ),
      ),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      textTheme: text,
      scaffoldBackgroundColor: bg,
      extensions: <ThemeExtension<dynamic>>[
        brand,
        EmphasizedTextTheme.of(text),
      ],
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: bg,
        foregroundColor: onBg,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: text.titleLarge?.copyWith(color: onBg),
        shape: Border(bottom: BorderSide(color: border, width: borderWidth)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: hcSquareShape(
          ElevatedButton.styleFrom(
            backgroundColor: primary,
            foregroundColor: onFill,
            elevation: 0,
            minimumSize: Size(64.w, AppSpacing.minTapTarget.h),
            textStyle: text.labelLarge,
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: hcSquareShape(
          FilledButton.styleFrom(
            backgroundColor: primary,
            foregroundColor: onFill,
            minimumSize: Size(64.w, AppSpacing.minTapTarget.h),
            textStyle: text.labelLarge,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: hcSquareShape(
          OutlinedButton.styleFrom(
            foregroundColor: primary,
            minimumSize: Size(64.w, AppSpacing.minTapTarget.h),
            side: BorderSide(color: primary, width: borderWidth),
            textStyle: text.labelLarge,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: false,
        border: hcBorder(border, borderWidth),
        enabledBorder: hcBorder(border, borderWidth),
        focusedBorder: hcBorder(primary, 3),
        errorBorder: hcBorder(error, borderWidth),
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppSpacing.lg.w,
          vertical: AppSpacing.lg.h,
        ),
        labelStyle: text.titleSmall?.copyWith(color: onBg),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: bg,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm.r),
          side: BorderSide(color: border, width: borderWidth),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 64.h,
        backgroundColor: bg,
        surfaceTintColor: Colors.transparent,
        indicatorColor: primary.withValues(alpha: 0.2),
        elevation: 0,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            size: 22.r,
            color: states.contains(WidgetState.selected)
                ? primary
                : onBg.withValues(alpha: 0.7),
          ),
        ),
        labelTextStyle: WidgetStatePropertyAll(
          text.labelSmall?.copyWith(
            color: onBg,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: border,
        thickness: borderWidth,
        space: 1,
      ),
      iconTheme: IconThemeData(color: onBg, size: 22.r),
    );
  }
}

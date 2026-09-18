import 'package:flutter/material.dart';

import 'zave_colors.dart';
import 'zave_geometry.dart';
import 'zave_motion.dart';
import 'zave_typography.dart';

/// The app's [ThemeData], composed from the Zave tokens.
///
/// ## Dark only, on purpose
///
/// The web app has exactly one appearance: the midnight ground with white-at-
/// opacity ink. There is no light mode to align to, so exposing one here would
/// invent a surface that has no counterpart on the web and would be the single
/// fastest way for the two products to diverge. The app forces dark.
///
/// (The pre-alignment app shipped five modes — light, dark and a high-contrast
/// pair — inherited from the reference skin it was cloned from. Dropping them
/// is part of the alignment, not an oversight.)
///
/// ## What this theme is and is not
///
/// It exists to make *incidental* Material surfaces — a dialog, a snack bar, a
/// text-selection handle, a scrollbar — look like they belong. Deliberate UI is
/// built from the Zave kit (`core/ui/zave/`), which draws its own containers
/// and does not read these values. So do not add component themes here hoping
/// to restyle the kit; change the kit.
class ZaveTheme {
  const ZaveTheme._();

  static ColorScheme get _scheme => const ColorScheme.dark(
    primary: ZaveColors.white,
    onPrimary: ZaveColors.ink,
    secondary: ZaveColors.blue,
    onSecondary: ZaveColors.white,
    surface: ZaveColors.midnight,
    onSurface: ZaveColors.white,
    // Zave has no red. Errors are amber — see ZaveField.
    error: ZaveColors.amber,
    onError: ZaveColors.ink,
    outline: ZaveColors.rule,
  );

  static ThemeData get dark {
    final ColorScheme scheme = _scheme;

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme,

      // Midnight, NOT transparent. ZaveGroundBox paints the full ground
      // gradient over this on aligned screens, so the flat colour is never
      // seen there — but a screen that has not been migrated yet still has a
      // correct dark base instead of falling through to white. (It did
      // exactly that when this was transparent: the splash, onboarding and
      // auth screens use a plain Scaffold and rendered white.)
      scaffoldBackgroundColor: ZaveColors.midnight,
      canvasColor: ZaveColors.midnight,

      textTheme: _textTheme,
      fontFamily: ZaveType.body.fontFamily,

      // No ripple splash: Zave's press response is ZavePress's scale, and a
      // Material ink splash on top of a glass pill reads as a second, competing
      // reaction to the same touch.
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,

      dividerTheme: const DividerThemeData(
        color: ZaveColors.rule,
        thickness: 1,
        space: 1,
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: ZaveType.h3,
        iconTheme: const IconThemeData(color: ZaveColors.white),
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: ZaveColors.deep,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: ZaveRadius.cardBr),
        titleTextStyle: ZaveType.h3,
        contentTextStyle: ZaveType.body,
      ),

      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: ZaveColors.midnight,
        surfaceTintColor: Colors.transparent,
        modalBackgroundColor: ZaveColors.midnight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(ZaveRadius.cardLg),
          ),
        ),
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: ZaveColors.deep,
        contentTextStyle: ZaveType.body,
        shape: RoundedRectangleBorder(borderRadius: ZaveRadius.cardSmBr),
        behavior: SnackBarBehavior.floating,
      ),

      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: ZaveColors.white,
        linearTrackColor: ZaveColors.rule,
        circularTrackColor: Colors.transparent,
      ),

      textSelectionTheme: TextSelectionThemeData(
        cursorColor: ZaveColors.white,
        selectionColor: ZaveColors.blue.withValues(alpha: 0.4),
        selectionHandleColor: ZaveColors.white,
      ),

      iconTheme: const IconThemeData(color: ZaveColors.white, size: 20),

      // Curved page transitions, not the platform's. Zave's motion rule is
      // "short and physical; nothing bounces", and the default iOS/Android
      // transitions are neither short nor consistent with each other.
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: <TargetPlatform, PageTransitionsBuilder>{
          TargetPlatform.iOS: FadeForwardsPageTransitionsBuilder(),
          TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
          TargetPlatform.macOS: FadeForwardsPageTransitionsBuilder(),
        },
      ),
    );
  }

  /// Maps the Zave roles onto Material's type slots, so an incidental Material
  /// widget picks up the right face without being restyled by hand.
  static TextTheme get _textTheme => TextTheme(
    displayLarge: ZaveType.hero,
    displayMedium: ZaveType.h2,
    displaySmall: ZaveType.h2,
    headlineLarge: ZaveType.h2,
    headlineMedium: ZaveType.h3,
    headlineSmall: ZaveType.h3,
    titleLarge: ZaveType.h3,
    titleMedium: ZaveType.label,
    titleSmall: ZaveType.label,
    bodyLarge: ZaveType.lead,
    bodyMedium: ZaveType.body,
    bodySmall: ZaveType.caption,
    labelLarge: ZaveType.button,
    labelMedium: ZaveType.label,
    labelSmall: ZaveType.kicker,
  );

  /// Kept next to the theme so the rule travels with it: Zave uses no spring
  /// with overshoot anywhere. See [ZaveMotion].
  static const Duration pageTransition = ZaveMotion.page;
}

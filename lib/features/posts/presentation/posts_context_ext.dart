import 'package:flutter/material.dart';

/// Minimal presentation helpers used across the posts pages, mirroring the
/// three members the legacy `core/extensions/context_extensions.dart` provided
/// (`colors` / `isDark` / `showSnackBar`).
///
/// Defined locally instead of importing the legacy extension because that file
/// still imports the stale l10n path (`package:plexaverse/l10n/app_localizations
/// .dart`, class `AppLocalizations`) which no longer resolves after the l10n
/// migration; depending on it would break the whole posts slice. The
/// cleanup/fix phase reconciles `context_extensions.dart`; until then the
/// posts feature is self-contained. Colours read straight from the active
/// `ColorScheme` (theme values are Plexaverse brand per the theme migration).
extension PostsContextX on BuildContext {
  ColorScheme get colors => Theme.of(this).colorScheme;

  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  void showSnackBar(String message, {bool isError = false}) {
    final scheme = Theme.of(this).colorScheme;
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? scheme.error : scheme.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

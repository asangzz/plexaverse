import 'package:flutter/services.dart';

/// Subtle, consistent haptic feedback, centralised so call sites express
/// *intent* and the whole app's haptic language tunes in one place. No-ops on
/// platforms without haptics.
///
/// **Used sparingly — only on genuine outcomes of important actions** (a post
/// published, a save succeeded, a submission failed). Routine taps (tabs,
/// list rows, ordinary button presses) deliberately have NO haptic:
/// pervasive buzzing feels cheap.
///
/// [selection] / [light] are kept as the vocabulary but are intentionally not
/// wired to routine interactions.
///
/// Ported from the ProHealth reference (`core/ui/motion/app_haptics.dart`).
class AppHaptics {
  const AppHaptics._();

  /// A discrete choice (kept for completeness; not used on routine taps).
  static void selection() => HapticFeedback.selectionClick();

  /// A light confirming tap (kept for completeness; not used on routine CTAs).
  static void light() => HapticFeedback.lightImpact();

  /// A positive outcome of an important action (post published, saved).
  static void success() => HapticFeedback.lightImpact();

  /// A rejection / failed submission surfaced — slightly firmer so it's
  /// noticed, but still restrained.
  static void warning() => HapticFeedback.mediumImpact();
}

import 'package:flutter/widgets.dart';

/// Motion tokens for the Plexaverse app — one source of truth for durations
/// and curves so animations stay subtle and consistent. Tune here to
/// recalibrate the whole app at once.
///
/// Ported from the ProHealth reference (`core/ui/motion/app_motion.dart`).
class AppMotion {
  const AppMotion._();

  /// Micro-feedback (taps, toggles, small fades).
  static const Duration fast = Duration(milliseconds: 140);

  /// Standard entrance / element transition.
  static const Duration medium = Duration(milliseconds: 240);

  /// Page transitions.
  static const Duration page = Duration(milliseconds: 280);

  /// Gap between successive items in a staggered list.
  static const Duration stagger = Duration(milliseconds: 45);

  /// Cap on a staggered list's total lead-in, so long lists don't crawl in.
  static const Duration staggerMaxDelay = Duration(milliseconds: 360);

  /// Gentle deceleration — the default for entrances + transitions.
  static const Curve curve = Curves.easeOutCubic;

  /// Soft ease for symmetric (in/out) transitions like fades.
  static const Curve fade = Curves.easeInOut;

  /// Vertical offset (logical px) an entrance slides up from. Small on
  /// purpose — a subtle lift, not a swoop.
  static const double slideOffset = 12;
}

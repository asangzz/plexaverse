import 'package:flutter/animation.dart';

/// Zave motion tokens.
///
/// The web source states the rule in four words: **"short and physical.
/// Nothing bounces."** There is no spring, no overshoot and no elastic curve
/// anywhere in this system. If a transition draws attention to itself, it is
/// wrong.
///
/// This is a real departure from the app's pre-alignment skin, which leaned on
/// M3-Expressive springs. Those are not part of Zave and should not be
/// reintroduced on Zave surfaces.
class ZaveMotion {
  const ZaveMotion._();

  /// The press/fill transition — CSS `transition: background 0.2s`.
  static const Duration fast = Duration(milliseconds: 200);

  /// The transform transition — CSS `transition: transform 0.15s`.
  static const Duration quick = Duration(milliseconds: 150);

  /// Page-level transitions. Not a Zave token; the web has no page transitions
  /// to port, so this is the platform-reasonable default the shell uses.
  static const Duration page = Duration(milliseconds: 260);

  /// Everything in Zave eases the same way.
  static const Curve curve = Curves.easeInOut;

  /// `zvSpin` — 42s linear, infinite. The slow ambient rotation; the only
  /// long-running animation in the system.
  static const Duration spin = Duration(seconds: 42);

  /// `zvDot` — 1.2s ease-in-out, infinite. The "thinking" dots on AI surfaces.
  /// Keyframes: opacity 0.25 at 0/80/100%, 1.0 at 40%.
  static const Duration thinkingDot = Duration(milliseconds: 1200);
  static const double thinkingDotMin = 0.25;
  static const double thinkingDotMax = 1.0;

  /// The pressed-scale for tappable surfaces.
  ///
  /// The web lifts the primary button on hover (`translateY(-2px)`), which has
  /// no touch analogue — a finger is already on the element. A touch device
  /// gets a small scale-down instead, which is the same idea (the control
  /// acknowledges the pointer) expressed in the grammar touch actually has.
  static const double pressedScale = 0.97;
}

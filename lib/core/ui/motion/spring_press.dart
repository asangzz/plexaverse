import '../widgets/pressable_scale.dart';
import 'package:flutter/widgets.dart';

/// App-standard spring press response for tappable surfaces (cards, rows,
/// chips): the child springs down on pointer-down and bounces back on
/// release on a physics spring — not a fixed curve.
///
/// A thin wrapper over [PressableScale] so feature code depends on one
/// app-owned seam, with the app's defaults baked in:
///
///  * **haptic off** — the app's haptic language is deliberately sparse
///    (only genuine outcomes buzz, see `AppHaptics`), so the press response
///    is purely visual;
///  * passive `Listener` under the hood — the wrapped widget keeps handling
///    its own taps and ink;
///  * Reduce Motion honoured by the spring (snaps, no lengthy bounce).
///
/// Ported from the ProHealth reference (`core/ui/motion/spring_press.dart`).
class SpringPress extends StatelessWidget {
  const SpringPress({required this.child, this.enabled = true, super.key});

  final Widget child;

  /// Pass false for a non-interactive state (e.g. `onTap == null`) so a dead
  /// surface doesn't appear to react.
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return PressableScale(enabled: enabled, haptic: false, child: child);
  }
}

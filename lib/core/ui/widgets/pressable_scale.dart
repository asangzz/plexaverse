import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

/// Wraps a tappable child with a Material 3 Expressive press response: the
/// child springs down on pointer-down and bounces back on release using a
/// real [SpringSimulation] (physics motion, not a fixed easing curve). The
/// [Listener] is passive — it only observes pointer events, so the wrapped
/// widget (button, card, …) keeps handling its own taps.
///
/// Pass `enabled: false` (e.g. for a disabled button) to freeze it at rest
/// so a non-interactive control doesn't appear to react.
///
/// Ported from the ProHealth reference
/// (`core/ui/widgets/pressable_scale.dart`). Feature code should wrap
/// surfaces in [SpringPress] (the app-owned seam) rather than this directly.
class PressableScale extends StatefulWidget {
  const PressableScale({
    required this.child,
    this.enabled = true,
    this.haptic = false,
    super.key,
  });

  static const double _pressedScale = 0.95;

  /// Snappy but lively spring — slight overshoot on release.
  static const SpringDescription _spring = SpringDescription(
    mass: 1,
    stiffness: 520,
    damping: 20,
  );

  final Widget child;
  final bool enabled;

  /// Kept for parity with the package API and the [SpringPress] seam; the
  /// press response is purely visual by default (the app's haptic language
  /// is sparse — see `AppHaptics`).
  final bool haptic;

  @override
  State<PressableScale> createState() => _PressableScaleState();
}

class _PressableScaleState extends State<PressableScale>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController.unbounded(
    vsync: this,
    value: 1,
  );

  void _springTo(double target) {
    if (!widget.enabled) return;
    _controller.animateWith(
      SpringSimulation(
        PressableScale._spring,
        _controller.value,
        target,
        _controller.velocity,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => _springTo(PressableScale._pressedScale),
      onPointerUp: (_) => _springTo(1),
      onPointerCancel: (_) => _springTo(1),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, child) =>
            Transform.scale(scale: _controller.value, child: child),
        child: widget.child,
      ),
    );
  }
}

/// A button [WidgetStateProperty] shape that morphs its corner radius on
/// press — the M3 Expressive shape-morph. At rest the shape uses
/// [restRadius]; while pressed it snaps to [pressedRadius] and the host
/// `Material` animates the transition. Pair with [PressableScale] for the
/// combined squish + corner morph.
WidgetStateProperty<OutlinedBorder> morphingButtonShape({
  required double restRadius,
  required double pressedRadius,
}) {
  return WidgetStateProperty.resolveWith<OutlinedBorder>((states) {
    final radius = states.contains(WidgetState.pressed)
        ? pressedRadius
        : restRadius;
    return RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius));
  });
}

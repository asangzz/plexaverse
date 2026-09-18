import 'package:flutter/widgets.dart';

import '../../theme/zave/zave.dart';

/// The Zave press response: a small, curved scale-down with **no overshoot**.
///
/// This exists instead of the app's [PressableScale] because that widget uses a
/// [SpringSimulation] tuned for "slight overshoot on release" — which is
/// precisely what Zave's motion rule forbids ("short and physical. Nothing
/// bounces."). Use this on every Zave surface; use [PressableScale] on none.
///
/// The [Listener] is passive: it observes pointer events only, so the wrapped
/// widget keeps handling its own taps and gestures.
class ZavePress extends StatefulWidget {
  const ZavePress({
    required this.child,
    this.enabled = true,
    super.key,
  });

  final Widget child;

  /// `false` freezes the child at rest, so a disabled control does not appear
  /// to react to a tap it is going to ignore.
  final bool enabled;

  @override
  State<ZavePress> createState() => _ZavePressState();
}

class _ZavePressState extends State<ZavePress>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: ZaveMotion.quick,
    reverseDuration: ZaveMotion.fast,
  );

  late final Animation<double> _scale = Tween<double>(
    begin: 1,
    end: ZaveMotion.pressedScale,
  ).animate(CurvedAnimation(parent: _c, curve: ZaveMotion.curve));

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  void _down(_) {
    if (widget.enabled) _c.forward();
  }

  void _up([_]) {
    if (widget.enabled) _c.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: _down,
      onPointerUp: _up,
      onPointerCancel: _up,
      child: ScaleTransition(scale: _scale, child: widget.child),
    );
  }
}

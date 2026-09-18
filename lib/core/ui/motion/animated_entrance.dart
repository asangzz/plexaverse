import 'dart:async';

import 'package:expressive_m3/expressive_m3.dart';
import 'package:flutter/material.dart';

import 'app_motion.dart';

/// Subtle one-shot entrance: a gentle fade + small upward slide, played once
/// when the widget first mounts. The building block for staggered lists and
/// section reveals.
///
/// **Spring-settled (M3 Expressive):** the entrance is driven by the ambient
/// [MotionSchemeScope]'s default spatial spring ([SpringDrive.springTo]) —
/// real physics with a whisper of overshoot on the slide — rather than a
/// fixed-duration curve. The fade clamps at 1, so only the position breathes.
///
/// Honours Reduce Motion (`MediaQuery.disableAnimations`) — it renders the
/// final state instantly, no movement. Pass a [delay] to stagger siblings
/// (see [AppEntrance.staggerDelay]).
///
/// Ported from the ProHealth reference
/// (`core/ui/motion/animated_entrance.dart`).
class FadeSlideIn extends StatefulWidget {
  const FadeSlideIn({
    required this.child,
    this.delay = Duration.zero,
    this.duration,
    super.key,
  });

  final Widget child;
  final Duration delay;

  /// Legacy knob from the curve-driven implementation — the spring's settle
  /// time is governed by the motion scheme now; kept so call sites compile.
  final Duration? duration;

  @override
  State<FadeSlideIn> createState() => _FadeSlideInState();
}

class _FadeSlideInState extends State<FadeSlideIn>
    with SingleTickerProviderStateMixin {
  // Unbounded: the spatial spring is under-damped, so the value briefly
  // overshoots 1 (the expressive bounce) before settling.
  late final AnimationController _controller =
      AnimationController.unbounded(vsync: this, value: 0);
  Timer? _delayTimer;
  bool _kicked = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Kicked here (not initState) so the ambient MotionSchemeScope is
    // readable; the flag keeps it one-shot across dependency changes.
    if (_kicked) return;
    _kicked = true;
    final spring = MotionSchemeScope.of(context).spatialDefault;
    if (widget.delay == Duration.zero) {
      _controller.springTo(1, spring);
    } else {
      _delayTimer = Timer(widget.delay, () {
        if (mounted) _controller.springTo(1, spring);
      });
    }
  }

  @override
  void dispose() {
    _delayTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Reduce Motion: skip the movement entirely, show the final state.
    if (MediaQuery.maybeOf(context)?.disableAnimations ?? false) {
      return widget.child;
    }
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Opacity(
        opacity: _controller.value.clamp(0.0, 1.0),
        child: Transform.translate(
          offset: Offset(0, (1 - _controller.value) * AppMotion.slideOffset),
          child: child,
        ),
      ),
      child: widget.child,
    );
  }
}

/// Entrance helpers.
class AppEntrance {
  const AppEntrance._();

  /// The lead-in delay for the item at [index] in a staggered list — capped
  /// so long lists still finish promptly.
  static Duration staggerDelay(int index) {
    final delay = AppMotion.stagger * index;
    return delay > AppMotion.staggerMaxDelay
        ? AppMotion.staggerMaxDelay
        : delay;
  }

  /// Re-keys an entrance by [generation] so it **replays** when that value
  /// changes. Pass the freshly-fetched data object — a new instance arrives
  /// on every refetch (pull-to-refresh / invalidate), so the cascade plays
  /// again; ordinary rebuilds keep the same instance and don't replay. Null
  /// generation → no key (plays once, on first mount).
  static Key? _key(Object? generation, int index) => generation == null
      ? null
      : ValueKey<String>('e${identityHashCode(generation)}_$index');

  /// Wraps each child in a staggered [FadeSlideIn] — drop-in for a Column /
  /// ListView `children` list to make a section cascade in. See [generation]
  /// to replay on refetch.
  static List<Widget> staggered(List<Widget> children, {Object? generation}) =>
      <Widget>[
        for (var i = 0; i < children.length; i++)
          FadeSlideIn(
            key: _key(generation, i),
            delay: staggerDelay(i),
            child: children[i],
          ),
      ];

  /// A single staggered item for a `ListView.builder` / `.separated`
  /// itemBuilder. Pass [generation] (the fetched list) to replay on refetch.
  static Widget item(int index, Widget child, {Object? generation}) =>
      FadeSlideIn(
        key: _key(generation, index),
        delay: staggerDelay(index),
        child: child,
      );
}

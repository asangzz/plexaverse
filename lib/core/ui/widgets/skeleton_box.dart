import 'package:flutter/material.dart';

import '../../responsive/screen_util.dart';
import '../../theme/app_radius.dart';

/// One loading-skeleton block: a surface-variant rounded rectangle pulsing
/// at ~1Hz, fully static under Reduce Motion. Size the boxes to the real
/// widgets so the loaded layout doesn't shift. Width-less boxes fill their
/// row.
///
/// Ported from the ProHealth reference (`core/ui/widgets/skeleton_box.dart`).
class SkeletonBox extends StatefulWidget {
  const SkeletonBox({
    required this.height,
    this.width,
    this.radius = AppRadius.md,
    super.key,
  });

  final double height;
  final double? width;
  final double radius;

  @override
  State<SkeletonBox> createState() => _SkeletonBoxState();
}

class _SkeletonBoxState extends State<SkeletonBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    // ~1Hz full pulse (down + back up).
    duration: const Duration(milliseconds: 500),
    lowerBound: 0.55,
    upperBound: 1.0,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final reduceMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    if (reduceMotion) {
      if (_controller.isAnimating) _controller.stop();
    } else if (!_controller.isAnimating) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Align(
      alignment: Alignment.centerLeft,
      child: FadeTransition(
        opacity: _controller,
        child: Container(
          width: widget.width == null ? double.infinity : widget.width!.w,
          height: widget.height.h,
          decoration: BoxDecoration(
            color: scheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(widget.radius.r),
          ),
        ),
      ),
    );
  }
}

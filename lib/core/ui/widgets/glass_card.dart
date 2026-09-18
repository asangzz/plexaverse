import 'package:flutter/material.dart';

import '../../responsive/screen_util.dart';
import '../../theme/app_radius.dart';
import '../../theme/plexaverse_colors.dart';
import '../motion/spring_press.dart';

/// Glassmorphic card — the Plexaverse signature surface.
///
/// The fill / border tokens live on the [PlexaverseColors] theme extension
/// (`context.brand.glassFill` / `glassBorder`), which carries the exact
/// legacy rgba pairs (dark: white 4% fill / white 12% border; light: black
/// 4% / black 10%). Overrides are still accepted for one-off surfaces.
///
/// Ported from `lib/presentation/common/widgets/glass_card.dart`; the raw
/// `Color(0x..)` hexes moved into the brand extension and the tappable
/// variant now uses [SpringPress] for the physics squish.
class GlassCard extends StatelessWidget {
  const GlassCard({
    required this.child,
    this.padding,
    this.radius,
    this.bgOverride,
    this.borderOverride,
    this.shadows,
    this.onTap,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? radius;
  final Color? bgOverride;
  final Color? borderOverride;
  final List<BoxShadow>? shadows;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    final bg = bgOverride ?? brand.glassFill;
    final border = borderOverride ?? brand.glassBorder;
    final r = (radius ?? AppRadius.xl).r;

    final box = Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(r),
        border: Border.all(color: border, width: 1),
        boxShadow: shadows,
      ),
      child: padding != null ? Padding(padding: padding!, child: child) : child,
    );

    if (onTap != null) {
      return SpringPress(
        child: GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: box,
        ),
      );
    }
    return box;
  }
}

/// Gradient card used for hero sections (streak, mission, etc.). Callers
/// pass the gradient stops — commonly `[context.brand.fabGradientStart,
/// context.brand.fabGradientEnd]` for the brand violet ramp.
///
/// Ported unchanged from the legacy widget, rewired to the core layer.
class GradientCard extends StatelessWidget {
  const GradientCard({
    required this.child,
    required this.colors,
    this.begin = Alignment.topLeft,
    this.end = Alignment.bottomRight,
    this.padding,
    this.radius,
    this.onTap,
    this.shadows,
    super.key,
  });

  final Widget child;
  final List<Color> colors;
  final AlignmentGeometry begin;
  final AlignmentGeometry end;
  final EdgeInsetsGeometry? padding;
  final double? radius;
  final VoidCallback? onTap;
  final List<BoxShadow>? shadows;

  static const double _defaultRadius = 20;

  @override
  Widget build(BuildContext context) {
    final box = Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: colors, begin: begin, end: end),
        borderRadius: BorderRadius.circular((radius ?? _defaultRadius).r),
        boxShadow: shadows,
      ),
      child: padding != null ? Padding(padding: padding!, child: child) : child,
    );

    if (onTap != null) {
      return SpringPress(child: GestureDetector(onTap: onTap, child: box));
    }
    return box;
  }
}

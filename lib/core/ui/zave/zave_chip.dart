import 'package:flutter/material.dart';

import '../../theme/zave/zave.dart';
import 'zave_press.dart';

/// A Zave chip / tab.
///
/// **Selected inverts to solid white with ink letters.** It is never tinted,
/// never outlined in a brand colour, and tabs are never underlined — that
/// inversion is the whole selection language of this system, and it is the
/// thing most likely to be "improved" by accident.
///
/// ## Why the two states CROSS-FADE instead of being one AnimatedContainer
///
/// Because an AnimatedContainer here threw, on every single tap, for the whole
/// length of the transition — and what the user saw was a red error box where
/// the chip should be, for about a sixth of a second, every time they switched
/// a tab.
///
/// `ZaveSurface.chip` carries a [ZaveEdgeBorder]; `ZaveSurface.chipSelected`
/// has no border at all. AnimatedContainer lerps the decorations, which calls
/// `BoxBorder.lerp(ZaveEdgeBorder(), null)` — and that is a STATIC with
/// hardcoded `is Border?` / `is BorderDirectional?` checks, so it cannot
/// interpolate a custom BoxBorder subclass and throws instead. No amount of
/// implementing lerp on `ZaveEdgeBorder` fixes it; the static never asks.
///
/// So nothing interpolates a decoration any more. The two surfaces are drawn
/// as separate static layers and their OPACITY is animated, which is a real
/// transition that cannot crash. Anything else in this kit that swaps an
/// AnimatedContainer between a bordered and an unbordered Zave surface has the
/// same bug — `zave_chip_lerp_test.dart` is the one that pins it.
class ZaveChip extends StatelessWidget {
  const ZaveChip({
    required this.label,
    required this.selected,
    this.onTap,
    this.icon,
    this.badge,
    super.key,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final Widget? icon;

  /// A trailing count, rendered in the current foreground at 60%.
  final String? badge;

  @override
  Widget build(BuildContext context) {
    final Color fg = selected ? ZaveColors.ink : ZaveColors.ink85;

    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: ZavePress(
        enabled: onTap != null,
        child: GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: ZaveSpace.minTapTarget),
            child: Stack(
              children: <Widget>[
                // Both surfaces, always present, never interpolated. The
                // unselected one carries the edge border; the selected one is
                // the lavender ramp. Opacity is the only thing that moves.
                Positioned.fill(
                  child: IgnorePointer(
                    child: AnimatedOpacity(
                      duration: ZaveMotion.fast,
                      curve: ZaveMotion.curve,
                      opacity: selected ? 0 : 1,
                      child: DecoratedBox(decoration: ZaveSurface.chip),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: IgnorePointer(
                    child: AnimatedOpacity(
                      duration: ZaveMotion.fast,
                      curve: ZaveMotion.curve,
                      opacity: selected ? 1 : 0,
                      child: DecoratedBox(decoration: ZaveSurface.chipSelected),
                    ),
                  ),
                ),
                Padding(
                  padding: ZaveSpace.chipPad,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      if (icon != null) ...<Widget>[
                        IconTheme.merge(
                          data: IconThemeData(color: fg, size: 16),
                          child: icon!,
                        ),
                        SizedBox(width: ZaveSpace.sm),
                      ],
                      Text(label, style: ZaveType.label.copyWith(color: fg)),
                      if (badge != null) ...<Widget>[
                        SizedBox(width: ZaveSpace.sm),
                        Text(
                          badge!,
                          style: ZaveType.label.copyWith(
                            color: fg.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// `.pill` — a static, non-selectable pill. A label, not a control.
///
/// Use [ZaveChip] if it can be tapped; a pill that responds to touch reads as a
/// chip whose selected state is broken.
class ZavePill extends StatelessWidget {
  const ZavePill({required this.label, this.color, this.leading, super.key});

  final String label;

  /// Tints the label and, if [leading] is a [ZaveDot], the dot. The pill's own
  /// fill never changes — status is carried by the text and dot, not the glass.
  final Color? color;

  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: ZaveSpace.pillPad,
      decoration: ZaveSurface.pill,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (leading != null) ...<Widget>[
            leading!,
            SizedBox(width: ZaveSpace.sm),
          ],
          // Flexible + ellipsis, though the Row is min-sized. The pill is
          // normally a count or a status word and never needs it — but it is
          // handed free text by callers (a category name, a plan name), and an
          // unbounded Text inside a min-sized Row does not shrink: it paints
          // past the parent and renders the overflow bars. Degrading to an
          // ellipsis costs short labels nothing.
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: ZaveType.label.copyWith(color: color ?? ZaveColors.ink85),
            ),
          ),
        ],
      ),
    );
  }
}

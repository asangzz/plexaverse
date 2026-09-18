import 'package:flutter/material.dart';

import '../../theme/zave/zave.dart';
import 'zave_press.dart';

/// A Zave chip / tab.
///
/// **Selected inverts to solid white with ink letters.** It is never tinted,
/// never outlined in a brand colour, and tabs are never underlined — that
/// inversion is the whole selection language of this system, and it is the
/// thing most likely to be "improved" by accident.
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
          child: AnimatedContainer(
            duration: ZaveMotion.fast,
            curve: ZaveMotion.curve,
            padding: ZaveSpace.chipPad,
            constraints: BoxConstraints(minHeight: ZaveSpace.minTapTarget),
            decoration: selected
                ? ZaveSurface.chipSelected
                : ZaveSurface.chip,
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
  const ZavePill({
    required this.label,
    this.color,
    this.leading,
    super.key,
  });

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
          Text(
            label,
            style: ZaveType.label.copyWith(color: color ?? ZaveColors.ink85),
          ),
        ],
      ),
    );
  }
}

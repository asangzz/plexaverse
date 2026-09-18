import 'package:flutter/material.dart';

import '../../responsive/screen_util.dart';
import '../../theme/app_radius.dart';
import 'pressable_scale.dart';

/// Tonal secondary action with an optional leading icon — an expressive pill
/// that morphs on press and springs, pairing cleanly beside the filled
/// [PrimaryActionButton]. Pass `onPressed: null` to disable.
///
/// Ported from the ProHealth reference
/// (`core/ui/widgets/secondary_action_button.dart`).
class SecondaryActionButton extends StatelessWidget {
  const SecondaryActionButton({
    required this.label,
    required this.onPressed,
    this.leadingIcon,
    this.height = _defaultHeight,
    super.key,
  });

  static const double _defaultHeight = 52;
  static const double _letterSpacing = 0.2;
  static const double _iconSize = 18;
  static const Duration _morphDuration = Duration(milliseconds: 150);

  final String label;
  final VoidCallback? onPressed;
  final IconData? leadingIcon;
  final double height;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = FilledButton.styleFrom(
      animationDuration: _morphDuration,
      textStyle: theme.textTheme.titleSmall?.copyWith(
        fontWeight: FontWeight.w600,
        letterSpacing: _letterSpacing,
      ),
    ).copyWith(
      shape: morphingButtonShape(
        restRadius: AppRadius.pill,
        pressedRadius: AppRadius.md.r,
      ),
    );
    final icon = leadingIcon;
    return PressableScale(
      enabled: onPressed != null,
      child: SizedBox(
        height: height.h,
        child: icon == null
            ? FilledButton.tonal(
                onPressed: onPressed,
                style: style,
                child:
                    Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
              )
            : FilledButton.tonalIcon(
                onPressed: onPressed,
                icon: Icon(icon, size: _iconSize.r),
                label:
                    Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
                style: style,
              ),
      ),
    );
  }
}

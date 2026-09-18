import 'package:flutter/material.dart';

import '../../responsive/screen_util.dart';
import '../../theme/app_radius.dart';
import 'pressable_scale.dart';

/// Filled primary CTA — a clean expressive pill that morphs its corners on
/// press and springs. Pass `onPressed: null` for the disabled state.
///
/// Ported from the ProHealth reference
/// (`core/ui/widgets/primary_action_button.dart`). Heights scale via `.h`.
class PrimaryActionButton extends StatelessWidget {
  const PrimaryActionButton({
    required this.label,
    required this.onPressed,
    this.height = _defaultHeight,
    super.key,
  });

  static const double _defaultHeight = 52;
  static const double _letterSpacing = 0.2;
  static const Duration _morphDuration = Duration(milliseconds: 150);

  final String label;
  final VoidCallback? onPressed;
  final double height;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return PressableScale(
      enabled: onPressed != null,
      child: SizedBox(
        height: height.h,
        child: FilledButton(
          onPressed: onPressed,
          style: FilledButton.styleFrom(
            backgroundColor: scheme.primary,
            foregroundColor: scheme.onPrimary,
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
          ),
          child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../responsive/screen_util.dart';
import '../../theme/app_spacing.dart';
import '../motion/spring_press.dart';

/// The four button roles Plexaverse ships. The visual style comes from the
/// global button themes in `AppTheme` (fill / outline / text + M3E press
/// morph); [AppButton] just picks the role, handles the loading spinner and
/// the optional leading icon, and wraps the whole control in [SpringPress]
/// for the physics squish.
///
/// Ported from `lib/presentation/common/widgets/app_button.dart`; visuals
/// unchanged, rewired to the core theme/responsive layer and given the
/// shared press response.
enum AppButtonVariant { primary, secondary, outline, text }

class AppButton extends StatelessWidget {
  const AppButton({
    required this.label,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.isLoading = false,
    this.leadingIcon,
    this.width,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool isLoading;
  final IconData? leadingIcon;
  final double? width;

  static const double _spinnerSize = 20;
  static const double _iconSize = 18;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final child = isLoading
        ? SizedBox(
            height: _spinnerSize.r,
            width: _spinnerSize.r,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: variant == AppButtonVariant.primary
                  ? scheme.onPrimary
                  : scheme.primary,
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (leadingIcon != null) ...<Widget>[
                Icon(leadingIcon, size: _iconSize.r),
                SizedBox(width: AppSpacing.sm.w),
              ],
              Text(label),
            ],
          );

    final effectiveOnPressed = isLoading ? null : onPressed;
    final button = switch (variant) {
      AppButtonVariant.primary => FilledButton(
          onPressed: effectiveOnPressed,
          child: child,
        ),
      AppButtonVariant.secondary => FilledButton.tonal(
          onPressed: effectiveOnPressed,
          child: child,
        ),
      AppButtonVariant.outline => OutlinedButton(
          onPressed: effectiveOnPressed,
          child: child,
        ),
      AppButtonVariant.text => TextButton(
          onPressed: effectiveOnPressed,
          child: child,
        ),
    };

    final sized = width != null ? SizedBox(width: width, child: button) : button;
    return SpringPress(enabled: effectiveOnPressed != null, child: sized);
  }
}

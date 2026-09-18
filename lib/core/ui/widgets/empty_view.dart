import 'package:flutter/material.dart';

import '../../responsive/screen_util.dart';
import '../../theme/app_spacing.dart';
import '../app_icons.dart';

/// Centred empty-state placeholder: icon + title + optional subtitle +
/// optional action button. Copy is passed in by the caller (feature-agnostic
/// — no hardcoded strings), the icon defaults to the [AppIcons.empty] glyph.
///
/// Ported from `lib/presentation/common/widgets/empty_view.dart`; icon
/// swapped to [AppIcons], rewired to the core theme / responsive layer.
class EmptyView extends StatelessWidget {
  const EmptyView({
    required this.title,
    this.icon = AppIcons.empty,
    this.subtitle,
    this.actionLabel,
    this.onAction,
    super.key,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  static const double _iconSize = 64;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.xl.w,
          vertical: AppSpacing.xl.h,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              icon,
              size: _iconSize.r,
              color: scheme.onSurface.withValues(alpha: 0.3),
            ),
            SizedBox(height: AppSpacing.lg.h),
            Text(
              title,
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...<Widget>[
              SizedBox(height: AppSpacing.sm.h),
              Text(
                subtitle!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (onAction != null && actionLabel != null) ...<Widget>[
              SizedBox(height: AppSpacing.xl.h),
              FilledButton.tonal(
                onPressed: onAction,
                child: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

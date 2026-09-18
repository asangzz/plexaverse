import 'package:flutter/material.dart';

import '../../../l10n/gen/app_localizations.dart';
import '../../responsive/screen_util.dart';
import '../../theme/app_spacing.dart';
import '../app_icons.dart';

/// Centred inline error state with an optional retry button. The retry label
/// defaults to the localized "Retry" string.
///
/// Ported from `lib/presentation/common/widgets/error_view.dart`; the icon
/// swapped to [AppIcons], strings via `AppL10n.of(context)`. For the
/// full-screen offline / no-connectivity state prefer [NetworkErrorView].
class ErrorView extends StatelessWidget {
  const ErrorView({required this.message, this.onRetry, super.key});

  final String message;
  final VoidCallback? onRetry;

  static const double _iconSize = 64;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
              AppIcons.error,
              size: _iconSize.r,
              color: theme.colorScheme.error,
            ),
            SizedBox(height: AppSpacing.lg.h),
            Text(
              message,
              style: theme.textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...<Widget>[
              SizedBox(height: AppSpacing.xl.h),
              FilledButton.tonal(
                onPressed: onRetry,
                child: Text(AppL10n.of(context).retry),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

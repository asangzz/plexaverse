import 'package:flutter/material.dart';

import '../../../l10n/gen/app_localizations.dart';
import '../../responsive/screen_util.dart';
import '../../theme/app_spacing.dart';
import '../app_icons.dart';

/// The full-screen "network error / no connectivity" state for online-first
/// data screens whose load failed while offline.
///
/// A neutral surface-variant ring with a plug-off glyph (deliberately not
/// alarming), the copy, and a "Try again" primary button at 80% width. The
/// title is a live region so the error is announced when it appears.
///
/// Ported from the ProHealth reference
/// (`core/ui/widgets/network_error_view.dart`). ProHealth's dedicated
/// `networkErrorTitle/Body/Retry` ARB keys are not part of the finalized
/// Plexaverse l10n, so [title] / [body] / [retryLabel] are parameters: the
/// title defaults to the existing localized `networkError` string and the
/// retry to `retry`. Callers own the retry (typically re-firing the failed
/// load after `internetMonitorProvider.recheck()`).
class NetworkErrorView extends StatelessWidget {
  const NetworkErrorView({
    required this.onRetry,
    this.title,
    this.body,
    this.retryLabel,
    super.key,
  });

  final VoidCallback onRetry;
  final String? title;
  final String? body;
  final String? retryLabel;

  static const double _ringSize = 72;
  static const double _iconSize = 26;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l = AppL10n.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.lg.w,
        vertical: AppSpacing.xl.h,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: _ringSize.r,
              height: _ringSize.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: scheme.surfaceContainerHighest,
              ),
              // onSurfaceVariant, not outline: keeps the calm grey while
              // clearing the WCAG 3:1 graphics-contrast bar with margin.
              child: Icon(
                AppIcons.offline,
                size: _iconSize.r,
                color: scheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: AppSpacing.lg.h),
            Semantics(
              liveRegion: true,
              child: Text(
                title ?? l.networkError,
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleLarge,
              ),
            ),
            if (body != null) ...<Widget>[
              SizedBox(height: AppSpacing.sm.h),
              Text(
                body!,
                textAlign: TextAlign.center,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyLarge,
              ),
            ],
            SizedBox(height: AppSpacing.lg.h),
            FractionallySizedBox(
              widthFactor: 0.8,
              child: FilledButton(
                onPressed: onRetry,
                child: Text(retryLabel ?? l.retry),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

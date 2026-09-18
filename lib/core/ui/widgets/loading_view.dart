import 'package:flutter/material.dart';

import '../../../l10n/gen/app_localizations.dart';
import '../../responsive/screen_util.dart';
import '../../theme/app_spacing.dart';

/// Centred loading indicator with an optional caption. Defaults the caption
/// to the localized "Loading…" string.
///
/// Ported from `lib/presentation/common/widgets/loading_view.dart`; rewired
/// to `AppL10n.of(context)` (the finalized gen class) and the core theme /
/// responsive layer.
class LoadingView extends StatelessWidget {
  const LoadingView({this.message, super.key});

  final String? message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const CircularProgressIndicator(),
          SizedBox(height: AppSpacing.lg.h),
          Text(
            message ?? AppL10n.of(context).loading,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

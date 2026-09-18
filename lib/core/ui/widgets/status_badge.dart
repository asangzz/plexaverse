import 'package:flutter/material.dart';

import '../../responsive/screen_util.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/plexaverse_colors.dart';

/// Semantic intent of a [StatusBadge]. Drives the colour pairing only — the
/// label (and optional icon) are always supplied so status is communicated
/// by colour **and** text (the "colour never alone" accessibility rule),
/// never colour by itself.
enum StatusBadgeVariant { info, success, warning, neutral, solid }

/// A pill status chip: a 15%-opacity tint of the status colour behind an
/// icon + label in the full-strength colour.
///
/// Ported from the ProHealth reference (`core/ui/widgets/status_badge.dart`),
/// re-skinned to the Plexaverse brand status palette via [PlexaverseColors].
/// Replaces the ad-hoc `StatusBadge` that lived inside the legacy
/// `glass_card.dart` (that inline one is dropped from the glass-card port).
class StatusBadge extends StatelessWidget {
  const StatusBadge({
    required this.label,
    this.icon,
    this.variant = StatusBadgeVariant.neutral,
    super.key,
  });

  final String label;
  final IconData? icon;
  final StatusBadgeVariant variant;

  static const double _height = 28;
  static const double _iconSize = 15;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final brand = context.brand;

    final (Color bg, Color fg) = switch (variant) {
      StatusBadgeVariant.info => (brand.tint(brand.info), brand.info),
      StatusBadgeVariant.success => (brand.tint(brand.success), brand.success),
      StatusBadgeVariant.warning => (brand.tint(brand.warning), brand.warning),
      StatusBadgeVariant.neutral => (
        scheme.surfaceContainerHighest,
        scheme.onSurfaceVariant,
      ),
      StatusBadgeVariant.solid => (scheme.primary, scheme.onPrimary),
    };

    return Container(
      height: _height.h,
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md.w),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (icon != null) ...<Widget>[
            Icon(icon, size: _iconSize.r, color: fg),
            SizedBox(width: (AppSpacing.xs + 2).w),
          ],
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: fg,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

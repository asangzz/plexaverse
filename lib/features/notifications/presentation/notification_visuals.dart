import 'package:flutter/material.dart';

import '../../../core/theme/plexaverse_colors.dart';
import '../../../core/ui/app_icons.dart';
import '../domain/notification_models.dart';

/// The leading badge icon for a notification `type` (the persisted Drift
/// `type` literal, e.g. `post_published`). Decorative — the row's text
/// carries the meaning for screen readers.
IconData notificationIcon(String type) {
  return switch (NotificationCategoryX.fromWire(type)) {
    NotificationCategory.postPublished => AppIcons.odyssey,
    NotificationCategory.postScheduled => AppIcons.schedule,
    NotificationCategory.postFailed => AppIcons.error,
    NotificationCategory.missionComplete => AppIcons.trophy,
    NotificationCategory.xpEarned => AppIcons.bolt,
    NotificationCategory.analytics => AppIcons.insights,
    NotificationCategory.system => AppIcons.notifications,
  };
}

/// The tint colour for a notification `type`, sourced from the brand palette
/// (never a raw hex). `mission_complete` uses the brand gold accent.
Color notificationColor(BuildContext context, String type) {
  final brand = context.brand;
  final scheme = Theme.of(context).colorScheme;
  return switch (NotificationCategoryX.fromWire(type)) {
    NotificationCategory.postPublished => scheme.primary,
    NotificationCategory.postScheduled => brand.warning,
    NotificationCategory.postFailed => scheme.error,
    NotificationCategory.missionComplete => brand.warning,
    NotificationCategory.xpEarned => scheme.secondary,
    NotificationCategory.analytics => brand.info,
    NotificationCategory.system => scheme.onSurfaceVariant,
  };
}

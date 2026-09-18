import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/responsive/screen_util.dart';
import '../../../core/storage/app_database.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/plexaverse_colors.dart';
import '../application/notification_controllers.dart';
import 'notification_visuals.dart';

// ── Public helper ────────────────────────────────────────────────────────

/// Opens the end drawer that hosts [NotificationDrawer]. Call from a bell
/// button inside a `Scaffold` that declares `endDrawer: const NotificationDrawer()`.
void openNotificationDrawer(BuildContext context) {
  HapticFeedback.selectionClick();
  Scaffold.of(context).openEndDrawer();
}

// ── Drawer ─────────────────────────────────────────────────────────────────

/// The notification inbox drawer (Plexaverse product feature — RULINGS #15).
/// Reads the persisted Drift inbox via [notificationInboxProvider]; read /
/// mark-all-read / clear-all / swipe-to-delete all write straight through the
/// [NotificationDao]. Hooks removed (now a plain [ConsumerWidget]); brand
/// tokens read from the theme instead of raw `AppColors`.
class NotificationDrawer extends ConsumerWidget {
  const NotificationDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(notificationInboxProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final scheme = Theme.of(context).colorScheme;
    final brand = context.brand;
    final dao = ref.read(appDatabaseProvider).notificationDao;

    return Drawer(
      width: screenWidth * 0.8,
      backgroundColor: brand.canvas,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(left: Radius.circular(AppRadius.xxl.r)),
      ),
      child: Column(
        children: <Widget>[
          _DrawerHeader(
            onMarkAll: dao.markAllAsRead,
            onClearAll: dao.clearAll,
            onSimulate: kDebugMode
                ? () => ref
                    .read(notificationIngestorProvider.notifier)
                    .simulate()
                : null,
          ),
          Expanded(
            child: notificationsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, _) => Center(
                child: Text(
                  'Failed to load',
                  style: TextStyle(color: scheme.onSurfaceVariant),
                ),
              ),
              data: (items) => items.isEmpty
                  ? const _EmptyState()
                  : ListView.separated(
                      padding: EdgeInsets.symmetric(vertical: AppSpacing.sm.h),
                      itemCount: items.length,
                      separatorBuilder: (_, _) => Divider(
                        height: 1,
                        thickness: 0.5,
                        indent: AppSpacing.lg.w,
                        endIndent: AppSpacing.lg.w,
                        color: brand.divider,
                      ),
                      itemBuilder: (_, i) => _NotificationTile(
                        notification: items[i],
                        onRead: () => dao.markAsRead(items[i].id),
                        onDismiss: () => dao.deleteNotification(items[i].id),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Header ───────────────────────────────────────────────────────────────

class _DrawerHeader extends StatelessWidget {
  const _DrawerHeader({
    required this.onMarkAll,
    required this.onClearAll,
    this.onSimulate,
  });

  final VoidCallback onMarkAll;
  final VoidCallback onClearAll;

  /// Debug-only simulate action (null in release).
  final VoidCallback? onSimulate;

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final brand = context.brand;

    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.xl.w,
        topPad + AppSpacing.lg.h,
        AppSpacing.md.w,
        AppSpacing.md.h,
      ),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: brand.hairline, width: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                'Notifications',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: Icon(Icons.close_rounded, size: 20.r),
                color: scheme.onSurface.withValues(alpha: 0.5),
                onPressed: () => Navigator.of(context).pop(),
                tooltip: 'Close',
              ),
            ],
          ),
          SizedBox(height: AppSpacing.sm.h),
          Row(
            children: <Widget>[
              _HeaderAction(
                label: 'Mark all read',
                icon: Icons.done_all_rounded,
                onTap: onMarkAll,
              ),
              SizedBox(width: AppSpacing.sm.w),
              _HeaderAction(
                label: 'Clear all',
                icon: Icons.delete_sweep_rounded,
                color: scheme.error,
                onTap: onClearAll,
              ),
              if (onSimulate != null) ...<Widget>[
                SizedBox(width: AppSpacing.sm.w),
                _HeaderAction(
                  label: 'Simulate',
                  icon: Icons.science_rounded,
                  onTap: onSimulate!,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _HeaderAction extends StatelessWidget {
  const _HeaderAction({
    required this.label,
    required this.icon,
    required this.onTap,
    this.color,
  });

  final String label;
  final IconData icon;
  final Color? color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brand = context.brand;
    final fg = color ?? theme.colorScheme.onSurface.withValues(alpha: 0.7);

    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.sm.w + 2,
          vertical: AppSpacing.xs.h + 1,
        ),
        decoration: BoxDecoration(
          color: brand.glassFill,
          borderRadius: BorderRadius.circular(AppRadius.md.r),
          border: Border.all(color: brand.hairline),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(icon, size: 12.r, color: fg),
            SizedBox(width: AppSpacing.xs.w),
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: fg,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Notification tile ──────────────────────────────────────────────────────

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({
    required this.notification,
    required this.onRead,
    required this.onDismiss,
  });

  final NotificationsTableData notification;
  final VoidCallback onRead;
  final VoidCallback onDismiss;

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inDays < 1) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return DateFormat('MMM d').format(dt);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isUnread = !notification.isRead;
    final typeColor = notificationColor(context, notification.type);

    return Dismissible(
      key: ValueKey<int>(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: AppSpacing.xl.w),
        color: scheme.error.withValues(alpha: 0.85),
        child: Icon(Icons.delete_outline_rounded, color: scheme.onError, size: 22.r),
      ),
      onDismissed: (_) => onDismiss(),
      child: InkWell(
        onTap: isUnread ? onRead : null,
        child: Container(
          color: isUnread
              ? scheme.primary.withValues(alpha: 0.06)
              : Colors.transparent,
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.lg.w,
            vertical: AppSpacing.md.h,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Type icon badge.
              Container(
                width: 36.r,
                height: 36.r,
                decoration: BoxDecoration(
                  color: typeColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppRadius.md.r + 2),
                ),
                child: Center(
                  child: Icon(
                    notificationIcon(notification.type),
                    color: typeColor,
                    size: 18.r,
                  ),
                ),
              ),
              SizedBox(width: AppSpacing.md.w),
              // Content.
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            notification.title,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight:
                                  isUnread ? FontWeight.w700 : FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: AppSpacing.sm.w),
                        Text(
                          _formatTime(notification.receivedAt),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: scheme.onSurface.withValues(alpha: 0.4),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      notification.body,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: scheme.onSurface.withValues(alpha: 0.6),
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // Unread dot.
              if (isUnread) ...<Widget>[
                SizedBox(width: AppSpacing.sm.w),
                Container(
                  width: 7.r,
                  height: 7.r,
                  margin: EdgeInsets.only(top: AppSpacing.xs.h),
                  decoration: BoxDecoration(
                    color: scheme.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ── Empty state ──────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.xxl.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.notifications_none_rounded,
              size: 48.r,
              color: scheme.onSurface.withValues(alpha: 0.2),
            ),
            SizedBox(height: AppSpacing.lg.h),
            Text(
              'All caught up!',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: scheme.onSurface.withValues(alpha: 0.45),
              ),
            ),
            SizedBox(height: AppSpacing.xs.h + 2),
            Text(
              'Notifications will appear here when your posts go live '
              'or missions complete.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: scheme.onSurface.withValues(alpha: 0.35),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Bell icon with badge ────────────────────────────────────────────────────

/// Drop-in replacement for the bell `IconButton` in any app bar. Watches
/// [unreadNotificationCountProvider] and draws a badge; taps open the end
/// drawer.
class NotificationBellButton extends ConsumerWidget {
  const NotificationBellButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final countAsync = ref.watch(unreadNotificationCountProvider);
    final count = countAsync.maybeWhen(data: (c) => c, orElse: () => 0);

    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        IconButton(
          icon: Icon(
            count > 0
                ? Icons.notifications_rounded
                : Icons.notifications_none_rounded,
            size: 22.r,
          ),
          color: scheme.onSurface.withValues(alpha: 0.7),
          onPressed: () => openNotificationDrawer(context),
          tooltip: 'Notifications',
        ),
        if (count > 0)
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              width: 16.r,
              height: 16.r,
              decoration: BoxDecoration(
                color: scheme.error,
                shape: BoxShape.circle,
                border: Border.all(color: scheme.surface, width: 1.5),
              ),
              child: Center(
                child: Text(
                  count > 9 ? '9+' : '$count',
                  style: TextStyle(
                    color: scheme.onError,
                    fontSize: 8.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

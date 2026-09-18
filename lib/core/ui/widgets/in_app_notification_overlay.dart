import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../responsive/screen_util.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../app_icons.dart';
import '../motion/spring_press.dart';

/// A single in-app notification to surface as a foreground banner. Kept
/// deliberately small and presentation-only so it doesn't depend on the
/// notifications feature's domain model — feature code maps its own model
/// onto this before pushing.
@immutable
class InAppNotification {
  const InAppNotification({
    required this.id,
    required this.title,
    this.body,
    this.route,
  });

  /// Stable id so an [AnimatedSwitcher] can key the banner.
  final String id;
  final String title;
  final String? body;

  /// Optional deep-link route; tapping the banner invokes the overlay's
  /// `onOpen` with this value.
  final String? route;
}

/// A tiny FIFO queue of foreground notification banners. Feature code (FCM
/// foreground handler, in-app events) calls [show]; the overlay drains it.
///
/// This is the ProHealth "in-app notification overlay" pattern (RULINGS.md
/// #15) — a deliberate replacement for `flutter_local_notifications` in the
/// foreground. Background/system-tray delivery stays with FCM; persistence
/// to Drift (the inbox drawer) stays a product feature owned by the
/// notifications slice. This controller only governs the transient banner.
class InAppNotificationController extends Notifier<InAppNotification?> {
  final Queue<InAppNotification> _pending = Queue<InAppNotification>();

  @override
  InAppNotification? build() => null;

  /// Enqueue a banner. If one is already showing, it queues behind it.
  void show(InAppNotification notification) {
    if (state == null) {
      state = notification;
    } else {
      _pending.add(notification);
    }
  }

  /// Called by the overlay when the current banner finishes (auto-dismiss,
  /// swipe, or tap) to advance the queue.
  void dismissCurrent() {
    state = _pending.isEmpty ? null : _pending.removeFirst();
  }
}

/// The single app-wide in-app notification controller.
final inAppNotificationControllerProvider =
    NotifierProvider<InAppNotificationController, InAppNotification?>(
  InAppNotificationController.new,
);

/// Mounts a foreground notification banner above **every** route (wired once
/// in `PlexaverseApp` via `MaterialApp.builder`, alongside [OfflineOverlay]).
/// Watches [inAppNotificationControllerProvider]; when a banner is present it
/// slides in from the top, auto-dismisses after [_visibleFor], and can be
/// tapped (fires [onOpen] with the route) or swiped up to dismiss.
///
/// Honours Reduce Motion (Duration.zero switch, no slide). Announced via a
/// live region.
class InAppNotificationOverlay extends ConsumerStatefulWidget {
  const InAppNotificationOverlay({required this.child, this.onOpen, super.key});

  /// The navigator subtree handed to `MaterialApp.builder` (nullable there).
  final Widget? child;

  /// Invoked with the tapped notification's route (if any).
  final void Function(String route)? onOpen;

  @override
  ConsumerState<InAppNotificationOverlay> createState() =>
      _InAppNotificationOverlayState();
}

class _InAppNotificationOverlayState
    extends ConsumerState<InAppNotificationOverlay> {
  static const Duration _visibleFor = Duration(seconds: 4);
  Timer? _autoDismiss;
  String? _shownId;

  @override
  void dispose() {
    _autoDismiss?.cancel();
    super.dispose();
  }

  void _onNotificationChange(
    InAppNotification? previous,
    InAppNotification? next,
  ) {
    _autoDismiss?.cancel();
    if (next != null && next.id != _shownId) {
      _shownId = next.id;
      _autoDismiss = Timer(_visibleFor, _dismiss);
    } else if (next == null) {
      _shownId = null;
    }
  }

  void _dismiss() {
    _autoDismiss?.cancel();
    ref.read(inAppNotificationControllerProvider.notifier).dismissCurrent();
  }

  void _open(InAppNotification notification) {
    final route = notification.route;
    if (route != null && route.isNotEmpty) {
      widget.onOpen?.call(route);
    }
    _dismiss();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<InAppNotification?>(
      inAppNotificationControllerProvider,
      _onNotificationChange,
    );
    final notification = ref.watch(inAppNotificationControllerProvider);
    final reduceMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;

    return Stack(
      children: <Widget>[
        if (widget.child != null) widget.child!,
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SafeArea(
            bottom: false,
            child: AnimatedSwitcher(
              duration: reduceMotion
                  ? Duration.zero
                  : const Duration(milliseconds: 260),
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeIn,
              transitionBuilder: (child, animation) => SizeTransition(
                sizeFactor: animation,
                axisAlignment: -1,
                child: FadeTransition(opacity: animation, child: child),
              ),
              child: notification == null
                  ? const SizedBox.shrink(key: ValueKey<String>('none'))
                  : _NotificationBanner(
                      key: ValueKey<String>(notification.id),
                      notification: notification,
                      onTap: () => _open(notification),
                      onDismiss: _dismiss,
                    ),
            ),
          ),
        ),
      ],
    );
  }
}

class _NotificationBanner extends StatelessWidget {
  const _NotificationBanner({
    required this.notification,
    required this.onTap,
    required this.onDismiss,
    super.key,
  });

  final InAppNotification notification;
  final VoidCallback onTap;
  final VoidCallback onDismiss;

  static const double _iconSize = 20;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.md.w,
        AppSpacing.xs.h,
        AppSpacing.md.w,
        0,
      ),
      child: Dismissible(
        key: ValueKey<String>('dismiss-${notification.id}'),
        direction: DismissDirection.up,
        onDismissed: (_) => onDismiss(),
        child: SpringPress(
          child: Material(
            color: scheme.surface,
            elevation: 4,
            shadowColor: scheme.shadow,
            borderRadius: BorderRadius.circular(AppRadius.lg.r),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: onTap,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.md.w,
                  vertical: AppSpacing.md.h,
                ),
                child: Semantics(
                  liveRegion: true,
                  child: Row(
                    children: <Widget>[
                      Icon(
                        AppIcons.notifications,
                        size: _iconSize.r,
                        color: scheme.primary,
                      ),
                      SizedBox(width: AppSpacing.md.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              notification.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.titleSmall?.copyWith(
                                color: scheme.onSurface,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (notification.body != null &&
                                notification.body!.isNotEmpty) ...<Widget>[
                              SizedBox(height: AppSpacing.xxs.h),
                              Text(
                                notification.body!,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: scheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

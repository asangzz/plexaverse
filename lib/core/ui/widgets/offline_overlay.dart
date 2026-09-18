import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/gen/app_localizations.dart';
import '../../network/internet_monitor.dart';
import '../../responsive/screen_util.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../app_icons.dart';

/// Mounts the global connectivity pill above **every** route. Plexaverse is
/// online-first, so connectivity loss must be visible everywhere — this is
/// wired once in `PlexaverseApp` via `MaterialApp.router(builder: ...)`,
/// which places it above the navigator. Watching [internetMonitorProvider]
/// here also keeps the monitor alive from the first frame.
///
/// UX (the strip is interactive, not a permanent squatter):
///   - **Offline** → a floating pill: message + Retry + dismiss (×).
///   - **Retry** → "Checking…" spinner; on failure a brief "still offline".
///   - **Dismiss** → hides the pill for *this* offline episode only.
///   - **Recovery** → a transient "Back online" confirmation (~2.5s).
/// All transitions honour Reduce Motion and are announced via a live region.
///
/// Ported from the ProHealth reference (`core/ui/widgets/offline_overlay.dart`)
/// and wired to Plexaverse's [internetMonitorProvider] (same `InternetStatus`
/// API). ProHealth's `offlineBanner*` ARB keys are not in the finalized
/// Plexaverse l10n; the pill reuses the existing `networkError` / `retry`
/// keys and short literals for the transient states (TODO(l10n): promote to
/// ARB keys when the strings file gains them).
class OfflineOverlay extends ConsumerStatefulWidget {
  const OfflineOverlay({required this.child, super.key});

  /// The navigator subtree handed to `MaterialApp.builder` (nullable there).
  final Widget? child;

  @override
  ConsumerState<OfflineOverlay> createState() => _OfflineOverlayState();
}

class _OfflineOverlayState extends ConsumerState<OfflineOverlay> {
  static const Duration _backOnlineFlash = Duration(milliseconds: 2500);
  static const Duration _stillOfflineFlash = Duration(seconds: 2);

  bool _dismissed = false;
  bool _checking = false;
  bool _stillOffline = false;
  bool _backOnline = false;
  Timer? _flashTimer;
  Timer? _stillTimer;

  @override
  void dispose() {
    _flashTimer?.cancel();
    _stillTimer?.cancel();
    super.dispose();
  }

  void _onStatusChange(InternetStatus? previous, InternetStatus next) {
    final wasOffline = previous?.isOffline ?? false;
    if (wasOffline && !next.isOffline) {
      _stillTimer?.cancel();
      setState(() {
        _checking = false;
        _stillOffline = false;
        _backOnline = !_dismissed;
        _dismissed = false;
      });
      if (_backOnline) {
        _flashTimer?.cancel();
        _flashTimer = Timer(_backOnlineFlash, () {
          if (mounted) setState(() => _backOnline = false);
        });
      }
    } else if (!wasOffline && next.isOffline) {
      _flashTimer?.cancel();
      setState(() {
        _dismissed = false;
        _backOnline = false;
      });
    }
  }

  Future<void> _retry() async {
    if (_checking) return;
    _stillTimer?.cancel();
    setState(() {
      _checking = true;
      _stillOffline = false;
    });
    await ref.read(internetMonitorProvider.notifier).recheck();
    if (!mounted) return;
    final offline = ref.read(internetMonitorProvider).isOffline;
    setState(() {
      _checking = false;
      _stillOffline = offline;
    });
    if (offline) {
      _stillTimer = Timer(_stillOfflineFlash, () {
        if (mounted) setState(() => _stillOffline = false);
      });
    }
  }

  void _dismiss() {
    _stillTimer?.cancel();
    setState(() {
      _dismissed = true;
      _checking = false;
      _stillOffline = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<InternetStatus>(internetMonitorProvider, _onStatusChange);
    final offline = ref.watch(internetMonitorProvider).isOffline;
    final reduceMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;

    final Widget pill;
    if (_backOnline) {
      pill = const _BackOnlinePill(key: ValueKey<String>('back-online'));
    } else if (offline && !_dismissed) {
      pill = _OfflinePill(
        key: const ValueKey<String>('offline'),
        checking: _checking,
        stillOffline: _stillOffline,
        onRetry: _retry,
        onDismiss: _dismiss,
      );
    } else {
      pill = const SizedBox.shrink(key: ValueKey<String>('hidden'));
    }

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
                  : const Duration(milliseconds: 250),
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeIn,
              transitionBuilder: (widget, animation) => SizeTransition(
                sizeFactor: animation,
                axisAlignment: -1,
                child: FadeTransition(opacity: animation, child: widget),
              ),
              child: pill,
            ),
          ),
        ),
      ],
    );
  }
}

/// Shared floating-pill chrome: rounded, elevated, inset from the edges so it
/// reads as a transient surface rather than a permanent app bar.
class _PillSurface extends StatelessWidget {
  const _PillSurface({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.md.w,
        AppSpacing.xs.h,
        AppSpacing.md.w,
        0,
      ),
      child: Material(
        color: scheme.inverseSurface,
        elevation: 3,
        shadowColor: scheme.shadow,
        borderRadius: BorderRadius.circular(AppRadius.lg.r),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.md.w,
            vertical: AppSpacing.xs.h,
          ),
          child: Semantics(liveRegion: true, child: child),
        ),
      ),
    );
  }
}

/// Offline state: message + Retry + dismiss; swaps to a checking spinner or
/// the brief "still offline" feedback after a failed retry.
class _OfflinePill extends StatelessWidget {
  const _OfflinePill({
    required this.checking,
    required this.stillOffline,
    required this.onRetry,
    required this.onDismiss,
    super.key,
  });

  final bool checking;
  final bool stillOffline;
  final VoidCallback onRetry;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l = AppL10n.of(context);

    // TODO(l10n): promote the transient copy to ARB keys.
    final String message = checking
        ? 'Checking connection…'
        : stillOffline
            ? "Still offline. We'll keep trying."
            : l.networkError;

    return _PillSurface(
      child: Row(
        children: <Widget>[
          if (checking)
            SizedBox(
              width: 16.r,
              height: 16.r,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: scheme.onInverseSurface,
              ),
            )
          else
            Icon(
              AppIcons.offline,
              size: 14.r,
              color: scheme.onInverseSurface,
            ),
          SizedBox(width: AppSpacing.sm.w),
          Expanded(
            child: Text(
              message,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(
                color: scheme.onInverseSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (!checking) ...<Widget>[
            TextButton(
              onPressed: onRetry,
              style: TextButton.styleFrom(
                foregroundColor: scheme.inversePrimary,
                minimumSize: Size(48.w, 40.h),
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm.w),
              ),
              child: Text(
                l.retry,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: scheme.inversePrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            // Semantics label rather than tooltip: a tooltip needs an Overlay
            // ancestor, and this pill mounts ABOVE the navigator, where none
            // exists.
            Semantics(
              label: MaterialLocalizations.of(context).closeButtonLabel,
              button: true,
              child: IconButton(
                onPressed: onDismiss,
                visualDensity: VisualDensity.compact,
                icon: Icon(
                  AppIcons.close,
                  size: 14.r,
                  color: scheme.onInverseSurface,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Transient recovery confirmation — auto-dismissed by the overlay.
class _BackOnlinePill extends StatelessWidget {
  const _BackOnlinePill({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return _PillSurface(
      child: Row(
        children: <Widget>[
          Icon(
            AppIcons.checkCircle,
            size: 14.r,
            color: scheme.inversePrimary,
          ),
          SizedBox(width: AppSpacing.sm.w),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.sm.h),
              child: Text(
                // TODO(l10n): promote to an ARB key.
                'Back online',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: scheme.onInverseSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

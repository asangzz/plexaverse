import 'package:flutter/material.dart';

import '../../l10n/gen/app_localizations.dart';
import '../theme/zave/zave_colors.dart';
import '../responsive/screen_util.dart';
import '../theme/app_spacing.dart';

/// App-wide privacy mask (RULINGS §12 hardening). When the app leaves the
/// foreground (app-switcher preview, a system interruption, backgrounding),
/// this paints a full-screen branded cover over **every** route so on-screen
/// content (feed, DMs, analytics) isn't exposed in the task-switcher snapshot
/// or to a shoulder-surfer.
///
/// Wired once in `PlexaverseApp` via `MaterialApp.builder`, outermost so it
/// covers the offline pill and the in-app notification banner too. This is the
/// Flutter-level cover; sensitive routes additionally use [SecureScreen]
/// (FLAG_SECURE / iOS obscuring) for the native snapshot guarantee.
class PrivacyMaskOverlay extends StatefulWidget {
  const PrivacyMaskOverlay({required this.child, super.key});

  final Widget? child;

  @override
  State<PrivacyMaskOverlay> createState() => _PrivacyMaskOverlayState();
}

class _PrivacyMaskOverlayState extends State<PrivacyMaskOverlay>
    with WidgetsBindingObserver {
  bool _masked = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Mask whenever the app isn't fully foreground. `inactive` fires for the
    // app-switcher / transient interruptions; `paused`/`hidden` for true
    // background — covering all of them keeps the snapshot clean.
    final masked = state != AppLifecycleState.resumed;
    if (masked != _masked) setState(() => _masked = masked);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ?widget.child,
        if (_masked) const Positioned.fill(child: _PrivacyMask()),
      ],
    );
  }
}

class _PrivacyMask extends StatelessWidget {
  const _PrivacyMask();

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    return Semantics(
      label: l.appName,
      // Announce the cover the moment it appears (app backgrounded).
      liveRegion: true,
      // The app ground, NOT colorScheme.primary. Under Zave, `primary` is
      // solid white (Zave reserves white for the one primary action on a
      // screen), so painting the cover with it turned the whole mask into a
      // white sheet. A privacy cover wants the brand's dark surface.
      child: ColoredBox(
        color: ZaveColors.midnight,
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.xl.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  Icons.lock_outline,
                  size: 40.r,
                  color: ZaveColors.white,
                ),
                SizedBox(height: AppSpacing.md.h),
                Text(
                  l.appName,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: ZaveColors.white,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                SizedBox(height: AppSpacing.xs.h),
                Text(
                  // TODO(l10n): add a `privacyMaskMessage` ARB key and read it
                  // here (mirrors ProHealth's l.privacyMaskMessage). Kept as a
                  // literal until the l10n phase lands the key.
                  'Hidden while the app is in the background',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: ZaveColors.ink85,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

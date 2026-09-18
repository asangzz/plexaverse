import 'package:flutter/widgets.dart';

import 'screen_util.dart';

/// Root wrapper that feeds the live window size into [ScreenUtil] so the
/// `.w` / `.h` / `.r` / `.sp` extensions resolve correctly everywhere below
/// it. Drop it in at the app root and set the reference phone size:
///
/// ```dart
/// runApp(
///   ProviderScope(
///     child: const ScreenUtilInit(
///       designSize: Size(360, 760), // the Plexaverse hi-fi design frame
///       child: PlexaverseApp(),
///     ),
///   ),
/// );
/// ```
///
/// It reads the device's logical size from the root [FlutterView] (so it
/// works above `MaterialApp`, before any `MediaQuery` exists) and
/// re-configures [ScreenUtil] on every metrics change — rotation, window
/// resize, foldable posture, keyboard. Because it sits above `MaterialApp`,
/// it reconfigures *before* the screens below it rebuild off the changed
/// `MediaQuery`, so they always read fresh scale factors. The theme is
/// likewise rebuilt on metrics change so `.sp`-scaled text tracks.
///
/// Ported from the ProHealth reference (`core/responsive/screen_util_init.dart`).
class ScreenUtilInit extends StatefulWidget {
  const ScreenUtilInit({
    required this.child,
    this.designSize = ScreenUtil.defaultDesignSize,
    this.minTextScale = 0.85,
    this.maxTextScale = 1.15,
    super.key,
  });

  /// The app below the scaler (typically the `MaterialApp`).
  final Widget child;

  /// Reference frame the UI was designed against (hi-fi default `360 x 760`).
  final Size designSize;

  /// Lower / upper bound on the **device-derived** font scale applied by
  /// `.sp`. The user's OS text-size setting is layered on top by the
  /// framework and is *not* bounded by these (accessibility is preserved).
  final double minTextScale;
  final double maxTextScale;

  @override
  State<ScreenUtilInit> createState() => _ScreenUtilInitState();
}

class _ScreenUtilInitState extends State<ScreenUtilInit>
    with WidgetsBindingObserver {
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
  void didChangeMetrics() {
    // Window size / orientation / insets changed — rebuild so [configure]
    // re-runs with the new size before descendants repaint.
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final view = View.of(context);
    final logical = view.physicalSize / view.devicePixelRatio;
    // Before the first real frame the view size can be zero or non-finite;
    // fall back to the design size (scale 1.0) until metrics arrive.
    final screenSize = (logical.isFinite && !logical.isEmpty)
        ? logical
        : widget.designSize;

    ScreenUtil.I.configure(
      designSize: widget.designSize,
      screenSize: screenSize,
      minTextScale: widget.minTextScale,
      maxTextScale: widget.maxTextScale,
    );

    return widget.child;
  }
}

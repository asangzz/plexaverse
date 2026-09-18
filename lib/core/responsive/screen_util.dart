import 'dart:math' as math;

import 'package:flutter/widgets.dart';

/// A small, dependency-free responsive scaler so designs built against a
/// fixed reference phone render proportionally on every device.
///
/// The reference frame is the Plexaverse hi-fi design's phone (`360 x 760`);
/// see [defaultDesignSize]. [ScreenUtilInit] (in `screen_util_init.dart`)
/// wraps the app at the root, reads the live window size, and calls
/// [configure]. Call sites then scale values with the [ScreenUtilNumX]
/// extensions:
///
/// ```dart
/// SizedBox(height: 24.h);                 // vertical, scaled to height
/// Padding(padding: EdgeInsets.all(16.w)); // horizontal, scaled to width
/// BorderRadius.circular(12.r);            // radius, scaled to min(w,h)
/// Text('Hi', style: TextStyle(fontSize: 17.sp)); // font, see below
/// SizedBox(width: 0.5.sw);                // 50% of screen width
/// ```
///
/// ## Text & accessibility
///
/// `.sp` applies only the **device** width-scale, clamped to
/// `[minTextScale, maxTextScale]` (`[0.85, 1.15]`) so fonts never balloon
/// or collapse across phone sizes. It deliberately does **not** fold in the
/// user's OS text-size setting — Flutter's [MediaQuery.textScaler] still
/// applies that on top automatically, so Dynamic Type / large-text
/// accessibility keeps working. Folding the OS scale into `.sp` here would
/// double-count it.
///
/// Before [configure] runs (e.g. in a widget test with no [ScreenUtilInit]),
/// every scale factor is `1.0`, so the extensions are a safe pass-through
/// that returns the raw design value.
///
/// Ported from the ProHealth reference (`core/responsive/screen_util.dart`);
/// the design frame and clamp are identical (Plexaverse also lays out
/// against 360x760).
class ScreenUtil {
  ScreenUtil._();

  /// The single shared instance the [ScreenUtilNumX] extensions read.
  static final ScreenUtil instance = ScreenUtil._();

  /// Terse alias — `ScreenUtil.I`.
  static ScreenUtil get I => instance;

  /// The Plexaverse hi-fi design's reference phone frame.
  static const Size defaultDesignSize = Size(360, 760);

  Size _designSize = defaultDesignSize;
  double _screenWidth = defaultDesignSize.width;
  double _screenHeight = defaultDesignSize.height;
  double _minTextScale = 0.85;
  double _maxTextScale = 1.15;
  bool _ready = false;

  /// Called by [ScreenUtilInit] whenever the window size changes.
  /// [designSize] is the reference frame the UI was laid out against;
  /// [screenSize] is the device's current logical size; the text clamp
  /// bounds the device-derived font scale.
  void configure({
    required Size designSize,
    required Size screenSize,
    required double minTextScale,
    required double maxTextScale,
  }) {
    _designSize = designSize;
    _screenWidth = screenSize.width;
    _screenHeight = screenSize.height;
    _minTextScale = minTextScale;
    _maxTextScale = maxTextScale;
    _ready = true;
  }

  /// Whether [configure] has run. `false` ⇒ all scales are `1.0`.
  bool get isReady => _ready;

  /// Current device logical size.
  double get screenWidth => _screenWidth;
  double get screenHeight => _screenHeight;

  /// Reference frame the design was built against.
  Size get designSize => _designSize;

  /// Raw scale factors (`1.0` until [configure] runs).
  double get scaleWidth => _ready ? _screenWidth / _designSize.width : 1.0;
  double get scaleHeight => _ready ? _screenHeight / _designSize.height : 1.0;

  /// Radius/icon scale — the smaller of width/height so circles and
  /// corners stay round rather than stretching with the aspect ratio.
  double get scaleRadius => math.min(scaleWidth, scaleHeight);

  /// Device font scale — the width scale clamped to the configured bounds.
  /// The OS text-size setting is layered on top by the framework.
  double get scaleText => scaleWidth.clamp(_minTextScale, _maxTextScale);

  double setWidth(num value) => value * scaleWidth;
  double setHeight(num value) => value * scaleHeight;
  double setRadius(num value) => value * scaleRadius;
  double setSp(num value) => value * scaleText;
}

/// Scaling extensions on [num] — the `16.w` / `24.h` / `12.r` / `17.sp`
/// call-site API. See [ScreenUtil] for semantics.
extension ScreenUtilNumX on num {
  /// Width-proportional size (relative to the design width).
  double get w => ScreenUtil.I.setWidth(this);

  /// Height-proportional size (relative to the design height).
  double get h => ScreenUtil.I.setHeight(this);

  /// Radius / icon size — scaled by `min(scaleWidth, scaleHeight)`.
  double get r => ScreenUtil.I.setRadius(this);

  /// Font size — device width-scale (clamped to `[0.85, 1.15]`); OS Dynamic
  /// Type applies on top via the framework. See [ScreenUtil] "Text &
  /// accessibility".
  double get sp => ScreenUtil.I.setSp(this);

  /// Fraction of the screen width — `0.5.sw` is half the screen.
  double get sw => ScreenUtil.I.screenWidth * this;

  /// Fraction of the screen height — `0.25.sh` is a quarter of the screen.
  double get sh => ScreenUtil.I.screenHeight * this;
}

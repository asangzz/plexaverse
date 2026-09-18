import 'package:flutter/material.dart';

/// The eight wonders shown on the Global Timeline's wonder tracks.
///
/// Order and names ported verbatim from Wonderous's `WonderType` enum.
enum WonderType {
  chichenItza,
  christRedeemer,
  colosseum,
  greatWall,
  machuPicchu,
  petra,
  pyramidsGiza,
  tajMahal,
}

/// Colors for [WonderType], ported verbatim from Wonderous's
/// `wonders_color_extensions.dart`. `title` is NOT included here — display
/// titles come from the JSON fixture per-wonder (see [WonderMarker.title]),
/// not from a hardcoded switch.
extension WonderTypeX on WonderType {
  Color get bgColor {
    return switch (this) {
      WonderType.pyramidsGiza => const Color(0xFF16184D),
      WonderType.greatWall => const Color(0xFF642828),
      WonderType.petra => const Color(0xFF444B9B),
      WonderType.colosseum => const Color(0xFF1E736D),
      WonderType.chichenItza => const Color(0xFF164F2A),
      WonderType.machuPicchu => const Color(0xFF0E4064),
      WonderType.tajMahal => const Color(0xFFC96454),
      WonderType.christRedeemer => const Color(0xFF1C4D46),
    };
  }

  Color get fgColor {
    return switch (this) {
      WonderType.pyramidsGiza => const Color(0xFF444B9B),
      WonderType.greatWall => const Color(0xFF688750),
      WonderType.petra => const Color(0xFF1B1A65),
      WonderType.colosseum => const Color(0xFF4AA39D),
      WonderType.chichenItza => const Color(0xFFE2CFBB),
      WonderType.machuPicchu => const Color(0xFFC1D9D1),
      WonderType.tajMahal => const Color(0xFF642828),
      WonderType.christRedeemer => const Color(0xFFED7967),
    };
  }

  /// Maps the JSON fixture's `"type"` string (e.g. `"greatWall"`) to a
  /// [WonderType]. Throws [FormatException] on an unrecognised key.
  static WonderType fromJson(String key) {
    for (final type in WonderType.values) {
      if (type.name == key) return type;
    }
    throw FormatException('Unknown WonderType: $key');
  }
}

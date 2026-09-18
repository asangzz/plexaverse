/// Corner-radius scale. Widgets read from here rather than writing raw
/// numeric literals at call sites.
///
/// Ported 1:1 from the ProHealth reference (`core/theme/app_radius.dart`).
class AppRadius {
  const AppRadius._();

  static const double sm = 6;
  static const double md = 8;
  static const double lg = 12;
  static const double xl = 16;

  /// Extra-large container corner — M3's expressive large-surface radius
  /// (selectable cards, hero sheets).
  static const double xxl = 28;
  static const double pill = 999;
}

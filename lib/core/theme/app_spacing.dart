/// Spacing scale. Widgets read from here rather than writing raw numeric
/// literals at call sites, so the whole app's rhythm tunes in one place.
///
/// Ported 1:1 from the ProHealth reference (`core/theme/app_spacing.dart`) —
/// the token STRUCTURE is shared architecture; only colour/type VALUES are
/// Plexaverse-branded.
class AppSpacing {
  const AppSpacing._();

  static const double xxs = 2;
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 48;

  /// Minimum tap target (Material accessibility guidance).
  static const double minTapTarget = 48;
}

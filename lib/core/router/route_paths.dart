import 'zave_routes.dart';

/// The routes the guard in `redirect.dart` reasons about.
///
/// This is a thin facade over [ZaveRoutes], which is the full, web-aligned
/// route table. It exists so the redirect guard — which is well-tested and
/// deliberately pure — keeps naming the few semantic routes it cares about
/// (splash / onboarding / login / unlock / home) rather than hard-coding
/// paths, while there is still exactly ONE place a path is defined.
///
/// Note [home] is `/dashboard`, not `/home`: the app's landing route is the
/// web's, so a signed-in user and a deep link both resolve the same way on
/// both platforms.
class RoutePaths {
  const RoutePaths._();

  static const String splash = ZaveRoutes.splash;
  static const String onboarding = ZaveRoutes.onboarding;
  static const String login = ZaveRoutes.login;
  static const String unlock = ZaveRoutes.unlock;

  /// Post-auth landing. The web's `/dashboard`.
  static const String home = ZaveRoutes.dashboard;

  static const String styleguide = ZaveRoutes.styleguide;

  /// Routes reachable while signed out. A signed-in user navigating to one is
  /// sent to [home] instead.
  static const Set<String> preAuth = ZaveRoutes.preAuth;
}

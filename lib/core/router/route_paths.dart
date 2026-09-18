/// All route literals live here. Call sites read from this class — raw URL
/// literals at call sites are forbidden (ProHealth enforces this with a
/// `hardcoded_endpoint` lint; the convention is adopted here as-is, §14).
///
/// Pattern (from ProHealth `RoutePaths`): a private const ctor, `static const
/// String` for fixed paths, `static String fn(String id)` for parameterised
/// ones, plus the semantic [preAuth] set the guard uses to define the
/// signed-out surface.
///
/// Plexaverse route shape:
///   /            — cold-start splash while session + onboarding resolve
///   /onboarding  — first-run onboarding carousel (pre-auth gate)
///   /login       — auth entry point (dual-mode sign-in / create-account)
///   /unlock      — biometric re-auth gate for a locked signed-in session
///   /home        — post-auth landing, branch 0 of the three-tab shell
class RoutePaths {
  const RoutePaths._();

  /// Brand splash shown on cold start while the session, app-lock and
  /// onboarding state resolve; the redirect moves on to [onboarding],
  /// [login] or [home] once they do. No page-level navigation — the router
  /// redirect owns it.
  static const String splash = '/';

  /// First-run onboarding. Gated ahead of auth: until the user completes it
  /// they are held here (priority splash → onboarding → login/unlock → home).
  static const String onboarding = '/onboarding';

  /// Auth entry point — the dual-mode sign-in / create-account page.
  static const String login = '/login';

  /// Biometric / device-credential unlock gate. Shown over everything when a
  /// signed-in session is locked (app resumed from background, or relaunched
  /// after being killed). Root-navigator, full-screen.
  static const String unlock = '/unlock';

  /// Post-auth landing — branch 0 of the three-tab shell.
  static const String home = '/home';

  /// Tab branches 1–3 (HeyGen re-skin shell). Order MUST match the shell +
  /// bottom navigation: home 0 · videos 1 · avatars 2 · timeline 3.
  static const String videos = '/videos';
  static const String avatars = '/avatars';
  static const String timeline = '/timeline';

  /// Legacy five-tab branch paths. NO LONGER ROUTED (the HeyGen re-skin shell
  /// dropped these branches) but kept because unrouted feature code still
  /// references the constants.
  static const String posts = '/posts';
  static const String odyssey = '/odyssey';
  static const String analytics = '/analytics';
  static const String settings = '/settings';

  /// Post composer (create / edit / pre-scheduled). NO LONGER ROUTED — kept
  /// for unrouted feature code that references the constant.
  static const String createPost = '/posts/create';

  /// Content calendar. NO LONGER ROUTED — kept for unrouted feature code.
  static const String schedule = '/schedule';

  /// Creator studio. NO LONGER ROUTED — kept for unrouted feature code.
  static const String studio = '/studio';

  /// Account page (HeyGen re-skin, screenshot 2374) — a root-level
  /// full-screen route opened from the Home header gear; covers the tab bar.
  static const String account = '/account';

  /// Routes reachable while signed **out** (the pre-auth surface). A
  /// signed-in user navigating to any of these is sent home instead.
  /// Plexaverse's create-account flow lives inside the dual-mode [login]
  /// page, so the surface is a single route today. [onboarding] is NOT part
  /// of this set — it has its own gate ahead of the auth gate.
  static const Set<String> preAuth = <String>{login};

  /// Design-system style guide — a dev / design reference catalogue of the
  /// Plexaverse brand layer. Public (see the exemption in `redirect.dart`)
  /// so it can be opened directly without signing in.
  static const String styleguide = '/styleguide';
}

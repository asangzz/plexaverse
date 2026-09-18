/// All API endpoint paths live here. Call sites read from this — the
/// `hardcoded_endpoint` lint (§2.5) flags raw URL literals.
///
/// Paths use `static const` for fixed endpoints and
/// `static String Function(String id)` helpers for parameterised ones.
/// Feature agents ADD the endpoints their slice needs here; this file is
/// shared across the whole network layer. Only the auth/product paths the
/// current migration has confirmed are listed today — never inline a URL at
/// a call site.
class ApiPaths {
  const ApiPaths._();

  // Auth (§8) — only /auth/login and /auth/refresh are public.
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String refresh = '/auth/refresh';
  static const String logout = '/auth/logout';
  static const String me = '/auth/me';

  // LinkedIn OAuth hand-off (wrapped by the core web-auth adapter seam).
  static const String linkedInAuthUrl = '/linkedin/auth-url';
  static const String linkedInExchange = '/linkedin/exchange';

  // Home / dashboard
  static const String homeDashboard = '/home/dashboard';

  // Posts
  static const String posts = '/posts';
  static String postById(String id) => '/posts/$id';
  static String postSchedule(String id) => '/posts/$id/schedule';
  static String postPublish(String id) => '/posts/$id/publish';
  static String postRetry(String id) => '/posts/$id/retry';
  static String postMetrics(String id) => '/posts/$id/metrics';

  // Analytics
  static const String analytics = '/analytics';
  static const String analyticsRange = '/analytics/range';

  // Odyssey / gamification
  static const String odysseyStats = '/odyssey/stats';
  static const String odysseyMissions = '/odyssey/missions';
  static const String odysseyAwardXp = '/odyssey/xp';

  // Notifications (inbox — the push counterpart of FCM)
  static const String notifications = '/notifications';
  static const String notificationsReadAll = '/notifications/read-all';
  static String notificationRead(String id) => '/notifications/$id/read';

  // FCM device registration (idempotent on the server).
  static const String notificationDevices = '/notifications/devices';

  // Media — single multipart endpoint. Returns a canonical `id`.
  static const String media = '/media';
}

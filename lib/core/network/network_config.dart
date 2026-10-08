/// HTTP transport tunables. Values live here, never at call sites
/// (`hardcoded_endpoint` and friends — §2.5).
class NetworkConfig {
  const NetworkConfig._();

  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 60);

  /// What a request is given when the server's work is a model call.
  ///
  /// [receiveTimeout] bounds the wait for response HEADERS, so for a
  /// generation endpoint it is a budget for the whole server-side pipeline —
  /// and 30 seconds is less than the backend gives ITSELF. `/ai/poster` can
  /// reach `OPENAI_IMAGE_TIMEOUT_MS`, which is 90 seconds; `/ai/headshot` and
  /// `/ai/carousel` both declare `maxDuration = 60` with the note that image
  /// generation "can hit 30-45s on cold start". A 30-second client deadline
  /// over that is not a safety net, it is a coin toss, and the side it lands
  /// on is indistinguishable from being offline.
  ///
  /// This is why posters appeared not to generate on the phone while the same
  /// account generated them on the web: the web calls these endpoints with a
  /// plain `fetch` and no AbortSignal, so it simply waits.
  ///
  /// Two minutes, not sixty seconds: it has to exceed the longest budget the
  /// SERVER will spend before giving up, or the client still hangs up first
  /// and the user pays the XP for a poster they never see.
  static const Duration generationReceiveTimeout = Duration(minutes: 2);

  /// Path prefixes whose handler runs a model.
  ///
  /// Prefixes rather than a list of exact paths so a new AI route inherits the
  /// longer budget by default. Getting that wrong in this direction costs a
  /// slow request nothing; getting it wrong the other way is the bug above.
  static const List<String> _generationPrefixes = <String>[
    '/ai/',
    '/planner/generate',
    '/planner/regenerate',
    '/planner/article',
    '/planner/video-script',
    '/planner/newsletter',
    '/planner/change-topic',
    '/festive/generate',
    '/studio/ai-designer',
    '/studio/customize',
    '/persona/chat',
    '/persona/harvest',
    '/onboarding/derive-audience',
  ];

  /// Whether [path] is served by a model call and so needs
  /// [generationReceiveTimeout] rather than [receiveTimeout].
  static bool isGenerationPath(String path) {
    // Dio hands this the request path, which may be absolute when a call site
    // passes a full URL; matching on `contains` covers both without the
    // caller having to care.
    for (final String prefix in _generationPrefixes) {
      if (path.startsWith(prefix) || path.contains(prefix)) return true;
    }
    return false;
  }

  /// Inline retry after the first transient failure (§7.5).
  static const Duration retryAfter = Duration(seconds: 5);

  /// Maximum attempts on a single drain pass before deferring to the next
  /// connectivity transition. Transient retries are otherwise unbounded.
  static const int maxAttemptsPerDrain = 2;

  /// Image compression quality for upload (`flutter_image_compress`).
  static const int imageCompressionQuality = 85;
}

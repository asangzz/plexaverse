/// HTTP transport tunables. Values live here, never at call sites
/// (`hardcoded_endpoint` and friends — §2.5).
class NetworkConfig {
  const NetworkConfig._();

  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 60);

  /// Inline retry after the first transient failure (§7.5).
  static const Duration retryAfter = Duration(seconds: 5);

  /// Maximum attempts on a single drain pass before deferring to the next
  /// connectivity transition. Transient retries are otherwise unbounded.
  static const int maxAttemptsPerDrain = 2;

  /// Image compression quality for upload (`flutter_image_compress`).
  static const int imageCompressionQuality = 85;
}

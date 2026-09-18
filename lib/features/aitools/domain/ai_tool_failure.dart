/// The one exception every AI-tool call fails with.
///
/// The three screens in this slice (`/reimagine`, `/festive`, `/headshots`)
/// all talk to XP-gated endpoints, and all three of them have to tell the same
/// two stories apart:
///
///   • "that didn't work, try again"  → [message]
///   • "you don't have the XP"        → [insufficientXp]
///
/// The web handles this three different ways across the same three pages —
/// headshots opens `InsufficientXPModal`, festive renders an inline red box,
/// the AI Designer prints a chat bubble. One shape here, surfaced one way, is
/// the deliberate correction.
///
/// The mobile envelope reports the XP case as `error.code == 'INSUFFICIENT_XP'`
/// with a 402; it does NOT carry a structured `requiredXP` the way the web
/// route's body does, so the server's own message is what the user reads. That
/// message is more specific than anything this client could reconstruct.
class AiToolFailure implements Exception {
  const AiToolFailure(this.message, {this.insufficientXp = false, this.code});

  /// Safe to show the user.
  final String message;

  /// The server answered 402. The remedy is topping up, not retrying, so the
  /// UI must not offer a "Try again" button for this one.
  final bool insufficientXp;

  /// The envelope's stable `error.code`, for branching that outlives copy.
  final String? code;

  @override
  String toString() => 'AiToolFailure($code): $message';
}

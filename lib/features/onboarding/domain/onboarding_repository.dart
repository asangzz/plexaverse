import 'profession_analysis.dart';

export 'chat_message.dart';
export 'onboarding_answers.dart';
export 'onboarding_step.dart';
export 'profession_analysis.dart';

/// The one failure sentinel for this feature.
///
/// Following the convention of the other slices there is exactly ONE exception
/// type and no error taxonomy. [reason] is carried because the finish step
/// shows it to the user — the web's copy is `I hit a snag saving your setup
/// ({reason}).`, and a snag with no reason is a snag nobody can act on.
class OnboardingUnavailable implements Exception {
  const OnboardingUnavailable([this.reason]);

  final String? reason;

  @override
  String toString() => reason == null
      ? 'OnboardingUnavailable'
      : 'OnboardingUnavailable: $reason';
}

/// Seam between the onboarding chat and the backend.
///
/// Only [completeOnboarding] may throw. The other three are best-effort by
/// design and swallow their own failures, because each one improves the result
/// and none of them is worth stranding a user on a setup screen for:
///
///  * a failed profession analysis costs a prefilled industry;
///  * a failed style save costs the first few posts' voice, which the product
///    then picks up from the user's real posts anyway (the web says exactly
///    this to the user and advances regardless);
///  * a failed topic seed costs nothing the user can see today.
abstract class OnboardingRepository {
  /// `GET /auth/me` — the signed-in user's display name.
  ///
  /// The web reads this from the NextAuth session, which it already holds on
  /// the client; this app has only tokens, so the name is fetched. It is used
  /// for one thing — Plexa's greeting uses the user's first name — so a null
  /// return is fine and the greeting falls back to "there", exactly as the web
  /// does when the session carries no name.
  Future<String?> fetchDisplayName();

  /// `POST /ai/analyze-profession` — the role answer in, a profession and
  /// industry out. Returns null on any failure.
  Future<ProfessionAnalysis?> analyzeProfession(String headline);

  /// `POST /ai/style-memory` — embeds the writing sample so generation can
  /// retrieve it. Returns the failure reason, or null on success, so the caller
  /// can quote it in the chat the way the web does.
  Future<String?> saveStyleSample(String text);

  /// `PATCH /user/preferences` — the single write that ends onboarding.
  /// Throws [OnboardingUnavailable] on failure; this is the one call whose
  /// outcome the user has to see.
  Future<void> completeOnboarding(Map<String, dynamic> patch);

  /// `POST /ai/suggest-topics` — seeds the user's topics from the profile they
  /// just described.
  ///
  /// This stands in for the web's post-finalise fan-out (`init-week-plan`,
  /// `generate-roadmap`, `persona/harvest`, `derive-audience`), none of which
  /// exists on the mobile API. Like those, it is fire-and-forget and never
  /// blocks the redirect.
  Future<void> seedTopics();
}

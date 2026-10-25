import '../../../core/platform/file_picking.dart';
import '../../../core/platform/image_picking.dart';
import 'onboarding_answers.dart';
import 'onboarding_inputs.dart';

export 'chat_message.dart';
export 'onboarding_answers.dart';
export 'onboarding_inputs.dart';
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
/// Every call is one the web's `OnboardingChat` makes, against the mobile
/// twin of the same route.
///
/// The uploads ([parseCv], [parseCompanyDoc], [uploadLogo],
/// [analyzePosterStyle]) throw [OnboardingUnavailable] with the server's
/// reason, because the chat quotes it — "I couldn't read that one — {reason}"
/// — and offers another try. So does [completeOnboarding]. The rest are
/// best-effort and swallow their own failures: each improves the result, and
/// none is worth stranding a user on a setup screen for.
abstract class OnboardingRepository {
  /// `GET /auth/me` — the signed-in user's display name, for the greeting.
  /// Null falls back to "there", as the web does with no session name.
  Future<String?> fetchDisplayName();

  /// `POST /ai/parse-cv` — the LinkedIn profile PDF, read.
  Future<ParsedCv> parseCv(PickedFile pdf);

  /// `POST /ai/parse-company-doc` — a company document, read.
  Future<CompanyDoc> parseCompanyDoc(PickedFile pdf);

  /// `POST /upload/asset` with `kind=logo` — the company logo, stored without
  /// the lossy re-encode `/upload/image` applies, so it keeps its
  /// transparency. Returns the public URL.
  Future<String> uploadLogo(PickedFile image);

  /// `POST /ai/analyze-poster-style` — the theme and brand colours of a poster
  /// the company already made.
  Future<PosterStyle> analyzePosterStyle(PickedFile image);

  /// `POST /ai/analyze-style-screenshot` — the writing voice, read out of
  /// screenshots of the user's own posts. The server seeds the style memory
  /// from them. Null when nothing usable came back — a screenshot of
  /// something that is not a post is the ordinary case, not an error.
  Future<String?> analyzeStyleScreenshots(List<PickedImage> images);

  /// `POST /ai/style-memory` — the written sample, as the `baseline` voice.
  /// Returns the failure reason, or null on success, so the chat can quote it.
  Future<String?> saveStyleSample(String text);

  /// `GET /user/xp?include=history` — whether the one-time welcome bonus
  /// landed in the last two minutes, which is when the onboarding celebrates
  /// it. The server credits it on the first LinkedIn connect (a company
  /// brand: when its page is saved), so the answer changes mid-chat. False on
  /// any failure: a missed celebration costs nothing.
  Future<bool> hasFreshWelcomeBonus();

  /// `PATCH /user/preferences` — the single write that ends onboarding.
  /// Throws [OnboardingUnavailable] on failure; this is the one call whose
  /// outcome the user has to see.
  Future<void> completeOnboarding(Map<String, dynamic> patch);

  /// The post-finalise fan-out — the web's chain, in the web's order, because
  /// the order is load-bearing:
  ///
  ///   1. `POST /studio/brand-template` — company brand only: a poster
  ///      template built from the logo, theme and colours. Fire-and-forget.
  ///   2. `POST /persona/harvest` — seeds the Substance Bank from the CV, so
  ///      the first weeks are grounded in something real. Fire-and-forget.
  ///   3. `POST /onboarding/derive-audience` — **AWAITED**. Nobody is asked
  ///      who they want reading their posts, so the audience is inferred
  ///      here, and the next call plans week one by reading it. Fired
  ///      alongside init-week-plan instead, the race is lost about half the
  ///      time and week one is aimed at nobody.
  ///   4. `POST /ai/init-week-plan` — seeds week one.
  ///   5. `POST /ai/generate-roadmap` — builds the roadmap, which IS the home
  ///      screen.
  ///
  /// Every step swallows its own failure: none may block the handover.
  Future<void> seedAfterOnboarding(OnboardingAnswers answers);
}

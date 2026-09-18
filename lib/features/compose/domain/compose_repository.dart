import 'compose_context.dart';
import 'compose_draft.dart';
import 'compose_models.dart';

/// The one failure type this slice raises.
///
/// The codebase convention is that a repository catches wire-level exceptions
/// once, at the boundary, and translates them into a per-feature type — so the
/// application layer never sees a `DioException`, never branches on a status
/// code, and `package:dio` stays out of everything above `data/`.
///
/// [insufficientXp] is split out of [message] because the remedy is different
/// in kind. Every other failure here is "try again"; this one is "you cannot,
/// until you top up", and showing it as a retryable error would send the user
/// round a loop that cannot succeed.
class ComposeFailure implements Exception {
  const ComposeFailure(this.message, {this.insufficientXp = false, this.code});

  /// Safe to show the user. The server's own message when it sent one, because
  /// it is more specific than anything this client could guess.
  final String message;

  final bool insufficientXp;

  /// The envelope's stable `error.code`, for branching that outlives copy
  /// changes.
  final String? code;

  @override
  String toString() => 'ComposeFailure($code): $message';
}

/// The seam between the composer and the mobile API.
///
/// Every method maps to exactly one route in
/// `lib/core/network/api_paths.dart`. There are no invented paths here: where
/// the web composer calls something mobile does not expose (`/api/poster-tags`,
/// `/api/studio/templates`, `/api/studio/customize`, a voice-sample count),
/// there is deliberately no method and the UI says so out loud instead of
/// silently rendering a dead control.
abstract class ComposeRepository {
  /// `GET /user/preferences` + `GET /linkedin/accounts`, together.
  ///
  /// Fetched as one unit because the screen cannot render a correct connection
  /// panel from either half alone: "company brand" comes from preferences and
  /// "has a company connection" comes from the accounts list, and showing one
  /// before the other produces a panel that briefly tells the user the wrong
  /// thing about where their post is going.
  Future<ComposeContextState> fetchContext();

  /// `POST /ai/generate` — the post body, its visual category, and a poster
  /// headline, in one round-trip.
  Future<GeneratedPost> generatePost({
    required String topic,
    required ComposeTone tone,
    required ComposeLength length,
  });

  /// `POST /ai/poster` — the composited hero image, returned inline as a data
  /// URI.
  ///
  /// This is the route the web composer actually uses after `/ai/generate`
  /// (`POST /api/ai/poster`), not the plainer `/ai/image`. The difference is
  /// not cosmetic: `/ai/poster` composites the headline and the author badge
  /// onto the hero, which is what makes the output look like the product's
  /// posters rather than a stock illustration.
  Future<GeneratedPoster> generatePoster(PosterPrompt prompt);

  /// `POST /upload/image` with the `base64` form field — moves an inline
  /// poster into Supabase storage and compresses it for the LinkedIn feed.
  Future<UploadedImage> uploadBase64Image(String dataUri);

  /// `POST /posts`.
  ///
  /// [status] is `'draft'` or `'pending_approval'`; the second one is what
  /// starts the Slack approval flow server-side. The client never sets
  /// `'published'` — publishing is the server's job.
  Future<CreatedPost> createPost({
    required String content,
    required String status,
    String? title,
    String? imageUrl,
    String? imageThumbUrl,
    String? accountId,
    DateTime? scheduledFor,
  });

  /// `POST /linkedin/company-post` — push a post to the company page now.
  ///
  /// Only reachable in company mode. [postId] is the row `createPost` just
  /// returned; passing it is what lets the server flip that row to `published`
  /// instead of leaving a draft behind next to a live LinkedIn post.
  Future<CompanyPublishResult> publishCompanyPost({
    required String content,
    required String organizationId,
    String? imageUrl,
    String? postId,
  });
}

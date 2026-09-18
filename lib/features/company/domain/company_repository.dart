import 'advocacy_post.dart';
import 'banner_template.dart';
import 'company_analytics.dart';
import 'company_post.dart';
import 'inbox_comment.dart';

/// Why a company surface cannot render.
///
/// These are PRECONDITIONS, not errors: the request was well-formed and the
/// token was fine, the user simply has not connected something yet. The server
/// is explicit about this — it returns 400 rather than 401 for exactly this
/// reason, so the client routes the user to a connect screen instead of
/// bouncing them to login through the 401 refresh path.
enum CompanyPrecondition {
  /// No COMPANY LinkedIn account connected.
  noCompanyAccount,

  /// Connected, but no Company Page id saved yet.
  pageUnlinked,

  /// No PERSONAL LinkedIn account — reshare publishes to the user's own feed,
  /// which is a different connection from the company one.
  noPersonalAccount,

  /// LinkedIn itself refused (502 UPSTREAM_FAILED). Retrying may help.
  upstreamRefused,
}

/// Thrown by [CompanyRepository] when a company surface cannot proceed.
///
/// The repository translates the wire failure ONCE, here, so no screen reads a
/// status code or pattern-matches a server string. Screens switch on
/// [reason] and are a compile error away from handling a new one.
class CompanyUnavailable implements Exception {
  const CompanyUnavailable(this.reason, [this.message]);

  final CompanyPrecondition reason;

  /// The server's own sentence, when it sent one. Shown verbatim under the
  /// headline — it is more specific than anything we could write here.
  final String? message;

  @override
  String toString() => 'CompanyUnavailable($reason): ${message ?? ''}';
}

/// Everything the company-brand surfaces read and write.
///
/// One repository rather than four, because these are one subject — the user's
/// connected LinkedIn Company Page — and every method fails on the same two
/// preconditions. Splitting them would mean four copies of the same
/// [CompanyUnavailable] translation.
abstract class CompanyRepository {
  /// Follower + page statistics. Both halves are best-effort server-side, so a
  /// success can still carry nulls — see [CompanyAnalytics].
  ///
  /// [forceRefresh] bypasses the server's 24-hour cache and hits LinkedIn
  /// live. It is slow and rate-limited, so it must only ever be user-triggered
  /// (the Refresh button, pull-to-refresh) — never on mount.
  Future<CompanyAnalytics> fetchAnalytics({bool forceRefresh});

  /// The ten most recent company posts, with stats and advocacy state.
  Future<List<CompanyPostItem>> fetchPosts({bool forceRefresh});

  /// Outstanding inbound comments on one post, each with an AI-drafted reply.
  /// Comments already replied to are filtered out server-side.
  Future<List<InboxComment>> fetchComments(String postUrn);

  /// Posts a batch of replies as the company. Keyed comment URN → reply body.
  ///
  /// Returns one outcome per entry: the batch does NOT abort on a bad reply,
  /// so a partial failure has to be reported as a partial failure.
  Future<List<ReplyOutcome>> replyToComments(Map<String, String> replies);

  /// Reacts to one comment as the company.
  ///
  /// Returns true when LinkedIn answered "already reacted" (409). That is a
  /// successful no-op, not an error — it is what a tap-and-come-back looks
  /// like — and the UI says so rather than flashing a failure.
  Future<bool> reactToComment({
    required String commentUrn,
    required CommentReaction reaction,
  });

  /// Toggles the local "featured for advocacy" flag on a post.
  ///
  /// No LinkedIn call happens: advocacy is Plexaverse state that surfaces the
  /// post on the team feed. Returns the flag the server stored.
  Future<bool> setAdvocacy({
    required String postId,
    required bool isAdvocated,
    int? expiryDays,
  });

  /// The global advocacy feed — every unexpired featured post, across the team.
  Future<List<AdvocacyPost>> fetchAdvocacyFeed();

  /// Reshares a featured post to the user's PERSONAL feed. Returns the XP
  /// awarded. Throws [CompanyPrecondition.noPersonalAccount] when the personal
  /// profile is not connected.
  Future<int> reshare({required String postUrn, required String commentary});

  /// The saved Company Page id, or null when the user has not linked one.
  ///
  /// Only the already-saved / auto-discovered page is read here; this
  /// deliberately does not offer the manual-entry path, which belongs to the
  /// company-post setup screen that owns that write.
  Future<String?> fetchCompanyPageId();

  /// Studio templates in the `banner` category, WITH their design blobs.
  Future<List<BannerTemplate>> fetchBannerTemplates();

  /// Replaces the company page's cover image with the rendered banner.
  /// Returns the page URL the server reports on success.
  Future<String> applyCompanyBanner({
    required String organizationId,
    required String imageBase64,
    required int imageWidth,
    required int imageHeight,
  });
}

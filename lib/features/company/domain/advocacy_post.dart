import 'package:freezed_annotation/freezed_annotation.dart';

part 'advocacy_post.freezed.dart';
part 'advocacy_post.g.dart';

/// The LinkedIn account a featured post was published from.
@freezed
abstract class AdvocacyAccount with _$AdvocacyAccount {
  const factory AdvocacyAccount({
    @Default('') String profileName,
    String? profileImage,
    String? profileSlug,
  }) = _AdvocacyAccount;

  factory AdvocacyAccount.fromJson(Map<String, dynamic> json) =>
      _$AdvocacyAccountFromJson(json);
}

/// Our own stored metrics for a published post (`post_metrics`).
///
/// Distinct from `CompanyPostStats`: those come live from LinkedIn's share
/// statistics, these are the snapshot we last persisted. The advocacy feed
/// reads OUR row because it lists posts across the whole team, including ones
/// this user's company token cannot query.
@freezed
abstract class AdvocacyMetrics with _$AdvocacyMetrics {
  const factory AdvocacyMetrics({
    @Default(0) int impressions,
    @Default(0) int clicks,
    @Default(0) int comments,
    @Default(0) int shares,
    @Default(0) int reactions,
  }) = _AdvocacyMetrics;

  factory AdvocacyMetrics.fromJson(Map<String, dynamic> json) =>
      _$AdvocacyMetricsFromJson(json);
}

/// One post featured for employee advocacy.
///
/// **The feed is global on purpose.** `listAdvocatedPosts()` filters on
/// `isAdvocated` and expiry only — not on user — so every teammate sees the
/// same set to amplify. That is the whole point of the surface.
///
/// The mobile route returns the raw row, which means the field names differ
/// from the web page's: the body is `content` (not `text`) and the numbers are
/// `metrics.impressions` / `metrics.comments` (not `stats.*`). The web page
/// reads the names its own web route maps to; reading them here would render
/// an empty card on every row.
@freezed
abstract class AdvocacyPost with _$AdvocacyPost {
  const AdvocacyPost._();

  const factory AdvocacyPost({
    required String id,
    @Default('') String content,

    /// The LinkedIn URN. Resharing needs it, and a row without one cannot be
    /// amplified — see [canReshare].
    String? linkedinPostId,
    String? linkedinUrl,
    String? publishedAt,
    @Default(false) bool isAdvocated,
    String? advocacyExpiry,
    AdvocacyAccount? account,
    AdvocacyMetrics? metrics,
  }) = _AdvocacyPost;

  factory AdvocacyPost.fromJson(Map<String, dynamic> json) =>
      _$AdvocacyPostFromJson(json);

  /// The web labels impressions "Reach" and comments "Inquiries" — a B2B
  /// reading of the same two numbers. Kept, because the labels are the copy.
  int get reach => metrics?.impressions ?? 0;
  int get inquiries => metrics?.comments ?? 0;

  String get companyName {
    final String name = account?.profileName.trim() ?? '';
    return name.isEmpty ? 'Company Page' : name;
  }

  /// A stub advocacy row (created by advocate-before-publish) has no URN yet.
  /// Resharing one would 400, so the card disables its action instead.
  bool get canReshare =>
      linkedinPostId != null && linkedinPostId!.trim().isNotEmpty;
}

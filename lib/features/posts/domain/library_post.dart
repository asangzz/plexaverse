import 'package:freezed_annotation/freezed_annotation.dart';

part 'library_post.freezed.dart';
part 'library_post.g.dart';

/// Where a post is in its life, as the SERVER reports it.
///
/// These are the `Post.status` strings the web's `statusConfig` keys on in
/// `app/(dashboard)/posts/page.tsx` plus the two the calendar's `STATUS_META`
/// adds (`scheduled`, `failed`). The column is a free-text string server-side,
/// so the parse is deliberately tolerant: an unrecognised value falls back to
/// [draft], which is exactly what the web does (its `statusConfig[...]` lookup
/// misses and it renders the grey/neutral treatment).
///
/// This is NOT the same enum as the Drift mirror's old `PostStatus`. That one
/// describes the OFFLINE Drift mirror, which only ever holds four states. This
/// one is the server's vocabulary, and the two must not be conflated — the
/// server's `pending_approval` and `approved` have no Drift equivalent and are
/// precisely the states the library screen exists to let the user resolve.
enum PostLibraryStatus {
  @JsonValue('draft')
  draft,

  /// Written, waiting on the user (or Slack) to approve it.
  @JsonValue('pending_approval')
  pendingApproval,

  /// Approved — Cloud Tasks will publish it.
  @JsonValue('approved')
  approved,

  /// Has a `scheduledFor` and is queued.
  @JsonValue('scheduled')
  scheduled,

  /// Live on LinkedIn.
  @JsonValue('published')
  published,

  @JsonValue('rejected')
  rejected,

  /// The publish attempt failed. `Post.failureReason` records why (not exposed
  /// on the mobile API yet — see the summary).
  @JsonValue('failed')
  failed;

  /// The exact string the API expects back in a `?status=` filter or a PATCH.
  String get wire => switch (this) {
    PostLibraryStatus.draft => 'draft',
    PostLibraryStatus.pendingApproval => 'pending_approval',
    PostLibraryStatus.approved => 'approved',
    PostLibraryStatus.scheduled => 'scheduled',
    PostLibraryStatus.published => 'published',
    PostLibraryStatus.rejected => 'rejected',
    PostLibraryStatus.failed => 'failed',
  };

  /// The inverse of [wire] — a wire string back to the enum.
  ///
  /// Unknown strings fall to [draft] rather than throwing. A status this
  /// client has not been taught yet must not take a whole list down; the row
  /// still renders and the user can still open it.
  static PostLibraryStatus fromWire(Object? value) => switch (value) {
    'draft' => PostLibraryStatus.draft,
    'pending_approval' => PostLibraryStatus.pendingApproval,
    'approved' => PostLibraryStatus.approved,
    'scheduled' => PostLibraryStatus.scheduled,
    'published' => PostLibraryStatus.published,
    'rejected' => PostLibraryStatus.rejected,
    'failed' => PostLibraryStatus.failed,
    _ => PostLibraryStatus.draft,
  };

  /// The label the web prints in the status pill.
  String get label => switch (this) {
    PostLibraryStatus.draft => 'Draft',
    PostLibraryStatus.pendingApproval => 'Pending',
    PostLibraryStatus.approved => 'Approved',
    PostLibraryStatus.scheduled => 'Scheduled',
    PostLibraryStatus.published => 'Published',
    PostLibraryStatus.rejected => 'Rejected',
    PostLibraryStatus.failed => 'Failed',
  };
}

/// Engagement counters for a post.
///
/// `reactions` is only populated by the detail endpoint — the list endpoint's
/// `select` deliberately omits it to keep the row narrow, so it is 0 in a list
/// payload and the list must not claim to show reactions.
@freezed
abstract class PostMetrics with _$PostMetrics {
  const factory PostMetrics({
    @Default(0) int impressions,
    @Default(0) int comments,
    @Default(0) int shares,
    @Default(0) int reactions,
  }) = _PostMetrics;

  factory PostMetrics.fromJson(Map<String, dynamic> json) =>
      _$PostMetricsFromJson(json);
}

/// The LinkedIn account a post belongs to. Detail payload only.
@freezed
abstract class PostAuthor with _$PostAuthor {
  const factory PostAuthor({required String id, String? profileName}) =
      _PostAuthor;

  factory PostAuthor.fromJson(Map<String, dynamic> json) =>
      _$PostAuthorFromJson(json);
}

/// A post as the mobile API serves it — `ListedPost` / `DetailedPost` in
/// `lib/services/post.service.ts`.
///
/// **[id] is the server id (a cuid).** It is never the local Drift
/// autoincrement the deleted Drift mirror carried. Every `/posts/{id}` route keys on
/// this value, and interpolating the local int is what made every publish,
/// schedule and retry 404 in the previous version of this app. The two models
/// are kept apart precisely so the wrong id cannot be passed by accident: there
/// is no conversion between them anywhere in this slice.
@freezed
abstract class LibraryPost with _$LibraryPost {
  const LibraryPost._();

  const factory LibraryPost({
    required String id,
    String? title,
    @Default('') String content,
    String? imageUrl,

    /// The ~5–15 KB thumbnail the upload pipeline writes. Prefer it in a list;
    /// a library of 50 rows must not pull 50 LinkedIn-sized artifacts.
    String? imageThumbUrl,
    @Default(<String>[]) List<String> imageUrls,
    @JsonKey(unknownEnumValue: PostLibraryStatus.draft)
    @Default(PostLibraryStatus.draft)
    PostLibraryStatus status,
    String? linkedinUrl,
    required DateTime createdAt,
    DateTime? updatedAt,
    DateTime? publishedAt,
    DateTime? scheduledFor,
    PostMetrics? metrics,

    /// Detail payload only.
    PostAuthor? account,
  }) = _LibraryPost;

  factory LibraryPost.fromJson(Map<String, dynamic> json) =>
      _$LibraryPostFromJson(json);

  /// `getPostTitle` on the web: the title, else the first 60 characters of the
  /// body, else a placeholder. Reproduced exactly, including the ellipsis.
  String get displayTitle {
    final String? t = title;
    if (t != null && t.trim().isNotEmpty) return t;
    if (content.trim().isEmpty) return 'Untitled Post';
    return content.length > 60 ? '${content.substring(0, 60)}...' : content;
  }

  /// `getDisplayDate` on the web.
  ///
  /// A post that is going out later shows WHEN it goes out, not when it was
  /// written — the creation date is always the day before and reading it as the
  /// publish date is the confusion this rule exists to remove.
  DateTime get displayDate =>
      (scheduledFor != null && status != PostLibraryStatus.published)
      ? scheduledFor!
      : createdAt;

  /// `getPostImageSrc` on the web: thumbnail → full image → first carousel
  /// slide. Data URLs are included, because posts generated before the Supabase
  /// upload pipeline was wired into Cloud Tasks store base64 in `imageUrl`.
  String? get imageSrc {
    if (imageThumbUrl != null && imageThumbUrl!.isNotEmpty) {
      return imageThumbUrl;
    }
    if (imageUrl != null && imageUrl!.isNotEmpty) return imageUrl;
    return imageUrls.isNotEmpty ? imageUrls.first : null;
  }

  /// Every image this post carries, whether it came from the carousel array or
  /// the single-image column.
  List<String> get allImages {
    if (imageUrls.isNotEmpty) return imageUrls;
    final String? single = imageUrl;
    return (single != null && single.isNotEmpty)
        ? <String>[single]
        : const <String>[];
  }

  bool get isPublished => status == PostLibraryStatus.published;

  /// The web shows Approve for anything not already published or approved.
  bool get canApprove =>
      status != PostLibraryStatus.published &&
      status != PostLibraryStatus.approved;

  /// Approved and waiting on the scheduler — the web's "✓ Ready" badge.
  bool get isReady => status == PostLibraryStatus.approved;

  /// Whether the user has to do something about this one before it can go out.
  bool get needsAttention =>
      status == PostLibraryStatus.pendingApproval ||
      status == PostLibraryStatus.failed ||
      status == PostLibraryStatus.rejected;
}

/// One page of the library.
///
/// The server paginates by keyset: [nextCursor] is the id of the last post in
/// this window, and the next request asks for posts created before it.
@freezed
abstract class PostPage with _$PostPage {
  const factory PostPage({
    @Default(<LibraryPost>[]) List<LibraryPost> posts,
    String? nextCursor,
    @Default(false) bool hasMore,
  }) = _PostPage;
}

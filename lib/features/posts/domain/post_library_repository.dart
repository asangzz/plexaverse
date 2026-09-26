import 'library_post.dart';

export 'library_post.dart';

/// How many posts one page asks for.
///
/// The web's `useInfinitePosts` uses 10. A phone row is taller than a web row
/// but a phone scroll is longer, and 10 would put a "Load more" after barely
/// two screens, so this asks for 20. The server defaults to 50 and caps at 100.
/// Five, matching the feed endpoint's own default.
///
/// The list shows two-and-a-bit rows on a phone, so a page fills the viewport
/// and leaves one to scroll into — which is what starts the next fetch before
/// the reader reaches the end rather than after.
const int kPostPageLimit = 5;

/// The seam between the post-library screens and the mobile API.
///
/// This is a SECOND posts seam, alongside the offline-first [PostsRepository]
/// in `posts_repository.dart`, and the split is deliberate rather than
/// accidental duplication:
///
///   • [PostsRepository] is the Drift-backed offline mirror. It is keyed by a
///     local autoincrement, its reads are streams, and its writes go through
///     the sync queue. It exists so a draft survives an aeroplane.
///   • [PostLibraryRepository] is the server's view of the library — the web's
///     `/posts` and `/posts/[id]`. It is keyed by the SERVER id, its reads are
///     paginated futures, and its writes are immediate API calls whose result
///     the user is waiting on (approve, publish, delete).
///
/// Mixing them is what broke the previous version: the local int was
/// interpolated into `/posts/{id}/publish` and every publish 404ed. Keeping two
/// types with two id spaces makes that mistake un-typable.
///
/// Failures are NOT collapsed into a feature sentinel here. `DioClient` already
/// maps the `{data, error, meta}` envelope onto a typed `Failure`, and the
/// controllers surface it through `AsyncValue.error` — wrapping it would throw
/// away the distinction between "you are offline" and "LinkedIn rejected this",
/// which the detail screen needs in order to say something true.
abstract class PostLibraryRepository {
  /// One page of the library, newest first.
  ///
  /// [status] is the exact wire string (`PostLibraryStatus.wire`); null means
  /// no filter. [cursor] is the id of the last post of the previous page.
  Future<PostPage> fetchPage({
    String? status,
    String? cursor,
    int limit = kPostPageLimit,
  });

  /// A single post, with its account and reaction count.
  Future<LibraryPost> fetchOne(String id);

  /// Writes a new post — `POST /posts`.
  ///
  /// Included here so the library owns every verb its own resource exposes,
  /// even though the LIBRARY screen never calls it: composing is a different
  /// screen. The server runs the full side-effect chain on create (Slack
  /// approval when [status] is `pending_approval`, Cloud Tasks scheduling when
  /// [scheduledFor] is set, Calendar sync), which is exactly why a client must
  /// not build a post by PATCHing an empty draft into shape.
  Future<LibraryPost> create({
    required String content,
    String? title,
    DateTime? scheduledFor,
    PostLibraryStatus status = PostLibraryStatus.draft,
  });

  /// Partial update. Only non-null arguments are sent — the API's PATCH merges
  /// what it receives, so a field we did not mean to touch must not appear in
  /// the body at all.
  ///
  /// [scheduledFor] and [clearSchedule] are separate because `null` is a
  /// meaningful value for that field: passing it clears the schedule, and
  /// "leave it alone" and "unschedule this" cannot both be expressed by one
  /// nullable parameter.
  Future<LibraryPost> update(
    String id, {
    String? title,
    String? content,
    PostLibraryStatus? status,
    DateTime? scheduledFor,
    bool clearSchedule = false,
  });

  /// Publish to LinkedIn now. Returns the share URL when the server reports
  /// one; null when it does not (a poll, or an older account without one).
  Future<String?> publish(String id);

  Future<void> delete(String id);
}

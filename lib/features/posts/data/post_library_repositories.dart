import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/env.dart';
import '../../../core/network/api_paths.dart';
import '../../../core/network/dio_client.dart';
// `post_library_repository.dart` re-exports `library_post.dart`, so the
// entities come in with the interface.
import '../domain/post_library_repository.dart';

/// Dio-backed [PostLibraryRepository] — the real mobile API.
///
/// [DioClient] unwraps the `{data, error, meta}` envelope, so on success
/// `response.data` is the inner payload: a `List` for the collection, a `Map`
/// for a single post.
class ApiPostLibraryRepository implements PostLibraryRepository {
  const ApiPostLibraryRepository(this._client);

  final DioClient _client;

  @override
  Future<PostPage> fetchPage({
    String? status,
    String? cursor,
    int limit = kPostPageLimit,
  }) async {
    // `/posts/feed`, not `/posts`.
    //
    // `/posts` carries `imageUrl`, which on the live table averages 252 KB a
    // row because 152 of 324 posts hold a base64 `data:` image inline. A
    // five-row page measured 1,686,633 bytes there and 2,416 bytes here. On a
    // phone that difference IS the wall clock — a hundred-row page of the old
    // endpoint took 45 seconds and 18 MB, which is how the calendar tab came
    // to exceed a 30-second receive timeout.
    final response = await _client.get<dynamic>(
      ApiPaths.postsFeed,
      queryParameters: <String, dynamic>{
        'limit': limit,
        'status': ?status,
        'cursor': ?cursor,
      },
    );

    final dynamic data = response.data;
    if (data is! List) return const PostPage();

    final List<LibraryPost> posts = <LibraryPost>[
      for (final dynamic row in data)
        if (row is Map<String, dynamic>) _summaryOf(row),
    ];

    // Read from the envelope's `meta`, not derived from the window.
    //
    // This used to guess: a full window meant "probably more", and the cursor
    // was assumed to be the last row's id. That cost one wasted request at
    // the end of every scroll whose total was an exact multiple of the page
    // size, and the note here said to ask for meta pass-through if it ever
    // mattered. It exists — `DioClient` stashes the envelope's meta in
    // `extra` before the payload replaces it — so the server's own answer is
    // used and the guess is gone.
    final Object? page = DioClient.envelopeMeta(response)?['pagination'];
    if (page is Map) {
      return PostPage(
        posts: posts,
        nextCursor: page['cursor'] as String?,
        hasMore: page['hasMore'] == true,
      );
    }

    // No meta — an older server. Fall back to the old guess rather than
    // stopping the list dead at the first page.
    final bool hasMore = posts.length >= limit;
    return PostPage(
      posts: posts,
      nextCursor: hasMore && posts.isNotEmpty ? posts.last.id : null,
      hasMore: hasMore,
    );
  }

  /// One feed row as a [LibraryPost].
  ///
  /// Hand-written rather than `LibraryPost.fromJson`: the feed's field names
  /// are deliberately not the full post's. `excerpt` is not `content` and
  /// `thumbUrl` is not `imageThumbUrl`, because they do not hold the same
  /// thing — the excerpt is truncated server-side and the thumbnail is
  /// guaranteed never to be a `data:` URL. Mapping them through `fromJson`
  /// would have meant naming them alike, and then nothing would stop the full
  /// payload flowing back into the list.
  ///
  /// **`content` here is a PREVIEW.** Anything needing the whole body opens
  /// the post, which fetches it by id. Every list row is a summary.
  LibraryPost _summaryOf(Map<String, dynamic> row) {
    DateTime? when(Object? value) =>
        value is String ? DateTime.tryParse(value) : null;

    return LibraryPost(
      id: row['id'] as String? ?? '',
      title: row['title'] as String?,
      content: row['excerpt'] as String? ?? '',
      imageThumbUrl: row['thumbUrl'] as String?,
      status: PostLibraryStatus.fromWire(row['status']),
      // Null on everything unpublished, which is what hides the row's
      // "View on LinkedIn". The feed carries it because the web's list shows
      // that link too; it is a ~70-byte share URL, not a payload risk.
      linkedinUrl: row['linkedinUrl'] as String?,
      createdAt: when(row['createdAt']) ?? DateTime.now(),
      publishedAt: when(row['publishedAt']),
      scheduledFor: when(row['scheduledFor']),
    );
  }

  @override
  Future<LibraryPost> fetchOne(String id) async {
    final response = await _client.get<Map<String, dynamic>>(ApiPaths.post(id));
    final Map<String, dynamic>? data = response.data;
    if (data == null) throw StateError('posts/$id returned no body');
    return LibraryPost.fromJson(data);
  }

  @override
  Future<LibraryPost> create({
    required String content,
    String? title,
    DateTime? scheduledFor,
    PostLibraryStatus status = PostLibraryStatus.draft,
  }) async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiPaths.posts,
      data: <String, dynamic>{
        'content': content,
        'title': ?title,
        'status': status.wire,
        if (scheduledFor != null)
          'scheduledFor': scheduledFor.toUtc().toIso8601String(),
      },
    );
    final Map<String, dynamic>? data = response.data;
    if (data == null) throw StateError('posts POST returned no body');
    return LibraryPost.fromJson(data);
  }

  @override
  Future<LibraryPost> update(
    String id, {
    String? title,
    String? content,
    PostLibraryStatus? status,
    DateTime? scheduledFor,
    bool clearSchedule = false,
  }) async {
    final Map<String, dynamic> body = <String, dynamic>{
      'title': ?title,
      'content': ?content,
      'status': ?status?.wire,
    };

    // `scheduledFor` is the one field where null is a VALUE (it unschedules)
    // rather than "unchanged", so it is set explicitly rather than folded into
    // the literal above — the API's PATCH merges only the keys it receives.
    //
    // Explicit UTC, not the web's naive `2026-09-18T09:00:00`. That string is
    // parsed by `new Date()` in the SERVER's timezone, which is a different
    // instant from the one the user picked unless the two happen to agree. A
    // phone knows its own offset, so it sends something unambiguous.
    if (clearSchedule) {
      body['scheduledFor'] = null;
    } else if (scheduledFor != null) {
      body['scheduledFor'] = scheduledFor.toUtc().toIso8601String();
    }

    final response = await _client.patch<Map<String, dynamic>>(
      ApiPaths.post(id),
      data: body,
    );
    final Map<String, dynamic>? data = response.data;
    if (data == null) throw StateError('posts/$id PATCH returned no body');
    return LibraryPost.fromJson(data);
  }

  @override
  Future<String?> publish(String id) async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiPaths.postPublish(id),
    );
    return response.data?['linkedinUrl'] as String?;
  }

  @override
  Future<void> delete(String id) =>
      _client.delete<Map<String, dynamic>>(ApiPaths.post(id));
}

/// In-memory [PostLibraryRepository] for the `mock` flavor.
///
/// Seeded so that every state the screen can render is reachable without a
/// server: one published post with metrics, one approved, one awaiting
/// approval, one plain draft, one scheduled and one failed. A mock that only
/// produces happy rows is how the failed/needs-attention treatment goes
/// unreviewed until a user hits it.
class FakePostLibraryRepository implements PostLibraryRepository {
  FakePostLibraryRepository();

  static final DateTime _now = DateTime.now();

  final List<LibraryPost> _posts = <LibraryPost>[
    LibraryPost(
      id: 'mock-post-1',
      title: 'The first week decides the year',
      content:
          'Most teams treat onboarding as a documentation exercise. Write '
          'enough down, the thinking goes, and a new joiner will find their '
          'way.\n\nIt does not work, and the reason is not effort.\n\n'
          'The first week is where someone decides whether this place is '
          'organised or improvised, and no amount of documentation written '
          'afterwards changes that first read.',
      status: PostLibraryStatus.published,
      linkedinUrl: 'https://www.linkedin.com/feed/update/urn:li:share:mock1',
      createdAt: _now.subtract(const Duration(days: 3)),
      publishedAt: _now.subtract(const Duration(days: 3)),
      metrics: const PostMetrics(
        impressions: 4821,
        comments: 37,
        shares: 9,
        reactions: 214,
      ),
      account: const PostAuthor(id: 'mock-acct', profileName: 'Asang Borkar'),
    ),
    LibraryPost(
      id: 'mock-post-2',
      title: 'Three onboarding metrics nobody tracks',
      content:
          'Time-to-first-commit is the only onboarding metric most teams '
          'measure, and it is the least interesting of the three.',
      status: PostLibraryStatus.approved,
      createdAt: _now.subtract(const Duration(days: 1)),
      scheduledFor: _now.add(const Duration(hours: 18)),
    ),
    LibraryPost(
      id: 'mock-post-3',
      title: 'What a good day one actually looks like',
      content:
          'A good first day has exactly one goal, and it is not to explain '
          'the architecture.',
      status: PostLibraryStatus.pendingApproval,
      createdAt: _now.subtract(const Duration(hours: 6)),
      scheduledFor: _now.add(const Duration(days: 1, hours: 3)),
    ),
    LibraryPost(
      id: 'mock-post-4',
      content:
          'Rough note: the handover problem is really a documentation-ownership '
          'problem. Nobody owns the handover, so nobody improves it.',
      status: PostLibraryStatus.draft,
      createdAt: _now.subtract(const Duration(hours: 2)),
    ),
    LibraryPost(
      id: 'mock-post-5',
      title: 'A checklist you can steal',
      content: 'Seven things to do before a new joiner opens their laptop.',
      status: PostLibraryStatus.failed,
      createdAt: _now.subtract(const Duration(days: 5)),
    ),
  ];

  @override
  Future<PostPage> fetchPage({
    String? status,
    String? cursor,
    int limit = kPostPageLimit,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    final List<LibraryPost> filtered = status == null
        ? _posts
        : _posts
              .where((LibraryPost p) => p.status.wire == status)
              .toList(growable: false);
    // Real cursor pagination over the fixture.
    //
    // This used to ignore `limit` and treat ANY cursor as the end of the
    // list, so the library always had exactly one short page: infinite scroll
    // never fired a second request, and an off-by-one or a cursor that failed
    // to advance — the two ways paging actually breaks — could not happen in
    // mock. The server pages on (createdAt, id) and over-fetches by one to
    // decide `hasMore`; this does the same on id alone, which is enough
    // because the fixture is already in order.
    int start = 0;
    if (cursor != null) {
      final int at = filtered.indexWhere((LibraryPost p) => p.id == cursor);
      // A cursor naming a post that has since been filtered out or deleted is
      // the end of the list, not the beginning of it again.
      if (at < 0) return const PostPage();
      start = at + 1;
    }

    final List<LibraryPost> window = filtered.skip(start).take(limit).toList();
    final bool hasMore = start + window.length < filtered.length;

    return PostPage(
      posts: window,
      nextCursor: hasMore ? window.last.id : null,
      hasMore: hasMore,
    );
  }

  @override
  Future<LibraryPost> fetchOne(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return _posts.firstWhere(
      (LibraryPost p) => p.id == id,
      orElse: () => throw StateError('mock post $id not found'),
    );
  }

  @override
  Future<LibraryPost> create({
    required String content,
    String? title,
    DateTime? scheduledFor,
    PostLibraryStatus status = PostLibraryStatus.draft,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    final LibraryPost created = LibraryPost(
      id: 'mock-post-${DateTime.now().microsecondsSinceEpoch}',
      title: title,
      content: content,
      status: status,
      scheduledFor: scheduledFor,
      createdAt: DateTime.now(),
    );
    _posts.insert(0, created);
    return created;
  }

  @override
  Future<LibraryPost> update(
    String id, {
    String? title,
    String? content,
    PostLibraryStatus? status,
    DateTime? scheduledFor,
    bool clearSchedule = false,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    final int index = _posts.indexWhere((LibraryPost p) => p.id == id);
    if (index < 0) throw StateError('mock post $id not found');
    final LibraryPost updated = _posts[index].copyWith(
      title: title ?? _posts[index].title,
      content: content ?? _posts[index].content,
      status: status ?? _posts[index].status,
      scheduledFor: clearSchedule
          ? null
          : (scheduledFor ?? _posts[index].scheduledFor),
    );
    _posts[index] = updated;
    return updated;
  }

  @override
  Future<String?> publish(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    final int index = _posts.indexWhere((LibraryPost p) => p.id == id);
    if (index < 0) throw StateError('mock post $id not found');
    _posts[index] = _posts[index].copyWith(
      status: PostLibraryStatus.published,
      publishedAt: DateTime.now(),
      scheduledFor: null,
      linkedinUrl: 'https://www.linkedin.com/feed/update/urn:li:share:$id',
    );
    return _posts[index].linkedinUrl;
  }

  @override
  Future<void> delete(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    _posts.removeWhere((LibraryPost p) => p.id == id);
  }
}

/// Mock ↔ real switch on `useFakeBackend`. A release build can never resolve
/// the fake — the assert mirrors every other slice.
final Provider<PostLibraryRepository> postLibraryRepositoryProvider =
    Provider<PostLibraryRepository>((Ref ref) {
      final bool useFake = ref.watch(useFakeBackendProvider);
      assert(
        !(kReleaseMode && useFake),
        'useFakeBackend must be false in release builds.',
      );
      if (useFake && !kReleaseMode) return FakePostLibraryRepository();
      return ApiPostLibraryRepository(ref.watch(dioClientProvider));
    });

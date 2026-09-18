import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/post_library_repositories.dart';
import '../domain/post_library_repository.dart';

part 'post_library_controllers.freezed.dart';
part 'post_library_controllers.g.dart';

/// The library's status tabs.
///
/// These are the web's five tabs verbatim — `['All','Published','Pending',
/// 'Draft','Rejected']` — and they map onto the same server-side `?status=`
/// filter, so the two platforms show the same rows for the same tab.
///
/// Note what is NOT here: `approved`, `scheduled` and `failed` have no tab on
/// the web either. They are still reachable under "All" and still get their own
/// signal colour on the card; adding tabs the web does not have would make the
/// two libraries disagree about what a filter means.
enum PostLibraryFilter {
  all('All', null),
  published('Published', PostLibraryStatus.published),
  pending('Pending', PostLibraryStatus.pendingApproval),
  draft('Draft', PostLibraryStatus.draft),
  rejected('Rejected', PostLibraryStatus.rejected);

  const PostLibraryFilter(this.label, this.status);

  final String label;

  /// Null for [all] — no `?status=` parameter at all.
  final PostLibraryStatus? status;
}

/// The whole library as the screen sees it: every page loaded so far, plus
/// enough bookkeeping to render "Load more" and per-row busy states.
@freezed
abstract class PostLibraryState with _$PostLibraryState {
  const PostLibraryState._();

  const factory PostLibraryState({
    @Default(<LibraryPost>[]) List<LibraryPost> posts,
    String? nextCursor,
    @Default(false) bool hasMore,
    @Default(false) bool loadingMore,

    /// Server ids with a mutation in flight. Per-id rather than a single
    /// boolean because the list shows an Approve button on every row, and one
    /// global flag would spin all of them for a tap on one.
    @Default(<String>{}) Set<String> busyIds,
  }) = _PostLibraryState;

  bool isBusy(String id) => busyIds.contains(id);
}

/// Which tab is selected. UI state, so it lives in its own tiny notifier and
/// [PostLibrary] watches it — selecting a tab re-runs the server-side filter
/// rather than filtering a list the client already has.
@riverpod
class PostFilter extends _$PostFilter {
  @override
  PostLibraryFilter build() => PostLibraryFilter.all;

  void select(PostLibraryFilter next) {
    if (state != next) state = next;
  }
}

/// The post library — the web's `/posts`.
///
/// Reads are paginated futures off the mobile API, NOT the Drift stream the
/// rest of this feature uses. The library is the server's list: it has to show
/// posts this device never created (the auto-post chain writes most of them),
/// and a local mirror would show a user an empty library on a fresh install.
@riverpod
class PostLibrary extends _$PostLibrary {
  @override
  Future<PostLibraryState> build() async {
    final PostLibraryFilter filter = ref.watch(postFilterProvider);
    final PostPage page = await ref
        .watch(postLibraryRepositoryProvider)
        .fetchPage(status: filter.status?.wire);
    return PostLibraryState(
      posts: page.posts,
      nextCursor: page.nextCursor,
      hasMore: page.hasMore,
    );
  }

  /// Appends the next page. A no-op while one is already in flight or when the
  /// server has told us there is nothing after this.
  Future<void> loadMore() async {
    final PostLibraryState? current = state.value;
    if (current == null ||
        current.loadingMore ||
        !current.hasMore ||
        current.nextCursor == null) {
      return;
    }

    state = AsyncData<PostLibraryState>(current.copyWith(loadingMore: true));

    try {
      final PostPage page = await ref
          .read(postLibraryRepositoryProvider)
          .fetchPage(
            status: ref.read(postFilterProvider).status?.wire,
            cursor: current.nextCursor,
          );
      state = AsyncData<PostLibraryState>(
        current.copyWith(
          posts: <LibraryPost>[...current.posts, ...page.posts],
          nextCursor: page.nextCursor,
          hasMore: page.hasMore,
          loadingMore: false,
        ),
      );
    } on Object {
      // Keep what we already have and drop the spinner. A failed "load more"
      // must not throw away the pages the user is already reading.
      state = AsyncData<PostLibraryState>(
        current.copyWith(loadingMore: false, hasMore: false),
      );
    }
  }

  /// Approve — `PATCH /posts/{id} {status:'approved'}`.
  ///
  /// The single most-tapped action in the library, so it is optimistic: the row
  /// flips immediately and is reconciled from the server's response. A
  /// round-trip of dead UI here reads as a broken button.
  Future<void> approve(String id) => _mutate(
    id,
    (PostLibraryRepository repo) =>
        repo.update(id, status: PostLibraryStatus.approved),
    optimistic: (LibraryPost p) =>
        p.copyWith(status: PostLibraryStatus.approved),
  );

  /// Publish now — `POST /posts/{id}/publish`. Returns the LinkedIn share URL
  /// when the server reports one, so the caller can offer it.
  ///
  /// NOT optimistic: publishing can fail at LinkedIn for reasons we cannot
  /// predict (a revoked token, a rejected asset), and a row that says
  /// "Published" when nothing reached LinkedIn is the one lie this screen must
  /// never tell.
  Future<String?> publish(String id) async {
    final PostLibraryState? current = state.value;
    if (current == null) return null;

    state = AsyncData<PostLibraryState>(current.copyWith(busyIds: _with(id)));
    try {
      final String? url = await ref
          .read(postLibraryRepositoryProvider)
          .publish(id);
      final LibraryPost fresh = await ref
          .read(postLibraryRepositoryProvider)
          .fetchOne(id);
      state = AsyncData<PostLibraryState>(
        _replace(current, fresh).copyWith(busyIds: _without(id)),
      );
      return url;
    } on Object {
      state = AsyncData<PostLibraryState>(
        current.copyWith(busyIds: _without(id)),
      );
      rethrow;
    }
  }

  /// Delete — `DELETE /posts/{id}`.
  ///
  /// Optimistic removal with a restore on failure, matching the web's
  /// `useDeletePost`: the row leaves the list at once and comes back if the
  /// server refuses.
  Future<void> delete(String id) async {
    final PostLibraryState? current = state.value;
    if (current == null) return;

    state = AsyncData<PostLibraryState>(
      current.copyWith(
        posts: current.posts
            .where((LibraryPost p) => p.id != id)
            .toList(growable: false),
      ),
    );

    try {
      await ref.read(postLibraryRepositoryProvider).delete(id);
    } on Object {
      state = AsyncData<PostLibraryState>(current);
      rethrow;
    }
  }

  /// Drops a row the DETAIL screen has already deleted server-side.
  ///
  /// Separate from [delete] on purpose: [delete] also calls the API, and the
  /// detail screen has already done that. Reusing it there would issue a second
  /// DELETE for a post that no longer exists and surface the 404 as a failure.
  void removeLocally(String id) {
    final PostLibraryState? current = state.value;
    if (current == null) return;
    state = AsyncData<PostLibraryState>(
      current.copyWith(
        posts: current.posts
            .where((LibraryPost p) => p.id != id)
            .toList(growable: false),
      ),
    );
  }

  /// Folds a post the detail screen has just changed back into the list, so
  /// popping back does not show a stale row while a refetch runs.
  void mergeUpdated(LibraryPost post) {
    final PostLibraryState? current = state.value;
    if (current == null) return;
    if (!current.posts.any((LibraryPost p) => p.id == post.id)) return;
    state = AsyncData<PostLibraryState>(_replace(current, post));
  }

  Future<void> _mutate(
    String id,
    Future<LibraryPost> Function(PostLibraryRepository repo) call, {
    LibraryPost Function(LibraryPost post)? optimistic,
  }) async {
    final PostLibraryState? current = state.value;
    if (current == null) return;

    PostLibraryState next = current.copyWith(busyIds: _with(id));
    if (optimistic != null) {
      next = next.copyWith(
        posts: next.posts
            .map((LibraryPost p) => p.id == id ? optimistic(p) : p)
            .toList(growable: false),
      );
    }
    state = AsyncData<PostLibraryState>(next);

    try {
      final LibraryPost updated = await call(
        ref.read(postLibraryRepositoryProvider),
      );
      state = AsyncData<PostLibraryState>(
        _replace(next, updated).copyWith(busyIds: _without(id)),
      );
    } on Object {
      // Put the server's truth back. A failed approve that still looks
      // approved is worse than one that visibly did not take.
      state = AsyncData<PostLibraryState>(
        current.copyWith(busyIds: _without(id)),
      );
      rethrow;
    }
  }

  PostLibraryState _replace(PostLibraryState from, LibraryPost post) =>
      from.copyWith(
        posts: from.posts
            .map((LibraryPost p) => p.id == post.id ? post : p)
            .toList(growable: false),
      );

  Set<String> _with(String id) => <String>{...?state.value?.busyIds, id};

  Set<String> _without(String id) => <String>{
    for (final String each in state.value?.busyIds ?? const <String>{})
      if (each != id) each,
  };
}

/// One post — the web's `/posts/[id]`.
///
/// Keyed by the SERVER id. There is no variant that takes the local Drift row
/// id, deliberately: the detail screen's publish button is exactly where the
/// wrong id used to produce a silent 404.
@riverpod
class PostDetail extends _$PostDetail {
  @override
  Future<LibraryPost> build(String postId) =>
      ref.watch(postLibraryRepositoryProvider).fetchOne(postId);

  Future<void> approve() => _apply(
    (PostLibraryRepository repo) =>
        repo.update(postId, status: PostLibraryStatus.approved),
  );

  /// Saves the edited body, optionally moving the post to another status.
  ///
  /// [status] is how "Save as draft" works on the web (`handleSave('draft')`);
  /// omitting it leaves the status exactly as it was. The web also saves an
  /// image from here — a phone cannot yet, see the screen's doc comment.
  Future<void> save({
    String? title,
    required String content,
    PostLibraryStatus? status,
  }) => _apply(
    (PostLibraryRepository repo) =>
        repo.update(postId, title: title, content: content, status: status),
  );

  /// Sets or clears the scheduled time.
  ///
  /// Passing null unschedules. That is a real PATCH with an explicit null body
  /// value, not an omitted field — see [PostLibraryRepository.update].
  Future<void> setSchedule(DateTime? at) => _apply(
    (PostLibraryRepository repo) =>
        repo.update(postId, scheduledFor: at, clearSchedule: at == null),
  );

  /// Publish to LinkedIn now. Returns the share URL when there is one.
  Future<String?> publish() async {
    final String? url = await ref
        .read(postLibraryRepositoryProvider)
        .publish(postId);
    final LibraryPost fresh = await ref
        .read(postLibraryRepositoryProvider)
        .fetchOne(postId);
    state = AsyncData<LibraryPost>(fresh);
    ref.read(postLibraryProvider.notifier).mergeUpdated(fresh);
    return url;
  }

  Future<void> delete() async {
    await ref.read(postLibraryRepositoryProvider).delete(postId);
    ref.read(postLibraryProvider.notifier).removeLocally(postId);
  }

  Future<void> _apply(
    Future<LibraryPost> Function(PostLibraryRepository repo) call,
  ) async {
    final LibraryPost updated = await call(
      ref.read(postLibraryRepositoryProvider),
    );
    state = AsyncData<LibraryPost>(updated);
    // Keep the list behind this screen honest without a refetch.
    ref.read(postLibraryProvider.notifier).mergeUpdated(updated);
  }
}

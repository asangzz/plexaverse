import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/company_repositories.dart';
import '../domain/advocacy_post.dart';
import '../domain/company_analytics.dart';
import '../domain/company_post.dart';
import '../domain/company_repository.dart';
import '../domain/inbox_comment.dart';

part 'company_controllers.freezed.dart';
part 'company_controllers.g.dart';

// The company surfaces are FOUR SCREENS OVER ONE SUBJECT, and they are
// modelled as independent providers for the same reason the settings screen
// is: the analytics page must not go blank because the (slow, separately
// cached) posts call is still in flight, and the inbox must not refetch
// analytics it never renders.
//
// Two of these providers are shared across screens by design —
// [CompanyPostsController] backs both Analytics' "Recent Post Performance"
// grid and the Inbox's post list, which is exactly what the web's shared
// `useCompanyPosts()` query does. The LinkedIn call behind it is slow enough
// that fetching it twice is visible.

/// Company page follower + page statistics.
@riverpod
class CompanyAnalyticsController extends _$CompanyAnalyticsController {
  @override
  Future<CompanyAnalytics> build() =>
      ref.watch(companyRepositoryProvider).fetchAnalytics();

  /// Bypasses the server's 24-hour cache and re-reads LinkedIn live.
  ///
  /// Only ever called from an explicit user gesture. On mount the cached read
  /// is used — the web learned this the expensive way, having once hit the
  /// live LinkedIn endpoint on every single navigation to the screen.
  /// Drops to a loading state rather than holding the stale numbers behind a
  /// spinner. Riverpod's `copyWithPrevious` — which would keep them — is
  /// `@internal` and cannot be called from here, and the skeleton is the
  /// honest alternative: it also disables the button, so a double tap cannot
  /// fire two live LinkedIn reads. It is what the web's own loading branch
  /// renders on a refresh too.
  Future<void> forceRefresh() async {
    state = const AsyncLoading<CompanyAnalytics>();
    state = await AsyncValue.guard<CompanyAnalytics>(
      () => ref
          .read(companyRepositoryProvider)
          .fetchAnalytics(forceRefresh: true),
    );
  }
}

/// The company page's recent posts. Shared by Analytics and the Inbox.
@riverpod
class CompanyPostsController extends _$CompanyPostsController {
  @override
  Future<List<CompanyPostItem>> build() =>
      ref.watch(companyRepositoryProvider).fetchPosts();

  /// See [CompanyAnalyticsController.forceRefresh] for why this drops to a
  /// loading state instead of keeping the previous list.
  Future<void> forceRefresh() async {
    state = const AsyncLoading<List<CompanyPostItem>>();
    state = await AsyncValue.guard<List<CompanyPostItem>>(
      () => ref.read(companyRepositoryProvider).fetchPosts(forceRefresh: true),
    );
  }

  /// Toggles "featured for advocacy" on one post.
  ///
  /// Optimistic, and reconciled from the flag the SERVER stored rather than
  /// the one we asked for: the star is the only thing telling the user whether
  /// their team can see this post to amplify, and a star that lies is worse
  /// than a star that takes a moment.
  Future<void> setAdvocacy(String postId, bool isAdvocated) async {
    final List<CompanyPostItem>? current = state.value;
    if (current == null) return;

    state = AsyncData<List<CompanyPostItem>>(
      _withAdvocacy(current, postId, isAdvocated),
    );

    try {
      final bool applied = await ref
          .read(companyRepositoryProvider)
          .setAdvocacy(
            postId: postId,
            isAdvocated: isAdvocated,
            // The web features a post for a week. The value is the product
            // decision, not a default — an indefinite feature would leave the
            // team feed full of last quarter's posts.
            expiryDays: isAdvocated ? 7 : null,
          );
      state = AsyncData<List<CompanyPostItem>>(
        _withAdvocacy(current, postId, applied),
      );
    } on Object {
      ref.invalidateSelf();
    }
  }

  static List<CompanyPostItem> _withAdvocacy(
    List<CompanyPostItem> posts,
    String postId,
    bool isAdvocated,
  ) => <CompanyPostItem>[
    for (final CompanyPostItem p in posts)
      if (p.id == postId) p.copyWith(isAdvocated: isAdvocated) else p,
  ];
}

// ── Inbox ─────────────────────────────────────────────────────────────────

/// Everything one post's comment triage needs to render.
///
/// Reaction state is held here rather than on [InboxComment] because it is
/// SESSION state, not server state: LinkedIn will not tell us which comments
/// this company already reacted to, so "reacted" only means "reacted in this
/// sitting". Persisting it would be a claim we cannot back.
@freezed
abstract class InboxState with _$InboxState {
  const InboxState._();

  const factory InboxState({
    @Default(<InboxComment>[]) List<InboxComment> comments,

    /// Comment URN → the reply body currently in its editor. Seeded from the
    /// AI draft, then owned by the user.
    @Default(<String, String>{}) Map<String, String> drafts,

    /// Reactions that landed in this session.
    @Default(<String>{}) Set<String> reacted,

    /// Reactions LinkedIn answered 409 on — this company had already reacted,
    /// from another device or before the app existed. A success, not an error.
    @Default(<String>{}) Set<String> alreadyReacted,

    /// Reactions in flight. Per-URN because "React All" is a sequential loop
    /// of one call per comment and each row spins on its own.
    @Default(<String>{}) Set<String> reacting,
    @Default(false) bool publishing,
    @Default(false) bool reactingAll,

    /// A one-shot message for the screen to surface and clear: "3 replies
    /// published", "1 reply failed to push".
    String? notice,
  }) = _InboxState;

  bool isSettled(String urn) =>
      reacted.contains(urn) || alreadyReacted.contains(urn);

  bool isReacting(String urn) => reacting.contains(urn);

  /// Nothing left to react to.
  bool get allReacted =>
      comments.isNotEmpty &&
      comments.every((InboxComment c) => isSettled(c.id));

  /// The drafts that are actually publishable. An empty editor is not a reply.
  Map<String, String> get publishableDrafts => <String, String>{
    for (final MapEntry<String, String> e in drafts.entries)
      if (e.value.trim().isNotEmpty) e.key: e.value.trim(),
  };
}

/// One post's comment inbox.
///
/// A family keyed on the post URN: the user moves between posts, and a single
/// notifier would have to reset itself on every switch — which is exactly how
/// the web's version leaks a previous post's drafts into the next one.
@riverpod
class InboxController extends _$InboxController {
  @override
  Future<InboxState> build(String postUrn) async {
    final List<InboxComment> comments = await ref
        .watch(companyRepositoryProvider)
        .fetchComments(postUrn);

    return InboxState(
      comments: comments,
      // Seed every editor with its AI draft. The server guarantees a draft for
      // any comment that had text, so an empty editor means an empty comment.
      drafts: <String, String>{
        for (final InboxComment c in comments) c.id: c.suggestedReply,
      },
    );
  }

  InboxState? get _now => state.value;

  void editDraft(String urn, String text) {
    final InboxState? now = _now;
    if (now == null) return;
    state = AsyncData<InboxState>(
      now.copyWith(
        drafts: <String, String>{...now.drafts, urn: text},
        notice: null,
      ),
    );
  }

  /// Clears the one-shot notice once the screen has shown it.
  void clearNotice() {
    final InboxState? now = _now;
    if (now == null || now.notice == null) return;
    state = AsyncData<InboxState>(now.copyWith(notice: null));
  }

  /// Publishes one reply.
  Future<void> publishOne(String urn) => _publish(<String>[urn]);

  /// Publishes every non-empty draft in one batched call.
  Future<void> publishAll() {
    final InboxState? now = _now;
    if (now == null) return Future<void>.value();
    return _publish(now.publishableDrafts.keys.toList(growable: false));
  }

  /// The batch endpoint reports per-reply, and this is where that matters:
  /// only the URNs that actually succeeded are removed from the list, and the
  /// rest stay on screen with their text intact so the user can retry them.
  /// Treating a partial success as a whole success would silently drop replies.
  Future<void> _publish(List<String> urns) async {
    final InboxState? now = _now;
    if (now == null || urns.isEmpty) return;

    final Map<String, String> payload = <String, String>{
      for (final String urn in urns)
        if ((now.drafts[urn] ?? '').trim().isNotEmpty)
          urn: now.drafts[urn]!.trim(),
    };
    if (payload.isEmpty) return;

    state = AsyncData<InboxState>(now.copyWith(publishing: true, notice: null));

    try {
      final List<ReplyOutcome> results = await ref
          .read(companyRepositoryProvider)
          .replyToComments(payload);

      final Set<String> ok = <String>{
        for (final ReplyOutcome r in results)
          if (r.success) r.targetUrn,
      };
      final int failed = results.length - ok.length;

      // Re-read rather than reusing the snapshot taken before the round-trip:
      // the user can keep typing while a batch is in flight, and rebuilding
      // from the stale copy would silently discard whatever they wrote.
      final InboxState? after = _now;
      if (after == null) return;
      state = AsyncData<InboxState>(
        after.copyWith(
          publishing: false,
          comments: after.comments
              .where((InboxComment c) => !ok.contains(c.id))
              .toList(growable: false),
          drafts: <String, String>{
            for (final MapEntry<String, String> e in after.drafts.entries)
              if (!ok.contains(e.key)) e.key: e.value,
          },
          notice: _publishNotice(ok.length, failed),
        ),
      );
    } on Object {
      final InboxState? after = _now;
      if (after == null) return;
      state = AsyncData<InboxState>(
        after.copyWith(
          publishing: false,
          notice: 'Could not reach LinkedIn. Nothing was published.',
        ),
      );
    }
  }

  /// The web's copy, with the singular/plural rule it uses.
  static String? _publishNotice(int published, int failed) {
    if (failed > 0) {
      final String noun = failed == 1 ? 'reply' : 'replies';
      return '$failed $noun failed to push. Please try again.';
    }
    if (published > 0) return 'Replies Published Successfully!';
    return null;
  }

  /// Reacts to one comment as the company.
  Future<void> react(InboxComment comment) async {
    final InboxState? now = _now;
    if (now == null ||
        now.isSettled(comment.id) ||
        now.isReacting(comment.id)) {
      return;
    }

    state = AsyncData<InboxState>(
      now.copyWith(reacting: <String>{...now.reacting, comment.id}),
    );

    bool already = false;
    bool landed = false;
    try {
      already = await ref
          .read(companyRepositoryProvider)
          .reactToComment(commentUrn: comment.id, reaction: comment.reaction);
      landed = true;
    } on Object {
      landed = false;
    }

    final InboxState? after = _now;
    if (after == null) return;
    state = AsyncData<InboxState>(
      after.copyWith(
        reacting: <String>{...after.reacting}..remove(comment.id),
        reacted: landed && !already
            ? <String>{...after.reacted, comment.id}
            : after.reacted,
        alreadyReacted: landed && already
            ? <String>{...after.alreadyReacted, comment.id}
            : after.alreadyReacted,
      ),
    );
  }

  /// Reacts to every outstanding comment, one call at a time.
  ///
  /// Sequential on purpose — there is no batch reaction endpoint, and firing
  /// ten concurrent writes at LinkedIn as one actor is the shape that gets an
  /// app rate-limited. Each row spins as its own call goes out.
  Future<void> reactAll() async {
    final InboxState? now = _now;
    if (now == null || now.reactingAll) return;

    final List<InboxComment> pending = now.comments
        .where((InboxComment c) => !now.isSettled(c.id))
        .toList(growable: false);
    if (pending.isEmpty) return;

    state = AsyncData<InboxState>(now.copyWith(reactingAll: true));
    for (final InboxComment c in pending) {
      await react(c);
    }
    final InboxState? after = _now;
    if (after != null) {
      state = AsyncData<InboxState>(after.copyWith(reactingAll: false));
    }
  }
}

// ── Advocacy ──────────────────────────────────────────────────────────────

/// The advocacy feed plus the per-card reshare bookkeeping.
@freezed
abstract class AdvocacyState with _$AdvocacyState {
  const AdvocacyState._();

  const factory AdvocacyState({
    @Default(<AdvocacyPost>[]) List<AdvocacyPost> posts,

    /// Post ids with a reshare in flight.
    @Default(<String>{}) Set<String> resharing,

    /// Post ids reshared in this session. Not server state: the API records
    /// the XP award but exposes no "has this user already reshared" read, so
    /// the button can only speak for this sitting.
    @Default(<String>{}) Set<String> reshared,

    /// XP from the last successful reshare, for the toast. Null when there is
    /// nothing to celebrate.
    int? lastXpAward,

    /// A failure to show, in the server's own words where it gave them.
    String? error,
  }) = _AdvocacyState;

  bool isResharing(String id) => resharing.contains(id);
  bool isReshared(String id) => reshared.contains(id);
}

/// The global advocacy feed.
@riverpod
class AdvocacyController extends _$AdvocacyController {
  /// The web sends this exact sentence with every reshare. It is a product
  /// string, not a placeholder — do not "improve" it here without changing it
  /// on the web in the same commit, or the same post reads two different ways
  /// depending on which client amplified it.
  static const String commentary =
      'Proud to share this update from our team! 🚀 #CompanyGrowth #TeamWork';

  @override
  Future<AdvocacyState> build() async {
    final List<AdvocacyPost> posts = await ref
        .watch(companyRepositoryProvider)
        .fetchAdvocacyFeed();
    return AdvocacyState(posts: posts);
  }

  /// Reshares one post to the user's personal feed.
  Future<void> reshare(AdvocacyPost post) async {
    final AdvocacyState? now = state.value;
    if (now == null ||
        !post.canReshare ||
        now.isResharing(post.id) ||
        now.isReshared(post.id)) {
      return;
    }

    state = AsyncData<AdvocacyState>(
      now.copyWith(
        resharing: <String>{...now.resharing, post.id},
        error: null,
        lastXpAward: null,
      ),
    );

    try {
      final int xp = await ref
          .read(companyRepositoryProvider)
          .reshare(postUrn: post.linkedinPostId!, commentary: commentary);

      final AdvocacyState? after = state.value;
      if (after == null) return;
      state = AsyncData<AdvocacyState>(
        after.copyWith(
          resharing: <String>{...after.resharing}..remove(post.id),
          reshared: <String>{...after.reshared, post.id},
          lastXpAward: xp,
        ),
      );
    } on Object catch (e) {
      final AdvocacyState? after = state.value;
      if (after == null) return;
      state = AsyncData<AdvocacyState>(
        after.copyWith(
          resharing: <String>{...after.resharing}..remove(post.id),
          error: _reshareError(e),
        ),
      );
    }
  }

  /// Clears the XP toast once it has been shown.
  void clearAward() {
    final AdvocacyState? now = state.value;
    if (now == null || now.lastXpAward == null) return;
    state = AsyncData<AdvocacyState>(now.copyWith(lastXpAward: null));
  }

  void clearError() {
    final AdvocacyState? now = state.value;
    if (now == null || now.error == null) return;
    state = AsyncData<AdvocacyState>(now.copyWith(error: null));
  }

  /// Reshare publishes to the user's PERSONAL feed, so the connection it needs
  /// is not the company one this whole screen otherwise runs on. Saying
  /// "reshare failed" without saying which account is missing sends people to
  /// re-check the connection that was already fine.
  static String _reshareError(Object error) {
    if (error is CompanyUnavailable &&
        error.reason == CompanyPrecondition.noPersonalAccount) {
      return 'Connect your personal LinkedIn profile to reshare — this posts '
          'to your own feed, not the company page.';
    }
    if (error is CompanyUnavailable && error.message != null) {
      return error.message!;
    }
    return 'Reshare failed. Double check your LinkedIn connection.';
  }
}

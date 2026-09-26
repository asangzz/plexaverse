import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show Clipboard, ClipboardData;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/zave_routes.dart';
import '../../../../core/ui/zave/zave_kit.dart';
import '../../application/post_library_controllers.dart';
import '../../domain/library_post.dart';
import '../widgets/post_card.dart';
import '../widgets/post_confirm_sheet.dart';
import '../widgets/post_states.dart';

/// **Posts** — the post library. The web's `/posts`.
///
/// ## What this screen is
///
/// The server's list of everything the user has written, whether they wrote it
/// or the auto-post chain did. It is NOT the offline Drift mirror the rest of
/// this feature uses: a library that only showed locally-created posts would be
/// empty on a fresh install for a user whose posts are all generated
/// server-side, which is most of them.
///
/// ## What is ported, and what is restated
///
/// The web ships two layouts for a row (stacked below `sm`, three columns
/// above). A phone gets the stacked one, which is the web's own mobile
/// rendering rather than a mobile-specific invention.
///
/// The tab strip, the five tab labels, the server-side status filter, the
/// client-side search over loaded pages, and the rule that "Load more" hides
/// while a search is active are all the web's behaviour exactly. What changes
/// is the language: the web's `.dark-card` list with `divide-y` hairlines
/// becomes separate Zave cards, and a selected tab INVERTS to solid white with
/// ink letters rather than taking a `bg-white/10` tint.
///
/// ## The one white button
///
/// "New Post" is a ghost, not the white primary, even though the web gives it
/// the accent pill. On a phone the compose action already has a dedicated
/// button in the bottom bar, and the primary action of THIS screen is approving
/// the post that is waiting — which is the white button on the card that needs
/// it.
class PostsPage extends ConsumerStatefulWidget {
  const PostsPage({super.key});

  @override
  ConsumerState<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends ConsumerState<PostsPage> {
  final TextEditingController _search = TextEditingController();

  /// Kept in widget state rather than in a provider: it is a text box, it never
  /// leaves this screen, and it must not survive a tab change.
  String _query = '';

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  bool get _isSearching => _query.trim().isNotEmpty;

  /// Client-side, over the pages already loaded — exactly what the web does.
  /// Matching `title || content`, lower-cased, substring.
  List<LibraryPost> _filter(List<LibraryPost> posts) {
    if (!_isSearching) return posts;
    final String needle = _query.toLowerCase().trim();
    return posts
        .where(
          (LibraryPost p) =>
              '${p.title ?? ''} ${p.content}'.toLowerCase().contains(needle),
        )
        .toList(growable: false);
  }

  void _notify(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          // Zave has no toast component; the platform's is used with Zave's own
          // ground colour and type so it at least belongs to the same app.
          backgroundColor: ZaveColors.deep,
          behavior: SnackBarBehavior.floating,
          content: Text(message, style: ZaveType.body),
        ),
      );
  }

  Future<void> _approve(LibraryPost post) async {
    try {
      await ref.read(postLibraryProvider.notifier).approve(post.id);
      _notify('Post approved.');
    } on Object {
      _notify('Could not approve that post.');
    }
  }

  Future<void> _delete(LibraryPost post) async {
    final bool confirmed = await confirmDestructive(
      context,
      title: 'Delete this post?',
      message:
          'It is removed from your library and, if it was scheduled, it will '
          'not go out.',
      confirmLabel: 'Delete post',
    );
    if (!confirmed) return;
    try {
      await ref.read(postLibraryProvider.notifier).delete(post.id);
      _notify('Post deleted.');
    } on Object {
      _notify('Could not delete that post.');
    }
  }

  Future<void> _copyLink(LibraryPost post) async {
    final String? url = post.linkedinUrl;
    if (url == null) return;
    await Clipboard.setData(ClipboardData(text: url));
    _notify('LinkedIn link copied.');
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<PostLibraryState> library = ref.watch(postLibraryProvider);
    final PostLibraryFilter filter = ref.watch(postFilterProvider);

    return ZaveScaffold(
      // No header — the name moves into the scroll view as an `.h2`, above the
      // lead line that was already there.
      body: RefreshIndicator(
        color: ZaveColors.white,
        backgroundColor: ZaveColors.deep,
        onRefresh: () async {
          ref.invalidate(postLibraryProvider);
          await ref.read(postLibraryProvider.future);
        },
        child: ZaveScrollView(
          children: <Widget>[
            Text('Posts', style: ZaveType.h2),
            SizedBox(height: ZaveSpace.md),
            Text('Manage all your LinkedIn posts', style: ZaveType.lead),

            // Search, THEN the filters. The reference orders them that way and
            // it is the right order: the filters narrow what a search runs
            // over, so reading them in the other order asks you to pick a
            // scope before you know you want one.
            SizedBox(height: ZaveSpace.lg),
            ZaveField(
              controller: _search,
              pill: true,
              hint: 'Search posts...',
              prefix: const Icon(Icons.search),
              onChanged: (String value) => setState(() => _query = value),
            ),

            SizedBox(height: ZaveSpace.lg),
            _FilterStrip(
              selected: filter,
              onSelect: (PostLibraryFilter next) =>
                  ref.read(postFilterProvider.notifier).select(next),
            ),

            SizedBox(height: ZaveSpace.lg),
            // The screen's one primary action, and now the one violet thing
            // on it. It was a ghost button sitting above a row of chips, which
            // made "New Post" look like another filter.
            ZaveButton.primary(
              label: 'New Post',
              icon: const Icon(Icons.add),
              expand: true,
              onPressed: () => context.push(ZaveRoutes.create),
            ),

            SizedBox(height: ZaveSpace.xl),
            ...library.when(
              loading: () => <Widget>[const PostListSkeleton()],
              error: (Object error, StackTrace _) => <Widget>[
                PostsError(
                  title: 'Your posts did not load.',
                  detail: 'Check your connection and try again.',
                  onRetry: () => ref.invalidate(postLibraryProvider),
                ),
              ],
              data: (PostLibraryState state) => _rows(state, filter),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _rows(PostLibraryState state, PostLibraryFilter filter) {
    final List<LibraryPost> visible = _filter(state.posts);

    if (visible.isEmpty) {
      // The web's "Create your first post" link. Withheld while a search or a
      // tab is what emptied the list — the posts exist, they are just not
      // these ones, and offering to write another answers a question the user
      // did not ask.
      final bool trulyEmpty = !_isSearching && filter == PostLibraryFilter.all;

      return <Widget>[
        PostsEmpty(
          message: _isSearching
              ? 'No post matches "${_query.trim()}".'
              : 'No posts found',
          action: trulyEmpty
              ? ZaveButton.primary(
                  label: 'Create your first post',
                  expand: true,
                  onPressed: () => context.push(ZaveRoutes.create),
                )
              : null,
        ),
      ];
    }

    return <Widget>[
      for (final LibraryPost post in visible) ...<Widget>[
        PostCard(
          post: post,
          busy: state.isBusy(post.id),
          onOpen: () => context.push(ZaveRoutes.post(post.id)),
          onApprove: post.canApprove ? () => _approve(post) : null,
          onDelete: () => _delete(post),
          // Offered only when there IS a link. It used to be offered
          // always and `_copyLink` returned silently for a post with no
          // LinkedIn URL — a menu item that did nothing. The list rows now
          // come from the feed, which carries no `linkedinUrl` at all, so
          // that silent no-op would have been every row.
          onCopyLink: post.linkedinUrl == null ? null : () => _copyLink(post),
        ),
        SizedBox(height: ZaveSpace.md),
      ],

      // Hidden while searching, because the search only covers the pages
      // already in hand — the web does the same, for the same reason.
      if (state.hasMore && !_isSearching) ...<Widget>[
        SizedBox(height: ZaveSpace.sm),
        Center(
          child: ZaveButton(
            label: 'Load more',
            icon: const Icon(Icons.keyboard_arrow_down),
            busy: state.loadingMore,
            onPressed: () => ref.read(postLibraryProvider.notifier).loadMore(),
          ),
        ),
      ],
    ];
  }
}

/// The five status tabs.
///
/// Chips, and a selected chip INVERTS to solid white with ink letters — that
/// inversion is the whole selection language of Zave and the thing most likely
/// to be "improved" into a tint or an underline by accident.
class _FilterStrip extends StatelessWidget {
  const _FilterStrip({required this.selected, required this.onSelect});

  final PostLibraryFilter selected;
  final ValueChanged<PostLibraryFilter> onSelect;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: <Widget>[
          for (final PostLibraryFilter filter
              in PostLibraryFilter.values) ...<Widget>[
            ZaveChip(
              label: filter.label,
              selected: filter == selected,
              onTap: () => onSelect(filter),
            ),
            SizedBox(width: ZaveSpace.sm),
          ],
        ],
      ),
    );
  }
}

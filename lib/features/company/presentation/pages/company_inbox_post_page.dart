import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/ui/zave/zave_kit.dart';
import '../../application/company_controllers.dart';
import '../../domain/company_post.dart';
import '../../domain/company_repository.dart';
import '../../domain/inbox_comment.dart' show InboxComment;
import '../widgets/company_states.dart';
import '../widgets/inbox_widgets.dart';

/// One company post's comment inbox — the right-hand pane of the web's
/// Community Inbox, as its own screen.
///
/// Two things happen here that are easy to conflate and are not the same:
/// **reacting** is one write per comment straight to LinkedIn, and
/// **replying** is a batch that reports per-entry. The footer holds both, and
/// they behave differently on failure for that reason.
class CompanyInboxPostPage extends ConsumerWidget {
  const CompanyInboxPostPage({required this.post, super.key});

  /// The post as the list had it. Advocacy state is re-read live from the
  /// posts controller below so the star cannot go stale while this screen is
  /// open.
  final CompanyPostItem post;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<InboxState> inbox = ref.watch(
      inboxControllerProvider(post.urn),
    );
    final CompanyPostItem live = _livePost(ref);

    // Surface the one-shot notice (published / partially failed) and clear it,
    // so it cannot fire twice on the next rebuild.
    ref.listen<AsyncValue<InboxState>>(inboxControllerProvider(post.urn), (
      AsyncValue<InboxState>? previous,
      AsyncValue<InboxState> next,
    ) {
      final String? notice = next.value?.notice;
      if (notice == null || notice == previous?.value?.notice) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(notice)));
      ref.read(inboxControllerProvider(post.urn).notifier).clearNotice();
    });

    return ZaveScaffold(
      title: 'AI Assisted Replies',
      leading: ZaveIconButton(
        icon: const Icon(Icons.arrow_back),
        tooltip: 'Back',
        onPressed: () => Navigator.of(context).maybePop(),
      ),
      bottomBar: inbox.value == null || inbox.value!.comments.isEmpty
          ? null
          : _InboxFooter(postUrn: post.urn, state: inbox.value!),
      body: RefreshIndicator(
        color: ZaveColors.white,
        backgroundColor: ZaveColors.deep,
        onRefresh: () async {
          ref.invalidate(inboxControllerProvider(post.urn));
        },
        child: ZaveScrollView(
          children: <Widget>[
            _PostHeader(post: live, ref: ref),
            SizedBox(height: ZaveSpace.xl),
            ...inbox.when(
              loading: () => <Widget>[
                Text(
                  'Syncing comments & generating AI drafts...',
                  style: ZaveType.bodyMuted,
                ),
                SizedBox(height: ZaveSpace.lg),
                const CompanySkeletonList(count: 3, height: 220),
              ],
              error: (Object e, StackTrace _) => <Widget>[
                if (e is CompanyUnavailable)
                  CompanyUnavailableCard(
                    failure: e,
                    onRetry: () =>
                        ref.invalidate(inboxControllerProvider(post.urn)),
                  )
                else
                  CompanyErrorCard(
                    title: "This post's comments didn't load.",
                    onRetry: () =>
                        ref.invalidate(inboxControllerProvider(post.urn)),
                  ),
              ],
              data: (InboxState state) => _comments(ref, state),
            ),
          ],
        ),
      ),
    );
  }

  /// The row the posts controller currently holds for this post, so the
  /// advocacy toggle reflects a write made from anywhere. Falls back to the
  /// post we were handed if the list is not loaded.
  CompanyPostItem _livePost(WidgetRef ref) {
    final List<CompanyPostItem>? posts = ref
        .watch(companyPostsControllerProvider)
        .value;
    if (posts == null) return post;
    for (final CompanyPostItem p in posts) {
      if (p.id == post.id) return p;
    }
    return post;
  }

  List<Widget> _comments(WidgetRef ref, InboxState state) {
    if (state.comments.isEmpty) {
      return <Widget>[
        const CompanyEmptyCard(
          title: 'Inbox Zero',
          body: 'No pending comments found on this post.',
        ),
      ];
    }

    final InboxController notifier = ref.read(
      inboxControllerProvider(post.urn).notifier,
    );

    final List<Widget> rows = <Widget>[];
    for (int i = 0; i < state.comments.length; i++) {
      final InboxComment comment = state.comments[i];
      rows.add(
        InboxCommentCard(
          // Keyed on the comment URN so a published reply removes ITS card and
          // its editor, rather than shifting every draft up by one row.
          key: ValueKey<String>(comment.id),
          comment: comment,
          draft: state.drafts[comment.id] ?? '',
          reacting: state.isReacting(comment.id),
          reacted: state.reacted.contains(comment.id),
          alreadyReacted: state.alreadyReacted.contains(comment.id),
          publishing: state.publishing,
          onDraftChanged: (String text) => notifier.editDraft(comment.id, text),
          onReact: () => notifier.react(comment),
          onPublish: () => notifier.publishOne(comment.id),
        ),
      );
      if (i != state.comments.length - 1) {
        rows.add(SizedBox(height: ZaveSpace.md));
      }
    }
    return rows;
  }
}

/// The post being triaged, and its advocacy toggle.
class _PostHeader extends StatelessWidget {
  const _PostHeader({required this.post, required this.ref});

  final CompanyPostItem post;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return ZaveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            post.text,
            style: ZaveType.body,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: ZaveSpace.lg),
          Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('ADVOCACY', style: ZaveType.kicker),
                    SizedBox(height: ZaveSpace.xs),
                    Text(
                      post.isAdvocated
                          ? 'Featured for Advocacy'
                          : 'Feature for Advocacy',
                      style: ZaveType.caption.copyWith(
                        // Amber is "waiting" in this palette, which is what a
                        // featured post is: queued for the team to amplify.
                        color: post.isAdvocated
                            ? ZaveColors.amber
                            : ZaveColors.ink50,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: ZaveSpace.md),
              ZaveSwitch(
                value: post.isAdvocated,
                semanticLabel: 'Feature for advocacy',
                onChanged: (bool next) => ref
                    .read(companyPostsControllerProvider.notifier)
                    .setAdvocacy(post.id, next),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// The sticky action footer: react to everything, or push every draft.
class _InboxFooter extends ConsumerWidget {
  const _InboxFooter({required this.postUrn, required this.state});

  final String postUrn;
  final InboxState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final InboxController notifier = ref.read(
      inboxControllerProvider(postUrn).notifier,
    );
    final int publishable = state.publishableDrafts.length;

    return Container(
      decoration: const BoxDecoration(
        color: ZaveGlass.headerFill,
        border: Border(
          top: BorderSide(color: ZaveGlass.headerBorder, width: 1),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: ZaveSpace.gutter,
            vertical: ZaveSpace.md,
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                child: ZaveButton(
                  label: state.allReacted ? 'All reacted' : 'React all',
                  busy: state.reactingAll,
                  expand: true,
                  onPressed: state.allReacted || state.reactingAll
                      ? null
                      : notifier.reactAll,
                ),
              ),
              SizedBox(width: ZaveSpace.md),
              Expanded(
                child: ZaveButton(
                  // The count is the number of drafts that would actually be
                  // sent, not the number of comments on screen. The web
                  // promises "Push {comments.length} Comments" and then sends
                  // only the non-empty ones.
                  label: publishable == 1
                      ? 'Push 1 reply'
                      : 'Push $publishable replies',
                  kind: ZaveButtonKind.primarySmall,
                  busy: state.publishing,
                  expand: true,
                  onPressed: publishable == 0 || state.publishing
                      ? null
                      : notifier.publishAll,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/zave_routes.dart';
import '../../../../core/ui/zave/zave_kit.dart';
import '../../application/company_controllers.dart';
import '../../domain/company_post.dart';
import '../../domain/company_repository.dart';
import '../widgets/company_states.dart';
import '../widgets/inbox_widgets.dart';
import 'company_inbox_post_page.dart';

/// **Inbox** — the web's `/company-auto-comment`, "Community Inbox".
///
/// Company-brand only (`visibility: company`). The web is a two-pane
/// master/detail: posts on the left, the selected post's comments on the
/// right. Below its `lg` breakpoint that collapses into two nested scrollers
/// stacked on top of each other, which is unusable on a phone.
///
/// So the master/detail becomes navigation: this screen is the post list, and
/// tapping a post opens its inbox as a screen of its own. That is the same
/// information architecture expressed in the grammar a phone has.
class CompanyInboxPage extends ConsumerWidget {
  const CompanyInboxPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<CompanyPostItem>> posts = ref.watch(
      companyPostsControllerProvider,
    );

    return ZaveScaffold(
      largeTitle: 'Community Inbox',
      body: RefreshIndicator(
        color: ZaveColors.white,
        backgroundColor: ZaveColors.deep,
        onRefresh: () =>
            ref.read(companyPostsControllerProvider.notifier).forceRefresh(),
        child: ZaveScrollView(
          children: <Widget>[
            Text(
              'Let AI draft replies to inbound comments on your Company posts.',
              style: ZaveType.lead,
            ),
            SizedBox(height: ZaveSpace.xl),
            Text('TARGET A POST', style: ZaveType.kicker),
            SizedBox(height: ZaveSpace.lg),
            ...posts.when(
              loading: () => <Widget>[
                const CompanySkeletonList(count: 4, height: 128),
              ],
              error: (Object e, StackTrace _) => <Widget>[
                if (e is CompanyUnavailable)
                  CompanyUnavailableCard(
                    failure: e,
                    onRetry: () =>
                        ref.invalidate(companyPostsControllerProvider),
                    onOpenSettings: () => context.push(ZaveRoutes.settings),
                  )
                else
                  CompanyErrorCard(
                    title: "Your company posts didn't load.",
                    onRetry: () =>
                        ref.invalidate(companyPostsControllerProvider),
                  ),
              ],
              data: (List<CompanyPostItem> items) => _rows(context, items),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _rows(BuildContext context, List<CompanyPostItem> posts) {
    if (posts.isEmpty) {
      return <Widget>[
        const CompanyEmptyCard(
          title: 'No posts to triage',
          body: 'No posts found to fetch comments for.',
        ),
      ];
    }

    return <Widget>[
      for (int i = 0; i < posts.length; i++) ...<Widget>[
        InboxPostRow(post: posts[i], onTap: () => _openPost(context, posts[i])),
        if (i != posts.length - 1) SizedBox(height: ZaveSpace.md),
      ],
    ];
  }

  /// Pushed on the local navigator rather than through a route constant.
  ///
  /// There is no web route for one post's inbox — the web selects into a pane.
  /// Inventing a `/company-auto-comment/:urn` path would put a URL in the app
  /// that the web cannot resolve, which is the thing the shared route table
  /// exists to prevent.
  void _openPost(BuildContext context, CompanyPostItem post) {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (BuildContext _) => CompanyInboxPostPage(post: post),
      ),
    );
  }
}

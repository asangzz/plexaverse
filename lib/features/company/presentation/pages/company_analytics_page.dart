import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/zave_routes.dart';
import '../../../../core/ui/zave/zave_kit.dart';
import '../../application/company_controllers.dart';
import '../../domain/company_analytics.dart';
import '../../domain/company_post.dart';
import '../../domain/company_repository.dart';
import '../widgets/analytics_widgets.dart';
import '../widgets/company_states.dart';

/// **Analytics** — the web's `/company-analytics`.
///
/// This is the app's ONLY analytics surface, on both platforms, and it is
/// company-brand only. There is no personal-brand analytics screen anywhere in
/// the product: LinkedIn's post-statistics and page-statistics endpoints both
/// require an organization URN, and the personal equivalents need Partner
/// Program access we do not have. The nav hides it for personal users
/// (`visibility: company`); the screen itself says so honestly if reached.
///
/// The web lays this out as a three-column tile row, a two-column detail row
/// and a three-column post grid. A phone gets the web's own sub-768px
/// rendering: one column throughout.
class CompanyAnalyticsPage extends ConsumerWidget {
  const CompanyAnalyticsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<CompanyAnalytics> analytics = ref.watch(
      companyAnalyticsControllerProvider,
    );
    final AsyncValue<List<CompanyPostItem>> posts = ref.watch(
      companyPostsControllerProvider,
    );

    final bool refreshing = analytics.isLoading || posts.isLoading;

    return ZaveScaffold(
      largeTitle: 'Company Analytics',
      actions: <Widget>[
        // The web's "Refresh Data" button. It force-refreshes BOTH queries,
        // bypassing the server's 24-hour cache — which is the only path that
        // does, and the reason it must stay an explicit gesture.
        ZaveIconButton(
          icon: const Icon(Icons.refresh),
          tooltip: refreshing ? 'Refreshing...' : 'Refresh Data',
          onPressed: refreshing ? null : () => _forceRefresh(ref),
        ),
      ],
      body: RefreshIndicator(
        color: ZaveColors.white,
        backgroundColor: ZaveColors.deep,
        // Pull-to-refresh maps to the same force-refresh, because a pull is
        // exactly as deliberate a gesture as the button.
        onRefresh: () => _forceRefresh(ref),
        child: ZaveScrollView(
          children: <Widget>[
            Text(
              'Measure your page growth, audience retention, and visitor '
              'metrics.',
              style: ZaveType.lead,
            ),
            SizedBox(height: ZaveSpace.xl),
            ...analytics.when(
              loading: () => <Widget>[
                const CompanySkeletonList(count: 3, height: 128),
              ],
              error: (Object e, StackTrace _) => <Widget>[
                _failureCard(context, ref, e),
              ],
              data: (CompanyAnalytics data) => _analyticsSections(data),
            ),
            SizedBox(height: ZaveSpace.xxl),
            Text('RECENT POST PERFORMANCE', style: ZaveType.kicker),
            SizedBox(height: ZaveSpace.lg),
            ...posts.when(
              loading: () => <Widget>[
                const CompanySkeletonList(count: 2, height: 180),
              ],
              // Analytics already reported the precondition above; a second
              // identical card would just be the same sentence twice.
              error: (Object e, StackTrace _) => analytics.hasError
                  ? const <Widget>[]
                  : <Widget>[_failureCard(context, ref, e)],
              data: (List<CompanyPostItem> items) =>
                  _postSections(context, items),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _forceRefresh(WidgetRef ref) async {
    await Future.wait<void>(<Future<void>>[
      ref.read(companyAnalyticsControllerProvider.notifier).forceRefresh(),
      ref.read(companyPostsControllerProvider.notifier).forceRefresh(),
    ]);
  }

  Widget _failureCard(BuildContext context, WidgetRef ref, Object error) {
    if (error is CompanyUnavailable) {
      return CompanyUnavailableCard(
        failure: error,
        onRetry: () => _forceRefresh(ref),
        onOpenSettings: () => context.push(ZaveRoutes.settings),
      );
    }
    return CompanyErrorCard(
      title: "Your company analytics didn't load.",
      onRetry: () => _forceRefresh(ref),
    );
  }

  List<Widget> _analyticsSections(CompanyAnalytics data) {
    return <Widget>[
      CompanyStatTile(
        badge: 'Audience',
        label: 'Total Followers',
        value: data.totalFollowers,
      ),
      SizedBox(height: ZaveSpace.md),
      CompanyStatTile(
        badge: 'Traffic',
        label: 'Page Views (All Time)',
        value: data.pageViews,
      ),
      SizedBox(height: ZaveSpace.md),
      CompanyStatTile(
        badge: 'Mobile',
        label: 'Mobile Views',
        value: data.mobileViews,
      ),
      SizedBox(height: ZaveSpace.xxl),
      _AudienceSizeCard(followers: data.followers),
      SizedBox(height: ZaveSpace.md),
      _DestinationsCard(pageStats: data.pageStats),
    ];
  }

  List<Widget> _postSections(
    BuildContext context,
    List<CompanyPostItem> posts,
  ) {
    if (posts.isEmpty) {
      return <Widget>[
        CompanyEmptyCard(
          title: 'No Posts Found',
          body:
              "It looks like your company page hasn't published any posts "
              'yet. Time to engage your audience!',
          actionLabel: 'Create a Post with AI',
          onAction: () => context.push(ZaveRoutes.companyPost),
        ),
      ];
    }
    return <Widget>[
      for (int i = 0; i < posts.length; i++) ...<Widget>[
        CompanyPostPerformanceCard(post: posts[i]),
        if (i != posts.length - 1) SizedBox(height: ZaveSpace.md),
      ],
    ];
  }
}

/// "Audience Company Size" — the top five employer sizes among followers.
class _AudienceSizeCard extends StatelessWidget {
  const _AudienceSizeCard({required this.followers});

  final CompanyFollowerStats? followers;

  @override
  Widget build(BuildContext context) {
    final List<StaffCountBucket> buckets =
        followers?.topStaffBuckets ?? const <StaffCountBucket>[];
    final int max = followers?.staffMax ?? 1;

    return ZaveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Audience Company Size', style: ZaveType.h3),
          SizedBox(height: ZaveSpace.lg),
          if (buckets.isEmpty)
            Text(
              'No company size data available yet.',
              style: ZaveType.bodyMuted,
            )
          else
            for (final StaffCountBucket b in buckets)
              CompanyProportionBar(
                // The web appends " employees" to the parsed range and relies
                // on CSS `capitalize`; Flutter has no text-transform, so the
                // string is composed here.
                label: '${b.label} employees',
                value: b.organic,
                // 5% floor: a bucket with one follower must still show as a
                // sliver, or the row reads as a bug.
                fraction: _atLeast(b.organic / max, 0.05),
              ),
        ],
      ),
    );
  }
}

/// "Page Destinations" — which tabs of the company page people land on.
class _DestinationsCard extends StatelessWidget {
  const _DestinationsCard({required this.pageStats});

  final CompanyPageStats? pageStats;

  @override
  Widget build(BuildContext context) {
    final List<PageDestination> rows =
        pageStats?.destinations ?? const <PageDestination>[];
    final int max = pageStats?.destinationMax ?? 1;

    return ZaveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Page Destinations', style: ZaveType.h3),
          SizedBox(height: ZaveSpace.lg),
          if (rows.isEmpty)
            Text('No page traffic recorded yet.', style: ZaveType.bodyMuted)
          else
            for (final PageDestination d in rows)
              CompanyProportionBar(
                label: d.label,
                value: d.views,
                fraction: _atLeast(d.views / max, 0.02),
              ),
        ],
      ),
    );
  }
}

/// The web's `Math.max(floor, …)` on a bar width, with one addition: a row
/// that is genuinely zero stays at zero. Floor-ing a zero row to 2% would draw
/// a sliver for traffic that does not exist.
double _atLeast(double value, double floor) {
  if (!value.isFinite || value <= 0) return 0;
  return value < floor ? floor : value;
}

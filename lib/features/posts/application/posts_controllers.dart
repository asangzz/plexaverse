import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/posts_repositories.dart';
import '../domain/analytics_entity.dart';
import '../domain/post_entity.dart';

part 'posts_controllers.g.dart';

/// Reactive stream of ALL posts (Drift-backed), most-recently-updated first.
///
/// This is the canonical posts stream for the whole app — the Posts tab, the
/// Home dashboard bell/recent list, and the Schedule calendar all watch it,
/// so the posts feature owns it (moved out of the legacy
/// `home/providers/dashboard_provider.dart`). Sibling features import
/// `allPostsProvider` from here.
@riverpod
Stream<List<PostEntity>> allPosts(Ref ref) =>
    ref.watch(postsRepositoryProvider).watchAll();

/// Backwards-compatible alias for the legacy `postsProvider` stream (the
/// posts-tab list). Identical payload to [allPosts]; kept so existing call
/// sites that referenced `postsProvider` keep resolving.
@riverpod
Stream<List<PostEntity>> posts(Ref ref) =>
    ref.watch(postsRepositoryProvider).watchAll();

/// Reactive stream of posts filtered by [status] (family keyed by status).
@riverpod
Stream<List<PostEntity>> postsByStatus(Ref ref, PostStatus status) =>
    ref.watch(postsRepositoryProvider).watchByStatus(status);

/// The N most recent posts (dashboard recent list).
@riverpod
Stream<List<PostEntity>> recentPosts(Ref ref, int limit) =>
    ref.watch(postsRepositoryProvider).watchRecent(limit);

/// Total post counts per status (drives the filter-chip badges + dashboard
/// scheduled count). Owned by posts; imported by home.
@riverpod
Future<Map<PostStatus, int>> postCounts(Ref ref) =>
    ref.watch(postsRepositoryProvider).getCounts();

/// Aggregate analytics for the Analytics tab and dashboard KPIs. Produced by
/// the posts repository (local aggregation today; remote metrics later).
/// Owned by posts; imported by the analytics feature.
@riverpod
Future<AnalyticsEntity> analyticsData(Ref ref) =>
    ref.watch(postsRepositoryProvider).fetchAnalytics();

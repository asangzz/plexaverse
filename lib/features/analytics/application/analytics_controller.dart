import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/analytics_repositories.dart';
import '../domain/analytics_repository.dart';

part 'analytics_controller.g.dart';

/// Loads the Analytics tab aggregate. `AsyncValue` drives the three states:
/// loading → shimmer placeholders, error → shared network-error view with
/// retry, data → the hero/sub-metrics/top-post/best-times cards.
/// Pull-to-refresh and the retry button re-run it via `ref.invalidate` /
/// `.future`.
@riverpod
class AnalyticsController extends _$AnalyticsController {
  @override
  Future<AnalyticsEntity> build() {
    return ref.watch(analyticsRepositoryProvider).fetchAnalytics();
  }
}

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/settings_repositories.dart';
import '../domain/subscription_info.dart';

part 'subscription_controller.g.dart';

/// Loads the plan + quota snapshot for the Account page (2374) and the
/// Subscription bottom sheet (2375).
///
/// `AsyncValue` drives the states: the Account page renders the gradient
/// card with fixture-shaped fallbacks while loading (the page chrome never
/// blocks on this fetch); the sheet shows a compact spinner → content →
/// inline retry. Auto-retry is globally disabled — recovery is explicit via
/// `ref.invalidate`.
@riverpod
class SubscriptionController extends _$SubscriptionController {
  @override
  Future<SubscriptionInfo> build() {
    return ref.watch(settingsRepositoryProvider).fetchSubscription();
  }
}

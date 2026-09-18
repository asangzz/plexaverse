// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Loads the plan + quota snapshot for the Account page (2374) and the
/// Subscription bottom sheet (2375).
///
/// `AsyncValue` drives the states: the Account page renders the gradient
/// card with fixture-shaped fallbacks while loading (the page chrome never
/// blocks on this fetch); the sheet shows a compact spinner → content →
/// inline retry. Auto-retry is globally disabled — recovery is explicit via
/// `ref.invalidate`.

@ProviderFor(SubscriptionController)
final subscriptionControllerProvider = SubscriptionControllerProvider._();

/// Loads the plan + quota snapshot for the Account page (2374) and the
/// Subscription bottom sheet (2375).
///
/// `AsyncValue` drives the states: the Account page renders the gradient
/// card with fixture-shaped fallbacks while loading (the page chrome never
/// blocks on this fetch); the sheet shows a compact spinner → content →
/// inline retry. Auto-retry is globally disabled — recovery is explicit via
/// `ref.invalidate`.
final class SubscriptionControllerProvider
    extends $AsyncNotifierProvider<SubscriptionController, SubscriptionInfo> {
  /// Loads the plan + quota snapshot for the Account page (2374) and the
  /// Subscription bottom sheet (2375).
  ///
  /// `AsyncValue` drives the states: the Account page renders the gradient
  /// card with fixture-shaped fallbacks while loading (the page chrome never
  /// blocks on this fetch); the sheet shows a compact spinner → content →
  /// inline retry. Auto-retry is globally disabled — recovery is explicit via
  /// `ref.invalidate`.
  SubscriptionControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'subscriptionControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$subscriptionControllerHash();

  @$internal
  @override
  SubscriptionController create() => SubscriptionController();
}

String _$subscriptionControllerHash() =>
    r'0354f6dc82f7f5213424b48493e4801526a5a4a7';

/// Loads the plan + quota snapshot for the Account page (2374) and the
/// Subscription bottom sheet (2375).
///
/// `AsyncValue` drives the states: the Account page renders the gradient
/// card with fixture-shaped fallbacks while loading (the page chrome never
/// blocks on this fetch); the sheet shows a compact spinner → content →
/// inline retry. Auto-retry is globally disabled — recovery is explicit via
/// `ref.invalidate`.

abstract class _$SubscriptionController
    extends $AsyncNotifier<SubscriptionInfo> {
  FutureOr<SubscriptionInfo> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<SubscriptionInfo>, SubscriptionInfo>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<SubscriptionInfo>, SubscriptionInfo>,
              AsyncValue<SubscriptionInfo>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

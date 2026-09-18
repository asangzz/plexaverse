// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_controllers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Company page follower + page statistics.

@ProviderFor(CompanyAnalyticsController)
final companyAnalyticsControllerProvider =
    CompanyAnalyticsControllerProvider._();

/// Company page follower + page statistics.
final class CompanyAnalyticsControllerProvider
    extends
        $AsyncNotifierProvider<CompanyAnalyticsController, CompanyAnalytics> {
  /// Company page follower + page statistics.
  CompanyAnalyticsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'companyAnalyticsControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$companyAnalyticsControllerHash();

  @$internal
  @override
  CompanyAnalyticsController create() => CompanyAnalyticsController();
}

String _$companyAnalyticsControllerHash() =>
    r'abe1fea575a8a2b178e574758f1c098a48ab62c2';

/// Company page follower + page statistics.

abstract class _$CompanyAnalyticsController
    extends $AsyncNotifier<CompanyAnalytics> {
  FutureOr<CompanyAnalytics> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<CompanyAnalytics>, CompanyAnalytics>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<CompanyAnalytics>, CompanyAnalytics>,
              AsyncValue<CompanyAnalytics>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// The company page's recent posts. Shared by Analytics and the Inbox.

@ProviderFor(CompanyPostsController)
final companyPostsControllerProvider = CompanyPostsControllerProvider._();

/// The company page's recent posts. Shared by Analytics and the Inbox.
final class CompanyPostsControllerProvider
    extends
        $AsyncNotifierProvider<CompanyPostsController, List<CompanyPostItem>> {
  /// The company page's recent posts. Shared by Analytics and the Inbox.
  CompanyPostsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'companyPostsControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$companyPostsControllerHash();

  @$internal
  @override
  CompanyPostsController create() => CompanyPostsController();
}

String _$companyPostsControllerHash() =>
    r'6cf805890a1b0d7efeb35d941d10bd2908e455cc';

/// The company page's recent posts. Shared by Analytics and the Inbox.

abstract class _$CompanyPostsController
    extends $AsyncNotifier<List<CompanyPostItem>> {
  FutureOr<List<CompanyPostItem>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<List<CompanyPostItem>>, List<CompanyPostItem>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<CompanyPostItem>>,
                List<CompanyPostItem>
              >,
              AsyncValue<List<CompanyPostItem>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// One post's comment inbox.
///
/// A family keyed on the post URN: the user moves between posts, and a single
/// notifier would have to reset itself on every switch — which is exactly how
/// the web's version leaks a previous post's drafts into the next one.

@ProviderFor(InboxController)
final inboxControllerProvider = InboxControllerFamily._();

/// One post's comment inbox.
///
/// A family keyed on the post URN: the user moves between posts, and a single
/// notifier would have to reset itself on every switch — which is exactly how
/// the web's version leaks a previous post's drafts into the next one.
final class InboxControllerProvider
    extends $AsyncNotifierProvider<InboxController, InboxState> {
  /// One post's comment inbox.
  ///
  /// A family keyed on the post URN: the user moves between posts, and a single
  /// notifier would have to reset itself on every switch — which is exactly how
  /// the web's version leaks a previous post's drafts into the next one.
  InboxControllerProvider._({
    required InboxControllerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'inboxControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$inboxControllerHash();

  @override
  String toString() {
    return r'inboxControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  InboxController create() => InboxController();

  @override
  bool operator ==(Object other) {
    return other is InboxControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$inboxControllerHash() => r'06379a969b966afb35655fcb3841155a9c6b0783';

/// One post's comment inbox.
///
/// A family keyed on the post URN: the user moves between posts, and a single
/// notifier would have to reset itself on every switch — which is exactly how
/// the web's version leaks a previous post's drafts into the next one.

final class InboxControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          InboxController,
          AsyncValue<InboxState>,
          InboxState,
          FutureOr<InboxState>,
          String
        > {
  InboxControllerFamily._()
    : super(
        retry: null,
        name: r'inboxControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// One post's comment inbox.
  ///
  /// A family keyed on the post URN: the user moves between posts, and a single
  /// notifier would have to reset itself on every switch — which is exactly how
  /// the web's version leaks a previous post's drafts into the next one.

  InboxControllerProvider call(String postUrn) =>
      InboxControllerProvider._(argument: postUrn, from: this);

  @override
  String toString() => r'inboxControllerProvider';
}

/// One post's comment inbox.
///
/// A family keyed on the post URN: the user moves between posts, and a single
/// notifier would have to reset itself on every switch — which is exactly how
/// the web's version leaks a previous post's drafts into the next one.

abstract class _$InboxController extends $AsyncNotifier<InboxState> {
  late final _$args = ref.$arg as String;
  String get postUrn => _$args;

  FutureOr<InboxState> build(String postUrn);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<InboxState>, InboxState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<InboxState>, InboxState>,
              AsyncValue<InboxState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}

/// The global advocacy feed.

@ProviderFor(AdvocacyController)
final advocacyControllerProvider = AdvocacyControllerProvider._();

/// The global advocacy feed.
final class AdvocacyControllerProvider
    extends $AsyncNotifierProvider<AdvocacyController, AdvocacyState> {
  /// The global advocacy feed.
  AdvocacyControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'advocacyControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$advocacyControllerHash();

  @$internal
  @override
  AdvocacyController create() => AdvocacyController();
}

String _$advocacyControllerHash() =>
    r'dff5028f926de76e8bd099a9e967cc70e31ca9db';

/// The global advocacy feed.

abstract class _$AdvocacyController extends $AsyncNotifier<AdvocacyState> {
  FutureOr<AdvocacyState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<AdvocacyState>, AdvocacyState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<AdvocacyState>, AdvocacyState>,
              AsyncValue<AdvocacyState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

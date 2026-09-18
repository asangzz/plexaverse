// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'posts_controllers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Reactive stream of ALL posts (Drift-backed), most-recently-updated first.
///
/// This is the canonical posts stream for the whole app — the Posts tab, the
/// Home dashboard bell/recent list, and the Schedule calendar all watch it,
/// so the posts feature owns it (moved out of the legacy
/// `home/providers/dashboard_provider.dart`). Sibling features import
/// `allPostsProvider` from here.

@ProviderFor(allPosts)
final allPostsProvider = AllPostsProvider._();

/// Reactive stream of ALL posts (Drift-backed), most-recently-updated first.
///
/// This is the canonical posts stream for the whole app — the Posts tab, the
/// Home dashboard bell/recent list, and the Schedule calendar all watch it,
/// so the posts feature owns it (moved out of the legacy
/// `home/providers/dashboard_provider.dart`). Sibling features import
/// `allPostsProvider` from here.

final class AllPostsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<PostEntity>>,
          List<PostEntity>,
          Stream<List<PostEntity>>
        >
    with $FutureModifier<List<PostEntity>>, $StreamProvider<List<PostEntity>> {
  /// Reactive stream of ALL posts (Drift-backed), most-recently-updated first.
  ///
  /// This is the canonical posts stream for the whole app — the Posts tab, the
  /// Home dashboard bell/recent list, and the Schedule calendar all watch it,
  /// so the posts feature owns it (moved out of the legacy
  /// `home/providers/dashboard_provider.dart`). Sibling features import
  /// `allPostsProvider` from here.
  AllPostsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'allPostsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$allPostsHash();

  @$internal
  @override
  $StreamProviderElement<List<PostEntity>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<PostEntity>> create(Ref ref) {
    return allPosts(ref);
  }
}

String _$allPostsHash() => r'ea990e83912e4710ed88c2d540825e8bcc218397';

/// Backwards-compatible alias for the legacy `postsProvider` stream (the
/// posts-tab list). Identical payload to [allPosts]; kept so existing call
/// sites that referenced `postsProvider` keep resolving.

@ProviderFor(posts)
final postsProvider = PostsProvider._();

/// Backwards-compatible alias for the legacy `postsProvider` stream (the
/// posts-tab list). Identical payload to [allPosts]; kept so existing call
/// sites that referenced `postsProvider` keep resolving.

final class PostsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<PostEntity>>,
          List<PostEntity>,
          Stream<List<PostEntity>>
        >
    with $FutureModifier<List<PostEntity>>, $StreamProvider<List<PostEntity>> {
  /// Backwards-compatible alias for the legacy `postsProvider` stream (the
  /// posts-tab list). Identical payload to [allPosts]; kept so existing call
  /// sites that referenced `postsProvider` keep resolving.
  PostsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'postsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$postsHash();

  @$internal
  @override
  $StreamProviderElement<List<PostEntity>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<PostEntity>> create(Ref ref) {
    return posts(ref);
  }
}

String _$postsHash() => r'70feaa497ff290c6d94dfc58108a7caba4e5555c';

/// Reactive stream of posts filtered by [status] (family keyed by status).

@ProviderFor(postsByStatus)
final postsByStatusProvider = PostsByStatusFamily._();

/// Reactive stream of posts filtered by [status] (family keyed by status).

final class PostsByStatusProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<PostEntity>>,
          List<PostEntity>,
          Stream<List<PostEntity>>
        >
    with $FutureModifier<List<PostEntity>>, $StreamProvider<List<PostEntity>> {
  /// Reactive stream of posts filtered by [status] (family keyed by status).
  PostsByStatusProvider._({
    required PostsByStatusFamily super.from,
    required PostStatus super.argument,
  }) : super(
         retry: null,
         name: r'postsByStatusProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$postsByStatusHash();

  @override
  String toString() {
    return r'postsByStatusProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<PostEntity>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<PostEntity>> create(Ref ref) {
    final argument = this.argument as PostStatus;
    return postsByStatus(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is PostsByStatusProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$postsByStatusHash() => r'f275c3d77e8a99db7d55adc5827e41b8ea429685';

/// Reactive stream of posts filtered by [status] (family keyed by status).

final class PostsByStatusFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<PostEntity>>, PostStatus> {
  PostsByStatusFamily._()
    : super(
        retry: null,
        name: r'postsByStatusProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Reactive stream of posts filtered by [status] (family keyed by status).

  PostsByStatusProvider call(PostStatus status) =>
      PostsByStatusProvider._(argument: status, from: this);

  @override
  String toString() => r'postsByStatusProvider';
}

/// The N most recent posts (dashboard recent list).

@ProviderFor(recentPosts)
final recentPostsProvider = RecentPostsFamily._();

/// The N most recent posts (dashboard recent list).

final class RecentPostsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<PostEntity>>,
          List<PostEntity>,
          Stream<List<PostEntity>>
        >
    with $FutureModifier<List<PostEntity>>, $StreamProvider<List<PostEntity>> {
  /// The N most recent posts (dashboard recent list).
  RecentPostsProvider._({
    required RecentPostsFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'recentPostsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$recentPostsHash();

  @override
  String toString() {
    return r'recentPostsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<PostEntity>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<PostEntity>> create(Ref ref) {
    final argument = this.argument as int;
    return recentPosts(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is RecentPostsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$recentPostsHash() => r'341869f2f448a1df9c7c35c9e9c6f383deace4cf';

/// The N most recent posts (dashboard recent list).

final class RecentPostsFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<PostEntity>>, int> {
  RecentPostsFamily._()
    : super(
        retry: null,
        name: r'recentPostsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The N most recent posts (dashboard recent list).

  RecentPostsProvider call(int limit) =>
      RecentPostsProvider._(argument: limit, from: this);

  @override
  String toString() => r'recentPostsProvider';
}

/// Total post counts per status (drives the filter-chip badges + dashboard
/// scheduled count). Owned by posts; imported by home.

@ProviderFor(postCounts)
final postCountsProvider = PostCountsProvider._();

/// Total post counts per status (drives the filter-chip badges + dashboard
/// scheduled count). Owned by posts; imported by home.

final class PostCountsProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<PostStatus, int>>,
          Map<PostStatus, int>,
          FutureOr<Map<PostStatus, int>>
        >
    with
        $FutureModifier<Map<PostStatus, int>>,
        $FutureProvider<Map<PostStatus, int>> {
  /// Total post counts per status (drives the filter-chip badges + dashboard
  /// scheduled count). Owned by posts; imported by home.
  PostCountsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'postCountsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$postCountsHash();

  @$internal
  @override
  $FutureProviderElement<Map<PostStatus, int>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<PostStatus, int>> create(Ref ref) {
    return postCounts(ref);
  }
}

String _$postCountsHash() => r'e83240eac6aa757e429b123c603517041829243f';

/// Aggregate analytics for the Analytics tab and dashboard KPIs. Produced by
/// the posts repository (local aggregation today; remote metrics later).
/// Owned by posts; imported by the analytics feature.

@ProviderFor(analyticsData)
final analyticsDataProvider = AnalyticsDataProvider._();

/// Aggregate analytics for the Analytics tab and dashboard KPIs. Produced by
/// the posts repository (local aggregation today; remote metrics later).
/// Owned by posts; imported by the analytics feature.

final class AnalyticsDataProvider
    extends
        $FunctionalProvider<
          AsyncValue<AnalyticsEntity>,
          AnalyticsEntity,
          FutureOr<AnalyticsEntity>
        >
    with $FutureModifier<AnalyticsEntity>, $FutureProvider<AnalyticsEntity> {
  /// Aggregate analytics for the Analytics tab and dashboard KPIs. Produced by
  /// the posts repository (local aggregation today; remote metrics later).
  /// Owned by posts; imported by the analytics feature.
  AnalyticsDataProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'analyticsDataProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$analyticsDataHash();

  @$internal
  @override
  $FutureProviderElement<AnalyticsEntity> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<AnalyticsEntity> create(Ref ref) {
    return analyticsData(ref);
  }
}

String _$analyticsDataHash() => r'412de65c5adb10dce2edbef12f79dab191884304';

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_library_controllers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Which tab is selected. UI state, so it lives in its own tiny notifier and
/// [PostLibrary] watches it — selecting a tab re-runs the server-side filter
/// rather than filtering a list the client already has.

@ProviderFor(PostFilter)
final postFilterProvider = PostFilterProvider._();

/// Which tab is selected. UI state, so it lives in its own tiny notifier and
/// [PostLibrary] watches it — selecting a tab re-runs the server-side filter
/// rather than filtering a list the client already has.
final class PostFilterProvider
    extends $NotifierProvider<PostFilter, PostLibraryFilter> {
  /// Which tab is selected. UI state, so it lives in its own tiny notifier and
  /// [PostLibrary] watches it — selecting a tab re-runs the server-side filter
  /// rather than filtering a list the client already has.
  PostFilterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'postFilterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$postFilterHash();

  @$internal
  @override
  PostFilter create() => PostFilter();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PostLibraryFilter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PostLibraryFilter>(value),
    );
  }
}

String _$postFilterHash() => r'e01caca8b2a49250a3d3bc2d3f4413f05e33464f';

/// Which tab is selected. UI state, so it lives in its own tiny notifier and
/// [PostLibrary] watches it — selecting a tab re-runs the server-side filter
/// rather than filtering a list the client already has.

abstract class _$PostFilter extends $Notifier<PostLibraryFilter> {
  PostLibraryFilter build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<PostLibraryFilter, PostLibraryFilter>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PostLibraryFilter, PostLibraryFilter>,
              PostLibraryFilter,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// The post library — the web's `/posts`.
///
/// Reads are paginated futures off the mobile API, NOT the Drift stream the
/// rest of this feature uses. The library is the server's list: it has to show
/// posts this device never created (the auto-post chain writes most of them),
/// and a local mirror would show a user an empty library on a fresh install.

@ProviderFor(PostLibrary)
final postLibraryProvider = PostLibraryProvider._();

/// The post library — the web's `/posts`.
///
/// Reads are paginated futures off the mobile API, NOT the Drift stream the
/// rest of this feature uses. The library is the server's list: it has to show
/// posts this device never created (the auto-post chain writes most of them),
/// and a local mirror would show a user an empty library on a fresh install.
final class PostLibraryProvider
    extends $AsyncNotifierProvider<PostLibrary, PostLibraryState> {
  /// The post library — the web's `/posts`.
  ///
  /// Reads are paginated futures off the mobile API, NOT the Drift stream the
  /// rest of this feature uses. The library is the server's list: it has to show
  /// posts this device never created (the auto-post chain writes most of them),
  /// and a local mirror would show a user an empty library on a fresh install.
  PostLibraryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'postLibraryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$postLibraryHash();

  @$internal
  @override
  PostLibrary create() => PostLibrary();
}

String _$postLibraryHash() => r'a4e9f218636fa91cbc4255a6f8eabcd549f3dde9';

/// The post library — the web's `/posts`.
///
/// Reads are paginated futures off the mobile API, NOT the Drift stream the
/// rest of this feature uses. The library is the server's list: it has to show
/// posts this device never created (the auto-post chain writes most of them),
/// and a local mirror would show a user an empty library on a fresh install.

abstract class _$PostLibrary extends $AsyncNotifier<PostLibraryState> {
  FutureOr<PostLibraryState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<PostLibraryState>, PostLibraryState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<PostLibraryState>, PostLibraryState>,
              AsyncValue<PostLibraryState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// One post — the web's `/posts/[id]`.
///
/// Keyed by the SERVER id. There is no variant that takes the local Drift row
/// id, deliberately: the detail screen's publish button is exactly where the
/// wrong id used to produce a silent 404.

@ProviderFor(PostDetail)
final postDetailProvider = PostDetailFamily._();

/// One post — the web's `/posts/[id]`.
///
/// Keyed by the SERVER id. There is no variant that takes the local Drift row
/// id, deliberately: the detail screen's publish button is exactly where the
/// wrong id used to produce a silent 404.
final class PostDetailProvider
    extends $AsyncNotifierProvider<PostDetail, LibraryPost> {
  /// One post — the web's `/posts/[id]`.
  ///
  /// Keyed by the SERVER id. There is no variant that takes the local Drift row
  /// id, deliberately: the detail screen's publish button is exactly where the
  /// wrong id used to produce a silent 404.
  PostDetailProvider._({
    required PostDetailFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'postDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$postDetailHash();

  @override
  String toString() {
    return r'postDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  PostDetail create() => PostDetail();

  @override
  bool operator ==(Object other) {
    return other is PostDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$postDetailHash() => r'b4fe01bb93bfca019e4af6b2badc334283397d59';

/// One post — the web's `/posts/[id]`.
///
/// Keyed by the SERVER id. There is no variant that takes the local Drift row
/// id, deliberately: the detail screen's publish button is exactly where the
/// wrong id used to produce a silent 404.

final class PostDetailFamily extends $Family
    with
        $ClassFamilyOverride<
          PostDetail,
          AsyncValue<LibraryPost>,
          LibraryPost,
          FutureOr<LibraryPost>,
          String
        > {
  PostDetailFamily._()
    : super(
        retry: null,
        name: r'postDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// One post — the web's `/posts/[id]`.
  ///
  /// Keyed by the SERVER id. There is no variant that takes the local Drift row
  /// id, deliberately: the detail screen's publish button is exactly where the
  /// wrong id used to produce a silent 404.

  PostDetailProvider call(String postId) =>
      PostDetailProvider._(argument: postId, from: this);

  @override
  String toString() => r'postDetailProvider';
}

/// One post — the web's `/posts/[id]`.
///
/// Keyed by the SERVER id. There is no variant that takes the local Drift row
/// id, deliberately: the detail screen's publish button is exactly where the
/// wrong id used to produce a silent 404.

abstract class _$PostDetail extends $AsyncNotifier<LibraryPost> {
  late final _$args = ref.$arg as String;
  String get postId => _$args;

  FutureOr<LibraryPost> build(String postId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<LibraryPost>, LibraryPost>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<LibraryPost>, LibraryPost>,
              AsyncValue<LibraryPost>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}

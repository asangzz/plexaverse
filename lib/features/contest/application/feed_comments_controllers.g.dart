// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed_comments_controllers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// `GET /contest/tasks/feed-comments` — open, done (with the links and what
/// each paid) or revoked, and the numbers the page quotes: the day's total,
/// each comment's share, and what a false claim costs.
///
/// A pure read, so unlike the comment level it is not held behind the gate:
/// the page still waits for the path before drawing the form.
///
/// Re-read when the app comes back to the foreground, as the web re-reads on
/// focus: the learner has been on LinkedIn, and a revoke or another device's
/// send reaches them by no other road.

@ProviderFor(feedComments)
final feedCommentsProvider = FeedCommentsProvider._();

/// `GET /contest/tasks/feed-comments` — open, done (with the links and what
/// each paid) or revoked, and the numbers the page quotes: the day's total,
/// each comment's share, and what a false claim costs.
///
/// A pure read, so unlike the comment level it is not held behind the gate:
/// the page still waits for the path before drawing the form.
///
/// Re-read when the app comes back to the foreground, as the web re-reads on
/// focus: the learner has been on LinkedIn, and a revoke or another device's
/// send reaches them by no other road.

final class FeedCommentsProvider
    extends
        $FunctionalProvider<
          AsyncValue<FeedCommentsView>,
          FeedCommentsView,
          FutureOr<FeedCommentsView>
        >
    with $FutureModifier<FeedCommentsView>, $FutureProvider<FeedCommentsView> {
  /// `GET /contest/tasks/feed-comments` — open, done (with the links and what
  /// each paid) or revoked, and the numbers the page quotes: the day's total,
  /// each comment's share, and what a false claim costs.
  ///
  /// A pure read, so unlike the comment level it is not held behind the gate:
  /// the page still waits for the path before drawing the form.
  ///
  /// Re-read when the app comes back to the foreground, as the web re-reads on
  /// focus: the learner has been on LinkedIn, and a revoke or another device's
  /// send reaches them by no other road.
  FeedCommentsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'feedCommentsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$feedCommentsHash();

  @$internal
  @override
  $FutureProviderElement<FeedCommentsView> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<FeedCommentsView> create(Ref ref) {
    return feedComments(ref);
  }
}

String _$feedCommentsHash() => r'23c9a5ad60f09297078252d22e1379cce51b0877';

/// Send ONE of today's comment links: `POST /contest/tasks/feed-comments`.

@ProviderFor(FeedCommentsActions)
final feedCommentsActionsProvider = FeedCommentsActionsProvider._();

/// Send ONE of today's comment links: `POST /contest/tasks/feed-comments`.
final class FeedCommentsActionsProvider
    extends $NotifierProvider<FeedCommentsActions, FeedCommentsSend> {
  /// Send ONE of today's comment links: `POST /contest/tasks/feed-comments`.
  FeedCommentsActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'feedCommentsActionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$feedCommentsActionsHash();

  @$internal
  @override
  FeedCommentsActions create() => FeedCommentsActions();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FeedCommentsSend value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FeedCommentsSend>(value),
    );
  }
}

String _$feedCommentsActionsHash() =>
    r'9adf3a0fba7cb17d8e8beddb67a75b0c1249952c';

/// Send ONE of today's comment links: `POST /contest/tasks/feed-comments`.

abstract class _$FeedCommentsActions extends $Notifier<FeedCommentsSend> {
  FeedCommentsSend build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<FeedCommentsSend, FeedCommentsSend>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<FeedCommentsSend, FeedCommentsSend>,
              FeedCommentsSend,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

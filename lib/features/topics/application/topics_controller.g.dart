// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'topics_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The user's topics.
///
/// ## The Level 5 side effect
///
/// The web fires a roadmap completion the moment the list reaches three
/// topics (`useEffect` on `topics.length`), and that tick is the whole reason
/// the goal card above the list exists. It is ported here rather than in the
/// page because it is a consequence of the DATA, not of anything being on
/// screen — a user who adds their third topic and navigates away mid-request
/// should still get the step.
///
/// It is fire-and-forget by design. The POST is idempotent server-side, so a
/// duplicate costs nothing; and a roadmap tick that failed must never surface
/// as "your topic did not save", because the topic did save.

@ProviderFor(TopicsController)
final topicsControllerProvider = TopicsControllerProvider._();

/// The user's topics.
///
/// ## The Level 5 side effect
///
/// The web fires a roadmap completion the moment the list reaches three
/// topics (`useEffect` on `topics.length`), and that tick is the whole reason
/// the goal card above the list exists. It is ported here rather than in the
/// page because it is a consequence of the DATA, not of anything being on
/// screen — a user who adds their third topic and navigates away mid-request
/// should still get the step.
///
/// It is fire-and-forget by design. The POST is idempotent server-side, so a
/// duplicate costs nothing; and a roadmap tick that failed must never surface
/// as "your topic did not save", because the topic did save.
final class TopicsControllerProvider
    extends $AsyncNotifierProvider<TopicsController, List<Topic>> {
  /// The user's topics.
  ///
  /// ## The Level 5 side effect
  ///
  /// The web fires a roadmap completion the moment the list reaches three
  /// topics (`useEffect` on `topics.length`), and that tick is the whole reason
  /// the goal card above the list exists. It is ported here rather than in the
  /// page because it is a consequence of the DATA, not of anything being on
  /// screen — a user who adds their third topic and navigates away mid-request
  /// should still get the step.
  ///
  /// It is fire-and-forget by design. The POST is idempotent server-side, so a
  /// duplicate costs nothing; and a roadmap tick that failed must never surface
  /// as "your topic did not save", because the topic did save.
  TopicsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'topicsControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$topicsControllerHash();

  @$internal
  @override
  TopicsController create() => TopicsController();
}

String _$topicsControllerHash() => r'5fc87909047c3f7df8ee050a9f480d8c190cd60e';

/// The user's topics.
///
/// ## The Level 5 side effect
///
/// The web fires a roadmap completion the moment the list reaches three
/// topics (`useEffect` on `topics.length`), and that tick is the whole reason
/// the goal card above the list exists. It is ported here rather than in the
/// page because it is a consequence of the DATA, not of anything being on
/// screen — a user who adds their third topic and navigates away mid-request
/// should still get the step.
///
/// It is fire-and-forget by design. The POST is idempotent server-side, so a
/// duplicate costs nothing; and a roadmap tick that failed must never surface
/// as "your topic did not save", because the topic did save.

abstract class _$TopicsController extends $AsyncNotifier<List<Topic>> {
  FutureOr<List<Topic>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Topic>>, List<Topic>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Topic>>, List<Topic>>,
              AsyncValue<List<Topic>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// The three AI suggestions, while the user is looking at them.

@ProviderFor(TopicSuggestions)
final topicSuggestionsProvider = TopicSuggestionsProvider._();

/// The three AI suggestions, while the user is looking at them.
final class TopicSuggestionsProvider
    extends $NotifierProvider<TopicSuggestions, TopicSuggestionsState> {
  /// The three AI suggestions, while the user is looking at them.
  TopicSuggestionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'topicSuggestionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$topicSuggestionsHash();

  @$internal
  @override
  TopicSuggestions create() => TopicSuggestions();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TopicSuggestionsState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TopicSuggestionsState>(value),
    );
  }
}

String _$topicSuggestionsHash() => r'a6f3a9a7e7243a51bdecae5fbdf41ef70410a421';

/// The three AI suggestions, while the user is looking at them.

abstract class _$TopicSuggestions extends $Notifier<TopicSuggestionsState> {
  TopicSuggestionsState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<TopicSuggestionsState, TopicSuggestionsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<TopicSuggestionsState, TopicSuggestionsState>,
              TopicSuggestionsState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

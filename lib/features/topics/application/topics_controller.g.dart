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
///
/// Held in a provider rather than in the page so a suggestion the user has
/// already paid 50 XP for survives a rebuild. It does NOT survive leaving the
/// screen, which matches the web — its `suggestedTopics` is component state and
/// the endpoint is non-deterministic, so there is nothing to restore.

@ProviderFor(TopicSuggestions)
final topicSuggestionsProvider = TopicSuggestionsProvider._();

/// The three AI suggestions, while the user is looking at them.
///
/// Held in a provider rather than in the page so a suggestion the user has
/// already paid 50 XP for survives a rebuild. It does NOT survive leaving the
/// screen, which matches the web — its `suggestedTopics` is component state and
/// the endpoint is non-deterministic, so there is nothing to restore.
final class TopicSuggestionsProvider
    extends $NotifierProvider<TopicSuggestions, List<SuggestedTopic>> {
  /// The three AI suggestions, while the user is looking at them.
  ///
  /// Held in a provider rather than in the page so a suggestion the user has
  /// already paid 50 XP for survives a rebuild. It does NOT survive leaving the
  /// screen, which matches the web — its `suggestedTopics` is component state and
  /// the endpoint is non-deterministic, so there is nothing to restore.
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
  Override overrideWithValue(List<SuggestedTopic> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<SuggestedTopic>>(value),
    );
  }
}

String _$topicSuggestionsHash() => r'85dffb4751e8dbf61c7ca9e3dad7e335ce27abf3';

/// The three AI suggestions, while the user is looking at them.
///
/// Held in a provider rather than in the page so a suggestion the user has
/// already paid 50 XP for survives a rebuild. It does NOT survive leaving the
/// screen, which matches the web — its `suggestedTopics` is component state and
/// the endpoint is non-deterministic, so there is nothing to restore.

abstract class _$TopicSuggestions extends $Notifier<List<SuggestedTopic>> {
  List<SuggestedTopic> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<List<SuggestedTopic>, List<SuggestedTopic>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<SuggestedTopic>, List<SuggestedTopic>>,
              List<SuggestedTopic>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

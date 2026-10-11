import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/topics_repositories.dart';
import '../domain/topics_repository.dart';

part 'topics_controller.g.dart';

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
@riverpod
class TopicsController extends _$TopicsController {
  /// Guards against re-firing the tick on every rebuild within one mount. Not
  /// a correctness guarantee — an invalidate builds a fresh notifier and the
  /// tick fires again — which is fine precisely because the endpoint is
  /// idempotent.
  bool _foundationSent = false;

  @override
  Future<List<Topic>> build() async {
    final List<Topic> topics = await ref
        .watch(topicsRepositoryProvider)
        .fetchTopics();
    _maybeRecordFoundation(topics.length);
    return topics;
  }

  /// Creates a topic and puts it at the head of the list.
  ///
  /// The list is patched locally rather than re-fetched, which is what the web
  /// does (`setQueryData([newTopic, ...prev])`). The server orders by
  /// `createdAt desc`, so prepending is the same order a refetch would give —
  /// without a second round-trip in front of the user's confirmation.
  Future<Topic> create({
    required String name,
    required List<String> keywords,
    String? description,
  }) async {
    final Topic created = await ref
        .read(topicsRepositoryProvider)
        .createTopic(name: name, keywords: keywords, description: description);

    final List<Topic> next = <Topic>[
      created,
      ...(state.value ?? const <Topic>[]),
    ];
    state = AsyncData<List<Topic>>(next);
    _maybeRecordFoundation(next.length);
    return created;
  }

  /// How many topics the Level 5 goal asks for. The web hardcodes 3 in both
  /// the mutation and the counter.
  static const int foundationTarget = 3;

  void _maybeRecordFoundation(int count) {
    if (_foundationSent || count < foundationTarget) return;
    _foundationSent = true;
    unawaited(_recordFoundation());
  }

  Future<void> _recordFoundation() async {
    try {
      await ref.read(topicsRepositoryProvider).recordTopicsFoundation();
    } on Object {
      // Deliberately silent. See the class doc: the user's topic is saved
      // either way, and a failed roadmap tick has no user-facing remedy.
    }
  }
}

/// The suggestions panel: the three results, and what the panel is doing.
///
/// ## Why the two flags are here and not on the page
///
/// They were `_suggesting` and `_addingName` on `_TopicsPageState`, and both
/// guard something that outlives the widget holding them:
///
///  * **`suggesting` guards 50 XP.** The suggest call is charged per press.
///    The page's `if (_suggesting) return` evaporated the moment the widget
///    was disposed, so leaving the screen mid-call and coming straight back
///    gave a live button over a call that was still running — a second 50 XP
///    for one user intent, and the screen is reached from a roadmap task, so
///    bouncing in and out of it is the normal way to use it.
///  * **`addingName` guards a write that finishes after the widget.** The add
///    was `create()` on the page, then `dismiss()` after the await; a dispose
///    in between left the topic created on the server and still sitting in the
///    suggestions panel, because `ref` throws once the widget is gone and the
///    dismiss never ran.
///
/// Both operations now run here end to end, and hold the notifier open for
/// their own duration rather than borrowing the page's lifetime.
class TopicSuggestionsState {
  const TopicSuggestionsState({
    this.items = const <SuggestedTopic>[],
    this.suggesting = false,
    this.addingName,
  });

  /// The suggestions the user is looking at. They survive a rebuild — the user
  /// has paid for them — but NOT leaving the screen, which matches the web:
  /// its `suggestedTopics` is component state and the endpoint is
  /// non-deterministic, so there is nothing to restore.
  final List<SuggestedTopic> items;

  /// True while the 50-XP suggest call is in flight.
  final bool suggesting;

  /// The name of the suggestion currently being added, so only that card's
  /// button spins. Null when none is.
  final String? addingName;

  bool isAdding(String name) => addingName == name;

  TopicSuggestionsState copyWith({
    List<SuggestedTopic>? items,
    bool? suggesting,
    String? addingName,
    bool clearAddingName = false,
  }) => TopicSuggestionsState(
    items: items ?? this.items,
    suggesting: suggesting ?? this.suggesting,
    addingName: clearAddingName ? null : (addingName ?? this.addingName),
  );
}

/// The three AI suggestions, while the user is looking at them.
@riverpod
class TopicSuggestions extends _$TopicSuggestions {
  @override
  TopicSuggestionsState build() {
    // A listen, not a watch. [add] writes through [TopicsController], and both
    // notifiers are autoDispose with the topics page as their only listener —
    // so without this, leaving the screen mid-add tears TopicsController down
    // before its `state = ...` lands and the write throws into nothing. A
    // watch would instead rebuild this state every time the topic list
    // changed, clearing `addingName` in the middle of the very add that set
    // it.
    ref.listen(topicsControllerProvider, (_, _) {});
    return const TopicSuggestionsState();
  }

  /// `POST /ai/suggest-topics`. Costs 50 XP per call.
  ///
  /// `ran` is false when a call was already in flight and this press was
  /// refused rather than charged — which the caller must be able to tell from
  /// a success, or it would announce a result nobody asked for.
  ///
  /// `error` is the failure itself, not a sentence. [TopicsUnavailable] keeps
  /// an XP shortfall, a thin profile and a model failure apart, which is a
  /// distinction the screen needs; turning it into copy is the screen's job,
  /// not this one's.
  Future<({bool ran, Object? error})> suggest() async {
    if (state.suggesting) return (ran: false, error: null);

    // Held for the length of the call. This provider is autoDispose and the
    // topics page is normally its only listener, so leaving the screen
    // mid-request would otherwise tear the notifier down before the results —
    // which the user has already been charged for — could be written back.
    // Type inferred: `KeepAliveLink` is not exported from riverpod_annotation.
    final link = ref.keepAlive();
    state = state.copyWith(suggesting: true);
    try {
      final List<SuggestedTopic> next = await ref
          .read(topicsRepositoryProvider)
          .suggestTopics();
      state = state.copyWith(items: next, suggesting: false);
      return (ran: true, error: null);
    } on Object catch (error) {
      state = state.copyWith(suggesting: false);
      return (ran: true, error: error);
    } finally {
      link.close();
    }
  }

  /// Adds one suggestion to the real list and takes it out of the panel.
  ///
  /// Both halves are here on purpose: the dismiss is what makes the add
  /// complete, and splitting it across the await boundary in a widget is what
  /// used to lose it.
  ///
  /// Reads like [suggest]: `ran` false means another add was already going and
  /// this one was dropped, exactly as the page's old guard dropped it.
  Future<({bool ran, Object? error})> add(SuggestedTopic topic) async {
    if (state.addingName != null) return (ran: false, error: null);

    final link = ref.keepAlive();
    state = state.copyWith(addingName: topic.name);
    try {
      await ref
          .read(topicsControllerProvider.notifier)
          .create(
            name: topic.name,
            keywords: topic.keywords,
            description: topic.description.isEmpty ? null : topic.description,
          );
      dismiss(topic.name);
      state = state.copyWith(clearAddingName: true);
      return (ran: true, error: null);
    } on Object catch (error) {
      state = state.copyWith(clearAddingName: true);
      return (ran: true, error: error);
    } finally {
      link.close();
    }
  }

  /// Drops one suggestion once it has been added to the real list, which is
  /// what the web does (`filter(t => t.name !== topic.name)`). Name is the key
  /// because a suggestion has no id — it has never been stored.
  void dismiss(String name) => state = state.copyWith(
    items: state.items
        .where((SuggestedTopic t) => t.name != name)
        .toList(growable: false),
  );

  /// Clears the whole panel.
  void clear() => state = state.copyWith(items: const <SuggestedTopic>[]);
}

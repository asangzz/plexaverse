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

/// The three AI suggestions, while the user is looking at them.
///
/// Held in a provider rather than in the page so a suggestion the user has
/// already paid 50 XP for survives a rebuild. It does NOT survive leaving the
/// screen, which matches the web — its `suggestedTopics` is component state and
/// the endpoint is non-deterministic, so there is nothing to restore.
@riverpod
class TopicSuggestions extends _$TopicSuggestions {
  @override
  List<SuggestedTopic> build() => const <SuggestedTopic>[];

  /// `POST /ai/suggest-topics`. Costs 50 XP per call.
  ///
  /// Rethrows [TopicsUnavailable] so the page can tell an XP shortfall from a
  /// thin profile from a model failure — three states with three different
  /// next actions, which a swallowed error would flatten into "try again".
  Future<void> suggest() async {
    state = await ref.read(topicsRepositoryProvider).suggestTopics();
  }

  /// Drops one suggestion once it has been added to the real list, which is
  /// what the web does (`filter(t => t.name !== topic.name)`). Name is the key
  /// because a suggestion has no id — it has never been stored.
  void dismiss(String name) => state = state
      .where((SuggestedTopic t) => t.name != name)
      .toList(growable: false);

  /// Clears the whole panel.
  void clear() => state = const <SuggestedTopic>[];
}

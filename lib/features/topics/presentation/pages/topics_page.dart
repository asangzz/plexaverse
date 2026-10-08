import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/ui/zave/zave_kit.dart';
import '../../application/topics_controller.dart';
import '../../domain/topics_repository.dart';
import '../widgets/create_topic_sheet.dart';
import '../widgets/suggested_topic_card.dart';
import '../widgets/topic_card.dart';
import '../widgets/topics_states.dart';

/// **Topics** — the web's `/topics`.
///
/// ## What a topic is for
///
/// Topics are the prompt seeds a **schedule** resolves when it fires. They are
/// not posts and not a plan: nothing here goes to LinkedIn. That is why the
/// screen is reached contextually (from a roadmap task or from scheduling)
/// rather than from the nav — on the web it has no sidebar entry either.
///
/// ## Two things the web does that are easy to miss
///
///  * **Suggesting costs 50 XP per press**, whether or not the user keeps any
///    of the three results. The price is in the button label for that reason.
///  * **Reaching three topics completes a roadmap step** (Level 5, Step 1).
///    The goal card above the list is the visible half of that; the POST is
///    fired by `TopicsController`, not from here, because it is a consequence
///    of the data rather than of anything being on screen.
///
/// ## The one white button
///
/// "Add Topic" is the screen's single primary action. "Suggest Topics", every
/// suggestion's "Add to My Topics", and the empty state's "Create Topic" are
/// all ghosts — the web fills all of them with indigo, which on a phone would
/// be up to five solid buttons competing at once.
class TopicsPage extends ConsumerStatefulWidget {
  const TopicsPage({super.key});

  @override
  ConsumerState<TopicsPage> createState() => _TopicsPageState();
}

class _TopicsPageState extends ConsumerState<TopicsPage> {
  /// The inline banner the web keeps at the top of the page, and the timer
  /// that clears it after three seconds (its `setTimeout(..., 3000)`).
  String? _banner;
  bool _bannerIsError = false;
  Timer? _bannerTimer;

  /// True while the 50-XP suggest call is in flight.
  bool _suggesting = false;

  /// The name of the suggestion currently being added, so only that card's
  /// button spins.
  String? _addingName;

  @override
  void dispose() {
    _bannerTimer?.cancel();
    super.dispose();
  }

  void _say(String message, {bool isError = false}) {
    if (!mounted) return;
    _bannerTimer?.cancel();
    setState(() {
      _banner = message;
      _bannerIsError = isError;
    });
    _bannerTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) setState(() => _banner = null);
    });
  }

  Future<void> _create() async {
    final NewTopicDraft? draft = await showCreateTopicSheet(context);
    if (draft == null) return;
    try {
      await ref
          .read(topicsControllerProvider.notifier)
          .create(
            name: draft.name,
            keywords: draft.keywords,
            description: draft.description,
          );
      _say('Topic created successfully!');
    } on Object {
      _say('Failed to create topic.', isError: true);
    }
  }

  Future<void> _suggest() async {
    if (_suggesting) return;
    setState(() => _suggesting = true);
    try {
      await ref.read(topicSuggestionsProvider.notifier).suggest();
    } on TopicsUnavailable catch (e) {
      // The server's own sentence is more specific than anything we could
      // compose — a thin profile, an XP shortfall and a model failure each
      // come back with their own message and their own real remedy.
      _say(e.message ?? 'Failed to suggest topics', isError: true);
    } on Object {
      _say('An unexpected error occurred.', isError: true);
    } finally {
      if (mounted) setState(() => _suggesting = false);
    }
  }

  Future<void> _addSuggested(SuggestedTopic topic) async {
    if (_addingName != null) return;
    setState(() => _addingName = topic.name);
    try {
      await ref
          .read(topicsControllerProvider.notifier)
          .create(
            name: topic.name,
            keywords: topic.keywords,
            description: topic.description.isEmpty ? null : topic.description,
          );
      ref.read(topicSuggestionsProvider.notifier).dismiss(topic.name);
      _say('Topic "${topic.name}" added!');
    } on Object {
      _say('Failed to add topic.', isError: true);
    } finally {
      if (mounted) setState(() => _addingName = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<Topic>> topics = ref.watch(topicsControllerProvider);
    final List<SuggestedTopic> suggestions = ref.watch(
      topicSuggestionsProvider,
    );

    return ZaveScaffold(
      largeTitle: 'Topics',
      subtitle: 'Topics for AI-generated content',
      // This screen has no nav entry on either platform — it is opened from a
      // roadmap task or from scheduling — so it needs the way back that a
      // tab would otherwise provide. Guarded, so it is absent if the
      // orchestrator ever parents this route inside the shell instead.
      leading: context.canPop()
          ? ZaveIconButton(
              tooltip: 'Back',
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.pop(),
            )
          : null,
      body: RefreshIndicator(
        color: ZaveColors.white,
        backgroundColor: ZaveColors.deep,
        onRefresh: () async {
          ref.invalidate(topicsControllerProvider);
          await ref.read(topicsControllerProvider.future);
        },
        child: ZaveScrollView(children: _body(topics, suggestions)),
      ),
    );
  }

  /// The Level 5 target, owned by the controller so the card and the roadmap
  /// tick can never disagree about what "enough topics" means.
  static const int _goal = TopicsController.foundationTarget;

  List<Widget> _body(
    AsyncValue<List<Topic>> topics,
    List<SuggestedTopic> suggestions,
  ) {
    final int count = topics.value?.length ?? 0;

    return <Widget>[
      // Stacked, not side by side. The web's own header is `flex flex-wrap`,
      // so this IS its narrow-width rendering — and two pills sharing a phone's
      // width would ellipsize "Suggest Topics (50 XP)" down to the point where
      // the price, which is the whole reason the label carries it, disappears.
      ZaveButton(
        label: 'Add Topic',
        kind: ZaveButtonKind.primarySmall,
        icon: const Icon(Icons.add),
        expand: true,
        onPressed: _create,
      ),
      SizedBox(height: ZaveSpace.md),
      ZaveButton(
        // The price is in the label because the press spends it, and it spends
        // it whether or not the user keeps a single suggestion.
        label: 'Suggest Topics (50 XP)',
        icon: const Icon(Icons.auto_awesome_outlined),
        expand: true,
        busy: _suggesting,
        onPressed: _suggesting ? null : _suggest,
      ),

      if (_banner != null) ...<Widget>[
        SizedBox(height: ZaveSpace.lg),
        TopicsBanner(message: _banner!, isError: _bannerIsError),
      ],

      // The goal card only exists while the goal is unmet, and it disappears
      // at the same count that fires the roadmap step. Gated on `hasValue` so
      // it does not flash "0/3" over a list that is still loading.
      if (topics.hasValue && count < _goal) ...<Widget>[
        SizedBox(height: ZaveSpace.xl),
        TopicsGoalCard(count: count, target: _goal),
      ],

      if (suggestions.isNotEmpty) ...<Widget>[
        SizedBox(height: ZaveSpace.xxl),
        Row(
          children: <Widget>[
            Expanded(child: Text('AI SUGGESTIONS', style: ZaveType.kicker)),
            // A dismiss control the web does not have, and the one addition
            // on this screen. On the web the panel is a three-column grid you
            // can scroll past in a flick; stacked on a phone it is three
            // full-width cards between the user and their actual topics, and
            // the web's only way out of it — leaving the page — costs a
            // refetch here.
            ZaveIconButton(
              tooltip: 'Dismiss suggestions',
              icon: const Icon(Icons.close),
              onPressed: () =>
                  ref.read(topicSuggestionsProvider.notifier).clear(),
            ),
          ],
        ),
        SizedBox(height: ZaveSpace.lg),
        for (final SuggestedTopic suggestion in suggestions) ...<Widget>[
          SuggestedTopicCard(
            topic: suggestion,
            busy: _addingName == suggestion.name,
            onAdd: () => _addSuggested(suggestion),
          ),
          SizedBox(height: ZaveSpace.md),
        ],
      ],

      SizedBox(height: ZaveSpace.xxl),
      ...topics.when(
        loading: () => <Widget>[const TopicsSkeleton()],
        error: (Object error, StackTrace _) => <Widget>[
          TopicsError(
            detail: error is TopicsUnavailable ? error.message : null,
            onRetry: () => ref.invalidate(topicsControllerProvider),
          ),
        ],
        data: (List<Topic> list) => list.isEmpty
            ? <Widget>[TopicsEmpty(onCreate: _create)]
            : <Widget>[
                Text('YOUR TOPICS', style: ZaveType.kicker),
                SizedBox(height: ZaveSpace.lg),
                for (final Topic topic in list) ...<Widget>[
                  TopicCard(topic: topic),
                  SizedBox(height: ZaveSpace.md),
                ],
              ],
      ),
    ];
  }
}

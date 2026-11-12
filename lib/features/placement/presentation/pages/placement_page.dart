import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show Clipboard, ClipboardData;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/links/plexaverse.dart';
import '../../../../core/platform/link_opening.dart';
import '../../../../core/router/zave_routes.dart';
import '../../../../core/ui/zave/zave_kit.dart';
import '../../../plexa/presentation/widgets/plexa_moment.dart';
import '../../application/placement_controllers.dart';
import '../../domain/placement_repository.dart';
import '../../domain/placement_words.dart';
import '../widgets/placement_intro.dart';
import '../widgets/placement_parts.dart';
import '../widgets/placement_question.dart';
import '../widgets/placement_result_view.dart';
import '../widgets/placement_writing.dart';

/// **Placement test** — the web's `/placement`.
///
/// Four screens, one at a time: intro → questions → writing → result. Which
/// one is showing, and everything in flight, lives on [PlacementFlow]; this
/// page draws it. The rules for what happens when an attempt ends under the
/// learner are that controller's — read its doc before changing a screen
/// change here.
///
/// ## No screen ever learns whether an answer was right
///
/// An item carries no key and an answer resolves to the next question. The
/// question screen has no verdict to draw and no colour to draw it in.
///
/// ## Plexa at phone width
///
/// The web hides the studying, result and wrench moments below 640 px. The
/// app is all phone, so it shows them, smaller (the plan's decision A5).
class PlacementPage extends ConsumerStatefulWidget {
  const PlacementPage({super.key});

  @override
  ConsumerState<PlacementPage> createState() => _PlacementPageState();
}

class _PlacementPageState extends ConsumerState<PlacementPage> {
  final ScrollController _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    // After the frame: a provider cannot be invalidated while the tree builds.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) ref.read(placementFlowProvider.notifier).refreshIfCached();
    });
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  /// Today's lesson takes this page's place: back from it is the contest,
  /// not a result the learner has already read.
  void _toLesson() => context.pushReplacement(ZaveRoutes.contestLesson);

  /// The privacy notice, from the consent card that refers to it. If nothing
  /// can open it, the address goes on the clipboard instead of the tap doing
  /// nothing.
  Future<void> _openPrivacy() async {
    final LinkOpenResult opened = await ref
        .read(linkOpeningProvider)
        .open(plexaversePrivacyUrl);
    if (opened is LinkOpened || !mounted) return;
    await Clipboard.setData(const ClipboardData(text: plexaversePrivacyUrl));
    if (!mounted) return;
    ScaffoldMessenger.maybeOf(context)
      ?..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: ZaveColors.deep,
          behavior: SnackBarBehavior.floating,
          content: Text(
            'Could not open the page — link copied instead.',
            style: ZaveType.body,
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    // A new screen starts at the top. The Next button sits below the fold on
    // a phone, and the next question would otherwise open scrolled past its
    // own passage.
    ref.listen<PlacementScreen>(
      placementFlowProvider.select((PlacementFlowState s) => s.screen),
      (_, _) {
        if (_scroll.hasClients && _scroll.offset > 0) _scroll.jumpTo(0);
      },
    );
    final PlacementFlowState flow = ref.watch(placementFlowProvider);
    final AsyncValue<PlacementStatus> status = ref.watch(
      placementStatusProvider,
    );
    final PlacementFlow actions = ref.read(placementFlowProvider.notifier);

    return ZaveScaffold(
      title: 'Placement test',
      body: ZaveScrollView(
        controller: _scroll,
        children: <Widget>[
          switch (flow.screen) {
            PlacementIntroScreen() => _intro(flow, status, actions),
            PlacementQuestionScreen(:final PlacementStep step) => _question(
              flow,
              step,
              actions,
            ),
            PlacementWritingScreen(
              :final String attemptId,
              :final WritingTask task,
            ) =>
              PlacementWriting(
                key: ValueKey<String>('w:$attemptId'),
                task: task,
                needsAgreement: flow.needsAgreement(status.value),
                grading: flow.work == PlacementWork.grading,
                skipping: flow.work == PlacementWork.skipping,
                checking: flow.work == PlacementWork.checking,
                // Skip only reads the stored result back; the test itself
                // is already done.
                errorTitle: flow.problem?.move == PlacementMove.skip
                    ? 'Could not show your result'
                    : 'Not graded yet',
                error: _problemOf(flow, <PlacementMove>{
                  PlacementMove.grade,
                  PlacementMove.skip,
                }),
                onGrade: actions.grade,
                onSkip: actions.skip,
                onPrivacy: _openPrivacy,
              ),
            PlacementResultScreen(:final PlacementResult result) =>
              PlacementResultView(result: result, onLesson: _toLesson),
          },
        ],
      ),
    );
  }

  Widget _intro(
    PlacementFlowState flow,
    AsyncValue<PlacementStatus> status,
    PlacementFlow actions,
  ) {
    // Back from a move that found its attempt gone, the cached status still
    // describes it as open. Drawn from that, the intro would offer a Continue
    // the server would refuse — so it waits for the read.
    if (flow.work == PlacementWork.rereading ||
        (status.isLoading && !status.hasValue && !status.hasError)) {
      return Text('Loading the placement test…', style: _meta);
    }
    final PlacementStatus? value = status.value;
    if (status.hasError || value == null) {
      final Object? error = status.error;
      return _LoadFailed(
        message: error is PlacementFailure && error.message.isNotEmpty
            ? error.message
            : 'Something went wrong while loading it.',
        retrying: status.isLoading,
        onRetry: actions.reloadStatus,
      );
    }
    return PlacementIntro(
      status: value,
      starting: flow.work == PlacementWork.starting,
      busy: flow.isBusy,
      startError: _problemOf(flow, <PlacementMove>{PlacementMove.start}),
      notice: flow.notice,
      onStart: actions.start,
      onWrite: actions.openWriting,
      onLesson: _toLesson,
      onClosePassed: actions.recheckClosed,
    );
  }

  Widget _question(
    PlacementFlowState flow,
    PlacementStep step,
    PlacementFlow actions,
  ) {
    final PublicPlacementItem? item = step.item;
    final ObjectiveSkill? skill = step.skill ?? item?.skill;
    if (item == null || skill == null) {
      // The engine ends a part whose band has run dry rather than hang on
      // it, so this should not happen. If it does, Start re-reads the
      // attempt and returns whatever step it is really on.
      return _QuestionDidNotLoad(
        busy: flow.work == PlacementWork.starting,
        error: _problemOf(flow, <PlacementMove>{PlacementMove.start}),
        onRetry: actions.start,
      );
    }
    return PlacementQuestion(
      // Attempt AND handle: a retake's first question has the same handle as
      // the last attempt's first one.
      key: ValueKey<String>('q:${step.attemptId}:${item.id}'),
      step: step,
      item: item,
      skill: skill,
      answering: flow.work == PlacementWork.answering,
      error: _problemOf(flow, <PlacementMove>{PlacementMove.answer}),
      notice: flow.newAttemptId == step.attemptId ? newAttemptNotice : null,
      onAnswer: actions.answer,
    );
  }
}

/// The last failure, when it belongs to one of [moves] — each screen says
/// only its own.
String? _problemOf(PlacementFlowState flow, Set<PlacementMove> moves) {
  final PlacementProblem? problem = flow.problem;
  return problem != null && moves.contains(problem.move)
      ? problem.message
      : null;
}

/// The status could not be read. A way forward on every failure: try again
/// in place.
class _LoadFailed extends StatelessWidget {
  const _LoadFailed({
    required this.message,
    required this.retrying,
    required this.onRetry,
  });

  final String message;
  final bool retrying;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => ZaveCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const PlacementDotLine('Could not load the placement test'),
                  SizedBox(height: ZaveSpace.xs),
                  Text(message, style: _meta),
                ],
              ),
            ),
            SizedBox(width: ZaveSpace.md),
            const PlexaMoment(PlexaMomentClip.oopsWrench, width: 96),
          ],
        ),
        SizedBox(height: ZaveSpace.lg),
        ZaveButton(label: 'Try again', busy: retrying, onPressed: onRetry),
      ],
    ),
  );
}

class _QuestionDidNotLoad extends StatelessWidget {
  const _QuestionDidNotLoad({
    required this.busy,
    required this.error,
    required this.onRetry,
  });

  final bool busy;
  final String? error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => ZaveCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            const Expanded(
              child: PlacementDotLine('This question did not load'),
            ),
            SizedBox(width: ZaveSpace.md),
            const PlexaMoment(PlexaMomentClip.oopsWrench, width: 96),
          ],
        ),
        SizedBox(height: ZaveSpace.lg),
        ZaveButton(label: 'Try again', busy: busy, onPressed: onRetry),
        PlacementErrorLine(title: 'Could not continue', message: error),
      ],
    ),
  );
}

TextStyle get _meta => ZaveType.caption.copyWith(height: 1.6);

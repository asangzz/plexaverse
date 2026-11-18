import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/zave_routes.dart';
import '../../../../core/ui/zave/zave_kit.dart';
import '../../../plexa/presentation/widgets/plexa_moment.dart';
import '../../../plexa/presentation/widgets/quiz_plexa.dart';
import '../../application/contest_controllers.dart';
import '../../application/lesson_controllers.dart';
import '../../application/skip_controllers.dart';
import '../../domain/contest_dates.dart';
import '../../domain/contest_repository.dart';
import '../../domain/contest_words.dart';
import '../../domain/lesson_parts.dart';
import '../widgets/contest_kit.dart';
import '../widgets/lesson/checkpoint_view.dart';
import '../widgets/lesson/lesson_question.dart';
import '../widgets/lesson/lesson_score.dart';
import '../widgets/lesson/lesson_shell.dart';
import '../widgets/lesson/lesson_steps.dart';
import '../widgets/lesson/lesson_summary.dart';
import '../widgets/lesson/skipped_parts.dart';

/// **Today's lesson** — the web's `/contest/lesson` (`ContestQuiz.tsx`).
///
/// The contest's set questions for the learner's band (10 a day for contests
/// from 11 Nov 2026, 5 for the one running then) and five written for their
/// own work, interleaved by the server — the page counts whatever it is
/// sent. Everything this page decides is on [LessonRun]; read its doc before
/// changing what happens when.
///
/// ## The screens
///
/// The outline while the lesson is opened; "Could not load today’s lesson";
/// the status screens when there is nothing to answer (no contest, not
/// joined, not started, ended, no lesson today); and, once there is a
/// lesson: one question at a time, a checkpoint between parts, the parked
/// screen when every part left is skipped, and the score.
///
/// ## `?part=k`
///
/// A skipped part's node opens `/contest/lesson?part=k` (17 Nov 2026): the
/// visit starts on that part when it is open or skipped, else where a plain
/// visit would.
///
/// ## No Zave header
///
/// The question is a full-screen player with its own ✕, as on the web, and
/// every other screen here leads home by the contest's own "Back to the
/// contest" or its white pill. A `ZaveScaffold` would add a back arrow over
/// both — two ways out stacked — so the page paints the contest's ground on
/// a bare `Scaffold`, as the Plexa journey does for its own top row.
class ContestLessonPage extends ConsumerStatefulWidget {
  const ContestLessonPage({this.part, super.key});

  /// The part asked for, 1-based — `?part=k`. Null for a plain visit.
  final int? part;

  @override
  ConsumerState<ContestLessonPage> createState() => _ContestLessonPageState();
}

class _ContestLessonPageState extends ConsumerState<ContestLessonPage> {
  @override
  void initState() {
    super.initState();
    ref.read(lessonRunProvider.notifier).request(widget.part);
  }

  @override
  void didUpdateWidget(ContestLessonPage old) {
    super.didUpdateWidget(old);
    if (old.part != widget.part) {
      ref.read(lessonRunProvider.notifier).request(widget.part);
    }
  }

  @override
  Widget build(BuildContext context) {
    // The standing and the path re-read when the app comes back — the score
    // and its next level read both.
    ref.watch(contestResumeRefreshProvider);
    final LessonRunState run = ref.watch(lessonRunProvider);
    final LessonRun actions = ref.read(lessonRunProvider.notifier);
    void quit() => context.go(ZaveRoutes.contest);

    final TodayQuiz? quiz = run.quiz;
    final Widget screen;
    if (quiz == null) {
      final String? failed = run.loadError;
      screen = failed == null
          ? LessonSkeleton(
              label: run.work == LessonWork.opening
                  ? 'Getting today’s lesson ready'
                  : 'Loading today’s lesson',
              onQuit: quit,
            )
          : _Unloaded(message: failed, onRetry: actions.retry);
    } else if (!quiz.isReady || run.questions.isEmpty) {
      screen = _NothingToAnswer(quiz: quiz);
    } else {
      screen = switch (run.at) {
        AtScore() => _Score(
          run: run,
          onGo: (int i) => actions.go(AtQuestion(i)),
        ),
        AtParked() => _Parked(run: run, actions: actions),
        AtQuestion(:final int index) => _Player(
          run: run,
          index: index,
          actions: actions,
          onQuit: quit,
          cooling: ref.watch(skipCooldownProvider),
        ),
      };
    }

    return ContestGround(
      child: Scaffold(backgroundColor: Colors.transparent, body: screen),
    );
  }
}

/// A question, with the checkpoint over it when one is up.
class _Player extends StatelessWidget {
  const _Player({
    required this.run,
    required this.index,
    required this.actions,
    required this.onQuit,
    required this.cooling,
  });

  final LessonRunState run;
  final int index;
  final LessonRun actions;
  final VoidCallback onQuit;

  /// The shared double-tap guard is cooling down after a skip.
  final bool cooling;

  @override
  Widget build(BuildContext context) {
    final LessonPart? checkpoint = run.shownCheckpoint;
    final List<PublicQuizItem> questions = run.questions;
    final List<LessonPart> parts = lessonPartBounds(questions.length);
    final bool canSkip =
        run.quiz?.dayKey != null && !cooling && run.work == null;

    Future<void> skip(int k) async {
      final String? route = await actions.skipPart(k);
      if (route != null && context.mounted) context.go(route);
    }

    // "Skip this part": only on the open part, before the question is
    // answered, with nothing in flight, and not just after a skip.
    final LessonPartView? here = run.partAt(index);
    final bool skipHere =
        canSkip &&
        checkpoint == null &&
        here != null &&
        here.state == LessonPartState.today &&
        !run.answers.containsKey(questions[index].id);

    // Not keyed per question — see [LessonQuestion].
    final Widget question = LessonQuestion(
      run: run,
      index: index,
      onPick: actions.pick,
      onCheck: actions.answer,
      onNext: actions.next,
      onGo: (int i) => actions.go(AtQuestion(i)),
      onQuit: onQuit,
      onSkipPart: skipHere ? () => skip(here.index + 1) : null,
    );
    if (checkpoint == null) return question;
    final bool nextOpen =
        checkpoint.index + 1 < run.partStates.length &&
        run.partStates[checkpoint.index + 1].state == LessonPartState.today;

    return Stack(
      children: <Widget>[
        // Inert under the checkpoint: it is a modal, and nothing behind it
        // may take a tap or be read out.
        ExcludeSemantics(child: IgnorePointer(child: question)),
        Positioned.fill(
          child: CheckpointView(
            part: checkpoint.index + 1,
            parts: parts.length,
            right: questions
                .sublist(checkpoint.start, checkpoint.end)
                .where(
                  (PublicQuizItem q) => run.answers[q.id]?.correct ?? false,
                )
                .length,
            size: checkpoint.size,
            nextSize: parts[checkpoint.index + 1].size,
            progress: questions.isEmpty ? 0 : checkpoint.end / questions.length,
            onContinue: actions.next,
            onQuit: onQuit,
            onSkipNext: canSkip && nextOpen
                ? () => skip(checkpoint.index + 2)
                : null,
            skipping: run.work == LessonWork.skipping,
          ),
        ),
      ],
    );
  }
}

/// The day, finished: Plexa's reaction, the steps to reopen any answer, and
/// the score.
class _Score extends StatelessWidget {
  const _Score({required this.run, required this.onGo});

  final LessonRunState run;
  final ValueChanged<int> onGo;

  @override
  Widget build(BuildContext context) {
    final TodayQuiz quiz = run.quiz!;
    final List<PublicQuizItem> questions = run.questions;
    final int total = questions.length;
    final int correct = run.correctCount;
    final List<LessonLearnt> learnt = <LessonLearnt>[
      for (final PublicQuizItem q in questions)
        if (run.answers[q.id] case final LessonAnswer a) LessonLearnt(q, a),
    ];
    final int? day = quiz.day;
    final String? band = quiz.band;

    return _Page(
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Expanded(
              child: Text(
                '${day == null ? 'Today’s lesson' : 'Day ${formatCount(day)} lesson'}'
                '${band == null || band.isEmpty ? '' : ' · $band'}',
                style: ContestType.meta,
              ),
            ),
            SizedBox(width: ZaveSpace.md),
            // On the score she reacts whatever this visit showed: the score
            // is the reaction's whole point.
            QuizPlexa(
              take: 'score',
              mood: total > 0 && correct * 2 >= total
                  ? QuizMood.correct
                  : QuizMood.wrong,
              react: true,
              height: 112,
            ),
          ],
        ),
        SizedBox(height: ZaveSpace.lg),
        LessonSteps(
          questions: questions,
          answers: run.answers,
          at: run.at,
          isReachable: run.isReachable,
          locked: run.isBusy,
          onGo: onGo,
        ),
        SizedBox(height: ZaveSpace.xxl),
        LessonScore(
          quiz: quiz,
          total: total,
          rightCount: correct,
          answers: <LessonAnswer>[
            for (final LessonLearnt l in learnt) l.answer,
          ],
          learnt: learnt,
        ),
      ],
    );
  }
}

/// Every part left is skipped and none was asked for: what is still open,
/// each skipped part, and the next level.
class _Parked extends StatelessWidget {
  const _Parked({required this.run, required this.actions});

  final LessonRunState run;
  final LessonRun actions;

  @override
  Widget build(BuildContext context) {
    final List<int> skipped = <int>[
      for (final LessonPartView p in run.partStates)
        if (p.state == LessonPartState.skipped) p.index + 1,
    ];
    return _Page(
      children: <Widget>[
        const Align(alignment: Alignment.centerLeft, child: BackToPath()),
        SizedBox(height: ZaveSpace.lg),
        LessonSteps(
          questions: run.questions,
          answers: run.answers,
          at: run.at,
          isReachable: run.isReachable,
          locked: run.isBusy,
          onGo: (int i) => actions.go(AtQuestion(i)),
        ),
        SizedBox(height: ZaveSpace.xl),
        SkippedPartsView(
          parts: skipped,
          onDo: (int k) {
            if (k < 1 || k > run.partStates.length) return;
            final int? i = run.firstOpenIn(run.partStates[k - 1]);
            if (i != null) actions.go(AtQuestion(i));
          },
        ),
      ],
    );
  }
}

/// A quiz with nothing to answer: no contest, not joined, not started,
/// ended, or no lesson today. The web's `STATUS_WORDS`, verbatim.
class _NothingToAnswer extends StatelessWidget {
  const _NothingToAnswer({required this.quiz});

  final TodayQuiz quiz;

  @override
  Widget build(BuildContext context) {
    // A ready lesson with no questions, or a status this build does not
    // know, reads as the quietest one.
    final (String title, String? line) = switch (quiz.status) {
      QuizStatus.noContest => (
        'No contest right now',
        'The daily lesson runs inside a contest. The next one will show up on the contest page.',
      ),
      QuizStatus.notJoined => ('Join the contest first', null),
      QuizStatus.upcoming => (
        'Not open yet',
        'The daily lesson opens on day 1 of the contest.',
      ),
      QuizStatus.ended => (
        'The contest has ended',
        'The daily lesson closed with it. The final standings are on the contest page.',
      ),
      QuizStatus.noQuizToday ||
      QuizStatus.ready => ('No lesson today', noQuizLine(quiz)),
    };
    final bool notJoined = quiz.status == QuizStatus.notJoined;

    return _Page(
      children: <Widget>[
        const Align(alignment: Alignment.centerLeft, child: BackToPath()),
        SizedBox(height: ZaveSpace.xl),
        Semantics(
          header: true,
          child: Text(title, style: ContestType.pageTitle),
        ),
        SizedBox(height: ZaveSpace.md),
        if (notJoined)
          const _NotJoinedLine()
        else
          Text(line ?? noQuizLine(quiz), style: ContestType.lead),
        if (notJoined) ...<Widget>[
          SizedBox(height: ZaveSpace.xl),
          _Hug(
            ContestGhostPill(
              label: 'See the contest',
              onPressed: () => context.go(ZaveRoutes.contest),
            ),
          ),
        ],
      ],
    );
  }
}

/// Why someone who has not joined cannot take the lesson, and when they
/// could.
///
/// "Opens straight away" is true only of a running contest; a non-entrant of
/// one that has not started is sent here too (the server answers not_joined
/// before it looks at the phase). The lesson read does not carry the phase,
/// so the overview — the contest page's own read — decides.
class _NotJoinedLine extends ConsumerWidget {
  const _NotJoinedLine();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ContestOverview? overview = ref.watch(contestOverviewProvider).value;
    String line = 'The daily lesson is for entrants, and joining is free.';
    if (overview?.phase == ContestPhase.running) {
      line =
          'The daily lesson is for entrants. Joining is free, and the lesson opens straight away.';
    } else if (overview != null && overview.phase == ContestPhase.upcoming) {
      // Day 1's calendar date as the contest counts it — never the start
      // instant through this phone's clock, which reads a day early west of
      // the contest's timezone.
      final String starts = dayKeyShort(overview.contest.firstDayKey);
      line =
          'The daily lesson is for entrants. Joining is free, and the lesson opens on day 1 of the contest${starts.isEmpty ? '' : ', $starts'}.';
    }
    return Text(line, style: ContestType.lead);
  }
}

/// The lesson could not be read at all.
class _Unloaded extends StatelessWidget {
  const _Unloaded({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return _Page(
      children: <Widget>[
        const Align(alignment: Alignment.centerLeft, child: BackToPath()),
        SizedBox(height: ZaveSpace.xl),
        Semantics(
          liveRegion: true,
          child: ContestPanel(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const ContestDot(
                        tone: ContestTone.idle,
                        label: 'Could not load today’s lesson',
                      ),
                      SizedBox(height: ZaveSpace.sm),
                      Text(message, style: ContestType.meta),
                    ],
                  ),
                ),
                SizedBox(width: ZaveSpace.md),
                const PlexaMoment(PlexaMomentClip.oopsWrench, width: 96),
              ],
            ),
          ),
        ),
        SizedBox(height: ZaveSpace.lg),
        // The web says "Refresh the page"; a phone has no page to refresh,
        // so the way forward is here.
        _Hug(ContestGhostPill(label: 'Try again', onPressed: onRetry)),
      ],
    );
  }
}

/// A pill at its own width, at the start of the line — the web's inline
/// pill. Given the column's width, the kit's pill stretches across it, and in
/// a Row its label's Flexible has no width to flex in.
class _Hug extends StatelessWidget {
  const _Hug(this.child);

  final Widget child;

  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.centerLeft,
    child: IntrinsicWidth(child: child),
  );
}

/// A screen on the contest's ground: the gutter, the web's 720 px column,
/// and room to scroll.
class _Page extends StatelessWidget {
  const _Page({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          ZaveSpace.gutter,
          ZaveSpace.xl,
          ZaveSpace.gutter,
          ZaveSpace.section,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: children,
            ),
          ),
        ),
      ),
    );
  }
}

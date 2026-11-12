import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/responsive/screen_util.dart';
import '../../../../../core/router/zave_routes.dart';
import '../../../../../core/ui/zave/zave_kit.dart';
import '../../../../plexa/presentation/widgets/plexa_moment.dart';
import '../../../application/contest_controllers.dart';
import '../../../application/lesson_controllers.dart';
import '../../../domain/contest_repository.dart';
import '../../../domain/contest_words.dart';
import '../contest_kit.dart';
import 'lesson_summary.dart';

/// Today's lesson, finished — the web's `Score` in `ContestQuiz.tsx`.
///
/// ## Two XP figures, on purpose
///
/// "XP from today’s lesson" is the lesson read's `score.points`: each
/// answer's own event and the finishing bonus. The finishing answer's reply
/// said more — it also carried the day credit and the week's bonus — and the
/// two do not match. That is the web's screen too (the plan's A15), kept
/// rather than quietly fixed on one platform.
///
/// ## What was paid is the ledger's, not the pause's
///
/// Each answer carries what the ledger paid it. "Not scored" is said only of
/// answers the ledger holds nothing for — never read off whether scoring is
/// paused NOW: a lesson paid at 09:00 and reread after the free days ran out
/// at 15:00 still shows its XP.
///
/// ## The streak is the overview's
///
/// Finishing the lesson is what keeps the streak, and the last answer
/// re-read the overview. Until that read is in, nothing is said: a stale 0
/// would read as a broken streak at the moment the learner kept it.
class LessonScore extends ConsumerWidget {
  const LessonScore({
    required this.quiz,
    required this.total,
    required this.rightCount,
    required this.answers,
    required this.learnt,
    super.key,
  });

  final TodayQuiz quiz;
  final int total;

  /// Right answers, by the server's verdicts.
  final int rightCount;

  /// Every answer, in lesson order.
  final List<LessonAnswer> answers;
  final List<LessonLearnt> learnt;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int? streak = ref.watch(contestOverviewProvider).value?.entry?.streak;
    final WeekReward? weekReward = ref
        .watch(contestPathProvider)
        .value
        ?.weekReward;

    // The server's figure knows the finishing bonus and any penalty the floor
    // at zero absorbed. Until the read after the last answer lands, the count
    // of right answers is already true and the figure waits.
    final QuizScore? score = quiz.score;
    final int? points = quiz.completed && score != null ? score.points : null;
    final String? tomorrow = tomorrowLine(quiz);
    final FinishBonus? finish = quiz.finishBonus;
    // Said beside the figure, so a total without the bonus does not read as
    // the bonus having gone missing.
    final FinishBonus? missed =
        finish != null && finish.points > 0 && rightCount < finish.minCorrect
        ? finish
        : null;
    final int unscored = answers
        .where((LessonAnswer a) => a.pointsApplied == null)
        .length;
    final bool noneScored = answers.isNotEmpty && unscored == answers.length;
    // The week's bonus: this visit's reply when the last answer completed
    // the week; on a reload, the path's word for the week. Only today's
    // finish can complete the week shown, so an earned week here is today's
    // doing.
    int? replyWeek;
    for (final LessonAnswer a in answers) {
      if (a.weekBonus != null) {
        replyWeek = a.weekBonus;
        break;
      }
    }
    final bool weekDone =
        replyWeek != null || (quiz.completed && (weekReward?.earned ?? false));
    final int? weekPaid = replyWeek ?? weekReward?.paid;
    // Plexa cheers a finish that cleared the bonus bar (3 right when the
    // contest sets none). Below it, the screen stays as it was.
    final bool cheer = rightCount >= (finish?.minCorrect ?? 3);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const ContestKicker('Today’s lesson · done'),
                  SizedBox(height: ZaveSpace.md),
                  Semantics(
                    header: true,
                    child: Text(
                      '${formatCount(rightCount)} of ${formatCount(total)} right',
                      style: ContestType.pageTitle,
                    ),
                  ),
                ],
              ),
            ),
            if (cheer) ...<Widget>[
              SizedBox(width: ZaveSpace.md),
              const PlexaMoment(PlexaMomentClip.quizScore, width: 120),
            ],
          ],
        ),
        SizedBox(height: ZaveSpace.xl),
        if (noneScored)
          _NotScored(paused: quiz.scoringPaused)
        else
          _LessonXp(points: points, missed: missed, unscored: unscored),
        if (weekDone) ...<Widget>[
          SizedBox(height: ZaveSpace.lg),
          _WeekComplete(paid: weekPaid, paused: quiz.scoringPaused),
        ],
        if (quiz.completed && streak != null && streak > 0) ...<Widget>[
          SizedBox(height: ZaveSpace.xl),
          Text(
            'Day ${formatCount(streak)} streak',
            style: GoogleFonts.manrope(
              fontSize: 20.sp,
              fontWeight: FontWeight.w800,
              color: ZaveColors.white,
            ),
          ),
        ],
        if (learnt.isNotEmpty) ...<Widget>[
          SizedBox(height: ZaveSpace.xl),
          LessonSummary(learnt: learnt),
        ],
        SizedBox(height: ZaveSpace.xl),
        const NextLevelPill(from: PathNodeKind.lesson, expand: true),
        SizedBox(height: ZaveSpace.md),
        Text(
          '${tomorrow == null ? '' : '$tomorrow '}'
          'Pick a question above to read its answer again.',
          style: ContestType.meta.copyWith(height: 1.6),
        ),
      ],
    );
  }
}

class _LessonXp extends StatelessWidget {
  const _LessonXp({
    required this.points,
    required this.missed,
    required this.unscored,
  });

  /// Null until the read after the last answer is in.
  final int? points;
  final FinishBonus? missed;
  final int unscored;

  @override
  Widget build(BuildContext context) {
    final int? p = points;
    final FinishBonus? bonus = missed;
    return ContestPanel(
      padding: EdgeInsets.all(ZaveSpace.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('XP from today’s lesson', style: ContestType.meta),
          if (p == null) ...<Widget>[
            SizedBox(height: ZaveSpace.md),
            Semantics(
              liveRegion: true,
              child: Text('Adding it up…', style: ContestType.meta),
            ),
          ] else ...<Widget>[
            SizedBox(height: ZaveSpace.sm),
            Semantics(
              label: contestXp(p),
              excludeSemantics: true,
              child: Text(
                signed(p),
                style: GoogleFonts.manrope(
                  fontSize: 56.sp,
                  fontWeight: FontWeight.w800,
                  height: 1,
                  letterSpacing: -0.04 * 56.sp,
                  color: ContestColors.amber,
                  fontFeatures: const <FontFeature>[
                    FontFeature.tabularFigures(),
                  ],
                ),
              ),
            ),
          ],
          if (bonus != null) ...<Widget>[
            SizedBox(height: ZaveSpace.md),
            Text(
              'No bonus for finishing today: it needs '
              '${formatCount(bonus.minCorrect)} right.',
              style: ContestType.meta,
            ),
          ],
          if (unscored > 0) ...<Widget>[
            SizedBox(height: ZaveSpace.md),
            Text(
              '${formatCount(unscored)} of these answers came while your '
              'scoring was paused and earned nothing.',
              style: ContestType.meta,
            ),
          ],
        ],
      ),
    );
  }
}

/// Every answer of the day came while scoring was paused.
class _NotScored extends StatelessWidget {
  const _NotScored({required this.paused});

  /// Still paused: a plan would score the NEXT answers, so say where plans
  /// are.
  final bool paused;

  @override
  Widget build(BuildContext context) {
    return ContestPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const ContestDot(tone: ContestTone.waiting, label: 'Not scored'),
          SizedBox(height: ZaveSpace.xs),
          Text(
            kQuizUnscoredLine,
            style: ZaveType.body.copyWith(
              fontSize: 16.sp,
              height: 1.6,
              color: ZaveColors.ink85,
            ),
          ),
          if (paused) ...<Widget>[
            SizedBox(height: ZaveSpace.lg),
            ContestGhostPill(
              label: 'See plans',
              onPressed: () => context.push(ZaveRoutes.pricing),
            ),
          ],
        ],
      ),
    );
  }
}

/// This finish completed the contest week.
class _WeekComplete extends StatelessWidget {
  const _WeekComplete({required this.paid, required this.paused});

  final int? paid;
  final bool paused;

  @override
  Widget build(BuildContext context) {
    final int? p = paid;
    final bool earnedNothing = (p == null || p == 0) && paused;
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: ZaveGlass.rest,
        border: Border.all(color: ContestColors.amber.withValues(alpha: 0.55)),
        borderRadius: ZaveRadius.cardMdBr,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: ContestColors.amber.withValues(alpha: 0.18),
            blurRadius: 26,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Week complete!${p == null || p == 0 ? '' : ' +${formatCount(p)} XP'}',
            style: GoogleFonts.manrope(
              fontSize: 22.sp,
              fontWeight: FontWeight.w800,
              color: ContestColors.amber,
            ),
          ),
          SizedBox(height: ZaveSpace.xs),
          Text(
            earnedNothing
                ? 'You finished every day’s lesson this week. It came while your scoring was paused, so it earned nothing.'
                : 'You finished every day’s lesson this week.',
            style: ContestType.meta,
          ),
        ],
      ),
    );
  }
}

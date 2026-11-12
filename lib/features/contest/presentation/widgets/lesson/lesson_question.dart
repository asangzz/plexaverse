import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/responsive/screen_util.dart';
import '../../../../../core/ui/zave/zave_kit.dart';
import '../../../../plexa/presentation/widgets/quiz_plexa.dart';
import '../../../application/lesson_controllers.dart';
import '../../../domain/contest_repository.dart';
import '../../../domain/lesson_parts.dart';
import '../contest_kit.dart';
import 'choice_view.dart';
import 'lesson_shell.dart';
import 'lesson_steps.dart';

/// One question of today's lesson, in the player's room — the web's
/// `ContestQuizQuestion.tsx`.
///
/// A question written for the learner's own work (an `ai-` id) carries a
/// small "For your work" tag and nothing louder: it is the same kind of
/// question, scored the same way, and the tag only says why it mentions
/// their field.
///
/// ## Not rebuilt per question
///
/// The page must not key this by question: Plexa, in its header, plays the
/// whole lesson as one take (`QuizPlexa`), and a new key would start her
/// over on every question. What does change per question is the scroll —
/// each one opens at the top.
class LessonQuestion extends StatefulWidget {
  const LessonQuestion({
    required this.run,
    required this.index,
    required this.onPick,
    required this.onCheck,
    required this.onNext,
    required this.onGo,
    required this.onQuit,
    super.key,
  });

  final LessonRunState run;

  /// The question on screen, 0-based.
  final int index;
  final ValueChanged<String> onPick;
  final ValueChanged<String> onCheck;
  final VoidCallback onNext;
  final ValueChanged<int> onGo;
  final VoidCallback onQuit;

  @override
  State<LessonQuestion> createState() => _LessonQuestionState();
}

class _LessonQuestionState extends State<LessonQuestion> {
  final ScrollController _scroll = ScrollController();

  @override
  void didUpdateWidget(LessonQuestion old) {
    super.didUpdateWidget(old);
    if (old.index != widget.index && _scroll.hasClients) _scroll.jumpTo(0);
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final LessonRunState run = widget.run;
    final List<PublicQuizItem> questions = run.questions;
    final int total = questions.length;
    final PublicQuizItem item = questions[widget.index];
    final LessonAnswer? answer = run.answers[item.id];
    final String? picked = run.pickFor(item.id);
    final bool sending = run.work == LessonWork.answering;
    final String? refusal = run.problemFor(item.id);
    final LessonPart? part = partOf(widget.index, total);
    final int parts = lessonPartBounds(total).length;
    final String? passage = item.passage;

    final String kicker = <String>[
      item.skill.label,
      'Question ${widget.index + 1} of $total',
      if (part != null && parts > 1) 'Part ${part.index + 1} of $parts',
    ].join(' · ');

    return ColoredBox(
      color: LessonColors.room,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: <Widget>[
            LessonHeader(
              progress: total == 0
                  ? 0
                  : (widget.index + (answer == null ? 0 : 1)) / total,
              streak: run.rightInARow(widget.index),
              onQuit: widget.onQuit,
            ),
            Expanded(
              child: SingleChildScrollView(
                controller: _scroll,
                padding: EdgeInsets.fromLTRB(
                  ZaveSpace.gutter,
                  ZaveSpace.lg,
                  ZaveSpace.gutter,
                  ZaveSpace.xl,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    LessonSteps(
                      questions: questions,
                      answers: run.answers,
                      at: run.at,
                      firstUnanswered: run.firstUnanswered,
                      locked: run.isBusy,
                      onGo: widget.onGo,
                    ),
                    SizedBox(height: ZaveSpace.lg),
                    // A live region that is always there, so the line is
                    // announced when it appears.
                    Semantics(
                      liveRegion: true,
                      child: run.redrawn
                          ? Padding(
                              padding: EdgeInsets.only(bottom: ZaveSpace.lg),
                              child: const ContestDot(
                                tone: ContestTone.idle,
                                label:
                                    'Your questions were updated for your level.',
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                    if ((run.quiz?.scoringPaused ?? false) &&
                        answer == null) ...<Widget>[
                      const PausedScoringBanner(),
                      SizedBox(height: ZaveSpace.lg),
                    ],
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              if (item.isOwn) ...<Widget>[
                                const _ForYourWork(),
                                SizedBox(height: ZaveSpace.sm),
                              ],
                              Text(
                                kicker.toUpperCase(),
                                style: GoogleFonts.manrope(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.14 * 11.sp,
                                  color: ZaveColors.ink35,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: ZaveSpace.md),
                        QuizPlexa(
                          take: item.id,
                          mood: answer == null
                              ? QuizMood.inspect
                              : (answer.correct
                                    ? QuizMood.correct
                                    : QuizMood.wrong),
                        ),
                      ],
                    ),
                    SizedBox(height: ZaveSpace.md),
                    if (passage != null && passage.isNotEmpty) ...<Widget>[
                      Semantics(
                        label: 'Passage',
                        container: true,
                        child: Container(
                          padding: EdgeInsets.all(20.r),
                          decoration: BoxDecoration(
                            color: ZaveColors.white.withValues(alpha: 0.03),
                            border: Border.all(
                              color: ZaveColors.white.withValues(alpha: 0.1),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            passage,
                            style: ZaveType.body.copyWith(
                              fontSize: 15.sp,
                              height: 1.6,
                              color: LessonColors.passage,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: ZaveSpace.xl),
                    ],
                    ChoiceView(
                      prompt: item.prompt,
                      options: item.options,
                      picked: picked,
                      verdict: answer,
                      onPick: sending ? null : widget.onPick,
                    ),
                    if (refusal != null) ...<Widget>[
                      SizedBox(height: ZaveSpace.lg),
                      Semantics(
                        liveRegion: true,
                        child: Text(
                          refusal,
                          style: ZaveType.body.copyWith(
                            fontSize: 13.sp,
                            color: LessonColors.refusal,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            LessonResultBar(
              verdict: answer == null
                  ? null
                  : LessonVerdict(
                      correct: answer.correct,
                      explain: answer.explain,
                      solution: answer.correctOption,
                    ),
              checking: sending,
              canCheck: picked != null && !sending,
              onCheck: () {
                if (picked != null) widget.onCheck(picked);
              },
              onContinue: widget.onNext,
              isLast: run.nextFrom(widget.index) is AtScore,
              footnote: answer == null ? null : lessonPointsLine(answer),
            ),
          ],
        ),
      ),
    );
  }
}

/// The tag on a question written for the learner's own work.
class _ForYourWork extends StatelessWidget {
  const _ForYourWork();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
      decoration: BoxDecoration(
        borderRadius: ZaveRadius.pillBr,
        border: Border.all(color: ZaveGlass.restBorder),
      ),
      child: Text(
        'For your work',
        style: GoogleFonts.manrope(
          fontSize: 11.sp,
          fontWeight: FontWeight.w700,
          color: ContestColors.peri,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/ui/app_icons.dart';
import '../../../../../core/ui/zave/zave_kit.dart';
import '../../../application/lesson_controllers.dart';
import '../../../domain/contest_repository.dart';
import '../contest_kit.dart';

/// The day's questions as a row of numbered circles — the web's `Steps`.
///
/// Answered ones show ✓ or ✕ and open again, revealed, with their verdict and
/// explanation: on a resume, or from the score. Questions not reached yet
/// cannot be opened — one at a time is the format — so only the answered
/// ones and the first unanswered one take a tap.
///
/// A shape as well as a colour, so right and wrong part for anyone who
/// cannot tell green from red.
class LessonSteps extends StatelessWidget {
  const LessonSteps({
    required this.questions,
    required this.answers,
    required this.at,
    required this.firstUnanswered,
    required this.locked,
    required this.onGo,
    super.key,
  });

  final List<PublicQuizItem> questions;
  final Map<String, LessonAnswer> answers;
  final LessonAt at;
  final int? firstUnanswered;

  /// While an answer is being sent: the screen must stay on the question it
  /// belongs to.
  final bool locked;
  final ValueChanged<int> onGo;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label: 'Questions',
      child: Wrap(
        spacing: 6,
        runSpacing: 6,
        children: <Widget>[
          for (int i = 0; i < questions.length; i++)
            _Step(
              number: i + 1,
              answer: answers[questions[i].id],
              here: at == AtQuestion(i),
              reachable:
                  answers.containsKey(questions[i].id) || i == firstUnanswered,
              onTap: locked ? null : () => onGo(i),
            ),
        ],
      ),
    );
  }
}

class _Step extends StatelessWidget {
  const _Step({
    required this.number,
    required this.answer,
    required this.here,
    required this.reachable,
    required this.onTap,
  });

  final int number;
  final LessonAnswer? answer;
  final bool here;
  final bool reachable;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final LessonAnswer? a = answer;
    final (Color fill, Color border, Color ink) = here
        ? (ZaveGlass.now, ZaveGlass.nowBorder, ZaveColors.white)
        : a == null
        ? (
            Colors.transparent,
            reachable ? ZaveGlass.hoverBorder : ZaveGlass.restBorder,
            reachable ? ZaveColors.white : ZaveColors.ink35,
          )
        : a.correct
        ? (Colors.transparent, ZaveColors.green, ContestColors.mint)
        : (Colors.transparent, ContestColors.wrongDot, ContestColors.wrongText);
    final String word = a == null
        ? (reachable ? 'to answer' : 'not reached yet')
        : (a.correct ? 'right' : 'wrong');
    final bool enabled = reachable && onTap != null;

    return Semantics(
      button: true,
      enabled: enabled,
      selected: here,
      label: 'Question $number, $word',
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: enabled ? onTap : null,
        child: Container(
          width: 32,
          height: 32,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: fill,
            shape: BoxShape.circle,
            border: Border.all(color: border),
          ),
          child: a != null && !here
              ? Icon(
                  a.correct ? AppIcons.check : AppIcons.close,
                  size: 13,
                  color: ink,
                )
              : Text(
                  '$number',
                  style: GoogleFonts.manrope(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: ink,
                    fontFeatures: const <FontFeature>[
                      FontFeature.tabularFigures(),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}

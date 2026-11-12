import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/responsive/screen_util.dart';
import '../../../../../core/ui/app_icons.dart';
import '../../../../../core/ui/zave/zave_kit.dart';
import '../../../application/lesson_controllers.dart';
import '../../../domain/contest_repository.dart';
import '../../../domain/contest_words.dart';
import '../contest_kit.dart';

/// One answered question, for the summary.
class LessonLearnt {
  const LessonLearnt(this.item, this.answer);

  final PublicQuizItem item;
  final LessonAnswer answer;
}

/// What today's lesson taught — the web's `LessonSummary` (owner, 11 Nov
/// 2026: the score screen should summarise the learning).
///
/// Built from what the learner already saw — each question's right answer
/// and its explanation, revealed as they answered — so it costs nothing and
/// can say nothing new: the skills the day covered, then the ones to review
/// first, then the ones they got.
class LessonSummary extends StatelessWidget {
  const LessonSummary({required this.learnt, super.key});

  final List<LessonLearnt> learnt;

  @override
  Widget build(BuildContext context) {
    if (learnt.isEmpty) return const SizedBox.shrink();
    final List<LessonLearnt> review = learnt
        .where((LessonLearnt l) => !l.answer.correct)
        .toList();
    final List<LessonLearnt> gotRight = learnt
        .where((LessonLearnt l) => l.answer.correct)
        .toList();
    // In the order the day met them.
    final Map<String, int> skills = <String, int>{};
    for (final LessonLearnt l in learnt) {
      skills.update(l.item.skill.label, (int n) => n + 1, ifAbsent: () => 1);
    }

    return ContestPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Semantics(
            header: true,
            child: Text(
              'What you learnt today',
              style: ZaveType.h3.copyWith(fontSize: 18.sp),
            ),
          ),
          SizedBox(height: ZaveSpace.xs),
          Text(
            skills.entries
                .map(
                  (MapEntry<String, int> e) =>
                      '${e.key} ${formatCount(e.value)}',
                )
                .join(' · '),
            style: ContestType.meta,
          ),
          if (review.isNotEmpty) ...<Widget>[
            SizedBox(height: ZaveSpace.lg),
            _Group(
              title: 'Review these (${formatCount(review.length)})',
              titleColor: _reviewWord,
              rows: review,
            ),
          ],
          if (gotRight.isNotEmpty) ...<Widget>[
            SizedBox(height: ZaveSpace.lg),
            _Group(
              title: 'You got these (${formatCount(gotRight.length)})',
              titleColor: ContestColors.mint,
              rows: gotRight,
            ),
          ],
        ],
      ),
    );
  }
}

/// The web's `#ff9b9b`: a heading in the wrong answers' red, lighter so it
/// reads as a list's name rather than an alarm.
const Color _reviewWord = Color(0xFFFF9B9B);

class _Group extends StatelessWidget {
  const _Group({
    required this.title,
    required this.titleColor,
    required this.rows,
  });

  final String title;
  final Color titleColor;
  final List<LessonLearnt> rows;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: GoogleFonts.manrope(
            fontSize: 13.sp,
            fontWeight: FontWeight.w700,
            color: titleColor,
          ),
        ),
        for (int i = 0; i < rows.length; i++) ...<Widget>[
          if (i > 0) const Divider(height: 1, color: ZaveColors.rule),
          _Row(learnt: rows[i]),
        ],
      ],
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.learnt});

  final LessonLearnt learnt;

  @override
  Widget build(BuildContext context) {
    final LessonAnswer a = learnt.answer;
    final Color mark = a.correct ? ZaveColors.green : ContestColors.wrongDot;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: ZaveSpace.md),
      child: MergeSemantics(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ExcludeSemantics(
              child: Container(
                width: 24,
                height: 24,
                margin: const EdgeInsets.only(top: 2),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: mark),
                ),
                child: Icon(
                  a.correct ? AppIcons.check : AppIcons.close,
                  size: 11,
                  color: mark,
                ),
              ),
            ),
            SizedBox(width: ZaveSpace.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Semantics(
                    label:
                        '${learnt.item.skill.label}, '
                        '${a.correct ? 'right' : 'to review'}',
                    excludeSemantics: true,
                    child: Text(
                      learnt.item.skill.label.toUpperCase(),
                      style: GoogleFonts.manrope(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.12 * 11.sp,
                        color: ZaveColors.white.withValues(alpha: 0.4),
                      ),
                    ),
                  ),
                  SizedBox(height: ZaveSpace.xs),
                  Text(
                    a.correctOption,
                    style: ZaveType.body.copyWith(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: ZaveColors.white,
                    ),
                  ),
                  if (a.explain.isNotEmpty) ...<Widget>[
                    SizedBox(height: ZaveSpace.xs),
                    Text(
                      a.explain,
                      style: ZaveType.body.copyWith(
                        fontSize: 14.sp,
                        height: 1.55,
                        color: ZaveColors.ink62,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

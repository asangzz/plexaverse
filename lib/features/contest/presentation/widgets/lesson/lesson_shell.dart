/// The lesson player's chrome: the bar across the top, the bar that answers
/// back, and the player's outline while the lesson is on its way. A port of
/// the web's `components/contest/player/QuizShell.tsx` and `LessonSkeleton`.
///
/// ## No hearts, no Skip
///
/// One attempt per question — the first is the one that scores, so there is
/// nothing to spend — and no Skip: a skipped set question would be a free
/// look at an answer key every learner at the band shares.
///
/// ## The result bar is the surface that matters most
///
/// It is the only moment a learner is told they were wrong, and it shows the
/// right answer as well as the word. Reading the right line is what makes the
/// next one easier.
///
/// ## A darker room than the contest page
///
/// The web's player is a full-screen takeover on `#030014`, over the
/// contest's navy ground. The question, the checkpoint and this outline sit
/// in that room; the score and the status screens go back to the ground.
library;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/responsive/screen_util.dart';
import '../../../../../core/ui/app_icons.dart';
import '../../../../../core/ui/zave/zave_kit.dart';
import '../../../domain/contest_words.dart';
import '../contest_kit.dart';

/// The player's colours — the web's, where Zave has none for a verdict.
abstract final class LessonColors {
  /// The player's room.
  static const Color room = Color(0xFF030014);

  /// The result bar after a right answer, and after a wrong one.
  static const Color rightWash = Color(0xFF0B2A1D);
  static const Color wrongWash = Color(0xFF3A1017);

  /// The verdict's disc, and the button's fill, after a wrong answer.
  static const Color wrongFill = Color(0xFFFF4B4B);

  /// Letters on green.
  static const Color onGreen = Color(0xFF06281A);

  static const Color rightExplain = Color(0xFF8DF0C4);
  static const Color wrongWord = Color(0xFFFF8A8A);
  static const Color wrongSolution = Color(0xFFFFC9C9);
  static const Color wrongExplain = Color(0xFFFFB3B3);

  /// The picked option before Check.
  static const Color pick = Color(0xFF5761EB);
  static const Color pickNumber = Color(0xFF8B92F5);

  /// A wrong pick, once the verdict is in.
  static const Color wrongPick = Color(0xFFF87171);

  /// A refusal under the question.
  static const Color refusal = Color(0xFFFCA5A5);

  /// A reading question's passage: softer than the prompt, which is the
  /// thing to answer.
  static const Color passage = Color(0xFFD4D8EA);
}

/// The way out, the day's progress, and "N in a row" once there is a run.
///
/// ✕ leaves to the contest: the player is a takeover with no other chrome,
/// and there is nowhere else a learner mid-lesson would want to go.
class LessonHeader extends StatelessWidget {
  const LessonHeader({
    required this.progress,
    required this.onQuit,
    this.streak = 0,
    this.quitLabel = 'Leave the lesson',
    super.key,
  });

  /// 0–1, the whole day's.
  final double progress;

  /// Right answers in a row. Shown from two up — one in a row is not a run,
  /// and saying so would cheapen the word.
  final int streak;
  final VoidCallback onQuit;

  /// What ✕ leaves, for a screen reader.
  final String quitLabel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        ZaveSpace.sm,
        ZaveSpace.md,
        ZaveSpace.gutter,
        ZaveSpace.sm,
      ),
      child: Row(
        children: <Widget>[
          Semantics(
            button: true,
            label: quitLabel,
            excludeSemantics: true,
            child: InkWell(
              onTap: onQuit,
              customBorder: const CircleBorder(),
              child: SizedBox.square(
                dimension: ZaveSpace.minTapTarget,
                child: Icon(AppIcons.close, size: 22, color: ZaveColors.ink45),
              ),
            ),
          ),
          SizedBox(width: ZaveSpace.xs),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                // Always laid out and only sometimes seen, so the bar does
                // not jump down the moment a run starts. A line of the SAME
                // style, not a reserved box: a guessed height once clipped
                // the descenders off the words.
                ExcludeSemantics(
                  excluding: streak < 2,
                  child: Opacity(
                    opacity: streak >= 2 ? 1 : 0,
                    child: Text(
                      '$streak in a row'.toUpperCase(),
                      style: GoogleFonts.manrope(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.14 * 10.sp,
                        color: ZaveColors.green,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: ZaveSpace.xs),
                LessonProgressBar(value: progress),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// The day's progress: a 14 px track, filled green.
class LessonProgressBar extends StatelessWidget {
  const LessonProgressBar({required this.value, super.key});

  final double value;

  @override
  Widget build(BuildContext context) {
    final bool still = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    final double v = value.clamp(0.0, 1.0);
    return Semantics(
      label: 'Lesson progress',
      value: '${(v * 100).round()}%',
      child: ClipRRect(
        borderRadius: ZaveRadius.pillBr,
        child: SizedBox(
          height: 14,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              const ColoredBox(color: ZaveGlass.hover),
              TweenAnimationBuilder<double>(
                tween: Tween<double>(end: v),
                duration: still
                    ? Duration.zero
                    : const Duration(milliseconds: 350),
                curve: Curves.easeOutCubic,
                builder: (BuildContext _, double fill, Widget? _) =>
                    FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: fill,
                      child: const DecoratedBox(
                        decoration: BoxDecoration(
                          color: ZaveColors.green,
                          borderRadius: BorderRadius.all(
                            Radius.circular(ZaveRadius.pill),
                          ),
                        ),
                      ),
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The server's verdict on the question on screen, as the bar shows it.
class LessonVerdict {
  const LessonVerdict({
    required this.correct,
    required this.explain,
    required this.solution,
  });

  final bool correct;
  final String explain;

  /// The right option, for the bar of a wrong answer.
  final String solution;
}

/// The bar across the foot: Check, then the verdict, then Continue.
///
/// Three states in one surface, because the answer should appear WHERE the
/// button was: a verdict that opened a sheet or pushed the question up would
/// put distance between committing and finding out, and that half second is
/// the lesson.
class LessonResultBar extends StatelessWidget {
  const LessonResultBar({
    required this.verdict,
    required this.checking,
    required this.canCheck,
    required this.onCheck,
    required this.onContinue,
    required this.isLast,
    this.footnote,
    super.key,
  });

  /// Null while the learner is still answering.
  final LessonVerdict? verdict;

  /// The answer is in flight.
  final bool checking;

  /// Something is picked to send.
  final bool canCheck;
  final VoidCallback onCheck;
  final VoidCallback onContinue;

  /// The last question says Finish rather than Continue.
  final bool isLast;

  /// Under the explanation: what the answer earned (`lessonPointsLine`).
  final String? footnote;

  @override
  Widget build(BuildContext context) {
    final LessonVerdict? v = verdict;
    final Color fill = switch (v?.correct) {
      null => LessonColors.room.withValues(alpha: 0.95),
      true => LessonColors.rightWash,
      false => LessonColors.wrongWash,
    };
    return DecoratedBox(
      decoration: BoxDecoration(
        color: fill,
        border: Border(
          top: BorderSide(
            color: v == null ? ZaveGlass.hover : Colors.transparent,
            width: 2,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            ZaveSpace.gutter,
            ZaveSpace.lg,
            ZaveSpace.gutter,
            ZaveSpace.lg,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Present before the verdict arrives, so a screen reader
              // announces it when it does.
              Semantics(
                liveRegion: true,
                child: v == null
                    ? const SizedBox.shrink()
                    : Padding(
                        padding: EdgeInsets.only(bottom: ZaveSpace.lg),
                        child: _VerdictPanel(verdict: v, footnote: footnote),
                      ),
              ),
              // At the right edge, its own width, as on the web: a Row
              // lets the button size to its word rather than the bar.
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  _PlayerButton(
                    label: v == null
                        ? 'Check'
                        : (isLast ? 'Finish' : 'Continue'),
                    wrong: v != null && !v.correct,
                    busy: checking,
                    onPressed: v != null
                        ? onContinue
                        : (canCheck && !checking ? onCheck : null),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _VerdictPanel extends StatelessWidget {
  const _VerdictPanel({required this.verdict, required this.footnote});

  final LessonVerdict verdict;
  final String? footnote;

  @override
  Widget build(BuildContext context) {
    final bool right = verdict.correct;
    final String? note = footnote;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: right ? ZaveColors.green : LessonColors.wrongFill,
          ),
          child: Icon(
            right ? AppIcons.check : AppIcons.close,
            size: 18,
            color: right ? LessonColors.onGreen : ZaveColors.white,
          ),
        ),
        SizedBox(width: ZaveSpace.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                right ? 'Nicely done.' : 'Not quite.',
                style: GoogleFonts.manrope(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w800,
                  height: 1.2,
                  color: right ? ZaveColors.green : LessonColors.wrongWord,
                ),
              ),
              // The right option, not just the word "wrong".
              if (!right && verdict.solution.isNotEmpty) ...<Widget>[
                SizedBox(height: ZaveSpace.xs),
                Text.rich(
                  TextSpan(
                    children: <InlineSpan>[
                      const TextSpan(
                        text: 'Correct: ',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      TextSpan(text: verdict.solution),
                    ],
                  ),
                  style: ZaveType.body.copyWith(
                    fontSize: 14.sp,
                    height: 1.35,
                    color: LessonColors.wrongSolution,
                  ),
                ),
              ],
              if (verdict.explain.isNotEmpty) ...<Widget>[
                SizedBox(height: ZaveSpace.xs),
                Text(
                  verdict.explain,
                  style: ZaveType.body.copyWith(
                    fontSize: 13.5.sp,
                    height: 1.6,
                    color: right
                        ? LessonColors.rightExplain
                        : LessonColors.wrongExplain,
                  ),
                ),
              ],
              if (note != null && note.isNotEmpty) ...<Widget>[
                SizedBox(height: 6.h),
                Text(
                  note,
                  style: GoogleFonts.manrope(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: ZaveColors.ink85,
                    fontFeatures: const <FontFeature>[
                      FontFeature.tabularFigures(),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

/// The player's own button: green, red after a wrong answer, a faint slab
/// while there is nothing to check. Not the contest's white pill — the player
/// is its own room, as on the web.
class _PlayerButton extends StatelessWidget {
  const _PlayerButton({
    required this.label,
    required this.wrong,
    required this.busy,
    required this.onPressed,
  });

  final String label;
  final bool wrong;
  final bool busy;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final bool enabled = onPressed != null && !busy;
    final bool idle = onPressed == null && !busy;
    final Color fill = idle
        ? ZaveGlass.controlFill
        : (wrong ? LessonColors.wrongFill : ZaveColors.green);
    final Color ink = idle
        ? ZaveColors.ink35
        : (wrong ? ZaveColors.white : LessonColors.onGreen);
    return Semantics(
      button: true,
      enabled: enabled,
      label: label,
      excludeSemantics: true,
      child: ZavePress(
        enabled: enabled,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: enabled ? onPressed : null,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              constraints: const BoxConstraints(
                minHeight: ZaveSpace.minTapTarget,
                minWidth: 140,
              ),
              padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: fill,
                borderRadius: BorderRadius.circular(12),
                boxShadow: idle
                    ? null
                    : const <BoxShadow>[
                        BoxShadow(
                          color: Color(0x4D000000),
                          offset: Offset(0, 4),
                        ),
                      ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  if (busy) ...<Widget>[
                    SizedBox.square(
                      dimension: 15,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: ink,
                      ),
                    ),
                    SizedBox(width: ZaveSpace.sm),
                  ],
                  Text(
                    label.toUpperCase(),
                    style: GoogleFonts.manrope(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.04 * 14.sp,
                      color: ink,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The player in outline while today's lesson is on its way: the bar, the
/// kicker, Plexa's corner, the prompt and four options — so the question drops
/// into place rather than the screen jumping. [label] is for a screen reader,
/// as on the web: "Loading today’s lesson", or "Getting today’s lesson ready"
/// while the day's first open writes the learner's own questions.
class LessonSkeleton extends StatelessWidget {
  const LessonSkeleton({required this.label, required this.onQuit, super.key});

  final String label;
  final VoidCallback onQuit;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: LessonColors.room,
      child: SafeArea(
        child: Column(
          children: <Widget>[
            LessonHeader(progress: 0, onQuit: onQuit),
            Expanded(
              child: Semantics(
                label: label,
                liveRegion: true,
                container: true,
                child: ExcludeSemantics(
                  child: SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(
                      ZaveSpace.gutter,
                      ZaveSpace.xl,
                      ZaveSpace.gutter,
                      ZaveSpace.xl,
                    ),
                    child: ZaveShimmer(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              const Expanded(
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: ZaveSkeleton.bar(width: 200),
                                ),
                              ),
                              SizedBox(width: ZaveSpace.lg),
                              const ZaveSkeleton.block(width: 86, height: 96),
                            ],
                          ),
                          SizedBox(height: ZaveSpace.xl),
                          const ZaveSkeleton.bar(height: 22),
                          SizedBox(height: ZaveSpace.sm),
                          const ZaveSkeleton.bar(height: 22, widthFactor: 0.7),
                          SizedBox(height: ZaveSpace.xl),
                          for (int i = 0; i < 4; i++) ...<Widget>[
                            if (i > 0) SizedBox(height: ZaveSpace.md),
                            _OptionOutline(widthFactor: 0.68 - i * 0.09),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // The bar, at rest: Check with nothing to check.
            LessonResultBar(
              verdict: null,
              checking: false,
              canCheck: false,
              onCheck: _nothing,
              onContinue: _nothing,
              isLast: false,
            ),
          ],
        ),
      ),
    );
  }

  static void _nothing() {}
}

class _OptionOutline extends StatelessWidget {
  const _OptionOutline({required this.widthFactor});

  final double widthFactor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ZaveSpace.lg),
      decoration: BoxDecoration(
        border: Border.all(color: ZaveGlass.hover, width: 2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: <Widget>[
          const ZaveSkeleton.block(width: 28, height: 28),
          SizedBox(width: ZaveSpace.md),
          Expanded(
            child: ZaveSkeleton.bar(height: 16, widthFactor: widthFactor),
          ),
        ],
      ),
    );
  }
}

/// Over a question not answered yet, while the free days are over and there
/// is no plan. Only there: an answered question says what the ledger paid
/// it, whatever scoring is doing now.
class PausedScoringBanner extends StatelessWidget {
  const PausedScoringBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const ContestDot(tone: ContestTone.waiting, label: 'Scoring paused'),
          SizedBox(height: ZaveSpace.xs),
          Text(kQuizPausedLine, style: ContestType.meta.copyWith(height: 1.6)),
        ],
      ),
    );
  }
}

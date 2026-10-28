/// The quiz chrome: progress, hearts, streak, and the bar that answers back.
///
/// Split out of the player because the player is about WHICH question comes
/// next and this is about how one question feels — and because the result bar
/// in particular is the single most important surface in the feature. It is
/// the only moment where a learner is told they were wrong, and it has one
/// job beyond that: show the finished correct line, not just the word they
/// missed. Reading the whole sentence right is what makes the next one
/// easier.
///
/// ## Green and amber, where the web has green and red
///
/// Zave has no red (`zave_colors.dart`), and this is the right place for that
/// rule rather than the exception to it: a wrong answer in a lesson is the
/// least destructive thing in the product, and the five-heart budget exists
/// precisely so that getting one wrong is allowed. Amber is the system's
/// "waiting, not finished" colour, which is exactly what a missed question
/// is.
library;

import 'package:flutter/material.dart';

import '../../../../core/ui/app_icons.dart';
import '../../../../core/ui/zave/zave_kit.dart';
import '../../domain/learn_unit.dart';

/// One life. Filled while it is still yours.
class _Heart extends StatelessWidget {
  const _Heart({required this.spent});

  final bool spent;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(left: 3),
    child: Icon(
      AppIcons.like,
      size: 15,
      color: spent ? ZaveColors.ink35.withValues(alpha: 0.25) : ZaveColors.amber,
    ),
  );
}

/// Where the learner is in the level, and what it has cost so far.
class QuizHeader extends StatelessWidget {
  const QuizHeader({
    required this.progress,
    required this.heartsLeft,
    required this.streak,
    this.heartsTotal = kMistakeBudget,
    super.key,
  });

  /// 0..1.
  final double progress;
  final int heartsLeft;
  final int heartsTotal;

  /// Consecutive correct answers in this level. Shown from two up — one in a
  /// row is not a streak, and saying so would cheapen the word by Thursday.
  final int streak;

  /// There is deliberately no close button here.
  ///
  /// The web draws one because its player is a full-screen takeover over the
  /// dashboard and has no other chrome. Here the day already sits under the
  /// app's own header, whose back arrow goes back to the week — so a second
  /// control one row below it, doing the same thing, was two ways out
  /// stacked on top of each other. The header bar is the way out.
  @override
  Widget build(BuildContext context) => Row(
    children: <Widget>[
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // The streak line is always laid out and only sometimes
            // visible, so the bar underneath does not jump down the moment
            // it appears. Drawn as a transparent line of the SAME style
            // rather than a reserved box of some chosen height — the first
            // version guessed 14 and clipped the descenders off "2 IN A
            // ROW" the moment anyone got two right.
            Opacity(
              opacity: streak >= 2 ? 1 : 0,
              child: Text(
                streak >= 2 ? '$streak IN A ROW' : '',
                style: ZaveType.kicker.copyWith(color: ZaveColors.green),
              ),
            ),
            SizedBox(height: ZaveSpace.xs),
            _ProgressTrack(value: progress),
          ],
        ),
      ),
      SizedBox(width: ZaveSpace.md),
      Semantics(
        label: '$heartsLeft of $heartsTotal tries left',
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            for (int i = 0; i < heartsTotal; i++) _Heart(spent: i >= heartsLeft),
          ],
        ),
      ),
    ],
  );
}

class _ProgressTrack extends StatelessWidget {
  const _ProgressTrack({required this.value});

  final double value;

  @override
  Widget build(BuildContext context) {
    final bool still = MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: SizedBox(
        height: 10,
        child: Stack(
          children: <Widget>[
            const Positioned.fill(
              child: ColoredBox(color: ZaveGlass.controlFill),
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.centerLeft,
                child: TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0, end: value.clamp(0.0, 1.0)),
                  duration: still ? Duration.zero : ZaveMotion.quick,
                  curve: ZaveMotion.curve,
                  builder: (BuildContext _, double v, Widget? _) =>
                      FractionallySizedBox(
                        widthFactor: v,
                        heightFactor: 1,
                        child: const ColoredBox(color: ZaveColors.green),
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The bar across the foot: Check, then the verdict, then Continue.
///
/// Three states in one surface rather than three surfaces, because the whole
/// point of the format is that the answer appears WHERE the button was. A
/// verdict that opened a sheet or pushed the question up the screen would put
/// distance between committing and finding out, and that half second is the
/// lesson.
class QuizResultBar extends StatelessWidget {
  const QuizResultBar({
    required this.verdict,
    required this.checking,
    required this.canCheck,
    required this.onCheck,
    required this.onContinue,
    required this.onSkip,
    required this.isLast,
    this.error,
    super.key,
  });

  /// Null while the learner is still answering.
  final AnswerVerdict? verdict;

  /// A request is in flight — grading this question, or banking the level.
  final bool checking;

  /// Enabled only once there is an answer to send.
  final bool canCheck;

  final VoidCallback onCheck;
  final VoidCallback onContinue;
  final VoidCallback onSkip;

  /// The last question of the last level says Finish rather than Continue.
  final bool isLast;

  /// Something went wrong with the request itself — not a wrong answer.
  final String? error;

  @override
  Widget build(BuildContext context) {
    final AnswerVerdict? v = verdict;
    final Color wash = v == null
        ? Colors.transparent
        : (v.correct ? ZaveColors.green : ZaveColors.amber).withValues(
            alpha: 0.10,
          );

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color.alphaBlend(wash, ZaveColors.midnight),
        border: const Border(top: BorderSide(color: ZaveColors.rule)),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (v != null) ...<Widget>[
                _VerdictPanel(verdict: v),
                SizedBox(height: ZaveSpace.lg),
              ],
              if (error case final String message) ...<Widget>[
                Text(
                  message,
                  style: ZaveType.caption.copyWith(color: ZaveColors.amber),
                ),
                SizedBox(height: ZaveSpace.md),
              ],
              Row(
                children: <Widget>[
                  if (v == null)
                    ZaveButton(
                      label: 'Skip',
                      icon: const Icon(AppIcons.skip),
                      onPressed: checking ? null : onSkip,
                    ),
                  const Spacer(),
                  ZaveButton.primary(
                    label: v == null
                        ? 'Check'
                        : isLast
                        ? 'Finish'
                        : 'Continue',
                    busy: checking,
                    onPressed: v != null
                        ? (checking ? null : onContinue)
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
  const _VerdictPanel({required this.verdict});

  final AnswerVerdict verdict;

  @override
  Widget build(BuildContext context) {
    final bool right = verdict.correct;
    final Color tint = right ? ZaveColors.green : ZaveColors.amber;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Icon(right ? AppIcons.checkCircle : AppIcons.info, size: 20, color: tint),
        SizedBox(width: ZaveSpace.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                right ? 'Nicely done.' : 'Not quite.',
                style: ZaveType.label.copyWith(color: tint),
              ),
              // The whole corrected line, not the word that was missed —
              // reading the finished sentence right is the teaching. Absent
              // on the free-text questions, which have no single answer.
              if (!right && (verdict.solution?.isNotEmpty ?? false)) ...<Widget>[
                SizedBox(height: ZaveSpace.xs),
                Text(
                  verdict.solution!,
                  style: ZaveType.body.copyWith(color: ZaveColors.white),
                ),
              ],
              if (verdict.message.isNotEmpty) ...<Widget>[
                SizedBox(height: ZaveSpace.xs),
                Text(verdict.message, style: ZaveType.bodyMuted),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

/// Shown when the hearts run out.
///
/// Deliberately NOT a dead end and NOT a purchase prompt: the answers are
/// discarded, the ladder is kept, and the first button restarts the level.
/// The budget exists so that guessing through a level does not count as
/// learning, which is a reason to retry — not a reason to pay.
class OutOfHeartsView extends StatelessWidget {
  const OutOfHeartsView({
    required this.onRetry,
    required this.onQuit,
    this.message,
    super.key,
  });

  final VoidCallback onRetry;
  final VoidCallback onQuit;

  /// The server's sentence, when it was the server that refused.
  final String? message;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            for (int i = 0; i < kMistakeBudget; i++) const _Heart(spent: true),
          ],
        ),
      ),
      SizedBox(height: ZaveSpace.lg),
      Text('That one got away.', textAlign: TextAlign.center, style: ZaveType.h2),
      SizedBox(height: ZaveSpace.md),
      Text(
        message ??
            'Five wrong in one level usually means the teaching point did '
                'not land. Run it again — the questions are the same, so this '
                'time you already know what they are asking.',
        textAlign: TextAlign.center,
        style: ZaveType.bodyMuted,
      ),
      SizedBox(height: ZaveSpace.xl),
      ZaveButton.primary(
        label: 'Try the level again',
        expand: true,
        onPressed: onRetry,
      ),
      SizedBox(height: ZaveSpace.md),
      ZaveButton(label: 'Back to the week', expand: true, onPressed: onQuit),
    ],
  );
}

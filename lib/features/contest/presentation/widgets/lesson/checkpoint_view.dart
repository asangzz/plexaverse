import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/responsive/screen_util.dart';
import '../../../../../core/ui/app_icons.dart';
import '../../../../../core/ui/zave/zave_kit.dart';
import '../../../domain/contest_words.dart';
import '../contest_kit.dart';
import 'lesson_shell.dart';

/// The pause between two parts of today's lesson — the web's
/// `player/Checkpoint.tsx` (owner, 11 Nov 2026: at least three checkpoints a
/// day).
///
/// Shown after Continue on the LAST question of a part that is not the day's
/// last. A pause, not a save point: every answer was recorded as it was
/// given, nothing is sent from here, and the day credit and the streak still
/// land only once every question is answered. Leaving here and coming back
/// resumes at the next part's first question.
///
/// Drawn over the question it follows rather than in its place, so Plexa —
/// who plays the whole lesson as one take inside the question — is still
/// there when the learner keeps going.
class CheckpointView extends StatelessWidget {
  const CheckpointView({
    required this.part,
    required this.parts,
    required this.right,
    required this.size,
    required this.nextSize,
    required this.progress,
    required this.onContinue,
    required this.onQuit,
    this.onSkipNext,
    this.skipping = false,
    super.key,
  });

  /// The part just finished, 1-based.
  final int part;

  /// How many parts the day has.
  final int parts;

  /// Right answers in the part just finished, of its [size].
  final int right;
  final int size;

  /// How many questions the next part holds.
  final int nextSize;

  /// The whole day's progress (0–1), for the bar the player keeps at the top.
  final double progress;
  final VoidCallback onContinue;
  final VoidCallback onQuit;

  /// Skip the next part (17 Nov 2026): a quiet link under "Keep going",
  /// which stays the one green pill. Null when the next part cannot be
  /// skipped right now (not the open one, a skip in flight, the double-tap
  /// guard cooling down, or a server before Skip).
  final VoidCallback? onSkipNext;

  /// The skip is being sent.
  final bool skipping;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: LessonColors.room,
      child: SafeArea(
        child: Column(
          children: <Widget>[
            LessonHeader(progress: progress, onQuit: onQuit),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  ZaveSpace.gutter,
                  48.h,
                  ZaveSpace.gutter,
                  ZaveSpace.xl,
                ),
                child: Column(
                  children: <Widget>[
                    Semantics(
                      label: 'Today’s checkpoints',
                      container: true,
                      child: Wrap(
                        spacing: ZaveSpace.md,
                        runSpacing: ZaveSpace.md,
                        alignment: WrapAlignment.center,
                        children: <Widget>[
                          for (int i = 0; i < parts; i++)
                            _PartCircle(number: i + 1, passed: i < part),
                        ],
                      ),
                    ),
                    SizedBox(height: ZaveSpace.xxl),
                    Text(
                      'Today’s lesson'.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.manrope(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.14 * 11.sp,
                        color: ZaveColors.ink35,
                      ),
                    ),
                    SizedBox(height: ZaveSpace.sm),
                    Semantics(
                      header: true,
                      child: Text(
                        'Checkpoint $part of $parts done',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.manrope(
                          fontSize: 30.sp,
                          fontWeight: FontWeight.w800,
                          height: 1.15,
                          letterSpacing: -0.02 * 30.sp,
                          color: ZaveColors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: ZaveSpace.md),
                    Text(
                      '${formatCount(right)} of ${formatCount(size)} right in this part',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.manrope(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w700,
                        color: LessonColors.rightExplain,
                      ),
                    ),
                    SizedBox(height: ZaveSpace.sm),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 340),
                      child: Text(
                        'Part ${part + 1} has ${formatCount(nextSize)} '
                        '${nextSize == 1 ? 'question' : 'questions'}. Your '
                        'answers are saved — finish all $parts parts to '
                        'complete the day.',
                        textAlign: TextAlign.center,
                        style: ZaveType.body.copyWith(
                          fontSize: 14.sp,
                          height: 1.6,
                          color: ZaveColors.white.withValues(alpha: 0.55),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _Foot(
              onContinue: onContinue,
              onQuit: onQuit,
              nextPart: part + 1,
              onSkipNext: onSkipNext,
              skipping: skipping,
            ),
          ],
        ),
      ),
    );
  }
}

class _PartCircle extends StatelessWidget {
  const _PartCircle({required this.number, required this.passed});

  final int number;
  final bool passed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Part $number, ${passed ? 'done' : 'to do'}',
      excludeSemantics: true,
      child: Container(
        width: 48,
        height: 48,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: passed ? ZaveColors.green : null,
          border: passed
              ? null
              : Border.all(
                  color: ZaveColors.white.withValues(alpha: 0.14),
                  width: 2,
                ),
        ),
        child: passed
            ? const Icon(AppIcons.check, size: 20, color: LessonColors.onGreen)
            : Text(
                '$number',
                style: GoogleFonts.manrope(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: ZaveColors.ink45,
                ),
              ),
      ),
    );
  }
}

/// Keep going, and the way back to the path under it — on a phone the web
/// stacks them in that order.
class _Foot extends StatelessWidget {
  const _Foot({
    required this.onContinue,
    required this.onQuit,
    required this.nextPart,
    this.onSkipNext,
    this.skipping = false,
  });

  final VoidCallback onContinue;
  final VoidCallback onQuit;
  final int nextPart;
  final VoidCallback? onSkipNext;
  final bool skipping;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: LessonColors.room.withValues(alpha: 0.95),
        border: const Border(top: BorderSide(color: ZaveGlass.hover, width: 2)),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          ZaveSpace.gutter,
          ZaveSpace.lg,
          ZaveSpace.gutter,
          ZaveSpace.md,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Semantics(
              button: true,
              label: 'Keep going',
              excludeSemantics: true,
              child: ZavePress(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onContinue,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      constraints: const BoxConstraints(
                        minHeight: ZaveSpace.minTapTarget,
                      ),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: ZaveColors.green,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const <BoxShadow>[
                          BoxShadow(
                            color: Color(0x4D000000),
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Text(
                        'Keep going'.toUpperCase(),
                        style: GoogleFonts.manrope(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.04 * 14.sp,
                          color: LessonColors.onGreen,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (onSkipNext != null || skipping)
              Center(
                child: ContestTextLink(
                  label: skipping ? 'Skipping…' : 'Skip part $nextPart',
                  onTap: skipping ? null : onSkipNext,
                ),
              ),
            SizedBox(height: ZaveSpace.sm),
            Center(
              child: Semantics(
                link: true,
                label: 'Back to the path',
                excludeSemantics: true,
                child: InkWell(
                  onTap: onQuit,
                  borderRadius: ZaveRadius.pillBr,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      minHeight: ZaveSpace.minTapTarget,
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: ZaveSpace.md),
                      child: Center(
                        widthFactor: 1,
                        child: Text(
                          'Back to the path',
                          style: GoogleFonts.manrope(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                            color: ZaveColors.white.withValues(alpha: 0.6),
                          ),
                        ),
                      ),
                    ),
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

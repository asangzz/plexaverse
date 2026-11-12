import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/responsive/screen_util.dart';
import '../../../../../core/ui/app_icons.dart';
import '../../../../../core/ui/zave/zave_kit.dart';
import '../contest_kit.dart';

/// The comment player's ground: the web player's near-black, not the
/// contest's navy — a full-screen player is its own room.
const Color kCommentPlayerGround = Color(0xFF030014);

/// The player's top line: ✕ back to the contest, and how many blanks are
/// filled as a green bar. The web's `QuizHeader`, as the comment level uses
/// it — no "in a row", since there is one comment, not a run of questions.
class CommentPlayerHeader extends StatelessWidget {
  const CommentPlayerHeader({
    required this.progress,
    required this.onQuit,
    super.key,
  });

  /// 0–1.
  final double progress;
  final VoidCallback onQuit;

  @override
  Widget build(BuildContext context) {
    final bool still = MediaQuery.disableAnimationsOf(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(4.w, 8.h, 16.w, 8.h),
      child: Row(
        children: <Widget>[
          IconButton(
            onPressed: onQuit,
            tooltip: 'Leave the comment level',
            icon: Icon(AppIcons.close, size: 22.sp, color: ZaveColors.ink45),
          ),
          SizedBox(width: ZaveSpace.sm),
          Expanded(
            child: Semantics(
              label: 'Blanks filled',
              value: '${(progress.clamp(0, 1) * 100).round()}%',
              child: ClipRRect(
                borderRadius: ZaveRadius.pillBr,
                child: Container(
                  height: 14.h,
                  color: const Color(0x14FFFFFF),
                  alignment: Alignment.centerLeft,
                  child: AnimatedFractionallySizedBox(
                    duration: still
                        ? Duration.zero
                        : const Duration(milliseconds: 350),
                    curve: const Cubic(0.22, 1, 0.36, 1),
                    widthFactor: progress.clamp(0, 1).toDouble(),
                    heightFactor: 1,
                    child: const DecoratedBox(
                      decoration: BoxDecoration(
                        color: ContestColors.green,
                        borderRadius: BorderRadius.all(Radius.circular(9999)),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// The bar that answers back, at the foot of the player. The web's
/// `ResultBar`, as the comment level uses it: Check, and after a miss "Not
/// quite." with its line and Try again. A right answer never shows here — it
/// lands as the finished comment.
class CommentResultBar extends StatelessWidget {
  const CommentResultBar({
    required this.missLine,
    required this.busy,
    required this.canCheck,
    required this.onCheck,
    required this.onTryAgain,
    super.key,
  });

  /// The line under "Not quite." while a miss is up; null before a check.
  final String? missLine;
  final bool busy;

  /// Every blank is filled.
  final bool canCheck;
  final VoidCallback onCheck;
  final VoidCallback onTryAgain;

  static const Color _wrongGround = Color(0xFF3A1017);
  static const Color _wrong = Color(0xFFFF4B4B);
  static const Color _greenInk = Color(0xFF06281A);

  @override
  Widget build(BuildContext context) {
    final String? miss = missLine;
    final bool enabled = miss != null || (canCheck && !busy);
    final String label = miss != null ? 'Try again' : 'Check';
    final (Color fill, Color ink) = !enabled
        ? (const Color(0x12FFFFFF), const Color(0x40FFFFFF))
        : miss != null
        ? (_wrong, ZaveColors.white)
        : (ContestColors.green, _greenInk);

    return Container(
      decoration: BoxDecoration(
        color: miss != null ? _wrongGround : const Color(0xF2030014),
        border: Border(
          top: BorderSide(
            color: miss != null ? Colors.transparent : const Color(0x14FFFFFF),
            width: 2,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Present before the verdict arrives, so it is announced.
              Semantics(
                liveRegion: true,
                child: miss == null
                    ? const SizedBox.shrink()
                    : Padding(
                        padding: EdgeInsets.only(bottom: 16.h),
                        child: _Miss(line: miss),
                      ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Semantics(
                  button: true,
                  enabled: enabled,
                  label: label,
                  excludeSemantics: true,
                  child: Material(
                    color: fill,
                    borderRadius: BorderRadius.circular(12.r),
                    child: InkWell(
                      onTap: !enabled
                          ? null
                          : (miss != null ? onTryAgain : onCheck),
                      borderRadius: BorderRadius.circular(12.r),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          minHeight: ZaveSpace.minTapTarget,
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 40.w),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              if (busy) ...<Widget>[
                                SizedBox.square(
                                  dimension: 15.r,
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
                                  letterSpacing: 0.5,
                                  color: ink,
                                ),
                              ),
                            ],
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
      ),
    );
  }
}

class _Miss extends StatelessWidget {
  const _Miss({required this.line});

  final String line;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: 40.r,
          height: 40.r,
          decoration: const BoxDecoration(
            color: CommentResultBar._wrong,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Icon(AppIcons.close, size: 20.sp, color: ZaveColors.white),
        ),
        SizedBox(width: ZaveSpace.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Not quite.',
                style: GoogleFonts.manrope(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFFFF8A8A),
                ),
              ),
              SizedBox(height: ZaveSpace.xs),
              Text(
                line,
                style: ZaveType.body.copyWith(
                  fontSize: 13.5.sp,
                  height: 1.6,
                  color: const Color(0xFFFFB3B3),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/responsive/screen_util.dart';
import '../../../../../core/ui/zave/zave_kit.dart';
import '../../../application/lesson_controllers.dart';
import 'lesson_shell.dart';

/// One multiple-choice question: the prompt and its four numbered options.
/// A port of the web's `components/contest/player/ChoiceView.tsx`.
///
/// ## The verdict is a prop, and only the server's
///
/// No answer key reaches the app before an answer — `PublicQuizItem` carries
/// none — so the option to paint green arrives with the verdict, as the
/// server's `correctOption`, and this view never works one out. Before the
/// verdict every option looks the same but the picked one, which is the
/// point. `test/features/contest/no_client_grading_test.dart` holds this
/// file to that, and names the one line where the reveal compares.
///
/// Numbered as on the web, where the numbers are the keys that pick.
class ChoiceView extends StatelessWidget {
  const ChoiceView({
    required this.prompt,
    required this.options,
    required this.picked,
    required this.verdict,
    required this.onPick,
    super.key,
  });

  final String prompt;

  /// In THIS learner's order. A pick travels back as the option's text.
  final List<String> options;

  /// The pick before Check. Ignored once [verdict] is in, which carries the
  /// answer the server recorded.
  final String? picked;

  /// The server's verdict, once there is one. Locks every option.
  final LessonAnswer? verdict;

  /// Null while nothing can be picked — an answer in flight, or the
  /// question already answered.
  final ValueChanged<String>? onPick;

  @override
  Widget build(BuildContext context) {
    final LessonAnswer? answer = verdict;
    final bool locked = answer != null;
    // The server's right option, and the answer it recorded — on a replay,
    // the first attempt's rather than this device's pick.
    final String? rightOption = answer?.correctOption;
    final String? shown = answer?.value ?? picked;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Semantics(
          header: true,
          child: Text(
            prompt,
            style: GoogleFonts.manrope(
              fontSize: 22.sp,
              fontWeight: FontWeight.w800,
              height: 1.2,
              color: ZaveColors.white,
            ),
          ),
        ),
        SizedBox(height: ZaveSpace.xl),
        for (int i = 0; i < options.length; i++) ...<Widget>[
          if (i > 0) SizedBox(height: ZaveSpace.md),
          Builder(
            builder: (BuildContext context) {
              final String option = options[i];
              final bool isPicked = option == shown;
              // The reveal: the server's right option, painted once its
              // verdict is in. The one comparison with it in the slice.
              final bool isRight = locked && option == rightOption;
              return _OptionTile(
                number: i + 1,
                text: option,
                selected: isPicked,
                look: !locked
                    ? (isPicked ? _Look.picked : _Look.open)
                    : isRight
                    ? _Look.right
                    : isPicked
                    ? _Look.wrongPick
                    : _Look.dimmed,
                onTap: locked || onPick == null ? null : () => onPick!(option),
              );
            },
          ),
        ],
      ],
    );
  }
}

/// How one option looks: open, picked, or — after the verdict — the right
/// one (always green, even when the learner picked another: the bar says they
/// were wrong, this says which one was right), their wrong pick, or the rest
/// at 40%.
enum _Look { open, picked, right, wrongPick, dimmed }

class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.number,
    required this.text,
    required this.selected,
    required this.look,
    required this.onTap,
  });

  final int number;
  final String text;

  /// The learner's pick — or, once answered, the answer on record.
  final bool selected;
  final _Look look;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final (Color border, Color fill) = switch (look) {
      _Look.open || _Look.dimmed => (
        ZaveColors.white.withValues(alpha: 0.12),
        ZaveColors.white.withValues(alpha: 0.02),
      ),
      _Look.picked => (
        LessonColors.pick,
        LessonColors.pick.withValues(alpha: 0.15),
      ),
      _Look.right => (
        ZaveColors.green,
        ZaveColors.green.withValues(alpha: 0.10),
      ),
      _Look.wrongPick => (
        LessonColors.wrongPick.withValues(alpha: 0.7),
        LessonColors.wrongPick.withValues(alpha: 0.10),
      ),
    };
    final (Color numberBorder, Color numberInk) = switch (look) {
      _Look.picked => (LessonColors.pick, LessonColors.pickNumber),
      _Look.right => (ZaveColors.green, ZaveColors.green),
      _ => (ZaveColors.white.withValues(alpha: 0.15), ZaveColors.ink45),
    };
    final Color ink = look == _Look.open ? ZaveColors.ink85 : ZaveColors.white;

    final Widget tile = Opacity(
      opacity: look == _Look.dimmed ? 0.4 : 1,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(ZaveSpace.lg),
        decoration: BoxDecoration(
          color: fill,
          border: Border.all(color: border, width: 2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: <Widget>[
            Container(
              width: 28,
              height: 28,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: numberBorder),
              ),
              child: Text(
                '$number',
                style: GoogleFonts.manrope(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: numberInk,
                  fontFeatures: const <FontFeature>[
                    FontFeature.tabularFigures(),
                  ],
                ),
              ),
            ),
            SizedBox(width: ZaveSpace.md),
            Expanded(
              child: Text(
                text,
                style: ZaveType.body.copyWith(
                  fontSize: 15.sp,
                  height: 1.35,
                  color: ink,
                ),
              ),
            ),
          ],
        ),
      ),
    );

    return Semantics(
      button: true,
      inMutuallyExclusiveGroup: true,
      checked: selected,
      enabled: onTap != null,
      value: switch (look) {
        _Look.right => 'Right answer',
        _Look.wrongPick => 'Your answer',
        _ => null,
      },
      child: ZavePress(
        enabled: onTap != null,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: tile,
        ),
      ),
    );
  }
}

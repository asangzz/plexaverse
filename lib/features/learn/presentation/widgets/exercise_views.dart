import 'package:flutter/material.dart';

import '../../../../core/ui/app_icons.dart';
import '../../../../core/ui/zave/zave_kit.dart';
import '../../domain/learn_unit.dart';

/// The server's verdict on one exercise, once it has one.
///
/// Null while the user is still answering. **Nothing in this file may compute
/// one.** The correct answers ride along inside the ladder because the
/// explanation has to be shown after answering — which puts `correctIndex`
/// and `modelAnswer` three lines from a tap handler, and the first person
/// asked to "make the check feel instant" will reach for them. Once that
/// lands, a unit can be completed without reading a word, and the post that
/// comes out is our example sentences in the user's voice.
///
/// `test/features/learn/no_client_grading_test.dart` scans this directory for
/// exactly that.
typedef Verdict = ExerciseResult?;

/// One question, in whichever of the four shapes it is.
class ExerciseView extends StatelessWidget {
  const ExerciseView({
    required this.exercise,
    required this.value,
    required this.onChanged,
    required this.verdict,
    required this.controller,
    super.key,
  });

  final Exercise exercise;

  /// What the user has answered so far. For choice/gap this is the option's
  /// TEXT — never its index, because option order is regenerated per unit.
  final String value;
  final ValueChanged<String> onChanged;

  /// Locked once this is non-null.
  final Verdict verdict;

  /// Owned by the player, so the text survives a rebuild.
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(exercise.prompt, style: ZaveType.label),
        SizedBox(height: ZaveSpace.md),
        if (exercise.isChoice)
          _Options(
            exercise: exercise,
            value: value,
            onChanged: onChanged,
            verdict: verdict,
          )
        else if (exercise.isGap)
          _Gap(
            exercise: exercise,
            value: value,
            onChanged: onChanged,
            verdict: verdict,
          )
        else if (exercise.isRewrite)
          _Rewrite(
            exercise: exercise,
            controller: controller,
            onChanged: onChanged,
            verdict: verdict,
          )
        else
          _Compose(
            exercise: exercise,
            controller: controller,
            onChanged: onChanged,
            verdict: verdict,
          ),
        if (verdict case final ExerciseResult r) ...<Widget>[
          SizedBox(height: ZaveSpace.md),
          _VerdictLine(result: r),
          // The model answer is one good version, not "the" answer — the
          // web's own wording. Shown only after the server has spoken.
          if (exercise.isRewrite &&
              (exercise.modelAnswer?.isNotEmpty ?? false)) ...<Widget>[
            SizedBox(height: ZaveSpace.md),
            _Revealed(label: 'ONE GOOD VERSION', body: exercise.modelAnswer!),
          ],
        ],
      ],
    );
  }
}

/// The option list, for `choice` and under the sentence for `gap`.
class _Options extends StatelessWidget {
  const _Options({
    required this.exercise,
    required this.value,
    required this.onChanged,
    required this.verdict,
  });

  final Exercise exercise;
  final String value;
  final ValueChanged<String> onChanged;
  final Verdict verdict;

  @override
  Widget build(BuildContext context) {
    final bool locked = verdict != null;

    return Column(
      children: <Widget>[
        for (int i = 0; i < exercise.options.length; i++) ...<Widget>[
          if (i > 0) SizedBox(height: ZaveSpace.sm),
          _OptionTile(
            text: exercise.options[i],
            selected: exercise.options[i] == value,
            // Which option is right is the SERVER's answer, and it only
            // exists once a verdict is in hand. Before that every option
            // looks the same, which is the point.
            revealedCorrect: locked && exercise.correctIndex == i,
            locked: locked,
            onTap: locked ? null : () => onChanged(exercise.options[i]),
          ),
        ],
      ],
    );
  }
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.text,
    required this.selected,
    required this.revealedCorrect,
    required this.locked,
    required this.onTap,
  });

  final String text;
  final bool selected;
  final bool revealedCorrect;
  final bool locked;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    // Green names the right answer whatever the user picked; amber names a
    // wrong pick. Zave has no red, and a wrong answer in a lesson is the
    // least destructive thing in the product.
    final Color border = revealedCorrect
        ? ZaveColors.green
        : locked && selected
        ? ZaveColors.amber
        : selected
        ? ZaveColors.violet
        : ZaveGlass.controlBorder;
    final Color fill = revealedCorrect
        ? ZaveColors.green.withValues(alpha: 0.12)
        : locked && selected
        ? ZaveColors.amber.withValues(alpha: 0.12)
        : selected
        ? ZaveColors.violet.withValues(alpha: 0.15)
        : ZaveGlass.controlFill;

    final Widget tile = Opacity(
      opacity: locked && !selected && !revealedCorrect ? 0.5 : 1,
      child: Container(
        width: double.infinity,
        padding: ZaveSpace.rowPad,
        decoration: BoxDecoration(
          color: fill,
          border: Border.all(color: border, width: 1),
          borderRadius: BorderRadius.circular(ZaveRadius.cardSm),
        ),
        child: Text(text, style: ZaveType.body),
      ),
    );

    if (onTap == null) return tile;
    return ZavePress(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: tile,
      ),
    );
  }
}

/// A sentence with one blank, filled live by the chosen option.
class _Gap extends StatelessWidget {
  const _Gap({
    required this.exercise,
    required this.value,
    required this.onChanged,
    required this.verdict,
  });

  final Exercise exercise;
  final String value;
  final ValueChanged<String> onChanged;
  final Verdict verdict;

  @override
  Widget build(BuildContext context) {
    final String sentence = exercise.sentence ?? '';
    final List<String> parts = sentence.split('___');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: double.infinity,
          padding: ZaveSpace.rowPad,
          decoration: ZaveSurface.row,
          child: Text.rich(
            TextSpan(
              children: <InlineSpan>[
                TextSpan(text: parts.isNotEmpty ? parts.first : sentence),
                // The blank fills as they choose, so the sentence reads as a
                // sentence rather than as a quiz.
                TextSpan(
                  text: value.isEmpty ? '          ' : value,
                  style: ZaveType.body.copyWith(
                    color: value.isEmpty ? ZaveColors.ink35 : ZaveColors.white,
                    decoration: TextDecoration.underline,
                    decorationColor: ZaveColors.violet,
                    decorationThickness: 2,
                  ),
                ),
                if (parts.length > 1)
                  TextSpan(text: parts.sublist(1).join('___')),
              ],
            ),
            style: ZaveType.body,
          ),
        ),
        SizedBox(height: ZaveSpace.md),
        _Options(
          exercise: exercise,
          value: value,
          onChanged: onChanged,
          verdict: verdict,
        ),
      ],
    );
  }
}

/// The weak sentence, and a box to say it better.
class _Rewrite extends StatelessWidget {
  const _Rewrite({
    required this.exercise,
    required this.controller,
    required this.onChanged,
    required this.verdict,
  });

  final Exercise exercise;
  final TextEditingController? controller;
  final ValueChanged<String> onChanged;
  final Verdict verdict;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // Shown as a card rather than pre-filled into the box. Pre-filling
        // makes the commonest non-answer — pressing Continue on the starter
        // untouched — the path of least resistance.
        _Revealed(label: 'BEFORE', body: exercise.starter ?? ''),
        SizedBox(height: ZaveSpace.md),
        ZaveField(
          controller: controller,
          label: 'YOUR VERSION',
          hint: 'Your version…',
          minLines: 3,
          maxLines: 5,
          enabled: verdict == null,
          onChanged: onChanged,
        ),
      ],
    );
  }
}

/// Their own material, in their own words. Never graded on quality.
class _Compose extends StatelessWidget {
  const _Compose({
    required this.exercise,
    required this.controller,
    required this.onChanged,
    required this.verdict,
  });

  final Exercise exercise;
  final TextEditingController? controller;
  final ValueChanged<String> onChanged;
  final Verdict verdict;

  @override
  Widget build(BuildContext context) => ZaveField(
    controller: controller,
    hint: exercise.placeholder ?? 'Your answer…',
    minLines: 4,
    maxLines: 8,
    enabled: verdict == null,
    onChanged: onChanged,
  );
}

/// The server's sentence about one answer.
class _VerdictLine extends StatelessWidget {
  const _VerdictLine({required this.result});

  final ExerciseResult result;

  @override
  Widget build(BuildContext context) {
    final Color tint = result.correct ? ZaveColors.green : ZaveColors.amber;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Icon(
          result.correct ? AppIcons.checkCircle : AppIcons.info,
          size: 16,
          color: tint,
        ),
        SizedBox(width: ZaveSpace.sm),
        Expanded(
          child: Text(
            result.message,
            style: ZaveType.caption.copyWith(color: tint),
          ),
        ),
      ],
    );
  }
}

/// A labelled quote block — the weak sentence, or the model answer.
class _Revealed extends StatelessWidget {
  const _Revealed({required this.label, required this.body});

  final String label;
  final String body;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: ZaveSpace.rowPad,
    decoration: ZaveSurface.row,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(label, style: ZaveType.kicker),
        SizedBox(height: ZaveSpace.xs),
        Text(body, style: ZaveType.body.copyWith(color: ZaveColors.ink85)),
      ],
    ),
  );
}

import 'package:flutter/material.dart';

import '../../../../core/ui/zave/zave_kit.dart';
import '../../domain/learn_unit.dart';

/// The server's verdict on the question on screen, once it has one.
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
typedef Verdict = AnswerVerdict?;

/// One question, in whichever of the seven shapes it is.
///
/// ## One to a screen
///
/// The first version of this stacked a level's exercises in a column under a
/// single Check. That reads as a form, and a form is answered the way forms
/// are: skim everything, fill it in, submit, scroll past whatever it says
/// back. The teaching lives in the moment between answering and finding out,
/// and a stacked list has no such moment. One question, one verdict, then the
/// next.
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

  /// What the user has answered so far. For the picker types this is the
  /// option's LABEL — never its index, because option order is regenerated
  /// per unit and an index would silently re-point.
  final String value;
  final ValueChanged<String> onChanged;

  /// Locked once this is non-null.
  final Verdict verdict;

  /// Owned by the player, so the text survives a rebuild. Null for the
  /// picker types, which have nothing to type into.
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    final Exercise e = exercise;

    if (e.isMeaning) return _Meaning(exercise: e, value: value, onChanged: onChanged, verdict: verdict);
    if (e.isDialogue) return _Dialogue(exercise: e, value: value, onChanged: onChanged, verdict: verdict);
    if (e.isGap) return _Gap(exercise: e, value: value, onChanged: onChanged, verdict: verdict);
    if (e.isPair) return _Pair(exercise: e, value: value, onChanged: onChanged, verdict: verdict);
    if (e.isRewrite) return _Rewrite(exercise: e, controller: controller, onChanged: onChanged, verdict: verdict);
    if (e.isCompose) return _Compose(exercise: e, controller: controller, onChanged: onChanged, verdict: verdict);

    return _Question(
      prompt: e.prompt,
      child: _Options(
        exercise: e,
        value: value,
        onChanged: onChanged,
        verdict: verdict,
      ),
    );
  }
}

/// The question line, then its body. One shape for all seven so a level does
/// not change its proportions from question to question.
class _Question extends StatelessWidget {
  const _Question({required this.prompt, required this.child, this.above});

  final String prompt;

  /// Material the question is ABOUT — the sentence, the comment — shown
  /// before the question itself, because that is the order it is read in.
  final Widget? above;

  final Widget child;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      if (above case final Widget material) ...<Widget>[
        material,
        SizedBox(height: ZaveSpace.xl),
      ],
      Text(prompt, style: ZaveType.h3),
      SizedBox(height: ZaveSpace.lg),
      child,
    ],
  );
}

/// The answer rows.
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
    final List<String> labels = exercise.optionLabels;

    return Column(
      children: <Widget>[
        for (int i = 0; i < labels.length; i++) ...<Widget>[
          if (i > 0) SizedBox(height: ZaveSpace.sm),
          _OptionTile(
            text: labels[i],
            selected: labels[i] == value,
            // Which option is right is the SERVER's answer, and it is only
            // drawn once a verdict is in hand. Before that every option looks
            // the same, which is the point.
            revealedCorrect: locked && exercise.correctIndex == i,
            locked: locked,
            onTap: locked ? null : () => onChanged(labels[i]),
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

/// A sentence with its blanks shown as slots, filled live as the learner
/// picks. The answer is read in place, as a sentence — which is the whole
/// reason this format beats a list of words beside one.
class _GappedSentence extends StatelessWidget {
  const _GappedSentence({required this.sentence, required this.fills});

  final String sentence;

  /// One entry per blank, in order. Null for a blank not yet filled.
  final List<String?> fills;

  @override
  Widget build(BuildContext context) {
    final List<String> parts = sentence.split('___');

    return Container(
      width: double.infinity,
      padding: ZaveSpace.rowPad,
      decoration: ZaveSurface.row,
      child: Text.rich(
        TextSpan(
          children: <InlineSpan>[
            for (int i = 0; i < parts.length; i++) ...<InlineSpan>[
              TextSpan(text: parts[i]),
              if (i < parts.length - 1)
                TextSpan(
                  text: (i < fills.length ? fills[i] : null) ?? '          ',
                  style: ZaveType.body.copyWith(
                    color: (i < fills.length ? fills[i] : null) == null
                        ? ZaveColors.ink35
                        : ZaveColors.white,
                    decoration: TextDecoration.underline,
                    decorationColor: ZaveColors.violet,
                    decorationThickness: 2,
                  ),
                ),
            ],
          ],
        ),
        style: ZaveType.body,
      ),
    );
  }
}

/// Tap-to-fill word chips. A spent chip leaves a hole rather than vanishing,
/// so the row does not reflow and the learner can see where the word went.
class _WordBank extends StatelessWidget {
  const _WordBank({
    required this.words,
    required this.used,
    required this.onPick,
    required this.locked,
  });

  final List<String> words;
  final String? used;
  final ValueChanged<String> onPick;
  final bool locked;

  @override
  Widget build(BuildContext context) => Wrap(
    alignment: WrapAlignment.center,
    spacing: ZaveSpace.sm,
    runSpacing: ZaveSpace.sm,
    children: <Widget>[
      for (final String word in words)
        _Chip(
          word: word,
          spent: word == used,
          locked: locked,
          onTap: locked ? null : () => onPick(word),
        ),
    ],
  );
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.word,
    required this.spent,
    required this.locked,
    required this.onTap,
  });

  final String word;
  final bool spent;
  final bool locked;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final Widget chip = Opacity(
      opacity: locked && !spent ? 0.5 : 1,
      child: Container(
        padding: ZaveSpace.chipPad,
        decoration: BoxDecoration(
          color: spent ? ZaveGlass.rest : ZaveGlass.controlFill,
          border: Border.all(
            color: spent ? ZaveGlass.restBorder : ZaveGlass.controlBorder,
          ),
          borderRadius: ZaveRadius.pillBr,
        ),
        child: Text(
          word,
          style: ZaveType.body.copyWith(
            color: spent ? Colors.transparent : ZaveColors.ink85,
          ),
        ),
      ),
    );

    if (onTap == null) return chip;
    return ZavePress(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: chip,
      ),
    );
  }
}

/// One blank, filled from a word bank.
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
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        exercise.prompt.isEmpty ? 'Fill in the blank' : exercise.prompt,
        style: ZaveType.h3,
      ),
      SizedBox(height: ZaveSpace.lg),
      _GappedSentence(
        sentence: exercise.sentence ?? '',
        fills: <String?>[value.isEmpty ? null : value],
      ),
      SizedBox(height: ZaveSpace.xl),
      _WordBank(
        words: exercise.optionLabels,
        used: value.isEmpty ? null : value,
        // Tapping the chip that is already in the blank takes it back out.
        onPick: (String w) => onChanged(value == w ? '' : w),
        locked: verdict != null,
      ),
    ],
  );
}

/// Two blanks, and the options are PAIRS.
///
/// Not two gaps: the point is collocation. Splitting the halves into
/// independent blanks lets a learner get each one right for the wrong reason,
/// and the pair is the unit being taught.
class _Pair extends StatelessWidget {
  const _Pair({
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
    final ExerciseOption? picked = exercise.optionFor(value);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          exercise.prompt.isEmpty ? 'Fill in the blanks' : exercise.prompt,
          style: ZaveType.h3,
        ),
        SizedBox(height: ZaveSpace.lg),
        _GappedSentence(
          sentence: exercise.sentence ?? '',
          fills: picked == null
              ? const <String?>[null, null]
              : <String?>[...picked.fills],
        ),
        SizedBox(height: ZaveSpace.xl),
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

/// A term shown doing a job in a sentence, then: what does it mean?
class _Meaning extends StatelessWidget {
  const _Meaning({
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
  Widget build(BuildContext context) => _Question(
    prompt: exercise.prompt,
    above: Container(
      width: double.infinity,
      padding: ZaveSpace.rowPad,
      decoration: ZaveSurface.row,
      child: Text.rich(
        _highlighted(exercise.sentence ?? '', exercise.term ?? ''),
        style: ZaveType.body,
      ),
    ),
    child: _Options(
      exercise: exercise,
      value: value,
      onChanged: onChanged,
      verdict: verdict,
    ),
  );

  /// The term marked in place, so the learner sees it working before being
  /// asked what it does. A definition drilled out of context is the thing
  /// people have forgotten by Thursday.
  TextSpan _highlighted(String sentence, String term) {
    if (term.isEmpty) return TextSpan(text: sentence);
    final int at = sentence.toLowerCase().indexOf(term.toLowerCase());
    if (at < 0) return TextSpan(text: sentence);
    return TextSpan(
      children: <InlineSpan>[
        TextSpan(text: sentence.substring(0, at)),
        TextSpan(
          text: sentence.substring(at, at + term.length),
          style: ZaveType.body.copyWith(
            color: ZaveColors.lavenderHi,
            fontWeight: FontWeight.w600,
            decoration: TextDecoration.underline,
            decorationStyle: TextDecorationStyle.dotted,
            decorationColor: ZaveColors.lavenderLo,
          ),
        ),
        TextSpan(text: sentence.substring(at + term.length)),
      ],
    );
  }
}

/// A comment lands under the post. What do you say back?
///
/// The surface Plexa can only ever coach: our LinkedIn scope set is
/// `w_member_social` — publishing a share and nothing else — so commenting is
/// something we can teach and never automate.
class _Dialogue extends StatelessWidget {
  const _Dialogue({
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
  Widget build(BuildContext context) => _Question(
    prompt: exercise.prompt.isEmpty ? 'Reply to the comment' : exercise.prompt,
    above: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (exercise.speaker case final String who when who.isNotEmpty) ...<Widget>[
          Text(who.toUpperCase(), style: ZaveType.kicker),
          SizedBox(height: ZaveSpace.sm),
        ],
        _Bubble(text: exercise.opener ?? ''),
        SizedBox(height: ZaveSpace.sm),
        // The empty bubble on the other side is the question, drawn. It says
        // what the options are FOR before any of them is read.
        const Align(alignment: Alignment.centerRight, child: _Bubble()),
      ],
    ),
    child: _Options(
      exercise: exercise,
      value: value,
      onChanged: onChanged,
      verdict: verdict,
    ),
  );
}

class _Bubble extends StatelessWidget {
  const _Bubble({this.text});

  /// Null draws the empty reply waiting to be filled.
  final String? text;

  @override
  Widget build(BuildContext context) => ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: 300),
    child: Container(
      padding: ZaveSpace.rowPad,
      decoration: ZaveSurface.row,
      child: text == null
          ? SizedBox(
              width: 56,
              child: Divider(color: ZaveColors.ink35, height: 18, thickness: 2),
            )
          : Text(text!, style: ZaveType.body.copyWith(color: ZaveColors.ink85)),
    ),
  );
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
  Widget build(BuildContext context) => _Question(
    prompt: exercise.prompt,
    // Shown as a card rather than pre-filled into the box. Pre-filling makes
    // the commonest non-answer — pressing Check on the starter untouched —
    // the path of least resistance.
    above: _Quoted(label: 'BEFORE', body: exercise.starter ?? ''),
    child: ZaveField(
      controller: controller,
      label: 'YOUR VERSION',
      hint: 'Your version…',
      minLines: 3,
      maxLines: 5,
      enabled: verdict == null,
      onChanged: onChanged,
    ),
  );
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
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(exercise.prompt, style: ZaveType.h3),
      SizedBox(height: ZaveSpace.sm),
      // Said out loud. Without it, a box that follows three graded questions
      // reads as a fourth and gets a guarded, minimal answer — the opposite
      // of what the post needs.
      Text(
        'Your own words. Nothing to get wrong — this goes into the post.',
        style: ZaveType.caption.copyWith(color: ZaveColors.ink45),
      ),
      SizedBox(height: ZaveSpace.lg),
      ZaveField(
        controller: controller,
        hint: exercise.placeholder ?? 'Your answer…',
        minLines: 4,
        maxLines: 8,
        enabled: verdict == null,
        onChanged: onChanged,
      ),
    ],
  );
}

/// A labelled quote block.
class _Quoted extends StatelessWidget {
  const _Quoted({required this.label, required this.body});

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

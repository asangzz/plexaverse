import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/ui/app_icons.dart';
import '../../../../core/ui/zave/zave_kit.dart';
import '../../../plexa/presentation/widgets/plexa_moment.dart';
import '../../domain/placement_repository.dart';
import '../../domain/placement_words.dart';
import 'placement_parts.dart';

/// One question, one screen. A port of the web's `PlacementQuestion.tsx`.
///
/// ## No feedback, by construction
///
/// The item has no answer key — the server strips it — so this screen could
/// not mark an answer if it tried. Next sends the option's TEXT and the next
/// screen is simply the next question: no tick, no colour, no "nice". A
/// placement test that teaches mid-way measures the teaching.
/// `test/features/placement/placement_no_verdict_test.dart` holds this file
/// to that.
///
/// ## The picked row takes the "now" step, not a colour
///
/// Next is the screen's one primary button. A picked row in an accent beside
/// it would be a second one, and green or amber is exactly what a marked
/// answer looks like — the wrong thing to suggest about an answer nobody has
/// marked.
///
/// ## Mounted once per question
///
/// The page keys this by attempt and handle, so a new question starts with
/// nothing picked rather than inheriting the last pick by position.
///
/// ## The leave line follows the clock, the server decides
///
/// Under Next it says the rules for leaving while the close is far off, the
/// time once it is near, and — past `closesAt` by this device's clock — that
/// the time may have run out. Next stays live through all three: a device
/// clock that runs fast would otherwise freeze a learner out of answers the
/// server still takes. A late answer is refused, and the page goes back to
/// the intro on a fresh read.
class PlacementQuestion extends StatefulWidget {
  const PlacementQuestion({
    required this.step,
    required this.item,
    required this.skill,
    required this.answering,
    required this.onAnswer,
    this.error,
    this.notice,
    super.key,
  });

  final PlacementStep step;
  final PublicPlacementItem item;
  final ObjectiveSkill skill;

  /// The answer is in flight. The pick is already sent, so it is frozen.
  final bool answering;

  /// Why the last answer did not go through.
  final String? error;

  /// One line above the question, when the learner needs telling why it is a
  /// new test.
  final String? notice;
  final ValueChanged<String> onAnswer;

  @override
  State<PlacementQuestion> createState() => _PlacementQuestionState();
}

class _PlacementQuestionState extends State<PlacementQuestion> {
  String? _picked;

  /// Wakes the leave line when its wording is due to change.
  Timer? _turn;

  @override
  void initState() {
    super.initState();
    _armTurn();
  }

  @override
  void didUpdateWidget(PlacementQuestion old) {
    super.didUpdateWidget(old);
    if (old.step.closesAt != widget.step.closesAt) _armTurn();
  }

  void _armTurn() {
    _turn?.cancel();
    _turn = null;
    final DateTime now = DateTime.now();
    final List<DateTime> turns = leaveLineTurns(widget.step.closesAt, now);
    if (turns.isEmpty) return;
    _turn = Timer(turns.first.difference(now), () {
      if (!mounted) return;
      setState(() {});
      _armTurn();
    });
  }

  @override
  void dispose() {
    _turn?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final PlacementStep step = widget.step;
    final PublicPlacementItem item = widget.item;
    final String? picked = _picked;
    final String? passage = item.passage;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        PlacementNotice(widget.notice),
        Row(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          widget.skill.label.toUpperCase(),
                          style: ZaveType.kicker,
                        ),
                      ),
                      Text(widget.skill.partOf, style: _meta),
                    ],
                  ),
                  SizedBox(height: ZaveSpace.md),
                  _Progress(
                    value: progressOf(step.answered, step.estimatedTotal),
                  ),
                  SizedBox(height: ZaveSpace.md),
                  Text(
                    questionCount(step.answered, step.estimatedTotal),
                    style: _meta,
                  ),
                ],
              ),
            ),
            SizedBox(width: ZaveSpace.md),
            const PlexaMoment(PlexaMomentClip.placementStudying, width: 104),
          ],
        ),
        if (passage != null && passage.isNotEmpty) ...<Widget>[
          SizedBox(height: ZaveSpace.xl),
          Semantics(
            label: 'Passage',
            child: ZaveCard(child: Text(passage, style: ZaveType.body)),
          ),
        ],
        SizedBox(height: ZaveSpace.xl),
        Semantics(header: true, child: Text(item.prompt, style: ZaveType.h3)),
        SizedBox(height: ZaveSpace.lg),
        for (int i = 0; i < item.options.length; i++) ...<Widget>[
          if (i > 0) SizedBox(height: ZaveSpace.sm),
          _Option(
            number: i + 1,
            text: item.options[i],
            picked: item.options[i] == picked,
            onTap: widget.answering
                ? null
                : () => setState(() => _picked = item.options[i]),
          ),
        ],
        SizedBox(height: ZaveSpace.xl),
        ZaveButton.primary(
          label: 'Next',
          trailing: const Icon(AppIcons.forward),
          expand: true,
          busy: widget.answering,
          onPressed: picked == null || widget.answering
              ? null
              : () => widget.onAnswer(picked),
        ),
        SizedBox(height: ZaveSpace.md),
        Text(
          leaveLine(
            closesAt: step.closesAt,
            answered: step.answered,
            now: DateTime.now(),
          ),
          style: _meta,
        ),
        PlacementErrorLine(title: 'Not sent yet', message: widget.error),
      ],
    );
  }
}

/// Solid white behind you, 14% ahead — the journey's spine, laid flat.
class _Progress extends StatelessWidget {
  const _Progress({required this.value});

  final double value;

  @override
  Widget build(BuildContext context) => Semantics(
    label: 'Test progress',
    value: '${(value * 100).round()}%',
    child: ClipRRect(
      borderRadius: ZaveRadius.pillBr,
      child: SizedBox(
        height: 6,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            const ColoredBox(color: ZaveColors.rule),
            FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: value,
              child: const ColoredBox(color: ZaveColors.white),
            ),
          ],
        ),
      ),
    ),
  );
}

/// One option row: its number, then its words. Numbers rather than A–D, as on
/// the web, where they are the keys that pick.
///
/// Picked or not, the same ink and the same glass — only the step of the
/// glass moves. See the class doc on [PlacementQuestion].
class _Option extends StatelessWidget {
  const _Option({
    required this.number,
    required this.text,
    required this.picked,
    required this.onTap,
  });

  final int number;
  final String text;
  final bool picked;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final Widget row = Container(
      width: double.infinity,
      padding: ZaveSpace.rowPad,
      decoration: picked ? ZaveSurface.rowNow : ZaveSurface.row,
      child: Row(
        children: <Widget>[
          Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: picked ? ZaveColors.white : ZaveGlass.restBorder,
              ),
            ),
            child: Text(
              '$number',
              style: ZaveType.button.copyWith(
                color: picked ? ZaveColors.white : ZaveColors.ink50,
              ),
            ),
          ),
          SizedBox(width: ZaveSpace.lg),
          Expanded(
            child: Text(
              text,
              style: ZaveType.body.copyWith(
                color: picked ? ZaveColors.white : ZaveColors.ink85,
              ),
            ),
          ),
        ],
      ),
    );

    return Semantics(
      inMutuallyExclusiveGroup: true,
      checked: picked,
      button: true,
      enabled: onTap != null,
      child: ZavePress(
        enabled: onTap != null,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: row,
        ),
      ),
    );
  }
}

TextStyle get _meta => ZaveType.caption.copyWith(height: 1.6);

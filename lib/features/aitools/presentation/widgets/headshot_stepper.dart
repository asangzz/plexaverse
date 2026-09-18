import 'package:flutter/material.dart';

import '../../../../core/ui/zave/zave_kit.dart';
import '../../domain/headshot_session.dart';

/// The four-node progress strip above the headshot wizard.
///
/// The web paints three different steppers across three pages in this family
/// (bare circles + bars, pills with inner circles, circles + labels +
/// connectors). This is one, in Zave's own language:
///
///   • **current** inverts to solid white with ink numerals — the same
///     selection language as a chip or the active nav item.
///   • **done** is [ZaveColors.green], because green means done.
///   • **ahead** is glass at rest with ink-45 numerals.
///
/// It scrolls horizontally, as the web's does, because four labelled nodes do
/// not fit across a phone.
class HeadshotStepper extends StatelessWidget {
  const HeadshotStepper({required this.current, super.key});

  final HeadshotStep current;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ZaveSpace.minTapTarget,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.zero,
        itemCount: HeadshotStep.values.length,
        separatorBuilder: (BuildContext _, int _) => Center(
          child: Container(
            height: 1,
            width: ZaveSpace.lg,
            color: ZaveColors.rule,
          ),
        ),
        itemBuilder: (BuildContext _, int index) {
          final HeadshotStep step = HeadshotStep.values[index];
          final bool done = index < current.index;
          final bool now = step == current;
          return _Node(step: step, index: index, done: done, now: now);
        },
      ),
    );
  }
}

class _Node extends StatelessWidget {
  const _Node({
    required this.step,
    required this.index,
    required this.done,
    required this.now,
  });

  final HeadshotStep step;
  final int index;
  final bool done;
  final bool now;

  @override
  Widget build(BuildContext context) {
    final Color fg = now
        ? ZaveColors.ink
        : (done ? ZaveColors.green : ZaveColors.ink45);

    return Semantics(
      label: step.label,
      selected: now,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          AnimatedContainer(
            duration: ZaveMotion.fast,
            curve: ZaveMotion.curve,
            height: ZaveSpace.iconBtn,
            width: ZaveSpace.iconBtn,
            decoration: BoxDecoration(
              color: now ? ZaveColors.white : ZaveGlass.controlFill,
              shape: BoxShape.circle,
              border: Border.all(
                color: now
                    ? ZaveColors.white
                    : (done ? ZaveColors.green : ZaveGlass.controlBorder),
                width: 1,
              ),
            ),
            child: Center(
              child: done
                  ? const Icon(Icons.check, size: 16, color: ZaveColors.green)
                  : Text(
                      '${index + 1}',
                      style: ZaveType.label.copyWith(color: fg),
                    ),
            ),
          ),
          SizedBox(width: ZaveSpace.sm),
          Text(
            step.label,
            style: ZaveType.label.copyWith(
              color: now ? ZaveColors.white : ZaveColors.ink45,
            ),
          ),
        ],
      ),
    );
  }
}

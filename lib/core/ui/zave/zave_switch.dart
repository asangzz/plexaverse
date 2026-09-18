import 'package:flutter/material.dart';

import '../../theme/zave/zave.dart';

/// `.zv-switch` — 52 x 30, a 22px knob inset 3px.
///
/// Off is glass with a 60%-white knob; on is solid white with an ink knob —
/// the same "selected inverts to white" language as [ZaveChip]. Deliberately
/// not a Material [Switch]: that would bring its own track/thumb colours,
/// ripple and platform shape, none of which are Zave.
class ZaveSwitch extends StatelessWidget {
  const ZaveSwitch({
    required this.value,
    required this.onChanged,
    this.semanticLabel,
    super.key,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final bool enabled = onChanged != null;

    return Semantics(
      toggled: value,
      label: semanticLabel,
      child: GestureDetector(
        onTap: enabled ? () => onChanged!(!value) : null,
        behavior: HitTestBehavior.opaque,
        child: Opacity(
          opacity: enabled ? 1 : 0.5,
          child: SizedBox(
            height: ZaveSpace.minTapTarget,
            width: ZaveSpace.switchWidth,
            child: Center(
              child: AnimatedContainer(
                duration: ZaveMotion.fast,
                curve: ZaveMotion.curve,
                height: ZaveSpace.switchHeight,
                width: ZaveSpace.switchWidth,
                decoration: BoxDecoration(
                  color: value ? ZaveColors.white : ZaveGlass.now,
                  border: Border.all(
                    color: value
                        ? ZaveColors.white
                        : const Color(0x2EFFFFFF), // rgba(255,255,255,0.18)
                    width: 1,
                  ),
                  borderRadius: ZaveRadius.pillBr,
                ),
                child: AnimatedAlign(
                  duration: ZaveMotion.fast,
                  curve: ZaveMotion.curve,
                  alignment:
                      value ? Alignment.centerRight : Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.all(ZaveSpace.switchInset),
                    child: Container(
                      height: ZaveSpace.switchKnob,
                      width: ZaveSpace.switchKnob,
                      decoration: BoxDecoration(
                        color: value
                            ? ZaveColors.ink
                            : ZaveColors.white.withValues(alpha: 0.6),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

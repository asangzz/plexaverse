import 'package:flutter/material.dart';

import '../../../../core/ui/zave/zave_kit.dart';
import '../../domain/onboarding_repository.dart';
import 'reply_lane.dart';

/// The current-role step's control.
///
/// The web's `RolePicker`: the four highest-coverage roles as reply chips, plus
/// an "Other…" that swaps them for a free-text field. Both paths end in the
/// same call, so the profession is always captured — the step exists precisely
/// because a missing profession used to default to the literal "Professional".
///
/// The free-text branch is **full width even though it lives in the reply
/// lane**, which is the web's own exception and worth keeping: a 78%-wide
/// right-aligned field with an inline Set button is about 220 logical pixels on
/// a small phone with the keyboard up. Only the RESULT is right-aligned, as the
/// echoed bubble.
class RolePicker extends StatefulWidget {
  const RolePicker({required this.onPick, this.hint, super.key});

  final ValueChanged<String> onPick;

  /// Passed through to [ReplyLane] — see its `hint`.
  final String? hint;

  @override
  State<RolePicker> createState() => _RolePickerState();
}

class _RolePickerState extends State<RolePicker> {
  final TextEditingController _controller = TextEditingController();
  bool _otherMode = false;

  /// Two characters is the web's floor: enough to rule out a stray keypress,
  /// low enough to accept "PM".
  bool get _canSubmit => _controller.text.trim().length >= 2;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    if (_canSubmit) widget.onPick(_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    if (!_otherMode) {
      return ReplyLane(
        hint: widget.hint,
        chips: <Widget>[
          for (final String role in kCommonRoles)
            ReplyChip(label: role, onTap: () => widget.onPick(role)),
          ReplySkipChip(
            label: 'Other…',
            onTap: () => setState(() => _otherMode = true),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        ZaveField(
          controller: _controller,
          hint: 'Type your current role…',
          autofocus: true,
          textInputAction: TextInputAction.done,
          onChanged: (_) => setState(() {}),
          onSubmitted: (_) => _submit(),
        ),
        SizedBox(height: ZaveSpace.md),
        Row(
          children: <Widget>[
            ZaveButton(
              label: 'Back to the list',
              onPressed: () => setState(() => _otherMode = false),
            ),
            const Spacer(),
            ZaveButton(
              // The step's only forward action, so it is the one solid-white
              // control on screen while this panel is up.
              kind: ZaveButtonKind.primarySmall,
              label: 'Set',
              onPressed: _canSubmit ? _submit : null,
            ),
          ],
        ),
      ],
    );
  }
}

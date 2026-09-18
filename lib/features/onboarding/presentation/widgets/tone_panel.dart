import 'package:flutter/material.dart';

import '../../../../core/ui/zave/zave_kit.dart';
import '../../domain/onboarding_repository.dart';

/// The voice composer — the web's `ToneInput`.
///
/// Three tone presets above a two-line composer with an inline send. Tapping a
/// preset **fills the composer with its sample**: it is a starting draft the
/// user edits, not a mode they select, which is why the samples are real
/// sentences rather than adjectives.
///
/// ## Two deliberate departures
///
/// **The presets are chips, not cards.** The web renders a three-up grid of
/// icon tiles that tint to the preset's own colour when active. Zave has no
/// selected state for a card, and every pressable in it is a full pill — so the
/// presets are [ZaveChip]s and "active" is the system's own inversion to solid
/// white. It also removes three decorative colours the palette has no room for.
///
/// **The draft is owned by the caller.** The composer is swapped for the typing
/// hint whenever Plexa replies, which throws away local state — and the way a
/// too-short sample is rejected IS a bot line. The web hit exactly this and
/// hoisted the draft into the parent; the controller holds it here for the same
/// reason.
class TonePanel extends StatefulWidget {
  const TonePanel({
    required this.value,
    required this.onChanged,
    required this.onSubmit,
    super.key,
  });

  final String value;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmit;

  @override
  State<TonePanel> createState() => _TonePanelState();
}

class _TonePanelState extends State<TonePanel> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.value,
  );

  /// The web's send gate. The REAL floor is 20 characters and lives in the
  /// controller, which rejects a short sample with a bot line rather than a
  /// dead button — five is only enough to stop an empty submit.
  static const int _minToSend = 5;

  @override
  void didUpdateWidget(TonePanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    // The caller owns the text, so an external change (a preset tap, or the
    // clear-on-success) has to reach the field.
    if (widget.value != _controller.text) {
      _controller.value = TextEditingValue(
        text: widget.value,
        selection: TextSelection.collapsed(offset: widget.value.length),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _canSend => _controller.text.trim().length >= _minToSend;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Wrap(
          spacing: ZaveSpace.sm,
          runSpacing: ZaveSpace.sm,
          children: <Widget>[
            for (final TonePreset preset in TonePreset.values)
              ZaveChip(
                label: preset.title,
                selected: widget.value == preset.sample,
                onTap: () => widget.onChanged(preset.sample),
              ),
          ],
        ),
        SizedBox(height: ZaveSpace.md),
        ZaveField(
          controller: _controller,
          hint: 'Or type your own 2–3 sentence sample…',
          minLines: 2,
          maxLines: 4,
          onChanged: (String v) {
            widget.onChanged(v);
            setState(() {});
          },
        ),
        SizedBox(height: ZaveSpace.md),
        Align(
          alignment: Alignment.centerRight,
          child: ZaveButton(
            // The panel's only forward action. There is no skip beside it, and
            // that is the point: this is the last place the user's own voice
            // can be captured, and "skip — learn from my posts" was a promise
            // the product cannot keep without the r_member_social scope.
            kind: ZaveButtonKind.primarySmall,
            label: 'Send',
            onPressed: _canSend
                ? () => widget.onSubmit(_controller.text)
                : null,
          ),
        ),
      ],
    );
  }
}

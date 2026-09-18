import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/ui/zave/zave_kit.dart';
import '../../application/studio_editor_controller.dart';
import '../../application/studio_editor_state.dart';
import '../../domain/ai_designer.dart';
import '../../domain/studio_design.dart';
import 'design_canvas.dart';
import 'studio_shared.dart';

/// **AI Designer** — the web's `AIDesignerPanel`, as a sheet.
///
/// On the web this is one of two 280px rails flanking the canvas. Two rails do
/// not fit a 375px viewport, so on a phone it is a sheet opened from the
/// header: the conversation scrolls, the composer is pinned above the
/// keyboard, and each assistant turn that produced a design shows it and
/// offers to use it.
///
/// **Applying is a tap, never automatic.** The model rewrites the whole poster
/// each turn; adopting a suggestion the moment it lands would throw away
/// whatever the user had just typed into their text layers. The web has the
/// same Apply button for the same reason.
///
/// The web also accepts reference-image attachments (it downscales them to
/// 1024px and sends them as data URLs). That needs a photo picker the app does
/// not ship; the sheet says so rather than showing a paperclip that opens
/// nothing.
class AiDesignerSheet extends ConsumerStatefulWidget {
  const AiDesignerSheet({required this.designId, super.key});

  final String designId;

  @override
  ConsumerState<AiDesignerSheet> createState() => _AiDesignerSheetState();
}

class _AiDesignerSheetState extends ConsumerState<AiDesignerSheet> {
  final TextEditingController _input = TextEditingController();

  /// The web's own starter prompts, verbatim.
  static const List<String> _suggestions = <String>[
    'Instagram post announcing an AI webinar',
    'Bold product launch poster — neon + black',
    'Minimal quote poster in cream & charcoal',
    'Gold price drop alert with glitchy tech vibe',
  ];

  @override
  void dispose() {
    _input.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<AiDesignerTurn> turns = ref.watch(
      aiDesignerProvider(widget.designId),
    );
    final bool busy = turns.any((AiDesignerTurn t) => t.pending);

    return StudioSheet(
      padBottomInset: true,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(child: Text('AI DESIGNER', style: ZaveType.kicker)),
            if (turns.isNotEmpty)
              ZaveIconButton(
                icon: const Icon(Icons.close),
                tooltip: 'Clear the conversation',
                onPressed: () => ref
                    .read(aiDesignerProvider(widget.designId).notifier)
                    .clear(),
              ),
          ],
        ),
        SizedBox(height: ZaveSpace.md),

        if (turns.isEmpty) ...<Widget>[
          Text('Describe a poster.', style: ZaveType.h3),
          SizedBox(height: ZaveSpace.sm),
          Text(
            'It writes the whole design — page, shapes, words and images. You '
            'decide whether to use it.',
            style: ZaveType.bodyMuted,
          ),
          SizedBox(height: ZaveSpace.xl),
          Text('TRY', style: ZaveType.kicker),
          SizedBox(height: ZaveSpace.md),
          for (final String suggestion in _suggestions) ...<Widget>[
            ZaveCard(
              size: ZaveCardSize.small,
              padding: ZaveSpace.rowPad,
              onTap: () => _input.text = suggestion,
              child: Text(suggestion, style: ZaveType.label),
            ),
            SizedBox(height: ZaveSpace.sm),
          ],
        ] else
          for (final AiDesignerTurn turn in turns) ...<Widget>[
            _TurnBubble(turn: turn, designId: widget.designId),
            SizedBox(height: ZaveSpace.md),
          ],

        SizedBox(height: ZaveSpace.lg),
        ZaveField(
          controller: _input,
          hint: busy ? 'Designing…' : 'Describe the poster…',
          enabled: !busy,
          maxLines: 4,
          minLines: 2,
          keyboardType: TextInputType.multiline,
        ),
        SizedBox(height: ZaveSpace.lg),
        ZaveButton.primary(
          label: 'Send',
          expand: true,
          busy: busy,
          onPressed: busy ? null : _send,
        ),

        SizedBox(height: ZaveSpace.xl),
        const StudioUnavailable(
          title: 'Attaching a reference image',
          reason:
              'The web lets you drop a screenshot for the model to copy. '
              'That needs a photo-library plugin this build does not ship '
              '(no image_picker in pubspec.yaml).',
        ),
      ],
    );
  }

  void _send() {
    final String prompt = _input.text.trim();
    if (prompt.isEmpty) return;

    final StudioEditorState? editor = ref
        .read(studioEditorProvider(widget.designId))
        .value;

    _input.clear();
    ref
        .read(aiDesignerProvider(widget.designId).notifier)
        .send(
          prompt,
          canvas: editor?.data.canvas ?? const StudioCanvas(),
          // Sending the current design is what makes "make it more minimal"
          // mean anything — without it every turn starts from nothing.
          currentDesign: editor?.data,
        );
  }
}

/// One turn.
///
/// Speakers are told apart by ALIGNMENT and a kicker, not by colour. The web
/// paints its user bubble in brand indigo, which Zave cannot copy: blue here
/// is the XP path and nothing else, and tinting a chat bubble with it would
/// claim a meaning it does not have. Nor is the selected-chip inversion
/// (solid white, ink letters) right — that means "selected", and a message is
/// not a selection.
class _TurnBubble extends ConsumerWidget {
  const _TurnBubble({required this.turn, required this.designId});

  final AiDesignerTurn turn;
  final String designId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (turn.isUser) {
      return Align(
        alignment: Alignment.centerRight,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.sizeOf(context).width * 0.8,
          ),
          child: ZaveCard(
            size: ZaveCardSize.small,
            padding: ZaveSpace.rowPad,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text('YOU', style: ZaveType.kicker),
                SizedBox(height: ZaveSpace.sm),
                Text(
                  turn.content,
                  style: ZaveType.body,
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (turn.pending) {
      return ZaveCard(
        size: ZaveCardSize.small,
        padding: ZaveSpace.rowPad,
        child: Row(
          children: <Widget>[
            const ZaveDot(ZaveColors.peri),
            SizedBox(width: ZaveSpace.sm),
            Text('Designing your poster…', style: ZaveType.bodyMuted),
          ],
        ),
      );
    }

    return ZaveCard(
      size: ZaveCardSize.small,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              // Amber for a failed turn — Zave has no red.
              ZaveDot(turn.failed ? ZaveColors.amber : ZaveColors.mint),
              SizedBox(width: ZaveSpace.sm),
              Expanded(child: Text('AI DESIGNER', style: ZaveType.kicker)),
            ],
          ),
          SizedBox(height: ZaveSpace.md),
          Text(
            turn.content,
            style: turn.failed
                ? ZaveType.body.copyWith(color: ZaveColors.amber)
                : ZaveType.body,
          ),
          if (turn.design != null) ...<Widget>[
            SizedBox(height: ZaveSpace.lg),
            DesignCanvas(data: turn.design!),
            SizedBox(height: ZaveSpace.lg),
            ZaveButton(
              label: 'Use this design',
              kind: ZaveButtonKind.primarySmall,
              expand: true,
              onPressed: () {
                ref
                    .read(studioEditorProvider(designId).notifier)
                    .applyDesign(turn.design!);
                Navigator.of(context).pop();
              },
            ),
          ],
        ],
      ),
    );
  }
}

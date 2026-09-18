import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/ui/zave/zave_kit.dart';
import '../../application/compose_controller.dart';
import '../../domain/compose_draft.dart';
import '../../domain/compose_status.dart';

/// "Write with AI" — the brief the generator works from.
///
/// The web renders this as a bottom sheet below 640px and a centred dialog
/// above it (`items-end sm:items-center`). A phone only ever sees the sheet, so
/// that is all this is; the two-form responsive behaviour would be dead code
/// on every device this app runs on.
///
/// **Three controls the web has and this does not, and why.**
///
/// • *Poster style* chips come from `GET /api/poster-tags`, which the mobile
///   API does not expose. Rendering a chip row that silently sends nothing
///   would be worse than not having one.
/// • *Reference post* — `POST /ai/generate` on mobile reads only
///   `{topic, tone, length}`; it drops `reference` on the floor. A textarea
///   whose content is discarded server-side is a lie told in UI.
/// • The *voice-sample count* subtitle needs a summary endpoint mobile has no
///   route for, so the subtitle states the plain fact instead.
///
/// All three are reported as missing endpoints rather than faked.
class AiGenerateSheet extends ConsumerStatefulWidget {
  const AiGenerateSheet({super.key});

  /// Opens the sheet. Returns when it closes; the generated post is written
  /// straight into the draft, so there is nothing to hand back.
  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      // Dismissible even mid-generation. Trapping someone behind a scrim for
      // the eight seconds a poster takes is worse than letting them leave, and
      // the page keeps reporting progress after the sheet closes — the status
      // lives on the controller, not in this widget.
      builder: (BuildContext _) => const AiGenerateSheet(),
    );
  }

  @override
  ConsumerState<AiGenerateSheet> createState() => _AiGenerateSheetState();
}

class _AiGenerateSheetState extends ConsumerState<AiGenerateSheet> {
  final TextEditingController _topic = TextEditingController();

  ComposeTone _tone = ComposeTone.professional;
  ComposeLength _length = ComposeLength.medium;

  @override
  void dispose() {
    _topic.dispose();
    super.dispose();
  }

  Future<void> _write() async {
    final String topic = _topic.text.trim();
    if (topic.isEmpty) return;

    await ref
        .read(composeActionsProvider.notifier)
        .generate(topic: topic, tone: _tone, length: _length);

    if (!mounted) return;
    // Close only once a body exists. The web does the same: a failed text call
    // returns before the modal is dismissed, so the user keeps their brief and
    // can retry without retyping it. A failed *poster* still closes, because
    // the post itself was written.
    final bool written = ref
        .read(composeDraftControllerProvider)
        .content
        .trim()
        .isNotEmpty;
    if (written) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final ComposeStatus status = ref.watch(composeActionsProvider);
    final bool busy = status.isGenerating;

    return Padding(
      // Lift the sheet clear of the keyboard — the topic field is the first
      // thing the user touches, and it is at the top of a sheet that would
      // otherwise sit underneath the keyboard.
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.88,
        ),
        decoration: BoxDecoration(
          gradient: ZaveGround.base,
          border: const Border(
            top: BorderSide(color: ZaveGlass.headerBorder, width: 1),
          ),
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(ZaveRadius.cardLg),
          ),
        ),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              ZaveSpace.gutter,
              ZaveSpace.md,
              ZaveSpace.gutter,
              ZaveSpace.xl,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Center(
                  child: Container(
                    height: 4,
                    width: 40,
                    decoration: BoxDecoration(
                      color: ZaveColors.rule,
                      borderRadius: ZaveRadius.pillBr,
                    ),
                  ),
                ),
                SizedBox(height: ZaveSpace.xl),

                Text('Write with AI', style: ZaveType.h2),
                SizedBox(height: ZaveSpace.sm),
                Text('Tell me what to write about.', style: ZaveType.caption),

                SizedBox(height: ZaveSpace.xl),
                ZaveField(
                  controller: _topic,
                  label: 'What should it be about?',
                  hint:
                      "The one thing I'd tell a junior engineer about code "
                      'review…',
                  helper:
                      'The more specific this is, the closer the result sounds '
                      'to you.',
                  minLines: 2,
                  maxLines: 4,
                  enabled: !busy,
                  textInputAction: TextInputAction.newline,
                  keyboardType: TextInputType.multiline,
                  autofocus: true,
                ),

                SizedBox(height: ZaveSpace.xl),
                Text('TONE', style: ZaveType.kicker),
                SizedBox(height: ZaveSpace.md),
                Wrap(
                  spacing: ZaveSpace.sm,
                  runSpacing: ZaveSpace.sm,
                  children: <Widget>[
                    for (final ComposeTone tone in ComposeTone.values)
                      ZaveChip(
                        label: tone.label,
                        selected: tone == _tone,
                        onTap: busy ? null : () => setState(() => _tone = tone),
                      ),
                  ],
                ),

                SizedBox(height: ZaveSpace.xl),
                Text('LENGTH', style: ZaveType.kicker),
                SizedBox(height: ZaveSpace.md),
                Wrap(
                  spacing: ZaveSpace.sm,
                  runSpacing: ZaveSpace.sm,
                  children: <Widget>[
                    for (final ComposeLength length in ComposeLength.values)
                      ZaveChip(
                        label: length.label,
                        selected: length == _length,
                        onTap: busy
                            ? null
                            : () => setState(() => _length = length),
                      ),
                  ],
                ),

                if (busy) ...<Widget>[
                  SizedBox(height: ZaveSpace.xl),
                  _ProgressStrip(message: status.progress ?? 'Working…'),
                ],

                if (status.insufficientXp) ...<Widget>[
                  SizedBox(height: ZaveSpace.xl),
                  const _XpNotice(),
                ],

                if (status.error != null) ...<Widget>[
                  SizedBox(height: ZaveSpace.xl),
                  _ErrorNotice(message: status.error!),
                ],

                SizedBox(height: ZaveSpace.xl),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: ZaveButton(
                        label: 'Cancel',
                        onPressed: busy
                            ? null
                            : () => Navigator.of(context).pop(),
                        expand: true,
                      ),
                    ),
                    SizedBox(width: ZaveSpace.md),
                    Expanded(
                      child: ZaveButton.primary(
                        label: busy ? 'Writing…' : 'Write it',
                        onPressed: busy ? null : _write,
                        busy: busy,
                        expand: true,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// The web's "Generating post content..." strip — a spinner and one line, on a
/// rest-fill block.
class _ProgressStrip extends StatelessWidget {
  const _ProgressStrip({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: ZaveSpace.rowPad,
      decoration: ZaveSurface.row,
      child: Row(
        children: <Widget>[
          const SizedBox(
            height: 16,
            width: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: ZaveColors.white,
            ),
          ),
          SizedBox(width: ZaveSpace.md),
          Expanded(child: Text(message, style: ZaveType.bodyMuted)),
        ],
      ),
    );
  }
}

/// The server answered 402. Amber — Zave has no red, and running out of XP is
/// a "waiting on you" state, not a failure.
class _XpNotice extends StatelessWidget {
  const _XpNotice();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: ZaveSpace.rowPad,
      decoration: ZaveSurface.row,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const ZaveDot(ZaveColors.amber),
          SizedBox(width: ZaveSpace.md),
          Expanded(
            child: Text(
              "You don't have enough XP to generate a post. Top up from "
              'Pricing, then try again.',
              style: ZaveType.caption.copyWith(color: ZaveColors.amber),
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorNotice extends StatelessWidget {
  const _ErrorNotice({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: ZaveSpace.rowPad,
      decoration: ZaveSurface.row,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const ZaveDot(ZaveColors.amber),
          SizedBox(width: ZaveSpace.md),
          Expanded(
            child: Text(
              message,
              style: ZaveType.caption.copyWith(color: ZaveColors.amber),
            ),
          ),
        ],
      ),
    );
  }
}

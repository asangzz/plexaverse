import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/zave_routes.dart';

import '../../../../core/ui/zave/zave_kit.dart';
import '../../application/compose_controller.dart';
import '../../domain/compose_draft.dart';
import '../../domain/compose_models.dart';
import '../../domain/compose_status.dart';

/// "Write with AI" — the brief the generator works from.
///
/// The web renders this as a bottom sheet below 640px and a centred dialog
/// above it (`items-end sm:items-center`). A phone only ever sees the sheet, so
/// that is all this is; the two-form responsive behaviour would be dead code
/// on every device this app runs on.
///
/// **Poster style and reference post are real controls now.** Mobile has a
/// `GET /poster-tags` route, and `POST /ai/generate` reads `reference`, so both
/// chips and textarea carry their value to the server rather than decorating a
/// request that drops it.
///
/// The style row follows the web's rule rather than listing the vocabulary: a
/// tag the reference library has no live images for produces exactly the poster
/// that no tag produces, so those are left out, and the row disappears entirely
/// when none of them are backed. A picker whose every option does the same
/// thing is worse than no picker — it invites a choice and then ignores it.
///
/// The reference field is collapsed behind a link and cleared when removed.
/// It is sent per request and never written to the draft: it describes this
/// post, not the user, and a stored one would keep re-applying a stranger's
/// structure long after they had forgotten pasting it.
///
/// **One control the web has is still missing, and still said out loud.** Its
/// subtitle reads "matched against N samples of your writing", which needs a
/// voice-summary endpoint mobile has no route for. Rather than invent a count,
/// the subtitle here states the plain fact.
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
  final TextEditingController _reference = TextEditingController();

  ComposeTone _tone = ComposeTone.professional;
  ComposeLength _length = ComposeLength.medium;

  /// Null is "no style", and the default — the poster every generation produced
  /// before the reference library existed.
  String? _posterTag;

  /// Most posts do not want a reference, and an empty textarea sitting on the
  /// sheet reads as a field somebody forgot to fill in.
  bool _showReference = false;

  @override
  void dispose() {
    _topic.dispose();
    _reference.dispose();
    super.dispose();
  }

  Future<void> _write() async {
    final String topic = _topic.text.trim();
    if (topic.isEmpty) return;

    await ref
        .read(composeActionsProvider.notifier)
        .generate(
          topic: topic,
          tone: _tone,
          length: _length,
          posterTag: _posterTag,
          reference: _reference.text.trim(),
        );

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

    // Only the tags the library can actually honour, and nothing at all until
    // they land. A failed fetch therefore costs the user the style choice and
    // nothing else: the brief, the tone and the length are untouched, and the
    // poster generates exactly as it did before this control existed.
    final List<PosterTagOption> styles =
        (ref.watch(posterTagOptionsProvider).value ?? const <PosterTagOption>[])
            .where((PosterTagOption option) => option.usable)
            .toList(growable: false);

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

                if (styles.isNotEmpty) ...<Widget>[
                  SizedBox(height: ZaveSpace.xl),
                  Text('POSTER STYLE', style: ZaveType.kicker),
                  SizedBox(height: ZaveSpace.md),
                  Wrap(
                    spacing: ZaveSpace.sm,
                    runSpacing: ZaveSpace.sm,
                    children: <Widget>[
                      // Explicit, and first. "No style" is the default and has
                      // to be reachable again after a tap, or the first chip
                      // the user tries becomes permanent.
                      ZaveChip(
                        label: 'None',
                        selected: _posterTag == null,
                        onTap: busy
                            ? null
                            : () => setState(() => _posterTag = null),
                      ),
                      for (final PosterTagOption option in styles)
                        ZaveChip(
                          label: option.label,
                          selected: option.tag == _posterTag,
                          onTap: busy
                              ? null
                              : () => setState(() => _posterTag = option.tag),
                        ),
                    ],
                  ),
                ],

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

                SizedBox(height: ZaveSpace.xl),
                _ReferenceField(
                  controller: _reference,
                  open: _showReference,
                  enabled: !busy,
                  onOpen: () => setState(() => _showReference = true),
                  // Removing clears the text as well as the box. Leaving it
                  // behind would send a reference the user had just taken off
                  // the screen.
                  onRemove: () => setState(() {
                    _showReference = false;
                    _reference.clear();
                  }),
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

/// "Use a post as a reference" — a link until asked for, a textarea after.
///
/// Stateless, with the open flag owned by the sheet, because the sheet is what
/// has to clear the controller on remove; splitting that across two widgets is
/// how a cleared field and a visible one get out of step.
class _ReferenceField extends StatelessWidget {
  const _ReferenceField({
    required this.controller,
    required this.open,
    required this.enabled,
    required this.onOpen,
    required this.onRemove,
  });

  final TextEditingController controller;
  final bool open;
  final bool enabled;
  final VoidCallback onOpen;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    if (!open) {
      return Align(
        alignment: Alignment.centerLeft,
        child: _TextAction(
          label: '+ Use a post as a reference',
          color: ZaveColors.peri,
          onTap: enabled ? onOpen : null,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(child: Text('REFERENCE POST', style: ZaveType.kicker)),
            _TextAction(
              label: 'Remove',
              color: ZaveColors.ink45,
              onTap: enabled ? onRemove : null,
            ),
          ],
        ),
        SizedBox(height: ZaveSpace.sm),
        ZaveField(
          controller: controller,
          hint: 'Paste a post whose structure you want to borrow…',
          // Says what is and is not borrowed. Someone pasting a competitor's
          // post needs to know this is not a rewrite, and someone who has
          // taught us their voice needs to know this does not replace it.
          helper:
              "I'll borrow its shape and pacing for this post only — not its "
              'words, and not your saved voice.',
          minLines: 3,
          maxLines: 6,
          enabled: enabled,
          textInputAction: TextInputAction.newline,
          keyboardType: TextInputType.multiline,
        ),
      ],
    );
  }
}

/// A tappable line of text. Zave's button set is all filled surfaces, and a
/// filled button would make an optional extra look like a second primary
/// action beside "Write it".
class _TextAction extends StatelessWidget {
  const _TextAction({
    required this.label,
    required this.color,
    required this.onTap,
  });

  final String label;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: ConstrainedBox(
          // Text this short is well under a finger otherwise; the padding is
          // the tap target, not spacing.
          constraints: BoxConstraints(minHeight: ZaveSpace.minTapTarget),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: ZaveSpace.sm),
            child: Align(
              widthFactor: 1,
              child: Opacity(
                opacity: onTap == null ? 0.5 : 1,
                child: Text(
                  label,
                  style: ZaveType.caption.copyWith(color: color),
                ),
              ),
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
              "You don't have enough XP to generate a post.",
              style: ZaveType.caption.copyWith(color: ZaveColors.amber),
            ),
          ),
          SizedBox(width: ZaveSpace.md),
          // The sentence used to end "…top up from Pricing" and stop there,
          // which names the fix and withholds the way to it. Pricing is a
          // route; say it with the route.
          ZaveButton(
            label: 'Top up',
            onPressed: () => context.push(ZaveRoutes.pricing),
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

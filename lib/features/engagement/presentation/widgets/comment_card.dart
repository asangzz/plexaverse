import 'package:flutter/material.dart';

import '../../../../core/ui/zave/zave_kit.dart';
import '../../domain/engagement_repository.dart';

/// One drafted comment, editable, with its copy action.
///
/// The web counterpart is the comment card in `app/(dashboard)/comments/
/// page.tsx`: a numbered status chip, the "Find a post about:" line, a
/// textarea, and a Copy Comment button that also opens LinkedIn's search in a
/// side drawer.
///
/// ## Three deliberate departures
///
/// 1. **The card does not turn green when sent.** The web tints the whole
///    surface `#00DC82/5`. In Zave, depth is a fill step and colour names a
///    status — so the status is carried by the dot and its label, the way every
///    other list row in this app carries one.
/// 2. **Two actions, not a drawer.** "Copy & open LinkedIn" does what the
///    web's copy-then-open-the-panel does; "Find posts" opens the same search
///    without copying and without marking the card sent, which is the web's
///    separate `openSearch`.
/// 3. **Copy is a ghost button, not the primary one.** One white button per
///    screen, and on this screen that is "Finish step".
///
/// The edit-then-teach behaviour IS ported: when the user rewrites a draft and
/// leaves the field, the new text goes to `/ai/style-memory`. That is the
/// mechanism behind the product's "sounds like me" claim, and the web fires it
/// on the textarea's blur for exactly the same reason.
class CommentCard extends StatefulWidget {
  const CommentCard({
    required this.index,
    required this.draft,
    required this.onChanged,
    required this.onEditFinished,
    required this.onCopyComment,
    required this.onOpenSearch,
    super.key,
  });

  /// Zero-based. Displayed as `index + 1`, as on the web.
  final int index;

  final CommentDraft draft;

  final ValueChanged<String> onChanged;

  /// The field lost focus — teach the edit if there is one.
  final VoidCallback onEditFinished;

  final VoidCallback onCopyComment;

  /// Opens LinkedIn's post search for this draft's keywords.
  ///
  /// Was "Copy search", which handed the user the terms and left them to find
  /// LinkedIn's search box themselves. The web has always opened the search
  /// (`openSearch` in its comments page); the app only copied because it had
  /// no launcher.
  final VoidCallback onOpenSearch;

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  late final TextEditingController _text = TextEditingController(
    text: widget.draft.comment,
  );
  final FocusNode _node = FocusNode();

  /// The last 2 seconds' worth of "Copied!", matching the web's 2000ms reset.
  bool _justCopied = false;

  @override
  void initState() {
    super.initState();
    _node.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    // Blur is the teach trigger, exactly as on the web. It must survive the
    // keyboard being dismissed by a tap elsewhere, which is why this hangs off
    // the focus node rather than off a submit action — a multi-line field has
    // no submit.
    if (!_node.hasFocus) widget.onEditFinished();
  }

  @override
  void dispose() {
    _node.removeListener(_onFocusChange);
    _node.dispose();
    _text.dispose();
    super.dispose();
  }

  Future<void> _copy() async {
    widget.onCopyComment();
    if (!mounted) return;
    setState(() => _justCopied = true);
    await Future<void>.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => _justCopied = false);
  }

  @override
  Widget build(BuildContext context) {
    final CommentDraft draft = widget.draft;
    final int length = _text.text.length;

    return ZaveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text('COMMENT ${widget.index + 1}', style: ZaveType.kicker),
              const Spacer(),
              ZaveDot(draft.isSent ? ZaveColors.green : ZaveColors.ink35),
              SizedBox(width: ZaveSpace.sm),
              Text(
                draft.isSent ? 'Deployed' : 'Not yet',
                style: ZaveType.caption.copyWith(
                  color: draft.isSent ? ZaveColors.green : ZaveColors.ink50,
                ),
              ),
            ],
          ),
          SizedBox(height: ZaveSpace.md),

          // The web's "Find a post about: {targetPostTitle}". This is a KIND
          // of post, not a real one — nothing in the product knows which post
          // the user will land on.
          Text('FIND A POST ABOUT', style: ZaveType.kicker),
          SizedBox(height: ZaveSpace.xs),
          Text(draft.targetPostTitle, style: ZaveType.body),
          SizedBox(height: ZaveSpace.lg),

          ZaveField(
            controller: _text,
            focusNode: _node,
            maxLines: 6,
            minLines: 3,
            hint: 'Your comment',
            onChanged: (String value) {
              widget.onChanged(value);
              // Only the counter depends on the raw length, and the field
              // repaints itself — this keeps the counter honest without
              // rebuilding the whole card on every keystroke elsewhere.
              setState(() {});
            },
          ),
          SizedBox(height: ZaveSpace.sm),
          Text(
            '$length / ${CommentDraft.charLimit}',
            style: ZaveType.caption.copyWith(
              // Amber past the limit, never red — Zave has no red, and an
              // over-long comment is a warning rather than a failure.
              color: length > CommentDraft.charLimit
                  ? ZaveColors.amber
                  : ZaveColors.ink45,
            ),
          ),

          SizedBox(height: ZaveSpace.lg),
          // Stacked, not side by side.
          //
          // A ghost button spends 82 points before its label: 26 of padding
          // each side, a 20-point icon, a 10-point gap. Two of them in a row
          // inside a card (24 of card padding each side, 12 between) leave
          // about 89 points each — roughly nine characters of Manrope 16.
          //
          // That is why the old "Copy search" rendered as "Copy s...": the
          // secondary button has been truncating since before these labels
          // changed. Widening the flex only moved the ellipsis. Full width
          // gives each label ~272 points and stays correct on a 375-point
          // iPhone SE, where a side-by-side pair cannot fit either label.
          ZaveButton(
            label: _justCopied ? 'Copied' : 'Copy & open LinkedIn',
            icon: Icon(_justCopied ? Icons.check : Icons.copy_all_outlined),
            expand: true,
            onPressed: draft.hasText ? _copy : null,
          ),
          SizedBox(height: ZaveSpace.md),
          ZaveButton(
            label: 'Find posts',
            icon: const Icon(Icons.search),
            expand: true,
            onPressed: draft.searchKeywords.isEmpty
                ? null
                : widget.onOpenSearch,
          ),
        ],
      ),
    );
  }
}

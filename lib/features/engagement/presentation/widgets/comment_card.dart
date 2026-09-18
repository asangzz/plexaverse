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
/// 2. **There is no "open LinkedIn" action.** The web's `LinkedInWebviewPanel`
///    needs a browser; this build has neither a URL launcher nor a webview.
///    The search terms are offered as a second copy action instead, so the
///    user can paste them into the LinkedIn app themselves.
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
    required this.onCopySearch,
    super.key,
  });

  /// Zero-based. Displayed as `index + 1`, as on the web.
  final int index;

  final CommentDraft draft;

  final ValueChanged<String> onChanged;

  /// The field lost focus — teach the edit if there is one.
  final VoidCallback onEditFinished;

  final VoidCallback onCopyComment;
  final VoidCallback onCopySearch;

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
          Row(
            children: <Widget>[
              Expanded(
                flex: 3,
                child: ZaveButton(
                  label: _justCopied ? 'Copied' : 'Copy comment',
                  icon: Icon(
                    _justCopied ? Icons.check : Icons.copy_all_outlined,
                  ),
                  expand: true,
                  onPressed: draft.hasText ? _copy : null,
                ),
              ),
              SizedBox(width: ZaveSpace.md),
              Expanded(
                flex: 2,
                child: ZaveButton(
                  label: 'Copy search',
                  icon: const Icon(Icons.search),
                  expand: true,
                  onPressed: draft.searchKeywords.isEmpty
                      ? null
                      : widget.onCopySearch,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

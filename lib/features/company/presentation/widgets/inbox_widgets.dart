import 'package:flutter/material.dart';

import '../../../../core/ui/zave/zave_kit.dart';
import '../../domain/company_post.dart';
import '../../domain/inbox_comment.dart';
import 'company_formats.dart';

/// One of the company page's posts, in the "Target a Post" list.
///
/// The web keeps this list beside the inbox in a 12-column split and stacks
/// the two panes on a phone — which produces a scroller above a scroller, each
/// with its own max-height. That layout is not ported. On a phone this is a
/// list, and tapping a row opens that post's inbox as its own screen.
class InboxPostRow extends StatelessWidget {
  const InboxPostRow({required this.post, required this.onTap, super.key});

  final CompanyPostItem post;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final DateTime? published = post.publishedOn;

    return ZaveCard(
      size: ZaveCardSize.compact,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  published == null
                      ? 'UNDATED'
                      : companyFullDate.format(published).toUpperCase(),
                  style: ZaveType.kicker,
                ),
              ),
              if (post.isAdvocated) ...<Widget>[
                // Amber is "waiting / featured" in this palette, which is what
                // an advocacy feature is: queued for the team to amplify.
                const ZaveDot(ZaveColors.amber),
                SizedBox(width: ZaveSpace.sm),
                Text(
                  'Featured',
                  style: ZaveType.caption.copyWith(color: ZaveColors.amber),
                ),
                SizedBox(width: ZaveSpace.md),
              ],
              if (post.hasComments)
                Text(
                  '${post.stats.commentCount} Comments',
                  style: ZaveType.caption.copyWith(color: ZaveColors.peri),
                ),
            ],
          ),
          SizedBox(height: ZaveSpace.md),
          Text(
            post.text,
            style: ZaveType.body,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

/// One inbound comment with its AI-drafted reply.
///
/// Stateful because the editor owns a [TextEditingController]: the draft in
/// the controller's state is the source of truth for publishing, and this is
/// the local mirror of it. The controller is only overwritten when the state's
/// draft actually diverges from what is typed, so a rebuild mid-sentence does
/// not move the caret.
class InboxCommentCard extends StatefulWidget {
  const InboxCommentCard({
    required this.comment,
    required this.draft,
    required this.reacting,
    required this.reacted,
    required this.alreadyReacted,
    required this.publishing,
    required this.onDraftChanged,
    required this.onReact,
    required this.onPublish,
    super.key,
  });

  final InboxComment comment;
  final String draft;
  final bool reacting;
  final bool reacted;
  final bool alreadyReacted;
  final bool publishing;
  final ValueChanged<String> onDraftChanged;
  final VoidCallback onReact;
  final VoidCallback onPublish;

  @override
  State<InboxCommentCard> createState() => _InboxCommentCardState();
}

class _InboxCommentCardState extends State<InboxCommentCard> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.draft,
  );

  @override
  void didUpdateWidget(InboxCommentCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.draft != _controller.text) {
      _controller.text = widget.draft;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// What the react control says, from [CommentReaction]'s two label sets.
  String get _reactLabel {
    if (widget.reacting) return 'Reacting…';
    if (widget.alreadyReacted) return 'Already reacted';
    if (widget.reacted) return widget.comment.reaction.doneLabel;
    return widget.comment.reaction.idleLabel;
  }

  /// Green once the reaction landed. Ink-35 for one that was already there
  /// (nothing happened and nothing needs to) and for one not yet sent — the
  /// dot only ever claims the reaction THIS session put on LinkedIn.
  Color get _reactSignal =>
      widget.reacted ? ZaveColors.green : ZaveColors.ink35;

  bool get _settled => widget.reacted || widget.alreadyReacted;

  @override
  Widget build(BuildContext context) {
    final bool canPublish =
        !widget.publishing && _controller.text.trim().isNotEmpty;

    return ZaveCard(
      size: ZaveCardSize.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  InboxComment.authorFallback.toUpperCase(),
                  style: ZaveType.kicker,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: ZaveSpace.md),
              Text(
                companyTimestamp.format(widget.comment.receivedAt),
                style: ZaveType.caption,
              ),
            ],
          ),
          SizedBox(height: ZaveSpace.md),
          Text(widget.comment.text, style: ZaveType.body),
          SizedBox(height: ZaveSpace.md),
          Row(
            children: <Widget>[
              ZaveDot(_reactSignal),
              SizedBox(width: ZaveSpace.sm),
              ZaveChip(
                label: _reactLabel,
                selected: widget.reacted,
                // A settled or in-flight reaction takes no more taps. The chip
                // going inert IS the feedback — there is no second state to
                // move to.
                onTap: _settled || widget.reacting ? null : widget.onReact,
              ),
            ],
          ),
          SizedBox(height: ZaveSpace.lg),

          // The reply editor. Indented and rule-separated, standing in for the
          // web's threaded connector lines — same "this hangs off the comment
          // above" reading, without two hairlines at negative offsets.
          Container(
            padding: EdgeInsets.only(left: ZaveSpace.lg),
            decoration: const BoxDecoration(
              border: Border(
                left: BorderSide(color: ZaveColors.rule, width: 1),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('SUGGESTED REPLY', style: ZaveType.kicker),
                SizedBox(height: ZaveSpace.sm),
                ZaveField(
                  controller: _controller,
                  hint: 'Drafting reply...',
                  maxLines: 6,
                  minLines: 3,
                  onChanged: (String value) {
                    widget.onDraftChanged(value);
                    // The publish button's enablement reads the controller, so
                    // it has to rebuild as the first character is typed.
                    setState(() {});
                  },
                ),
                SizedBox(height: ZaveSpace.md),
                Align(
                  alignment: Alignment.centerRight,
                  child: ZaveButton(
                    label: 'Publish Only This',
                    onPressed: canPublish ? widget.onPublish : null,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

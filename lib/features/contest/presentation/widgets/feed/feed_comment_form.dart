import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/responsive/screen_util.dart';
import '../../../../../core/ui/zave/zave_kit.dart';
import '../../../application/feed_comments_controllers.dart';
import '../../../domain/contest_links.dart';
import '../../../domain/contest_repository.dart';
import '../../../domain/contest_words.dart';
import '../contest_kit.dart';
import 'feed_words.dart';
import 'sent_links.dart';

/// ONE link field: "Comment k of 5". The web's `Form` in `FeedComments.tsx`.
///
/// The link is checked with the server's own rule against today's links —
/// on leaving the field and on send, not while typing — so a wrong one is
/// flagged in its field before anything is sent. A refusal the server still
/// makes (a comment sent on an earlier day, a race) shows in the same place.
/// After a send the field clears and moves on to the next comment, with a
/// short confirmation.
///
/// The warning about false claims sits BEFORE the button, with the real
/// penalty in it: the learner reads what a false link costs before they can
/// send one.
class FeedCommentForm extends ConsumerStatefulWidget {
  const FeedCommentForm({
    required this.view,
    required this.sent,
    this.linkPoints,
    super.key,
  });

  final FeedCommentsView view;

  /// Today's links so far — the read's, moved on by the last send.
  final List<String> sent;
  final List<int>? linkPoints;

  @override
  ConsumerState<FeedCommentForm> createState() => _FeedCommentFormState();
}

class _FeedCommentFormState extends ConsumerState<FeedCommentForm> {
  final TextEditingController _link = TextEditingController();
  final FocusNode _focus = FocusNode();

  /// The field has been left, or a send was tried: from then on it says
  /// what is wrong with the link, not before.
  bool _touched = false;

  @override
  void initState() {
    super.initState();
    _focus.addListener(_onFocus);
  }

  void _onFocus() {
    if (!_focus.hasFocus && !_touched) setState(() => _touched = true);
  }

  @override
  void dispose() {
    _focus.removeListener(_onFocus);
    _focus.dispose();
    _link.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    setState(() => _touched = true);
    final bool sent = await ref
        .read(feedCommentsActionsProvider.notifier)
        .send(_link.text);
    if (!sent || !mounted) return;
    _link.clear();
    setState(() => _touched = false);
  }

  @override
  Widget build(BuildContext context) {
    final FeedCommentsSend send = ref.watch(feedCommentsActionsProvider);
    final FeedCommentsView view = widget.view;
    final int perDay = view.perDay;
    final int k = widget.sent.length + 1;
    final FeedCommentLinkProblem? problem = _touched
        ? checkFeedCommentLink(_link.text, widget.sent)
        : null;
    final String? error = problem != null
        ? feedProblemText(problem)
        : send.error;
    final String shares = feedSharesLine(view);
    final FeedCommentSubmitResult? last = send.last;

    return Semantics(
      label: 'Your comments, one at a time',
      container: true,
      child: ContestPanel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Your $perDay comments, one at a time',
              style: ContestType.cardTitle,
            ),
            SizedBox(height: ZaveSpace.xs),
            Text(kFeedHowLine, style: ContestType.meta),
            if (shares.isNotEmpty) ...<Widget>[
              SizedBox(height: ZaveSpace.xs),
              Text(shares, style: ContestType.meta),
            ],
            if (last != null && last.n == widget.sent.length) ...<Widget>[
              SizedBox(height: ZaveSpace.lg),
              Semantics(
                liveRegion: true,
                child: Text(
                  'Comment ${last.n} sent'
                  '${last.pointsApplied > 0 ? ' · +${formatCount(last.pointsApplied)} XP' : ''}'
                  '. Now comment $k.',
                  style: ZaveType.body.copyWith(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: ZaveColors.white,
                  ),
                ),
              ),
            ],
            SizedBox(height: ZaveSpace.xl),
            Text(
              'Comment $k of $perDay',
              style: ZaveType.body.copyWith(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: ZaveColors.white,
              ),
            ),
            SizedBox(height: 6.h),
            _LinkField(
              controller: _link,
              focusNode: _focus,
              error: error,
              onChanged: (_) {
                ref.read(feedCommentsActionsProvider.notifier).clearError();
                // Re-checked as it changes once it has been left — the line
                // must not keep naming a problem the learner just fixed.
                if (_touched) setState(() {});
              },
              onSubmitted: (_) => _send(),
            ),
            SizedBox(height: ZaveSpace.xl),
            FeedWarning(penalty: view.penalty),
            SizedBox(height: ZaveSpace.xl),
            ContestPrimaryPill(
              label: 'Send comment $k',
              busy: send.busy,
              onPressed: _send,
            ),
            if (widget.sent.isNotEmpty) ...<Widget>[
              SizedBox(height: ZaveSpace.xl),
              Text(
                'Sent today · ${widget.sent.length} of $perDay',
                style: ZaveType.body.copyWith(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: ZaveColors.white,
                ),
              ),
              SizedBox(height: ZaveSpace.sm),
              SentLinks(
                links: widget.sent,
                points: widget.linkPoints,
                label: 'Comments sent today',
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// The link field, drawn the contest's way: a wrong link turns its border
/// red and says why underneath, in red — the contest names a wrong thing in
/// red, where the app's own field uses amber.
class _LinkField extends StatelessWidget {
  const _LinkField({
    required this.controller,
    required this.focusNode,
    required this.error,
    required this.onChanged,
    required this.onSubmitted,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final String? error;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;

  @override
  Widget build(BuildContext context) {
    final String? said = error;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: ZaveGlass.rest,
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              color: said != null
                  ? ContestColors.wrongDot
                  : ZaveGlass.restBorder,
            ),
          ),
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            keyboardType: TextInputType.url,
            textInputAction: TextInputAction.send,
            autocorrect: false,
            enableSuggestions: false,
            onChanged: onChanged,
            onSubmitted: onSubmitted,
            cursorColor: ZaveColors.white,
            style: ZaveType.body.copyWith(
              fontSize: 15.sp,
              color: ZaveColors.white,
            ),
            decoration: InputDecoration(
              isDense: true,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: EdgeInsets.zero,
              semanticCounterText: '',
              hintText: 'https://www.linkedin.com/feed/update/…',
              hintStyle: ZaveType.body.copyWith(
                fontSize: 15.sp,
                color: ZaveColors.ink50,
              ),
              hintMaxLines: 1,
            ),
          ),
        ),
        if (said != null) ...<Widget>[
          SizedBox(height: 6.h),
          Semantics(
            liveRegion: true,
            child: Text(
              said,
              style: ContestType.meta.copyWith(
                fontSize: 13.sp,
                color: ContestColors.wrongText,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

/// "We check these." — the false-claim rule with the real penalty, in a
/// red-edged box. The web's `Warning`.
class FeedWarning extends StatelessWidget {
  const FeedWarning({required this.penalty, super.key});

  final int penalty;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'We check these',
      container: true,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: ContestColors.wrongDot.withValues(alpha: 0.08),
          border: Border.all(color: ContestColors.wrongDot),
          borderRadius: BorderRadius.circular(18.r),
        ),
        child: Text(
          feedWarningLine(penalty),
          style: ZaveType.body.copyWith(
            fontSize: 15.sp,
            height: 1.55,
            fontWeight: FontWeight.w600,
            color: ZaveColors.white,
          ),
        ),
      ),
    );
  }
}

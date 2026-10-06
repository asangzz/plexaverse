import 'package:flutter/material.dart';

import '../../../../core/ui/zave/zave_kit.dart';

/// One thing the day asks for.
///
/// The same card serves all three lanes — a curated post, a comment for the
/// user's own niche, a person to write to — because from the user's side they
/// are the same shape: here is something to say, here is where to say it, tell
/// me when you have.
///
/// ## Why the action says "I did this" and not "Done"
///
/// Nothing in this product can observe whether a comment was left or an
/// invitation sent; LinkedIn exposes no such read on any scope the app holds.
/// Every tick is the user's own account of their day. "Done" would read as the
/// product having checked — this card must not imply a verification that does
/// not exist, and the whole thread is honest only if each row is.
class PlexaItemCard extends StatelessWidget {
  const PlexaItemCard({
    required this.kicker,
    required this.body,
    required this.draft,
    required this.isDone,
    required this.onToggleDone,
    this.onOpen,
    this.onCopy,
    this.badge,
    super.key,
  });

  /// What this is about — an author's name, the kind of post a comment fits,
  /// or a role at a company.
  final String kicker;

  /// The thing to read: the post's opening line, or the text to send.
  final String body;

  /// A second block under [body], for a lane where the two differ — a curated
  /// post shows the post's first line AND the comment written for it. Empty
  /// when [body] is already the draft.
  final String draft;

  final bool isDone;
  final VoidCallback onToggleDone;

  /// Opens LinkedIn at the post, the search, or the person.
  final VoidCallback? onOpen;

  final VoidCallback? onCopy;

  /// A small qualifier — "Direct message" on the one connection card in five
  /// that is a DM rather than a request.
  final String? badge;

  @override
  Widget build(BuildContext context) {
    return ZaveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ZaveRowCircle(
                icon: isDone ? Icons.check_rounded : Icons.bolt_outlined,
                tone: isDone ? ZaveRowTone.done : ZaveRowTone.rest,
              ),
              SizedBox(width: ZaveSpace.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    if (kicker.isNotEmpty)
                      Text(
                        kicker.toUpperCase(),
                        style: ZaveType.kicker,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    if (badge != null) ...<Widget>[
                      SizedBox(height: ZaveSpace.xs),
                      ZavePill(label: badge!, color: ZaveColors.amber),
                    ],
                    SizedBox(height: ZaveSpace.sm),
                    Text(
                      body,
                      style: ZaveType.body.copyWith(
                        // Struck through would be unreadable at this length,
                        // so a cleared row dims instead. The circle carries
                        // the state; the text only has to get out of the way.
                        color: isDone ? ZaveColors.ink45 : ZaveColors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          if (draft.isNotEmpty) ...<Widget>[
            SizedBox(height: ZaveSpace.md),
            Container(
              width: double.infinity,
              decoration: ZaveSurface.row,
              padding: ZaveSpace.rowPad,
              child: Text(draft, style: ZaveType.body),
            ),
          ],

          SizedBox(height: ZaveSpace.lg),
          // Stacked, not a row. Three ghost buttons side by side leave each
          // one about nine characters after its padding and icon — the same
          // arithmetic that rendered "Find posts" as "F..." on the engagement
          // cards.
          if (onOpen != null) ...<Widget>[
            ZaveButton(
              label: 'Open on LinkedIn',
              icon: const Icon(Icons.open_in_new_rounded),
              expand: true,
              onPressed: onOpen,
            ),
            SizedBox(height: ZaveSpace.sm),
          ],
          if (onCopy != null) ...<Widget>[
            ZaveButton(
              label: 'Copy the text',
              icon: const Icon(Icons.copy_all_outlined),
              expand: true,
              onPressed: onCopy,
            ),
            SizedBox(height: ZaveSpace.sm),
          ],
          ZaveButton(
            label: isDone ? 'Not yet, actually' : 'I did this',
            kind: isDone ? ZaveButtonKind.ghost : ZaveButtonKind.primarySmall,
            icon: Icon(isDone ? Icons.undo_rounded : Icons.check_rounded),
            expand: true,
            onPressed: onToggleDone,
          ),
        ],
      ),
    );
  }
}

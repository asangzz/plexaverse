import 'package:flutter/material.dart';

import '../../../../core/ui/zave/zave_kit.dart';
import '../../domain/engagement_repository.dart';

/// One connection target: who to look for, and the note already written.
///
/// The web counterpart is the connection card in `app/(dashboard)/connections/
/// page.tsx` — a numbered status chip, `{role} @ {company}`, a monospaced
/// search query, the note in italic quotes with a `{len}/280` counter, and a
/// Send Request button that copies the note and opens LinkedIn's people search
/// in a side drawer.
///
/// ## What changed, and why
///
/// * **No drawer.** The web's panel becomes a hand-off to the LinkedIn app:
///   "Copy & open LinkedIn" copies the note and opens the people search,
///   "Find people" opens it without claiming the card as sent.
/// * **The premium badge is a pill, not a red-on-amber chip.** In Zave, amber
///   is the "needs your attention" signal, which is exactly what a direct-
///   message card is: it behaves differently from the other four.
/// * **The card does not tint green when sent.** Status is the dot and its
///   label, as everywhere else in this app.
///
/// The note is deliberately NOT editable here, matching the web: these notes
/// are written against LinkedIn's 280-character cap and the counter exists to
/// warn when the model overshot it.
class ConnectionCard extends StatefulWidget {
  const ConnectionCard({
    required this.index,
    required this.target,
    required this.onCopyNote,
    required this.onOpenSearch,
    super.key,
  });

  /// Zero-based. Displayed as `index + 1`, as on the web.
  final int index;

  final ConnectionTarget target;
  final VoidCallback onCopyNote;

  /// Opens LinkedIn's people search for this target.
  ///
  /// Was "Copy search". The web opens `connection.linkedinSearchUrl` here;
  /// the app only copied the raw query because it had no launcher.
  final VoidCallback onOpenSearch;

  @override
  State<ConnectionCard> createState() => _ConnectionCardState();
}

class _ConnectionCardState extends State<ConnectionCard> {
  /// The web's 2000ms "Copied!" reset.
  bool _justCopied = false;

  Future<void> _copy() async {
    widget.onCopyNote();
    if (!mounted) return;
    setState(() => _justCopied = true);
    await Future<void>.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => _justCopied = false);
  }

  @override
  Widget build(BuildContext context) {
    final ConnectionTarget target = widget.target;

    return ZaveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text('TARGET ${widget.index + 1}', style: ZaveType.kicker),
              const Spacer(),
              ZaveDot(target.isSent ? ZaveColors.green : ZaveColors.ink35),
              SizedBox(width: ZaveSpace.sm),
              Text(
                target.isSent ? 'Sent' : 'Not yet',
                style: ZaveType.caption.copyWith(
                  color: target.isSent ? ZaveColors.green : ZaveColors.ink50,
                ),
              ),
            ],
          ),
          SizedBox(height: ZaveSpace.md),

          Text(target.role, style: ZaveType.h3),
          SizedBox(height: ZaveSpace.xs),
          Text(
            target.company,
            style: ZaveType.label.copyWith(color: ZaveColors.peri),
          ),

          if (target.isDirectMessage) ...<Widget>[
            SizedBox(height: ZaveSpace.md),
            const ZavePill(
              label: 'Direct message · premium profile',
              color: ZaveColors.amber,
              leading: ZaveDot(ZaveColors.amber),
            ),
          ],

          SizedBox(height: ZaveSpace.lg),
          Text('SEARCH LINKEDIN FOR', style: ZaveType.kicker),
          SizedBox(height: ZaveSpace.sm),
          Container(
            width: double.infinity,
            padding: ZaveSpace.inputPad,
            decoration: ZaveSurface.codeBlock,
            child: Text(target.searchQuery, style: ZaveType.mono),
          ),

          SizedBox(height: ZaveSpace.lg),
          Text('THE NOTE', style: ZaveType.kicker),
          SizedBox(height: ZaveSpace.sm),
          Container(
            width: double.infinity,
            padding: ZaveSpace.rowPad,
            decoration: ZaveSurface.row,
            child: Text(
              target.note,
              style: ZaveType.body.copyWith(fontStyle: FontStyle.italic),
            ),
          ),
          if (target.showsNoteCounter) ...<Widget>[
            SizedBox(height: ZaveSpace.sm),
            Text(
              '${target.note.length} / ${ConnectionTarget.noteLimit}',
              style: ZaveType.caption.copyWith(
                // Amber near and past the cap. Never red: Zave has none, and
                // an over-long note is a warning, not a destructive state.
                color: target.isNoteNearLimit
                    ? ZaveColors.amber
                    : ZaveColors.ink45,
              ),
            ),
          ],

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
            onPressed: target.note.isEmpty ? null : _copy,
          ),
          SizedBox(height: ZaveSpace.md),
          ZaveButton(
            label: 'Find people',
            icon: const Icon(Icons.search),
            expand: true,
            // Gated on the resolved URL, not on `searchQuery`: a target
            // can carry the server's URL with an empty query, and that
            // one is perfectly openable.
            onPressed: target.searchUrl == null ? null : widget.onOpenSearch,
          ),
        ],
      ),
    );
  }
}

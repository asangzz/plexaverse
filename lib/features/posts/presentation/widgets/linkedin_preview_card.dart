import 'package:flutter/material.dart';

import '../../../../core/ui/zave/zave_kit.dart';
import '../../domain/library_post.dart';
import 'post_card.dart' show PostImage;

/// The post as LinkedIn will render it — the web's "LinkedIn Preview" card on
/// `/posts/[id]`.
///
/// ## Why there is a white card in a dark app
///
/// This is the one surface in the product that is deliberately NOT the app's
/// own language, and that is the point: the user is checking what their post
/// will look like on LinkedIn, so it has to look like LinkedIn, not like
/// Plexaverse. The web makes the same call (`bg-white border-gray-200`).
///
/// It is still built entirely from Zave tokens. Zave already owns a
/// white-surface-with-ink-letters pairing — it is what a primary button and a
/// selected chip are — so the card is [ZaveColors.white] with [ZaveColors.ink]
/// text, and the two de-emphasised steps are ink at the SAME ratios the
/// white-on-dark scale uses:
///
///   • secondary text → ink at 0.62, the `--zv-ink-62` step's ratio
///   • hairline       → ink at 0.12, the `--zv-rule` step's ratio
///
/// so the preview's internal hierarchy is the system's hierarchy, inverted,
/// rather than a set of greys invented for this one screen.
class LinkedInPreviewCard extends StatefulWidget {
  const LinkedInPreviewCard({required this.post, super.key});

  final LibraryPost post;

  @override
  State<LinkedInPreviewCard> createState() => _LinkedInPreviewCardState();
}

class _LinkedInPreviewCardState extends State<LinkedInPreviewCard> {
  /// LinkedIn itself cuts a post at roughly this length behind a "see more",
  /// and the web preview hard-codes the same number.
  static const int _foldAt = 250;

  bool _expanded = false;

  /// The ink hierarchy on a white surface. See the class doc: these are the
  /// `--zv-ink-62` and `--zv-rule` ratios applied to [ZaveColors.ink] instead
  /// of to white, not new values.
  static final Color _inkSecondary = ZaveColors.ink.withValues(alpha: 0.62);
  static final Color _inkRule = ZaveColors.ink.withValues(alpha: 0.12);

  @override
  Widget build(BuildContext context) {
    final LibraryPost post = widget.post;
    final List<String> images = post.allImages;
    final bool folds = post.content.length > _foldAt;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: ZaveColors.white,
        borderRadius: ZaveRadius.cardBr,
      ),
      child: ClipRRect(
        borderRadius: ZaveRadius.cardBr,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(ZaveSpace.lg),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _Avatar(name: post.account?.profileName),
                  SizedBox(width: ZaveSpace.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          post.account?.profileName ?? 'Your Name',
                          style: ZaveType.label.copyWith(color: ZaveColors.ink),
                        ),
                        SizedBox(height: ZaveSpace.xs),
                        Row(
                          children: <Widget>[
                            Icon(Icons.public, size: 12, color: _inkSecondary),
                            SizedBox(width: ZaveSpace.xs),
                            Text(
                              'Public',
                              style: ZaveType.caption.copyWith(
                                color: _inkSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(
                ZaveSpace.lg,
                0,
                ZaveSpace.lg,
                ZaveSpace.md,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    folds && !_expanded
                        ? '${post.content.substring(0, _foldAt)}...'
                        : post.content,
                    style: ZaveType.body.copyWith(color: ZaveColors.ink),
                  ),
                  if (folds) ...<Widget>[
                    SizedBox(height: ZaveSpace.sm),
                    GestureDetector(
                      onTap: () => setState(() => _expanded = !_expanded),
                      behavior: HitTestBehavior.opaque,
                      child: Text(
                        _expanded ? 'see less' : 'see more',
                        // LinkedIn tints this `#0077B5`, which is not a token
                        // and is exactly the kind of imported brand blue Zave
                        // forbids. Zave's own link colour is periwinkle, but
                        // periwinkle is a light step and vanishes on white, so
                        // a link on THIS surface takes `horizon` — the dark end
                        // of the same blue family.
                        style: ZaveType.label.copyWith(
                          color: ZaveColors.horizon,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            if (images.isNotEmpty) _Images(urls: images, rule: _inkRule),

            _Hairline(color: _inkRule),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: ZaveSpace.lg,
                vertical: ZaveSpace.md,
              ),
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.thumb_up_alt_outlined,
                    size: 14,
                    color: _inkSecondary,
                  ),
                  SizedBox(width: ZaveSpace.sm),
                  Text(
                    '${post.metrics?.reactions ?? 0}',
                    style: ZaveType.caption.copyWith(color: _inkSecondary),
                  ),
                  const Spacer(),
                  Text(
                    '${post.metrics?.comments ?? 0} comments  ·  '
                    '${post.metrics?.shares ?? 0} reposts',
                    style: ZaveType.caption.copyWith(color: _inkSecondary),
                  ),
                ],
              ),
            ),

            _Hairline(color: _inkRule),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: ZaveSpace.lg,
                vertical: ZaveSpace.md,
              ),
              // Static labels, not buttons. The web renders these as `<button>`
              // elements with no handler; a control that visibly does nothing
              // when tapped is worse on a phone than a label that never invited
              // the tap. They are here because the row is part of what a
              // LinkedIn post looks like, which is the whole job of this card.
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  _ActionLabel(
                    icon: Icons.thumb_up_alt_outlined,
                    label: 'Like',
                    color: _inkSecondary,
                  ),
                  _ActionLabel(
                    icon: Icons.mode_comment_outlined,
                    label: 'Comment',
                    color: _inkSecondary,
                  ),
                  _ActionLabel(
                    icon: Icons.repeat,
                    label: 'Repost',
                    color: _inkSecondary,
                  ),
                  _ActionLabel(
                    icon: Icons.send_outlined,
                    label: 'Send',
                    color: _inkSecondary,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The author's initial on an ink disc.
///
/// The web paints a `#5761EB → #00AAFF` gradient here. Zave's only brand fill
/// is [ZaveColors.blue], and it is reserved for the XP / upgrade path — a blue
/// avatar would be a miscolour, not a style choice — so the disc is ink, which
/// is the correct partner for a white surface.
class _Avatar extends StatelessWidget {
  const _Avatar({this.name});

  final String? name;

  static const double _size = 48;

  @override
  Widget build(BuildContext context) {
    final String initial = (name != null && name!.trim().isNotEmpty)
        ? name!.trim()[0].toUpperCase()
        : 'U';

    return Container(
      height: _size,
      width: _size,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: ZaveColors.ink,
        shape: BoxShape.circle,
      ),
      child: Text(
        initial,
        style: ZaveType.h3.copyWith(color: ZaveColors.white),
      ),
    );
  }
}

/// The post's images: a three-column grid for a carousel (the first nine
/// slides, as the web does), a single full-width image otherwise.
class _Images extends StatelessWidget {
  const _Images({required this.urls, required this.rule});

  final List<String> urls;
  final Color rule;

  /// The web caps the single-image preview at 320px so a tall poster does not
  /// push the engagement bar off the screen.
  static const double _singleMaxHeight = 320;

  @override
  Widget build(BuildContext context) {
    if (urls.length == 1) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _Hairline(color: rule),
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: _singleMaxHeight),
            child: PostImage(url: urls.first),
          ),
        ],
      );
    }

    final List<String> slides = urls.take(9).toList(growable: false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _Hairline(color: rule),
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          // The web's `gap-1` — 4px, which is ZaveSpace.xs exactly.
          mainAxisSpacing: ZaveSpace.xs,
          crossAxisSpacing: ZaveSpace.xs,
          children: <Widget>[
            for (final String url in slides) PostImage(url: url),
          ],
        ),
      ],
    );
  }
}

class _Hairline extends StatelessWidget {
  const _Hairline({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) => Container(height: 1, color: color);
}

class _ActionLabel extends StatelessWidget {
  const _ActionLabel({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(icon, size: 16, color: color),
        SizedBox(width: ZaveSpace.xs),
        Text(label, style: ZaveType.caption.copyWith(color: color)),
      ],
    );
  }
}

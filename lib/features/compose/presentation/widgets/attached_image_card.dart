import 'package:flutter/material.dart';

import '../../../../core/ui/zave/zave_kit.dart';
import '../../domain/compose_draft.dart';
import 'compose_image_view.dart';

/// "Attached image" — the generated poster, with remove and regenerate.
///
/// Ports the web composer's attached-image panel (recon §4.2.6 item 6) with two
/// Zave corrections:
///
/// • The web's regenerate control is a **solid white FAB** floating on the
///   image. In Zave solid white means "the one primary action on this screen",
///   and that is the submit button — so regenerate is a glass icon button
///   instead. It sits in the same corner and does the same thing; it just stops
///   competing with the action that commits the post.
/// • The web's remove button is `text-red-400` on a red hover. Zave has no red.
///   The control is a plain glass icon button; removing an image is reversible
///   (regenerate is one tap away), so it is not a state that needs a colour at
///   all.
class AttachedImageCard extends StatelessWidget {
  const AttachedImageCard({
    required this.image,
    required this.onRemove,
    required this.onRegenerate,
    required this.regenerating,
    super.key,
  });

  final ComposeImage image;
  final VoidCallback onRemove;

  /// Null when there is no stored brief to regenerate from — an image that
  /// arrived some other way cannot be re-asked for.
  final VoidCallback? onRegenerate;

  final bool regenerating;

  @override
  Widget build(BuildContext context) {
    return ZaveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(child: Text('Attached image', style: ZaveType.h3)),
              if (image.aiGenerated) ...<Widget>[
                const ZavePill(label: 'AI generated', color: ZaveColors.peri),
                SizedBox(width: ZaveSpace.sm),
              ],
              ZaveIconButton(
                icon: const Icon(Icons.close),
                tooltip: 'Remove image',
                onPressed: regenerating ? null : onRemove,
              ),
            ],
          ),
          SizedBox(height: ZaveSpace.lg),
          Stack(
            children: <Widget>[
              ClipRRect(
                borderRadius: ZaveRadius.cardSmBr,
                child: ComposeImageView(
                  image: image,
                  // The web caps this at 192px on a phone (`max-h-48`).
                  height: 192,
                ),
              ),
              if (onRegenerate != null)
                Positioned(
                  right: ZaveSpace.sm,
                  bottom: ZaveSpace.sm,
                  child: regenerating
                      ? Container(
                          height: ZaveSpace.iconBtn,
                          width: ZaveSpace.iconBtn,
                          decoration: ZaveSurface.iconButton,
                          padding: EdgeInsets.all(ZaveSpace.md),
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            color: ZaveColors.white,
                          ),
                        )
                      : ZaveIconButton(
                          icon: const Icon(Icons.refresh),
                          tooltip: 'Regenerate image',
                          onPressed: onRegenerate,
                        ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

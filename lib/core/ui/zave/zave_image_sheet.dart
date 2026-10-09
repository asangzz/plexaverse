import 'package:flutter/material.dart';

import '../../theme/zave/zave.dart';
import 'zave_button.dart';

/// The poster, whole, on a sheet.
///
/// ## Why this exists
///
/// Everywhere a generated image appears in this app it appears CROPPED — the
/// planner card fills a 16:9 strip, the post editor a square — because a card
/// in a list has a shape of its own and the poster has to fit it. A poster is
/// 4:5 or taller, and its title sits near the top, so `BoxFit.cover` on a 16:9
/// strip can cut the words off the thing whose whole job is to carry them.
///
/// So a crop is a thumbnail, never the artwork. Tapping one opens this, which
/// is the only place the image is shown [BoxFit.contain] — the entire poster,
/// letterboxed rather than trimmed.
///
/// ## Full image, never the thumbnail
///
/// `imageThumbUrl` is capped at 160px on its longest edge
/// (`THUMB_MAX_DIMENSION` in uploads.service). That is right for a card and
/// useless here: blown up to a phone's width it is a smear. Callers must pass
/// the real `imageUrl`, which is why [showPosterSheet] takes it rather than
/// reaching for whatever the card happened to render.
Future<void> showPosterSheet(
  BuildContext context, {
  required String imageUrl,
  String? title,
}) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    // The poster decides the height, up to most of the screen — a short image
    // should not be padded out to a sheet's worth of empty ground.
    isScrollControlled: true,
    builder: (BuildContext _) => _PosterSheet(imageUrl: imageUrl, title: title),
  );
}

class _PosterSheet extends StatelessWidget {
  const _PosterSheet({required this.imageUrl, this.title});

  final String imageUrl;
  final String? title;

  @override
  Widget build(BuildContext context) {
    final Size screen = MediaQuery.sizeOf(context);

    return Container(
      constraints: BoxConstraints(maxHeight: screen.height * 0.9),
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
        child: Padding(
          padding: EdgeInsets.all(ZaveSpace.gutter),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
              if (title case final String t when t.isNotEmpty) ...<Widget>[
                SizedBox(height: ZaveSpace.lg),
                Text(
                  t,
                  style: ZaveType.h3,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              SizedBox(height: ZaveSpace.lg),
              // Flexible, not Expanded: a poster shorter than the cap should
              // leave the sheet short rather than stretch to fill it.
              Flexible(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(ZaveRadius.cardSm),
                  child: InteractiveViewer(
                    // The poster's own text is small on a phone, and reading it
                    // is most of why someone opens this.
                    maxScale: 4,
                    child: Image.network(
                      imageUrl,
                      // The whole point. Never `cover` here.
                      fit: BoxFit.contain,
                      errorBuilder: (_, _, _) => _Fallback(
                        icon: Icons.broken_image_outlined,
                        message: 'That image could not be loaded.',
                      ),
                      loadingBuilder:
                          (_, Widget child, ImageChunkEvent? progress) =>
                              progress == null
                              ? child
                              : const _Fallback(
                                  icon: null,
                                  message: 'Loading the full image…',
                                ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: ZaveSpace.lg),
              ZaveButton(
                label: 'Close',
                kind: ZaveButtonKind.primarySmall,
                expand: true,
                onPressed: () => Navigator.of(context).maybePop(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Keeps the sheet a stable size while the full image loads or fails, so it
/// does not snap open and then collapse.
class _Fallback extends StatelessWidget {
  const _Fallback({required this.icon, required this.message});

  final IconData? icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 4 / 5,
      child: ColoredBox(
        color: ZaveGlass.hover,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (icon != null) ...<Widget>[
              Icon(icon, size: 28, color: ZaveColors.ink45),
              SizedBox(height: ZaveSpace.md),
            ] else ...<Widget>[
              const SizedBox.square(
                dimension: 22,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              SizedBox(height: ZaveSpace.md),
            ],
            Text(message, style: ZaveType.caption),
          ],
        ),
      ),
    );
  }
}

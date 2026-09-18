import 'package:flutter/material.dart';

import '../../../../core/ui/zave/zave_kit.dart';
import '../../domain/studio_design.dart';
import 'css_value.dart';

/// One row in the Studio library.
///
/// The web renders these as a four-column grid of thumbnail cards whose edit
/// and delete buttons only appear on hover — which on a phone means they never
/// appear at all. So the actions move onto a persistent trailing control that
/// opens a sheet, and the card itself opens the design. Same two actions, same
/// destructive confirmation; reachable by a finger.
///
/// A summary row carries no element tree (the list endpoint omits `data` to
/// stay small), so the preview is the server's [StudioDesign.thumbnail] when
/// there is one and a proportioned placeholder when there is not — never a
/// spinner, because nothing is loading.
class DesignTile extends StatelessWidget {
  const DesignTile({
    required this.design,
    required this.onOpen,
    this.onMore,
    this.busy = false,
    super.key,
  });

  final StudioDesign design;
  final VoidCallback onOpen;

  /// Opens the actions sheet. Null for a template, which the user copies
  /// rather than edits.
  final VoidCallback? onMore;

  /// The design is being opened or copied.
  final bool busy;

  @override
  Widget build(BuildContext context) {
    return ZaveCard(
      size: ZaveCardSize.medium,
      onTap: busy ? null : onOpen,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _Thumbnail(design: design),
          SizedBox(width: ZaveSpace.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  design.name,
                  style: ZaveType.h3,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: ZaveSpace.sm),
                Text(_meta(design), style: ZaveType.caption),
                if (design.isTemplate ||
                    design.categoryLabel != null) ...<Widget>[
                  SizedBox(height: ZaveSpace.md),
                  Wrap(
                    spacing: ZaveSpace.sm,
                    runSpacing: ZaveSpace.sm,
                    children: <Widget>[
                      if (design.isTemplate)
                        const ZavePill(
                          label: 'Template',
                          color: ZaveColors.peri,
                        ),
                      if (design.categoryLabel != null)
                        ZavePill(
                          label: design.categoryLabel!,
                          color: ZaveColors.ink62,
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          if (busy)
            SizedBox(
              height: ZaveSpace.minTapTarget,
              width: ZaveSpace.minTapTarget,
              child: Center(
                child: SizedBox(
                  height: ZaveSpace.lg,
                  width: ZaveSpace.lg,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    color: ZaveColors.white,
                  ),
                ),
              ),
            )
          else if (onMore != null)
            ZaveIconButton(
              icon: const Icon(Icons.more_horiz),
              tooltip: 'Design actions',
              onPressed: onMore,
            ),
        ],
      ),
    );
  }

  /// "1080 × 1350 · Updated 17 Sep". The date is parsed leniently — a row
  /// whose timestamp we cannot read still deserves its dimensions.
  static String _meta(StudioDesign design) {
    final StringBuffer out = StringBuffer('${design.width} × ${design.height}');
    final DateTime? updated = design.updatedAtDate;
    if (updated != null) {
      const List<String> months = <String>[
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      final DateTime local = updated.toLocal();
      out.write(' · Updated ${local.day} ${months[local.month - 1]}');
    }
    return out.toString();
  }
}

/// The tile's preview square.
class _Thumbnail extends StatelessWidget {
  const _Thumbnail({required this.design});

  final StudioDesign design;

  /// Kept square regardless of the design's own ratio so the list's left edge
  /// stays a column. A 2480×3508 A4 poster beside a 1600×900 banner would
  /// otherwise make every row a different height.
  ///
  /// Zave names no thumbnail size, so this is derived from tokens rather than
  /// invented: one tap target plus one gutter step.
  static double get _size => ZaveSpace.minTapTarget + ZaveSpace.lg;

  @override
  Widget build(BuildContext context) {
    final ImageProvider<Object>? provider = studioImageProvider(
      design.thumbnail,
    );

    return ClipRRect(
      borderRadius: ZaveRadius.inputBr,
      child: SizedBox(
        height: _size,
        width: _size,
        child: provider == null
            ? DecoratedBox(
                decoration: BoxDecoration(
                  color: ZaveGlass.now,
                  border: Border.all(color: ZaveColors.rule, width: 1),
                ),
                child: const Icon(
                  Icons.crop_original_outlined,
                  color: ZaveColors.ink35,
                ),
              )
            : Image(
                image: provider,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) =>
                    const ColoredBox(color: ZaveGlass.now),
              ),
      ),
    );
  }
}

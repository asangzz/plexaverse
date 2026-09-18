import 'package:flutter/material.dart';

import '../../../../core/ui/zave/zave_kit.dart';
import 'ai_tool_image.dart';

/// How a category slug is written for a human.
///
/// The web pairs each slug with an emoji AND a two-colour gradient, and paints
/// the selected chip in that gradient. The emoji and the name carry over; the
/// gradients do not. Zave's first rule is that colour only ever names a status,
/// and "this chip is selected" is already said — loudly — by the inversion to
/// solid white. Ten decorative gradients would be ten colours that mean
/// nothing, on the one control whose colour already means something.
class CategoryLabel {
  const CategoryLabel(this.emoji, this.name);

  final String emoji;
  final String name;
}

/// Reimagine's categories — the Studio design taxonomy.
const Map<String, CategoryLabel> studioCategoryLabels = <String, CategoryLabel>{
  'social_media': CategoryLabel('📱', 'Social Media'),
  'automate_posts_personal': CategoryLabel('📝', 'Automate Posts'),
  'automate_posts_company': CategoryLabel('🏢', 'Company Posts'),
  'presentation': CategoryLabel('📊', 'Presentation'),
  'marketing': CategoryLabel('📣', 'Marketing'),
  'banner': CategoryLabel('🎨', 'Banner'),
  'infographic': CategoryLabel('📈', 'Infographic'),
  'general': CategoryLabel('✨', 'General'),
};

/// Festive's categories — occasions.
const Map<String, CategoryLabel> festiveCategoryLabels =
    <String, CategoryLabel>{
      'new_year': CategoryLabel('🎆', 'New Year'),
      'diwali': CategoryLabel('🪔', 'Diwali'),
      'christmas': CategoryLabel('🎄', 'Christmas'),
      'holi': CategoryLabel('🎨', 'Holi'),
      'eid': CategoryLabel('🌙', 'Eid'),
      'republic_day': CategoryLabel('🇮🇳', 'Republic Day'),
      'independence_day': CategoryLabel('🇮🇳', 'Independence Day'),
      'birthday': CategoryLabel('🎂', 'Birthday'),
      'anniversary': CategoryLabel('💝', 'Anniversary'),
      'general': CategoryLabel('🎉', 'General'),
    };

/// The label for [slug], falling back to `general` and then to the slug itself
/// so a category the server grows tomorrow still renders as something legible.
CategoryLabel categoryLabel(Map<String, CategoryLabel> labels, String slug) {
  final CategoryLabel? hit = labels[slug];
  if (hit != null) return hit;
  final CategoryLabel? fallback = labels['general'];
  return CategoryLabel(fallback?.emoji ?? '✨', slug.replaceAll('_', ' '));
}

/// The horizontally-scrolling category filter above a gallery.
///
/// "All templates" is the leftmost chip and [selected] `null` means it is on —
/// the same shape the web uses, with `'all'` as a magic string it then has to
/// special-case in two places.
class CategoryBar extends StatelessWidget {
  const CategoryBar({
    required this.categories,
    required this.selected,
    required this.labels,
    required this.onSelect,
    super.key,
  });

  final List<String> categories;
  final String? selected;
  final Map<String, CategoryLabel> labels;
  final ValueChanged<String?> onSelect;

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: ZaveSpace.minTapTarget,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        // The bar sits inside a gutter-padded scroll view, so it pads nothing
        // of its own; the first chip lines up with the heading above it.
        padding: EdgeInsets.zero,
        itemCount: categories.length + 1,
        separatorBuilder: (BuildContext _, int _) =>
            SizedBox(width: ZaveSpace.sm),
        itemBuilder: (BuildContext _, int index) {
          if (index == 0) {
            return ZaveChip(
              label: 'All templates',
              selected: selected == null,
              onTap: () => onSelect(null),
            );
          }
          final String slug = categories[index - 1];
          final CategoryLabel label = categoryLabel(labels, slug);
          return ZaveChip(
            label: '${label.emoji} ${label.name}',
            selected: selected == slug,
            onTap: () => onSelect(slug),
          );
        },
      ),
    );
  }
}

/// One gallery tile.
///
/// The web puts BOTH of a Reimagine card's actions behind `group-hover`, so on
/// a phone the page is completely non-functional — the card itself has no
/// click handler at all. Here the whole card is the control and it opens a
/// sheet, which is also what the web's festive gallery does and the only form
/// that works under a finger.
class TemplateTile extends StatelessWidget {
  const TemplateTile({
    required this.title,
    required this.onTap,
    this.description,
    this.imageUrl,
    this.imageLabel,
    this.aspectRatio = 1,
    this.badge,
    super.key,
  });

  final String title;
  final String? description;
  final String? imageUrl;

  /// Printed inside the image box when there is no preview — the web shows the
  /// design's pixel size there.
  final String? imageLabel;

  /// 4/3 for Studio designs, 1/1 for festive posters. The two galleries differ
  /// in exactly this, and it is worth keeping rather than flattening.
  final double aspectRatio;

  /// The category pill over the tile.
  final String? badge;

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ZaveCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Stack(
            children: <Widget>[
              ClipRRect(
                borderRadius: ZaveRadius.cardSmBr,
                child: AiToolImage(
                  source: imageUrl,
                  aspectRatio: aspectRatio,
                  label: imageLabel,
                ),
              ),
              if (badge != null)
                Positioned(
                  top: ZaveSpace.md,
                  left: ZaveSpace.md,
                  child: ZavePill(label: badge!, color: ZaveColors.ink85),
                ),
            ],
          ),
          SizedBox(height: ZaveSpace.lg),
          Text(
            title,
            style: ZaveType.h3,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (description != null && description!.isNotEmpty) ...<Widget>[
            SizedBox(height: ZaveSpace.sm),
            Text(
              description!,
              style: ZaveType.caption,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}

/// The gallery's loading state.
///
/// Rest-fill blocks at the tile's own proportions, so the page does not jump
/// when the real tiles land. No shimmer: Zave's motion rule is "short and
/// physical; nothing bounces", and a looping sweep across half the screen is
/// the opposite of that.
class GallerySkeleton extends StatelessWidget {
  const GallerySkeleton({this.count = 3, this.aspectRatio = 1, super.key});

  final int count;
  final double aspectRatio;

  @override
  Widget build(BuildContext context) => Column(
    children: <Widget>[
      for (int i = 0; i < count; i++) ...<Widget>[
        ZaveCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AspectRatio(
                aspectRatio: aspectRatio,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: ZaveGlass.hover,
                    borderRadius: ZaveRadius.cardSmBr,
                  ),
                ),
              ),
              SizedBox(height: ZaveSpace.lg),
              const _Bar(widthFactor: 0.7),
              SizedBox(height: ZaveSpace.sm),
              const _Bar(widthFactor: 0.45),
            ],
          ),
        ),
        SizedBox(height: ZaveSpace.md),
      ],
    ],
  );
}

class _Bar extends StatelessWidget {
  const _Bar({required this.widthFactor});

  final double widthFactor;

  @override
  Widget build(BuildContext context) => FractionallySizedBox(
    alignment: Alignment.centerLeft,
    widthFactor: widthFactor,
    child: Container(
      height: ZaveSpace.md,
      decoration: BoxDecoration(
        color: ZaveGlass.rest,
        borderRadius: ZaveRadius.pillBr,
      ),
    ),
  );
}

/// A gallery that could not load.
///
/// Amber, not red — Zave has no red, and a failed fetch is "needs attention",
/// not a destructive state. The web paints this one in `red-400`.
class GalleryError extends StatelessWidget {
  const GalleryError({required this.onRetry, this.message, super.key});

  final VoidCallback onRetry;
  final String? message;

  @override
  Widget build(BuildContext context) => ZaveCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            const ZaveDot(ZaveColors.amber),
            SizedBox(width: ZaveSpace.sm),
            Text('COULD NOT LOAD', style: ZaveType.kicker),
          ],
        ),
        SizedBox(height: ZaveSpace.md),
        Text(message ?? 'The templates did not load.', style: ZaveType.h3),
        SizedBox(height: ZaveSpace.lg),
        ZaveButton(label: 'Try again', onPressed: onRetry),
      ],
    ),
  );
}

/// A gallery with nothing in it.
class GalleryEmpty extends StatelessWidget {
  const GalleryEmpty({
    required this.title,
    required this.message,
    this.action,
    super.key,
  });

  final String title;
  final String message;
  final Widget? action;

  @override
  Widget build(BuildContext context) => ZaveCard(
    size: ZaveCardSize.large,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            const ZaveDot(ZaveColors.ink35),
            SizedBox(width: ZaveSpace.sm),
            Text('NOTHING HERE YET', style: ZaveType.kicker),
          ],
        ),
        SizedBox(height: ZaveSpace.md),
        Text(title, style: ZaveType.h3),
        SizedBox(height: ZaveSpace.md),
        Text(message, style: ZaveType.bodyMuted),
        if (action != null) ...<Widget>[
          SizedBox(height: ZaveSpace.lg),
          action!,
        ],
      ],
    ),
  );
}

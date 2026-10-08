import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/ui/zave/zave_kit.dart';
import '../../application/festive_controller.dart';
import '../../domain/festive_template.dart';
import '../widgets/ai_tool_note.dart';
import '../widgets/ai_tool_sheet.dart';
import '../widgets/festive_customizer_sheet.dart';
import '../widgets/template_gallery.dart';

/// **Festive** — the web's `/festive`.
///
/// Occasion posters (Diwali, Christmas, Holi, Eid, Republic Day, New Year,
/// birthdays, anniversaries) composited from a Figma-derived base image plus
/// the user's own text. 800 XP a poster. Nav visibility is `admin` in v1; the
/// nav gates it, the screen does not.
///
/// Worth stating because the name misleads: this is **not** AI generation. The
/// server composites with sharp, deterministically, and never falls back to a
/// model — which is why festive has its own service and its own failure modes
/// on the backend, and why a failure here is worth retrying on a different
/// template rather than retrying the same one.
///
/// The web's gallery is the one page in this family that already works under a
/// finger (the whole card has an `onClick`), so the interaction carries over
/// unchanged: tap a tile, get the customizer.
class FestivePage extends ConsumerWidget {
  const FestivePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<FestiveGallery> gallery = ref.watch(
      festiveControllerProvider,
    );
    final String? selected = ref.watch(festiveCategoryProvider);

    return ZaveScaffold(
      largeTitle: 'Festive',
      subtitle: 'Occasion posters in a few taps',
      body: RefreshIndicator(
        color: ZaveColors.white,
        backgroundColor: ZaveColors.deep,
        onRefresh: () async {
          ref.invalidate(festiveControllerProvider);
          await ref.read(festiveControllerProvider.future);
        },
        child: gallery.when(
          loading: () => ZaveScrollView(
            children: <Widget>[
              const _Intro(),
              SizedBox(height: ZaveSpace.xl),
              const GallerySkeleton(),
            ],
          ),
          error: (Object e, StackTrace _) => ZaveScrollView(
            children: <Widget>[
              const _Intro(),
              SizedBox(height: ZaveSpace.xl),
              GalleryError(
                onRetry: () => ref.invalidate(festiveControllerProvider),
              ),
            ],
          ),
          data: (FestiveGallery data) =>
              _Body(gallery: data, selected: selected),
        ),
      ),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body({required this.gallery, required this.selected});

  final FestiveGallery gallery;
  final String? selected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<FestiveTemplate> visible = selected == null
        ? gallery.templates
        : gallery.templates
              .where((FestiveTemplate t) => t.category == selected)
              .toList(growable: false);

    return ZaveScrollView(
      children: <Widget>[
        const _Intro(),
        SizedBox(height: ZaveSpace.xl),
        CategoryBar(
          categories: gallery.categories,
          selected: selected,
          labels: festiveCategoryLabels,
          onSelect: (String? c) =>
              ref.read(festiveCategoryProvider.notifier).select(c),
        ),
        if (gallery.categories.isNotEmpty) SizedBox(height: ZaveSpace.xl),

        if (gallery.templates.isEmpty)
          const GalleryEmpty(
            title: 'No templates yet',
            // The web retries via a Figma sync at this point. There is no
            // mobile route for that sync, so the screen states the position
            // rather than looking like it is about to fix itself.
            message:
                'Festive templates are still being prepared. They are synced '
                'from the design file on the web, and they will appear here '
                'once they are published.',
          )
        else if (visible.isEmpty)
          const GalleryEmpty(
            title: 'Nothing for this occasion',
            message: 'Try another occasion, or go back to all templates.',
          )
        else
          for (final FestiveTemplate t in visible) ...<Widget>[
            TemplateTile(
              title: t.name,
              description: t.description,
              imageUrl: t.previewUrl,
              // 1:1 — the festive tile is square where Studio's is 4:3.
              aspectRatio: 1,
              badge: categoryLabel(festiveCategoryLabels, t.category).name,
              onTap: () => AiToolSheet.show<void>(
                context,
                FestiveCustomizerSheet(template: t),
              ),
            ),
            SizedBox(height: ZaveSpace.md),
          ],
      ],
    );
  }
}

/// The heading block — the web's emoji + h1 + "NEW" pill + subtitle + XP badge.
///
/// The title and its lead now live in the scaffold's large header, so what is
/// left here is the cost. The gradient "NEW" pill does not survive the port: in
/// Zave a fill names a status, and "new" is a marketing label rather than a
/// state of the user's work. The XP badge does survive, because a cost is
/// something the user needs before they tap, not after.
class _Intro extends StatelessWidget {
  const _Intro();

  @override
  Widget build(BuildContext context) => const XpCostRow(
    cost: '800 XP per poster',
    detail:
        'Charged only when a poster comes back, so a failed one costs you '
        'nothing.',
  );
}

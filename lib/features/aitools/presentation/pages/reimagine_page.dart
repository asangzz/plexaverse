import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/ui/zave/zave_kit.dart';
import '../../application/reimagine_controller.dart';
import '../../domain/studio_template.dart';
import '../widgets/ai_tool_image.dart';
import '../widgets/ai_tool_note.dart';
import '../widgets/ai_tool_sheet.dart';
import '../widgets/template_gallery.dart';

/// **Reimagine** — the web's `/reimagine`.
///
/// Browse the globally-published Studio templates and copy one into your own
/// designs. Nav visibility is `admin` in v1; the nav gates it, the screen does
/// not.
///
/// ## What this screen can and cannot do, and why
///
/// The web page offers two things per tile: **Use Template** (copy → open
/// Studio) and **Preview** (open `TemplateCustomizer`, fill the design's named
/// layers, export a PNG). Only the first has a mobile route.
/// `GET /studio/templates/[id]` and `POST /studio/customize` are not in
/// `api_paths.dart`, so the customizer is reported as a missing endpoint
/// rather than stubbed — a live-preview panel wired to nothing would be the
/// worst version of this screen.
///
/// The copy action works end to end, and stops one step short of the web's:
/// the web redirects to `/studio?project=<id>`, and this app has no Studio
/// canvas to redirect to. So the sheet confirms where the copy went instead of
/// pretending to navigate.
///
/// ## The mobile hole this fixes
///
/// On the web BOTH of a tile's buttons live inside a `group-hover` overlay and
/// the card itself has no click handler, so `/reimagine` is completely
/// non-functional on a touch device. Here the tile IS the control.
class ReimaginePage extends ConsumerWidget {
  const ReimaginePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<StudioTemplate>> gallery = ref.watch(
      reimagineControllerProvider,
    );
    final String? selected = ref.watch(reimagineCategoryProvider);

    return ZaveScaffold(
      title: 'Reimagine',
      body: RefreshIndicator(
        color: ZaveColors.white,
        backgroundColor: ZaveColors.deep,
        onRefresh: () async {
          ref.invalidate(reimagineControllerProvider);
          await ref.read(reimagineControllerProvider.future);
        },
        child: gallery.when(
          loading: () => ZaveScrollView(
            children: <Widget>[
              const _Intro(),
              SizedBox(height: ZaveSpace.xl),
              const GallerySkeleton(aspectRatio: 4 / 3),
            ],
          ),
          error: (Object e, StackTrace _) => ZaveScrollView(
            children: <Widget>[
              const _Intro(),
              SizedBox(height: ZaveSpace.xl),
              GalleryError(
                onRetry: () => ref.invalidate(reimagineControllerProvider),
              ),
            ],
          ),
          data: (List<StudioTemplate> templates) =>
              _Body(templates: templates, selected: selected),
        ),
      ),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body({required this.templates, required this.selected});

  final List<StudioTemplate> templates;
  final String? selected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<String> categories = studioCategoriesOf(templates);
    final List<StudioTemplate> visible = selected == null
        ? templates
        : templates
              .where((StudioTemplate t) => t.category == selected)
              .toList(growable: false);

    final TemplateCopyState copy = ref.watch(templateCopyControllerProvider);

    return ZaveScrollView(
      children: <Widget>[
        const _Intro(),
        SizedBox(height: ZaveSpace.xl),

        if (copy.copied != null) ...<Widget>[
          _CopiedBanner(
            name: copy.copied!.name,
            onDismiss: () =>
                ref.read(templateCopyControllerProvider.notifier).dismiss(),
          ),
          SizedBox(height: ZaveSpace.lg),
        ],
        if (copy.error != null) ...<Widget>[
          ZaveCard(
            child: AiToolNote(title: 'Copy failed', message: copy.error!),
          ),
          SizedBox(height: ZaveSpace.lg),
        ],

        CategoryBar(
          categories: categories,
          selected: selected,
          labels: studioCategoryLabels,
          onSelect: (String? c) =>
              ref.read(reimagineCategoryProvider.notifier).select(c),
        ),
        if (categories.isNotEmpty) SizedBox(height: ZaveSpace.xl),

        if (templates.isEmpty)
          const GalleryEmpty(
            title: 'Templates are on their way',
            message:
                'There are no published Studio templates yet. When there are, '
                'they show up here and you can copy any of them into your own '
                'designs.',
          )
        else if (visible.isEmpty)
          const GalleryEmpty(
            title: 'Nothing in this category',
            message: 'Try another category, or go back to all templates.',
          )
        else
          for (final StudioTemplate t in visible) ...<Widget>[
            TemplateTile(
              title: t.name,
              description: t.description,
              imageUrl: t.thumbnail,
              imageLabel: t.sizeLabel,
              // 4:3, the web's Studio-template tile. Festive uses 1:1; the two
              // galleries differ in exactly this and it is worth keeping.
              aspectRatio: 4 / 3,
              badge: t.category == null
                  ? null
                  : categoryLabel(studioCategoryLabels, t.category!).name,
              onTap: () =>
                  AiToolSheet.show<void>(context, _TemplateSheet(template: t)),
            ),
            SizedBox(height: ZaveSpace.md),
          ],
      ],
    );
  }
}

/// The page's own heading block — the web's emoji + h1 + "AI Spark" pill +
/// subtitle + two feature pills.
///
/// The gradient pill does not survive the port. In Zave a fill means a status,
/// and "AI Spark" is a name, not a state; the two feature pills (`Free to
/// copy`, `Full Studio editing`) are statements about the templates, so they
/// stay as static [ZavePill]s, which is what a non-tappable label is in this
/// system.
class _Intro extends StatelessWidget {
  const _Intro();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        'Browse template designs and make them your own.',
        style: ZaveType.lead,
      ),
      SizedBox(height: ZaveSpace.lg),
      Wrap(
        spacing: ZaveSpace.sm,
        runSpacing: ZaveSpace.sm,
        children: const <Widget>[
          ZavePill(
            label: 'Free to copy',
            color: ZaveColors.green,
            leading: ZaveDot(ZaveColors.green),
          ),
          ZavePill(label: 'Edit in Studio on the web', color: ZaveColors.ink62),
        ],
      ),
    ],
  );
}

/// What a tile opens: the design at size, its facts, and the one action this
/// screen has.
///
/// One white button, as Zave requires — and it is the right one. The web's
/// second CTA ("Preview") opens the template customizer, which has no mobile
/// route; saying so here is the honest form of that button.
class _TemplateSheet extends ConsumerWidget {
  const _TemplateSheet({required this.template});

  final StudioTemplate template;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TemplateCopyState copy = ref.watch(templateCopyControllerProvider);
    final bool copying = copy.isCopying(template.id);
    final bool done = copy.didCopy(template.id);

    return AiToolSheet(
      children: <Widget>[
        Text('STUDIO TEMPLATE', style: ZaveType.kicker),
        SizedBox(height: ZaveSpace.md),
        Text(template.name, style: ZaveType.h2),
        if (template.description != null &&
            template.description!.isNotEmpty) ...<Widget>[
          SizedBox(height: ZaveSpace.md),
          Text(template.description!, style: ZaveType.bodyMuted),
        ],
        SizedBox(height: ZaveSpace.xl),
        ClipRRect(
          borderRadius: ZaveRadius.cardSmBr,
          child: AiToolImage(
            source: template.thumbnail,
            aspectRatio: 4 / 3,
            fit: BoxFit.contain,
            label: template.sizeLabel,
          ),
        ),
        SizedBox(height: ZaveSpace.lg),
        Wrap(
          spacing: ZaveSpace.sm,
          runSpacing: ZaveSpace.sm,
          children: <Widget>[
            ZavePill(label: template.sizeLabel, color: ZaveColors.ink62),
            if (template.category != null)
              ZavePill(
                label: categoryLabel(
                  studioCategoryLabels,
                  template.category!,
                ).name,
                color: ZaveColors.ink62,
              ),
          ],
        ),
        SizedBox(height: ZaveSpace.xl),
        ZaveButton(
          label: done ? 'Copied to your designs' : 'Copy to my designs',
          kind: ZaveButtonKind.primary,
          expand: true,
          busy: copying,
          onPressed: done || copy.busy
              ? null
              : () => ref
                    .read(templateCopyControllerProvider.notifier)
                    .copy(template),
        ),
        SizedBox(height: ZaveSpace.lg),
        const AiToolNoteRow(
          title: 'Editing happens on the web',
          message:
              'The copy lands in your Studio designs. The canvas editor is '
              'web-only by design — Plexa Studio is a Fabric.js canvas, and '
              'a phone port of it was ruled out rather than half-built — so '
              'open Plexaverse on the web to move and restyle elements.',
        ),
      ],
    );
  }
}

/// Confirmation that a copy landed, shown on the gallery after the sheet
/// closes.
///
/// Green, because it names a completed state. The web redirects into Studio at
/// this point; there is no Studio here to redirect to, so the screen says
/// where the design went instead.
class _CopiedBanner extends StatelessWidget {
  const _CopiedBanner({required this.name, required this.onDismiss});

  final String name;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) => ZaveCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            const ZaveDot(ZaveColors.green),
            SizedBox(width: ZaveSpace.sm),
            Expanded(
              child: Text(
                'COPIED',
                style: ZaveType.kicker.copyWith(color: ZaveColors.green),
              ),
            ),
            ZaveIconButton(
              icon: const Icon(Icons.close),
              tooltip: 'Dismiss',
              onPressed: onDismiss,
            ),
          ],
        ),
        SizedBox(height: ZaveSpace.md),
        Text(name, style: ZaveType.h3),
        SizedBox(height: ZaveSpace.sm),
        Text(
          'It is in your Studio designs. Open Plexaverse on the web to edit '
          'it.',
          style: ZaveType.caption,
        ),
      ],
    ),
  );
}

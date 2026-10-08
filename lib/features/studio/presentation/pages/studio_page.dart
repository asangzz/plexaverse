import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/zave_routes.dart';
import '../../../../core/ui/zave/zave_kit.dart';
import '../../application/studio_controller.dart';
import '../../domain/studio_design.dart';
import '../widgets/canvas_presets.dart';
import '../widgets/design_tile.dart';
import '../widgets/studio_shared.dart';
import 'studio_design_page.dart';

/// **Plexa Studio** — the web's `/studio`.
///
/// ## What this screen is, and what it deliberately is not
///
/// The web Studio is two views in one 4,400-line component: a project picker
/// and a full vector editor with two 280px floating panels, six tools, a
/// right-click menu, fourteen keyboard shortcuts and 12px resize handles.
///
/// **Studio on a phone is VIEW plus LIGHT EDIT, and that is a product
/// decision, not a stage of one.** This screen is the picker; opening a design
/// gives you its preview, its text layers, its image layers and the AI
/// Designer. There is no freeform canvas, no Fabric.js and no webview. A
/// 280+280px panel layout cannot be squeezed into 375px, hover-only controls
/// have no touch equivalent, and a keyboard-driven editor has no keyboard —
/// so the honest phone surface is the one where every control is reachable by
/// a finger and does exactly what it says.
///
/// ## Routing
///
/// One path, two states, exactly as the web does it: `/studio` is the library,
/// `/studio?project=<id>` is one design. Keeping the query-param form means a
/// link works identically on both platforms.
class StudioPage extends ConsumerWidget {
  const StudioPage({this.designId, super.key});

  /// From `?project=` on the route. Null is the library.
  final String? designId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<StudioAccess> access = ref.watch(
      studioAccessControllerProvider,
    );

    return access.when(
      loading: () => ZaveScaffold(
        largeTitle: 'Studio',
        subtitle: 'Your creative engine',
        body: ZaveScrollView(
          children: <Widget>[
            StudioSkeleton(height: _Skeleton.header),
            SizedBox(height: ZaveSpace.xl),
            StudioSkeleton(height: _Skeleton.card),
          ],
        ),
      ),
      error: (Object error, StackTrace _) => ZaveScaffold(
        largeTitle: 'Studio',
        subtitle: 'Your creative engine',
        body: ZaveScrollView(
          children: <Widget>[
            StudioNotice.failure(
              title: "Studio didn't load.",
              body:
                  'We could not check whether Studio is unlocked on this '
                  'account.',
              onAction: () => ref.invalidate(studioAccessControllerProvider),
            ),
          ],
        ),
      ),
      data: (StudioAccess status) {
        if (!status.hasAccess) return _LockedStudio(access: status);
        if (designId != null) return StudioDesignPage(designId: designId!);
        return const StudioLibraryView();
      },
    );
  }
}

/// Skeleton block heights.
///
/// Zave names no skeleton sizes — these are the measured heights of the
/// content each block stands in for, kept here rather than inline so a screen
/// never carries a bare number.
abstract final class _Skeleton {
  static const double header = 92;
  static const double card = 180;
  static const double tile = 116;
}

/// The XP gate.
///
/// The web hard-codes "Unlock for 2,000 XP"; the price comes from the server
/// here, because it is an admin-tunable XP constant and a figure baked into a
/// build is a figure that goes stale without anyone noticing.
///
/// Blue is the XP path in Zave and the ONLY brand-coloured fill, so the unlock
/// is the one correct use of [ZaveButtonKind.brand] on this screen.
class _LockedStudio extends ConsumerWidget {
  const _LockedStudio({required this.access});

  final StudioAccess access;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool affordable = access.canAfford;

    return ZaveScaffold(
      largeTitle: 'Studio',
      subtitle: 'Your creative engine',
      body: ZaveScrollView(
        children: <Widget>[
          Text('LOCKED', style: ZaveType.kicker),
          SizedBox(height: ZaveSpace.lg),
          Text(
            'The design surface behind your posters. Open a saved design, '
            'rewrite its text, swap its images, or have the AI Designer build '
            'one for you.',
            style: ZaveType.lead,
          ),
          SizedBox(height: ZaveSpace.xl),
          ZaveCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    // Amber is "waiting" — waiting on XP, in this case.
                    ZaveDot(affordable ? ZaveColors.green : ZaveColors.amber),
                    SizedBox(width: ZaveSpace.sm),
                    Expanded(
                      child: Text(
                        affordable ? 'READY TO UNLOCK' : 'NOT ENOUGH XP',
                        style: ZaveType.kicker,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: ZaveSpace.md),
                Text('${access.requiredXp} XP', style: ZaveType.h3),
                SizedBox(height: ZaveSpace.sm),
                Text(
                  affordable
                      ? 'You have ${access.currentXp} XP. One-time unlock, '
                            'kept for good.'
                      : 'You have ${access.currentXp} XP — '
                            '${access.shortfall} short.',
                  style: ZaveType.bodyMuted,
                ),
                SizedBox(height: ZaveSpace.lg),
                ZaveButton.brand(
                  label: 'Unlock Studio',
                  expand: true,
                  onPressed: affordable
                      ? () => ref
                            .read(studioAccessControllerProvider.notifier)
                            .unlock()
                      : null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// The library — the web picker, restated as a list.
///
/// The web's grid puts edit and delete behind `opacity-0 group-hover`, which
/// on touch means they do not exist. Here they live behind a persistent
/// trailing control on every row.
class StudioLibraryView extends ConsumerStatefulWidget {
  const StudioLibraryView({super.key});

  @override
  ConsumerState<StudioLibraryView> createState() => _StudioLibraryViewState();
}

enum _LibraryTab { designs, templates }

class _StudioLibraryViewState extends ConsumerState<StudioLibraryView> {
  _LibraryTab _tab = _LibraryTab.designs;

  /// The row currently being opened or copied. Held here, not in a provider:
  /// it is per-view ephemeral UI state and dies with the screen.
  String? _busyId;

  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<StudioDesign>> designs = ref.watch(
      studioDesignsControllerProvider,
    );
    final AsyncValue<List<StudioDesign>> templates = ref.watch(
      studioTemplatesControllerProvider,
    );
    final AsyncValue<List<StudioDesign>> shown = _tab == _LibraryTab.designs
        ? designs
        : templates;

    return ZaveScaffold(
      largeTitle: 'Studio',
      subtitle: 'Your creative engine',
      actions: <Widget>[
        ZaveIconButton(
          icon: const Icon(Icons.add),
          tooltip: 'New design',
          onPressed: _openNewDesignSheet,
        ),
      ],
      body: RefreshIndicator(
        color: ZaveColors.white,
        backgroundColor: ZaveColors.deep,
        onRefresh: () async {
          ref.invalidate(studioDesignsControllerProvider);
          ref.invalidate(studioTemplatesControllerProvider);
          await ref.read(studioDesignsControllerProvider.future);
        },
        child: ZaveScrollView(
          children: <Widget>[
            const _TemplateGuideCard(),
            SizedBox(height: ZaveSpace.xxl),
            Row(
              children: <Widget>[
                ZaveChip(
                  label: 'Designs',
                  selected: _tab == _LibraryTab.designs,
                  badge: designs.value?.length.toString(),
                  onTap: () => setState(() => _tab = _LibraryTab.designs),
                ),
                SizedBox(width: ZaveSpace.sm),
                ZaveChip(
                  label: 'Templates',
                  selected: _tab == _LibraryTab.templates,
                  badge: templates.value?.length.toString(),
                  onTap: () => setState(() => _tab = _LibraryTab.templates),
                ),
              ],
            ),
            SizedBox(height: ZaveSpace.lg),
            ...shown.when(
              loading: () => <Widget>[
                for (int i = 0; i < 3; i++) ...<Widget>[
                  StudioSkeleton(height: _Skeleton.tile),
                  SizedBox(height: ZaveSpace.md),
                ],
              ],
              error: (Object error, StackTrace _) => <Widget>[
                StudioNotice.failure(
                  title: _tab == _LibraryTab.designs
                      ? "Your designs didn't load."
                      : "Templates didn't load.",
                  onAction: _reloadCurrentTab,
                ),
              ],
              data: (List<StudioDesign> rows) => rows.isEmpty
                  ? <Widget>[_emptyState()]
                  : <Widget>[
                      for (final StudioDesign row in rows) ...<Widget>[
                        DesignTile(
                          design: row,
                          busy: _busyId == row.id,
                          onOpen: () => _tab == _LibraryTab.designs
                              ? _open(row.id)
                              : _useTemplate(row),
                          onMore: _tab == _LibraryTab.designs
                              ? () => _openActionsSheet(row)
                              : null,
                        ),
                        SizedBox(height: ZaveSpace.md),
                      ],
                    ],
            ),
          ],
        ),
      ),
    );
  }

  /// Re-reads whichever list is on screen. Written as a method rather than a
  /// ternary inside `ref.invalidate` because the two generated providers have
  /// no common type that the call would accept.
  void _reloadCurrentTab() {
    if (_tab == _LibraryTab.designs) {
      ref.invalidate(studioDesignsControllerProvider);
    } else {
      ref.invalidate(studioTemplatesControllerProvider);
    }
  }

  Widget _emptyState() => _tab == _LibraryTab.designs
      ? StudioNotice(
          kicker: 'Nothing saved yet',
          title: 'Your gallery is quiet.',
          body:
              'Start from a template, or make an empty design and let the '
              'AI Designer fill it.',
          actionLabel: 'Browse templates',
          onAction: () => setState(() => _tab = _LibraryTab.templates),
        )
      : const StudioNotice(
          kicker: 'No templates',
          title: 'Nothing to start from yet.',
          body: 'Templates are designs marked shareable in Studio on the web.',
        );

  /// Opens a design. The web pushes `/studio?project=<id>`; so does this, so a
  /// link means the same thing on both platforms.
  void _open(String id) => context.push('${ZaveRoutes.studio}?project=$id');

  Future<void> _useTemplate(StudioDesign template) async {
    setState(() => _busyId = template.id);
    try {
      final StudioDesign copy = await ref
          .read(studioTemplatesControllerProvider.notifier)
          .use(template.id, name: template.name);
      if (!mounted) return;
      setState(() => _tab = _LibraryTab.designs);
      _open(copy.id);
    } on Object {
      if (!mounted) return;
      _toast('Could not copy that template.');
    } finally {
      if (mounted) setState(() => _busyId = null);
    }
  }

  void _toast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: ZaveType.body),
        backgroundColor: ZaveColors.deep,
      ),
    );
  }

  Future<void> _openActionsSheet(StudioDesign design) async {
    final _DesignAction? action = await showModalBottomSheet<_DesignAction>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext sheetContext) => StudioSheet(
        children: <Widget>[
          Text(design.name.toUpperCase(), style: ZaveType.kicker),
          SizedBox(height: ZaveSpace.lg),
          ZaveButton(
            label: 'Open',
            expand: true,
            kind: ZaveButtonKind.primarySmall,
            onPressed: () => Navigator.of(sheetContext).pop(_DesignAction.open),
          ),
          SizedBox(height: ZaveSpace.md),
          ZaveButton(
            label: 'Rename',
            expand: true,
            onPressed: () =>
                Navigator.of(sheetContext).pop(_DesignAction.rename),
          ),
          SizedBox(height: ZaveSpace.md),
          ZaveButton(
            label: 'Destroy project',
            expand: true,
            onPressed: () =>
                Navigator.of(sheetContext).pop(_DesignAction.delete),
          ),
        ],
      ),
    );

    if (!mounted || action == null) return;
    switch (action) {
      case _DesignAction.open:
        _open(design.id);
      case _DesignAction.rename:
        await _openRenameSheet(design);
      case _DesignAction.delete:
        await _confirmDelete(design);
    }
  }

  Future<void> _openRenameSheet(StudioDesign design) async {
    final TextEditingController controller = TextEditingController(
      text: design.name,
    );
    final String? name = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext sheetContext) => StudioSheet(
        padBottomInset: true,
        children: <Widget>[
          Text('PROJECT IDENTIFIER', style: ZaveType.kicker),
          SizedBox(height: ZaveSpace.lg),
          ZaveField(
            controller: controller,
            hint: 'Untitled deployment',
            autofocus: true,
            textInputAction: TextInputAction.done,
            onSubmitted: (String value) =>
                Navigator.of(sheetContext).pop(value.trim()),
          ),
          SizedBox(height: ZaveSpace.lg),
          ZaveButton.primary(
            label: 'Save',
            expand: true,
            onPressed: () =>
                Navigator.of(sheetContext).pop(controller.text.trim()),
          ),
        ],
      ),
    );
    controller.dispose();

    if (!mounted || name == null || name.isEmpty || name == design.name) {
      return;
    }
    await ref
        .read(studioDesignsControllerProvider.notifier)
        .rename(design.id, name);
  }

  /// The web's copy, kept: this product's register is deliberately technical
  /// and flattening it into "Delete design?" would make the phone read like a
  /// different app.
  Future<void> _confirmDelete(StudioDesign design) async {
    final bool? confirmed = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext sheetContext) => StudioSheet(
        children: <Widget>[
          Row(
            children: <Widget>[
              // Amber, not red — Zave has no red, and the confirmation itself
              // is what carries the weight here.
              const ZaveDot(ZaveColors.amber),
              SizedBox(width: ZaveSpace.sm),
              Expanded(
                child: Text('THIS CANNOT BE UNDONE', style: ZaveType.kicker),
              ),
            ],
          ),
          SizedBox(height: ZaveSpace.md),
          Text('Destroy project?', style: ZaveType.h3),
          SizedBox(height: ZaveSpace.md),
          Text(
            '${design.name} will be permanently purged from the Plexaverse.',
            style: ZaveType.bodyMuted,
          ),
          SizedBox(height: ZaveSpace.xl),
          ZaveButton.primary(
            label: 'Confirm',
            expand: true,
            onPressed: () => Navigator.of(sheetContext).pop(true),
          ),
          SizedBox(height: ZaveSpace.md),
          ZaveButton(
            label: 'Abort',
            expand: true,
            onPressed: () => Navigator.of(sheetContext).pop(false),
          ),
        ],
      ),
    );

    if (!mounted || confirmed != true) return;
    await ref.read(studioDesignsControllerProvider.notifier).delete(design.id);
  }

  Future<void> _openNewDesignSheet() async {
    final CanvasPreset? preset = await showModalBottomSheet<CanvasPreset>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext sheetContext) => StudioSheet(
        children: <Widget>[
          Text('FRAME PRESETS', style: ZaveType.kicker),
          SizedBox(height: ZaveSpace.md),
          Text('New design', style: ZaveType.h3),
          SizedBox(height: ZaveSpace.md),
          Text(
            'Pick a page size. The AI Designer fills it — there is no blank '
            'canvas to draw on here.',
            style: ZaveType.bodyMuted,
          ),
          SizedBox(height: ZaveSpace.xl),
          for (final CanvasPreset option in CanvasPreset.all) ...<Widget>[
            ZaveCard(
              size: ZaveCardSize.small,
              padding: ZaveSpace.rowPad,
              onTap: () => Navigator.of(sheetContext).pop(option),
              child: Row(
                children: <Widget>[
                  Expanded(child: Text(option.name, style: ZaveType.label)),
                  Text(option.dimensions, style: ZaveType.caption),
                ],
              ),
            ),
            SizedBox(height: ZaveSpace.sm),
          ],
        ],
      ),
    );

    if (!mounted || preset == null) return;
    try {
      final StudioDesign created = await ref
          .read(studioDesignsControllerProvider.notifier)
          .create(name: 'Untitled deployment', canvas: preset.canvas);
      if (!mounted) return;
      _open(created.id);
    } on Object {
      if (!mounted) return;
      _toast('Could not create that design.');
    }
  }
}

enum _DesignAction { open, rename, delete }

/// The web's "Customizable Templates Guide" — the four naming rules that make
/// a design fillable by the auto-post pipeline.
///
/// It matters more on a phone than on the web, because a design whose layers
/// are NOT named `title` / `subtitle` / `image` has nothing this screen can
/// edit: light edit works through named layers.
class _TemplateGuideCard extends StatelessWidget {
  const _TemplateGuideCard();

  static const List<String> _rules = <String>[
    'Create a frame and name it poster.',
    'Name text layers title and subtitle so they can be rewritten.',
    'Name image layers image so they can be swapped.',
    'Toggle "Save as Template" when you save it.',
  ];

  @override
  Widget build(BuildContext context) => ZaveCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('CUSTOMIZABLE TEMPLATES GUIDE', style: ZaveType.kicker),
        SizedBox(height: ZaveSpace.md),
        for (final String rule in _rules) ...<Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                // Nudges the dot onto the first line's optical centre.
                padding: EdgeInsets.only(top: ZaveSpace.sm),
                child: const ZaveDot(ZaveColors.peri),
              ),
              SizedBox(width: ZaveSpace.md),
              Expanded(child: Text(rule, style: ZaveType.bodyMuted)),
            ],
          ),
          SizedBox(height: ZaveSpace.sm),
        ],
      ],
    ),
  );
}

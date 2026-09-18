import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/security/clipboard_policy.dart';
import '../../../../core/ui/zave/zave_kit.dart';
import '../../application/studio_editor_controller.dart';
import '../../application/studio_editor_state.dart';
import '../../domain/studio_design.dart';
import '../widgets/ai_designer_sheet.dart';
import '../widgets/design_canvas.dart';
import '../widgets/studio_shared.dart';

/// **One design, open for light editing** — the web's `/studio?project=<id>`.
///
/// ## The scope, stated where it is easiest to violate
///
/// The web's editor view is a vector canvas: six tools, drag-to-move,
/// twelve-pixel resize handles, a layer tree with drag-to-nest, a right-click
/// menu and fourteen keyboard shortcuts. **None of that is here, on purpose.**
/// A phone has no hover, no right-click, no keyboard and no room for the two
/// 280px panels the editor's layout is built around.
///
/// What a phone CAN do well is the part users actually do most: open a poster,
/// fix its words, change its picture, and ask the AI Designer for a different
/// take. That is this screen, and each of those four things is a real control
/// that does exactly what it says.
///
/// ## Light edit works through NAMED layers
///
/// The text and image sections list the design's text and image nodes by their
/// layer name. A template that follows the web's own naming guide (`title`,
/// `subtitle`, `image`) is therefore editable here without any further work —
/// which is the same contract the auto-post pipeline fills templates through.
///
/// ## Saving is explicit
///
/// The web autosaves every five minutes. This does not: a background PATCH
/// that replaces a design somebody is also editing on a laptop is data loss,
/// not convenience. Edits live in memory until **Save**, and the header says
/// so while they are unsaved.
class StudioDesignPage extends ConsumerStatefulWidget {
  const StudioDesignPage({required this.designId, super.key});

  final String designId;

  @override
  ConsumerState<StudioDesignPage> createState() => _StudioDesignPageState();
}

class _StudioDesignPageState extends ConsumerState<StudioDesignPage> {
  /// Which layer the preview outlines. Purely a viewing aid, so it is local
  /// state and dies with the screen.
  String? _highlightId;

  @override
  Widget build(BuildContext context) {
    final AsyncValue<StudioEditorState> editor = ref.watch(
      studioEditorProvider(widget.designId),
    );

    return ZaveScaffold(
      title: editor.value?.design.name ?? 'Design',
      leading: ZaveIconButton(
        icon: const Icon(Icons.arrow_back),
        tooltip: 'Back to Studio',
        onPressed: () => context.pop(),
      ),
      actions: <Widget>[
        if (editor.value != null)
          ZaveIconButton(
            icon: const Icon(Icons.auto_awesome_outlined),
            tooltip: 'AI Designer',
            onPressed: _openDesigner,
          ),
        if (editor.value != null)
          ZaveIconButton(
            icon: const Icon(Icons.ios_share_outlined),
            tooltip: 'Export',
            onPressed: () => _openExport(editor.value!),
          ),
      ],
      body: editor.when(
        loading: () => ZaveScrollView(
          children: <Widget>[
            StudioSkeleton(height: _Skeleton.canvas),
            SizedBox(height: ZaveSpace.xl),
            StudioSkeleton(height: _Skeleton.section),
            SizedBox(height: ZaveSpace.md),
            StudioSkeleton(height: _Skeleton.section),
          ],
        ),
        error: (Object error, StackTrace _) => ZaveScrollView(
          children: <Widget>[
            StudioNotice.failure(
              title: "That design didn't open.",
              body:
                  'It may have been deleted, or the connection dropped on '
                  'the way.',
              onAction: () =>
                  ref.invalidate(studioEditorProvider(widget.designId)),
            ),
          ],
        ),
        data: _body,
      ),
    );
  }

  Widget _body(StudioEditorState editor) {
    final StudioDesignData data = editor.data;
    final List<StudioElement> texts = data.textElements;
    final List<StudioElement> images = data.imageElements;

    return ZaveScrollView(
      children: <Widget>[
        DesignCanvas(data: data, highlightId: _highlightId),
        SizedBox(height: ZaveSpace.lg),
        _SaveBar(editor: editor, designId: widget.designId),
        SizedBox(height: ZaveSpace.xxl),

        Text('TEXT', style: ZaveType.kicker),
        SizedBox(height: ZaveSpace.lg),
        if (texts.isEmpty)
          const StudioNotice(
            kicker: 'No text layers',
            title: 'Nothing to rewrite here.',
            body:
                'This design has no text nodes. On the web, name a text '
                'layer title or subtitle and it will appear here.',
          )
        else
          for (final StudioElement element in texts) ...<Widget>[
            _TextLayerCard(
              element: element,
              focused: _highlightId == element.id,
              onFocus: () => setState(() => _highlightId = element.id),
              onChanged: (String value) => ref
                  .read(studioEditorProvider(widget.designId).notifier)
                  .editText(element.id, value),
            ),
            SizedBox(height: ZaveSpace.md),
          ],

        SizedBox(height: ZaveSpace.xxl),
        Text('IMAGES', style: ZaveType.kicker),
        SizedBox(height: ZaveSpace.lg),
        if (images.isEmpty)
          const StudioNotice(
            kicker: 'No image layers',
            title: 'Nothing to swap here.',
            body: 'This design has no image nodes.',
          )
        else
          for (final StudioElement element in images) ...<Widget>[
            _ImageLayerCard(
              element: element,
              onFocus: () => setState(() => _highlightId = element.id),
              onSwap: () => _openImageSheet(element),
            ),
            SizedBox(height: ZaveSpace.md),
          ],
      ],
    );
  }

  void _openDesigner() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext _) => AiDesignerSheet(designId: widget.designId),
    );
  }

  /// The export sheet.
  ///
  /// "Copy the words" is the one export this build can actually perform, and
  /// it is the one that matters most here — the text of a poster is what goes
  /// into a post's body. Saving a PNG to the camera roll and a share sheet
  /// both need a platform plugin the app does not ship; the sheet says so
  /// rather than offering a button that does nothing.
  void _openExport(StudioEditorState editor) {
    final String words = editor.data.textElements
        .map((StudioElement e) => e.textValue.trim())
        .where((String t) => t.isNotEmpty)
        .join('\n\n');

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext sheetContext) => StudioSheet(
        children: <Widget>[
          Text('EXPORT', style: ZaveType.kicker),
          SizedBox(height: ZaveSpace.md),
          Text(editor.design.name, style: ZaveType.h3),
          SizedBox(height: ZaveSpace.xl),
          ZaveButton.primary(
            label: words.isEmpty ? 'No text to copy' : 'Copy the words',
            expand: true,
            onPressed: words.isEmpty
                ? null
                : () async {
                    await ClipboardPolicy.copyNonSensitive(words);
                    if (!sheetContext.mounted) return;
                    Navigator.of(sheetContext).pop();
                    _notify('Copied.');
                  },
          ),
          SizedBox(height: ZaveSpace.lg),
          const StudioUnavailable(
            title: 'Saving the image',
            reason:
                'Writing a PNG to the camera roll, and the system share '
                'sheet, both need a platform plugin this build does not ship '
                '(no image_picker / share_plus in pubspec.yaml).',
            detail:
                'Until then: open the design in Studio on the web to '
                'export it.',
          ),
        ],
      ),
    );
  }

  /// Swapping an image.
  ///
  /// Two routes in, and the reason there are two: the app ships no photo
  /// picker, so "choose from my phone" is not available. A URL always works,
  /// and `POST /ai/image` generates a replacement inline as a data URI — which
  /// on a phone is the better default anyway, because the user has a prompt in
  /// their head and not a file path.
  Future<void> _openImageSheet(StudioElement element) async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext _) =>
          _ImageSwapSheet(designId: widget.designId, element: element),
    );
  }

  void _notify(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message, style: ZaveType.body),
          backgroundColor: ZaveColors.deep,
        ),
      );
  }
}

/// Skeleton block heights — the measured heights of what they stand in for.
abstract final class _Skeleton {
  static const double canvas = 300;
  static const double section = 120;
}

/// The save state, and the only control that writes.
///
/// Reads as a status row until there is something to save, at which point it
/// grows the button. That ordering is deliberate: a permanently-present Save
/// button trains people to ignore it, and then the one time it matters they do.
class _SaveBar extends ConsumerWidget {
  const _SaveBar({required this.editor, required this.designId});

  final StudioEditorState editor;
  final String designId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool failed = editor.saveError != null;

    return ZaveCard(
      size: ZaveCardSize.small,
      padding: ZaveSpace.rowPad,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              ZaveDot(
                failed
                    ? ZaveColors.amber
                    : (editor.dirty ? ZaveColors.peri : ZaveColors.green),
              ),
              SizedBox(width: ZaveSpace.sm),
              Expanded(
                child: Text(
                  failed
                      ? 'NOT SAVED'
                      : (editor.dirty ? 'UNSAVED CHANGES' : 'SAVED'),
                  style: ZaveType.kicker,
                ),
              ),
              Text(
                '${editor.data.canvas.width.round()} × '
                '${editor.data.canvas.height.round()}',
                style: ZaveType.caption,
              ),
            ],
          ),
          if (failed) ...<Widget>[
            SizedBox(height: ZaveSpace.sm),
            Text(
              // Amber, not red: Zave has no red, and a failed save is
              // recoverable — the edits are still in memory.
              'The last save did not go through. Your edits are still here.',
              style: ZaveType.caption.copyWith(color: ZaveColors.amber),
            ),
          ],
          if (editor.dirty || failed) ...<Widget>[
            SizedBox(height: ZaveSpace.lg),
            ZaveButton.primary(
              label: 'Save',
              expand: true,
              busy: editor.saving,
              onPressed: editor.saving
                  ? null
                  : () => ref
                        .read(studioEditorProvider(designId).notifier)
                        .save(),
            ),
          ],
        ],
      ),
    );
  }
}

/// One text layer, editable in place.
class _TextLayerCard extends StatefulWidget {
  const _TextLayerCard({
    required this.element,
    required this.focused,
    required this.onFocus,
    required this.onChanged,
  });

  final StudioElement element;
  final bool focused;
  final VoidCallback onFocus;
  final ValueChanged<String> onChanged;

  @override
  State<_TextLayerCard> createState() => _TextLayerCardState();
}

class _TextLayerCardState extends State<_TextLayerCard> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.element.textValue,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Seeded once at construction and never re-seeded from the model. The
    // controller is the source of truth while the field has focus; rewriting
    // it on every rebuild would fight the user's cursor on each keystroke.
    return ZaveCard(
      isNow: widget.focused,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  widget.element.displayName.toUpperCase(),
                  style: ZaveType.kicker,
                ),
              ),
              if (widget.element.fontSize != null)
                Text(
                  '${widget.element.fontSize!.round()}pt',
                  style: ZaveType.caption,
                ),
            ],
          ),
          SizedBox(height: ZaveSpace.md),
          ZaveField(
            controller: _controller,
            hint: 'Empty',
            maxLines: null,
            minLines: 1,
            keyboardType: TextInputType.multiline,
            onChanged: (String value) {
              widget.onFocus();
              widget.onChanged(value);
            },
          ),
        ],
      ),
    );
  }
}

/// One image layer, with its current picture and the swap control.
class _ImageLayerCard extends StatelessWidget {
  const _ImageLayerCard({
    required this.element,
    required this.onFocus,
    required this.onSwap,
  });

  final StudioElement element;
  final VoidCallback onFocus;
  final VoidCallback onSwap;

  @override
  Widget build(BuildContext context) => ZaveCard(
    onTap: onFocus,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(element.displayName.toUpperCase(), style: ZaveType.kicker),
        SizedBox(height: ZaveSpace.md),
        // Shows the layer in isolation, at its own shape, using the same
        // renderer the canvas uses — so what you swap is what you saw.
        DesignCanvas(
          data: StudioDesignData(
            canvas: StudioCanvas(
              width: element.width > 0 ? element.width : 1,
              height: element.height > 0 ? element.height : 1,
              background: 'transparent',
            ),
            elements: <StudioElement>[element.copyWith(x: 0.0, y: 0.0)],
          ),
        ),
        SizedBox(height: ZaveSpace.lg),
        ZaveButton(
          label: element.imageUrl == null ? 'Add an image' : 'Swap image',
          expand: true,
          onPressed: onSwap,
        ),
      ],
    ),
  );
}

/// The swap sheet: a URL, or a generated image.
class _ImageSwapSheet extends ConsumerStatefulWidget {
  const _ImageSwapSheet({required this.designId, required this.element});

  final String designId;
  final StudioElement element;

  @override
  ConsumerState<_ImageSwapSheet> createState() => _ImageSwapSheetState();
}

class _ImageSwapSheetState extends ConsumerState<_ImageSwapSheet> {
  final TextEditingController _url = TextEditingController();
  final TextEditingController _prompt = TextEditingController();
  bool _generating = false;
  String? _error;

  @override
  void dispose() {
    _url.dispose();
    _prompt.dispose();
    super.dispose();
  }

  /// The closest ratio `/ai/image` offers to the layer's own shape. The route
  /// takes a fixed set, so an arbitrary layer has to be rounded to one — and
  /// rounding to the nearest is visibly better than always asking for a square
  /// and letting `BoxFit.cover` crop the difference away.
  String get _aspectRatio {
    final double w = widget.element.width;
    final double h = widget.element.height;
    if (w <= 0 || h <= 0) return '1:1';
    final double ratio = w / h;
    const Map<String, double> options = <String, double>{
      '16:9': 16 / 9,
      '4:3': 4 / 3,
      '1:1': 1,
      '3:4': 3 / 4,
      '9:16': 9 / 16,
    };
    String best = '1:1';
    double bestDelta = double.infinity;
    options.forEach((String name, double value) {
      final double delta = (value - ratio).abs();
      if (delta < bestDelta) {
        bestDelta = delta;
        best = name;
      }
    });
    return best;
  }

  @override
  Widget build(BuildContext context) {
    return StudioSheet(
      padBottomInset: true,
      children: <Widget>[
        Text('SWAP IMAGE', style: ZaveType.kicker),
        SizedBox(height: ZaveSpace.md),
        Text(widget.element.displayName, style: ZaveType.h3),
        SizedBox(height: ZaveSpace.xl),

        ZaveField(
          controller: _prompt,
          label: 'Describe a new image',
          hint: 'A quiet desk at first light, shot from above',
          maxLines: 3,
          minLines: 2,
          keyboardType: TextInputType.multiline,
        ),
        SizedBox(height: ZaveSpace.lg),
        ZaveButton.primary(
          label: 'Generate',
          expand: true,
          busy: _generating,
          onPressed: _generating ? null : _generate,
        ),

        SizedBox(height: ZaveSpace.xxl),
        ZaveField(
          controller: _url,
          label: 'Or paste an image URL',
          hint: 'https://…',
          keyboardType: TextInputType.url,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _useUrl(),
        ),
        SizedBox(height: ZaveSpace.lg),
        ZaveButton(label: 'Use this URL', expand: true, onPressed: _useUrl),

        if (_error != null) ...<Widget>[
          SizedBox(height: ZaveSpace.lg),
          Text(
            // Amber: Zave has no red.
            _error!,
            style: ZaveType.caption.copyWith(color: ZaveColors.amber),
          ),
        ],

        SizedBox(height: ZaveSpace.xl),
        const StudioUnavailable(
          title: 'Choosing a photo from this phone',
          reason:
              'The app ships no photo-library plugin (no image_picker in '
              'pubspec.yaml), so there is nothing to open a picker with.',
          detail:
              'The upload endpoint it would need, POST /upload/image, '
              'already exists and accepts base64 — only the picker is '
              'missing.',
        ),
      ],
    );
  }

  void _useUrl() {
    final String url = _url.text.trim();
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      setState(() => _error = 'That does not look like an image URL.');
      return;
    }
    ref
        .read(studioEditorProvider(widget.designId).notifier)
        .swapImage(widget.element.id, url);
    Navigator.of(context).pop();
  }

  Future<void> _generate() async {
    final String prompt = _prompt.text.trim();
    if (prompt.isEmpty) {
      setState(() => _error = 'Say what the image should be.');
      return;
    }
    setState(() {
      _generating = true;
      _error = null;
    });
    try {
      final String uri = await ref
          .read(studioEditorProvider(widget.designId).notifier)
          .generateImageFor(prompt: prompt, aspectRatio: _aspectRatio);
      if (!mounted) return;
      ref
          .read(studioEditorProvider(widget.designId).notifier)
          .swapImage(widget.element.id, uri);
      Navigator.of(context).pop();
    } on Object {
      if (!mounted) return;
      setState(() {
        _generating = false;
        _error = 'That image did not come back. It may be an XP balance.';
      });
    }
  }
}

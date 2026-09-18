import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/ui/zave/zave_kit.dart';
import '../../application/template_controller.dart';
import '../../application/template_creator_state.dart';
import '../widgets/canvas_presets.dart';
import '../widgets/css_value.dart';
import '../widgets/studio_shared.dart';

/// **Template Creator** — the web's `/template-creator`.
///
/// A four-step wizard: a reference image, a page size and a visual register, a
/// confirmation, and the generated template.
///
/// ## Two things here do not work, and the screen says which
///
/// 1. **The generate call has no mobile route.** The web posts to
///    `/api/ai/template-creator`; there is no `app/api/mobile/v1/ai/
///    template-creator/route.ts`. Rather than invent a path and let the 404 be
///    swallowed, the wizard is built in full and the final step states the
///    missing endpoint by name.
/// 2. **There is no photo picker.** The web's dropzone base64s a dropped file.
///    This build ships no `image_picker`, so the reference and the logo are
///    given as URLs.
///
/// Everything else is real: every choice is held in the shape the endpoint
/// will want, so wiring it up later is a repository and one call.
class TemplateCreatorPage extends ConsumerWidget {
  const TemplateCreatorPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TemplateCreatorState state = ref.watch(
      templateCreatorControllerProvider,
    );

    return ZaveScaffold(
      title: 'Template creator',
      leading: ZaveIconButton(
        icon: const Icon(Icons.arrow_back),
        tooltip: 'Back',
        onPressed: () => context.pop(),
      ),
      body: ZaveScrollView(
        children: <Widget>[
          Text('AI SPARK', style: ZaveType.kicker),
          SizedBox(height: ZaveSpace.md),
          Text(
            'Point it at a design you like and it builds you a template you '
            'can fill.',
            style: ZaveType.lead,
          ),
          SizedBox(height: ZaveSpace.xl),
          _StepRail(step: state.step),
          SizedBox(height: ZaveSpace.xl),

          if (state.error != null) ...<Widget>[
            Row(
              children: <Widget>[
                // Amber, never red — Zave has no red.
                const ZaveDot(ZaveColors.amber),
                SizedBox(width: ZaveSpace.sm),
                Expanded(
                  child: Text(
                    state.error!,
                    style: ZaveType.caption.copyWith(color: ZaveColors.amber),
                  ),
                ),
              ],
            ),
            SizedBox(height: ZaveSpace.lg),
          ],

          switch (state.step) {
            TemplateStep.upload => _UploadStep(state: state),
            TemplateStep.configure => _ConfigureStep(state: state),
            TemplateStep.generate ||
            TemplateStep.result => _GenerateStep(state: state),
          },
        ],
      ),
    );
  }
}

/// Four segments; the ones you have reached are white.
class _StepRail extends StatelessWidget {
  const _StepRail({required this.step});

  final TemplateStep step;

  @override
  Widget build(BuildContext context) {
    final int reached = TemplateStep.values.indexOf(step);
    return Row(
      children: <Widget>[
        for (int i = 0; i < TemplateStep.values.length; i++) ...<Widget>[
          Expanded(
            child: Container(
              height: ZaveSpace.xs,
              decoration: BoxDecoration(
                color: i <= reached ? ZaveColors.white : ZaveColors.rule,
                borderRadius: ZaveRadius.pillBr,
              ),
            ),
          ),
          if (i < TemplateStep.values.length - 1) SizedBox(width: ZaveSpace.sm),
        ],
      ],
    );
  }
}

/// Step 1 — the reference.
class _UploadStep extends ConsumerStatefulWidget {
  const _UploadStep({required this.state});

  final TemplateCreatorState state;

  @override
  ConsumerState<_UploadStep> createState() => _UploadStepState();
}

class _UploadStepState extends ConsumerState<_UploadStep> {
  late final TextEditingController _url = TextEditingController(
    text: widget.state.referenceImageUrl ?? '',
  );

  @override
  void dispose() {
    _url.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TemplateCreatorController controller = ref.read(
      templateCreatorControllerProvider.notifier,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Reference image', style: ZaveType.h3),
        SizedBox(height: ZaveSpace.md),
        Text(
          'A screenshot or design to reimagine. Its layout, colours and '
          'styling are what the model reads.',
          style: ZaveType.bodyMuted,
        ),
        SizedBox(height: ZaveSpace.xl),
        if (widget.state.hasReference) ...<Widget>[
          _ImagePreview(url: widget.state.referenceImageUrl!),
          SizedBox(height: ZaveSpace.lg),
        ],
        ZaveField(
          controller: _url,
          label: 'Image URL',
          hint: 'https://…',
          keyboardType: TextInputType.url,
          textInputAction: TextInputAction.done,
          onSubmitted: (String value) => controller.setReference(value),
        ),
        SizedBox(height: ZaveSpace.md),
        ZaveButton(
          label: 'Use this image',
          expand: true,
          onPressed: () => controller.setReference(_url.text),
        ),
        SizedBox(height: ZaveSpace.lg),
        const StudioUnavailable(
          title: 'Picking a file from this phone',
          reason:
              'The web drops a file into a dropzone and base64s it. That '
              'needs a photo-library plugin this build does not ship (no '
              'image_picker in pubspec.yaml).',
        ),
        SizedBox(height: ZaveSpace.xl),
        ZaveButton.primary(
          label: 'Next: configure',
          expand: true,
          onPressed: widget.state.hasReference ? controller.next : null,
        ),
      ],
    );
  }
}

/// Step 2 — page size, register, naming, options, branding.
class _ConfigureStep extends ConsumerStatefulWidget {
  const _ConfigureStep({required this.state});

  final TemplateCreatorState state;

  @override
  ConsumerState<_ConfigureStep> createState() => _ConfigureStepState();
}

class _ConfigureStepState extends ConsumerState<_ConfigureStep> {
  late final TextEditingController _name = TextEditingController(
    text: widget.state.name,
  );
  late final TextEditingController _logo = TextEditingController(
    text: widget.state.logoImageUrl ?? '',
  );

  @override
  void dispose() {
    _name.dispose();
    _logo.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TemplateCreatorState state = widget.state;
    final TemplateCreatorController controller = ref.read(
      templateCreatorControllerProvider.notifier,
    );
    final TemplateStyle style = TemplateStyle.all.firstWhere(
      (TemplateStyle s) => s.id == state.styleId,
      orElse: () => TemplateStyle.all.first,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('CANVAS SIZE', style: ZaveType.kicker),
        SizedBox(height: ZaveSpace.md),
        Wrap(
          spacing: ZaveSpace.sm,
          runSpacing: ZaveSpace.sm,
          children: <Widget>[
            for (final CanvasPreset option in CanvasPreset.all)
              ZaveChip(
                label: option.name,
                selected: option.name == state.preset.name,
                onTap: () => controller.setPreset(option),
              ),
          ],
        ),
        SizedBox(height: ZaveSpace.sm),
        Text(state.preset.dimensions, style: ZaveType.caption),

        SizedBox(height: ZaveSpace.xxl),
        Text('OVERALL STYLE', style: ZaveType.kicker),
        SizedBox(height: ZaveSpace.md),
        Wrap(
          spacing: ZaveSpace.sm,
          runSpacing: ZaveSpace.sm,
          children: <Widget>[
            for (final TemplateStyle option in TemplateStyle.all)
              ZaveChip(
                label: option.name,
                selected: option.id == state.styleId,
                onTap: () => controller.setStyle(option.id),
              ),
          ],
        ),
        SizedBox(height: ZaveSpace.sm),
        Text(style.description, style: ZaveType.caption),

        SizedBox(height: ZaveSpace.xxl),
        ZaveField(
          controller: _name,
          label: 'Template name',
          hint: state.effectiveName,
          onChanged: controller.setName,
        ),

        SizedBox(height: ZaveSpace.xl),
        Text('CATEGORY', style: ZaveType.kicker),
        SizedBox(height: ZaveSpace.md),
        Wrap(
          spacing: ZaveSpace.sm,
          runSpacing: ZaveSpace.sm,
          children: <Widget>[
            for (final String option in kTemplateCategories)
              ZaveChip(
                label: categoryLabel(option),
                selected: option == state.category,
                onTap: () => controller.setCategory(option),
              ),
          ],
        ),

        SizedBox(height: ZaveSpace.xxl),
        ZaveCard(
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Include AI content', style: ZaveType.label),
                    SizedBox(height: ZaveSpace.xs),
                    Text(
                      'Add a heading, a subheading and a call to action.',
                      style: ZaveType.caption,
                    ),
                  ],
                ),
              ),
              SizedBox(width: ZaveSpace.md),
              ZaveSwitch(
                value: state.includeText,
                semanticLabel: 'Include AI content',
                onChanged: controller.setIncludeText,
              ),
            ],
          ),
        ),

        SizedBox(height: ZaveSpace.xl),
        Text('BRANDING (OPTIONAL)', style: ZaveType.kicker),
        SizedBox(height: ZaveSpace.md),
        if (state.logoImageUrl != null) ...<Widget>[
          _ImagePreview(url: state.logoImageUrl!),
          SizedBox(height: ZaveSpace.md),
        ],
        ZaveField(
          controller: _logo,
          label: 'Logo URL',
          hint: 'https://…',
          keyboardType: TextInputType.url,
          textInputAction: TextInputAction.done,
          onSubmitted: controller.setLogo,
        ),
        SizedBox(height: ZaveSpace.md),
        ZaveButton(
          label: state.logoImageUrl == null ? 'Use this logo' : 'Replace logo',
          expand: true,
          onPressed: () => controller.setLogo(_logo.text),
        ),

        SizedBox(height: ZaveSpace.xxl),
        ZaveButton.primary(
          label: 'Continue',
          expand: true,
          onPressed: controller.next,
        ),
        SizedBox(height: ZaveSpace.md),
        ZaveButton(label: 'Back', expand: true, onPressed: controller.back),
      ],
    );
  }
}

/// Steps 3 and 4 — what would be generated, and why it cannot be yet.
///
/// The web's step 3 shows a before/after strip: the reference on the left, an
/// empty placeholder at the target aspect ratio on the right. That strip is
/// kept, because it is the clearest statement of what the call would do — and
/// the right-hand side stays empty for the honest reason.
class _GenerateStep extends ConsumerWidget {
  const _GenerateStep({required this.state});

  final TemplateCreatorState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TemplateCreatorController controller = ref.read(
      templateCreatorControllerProvider.notifier,
    );
    final TemplateStyle style = TemplateStyle.all.firstWhere(
      (TemplateStyle s) => s.id == state.styleId,
      orElse: () => TemplateStyle.all.first,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ZaveCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('READY TO GENERATE', style: ZaveType.kicker),
              SizedBox(height: ZaveSpace.md),
              Text(state.effectiveName, style: ZaveType.h3),
              SizedBox(height: ZaveSpace.sm),
              Text(
                '${state.preset.dimensions} · ${style.name} · '
                '${categoryLabel(state.category)}',
                style: ZaveType.caption,
              ),
              SizedBox(height: ZaveSpace.lg),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  if (state.hasReference)
                    Expanded(
                      child: _ImagePreview(url: state.referenceImageUrl!),
                    ),
                  SizedBox(width: ZaveSpace.md),
                  Icon(
                    Icons.arrow_forward,
                    color: ZaveColors.ink45,
                    size: ZaveSpace.xl,
                  ),
                  SizedBox(width: ZaveSpace.md),
                  Expanded(
                    child: AspectRatio(
                      aspectRatio: state.preset.width / state.preset.height,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: ZaveGlass.rest,
                          border: Border.all(color: ZaveColors.rule, width: 1),
                          borderRadius: ZaveRadius.cardSmBr,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: ZaveSpace.lg),
        const StudioUnavailable(
          title: 'Generating the template',
          reason:
              'The mobile API has no template-creator route. The web '
              'posts to /api/ai/template-creator; there is no '
              '/api/mobile/v1/ai/template-creator to call, and inventing one '
              'would just 404 behind a catch.',
          detail:
              'Until it exists: the AI Designer inside Studio does build '
              'a whole design from a written brief, and that does work today.',
        ),
        SizedBox(height: ZaveSpace.lg),
        // Disabled, not hidden. A control the user can see and understand is
        // worth more than a gap they have to guess at — and when the route
        // lands, only its `onPressed` changes.
        const ZaveButton.primary(
          label: 'Generate template',
          expand: true,
          onPressed: null,
        ),
        SizedBox(height: ZaveSpace.md),
        ZaveButton(label: 'Back', expand: true, onPressed: controller.back),
      ],
    );
  }
}

/// A remote image at its own aspect ratio, on a Zave surface.
class _ImagePreview extends StatelessWidget {
  const _ImagePreview({required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    final ImageProvider<Object>? provider = studioImageProvider(url);

    return ClipRRect(
      borderRadius: ZaveRadius.cardSmBr,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: ZaveGlass.rest,
          border: Border.all(color: ZaveColors.rule, width: 1),
          borderRadius: ZaveRadius.cardSmBr,
        ),
        child: AspectRatio(
          aspectRatio: _previewAspect,
          child: provider == null
              ? Center(
                  child: Text(
                    'Could not read that image',
                    style: ZaveType.caption,
                  ),
                )
              : Image(
                  image: provider,
                  fit: BoxFit.contain,
                  errorBuilder: (_, _, _) => Center(
                    child: Text(
                      'That image did not load',
                      style: ZaveType.caption,
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  /// A 4:3 window. The reference's own ratio is unknown until it loads, and a
  /// box that resizes on load makes the whole step jump.
  static const double _previewAspect = 4 / 3;
}

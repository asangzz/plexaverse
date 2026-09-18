import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/zave_routes.dart';
import '../../../../core/security/clipboard_policy.dart';
import '../../../../core/ui/zave/zave_kit.dart';
import '../../../home/application/home_controllers.dart';
import '../../application/title_controller.dart';
import '../../application/title_creator_state.dart';
import '../../domain/title_creator.dart';
import '../widgets/studio_shared.dart';

/// **Profile Title Creator** — the web's `/title-creator`.
///
/// Roadmap level 1, step 4. Three steps and nothing else: type the headline
/// you have, say who the new one is for, read what you get. It is the most
/// mobile-native surface in this whole area — the web version is already a
/// single narrow column of two text fields and two big taps — so this is a
/// faithful port rather than a reinterpretation.
///
/// ## The one deliberate correction
///
/// The web sends `get_hired` as the priority. The mobile route accepts only
/// `personal_brand` | `recruiter` and coerces anything else away, at which
/// point the server silently falls back to the stored preference — so a client
/// that copied the web's string would produce a headline for the wrong
/// audience and look like it had worked. [TitlePriority] carries the corrected
/// wire value and the web's labels.
class TitleCreatorPage extends ConsumerWidget {
  const TitleCreatorPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TitleCreatorState state = ref.watch(titleCreatorControllerProvider);

    return ZaveScaffold(
      title: 'Title creator',
      leading: ZaveIconButton(
        icon: const Icon(Icons.arrow_back),
        tooltip: 'Back',
        onPressed: () => context.pop(),
      ),
      body: ZaveScrollView(
        children: <Widget>[
          Text('ROADMAP · LEVEL 1', style: ZaveType.kicker),
          SizedBox(height: ZaveSpace.md),
          Text(
            'A standout LinkedIn headline, written for whoever you want '
            'reading it.',
            style: ZaveType.lead,
          ),
          SizedBox(height: ZaveSpace.xl),
          _StepRail(step: state.step),
          SizedBox(height: ZaveSpace.xl),

          if (state.error != null) ...<Widget>[
            _ErrorLine(message: state.error!),
            SizedBox(height: ZaveSpace.lg),
          ],

          switch (state.step) {
            TitleStep.headline => _HeadlineStep(state: state),
            TitleStep.priority => _PriorityStep(state: state),
            TitleStep.result => _ResultStep(state: state),
          },
        ],
      ),
    );
  }
}

/// Three segments; the ones you have reached are white.
///
/// The web draws numbered circles joined by bars. Zave has no numbered-circle
/// component and adding one for a single screen would be a new primitive, so
/// this says the same thing with the language the system already has: a filled
/// segment is done, a rule-coloured one is not.
class _StepRail extends StatelessWidget {
  const _StepRail({required this.step});

  final TitleStep step;

  @override
  Widget build(BuildContext context) {
    final int reached = TitleStep.values.indexOf(step);
    return Row(
      children: <Widget>[
        for (int i = 0; i < TitleStep.values.length; i++) ...<Widget>[
          Expanded(
            child: Container(
              height: ZaveSpace.xs,
              decoration: BoxDecoration(
                color: i <= reached ? ZaveColors.white : ZaveColors.rule,
                borderRadius: ZaveRadius.pillBr,
              ),
            ),
          ),
          if (i < TitleStep.values.length - 1) SizedBox(width: ZaveSpace.sm),
        ],
      ],
    );
  }
}

/// Amber, never red — Zave has no red.
class _ErrorLine extends StatelessWidget {
  const _ErrorLine({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) => Row(
    children: <Widget>[
      const ZaveDot(ZaveColors.amber),
      SizedBox(width: ZaveSpace.sm),
      Expanded(
        child: Text(
          message,
          style: ZaveType.caption.copyWith(color: ZaveColors.amber),
        ),
      ),
    ],
  );
}

/// Step 1 — the headline you have now.
class _HeadlineStep extends ConsumerStatefulWidget {
  const _HeadlineStep({required this.state});

  final TitleCreatorState state;

  @override
  ConsumerState<_HeadlineStep> createState() => _HeadlineStepState();
}

class _HeadlineStepState extends ConsumerState<_HeadlineStep> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.state.headline,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ZaveField(
          controller: _controller,
          label: 'Current headline / profession',
          hint: 'e.g. Product Manager at Tech Co…',
          textInputAction: TextInputAction.done,
          onChanged: (String value) => ref
              .read(titleCreatorControllerProvider.notifier)
              .setHeadline(value),
          onSubmitted: (_) => _next(),
        ),
        SizedBox(height: ZaveSpace.xl),
        ZaveButton.primary(
          label: 'Next step',
          expand: true,
          busy: widget.state.busy,
          onPressed: widget.state.busy ? null : _next,
        ),
      ],
    );
  }

  void _next() => ref.read(titleCreatorControllerProvider.notifier).analyze();
}

/// Step 2 — who the headline is for. Choosing generates immediately, exactly
/// as on the web: there is no separate "generate" tap.
class _PriorityStep extends ConsumerWidget {
  const _PriorityStep({required this.state});

  final TitleCreatorState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String? read = state.analysis?.profession.trim();
    final String profession = (read == null || read.isEmpty)
        ? 'Professional'
        : read;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('YOUR PROFILE FOCUS', style: ZaveType.kicker),
        SizedBox(height: ZaveSpace.sm),
        Text(profession, style: ZaveType.h3),
        SizedBox(height: ZaveSpace.xl),
        for (final TitlePriority option in TitlePriority.values) ...<Widget>[
          ZaveCard(
            onTap: () => ref
                .read(titleCreatorControllerProvider.notifier)
                .choose(option),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(option.label, style: ZaveType.h3),
                SizedBox(height: ZaveSpace.sm),
                Text(option.description, style: ZaveType.bodyMuted),
              ],
            ),
          ),
          SizedBox(height: ZaveSpace.md),
        ],
      ],
    );
  }
}

/// The measured height of the generated-headline card, so the loading state
/// reserves the space the result will take. Zave names no skeleton sizes.
const double _resultSkeletonHeight = 160;

/// Step 3 — the headline, why it works, and what to do with it.
class _ResultStep extends ConsumerWidget {
  const _ResultStep({required this.state});

  final TitleCreatorState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (state.busy) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              const ZaveDot(ZaveColors.peri),
              SizedBox(width: ZaveSpace.sm),
              Text('ANALYSING PERSONA', style: ZaveType.kicker),
            ],
          ),
          SizedBox(height: ZaveSpace.lg),
          const StudioSkeleton(height: _resultSkeletonHeight),
        ],
      );
    }

    final TitleSuggestion? result = state.result;
    if (result == null || result.isEmpty) {
      return StudioNotice.failure(
        title: 'No headline came back.',
        body: 'Pick an audience again and it will have another go.',
        actionLabel: 'Start over',
        onAction: () =>
            ref.read(titleCreatorControllerProvider.notifier).restart(),
      );
    }

    final TitlePriority priority =
        state.priority ?? TitlePriority.personalBrand;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ZaveCard(
          size: ZaveCardSize.large,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(priority.resultKicker.toUpperCase(), style: ZaveType.kicker),
              SizedBox(height: ZaveSpace.md),
              Text(result.suggestedTitle, style: ZaveType.h3),
              SizedBox(height: ZaveSpace.lg),
              ZaveButton(
                label: 'Copy headline',
                icon: const Icon(Icons.copy_outlined),
                expand: true,
                onPressed: () async {
                  await ClipboardPolicy.copyNonSensitive(result.suggestedTitle);
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(
                        content: Text('Copied.', style: ZaveType.body),
                        backgroundColor: ZaveColors.deep,
                      ),
                    );
                },
              ),
            ],
          ),
        ),
        SizedBox(height: ZaveSpace.lg),
        if (result.reasoning.isNotEmpty) ...<Widget>[
          _InsightCard(
            kicker: 'Strategic logic',
            dot: ZaveColors.peri,
            body: result.reasoning,
          ),
          SizedBox(height: ZaveSpace.md),
        ],
        if (result.tips.isNotEmpty) ...<Widget>[
          _InsightCard(
            kicker: 'Authority tip',
            dot: ZaveColors.green,
            body: result.tips,
          ),
          SizedBox(height: ZaveSpace.md),
        ],
        SizedBox(height: ZaveSpace.lg),
        ZaveButton(
          label: 'Try again',
          expand: true,
          onPressed: () =>
              ref.read(titleCreatorControllerProvider.notifier).restart(),
        ),
        SizedBox(height: ZaveSpace.md),
        ZaveButton.primary(
          label: 'Complete quest',
          expand: true,
          onPressed: () => _complete(context, ref),
        ),
      ],
    );
  }

  /// Closes the roadmap step and goes home, which is what the web does
  /// (`router.refresh()` then `router.push('/dashboard')`).
  ///
  /// The roadmap lives in the home slice, so its provider is invalidated by
  /// hand here — without that the dashboard would still show the step as
  /// outstanding until the user pulled to refresh.
  Future<void> _complete(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(titleCreatorControllerProvider.notifier).completeQuest();
    } on Object {
      // The write is idempotent and the headline is already copied; failing to
      // tick a checkbox must not strand the user on this screen.
    }
    if (!context.mounted) return;
    ref.invalidate(roadmapProgressControllerProvider);
    context.go(ZaveRoutes.dashboard);
  }
}

class _InsightCard extends StatelessWidget {
  const _InsightCard({
    required this.kicker,
    required this.dot,
    required this.body,
  });

  final String kicker;
  final Color dot;
  final String body;

  @override
  Widget build(BuildContext context) => ZaveCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            ZaveDot(dot),
            SizedBox(width: ZaveSpace.sm),
            Expanded(child: Text(kicker.toUpperCase(), style: ZaveType.kicker)),
          ],
        ),
        SizedBox(height: ZaveSpace.md),
        Text(body, style: ZaveType.bodyMuted),
      ],
    ),
  );
}

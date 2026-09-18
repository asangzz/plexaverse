import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/ui/zave/zave_kit.dart';
import '../../application/missions_controllers.dart';
import '../../domain/missions_repository.dart';
import '../widgets/linkedin_handoff_card.dart';
import '../widgets/mission_chrome.dart';

/// **The Headline Hook** — the web's `/roadmap/headline-hook`.
///
/// Day-3 profile mission, reached from the Season 1 roadmap's step row. Write
/// or AI-optimise a LinkedIn headline, copy it across, tick a three-item manual
/// checklist, then complete the step.
///
/// ## Layout
///
/// The web is a 12-column grid: the editor on the left, "Final Polish" on the
/// right. Below `xl` it stacks, and that stacked order — editor, hand-off,
/// checklist, finish — is exactly what a phone gets here. No mobile-specific
/// arrangement was invented.
///
/// ## The one thing that changed shape
///
/// The web's "Update on LinkedIn" opens an embedded webview panel. The app
/// ships no browser plugin, so that becomes [LinkedInHandoffCard]: the same
/// copy action, the same URL, the same steps, stated rather than opened. See
/// that widget for the full reasoning.
class HeadlineHookPage extends ConsumerStatefulWidget {
  const HeadlineHookPage({super.key});

  /// `${levelId}-${stepId}` is the server's completion key. Level 1 step 3 —
  /// the same pair the web posts.
  static const int levelId = 1;
  static const int stepId = 3;

  /// LinkedIn's own headline editor.
  static const String editPath = 'edit/forms/intro/new/';

  /// LinkedIn caps a headline at 220 characters.
  static const int maxLength = 220;

  @override
  ConsumerState<HeadlineHookPage> createState() => _HeadlineHookPageState();
}

class _HeadlineHookPageState extends ConsumerState<HeadlineHookPage> {
  final TextEditingController _headline = TextEditingController();
  bool _seeded = false;

  bool _suggesting = false;
  bool _saving = false;
  bool _finishing = false;

  // The three manual steps the user does on LinkedIn itself. The first two
  // gate completion, exactly as on the web; the third is advice.
  bool _urlCleanup = false;
  bool _featuredAdded = false;
  bool _keywordsAdded = false;

  String? _message;
  MissionTone _tone = MissionTone.success;

  @override
  void dispose() {
    _headline.dispose();
    super.dispose();
  }

  /// Fills the field from the server's row, once. Re-seeding on every build
  /// would fight the user's typing.
  void _seed(MissionProfile profile) {
    if (_seeded) return;
    _seeded = true;
    _headline.text = profile.preferences.headline ?? '';
  }

  void _say(String text, MissionTone tone) {
    if (!mounted) return;
    setState(() {
      _message = text;
      _tone = tone;
    });
  }

  Future<void> _suggest() async {
    final String current = _headline.text.trim();
    if (current.length < 5) {
      _say(
        'Write a basic headline first so the model has something to optimise.',
        MissionTone.warning,
      );
      return;
    }

    setState(() {
      _suggesting = true;
      _message = null;
    });
    try {
      final String suggested = await ref
          .read(missionProfileControllerProvider.notifier)
          .suggestHeadline(current);
      _headline.text = suggested;
      _say('Headline optimised.', MissionTone.success);
    } on Object {
      _say(
        'That did not generate. Try again in a moment.',
        MissionTone.warning,
      );
    } finally {
      if (mounted) setState(() => _suggesting = false);
    }
  }

  Future<void> _saveDraft() async {
    setState(() {
      _saving = true;
      _message = null;
    });
    try {
      await ref.read(missionProfileControllerProvider.notifier).save(
        <String, dynamic>{'headline': _headline.text.trim()},
      );
      _say('Headline saved.', MissionTone.success);
    } on Object {
      _say('Could not save that headline.', MissionTone.warning);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _finish() async {
    if (!_urlCleanup || !_featuredAdded) {
      _say('Finish the checklist first.', MissionTone.warning);
      return;
    }

    setState(() {
      _finishing = true;
      _message = null;
    });
    try {
      await ref
          .read(missionProfileControllerProvider.notifier)
          .completeStep(
            levelId: HeadlineHookPage.levelId,
            stepId: HeadlineHookPage.stepId,
          );
      if (!mounted) return;
      // Back to the roadmap, which re-reads its own progress on the way in.
      context.pop();
    } on Object {
      _say('Could not record that step.', MissionTone.warning);
      if (mounted) setState(() => _finishing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<MissionProfile> profile = ref.watch(
      missionProfileControllerProvider,
    );

    return ZaveScaffold(
      title: 'Headline Hook',
      leading: ZaveIconButton(
        icon: const Icon(Icons.arrow_back),
        tooltip: 'Back to roadmap',
        onPressed: () => context.pop(),
      ),
      body: profile.when(
        loading: () => ZaveScrollView(
          children: <Widget>[
            const MissionSkeleton(height: 140),
            SizedBox(height: ZaveSpace.xl),
            const MissionSkeleton(height: 320),
            SizedBox(height: ZaveSpace.lg),
            const MissionSkeleton(height: 220),
          ],
        ),
        error: (Object e, StackTrace _) => ZaveScrollView(
          children: <Widget>[
            MissionErrorCard(
              title: 'Your profile did not load.',
              detail:
                  'The headline lives on your preferences row, and that read '
                  'did not come back.',
              onRetry: () => ref.invalidate(missionProfileControllerProvider),
            ),
          ],
        ),
        data: (MissionProfile p) {
          _seed(p);
          return _body(p);
        },
      ),
    );
  }

  Widget _body(MissionProfile profile) {
    return ZaveScrollView(
      children: <Widget>[
        const MissionHeader(
          title: 'The Headline Hook',
          subtitle:
              'Step 3: Craft a digital billboard that makes recruiters stop '
              'scrolling.',
          level: HeadlineHookPage.levelId,
          step: HeadlineHookPage.stepId,
          totalSteps: 7,
          rewardXp: 50,
        ),

        SizedBox(height: ZaveSpace.xl),

        // ── The editor ──
        ZaveCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('YOUR DIGITAL BILLBOARD', style: ZaveType.kicker),
              SizedBox(height: ZaveSpace.sm),
              Text(
                'Persona: ${profile.personaLabel}',
                style: ZaveType.bodyMuted,
              ),
              SizedBox(height: ZaveSpace.lg),

              ZaveField(
                controller: _headline,
                hint:
                    'Enter your current headline, or start with a simple '
                    'description…',
                maxLines: 4,
                minLines: 3,
                maxLength: HeadlineHookPage.maxLength,
              ),
              SizedBox(height: ZaveSpace.md),

              // The live counter. A ValueListenableBuilder rather than a
              // setState on every keystroke: only this badge depends on the
              // length, and rebuilding the whole page per character is how a
              // text field starts dropping input on a slow phone.
              ValueListenableBuilder<TextEditingValue>(
                valueListenable: _headline,
                builder:
                    (BuildContext context, TextEditingValue value, Widget? _) {
                      final int length = value.text.length;
                      return Align(
                        alignment: Alignment.centerLeft,
                        child: MissionBadge(
                          label: '$length / ${HeadlineHookPage.maxLength}',
                          // Green once it is close to the cap, which is where
                          // a headline is doing real work. The web turns this
                          // red past 200; Zave has no red, and being near the
                          // limit is not a failure anyway.
                          met: length > 200,
                        ),
                      );
                    },
              ),

              SizedBox(height: ZaveSpace.lg),
              // `busy` already blocks the tap (the kit treats a busy button
              // as disabled), so `onPressed` stays non-null — passing null
              // would also dim it to 50% and hide its own spinner.
              ZaveButton(
                label: _suggesting ? 'Optimising…' : 'AI Spark',
                icon: const Icon(Icons.auto_awesome),
                onPressed: _suggest,
                busy: _suggesting,
                expand: true,
              ),
              SizedBox(height: ZaveSpace.md),
              ZaveButton(
                label: 'Save as draft',
                onPressed: _saveDraft,
                busy: _saving,
                expand: true,
              ),
            ],
          ),
        ),

        SizedBox(height: ZaveSpace.lg),

        // ── Help ──
        const _HelpCard(
          kicker: 'Recommended formula',
          body: '[Job Title] | [Expertise] | [Impact/Secret Sauce]',
        ),
        SizedBox(height: ZaveSpace.md),
        const _HelpCard(
          kicker: 'Pro tip',
          body:
              'Use keywords that your target recruiters or clients search '
              'for.',
        ),
        SizedBox(height: ZaveSpace.md),
        _HelpCard(
          kicker: 'AI context',
          body: profile.preferences.priority == 'personal_brand'
              ? 'Optimising for thought leadership.'
              : 'Optimising for recruiter visibility.',
        ),

        SizedBox(height: ZaveSpace.lg),

        // Listening rather than reading once: the copy button must carry what
        // is in the field NOW, not what was there when the card was built.
        ValueListenableBuilder<TextEditingValue>(
          valueListenable: _headline,
          builder: (BuildContext context, TextEditingValue value, Widget? _) =>
              LinkedInHandoffCard(
                title: 'Update it on LinkedIn',
                payload: value.text,
                copyLabel: 'Copy headline',
                slug: profile.linkedinSlug,
                editPath: HeadlineHookPage.editPath,
                steps: const <String>[
                  'Open the link above — your profile intro editor loads',
                  'Find the "Headline" box',
                  'Paste the copied headline',
                  'Tap Save',
                ],
              ),
        ),

        SizedBox(height: ZaveSpace.lg),

        // ── Final polish ──
        ZaveCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('FINAL POLISH', style: ZaveType.kicker),
              SizedBox(height: ZaveSpace.sm),
              Text(
                'Do these on LinkedIn itself to get the most out of the new '
                'headline.',
                style: ZaveType.bodyMuted,
              ),
              SizedBox(height: ZaveSpace.lg),

              _ChecklistRow(
                label: 'Clean URL',
                detail: 'Remove the random numbers from your /in/ link.',
                value: _urlCleanup,
                onChanged: (bool v) => setState(() => _urlCleanup = v),
              ),
              SizedBox(height: ZaveSpace.md),
              _ChecklistRow(
                label: 'Feature content',
                detail: 'Add one or two projects to your Featured section.',
                value: _featuredAdded,
                onChanged: (bool v) => setState(() => _featuredAdded = v),
              ),
              SizedBox(height: ZaveSpace.md),
              _ChecklistRow(
                label: 'SEO boost',
                detail: 'Make sure your top skills appear in your intro.',
                value: _keywordsAdded,
                onChanged: (bool v) => setState(() => _keywordsAdded = v),
              ),

              if (_message != null) ...<Widget>[
                SizedBox(height: ZaveSpace.lg),
                MissionMessage(text: _message!, tone: _tone),
              ],

              SizedBox(height: ZaveSpace.lg),
              ZaveButton.primary(
                label: 'Finish step',
                // The first two are the gate the web enforces; SEO boost is
                // advice, so it does not block.
                onPressed: (_urlCleanup && _featuredAdded) ? _finish : null,
                busy: _finishing,
                expand: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// One of the three small guidance cards under the editor.
class _HelpCard extends StatelessWidget {
  const _HelpCard({required this.kicker, required this.body});

  final String kicker;
  final String body;

  @override
  Widget build(BuildContext context) => ZaveCard(
    size: ZaveCardSize.small,
    padding: ZaveSpace.rowPad,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(kicker.toUpperCase(), style: ZaveType.kicker),
        SizedBox(height: ZaveSpace.sm),
        Text(body, style: ZaveType.label),
      ],
    ),
  );
}

/// A manual step the user performs on LinkedIn and confirms here.
///
/// Zave has no checkbox — the system's one two-state control is [ZaveSwitch],
/// which inverts to solid white when on, the same selection language as a chip.
class _ChecklistRow extends StatelessWidget {
  const _ChecklistRow({
    required this.label,
    required this.detail,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final String detail;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ZaveSurface.row,
      padding: ZaveSpace.rowPad,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  label,
                  style: ZaveType.label.copyWith(
                    // Green means done, which is exactly what a ticked item is.
                    color: value ? ZaveColors.green : ZaveColors.white,
                  ),
                ),
                SizedBox(height: ZaveSpace.xs),
                Text(detail, style: ZaveType.caption),
              ],
            ),
          ),
          SizedBox(width: ZaveSpace.md),
          ZaveSwitch(value: value, onChanged: onChanged, semanticLabel: label),
        ],
      ),
    );
  }
}

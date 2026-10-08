import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/ui/zave/zave_kit.dart';
import '../../application/missions_controllers.dart';
import '../../domain/missions_repository.dart';
import '../widgets/linkedin_handoff_card.dart';
import '../widgets/mission_chrome.dart';

/// **The About Odyssey** — the web's `/roadmap/about-odyssey`.
///
/// Day-4 profile mission, reached from the Season 1 roadmap's step row.
/// AI-draft or write a three-paragraph LinkedIn About section, curate up to ten
/// skills, copy it across, then complete the step.
///
/// ## What the structure checklist is actually measuring
///
/// Paragraph count, and nothing cleverer. The web splits on a blank line
/// (`/\n\s*\n/`) and lights "Problem Hook", "Expertise Bridge" and
/// "Impact & CTA" as the count passes one, two and three. It is a shape check,
/// not a quality check, and the copy is honest about that — so the same split
/// is ported exactly rather than replaced with something that would disagree
/// with the web on the same text.
class AboutOdysseyPage extends ConsumerStatefulWidget {
  const AboutOdysseyPage({super.key});

  /// Level 1 step 4 — the same completion key the web posts.
  static const int levelId = 1;
  static const int stepId = 4;

  /// LinkedIn's own About editor.
  static const String editPath = 'edit/forms/summary/new/';

  /// The web refuses to complete the step below this. It is a floor, not a
  /// target: three real paragraphs are far longer.
  static const int minSummaryLength = 50;

  /// LinkedIn's own ceiling on the skill list the profile shows.
  static const int maxSkills = 10;

  @override
  ConsumerState<AboutOdysseyPage> createState() => _AboutOdysseyPageState();
}

class _AboutOdysseyPageState extends ConsumerState<AboutOdysseyPage> {
  final TextEditingController _summary = TextEditingController();
  final TextEditingController _newSkill = TextEditingController();
  bool _seeded = false;

  List<String> _skills = <String>[];

  bool _generating = false;
  bool _finishing = false;

  String? _message;
  MissionTone _tone = MissionTone.success;

  @override
  void dispose() {
    _summary.dispose();
    _newSkill.dispose();
    super.dispose();
  }

  void _seed(MissionProfile profile) {
    if (_seeded) return;
    _seeded = true;
    _summary.text = profile.preferences.summary ?? '';
    _skills = List<String>.of(profile.preferences.skills);
  }

  void _say(String text, MissionTone tone) {
    if (!mounted) return;
    setState(() {
      _message = text;
      _tone = tone;
    });
  }

  /// The web's paragraph rule, ported verbatim: split on a blank line, drop
  /// whatever is only whitespace.
  static int paragraphsIn(String text) => text
      .split(RegExp(r'\n\s*\n'))
      .where((String p) => p.trim().isNotEmpty)
      .length;

  Future<void> _generate() async {
    final MissionProfile? profile = ref
        .read(missionProfileControllerProvider)
        .value;
    final String profession = profile?.preferences.profession ?? '';
    if (profession.isEmpty) {
      _say(
        'Set your profession in Settings first — the draft is built around it.',
        MissionTone.warning,
      );
      return;
    }

    setState(() {
      _generating = true;
      _message = null;
    });
    try {
      final String about = await ref
          .read(missionProfileControllerProvider.notifier)
          .generateAbout();
      _summary.text = about;
      _say('About section drafted.', MissionTone.success);
    } on Object {
      _say(
        'That did not generate. Try again in a moment.',
        MissionTone.warning,
      );
    } finally {
      if (mounted) setState(() => _generating = false);
    }
  }

  void _addSkill() {
    final String skill = _newSkill.text.trim();
    if (skill.isEmpty) return;
    if (_skills.contains(skill)) {
      _say('That skill is already on the list.', MissionTone.warning);
      return;
    }
    if (_skills.length >= AboutOdysseyPage.maxSkills) {
      _say(
        'LinkedIn shows ${AboutOdysseyPage.maxSkills} skills — remove one '
        'first.',
        MissionTone.warning,
      );
      return;
    }
    setState(() {
      _skills = <String>[..._skills, skill];
      _newSkill.clear();
    });
  }

  void _removeSkill(String skill) => setState(() {
    _skills = _skills.where((String s) => s != skill).toList(growable: false);
  });

  Future<void> _finish() async {
    final String summary = _summary.text.trim();
    if (summary.length < AboutOdysseyPage.minSummaryLength) {
      _say(
        'Write a more substantial About section before finishing.',
        MissionTone.warning,
      );
      return;
    }

    setState(() {
      _finishing = true;
      _message = null;
    });
    try {
      final MissionProfileController controller = ref.read(
        missionProfileControllerProvider.notifier,
      );
      // Save BEFORE completing: if the save fails, the step must not be
      // recorded against work that was never persisted.
      await controller.save(<String, dynamic>{
        'summary': summary,
        'skills': _skills,
      });
      await controller.completeStep(
        levelId: AboutOdysseyPage.levelId,
        stepId: AboutOdysseyPage.stepId,
      );
      if (!mounted) return;
      context.pop();
    } on Object {
      _say('Could not save those changes.', MissionTone.warning);
      if (mounted) setState(() => _finishing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<MissionProfile> profile = ref.watch(
      missionProfileControllerProvider,
    );

    return ZaveScaffold(
      largeTitle: 'The About Odyssey',
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
            const MissionSkeleton(height: 360),
            SizedBox(height: ZaveSpace.lg),
            const MissionSkeleton(height: 240),
          ],
        ),
        error: (Object e, StackTrace _) => ZaveScrollView(
          children: <Widget>[
            MissionErrorCard(
              title: 'Your profile did not load.',
              detail:
                  'The About section and your skills live on your preferences '
                  'row, and that read did not come back.',
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
          subtitle:
              'Step 4: Craft a storytelling summary and showcase your skill '
              'stack.',
          level: AboutOdysseyPage.levelId,
          step: AboutOdysseyPage.stepId,
          totalSteps: 7,
          rewardXp: 70,
        ),

        SizedBox(height: ZaveSpace.xl),

        // ── Your story ──
        ZaveCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('YOUR STORY', style: ZaveType.kicker),
              SizedBox(height: ZaveSpace.lg),

              ZaveField(
                controller: _summary,
                hint:
                    'Write your LinkedIn summary here… or use AI Spark to get '
                    'a professional draft.',
                maxLines: 14,
                minLines: 8,
              ),
              SizedBox(height: ZaveSpace.md),

              // One listener drives both badges and the structure checklist,
              // so typing rebuilds this subtree rather than the whole page.
              ValueListenableBuilder<TextEditingValue>(
                valueListenable: _summary,
                builder:
                    (BuildContext context, TextEditingValue value, Widget? _) {
                      final int paragraphs = paragraphsIn(value.text);
                      final int characters = value.text.length;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Wrap(
                            spacing: ZaveSpace.sm,
                            runSpacing: ZaveSpace.sm,
                            children: <Widget>[
                              MissionBadge(
                                label: '$paragraphs/3 paragraphs',
                                met: paragraphs >= 3,
                              ),
                              MissionBadge(
                                label: '$characters characters',
                                met: characters > 300,
                              ),
                            ],
                          ),
                          SizedBox(height: ZaveSpace.lg),
                          _StructureRow(
                            label: 'Problem hook',
                            met: paragraphs >= 1,
                          ),
                          SizedBox(height: ZaveSpace.sm),
                          _StructureRow(
                            label: 'Expertise bridge',
                            met: paragraphs >= 2,
                          ),
                          SizedBox(height: ZaveSpace.sm),
                          _StructureRow(
                            label: 'Impact & CTA',
                            met: paragraphs >= 3,
                          ),
                        ],
                      );
                    },
              ),

              SizedBox(height: ZaveSpace.lg),
              // `busy` blocks the tap on its own; passing null as well would
              // dim the button and hide its spinner.
              ZaveButton(
                label: _generating ? 'Drafting…' : 'AI Spark',
                icon: const Icon(Icons.auto_awesome),
                onPressed: _generate,
                busy: _generating,
                expand: true,
              ),
            ],
          ),
        ),

        SizedBox(height: ZaveSpace.lg),

        ValueListenableBuilder<TextEditingValue>(
          valueListenable: _summary,
          builder: (BuildContext context, TextEditingValue value, Widget? _) =>
              LinkedInHandoffCard(
                title: 'Update it on LinkedIn',
                payload: value.text,
                copyLabel: 'Copy summary',
                slug: profile.linkedinSlug,
                editPath: AboutOdysseyPage.editPath,
                steps: const <String>[
                  'Open the link above — your profile summary editor loads',
                  'Find the "About" box',
                  'Paste the copied summary',
                  'Tap Save',
                ],
              ),
        ),

        SizedBox(height: ZaveSpace.lg),

        // ── Skill stack ──
        ZaveCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('SKILL STACK', style: ZaveType.kicker),
              SizedBox(height: ZaveSpace.sm),
              Text(
                'Add up to ${AboutOdysseyPage.maxSkills} professional skills '
                'to your profile.',
                style: ZaveType.bodyMuted,
              ),
              SizedBox(height: ZaveSpace.lg),

              Row(
                children: <Widget>[
                  Expanded(
                    child: ZaveField(
                      controller: _newSkill,
                      hint: 'Add a skill…',
                      pill: true,
                      maxLength: 30,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (String _) => _addSkill(),
                    ),
                  ),
                  SizedBox(width: ZaveSpace.sm),
                  ZaveIconButton(
                    icon: const Icon(Icons.add_rounded),
                    tooltip: 'Add skill',
                    onPressed: _skills.length >= AboutOdysseyPage.maxSkills
                        ? null
                        : _addSkill,
                  ),
                ],
              ),

              SizedBox(height: ZaveSpace.lg),

              if (_skills.isEmpty)
                Container(
                  width: double.infinity,
                  decoration: ZaveSurface.row,
                  padding: ZaveSpace.cardPad,
                  child: Text(
                    'Your skill stack is empty.',
                    style: ZaveType.caption,
                    textAlign: TextAlign.center,
                  ),
                )
              else
                Wrap(
                  spacing: ZaveSpace.sm,
                  runSpacing: ZaveSpace.sm,
                  children: <Widget>[
                    for (final String skill in _skills)
                      // A chip whose tap REMOVES it. The web puts a small × on
                      // the trailing edge; ZaveChip has one icon slot and it
                      // leads, so the × leads here rather than being drawn by
                      // hand outside the kit.
                      ZaveChip(
                        label: skill,
                        selected: false,
                        icon: const Icon(Icons.close_rounded),
                        onTap: () => _removeSkill(skill),
                      ),
                  ],
                ),

              if (_message != null) ...<Widget>[
                SizedBox(height: ZaveSpace.lg),
                MissionMessage(text: _message!, tone: _tone),
              ],

              SizedBox(height: ZaveSpace.lg),
              ZaveButton.primary(
                label: 'Finish step',
                onPressed: _finish,
                busy: _finishing,
                expand: true,
              ),
            ],
          ),
        ),

        SizedBox(height: ZaveSpace.lg),

        // The web shows this only below `md`, because only a phone hits the
        // problem it describes. Every screen here is a phone.
        ZaveCard(
          size: ZaveCardSize.small,
          padding: ZaveSpace.rowPad,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: ZaveSpace.xs + 2),
                child: const ZaveDot(ZaveColors.amber),
              ),
              SizedBox(width: ZaveSpace.sm),
              Expanded(
                child: Text(
                  "If the LinkedIn app doesn't open the About editor directly, "
                  'paste the copied text into the About section by hand.',
                  style: ZaveType.caption,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// One line of the three-part structure check.
///
/// Green when met — green is "done" in this system, and that is exactly what
/// this dot reports.
class _StructureRow extends StatelessWidget {
  const _StructureRow({required this.label, required this.met});

  final String label;
  final bool met;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        ZaveDot(met ? ZaveColors.green : ZaveColors.ink35),
        SizedBox(width: ZaveSpace.sm),
        Text(
          label.toUpperCase(),
          style: ZaveType.kicker.copyWith(
            color: met ? ZaveColors.green : ZaveColors.ink45,
          ),
        ),
      ],
    );
  }
}

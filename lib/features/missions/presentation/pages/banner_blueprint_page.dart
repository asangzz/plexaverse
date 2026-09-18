import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/ui/zave/zave_kit.dart';
import '../../application/missions_controllers.dart';
import '../../domain/missions_repository.dart';
import '../widgets/banner_preview.dart';
import '../widgets/mission_chrome.dart';

/// **Banner Blueprint** — the web's `/roadmap/banner-blueprint`.
///
/// Profile-banner mission, reached from the Season 1 roadmap's step row. A
/// carousel of Studio banner templates, each auto-personalised with the user's
/// name and position, rendered live from the design's own element tree.
///
/// ## What this screen cannot do, and why the button still exists
///
/// The web's single CTA renders the chosen template to a 2D canvas, downloads
/// it as a PNG, opens a LinkedIn panel, and marks the step complete **in the
/// background**. On a phone the first two of those need a way to hand a file to
/// the user — a share sheet or a gallery write — and the app ships neither
/// plugin. This slice may not add one.
///
/// So the screen does the parts it genuinely can: it personalises and previews
/// every template, and it records the step. The note under the CTA says plainly
/// where the image itself comes from. Silently completing a step while
/// pretending a download happened would be the worse of the two.
///
/// The plugin this needs is reported in the summary.
class BannerBlueprintPage extends ConsumerStatefulWidget {
  const BannerBlueprintPage({super.key});

  /// Level 2 step 4 — the same completion key the web posts. Note the LEVEL is
  /// 2 here, unlike the two profile missions; the roadmap's day-2 extra task is
  /// what links to this page.
  static const int levelId = 2;
  static const int stepId = 4;

  @override
  ConsumerState<BannerBlueprintPage> createState() =>
      _BannerBlueprintPageState();
}

class _BannerBlueprintPageState extends ConsumerState<BannerBlueprintPage> {
  /// Slightly under 1 so the neighbouring template peeks in, which is what
  /// tells a user the row scrolls at all.
  static const double _viewportFraction = 0.88;

  final PageController _pages = PageController(
    viewportFraction: _viewportFraction,
  );
  final TextEditingController _position = TextEditingController();
  bool _seeded = false;

  int _index = 0;
  bool _finishing = false;

  String? _message;
  MissionTone _tone = MissionTone.success;

  @override
  void dispose() {
    _pages.dispose();
    _position.dispose();
    super.dispose();
  }

  /// The web seeds this field from `headline` and falls back to `profession` —
  /// in that order, because a headline is the line the user already chose to
  /// present themselves with.
  void _seed(MissionProfile profile) {
    if (_seeded) return;
    _seeded = true;
    _position.text =
        profile.preferences.headline ?? profile.preferences.profession ?? '';
  }

  void _say(String text, MissionTone tone) {
    if (!mounted) return;
    setState(() {
      _message = text;
      _tone = tone;
    });
  }

  Future<void> _finish() async {
    setState(() {
      _finishing = true;
      _message = null;
    });
    try {
      await ref
          .read(missionProfileControllerProvider.notifier)
          .completeStep(
            levelId: BannerBlueprintPage.levelId,
            stepId: BannerBlueprintPage.stepId,
          );
      if (!mounted) return;
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
    final AsyncValue<List<BannerTemplate>> templates = ref.watch(
      bannerTemplatesProvider,
    );

    return ZaveScaffold(
      title: 'Banner Blueprint',
      leading: ZaveIconButton(
        icon: const Icon(Icons.arrow_back),
        tooltip: 'Back to roadmap',
        onPressed: () => context.pop(),
      ),
      body: ZaveScrollView(
        children: <Widget>[
          Text('Banner Blueprint', style: ZaveType.h2),
          SizedBox(height: ZaveSpace.md),
          Text(
            "Pick a template. Your name and position are filled in "
            'automatically.',
            style: ZaveType.lead,
          ),

          SizedBox(height: ZaveSpace.xl),

          // ── Position ──
          profile.when(
            loading: () => const MissionSkeleton(height: 96),
            error: (Object e, StackTrace _) => MissionErrorCard(
              title: 'Your profile did not load.',
              detail:
                  'The banner is personalised from your name and position, and '
                  'that read did not come back.',
              onRetry: () => ref.invalidate(missionProfileControllerProvider),
            ),
            data: (MissionProfile p) {
              _seed(p);
              return ZaveField(
                controller: _position,
                label: 'Your position',
                hint: 'e.g. Founder & CEO',
                onChanged: (String _) => setState(() {}),
              );
            },
          ),

          SizedBox(height: ZaveSpace.xl),

          // ── Carousel ──
          templates.when(
            loading: () => const MissionSkeleton(height: 180),
            error: (Object e, StackTrace _) => MissionErrorCard(
              title: 'Templates did not load.',
              detail:
                  'The banner templates come from Plexa Studio. Nothing is '
                  'lost — try again.',
              onRetry: () => ref.invalidate(bannerTemplatesProvider),
            ),
            data: (List<BannerTemplate> list) =>
                list.isEmpty ? const _NoTemplates() : _carousel(list, profile),
          ),

          SizedBox(height: ZaveSpace.xl),

          if (_message != null) ...<Widget>[
            MissionMessage(text: _message!, tone: _tone),
            SizedBox(height: ZaveSpace.lg),
          ],

          ZaveCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // Amber: waiting on something the app cannot do yet. Zave
                    // has no red, and nothing here has failed.
                    Padding(
                      padding: EdgeInsets.only(top: ZaveSpace.xs + 2),
                      child: const ZaveDot(ZaveColors.amber),
                    ),
                    SizedBox(width: ZaveSpace.sm),
                    Expanded(
                      child: Text(
                        'Saving the banner image is not available in the app '
                        'yet — download it from Plexa Studio on the web, then '
                        'upload it to your LinkedIn profile. You can still '
                        'mark the step done here.',
                        style: ZaveType.caption,
                      ),
                    ),
                  ],
                ),
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
        ],
      ),
    );
  }

  Widget _carousel(
    List<BannerTemplate> templates,
    AsyncValue<MissionProfile> profile,
  ) {
    // While the profile is still loading this is the web's own fallback, and
    // the preview re-renders the moment the real name arrives.
    final String name = profile.value?.bannerName ?? 'Plexaverse User';
    final String position = _position.text.trim();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          // A LinkedIn banner is 4:1, so a phone-width card is short. The
          // extra room is the card padding around the preview.
          height: 200,
          child: PageView.builder(
            controller: _pages,
            itemCount: templates.length,
            onPageChanged: (int i) => setState(() => _index = i),
            itemBuilder: (BuildContext context, int i) {
              final BannerTemplate template = templates[i];
              final bool active = i == _index;
              // Personalise on the way out, exactly as the web does in its
              // useMemo: substitute, then crop the canvas to the artwork.
              final BannerDesign design = template.data!
                  .personalised(name: name, position: position)
                  .normalised();

              return Padding(
                padding: EdgeInsets.symmetric(horizontal: ZaveSpace.sm),
                child: AnimatedOpacity(
                  duration: ZaveMotion.fast,
                  curve: ZaveMotion.curve,
                  opacity: active ? 1 : 0.4,
                  child: AnimatedScale(
                    duration: ZaveMotion.fast,
                    curve: ZaveMotion.curve,
                    scale: active ? 1 : 0.94,
                    child: ZaveCard(
                      // The active card takes the `now` fill step — "this is
                      // the one" — which is the one correct use of that step.
                      isNow: active,
                      padding: EdgeInsets.all(ZaveSpace.md),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          BannerPreview(design: design),
                          SizedBox(height: ZaveSpace.sm),
                          Text(
                            template.name.toUpperCase(),
                            style: ZaveType.kicker,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        SizedBox(height: ZaveSpace.md),

        // Page indicators. The active one stretches rather than changing
        // colour — position is the status here, not hue.
        Center(
          child: Wrap(
            spacing: ZaveSpace.sm,
            children: <Widget>[
              for (int i = 0; i < templates.length; i++)
                AnimatedContainer(
                  duration: ZaveMotion.fast,
                  curve: ZaveMotion.curve,
                  height: 6,
                  width: i == _index ? 40 : 10,
                  decoration: BoxDecoration(
                    color: i == _index ? ZaveColors.white : ZaveColors.rule,
                    borderRadius: ZaveRadius.pillBr,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

/// No banner templates exist yet. Not an error — the Studio library is
/// seeded server-side, and an empty one is a real state.
class _NoTemplates extends StatelessWidget {
  const _NoTemplates();

  @override
  Widget build(BuildContext context) => ZaveCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            const ZaveDot(ZaveColors.ink35),
            SizedBox(width: ZaveSpace.sm),
            Text('NO TEMPLATES YET', style: ZaveType.kicker),
          ],
        ),
        SizedBox(height: ZaveSpace.md),
        Text(
          'There are no banner templates in the Studio library right now.',
          style: ZaveType.bodyMuted,
        ),
      ],
    ),
  );
}

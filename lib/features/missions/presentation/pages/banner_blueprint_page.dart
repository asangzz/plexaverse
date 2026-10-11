import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/links/linkedin.dart';
import '../../../../core/ui/app_icons.dart';
import '../../../../core/ui/widgets/open_link.dart';
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

  /// Which template the carousel is showing, and the boundary the export
  /// renders. Both are this widget's by nature — a page index is a selection
  /// inside one local control, and a `GlobalKey` identifies a render object
  /// that only exists while this page is mounted.
  ///
  /// A notifier rather than a field behind `setState`, because the index is
  /// read by the carousel and by nothing else on this page. Under `setState` a
  /// swipe rebuilt the heading, the position field, the notice and the three
  /// buttons below as well.
  final ValueNotifier<int> _index = ValueNotifier<int>(0);
  final GlobalKey _bannerKey = GlobalKey();

  /// Everything the carousel reads that is not a provider: the chosen page and
  /// the position text, which is substituted into every preview.
  ///
  /// Merged once and held rather than rebuilt inside `build`, so an unrelated
  /// rebuild does not re-subscribe the builder to both of them. The text half
  /// is why the field no longer carries `onChanged: (_) => setState(() {})` —
  /// a [TextEditingController] is already a [Listenable], and that call was
  /// rebuilding the whole page on every keystroke to re-render one row.
  late final Listenable _carouselInputs = Listenable.merge(<Listenable>[
    _position,
    _index,
  ]);

  @override
  void dispose() {
    _pages.dispose();
    _position.dispose();
    _index.dispose();
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

  BannerBlueprintController get _form =>
      ref.read(bannerBlueprintControllerProvider.notifier);

  Future<void> _finish() async {
    final bool done = await _form.finish(
      levelId: BannerBlueprintPage.levelId,
      stepId: BannerBlueprintPage.stepId,
    );
    if (done && mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<MissionProfile> profile = ref.watch(
      missionProfileControllerProvider,
    );
    final AsyncValue<List<BannerTemplate>> templates = ref.watch(
      bannerTemplatesProvider,
    );
    final BannerBlueprintState form = ref.watch(
      bannerBlueprintControllerProvider,
    );

    return ZaveScaffold(
      largeTitle: 'Banner Blueprint',
      leading: ZaveIconButton(
        icon: const Icon(AppIcons.back),
        tooltip: 'Back to roadmap',
        onPressed: () => context.pop(),
      ),
      body: ZaveScrollView(
        children: <Widget>[
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
              // No `onChanged`: the carousel listens to this controller
              // directly, which is the only thing the typed text feeds.
              return ZaveField(
                controller: _position,
                label: 'Your position',
                hint: 'e.g. Founder & CEO',
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
            data: (List<BannerTemplate> list) => list.isEmpty
                ? const _NoTemplates()
                : ListenableBuilder(
                    listenable: _carouselInputs,
                    builder: (BuildContext context, Widget? _) =>
                        _carousel(list, profile),
                  ),
          ),

          SizedBox(height: ZaveSpace.xl),

          if (form.notice case final MissionNotice notice) ...<Widget>[
            MissionMessage(text: notice.text, tone: notice.tone),
            SizedBox(height: ZaveSpace.lg),
          ],

          ZaveCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: ZaveSpace.xs + 2),
                      child: const ZaveDot(ZaveColors.peri),
                    ),
                    SizedBox(width: ZaveSpace.sm),
                    Expanded(
                      child: Text(
                        'Save the banner, then set it as your LinkedIn '
                        'cover photo.',
                        style: ZaveType.caption,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: ZaveSpace.md),
                // "…from the LinkedIn app or the web" used to end that
                // sentence — an instruction to go and find it. The web opens
                // the bare domain here for the same reason this does: the
                // cover-photo editor has no addressable URL.
                ZaveButton(
                  label: 'Open LinkedIn',
                  icon: const Icon(AppIcons.openExternal),
                  expand: true,
                  onPressed: () =>
                      openLinkAndReport(context, ref, linkedInHomeUrl),
                ),
                SizedBox(height: ZaveSpace.lg),
                ZaveButton(
                  label: 'Save this banner',
                  icon: const Icon(AppIcons.share),
                  expand: true,
                  busy: form.saving,
                  onPressed: form.saving
                      ? null
                      : () => _form.saveBanner(_bannerKey),
                ),
                SizedBox(height: ZaveSpace.lg),
                ZaveButton.primary(
                  label: 'Finish step',
                  onPressed: _finish,
                  busy: form.finishing,
                  expand: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Built inside the [ListenableBuilder] above, so reading `_position.text`
  /// and `_index.value` here is a subscribed read, not a stale snapshot.
  Widget _carousel(
    List<BannerTemplate> templates,
    AsyncValue<MissionProfile> profile,
  ) {
    // While the profile is still loading this is the web's own fallback, and
    // the preview re-renders the moment the real name arrives.
    final String name = profile.value?.bannerName ?? 'Plexaverse User';
    final String position = _position.text.trim();
    final int index = _index.value;

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
            onPageChanged: (int i) => _index.value = i,
            itemBuilder: (BuildContext context, int i) {
              final BannerTemplate template = templates[i];
              final bool active = i == index;
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
                          // Only the active card carries the boundary: the
                          // key must identify exactly one render object, and
                          // the export is always of the card the user is
                          // looking at.
                          active
                              ? RepaintBoundary(
                                  key: _bannerKey,
                                  child: BannerPreview(design: design),
                                )
                              : BannerPreview(design: design),
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
                  width: i == index ? 40 : 10,
                  decoration: BoxDecoration(
                    color: i == index ? ZaveColors.white : ZaveColors.rule,
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
  Widget build(BuildContext context) => const ZaveEmptyState(
    kicker: 'NO TEMPLATES YET',
    title: 'Nothing to start from',
    body: 'There are no banner templates in the Studio library right now.',
  );
}

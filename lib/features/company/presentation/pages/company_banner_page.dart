import 'dart:convert' show base64Encode;
import 'dart:typed_data' show ByteData, Uint8List;
import 'dart:ui' as ui show Image, ImageByteFormat;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart'
    show RenderObject, RenderRepaintBoundary;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/zave_routes.dart';
import '../../../../core/ui/zave/zave_kit.dart';
import '../../../studio/presentation/widgets/css_value.dart';
import '../../../studio/presentation/widgets/design_canvas.dart';
import '../../application/banner_controller.dart';
import '../../domain/banner_template.dart';
import '../../domain/company_repository.dart';
import '../widgets/company_states.dart';

/// **Company Banner** — the web's `/company-banner`.
///
/// Pick a banner template, personalise it with your name and position, and put
/// it on the company page's cover.
///
/// ## The deliberate departure
///
/// The web DOWNLOADS the banner and then walks the user through uploading it
/// by hand, because a browser page cannot write a company page's cover image.
/// The mobile API can: `POST /linkedin/company-banner` does the
/// register-upload / PUT / partial-update dance server-side. So this screen
/// applies the banner directly, and keeps the web's manual instructions only
/// for the case where it cannot — no linked page, or LinkedIn refusing.
///
/// That also resolves a live contradiction on the web: its on-page steps talk
/// about the Company Page cover photo while the drawer it opens talks about
/// the user's PERSONAL profile background photo. Only one of those is what the
/// screen is for, and it is the first.
///
/// Nav visibility is `admin` — hidden from end users in v1, reachable by deep
/// link.
class CompanyBannerPage extends ConsumerStatefulWidget {
  const CompanyBannerPage({super.key});

  @override
  ConsumerState<CompanyBannerPage> createState() => _CompanyBannerPageState();
}

class _CompanyBannerPageState extends ConsumerState<CompanyBannerPage> {
  /// Marks the preview of the CURRENTLY SELECTED template so it can be
  /// rasterised. Exactly one page carries it at a time — the PageView keeps
  /// neighbours alive, and two boundaries with one key would be a duplicate
  /// GlobalKey crash.
  final GlobalKey _captureKey = GlobalKey();

  final PageController _pages = PageController(viewportFraction: 0.88);
  final TextEditingController _position = TextEditingController();
  bool _positionSeeded = false;

  @override
  void dispose() {
    _pages.dispose();
    _position.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<BannerState> banner = ref.watch(bannerControllerProvider);

    // Seed the position field once, from the user's headline. After that the
    // field is theirs — re-seeding on every rebuild would fight their typing.
    //
    // Deferred to after the frame on purpose: the data arrives on a REBUILD,
    // by which point the field's EditableText is already listening, and
    // writing to a controller during build makes it call setState mid-build.
    final BannerState? value = banner.value;
    if (value != null && !_positionSeeded) {
      _positionSeeded = true;
      final String seed = value.position;
      WidgetsBinding.instance.addPostFrameCallback((Duration _) {
        if (mounted) _position.text = seed;
      });
    }

    return ZaveScaffold(
      title: 'Company Banner',
      body: banner.when(
        loading: () => ZaveScrollView(
          children: <Widget>[
            const CompanySkeleton(height: 120),
            SizedBox(height: ZaveSpace.xl),
            const CompanySkeleton(height: 180),
          ],
        ),
        error: (Object e, StackTrace _) => ZaveScrollView(
          children: <Widget>[
            if (e is CompanyUnavailable)
              CompanyUnavailableCard(
                failure: e,
                onRetry: () => ref.invalidate(bannerControllerProvider),
                onOpenSettings: () => context.push(ZaveRoutes.settings),
              )
            else
              CompanyErrorCard(
                title: "The banner templates didn't load.",
                onRetry: () => ref.invalidate(bannerControllerProvider),
              ),
          ],
        ),
        data: _body,
      ),
    );
  }

  Widget _body(BannerState state) {
    if (state.templates.isEmpty) {
      return ZaveScrollView(
        children: const <Widget>[
          CompanyEmptyCard(
            title: 'No banner templates yet',
            body:
                'There are no templates in the banner category. Publish one '
                'from Plexa Studio and it will appear here.',
          ),
        ],
      );
    }

    return ZaveScrollView(
      children: <Widget>[
        Text(
          'Pick a template, personalise it, then apply it as your LinkedIn '
          'Company Page cover photo.',
          style: ZaveType.lead,
        ),
        SizedBox(height: ZaveSpace.xl),
        ZaveField(
          controller: _position,
          label: 'Your position',
          hint: 'e.g. Founder & CEO',
          onChanged: (String value) =>
              ref.read(bannerControllerProvider.notifier).setPosition(value),
        ),
        SizedBox(height: ZaveSpace.xl),
        _Carousel(
          state: state,
          controller: _pages,
          captureKey: _captureKey,
          onPageChanged: (int index) =>
              ref.read(bannerControllerProvider.notifier).selectTemplate(index),
        ),
        SizedBox(height: ZaveSpace.lg),
        _Dots(count: state.templates.length, index: state.index),
        SizedBox(height: ZaveSpace.xxl),
        _ApplyPanel(state: state, onApply: _apply),
      ],
    );
  }

  /// Rasterises the selected preview and hands the PNG to LinkedIn.
  ///
  /// The pixel ratio is derived so the export lands at the template's AUTHORED
  /// width rather than the phone's. A 340-point carousel card rasterised at
  /// device scale would put a ~1000px image on a cover LinkedIn renders at
  /// 1584 — visibly soft on every desktop that opens the page.
  Future<void> _apply() async {
    final BannerController notifier = ref.read(
      bannerControllerProvider.notifier,
    );
    final BannerState? state = ref.read(bannerControllerProvider).value;
    final StudioDesignData? design = state?.preparedDesign;
    if (design == null) return;

    notifier.beginRender();

    try {
      final BuildContext? captureContext = _captureKey.currentContext;
      final RenderObject? object = captureContext?.findRenderObject();
      if (object is! RenderRepaintBoundary) {
        notifier.failRender();
        return;
      }

      final double renderedWidth = object.size.width;
      if (renderedWidth <= 0) {
        notifier.failRender();
        return;
      }
      final double targetWidth = design.canvas.width <= 0
          ? renderedWidth
          : design.canvas.width;

      final ui.Image image = await object.toImage(
        pixelRatio: targetWidth / renderedWidth,
      );
      final ByteData? bytes = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );
      final int width = image.width;
      final int height = image.height;
      image.dispose();

      if (bytes == null) {
        notifier.failRender();
        return;
      }

      final Uint8List png = bytes.buffer.asUint8List(
        bytes.offsetInBytes,
        bytes.lengthInBytes,
      );

      await notifier.apply(
        imageBase64: base64Encode(png),
        width: width,
        height: height,
      );
    } on Object {
      notifier.failRender();
    }
  }
}

/// The template carousel.
///
/// The web is a horizontal snap-scroller where the active slide sits at full
/// scale and opacity and its neighbours at 0.9 / 0.4. A [PageView] with a
/// viewport fraction is the same gesture, and the neighbours are faded the
/// same way — the one page a user can act on should be the one page that reads
/// as present.
class _Carousel extends StatelessWidget {
  const _Carousel({
    required this.state,
    required this.controller,
    required this.captureKey,
    required this.onPageChanged,
  });

  final BannerState state;
  final PageController controller;
  final GlobalKey captureKey;
  final ValueChanged<int> onPageChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // A fixed height, because a PageView needs one. 132 fits a 4:1 LinkedIn
      // cover across a phone's width with room to breathe; a template whose
      // normalised bounding box is squarer letterboxes inside it rather than
      // overflowing. Not a Zave token — there is no token for "as tall as a
      // cover image happens to be".
      height: 132,
      child: PageView.builder(
        controller: controller,
        itemCount: state.templates.length,
        onPageChanged: onPageChanged,
        itemBuilder: (BuildContext context, int index) {
          final bool active = index == state.index;
          final BannerTemplate template = state.templates[index];

          // The active page renders the PREPARED design (personalised and
          // cropped); the neighbours render the raw template. Preparing all
          // three would run the transform on every keystroke in the position
          // field for banners the user cannot see.
          final StudioDesignData? design = active
              ? state.preparedDesign
              : template.data;

          // `DesignCanvas` is the studio slice's renderer, reused rather than
          // re-implemented: it is the one place in the app that understands a
          // Studio element tree, and a second renderer would let a template
          // preview correctly here and export wrong.
          final Widget preview = design == null
              ? const CompanySkeleton(height: 120)
              // The canvas paints its own rounded corners, which would leave
              // transparent pixels in the exported PNG — and LinkedIn
              // composites a cover onto its own background, so those corners
              // would show. Backing it with the design's own canvas colour
              // makes the rasterised image opaque edge to edge.
              : ColoredBox(
                  color: cssColor(
                    design.canvas.background,
                    fallback: ZaveColors.midnight,
                  ),
                  child: DesignCanvas(data: design),
                );

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: ZaveSpace.sm),
            child: AnimatedOpacity(
              duration: ZaveMotion.fast,
              curve: ZaveMotion.curve,
              opacity: active ? 1 : 0.4,
              child: Center(
                child: active
                    ? RepaintBoundary(key: captureKey, child: preview)
                    : preview,
              ),
            ),
          );
        },
      ),
    );
  }
}

/// The carousel's page indicator — the active dot stretches into a bar.
class _Dots extends StatelessWidget {
  const _Dots({required this.count, required this.index});

  final int count;
  final int index;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      for (int i = 0; i < count; i++)
        Padding(
          padding: EdgeInsets.symmetric(horizontal: ZaveSpace.xs),
          child: AnimatedContainer(
            duration: ZaveMotion.fast,
            curve: ZaveMotion.curve,
            // A hairline bar rather than a dot. The web's 6px/64px pair is
            // scaled down for a phone; no Zave token covers an indicator.
            height: 4,
            width: i == index ? 40 : 10,
            decoration: BoxDecoration(
              // Selected inverts to solid white, exactly as a chip does.
              color: i == index ? ZaveColors.white : ZaveColors.rule,
              borderRadius: ZaveRadius.pillBr,
            ),
          ),
        ),
    ],
  );
}

/// The manual route, for when the direct apply is not available.
const List<String> _manualSteps = <String>[
  'Go to your LinkedIn Company Page and tap Edit page.',
  'Under Page info, open Cover photo.',
  'Upload the banner and save.',
];

/// The action panel: apply, or say honestly why it cannot.
class _ApplyPanel extends StatelessWidget {
  const _ApplyPanel({required this.state, required this.onApply});

  final BannerState state;
  final Future<void> Function() onApply;

  @override
  Widget build(BuildContext context) {
    final bool unlinked = state.organizationId == null;

    return ZaveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (state.status == BannerApplyStatus.done) ...<Widget>[
            Row(
              children: <Widget>[
                const ZaveDot(ZaveColors.green),
                SizedBox(width: ZaveSpace.sm),
                Text('APPLIED', style: ZaveType.kicker),
              ],
            ),
            SizedBox(height: ZaveSpace.md),
            Text(
              'Your Company Page cover photo has been replaced.',
              style: ZaveType.bodyMuted,
            ),
            SizedBox(height: ZaveSpace.lg),
          ],
          if (state.error != null) ...<Widget>[
            Row(
              children: <Widget>[
                // Amber, not red. Zave has no red, and a banner that did not
                // apply is a retry, not a catastrophe.
                const ZaveDot(ZaveColors.amber),
                SizedBox(width: ZaveSpace.sm),
                Expanded(child: Text(state.error!, style: ZaveType.bodyMuted)),
              ],
            ),
            SizedBox(height: ZaveSpace.lg),
          ],
          ZaveButton(
            label: unlinked
                ? 'No Company Page linked'
                : 'Apply to Company Page',
            kind: ZaveButtonKind.primarySmall,
            busy: state.isBusy,
            expand: true,
            onPressed: state.canApply ? onApply : null,
          ),
          SizedBox(height: ZaveSpace.lg),
          Container(height: 1, color: ZaveColors.rule),
          SizedBox(height: ZaveSpace.lg),
          Text('OR APPLY IT YOURSELF', style: ZaveType.kicker),
          SizedBox(height: ZaveSpace.md),
          Text(
            unlinked
                ? 'Link a Company Page in Settings to apply it from here. '
                      'Until then, the steps below are the manual route.'
                : 'If LinkedIn refuses the upload, these are the same steps '
                      'the web app walks you through.',
            style: ZaveType.caption,
          ),
          SizedBox(height: ZaveSpace.md),
          // The web's "How to apply your banner" list. Its first step
          // ("Download the banner below") is dropped — there is nothing to
          // download here, and the remaining three are the actual instructions.
          for (final (int index, String step) in _manualSteps.indexed)
            Padding(
              padding: EdgeInsets.only(bottom: ZaveSpace.sm),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('${index + 1}', style: ZaveType.num),
                  SizedBox(width: ZaveSpace.md),
                  Expanded(child: Text(step, style: ZaveType.bodyMuted)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

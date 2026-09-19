import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/ui/zave/zave_kit.dart';
import '../../application/headshots_controller.dart';
import '../../domain/headshot_session.dart';
import '../widgets/ai_tool_image.dart';
import '../widgets/ai_tool_note.dart';
import '../widgets/headshot_stepper.dart';
import '../../../../core/platform/image_picking.dart';
import '../../../../core/platform/image_sharing.dart';

/// **The Visual Persona** — the web's `/headshots`.
///
/// Upload three to ten reference photos, pick a look and a background, spend
/// XP, get four LinkedIn portraits back. It is the roadmap's Level 1 Step 5,
/// which is why it has no nav entry on either platform: it is reached from the
/// mission that asks for it.
///
/// ## The one thing this build cannot do
///
/// It cannot read the camera roll. The app ships no image-picker package and
/// `pubspec.yaml` is not this slice's to change, so there is no way to put a
/// photo into [HeadshotSession.photos]. Every other part of the flow is real
/// and wired: the wizard, the looks, the backgrounds, the request, the
/// failure branches, the roadmap completion.
///
/// **The deliberate departure:** step 1 does not block step 2. The web gates
/// "Select Looks" on three photos; here the gate is moved to the generate
/// button instead, so the looks and backgrounds can be seen and chosen while
/// the picker is missing. The button that actually spends XP still refuses,
/// and says why. Gating the first step instead would leave three quarters of
/// this screen unreachable for a reason that has nothing to do with the user.
///
/// ## What the web gets wrong here, and this does not
///
/// • The XP figure. The page says "1000 XP will be deducted"; the server
///   charges `AI_GENERATE_HEADSHOT`, which is **1200**. The app quotes the
///   server, because the server is what takes the XP.
/// • "Download HD" is hover-only, so on a phone the results are a dead end.
///   There is nothing to hover here.
class HeadshotsPage extends ConsumerWidget {
  const HeadshotsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final HeadshotSession session = ref.watch(headshotsControllerProvider);
    final HeadshotsController controller = ref.read(
      headshotsControllerProvider.notifier,
    );

    return ZaveScaffold(
      title: 'Headshots',
      body: ZaveScrollView(
        children: <Widget>[
          const _Intro(),
          SizedBox(height: ZaveSpace.xl),
          HeadshotStepper(current: session.step),
          SizedBox(height: ZaveSpace.xl),

          if (session.error != null) ...<Widget>[
            ZaveCard(
              child: AiToolNote(
                title: session.insufficientXp
                    ? 'Not enough XP'
                    : 'That did not work',
                message: session.error!,
              ),
            ),
            SizedBox(height: ZaveSpace.lg),
          ],

          switch (session.step) {
            HeadshotStep.upload => _UploadStep(
              session: session,
              controller: controller,
            ),
            HeadshotStep.style => _StyleStep(
              session: session,
              controller: controller,
            ),
            HeadshotStep.generate => const _GeneratingStep(),
            HeadshotStep.results => _ResultsStep(
              session: session,
              controller: controller,
            ),
          },
        ],
      ),
    );
  }
}

/// The heading block. The web's h1 is "The **Visual** Persona" with one word
/// in a gradient; Zave has no gradient text and a gradient is not a status, so
/// the emphasis is carried by the kicker above it instead.
class _Intro extends StatelessWidget {
  const _Intro();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text('LEVEL 1 · STEP 5 OF 7', style: ZaveType.kicker),
      SizedBox(height: ZaveSpace.md),
      Text('The Visual Persona', style: ZaveType.h2),
      SizedBox(height: ZaveSpace.md),
      Text(
        'Professional AI headshots for your LinkedIn profile.',
        style: ZaveType.lead,
      ),
      SizedBox(height: ZaveSpace.lg),
      Wrap(
        spacing: ZaveSpace.sm,
        runSpacing: ZaveSpace.sm,
        children: const <Widget>[
          ZavePill(label: 'Reward: 100 XP', color: ZaveColors.amber),
          ZavePill(label: '4 portraits', color: ZaveColors.ink62),
        ],
      ),
    ],
  );
}

/// Step 1 — reference photos.
class _UploadStep extends StatelessWidget {
  const _UploadStep({required this.session, required this.controller});

  final HeadshotSession session;
  final HeadshotsController controller;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      ZaveCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Upload reference photos', style: ZaveType.h3),
            SizedBox(height: ZaveSpace.md),
            Text(
              'The generator learns how you look from these. It works best '
              'with at least two waist-up photos mixed in with close-ups.',
              style: ZaveType.bodyMuted,
            ),
            SizedBox(height: ZaveSpace.lg),
            Row(
              children: <Widget>[
                Expanded(
                  child: ZaveButton(
                    label: 'Choose photos',
                    icon: const Icon(Icons.photo_library_outlined),
                    expand: true,
                    onPressed: () => _pick(context, controller, ImageSourceKind.gallery),
                  ),
                ),
                SizedBox(width: ZaveSpace.md),
                Expanded(
                  child: ZaveButton(
                    label: 'Take one',
                    icon: const Icon(Icons.photo_camera_outlined),
                    expand: true,
                    onPressed: () => _pick(context, controller, ImageSourceKind.camera),
                  ),
                ),
              ],
            ),
            if (session.photos.isNotEmpty) ...<Widget>[
              SizedBox(height: ZaveSpace.lg),
              Text(
                '${session.photos.length} of $maxHeadshotPhotos photos',
                style: ZaveType.caption,
              ),
              SizedBox(height: ZaveSpace.sm),
              Wrap(
                spacing: ZaveSpace.sm,
                runSpacing: ZaveSpace.sm,
                children: <Widget>[
                  for (int i = 0; i < session.photos.length; i++)
                    _PhotoThumb(
                      source: session.photos[i],
                      onRemove: () => controller.removePhoto(i),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
      SizedBox(height: ZaveSpace.lg),
      const _Requirements(),
      SizedBox(height: ZaveSpace.lg),
      ZaveButton(
        label: 'Select looks',
        kind: ZaveButtonKind.primary,
        trailing: const Icon(Icons.arrow_forward),
        expand: true,
        onPressed: () => controller.goTo(HeadshotStep.style),
      ),
    ],
  );
}

/// The web's four-row "Requirements" card, verbatim. Emoji and all: they are
/// content, not decoration, and they are the fastest way to read this list.
class _Requirements extends StatelessWidget {
  const _Requirements();

  static const List<String> _rules = <String>[
    '📷  High quality, high resolution photos.',
    '👔  Different outfits, backgrounds and expressions.',
    '💈  Same hairstyle and beard.',
    '👀  Looking directly at the camera. No silly faces.',
  ];

  @override
  Widget build(BuildContext context) => ZaveCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Requirements', style: ZaveType.h3),
        SizedBox(height: ZaveSpace.md),
        Text(
          'A few clear, everyday photos where your face is visible.',
          style: ZaveType.bodyMuted,
        ),
        SizedBox(height: ZaveSpace.lg),
        for (final String rule in _rules) ...<Widget>[
          Text(rule, style: ZaveType.body),
          SizedBox(height: ZaveSpace.sm),
        ],
      ],
    ),
  );
}

/// One attached reference photo.
class _PhotoThumb extends StatelessWidget {
  const _PhotoThumb({required this.source, required this.onRemove});

  final String source;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) => Stack(
    children: <Widget>[
      ClipRRect(
        borderRadius: ZaveRadius.cardSmBr,
        child: SizedBox(
          height: ZaveSpace.xxl * 2,
          width: ZaveSpace.xxl * 2,
          child: AiToolImage(source: source),
        ),
      ),
      Positioned(
        top: 0,
        right: 0,
        child: ZaveIconButton(
          icon: const Icon(Icons.close),
          tooltip: 'Remove photo',
          onPressed: onRemove,
        ),
      ),
    ],
  );
}

/// Step 2 — the look and the background.
class _StyleStep extends StatelessWidget {
  const _StyleStep({required this.session, required this.controller});

  final HeadshotSession session;
  final HeadshotsController controller;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text('SELECT YOUR STYLE', style: ZaveType.kicker),
      SizedBox(height: ZaveSpace.lg),
      for (final HeadshotStyle style in HeadshotStyle.values) ...<Widget>[
        _StyleCard(
          style: style,
          selected: session.style == style,
          onTap: () => controller.chooseStyle(style),
        ),
        SizedBox(height: ZaveSpace.md),
      ],

      SizedBox(height: ZaveSpace.lg),
      Text('BACKGROUND', style: ZaveType.kicker),
      SizedBox(height: ZaveSpace.lg),
      Wrap(
        spacing: ZaveSpace.sm,
        runSpacing: ZaveSpace.sm,
        children: <Widget>[
          for (final HeadshotBackground bg in HeadshotBackground.values)
            ZaveChip(
              label: bg.label,
              selected: session.background == bg,
              onTap: () => controller.chooseBackground(bg),
            ),
        ],
      ),

      SizedBox(height: ZaveSpace.xl),
      const XpCostRow(
        cost: '1200 XP will be deducted',
        detail:
            'Four portraits, generated together. If any of the four fails the '
            'whole run is refused and no XP is spent.',
      ),

      if (!session.canGenerate) ...<Widget>[
        SizedBox(height: ZaveSpace.lg),
        const AiToolNoteRow(
          title: 'Nothing to generate from',
          message:
              'Generating needs at least three reference photos, and this '
              'build cannot reach your camera roll. The button stays off '
              'rather than spending a request that would be refused.',
        ),
      ],

      SizedBox(height: ZaveSpace.lg),
      ZaveButton(
        label: 'Generate headshots',
        kind: ZaveButtonKind.primary,
        expand: true,
        busy: session.generating,
        onPressed: session.canGenerate ? controller.generate : null,
      ),
      SizedBox(height: ZaveSpace.md),
      ZaveButton(
        label: 'Back',
        icon: const Icon(Icons.arrow_back),
        expand: true,
        onPressed: () => controller.goTo(HeadshotStep.upload),
      ),
    ],
  );
}

/// One look. Selected takes the `now` fill step rather than a tinted border —
/// depth in this system is the fill, and a card is not a pill, so it does not
/// invert to white the way a chip does.
class _StyleCard extends StatelessWidget {
  const _StyleCard({
    required this.style,
    required this.selected,
    required this.onTap,
  });

  final HeadshotStyle style;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => ZaveCard(
    size: ZaveCardSize.small,
    isNow: selected,
    onTap: onTap,
    child: Row(
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(style.label, style: ZaveType.h3),
              SizedBox(height: ZaveSpace.xs),
              Text(style.description, style: ZaveType.caption),
            ],
          ),
        ),
        if (selected) ...<Widget>[
          SizedBox(width: ZaveSpace.md),
          const ZaveDot(ZaveColors.green),
        ],
      ],
    ),
  );
}

/// Step 3 — waiting.
///
/// The web animates a 128px ring here. This is a plain indicator on a card:
/// the wait is a minute or two, and a large bespoke animation running that
/// long is exactly the kind of motion Zave's rule exists to prevent.
class _GeneratingStep extends StatelessWidget {
  const _GeneratingStep();

  @override
  Widget build(BuildContext context) => ZaveCard(
    size: ZaveCardSize.large,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            SizedBox(
              height: ZaveSpace.xl,
              width: ZaveSpace.xl,
              child: const CircularProgressIndicator(
                strokeWidth: 2,
                color: ZaveColors.white,
              ),
            ),
            SizedBox(width: ZaveSpace.md),
            Expanded(child: Text('Creating your persona', style: ZaveType.h3)),
          ],
        ),
        SizedBox(height: ZaveSpace.lg),
        Text(
          'Your photos are being read and four portraits drawn from them. '
          'This usually takes one to two minutes.',
          style: ZaveType.bodyMuted,
        ),
      ],
    ),
  );
}

/// Step 4 — the four portraits.
class _ResultsStep extends StatelessWidget {
  const _ResultsStep({required this.session, required this.controller});

  final HeadshotSession session;
  final HeadshotsController controller;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Row(
        children: <Widget>[
          const ZaveDot(ZaveColors.green),
          SizedBox(width: ZaveSpace.sm),
          Text(
            'READY',
            style: ZaveType.kicker.copyWith(color: ZaveColors.green),
          ),
        ],
      ),
      SizedBox(height: ZaveSpace.md),
      Text('Your headshots are ready', style: ZaveType.h2),
      SizedBox(height: ZaveSpace.xl),

      for (int i = 0; i < session.results.length; i++) ...<Widget>[
        ZaveCard(
          child: ClipRRect(
            borderRadius: ZaveRadius.cardSmBr,
            // 4:5 — LinkedIn's portrait crop, the same ratio the web uses.
            child: AiToolImage(source: session.results[i], aspectRatio: 4 / 5),
          ),
        ),
        SizedBox(height: ZaveSpace.sm),
        Align(
          alignment: Alignment.centerLeft,
          child: _SaveHeadshot(url: session.results[i], index: i),
        ),
        SizedBox(height: ZaveSpace.md),
      ],

      SizedBox(height: ZaveSpace.md),
      Text(
        'Save one, then set it as your LinkedIn profile picture.',
        style: ZaveType.caption,
      ),

      SizedBox(height: ZaveSpace.lg),
      ZaveButton(
        label: session.finished ? 'Step complete' : 'Finish step',
        kind: ZaveButtonKind.primary,
        expand: true,
        busy: session.finishing,
        onPressed: session.finished ? null : controller.finishStep,
      ),
      SizedBox(height: ZaveSpace.md),
      ZaveButton(
        label: 'Generate new',
        icon: const Icon(Icons.refresh),
        expand: true,
        onPressed: controller.restart,
      ),
    ],
  );
}


/// Runs the picker and reports only what is worth reporting.
///
/// A cancelled picker says nothing — the user closed it on purpose. This
/// screen previously carried a note claiming the build shipped no photo
/// picker, which stopped being true when `image_picker` landed for the
/// composer; the note outlived the limitation and told users something false
/// about their own app.
Future<void> _pick(
  BuildContext context,
  HeadshotsController controller,
  ImageSourceKind source,
) async {
  final String? message = await controller.pickPhoto(source);
  if (message == null || !context.mounted) return;
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message, style: ZaveType.body)));
}


/// Saves one generated headshot.
///
/// This screen used to say saving "needs a package this build does not
/// ship" — true when written, and false since `share_plus` landed for the
/// banner mission. iOS's sheet carries "Save Image", so the portrait reaches
/// the camera roll without a photo-library write permission.
class _SaveHeadshot extends ConsumerStatefulWidget {
  const _SaveHeadshot({required this.url, required this.index});

  final String url;
  final int index;

  @override
  ConsumerState<_SaveHeadshot> createState() => _SaveHeadshotState();
}

class _SaveHeadshotState extends ConsumerState<_SaveHeadshot> {
  bool _busy = false;

  Future<void> _save() async {
    setState(() => _busy = true);
    try {
      final ShareResult result = await ref
          .read(imageSharingProvider)
          .shareImageUrl(
            url: widget.url,
            fileName: 'plexaverse-headshot-${widget.index + 1}.png',
          );
      if (!mounted) return;
      // A dismissed sheet says nothing — the user closed it on purpose.
      final String? note = switch (result) {
        ShareSucceeded() => 'Saved.',
        ShareDismissed() => null,
        ShareFailed(:final String? message) =>
          message ?? "Couldn't save that one. Try again.",
      };
      if (note == null) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(note, style: ZaveType.body)));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => ZaveButton(
    label: 'Save',
    icon: const Icon(Icons.ios_share),
    busy: _busy,
    onPressed: _busy ? null : _save,
  );
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/ui/widgets/open_link.dart';
import '../../../../core/ui/zave/zave_kit.dart';
import '../../application/compose_controller.dart';
import '../../domain/compose_context.dart';
import '../../domain/compose_draft.dart';
import '../../domain/compose_status.dart';
import '../widgets/ai_generate_sheet.dart';
import '../widgets/attached_image_card.dart';
import '../widgets/linkedin_connection_panel.dart';
import '../widgets/linkedin_preview_card.dart';
import '../widgets/post_optimizer_card.dart';
import '../widgets/schedule_panel.dart';
import '../../../../core/platform/image_picking.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/zave_routes.dart';

/// **Write** — the composer. The web's `/create` and `/company-post`.
///
/// ## Why this is one screen and not two
///
/// The web has two routes and two nav items, both labelled "Write", and both
/// of them render the same `PostEditor`. The difference between them is not the
/// editor — it is `UserPreferences.brandType`, which `PostEditor` reads for
/// itself. So the honest port is one screen that branches on the same flag,
/// reached from whichever route the user's brand puts in their nav. Building
/// two pages would duplicate every control in order to express a difference
/// that lives in one boolean.
///
/// ## The web's two columns
///
/// `PostEditor` lays the editor and the LinkedIn preview side by side at `lg`
/// and up, and below that collapses to one column with an "Editor | Preview"
/// segmented control. A phone always renders the second form — so the toggle
/// here is the web's own mobile behaviour, not a mobile-specific invention.
///
/// ## What is not here, and why
///
/// • **The roadmap-quest shell.** `/create` wraps the editor in a quest header
///   (step title, "Day n", "+xp XP", a consistency meter) driven by
///   `getBaseRoadmap()` and credited through `useUpdateRoadmapProgress`. That
///   belongs to the roadmap surface, not the composer, and the mobile API's
///   `/roadmap/progress` is owned by the home slice. Wiring it from here would
///   put two owners on the same progress row.
/// • **The design-template gallery.** `GET /studio/templates` exists on mobile
///   but `POST /studio/customize` does not, so the gallery could be listed and
///   never applied.
/// • **Poll mode.** Present in the web source and unreachable from its UI —
///   the mode switcher is commented out. Porting a control the web has
///   deliberately hidden would make mobile the only place it exists.
class ComposePage extends ConsumerStatefulWidget {
  const ComposePage({this.onOpenSettings, super.key});

  /// Routes to settings, where LinkedIn is connected. Supplied by the shell,
  /// which owns the router; null simply hides the shortcut and leaves the
  /// instruction text, which still tells the user where to go.
  final VoidCallback? onOpenSettings;

  @override
  ConsumerState<ComposePage> createState() => _ComposePageState();
}

class _ComposePageState extends ConsumerState<ComposePage> {
  final TextEditingController _title = TextEditingController();
  final TextEditingController _body = TextEditingController();

  bool _showPreview = false;

  @override
  void dispose() {
    _title.dispose();
    _body.dispose();
    super.dispose();
  }

  /// Pushes draft text into the fields when something OTHER than typing
  /// changed it — an AI generation, or the reset after a successful save.
  ///
  /// The equality check is what makes this safe: when the user types, the
  /// controller already holds the new text and the draft is set to the same
  /// string, so nothing is written back and the caret does not jump to the end
  /// mid-sentence.
  void _syncFields(ComposeDraft draft) {
    if (_title.text != draft.title) _title.text = draft.title;
    if (_body.text != draft.content) _body.text = draft.content;
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<ComposeDraft>(
      composeDraftControllerProvider,
      (ComposeDraft? _, ComposeDraft next) => _syncFields(next),
    );

    final AsyncValue<ComposeContextState> brandAsync = ref.watch(
      composeContextControllerProvider,
    );
    final ComposeDraft draft = ref.watch(composeDraftControllerProvider);
    final ComposeStatus status = ref.watch(composeActionsProvider);
    final ComposeContextState? brand = brandAsync.value;
    final bool isCompany = brand?.isCompanyBrand ?? false;

    return ZaveScaffold(
      title: 'Write',
      leading: Navigator.of(context).canPop()
          ? ZaveIconButton(
              icon: const Icon(Icons.arrow_back),
              tooltip: 'Back',
              onPressed: () => Navigator.of(context).maybePop(),
            )
          : null,
      body: ZaveScrollView(
        children: <Widget>[
          if (isCompany) ...<Widget>[
            const ZavePill(label: 'Company brand', color: ZaveColors.mint),
            SizedBox(height: ZaveSpace.lg),
          ],

          if (status.outcome != null) ...<Widget>[
            _OutcomeCard(status: status),
            SizedBox(height: ZaveSpace.lg),
          ],

          if (status.error != null || status.insufficientXp) ...<Widget>[
            _ProblemCard(status: status),
            SizedBox(height: ZaveSpace.lg),
          ],

          // The AI sheet reports its own progress, but it can be dismissed
          // mid-generation — and the work keeps going, because it belongs to
          // the controller rather than to the sheet. Without this the user
          // would come back to a screen that looked idle while a poster was
          // still being composited.
          if (status.isGenerating) ...<Widget>[
            _ProgressCard(message: status.progress ?? 'Working…'),
            SizedBox(height: ZaveSpace.lg),
          ],

          brandAsync.when(
            loading: () => const _PanelSkeleton(height: 108),
            error: (Object e, StackTrace _) => _ContextError(
              onRetry: () => ref.invalidate(composeContextControllerProvider),
            ),
            data: (ComposeContextState state) => LinkedInConnectionPanel(
              state: state,
              selectedAccountId: draft.accountId,
              onSelectAccount: ref
                  .read(composeDraftControllerProvider.notifier)
                  .setAccount,
              onOpenSettings: widget.onOpenSettings,
            ),
          ),

          SizedBox(height: ZaveSpace.xl),
          _ModeTabs(
            showPreview: _showPreview,
            onChanged: (bool value) => setState(() => _showPreview = value),
          ),
          SizedBox(height: ZaveSpace.xl),

          if (_showPreview)
            _Preview(draft: draft, brand: brand)
          else
            ..._editor(draft, status, brand, isCompany),
        ],
      ),
    );
  }

  List<Widget> _editor(
    ComposeDraft draft,
    ComposeStatus status,
    ComposeContextState? brand,
    bool isCompany,
  ) {
    final ComposeDraftController drafts = ref.read(
      composeDraftControllerProvider.notifier,
    );
    final ComposeActions actions = ref.read(composeActionsProvider.notifier);

    return <Widget>[
      // The web makes this a second solid-white `.zv-cta`, giving the screen
      // two primary buttons. Zave allows one, and it has to be the action that
      // commits the post — so generation is a ghost here. It keeps its full
      // width and its place at the top, which is what actually makes it the
      // first thing a user reaches for.
      ZaveButton(
        label: 'Write this post with AI',
        icon: const Icon(Icons.auto_awesome_outlined),
        expand: true,
        onPressed: status.isBusy ? null : () => AiGenerateSheet.show(context),
      ),

      SizedBox(height: ZaveSpace.xl),
      ZaveField(
        controller: _title,
        label: 'Title',
        hint: 'Post title (optional)',
        onChanged: (String value) {
          actions.clearFeedback();
          drafts.setTitle(value);
        },
      ),

      SizedBox(height: ZaveSpace.xl),
      ZaveField(
        controller: _body,
        label: 'Post content',
        hint: 'What would you like to share on LinkedIn?',
        minLines: 8,
        maxLines: 14,
        maxLength: ComposeDraft.charLimit,
        keyboardType: TextInputType.multiline,
        textInputAction: TextInputAction.newline,
        onChanged: (String value) {
          actions.clearFeedback();
          drafts.setContent(value);
        },
      ),
      SizedBox(height: ZaveSpace.md),
      Row(
        children: <Widget>[
          ZaveIconButton(
            icon: const Icon(Icons.image_outlined),
            tooltip: 'Attach an image',
            onPressed: () => _attach(context, ref),
          ),
          const Spacer(),
          Text(
            '${draft.charCount}/${ComposeDraft.charLimit}',
            style: ZaveType.caption.copyWith(
              // The web turns this yellow past 90% of the limit. Amber is the
              // Zave signal for "getting close"; there is no red in this
              // system and this is not an error anyway.
              color: draft.nearLimit ? ZaveColors.amber : ZaveColors.ink35,
            ),
          ),
        ],
      ),

      if (draft.image != null) ...<Widget>[
        SizedBox(height: ZaveSpace.xl),
        AttachedImageCard(
          image: draft.image!,
          regenerating: status.busy == ComposeBusy.designing,
          onRemove: drafts.removeImage,
          onRegenerate: draft.lastPosterPrompt == null
              ? null
              : actions.regeneratePoster,
        ),
      ],

      SizedBox(height: ZaveSpace.xl),
      SchedulePanel(
        draft: draft,
        onToggle: drafts.setScheduled,
        onPickDate: drafts.setDate,
        onPickTime: drafts.setTime,
      ),

      SizedBox(height: ZaveSpace.xl),
      PostOptimizerCard(content: draft.content),

      SizedBox(height: ZaveSpace.xl),
      ZaveButton(
        label: 'Save as draft',
        icon: const Icon(Icons.bookmark_border),
        expand: true,
        onPressed: draft.canSubmit && !status.isBusy ? actions.saveDraft : null,
        busy: status.isSubmitting && status.intent == ComposeOutcome.draftSaved,
      ),
      SizedBox(height: ZaveSpace.md),
      ZaveButton.primary(
        // One action, two labels — exactly as on the web, where the presence of
        // a schedule changes the wording but not the wire status.
        label: draft.scheduled ? 'Schedule post' : 'Submit for approval',
        icon: Icon(
          draft.scheduled ? Icons.event_outlined : Icons.send_outlined,
        ),
        expand: true,
        onPressed: draft.canSubmit && !status.isBusy
            ? actions.submitForApproval
            : null,
        busy:
            status.isSubmitting &&
            (status.intent == ComposeOutcome.submitted ||
                status.intent == ComposeOutcome.scheduled),
      ),

      if (isCompany) ...<Widget>[
        SizedBox(height: ZaveSpace.md),
        ZaveButton(
          label: 'Publish now to ${brand?.companyPageLabel ?? 'the page'}',
          icon: const Icon(Icons.rocket_launch_outlined),
          expand: true,
          onPressed:
              draft.canSubmit &&
                  !status.isBusy &&
                  (brand?.companyAccount != null)
              ? actions.publishToCompanyPage
              : null,
          busy:
              (status.isSubmitting || status.busy == ComposeBusy.publishing) &&
              status.intent == ComposeOutcome.published,
        ),
      ],
    ];
  }
}

/// "Editor | Preview".
///
/// The web renders this as a segmented control whose active half is
/// `bg-white/10`. Zave's selection language is stronger and singular —
/// **selected inverts to solid white with ink letters** — so these are chips.
/// Using the web's tint here would be the one place in the app where "selected"
/// looked like something else.
class _ModeTabs extends StatelessWidget {
  const _ModeTabs({required this.showPreview, required this.onChanged});

  final bool showPreview;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        ZaveChip(
          label: 'Editor',
          selected: !showPreview,
          onTap: () => onChanged(false),
        ),
        SizedBox(width: ZaveSpace.sm),
        ZaveChip(
          label: 'Preview',
          selected: showPreview,
          onTap: () => onChanged(true),
        ),
      ],
    );
  }
}

/// The LinkedIn preview, framed.
///
/// The frame is Zave (kicker, radius, gutter); everything inside it is
/// LinkedIn's own chrome. Clipped to the Zave card radius so a foreign white
/// surface never bleeds past the corner of a Plexaverse container.
class _Preview extends StatelessWidget {
  const _Preview({required this.draft, required this.brand});

  final ComposeDraft draft;
  final ComposeContextState? brand;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('LINKEDIN PREVIEW', style: ZaveType.kicker),
        SizedBox(height: ZaveSpace.md),
        ClipRRect(
          borderRadius: ZaveRadius.cardBr,
          child: LinkedInPreviewCard(draft: draft, brandContext: brand),
        ),
      ],
    );
  }
}

/// "Saved as draft" / "Submitted for approval" / "Scheduled" / "Published".
///
/// The web shows a toast and then redirects to `/posts` after 1500 ms. This
/// slice does not navigate: the posts route belongs to the shell, and a screen
/// that pushes a route it does not own is how two agents end up disagreeing
/// about the back stack. The card states the outcome and the user decides.
class _OutcomeCard extends ConsumerWidget {
  const _OutcomeCard({required this.status});

  final ComposeStatus status;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (String kicker, String line) copy = switch (status.outcome) {
      ComposeOutcome.draftSaved => (
        'SAVED',
        'Saved as a draft. You can finish it from Posts.',
      ),
      ComposeOutcome.submitted => (
        'SUBMITTED',
        'Submitted for approval. It goes out once approved.',
      ),
      ComposeOutcome.scheduled => (
        'SCHEDULED',
        'Scheduled. It goes out at the time you picked.',
      ),
      ComposeOutcome.published => (
        'PUBLISHED',
        'Live on your company page now.',
      ),
      null => ('DONE', 'Done.'),
    };

    return ZaveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              const ZaveDot(ZaveColors.green),
              SizedBox(width: ZaveSpace.sm),
              Text(copy.$1, style: ZaveType.kicker),
            ],
          ),
          SizedBox(height: ZaveSpace.md),
          Text(copy.$2, style: ZaveType.body),
          if (status.publishedUrl != null) ...<Widget>[
            SizedBox(height: ZaveSpace.md),
            // Was the URL printed as caption text: a LinkedIn link the user
            // could read and not act on. Every other publish path in the
            // product opens the post it just made — the web does it from both
            // the posts list and the post detail page — and this is the only
            // place a company post's URL ever appears.
            ZaveButton(
              label: 'View on LinkedIn',
              icon: const Icon(Icons.open_in_new_rounded),
              expand: true,
              onPressed: () =>
                  openLinkAndReport(context, ref, status.publishedUrl!),
            ),
          ],
        ],
      ),
    );
  }
}

/// "Generating post content…" / "Designing your poster…", on the page itself.
class _ProgressCard extends StatelessWidget {
  const _ProgressCard({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return ZaveCard(
      child: Row(
        children: <Widget>[
          const SizedBox(
            height: 16,
            width: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: ZaveColors.white,
            ),
          ),
          SizedBox(width: ZaveSpace.md),
          Expanded(child: Text(message, style: ZaveType.bodyMuted)),
        ],
      ),
    );
  }
}

/// Something went wrong, or the user is out of XP.
///
/// Amber in both cases. Zave has no red, and neither of these is destructive:
/// one is "try again", the other is "top up first".
class _ProblemCard extends StatelessWidget {
  const _ProblemCard({required this.status});

  final ComposeStatus status;

  @override
  Widget build(BuildContext context) {
    return ZaveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              const ZaveDot(ZaveColors.amber),
              SizedBox(width: ZaveSpace.sm),
              Text(
                status.insufficientXp ? 'NOT ENOUGH XP' : 'DID NOT GO THROUGH',
                style: ZaveType.kicker,
              ),
            ],
          ),
          SizedBox(height: ZaveSpace.md),
          Text(
            status.insufficientXp
                ? "You don't have enough XP to generate."
                : status.error!,
            style: ZaveType.body,
          ),
          // Only the XP case gets a CTA. "Did not go through" is a retry the
          // user makes with the button they already pressed; sending them to
          // Pricing for it would be wrong.
          if (status.insufficientXp) ...<Widget>[
            SizedBox(height: ZaveSpace.md),
            Align(
              alignment: Alignment.centerLeft,
              child: ZaveButton(
                label: 'Top up XP',
                onPressed: () => context.push(ZaveRoutes.pricing),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// The rest-fill block shown while the accounts call is in flight. A fill step
/// rather than a spinner — Zave builds depth out of fills, and the panel is
/// already the right size.
class _PanelSkeleton extends StatelessWidget {
  const _PanelSkeleton({required this.height});

  final double height;

  @override
  Widget build(BuildContext context) =>
      Container(height: height, decoration: ZaveSurface.card);
}

/// The accounts / preferences call failed. The editor below still works —
/// a draft can be saved without knowing which account will publish it.
class _ContextError extends StatelessWidget {
  const _ContextError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return ZaveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              // Amber, not red — see the note in _ProblemCard.
              const ZaveDot(ZaveColors.amber),
              SizedBox(width: ZaveSpace.sm),
              Text('COULD NOT LOAD', style: ZaveType.kicker),
            ],
          ),
          SizedBox(height: ZaveSpace.md),
          Text(
            "We couldn't check your LinkedIn connection. You can still write "
            'and save a draft.',
            style: ZaveType.bodyMuted,
          ),
          SizedBox(height: ZaveSpace.lg),
          ZaveButton(label: 'Try again', onPressed: onRetry),
        ],
      ),
    );
  }
}

/// Asks where the photo should come from, then attaches it.
///
/// A sheet rather than going straight to the gallery: the camera is the right
/// answer for a headshot or a whiteboard, and guessing wrong costs the user a
/// dismissed picker.
Future<void> _attach(BuildContext context, WidgetRef ref) async {
  final ImageSourceKind? source = await showModalBottomSheet<ImageSourceKind>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (BuildContext ctx) => Container(
      decoration: BoxDecoration(
        gradient: ZaveGround.base,
        border: const Border(
          top: BorderSide(color: ZaveGlass.headerBorder, width: 1),
        ),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(ZaveRadius.cardLg),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.all(ZaveSpace.gutter),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text('ADD AN IMAGE', style: ZaveType.kicker),
              SizedBox(height: ZaveSpace.lg),
              ZaveButton(
                label: 'Choose a photo',
                icon: const Icon(Icons.photo_library_outlined),
                expand: true,
                onPressed: () => Navigator.of(ctx).pop(ImageSourceKind.gallery),
              ),
              SizedBox(height: ZaveSpace.md),
              ZaveButton(
                label: 'Take a photo',
                icon: const Icon(Icons.photo_camera_outlined),
                expand: true,
                onPressed: () => Navigator.of(ctx).pop(ImageSourceKind.camera),
              ),
            ],
          ),
        ),
      ),
    ),
  );

  if (source == null) return;
  final String? error = await ref
      .read(composeDraftControllerProvider.notifier)
      .pickImage(source);

  if (error != null && context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/plan/plan_limit_sheet.dart';
import '../../../../core/platform/image_picking.dart';
import '../../../../core/ui/app_icons.dart';
import '../../../../core/ui/widgets/open_link.dart';
import '../../../../core/ui/zave/zave_kit.dart';
import '../../../../core/week/week_shape.dart' show PostRole;
import '../../../posts/application/post_library_controllers.dart'
    show postDetailProvider;
import '../../../posts/domain/library_post.dart';
import '../../application/planner_controller.dart';
import '../../domain/plan_slot.dart';
import '../../domain/planner_repository.dart';
import '../../domain/post_formats.dart';
import 'slot_card.dart' show roleAccent;

/// The playbook week's parts of a day's sheet (PLANNER_REDESIGN.md §3):
/// what the day is FOR, the review with "Fix with AI", the image step by the
/// format's image kind, and the week's news picker. The web's `FormatInfo`,
/// `ReviewStatus`, `SlotImageStep` and `NewsPicker`.
///
/// Each reads its day from [plannerControllerProvider] by index, as the
/// sheet does, so a refine or a new image lands here without a reopen.

/// Runs a playbook action. Its outcome (or failure) is written by the
/// controller to [plannerNotesProvider]; the only thing left to the widget is
/// the plan sheet for a plan refusal, which needs a context.
Future<void> _runAction(
  BuildContext context,
  Future<Object?> Function() action,
) async {
  try {
    await action();
  } on PlannerActionFailure catch (e) {
    final refusal = e.refusal;
    if (refusal != null && context.mounted) {
      await PlanLimitSheet.show(context, refusal);
    }
  } on Object {
    // Already said on the day's note.
  }
}

/// The day's latest note for [work], drawn under the action that wrote it.
class _Note extends ConsumerWidget {
  const _Note({required this.slotIndex, required this.work});

  final int slotIndex;
  final SlotWork work;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final PlannerNote? note = ref.watch(
      plannerNotesProvider.select(
        (Map<String, PlannerNote> m) => m[PlannerNotes.keyOf(slotIndex, work)],
      ),
    );
    if (note == null) return const SizedBox.shrink();
    return Padding(
      padding: EdgeInsets.only(top: ZaveSpace.sm),
      child: Text(
        note.text,
        style: ZaveType.caption.copyWith(
          color: note.isError ? ZaveColors.amber : ZaveColors.green,
        ),
      ),
    );
  }
}

// ─── What the day is ─────────────────────────────────────────────────────────

/// "TEACH · Numbered steps — Something worth saving", and the format's one
/// line. Shown on a playbook day only.
class SlotFormatBlock extends StatelessWidget {
  const SlotFormatBlock({required this.slot, super.key});

  final PlanSlot slot;

  @override
  Widget build(BuildContext context) {
    final PostFormatInfo? format = slot.formatSpec;
    final PostRole? role = slot.role;
    if (format == null) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Wrap(
          spacing: ZaveSpace.sm,
          runSpacing: ZaveSpace.sm,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: <Widget>[
            if (role != null)
              ZavePill(label: role.label, color: roleAccent(role)),
            ZavePill(label: format.name, color: ZaveColors.ink62),
            if (slot.imageKind case final ImageKind k)
              ZavePill(label: k.label, color: ZaveColors.ink62),
          ],
        ),
        SizedBox(height: ZaveSpace.sm),
        Text(
          role == null ? format.oneLine : '${rolePurpose(role)}. ${format.oneLine}',
          style: ZaveType.bodyMuted,
        ),
        if (slot.formatFellBack && role == PostRole.story) ...<Widget>[
          SizedBox(height: ZaveSpace.sm),
          Text(
            'Add a real story to unlock story posts.',
            style: ZaveType.caption,
          ),
        ],
      ],
    );
  }
}

// ─── The review ──────────────────────────────────────────────────────────────

/// The playbook review the server stored, and "Fix with AI".
///
/// The app does not run the review itself (it is the server's pure
/// `reviewPost`); it shows the stored verdict, which the server rewrites on
/// every generation, refine and edit. A post that still breaks a rule is
/// held, never auto-published — said here so a held post is not a surprise.
class SlotReviewPanel extends ConsumerWidget {
  const SlotReviewPanel({required this.slotIndex, super.key});

  final int slotIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final PlanSlot? slot = ref
        .watch(plannerControllerProvider)
        .value
        ?.plan
        ?.posts
        .elementAtOrNull(slotIndex);
    final String? postId = slot?.postId;
    if (slot == null || postId == null || postId.isEmpty) {
      return const SizedBox.shrink();
    }
    final SlotReview? review = slot.review;
    if (review == null) return const SizedBox.shrink();

    // The user's own edits are advice, not a hold: the publish gate passes an
    // edited playbook post as written (PLANNER_REDESIGN.md §0.4).
    final bool edited = ref.watch(
      postDetailProvider(
        postId,
      ).select((AsyncValue<LibraryPost> p) => p.value?.contentEdited == true),
    );
    final Set<SlotWork> working =
        ref.watch(plannerBusyProvider)[slotIndex] ?? const <SlotWork>{};
    final bool fixing = working.contains(SlotWork.refine);
    // Not while the post is being rewritten: it is about to be replaced.
    final bool rewriting =
        working.contains(SlotWork.writing) ||
        slot.status == SlotStatus.generating;
    final bool canFix = slot.status != SlotStatus.published && !rewriting;
    final int n = review.errors.length;
    final bool ok = review.ok && n == 0;

    return ZaveCard(
      size: ZaveCardSize.small,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              ZaveDot(
                ok
                    ? ZaveColors.green
                    : edited
                    ? ZaveColors.ink62
                    : ZaveColors.amber,
              ),
              SizedBox(width: ZaveSpace.sm),
              Expanded(
                child: Text(
                  ok
                      ? 'Passes the playbook review'
                            '${review.refined ? ' — tidied up by Plexa' : ''}'
                      : edited
                      ? '$n suggestion${n == 1 ? '' : 's'}'
                      : '$n fix${n == 1 ? '' : 'es'} before this can publish',
                  style: ZaveType.label.copyWith(
                    color: ok
                        ? ZaveColors.green
                        : edited
                        ? ZaveColors.ink62
                        : ZaveColors.amber,
                  ),
                ),
              ),
            ],
          ),
          if (!ok) ...<Widget>[
            SizedBox(height: ZaveSpace.sm),
            for (final String e in review.errors)
              Padding(
                padding: EdgeInsets.only(bottom: ZaveSpace.xs),
                child: Text('• $e', style: ZaveType.body),
              ),
            Text(
              edited
                  ? 'You edited this post, so it publishes as you wrote it.'
                  : 'A post that still breaks a rule is held, not published.',
              style: ZaveType.caption,
            ),
          ],
          // Warnings only on a passing review, as the web shows them: beside
          // a failing one they read as a second, contradicting count.
          if (ok && review.warnings.isNotEmpty) ...<Widget>[
            SizedBox(height: ZaveSpace.sm),
            Text(
              '${review.warnings.length} suggestion'
              '${review.warnings.length == 1 ? '' : 's'}',
              style: ZaveType.kicker,
            ),
            SizedBox(height: ZaveSpace.xs),
            for (final String w in review.warnings)
              Padding(
                padding: EdgeInsets.only(bottom: ZaveSpace.xs),
                child: Text('• $w', style: ZaveType.bodyMuted),
              ),
          ],
          if (!ok && canFix) ...<Widget>[
            SizedBox(height: ZaveSpace.md),
            ZaveButton(
              label: fixing ? 'Fixing…' : 'Fix with AI',
              expand: true,
              busy: fixing,
              onPressed: fixing
                  ? null
                  : () => _runAction(
                      context,
                      () => ref
                          .read(plannerControllerProvider.notifier)
                          .refine(slotIndex),
                    ),
            ),
            if (edited)
              Padding(
                padding: EdgeInsets.only(top: ZaveSpace.sm),
                child: Text(
                  'Fix with AI rewrites the whole post, your edits too.',
                  style: ZaveType.caption,
                ),
              ),
          ],
          _Note(slotIndex: slotIndex, work: SlotWork.refine),
        ],
      ),
    );
  }
}

// ─── The image step ──────────────────────────────────────────────────────────

/// The day's image, made the way its format wants (`imageKind`):
///
///   photo                the format's photo guide → upload a photo → either
///                        OpenAI makes a portrait from it (needs the tick:
///                        `photo_reference` consent) or it is used as it is
///   quote_card/text_card a card printed from the post — no model
///   ai_poster            the AI poster
///
/// The photo is kept privately on the server; this widget only ever holds
/// the 10-minute preview link of a photo uploaded this session.
class SlotImageStep extends ConsumerStatefulWidget {
  const SlotImageStep({required this.slotIndex, super.key});

  final int slotIndex;

  @override
  ConsumerState<SlotImageStep> createState() => _SlotImageStepState();
}

class _SlotImageStepState extends ConsumerState<SlotImageStep> {
  /// The user's tick on "send this photo to OpenAI". Never sent unasked.
  bool _consent = false;

  Future<void> _pick(ImageSourceKind source) async {
    final PlannerNotes notes = ref.read(plannerNotesProvider.notifier);
    notes.clear(widget.slotIndex, SlotWork.photo);
    final ImagePickResult picked = await ref
        .read(imagePickingProvider)
        .pick(source);
    switch (picked) {
      case ImagePickCancelled():
        return;
      case ImagePickFailure(:final String? message):
        notes.say(
          widget.slotIndex,
          SlotWork.photo,
          message ?? 'Could not open your photos.',
          isError: true,
        );
        return;
      case PickedImage():
        if (!mounted) return;
        await _runAction(
          context,
          () => ref
              .read(plannerControllerProvider.notifier)
              .uploadPhoto(widget.slotIndex, picked),
        );
    }
  }

  Future<void> _make(SlotImageMode mode) async {
    if (mode == SlotImageMode.reference && !_consent) {
      ref
          .read(plannerNotesProvider.notifier)
          .say(
            widget.slotIndex,
            SlotWork.image,
            'Tick the box to send your photo to OpenAI first.',
            isError: true,
          );
      return;
    }
    await _runAction(
      context,
      () => ref
          .read(plannerControllerProvider.notifier)
          .makeImage(
            widget.slotIndex,
            mode,
            consent: mode == SlotImageMode.reference && _consent,
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final PlanSlot? slot = ref
        .watch(plannerControllerProvider)
        .value
        ?.plan
        ?.posts
        .elementAtOrNull(widget.slotIndex);
    final ImageKind? kind = slot?.imageKind;
    if (slot == null || kind == null) return const SizedBox.shrink();

    final Set<SlotWork> working =
        ref.watch(plannerBusyProvider)[widget.slotIndex] ?? const <SlotWork>{};
    final bool uploading = working.contains(SlotWork.photo);
    final bool making = working.contains(SlotWork.image);
    // Also while the post is being (re)written: its image is made right
    // after, and a second one started now would be paid for twice.
    final bool busy =
        uploading ||
        making ||
        working.contains(SlotWork.writing) ||
        slot.status == SlotStatus.generating;
    final bool hasImage =
        (slot.fullImageUrl ?? slot.previewImageUrl ?? '').isNotEmpty;
    final String? previewUrl = ref.watch(
      plannerPhotoPreviewsProvider.select(
        (Map<int, String> m) => m[widget.slotIndex],
      ),
    );
    final bool published = slot.status == SlotStatus.published;

    final List<Widget> body = <Widget>[];
    switch (kind) {
      case ImageKind.photo:
        final bool hasPhoto = slot.hasReferencePhoto || previewUrl != null;
        body.addAll(<Widget>[
          Text(photoAsk(slot.formatSpec?.photoGuide), style: ZaveType.body),
          SizedBox(height: ZaveSpace.md),
          if (previewUrl case final String url)
            Padding(
              padding: EdgeInsets.only(bottom: ZaveSpace.md),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(ZaveRadius.cardSm),
                child: SizedBox(
                  height: 160,
                  child: AspectRatio(
                    aspectRatio: 4 / 5,
                    child: ZaveImage(source: url, tone: ZaveImageTone.quiet),
                  ),
                ),
              ),
            )
          else if (slot.hasReferencePhoto)
            Padding(
              padding: EdgeInsets.only(bottom: ZaveSpace.md),
              child: Text(
                'Your photo is added. We keep the original for 30 days.',
                style: ZaveType.caption,
              ),
            ),
          if (!published)
            Row(
              children: <Widget>[
                Expanded(
                  child: ZaveButton(
                    label: uploading
                        ? 'Uploading…'
                        : hasPhoto
                        ? 'Change photo'
                        : 'Upload a photo',
                    busy: uploading,
                    onPressed: busy
                        ? null
                        : () => _pick(ImageSourceKind.gallery),
                  ),
                ),
                SizedBox(width: ZaveSpace.sm),
                ZaveButton(
                  label: 'Camera',
                  onPressed: busy ? null : () => _pick(ImageSourceKind.camera),
                ),
              ],
            ),
          if (hasPhoto && slot.hasPost && !published) ...<Widget>[
            SizedBox(height: ZaveSpace.md),
            TickBox(
              checked: _consent,
              title: 'Send my photo to OpenAI',
              body: photoConsentText,
              onChanged: busy ? null : (bool v) => setState(() => _consent = v),
            ),
            SizedBox(height: ZaveSpace.md),
            ZaveButton.primary(
              label: 'Create image from my photo',
              expand: true,
              busy: making,
              onPressed: busy ? null : () => _make(SlotImageMode.reference),
            ),
            SizedBox(height: ZaveSpace.sm),
            ZaveButton(
              label: 'Use my photo as it is',
              expand: true,
              onPressed: busy ? null : () => _make(SlotImageMode.asIs),
            ),
          ],
        ]);
      case ImageKind.textCard:
      case ImageKind.quoteCard:
        body.addAll(<Widget>[
          Text(
            '${kind == ImageKind.quoteCard ? 'The post’s quote' : 'The post’s key line'}, '
            'printed on a clean card. No AI image involved.',
            style: ZaveType.bodyMuted,
          ),
          if (slot.hasPost && !published) ...<Widget>[
            SizedBox(height: ZaveSpace.md),
            ZaveButton(
              label: hasImage ? 'Create the card again' : 'Create card',
              expand: true,
              busy: making,
              onPressed: busy ? null : () => _make(SlotImageMode.card),
            ),
          ],
        ]);
      case ImageKind.aiPoster:
        body.addAll(<Widget>[
          Text(
            'An AI poster made from the post.',
            style: ZaveType.bodyMuted,
          ),
          if (slot.hasPost && !published) ...<Widget>[
            SizedBox(height: ZaveSpace.md),
            ZaveButton(
              label: hasImage ? 'Create a new poster' : 'Create poster',
              expand: true,
              busy: making,
              onPressed: busy ? null : () => _make(SlotImageMode.poster),
            ),
          ],
        ]);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('IMAGE · ${kind.label.toUpperCase()}', style: ZaveType.kicker),
        SizedBox(height: ZaveSpace.sm),
        ...body,
        if (!slot.hasPost && kind != ImageKind.photo) ...<Widget>[
          SizedBox(height: ZaveSpace.sm),
          Text(
            'Write the post first — then make its image.',
            style: ZaveType.caption,
          ),
        ],
        if (!slot.hasPost && kind == ImageKind.photo) ...<Widget>[
          SizedBox(height: ZaveSpace.sm),
          Text(
            'Add your photo now and the image is made when the post is '
            'written.',
            style: ZaveType.caption,
          ),
        ],
        _Note(slotIndex: widget.slotIndex, work: SlotWork.photo),
        _Note(slotIndex: widget.slotIndex, work: SlotWork.image),
      ],
    );
  }
}

/// A checkbox in its tile, the whole tile its tap target. Zave has a switch
/// but no checkbox, and a consent is a box that is ticked, not a setting.
class TickBox extends StatelessWidget {
  const TickBox({
    required this.checked,
    required this.title,
    required this.body,
    required this.onChanged,
    super.key,
  });

  final bool checked;
  final String title;
  final String body;

  /// Null while an action is in flight.
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final ValueChanged<bool>? change = onChanged;
    final BorderRadius radius = ZaveRadius.cardSmBr;
    return Semantics(
      checked: checked,
      enabled: change != null,
      label: '$title. $body',
      excludeSemantics: true,
      onTap: change == null ? null : () => change(!checked),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: change == null ? null : () => change(!checked),
          borderRadius: radius,
          child: Ink(
            padding: EdgeInsets.all(ZaveSpace.md),
            decoration: BoxDecoration(
              color: ZaveGlass.rest,
              border: Border.all(color: ZaveGlass.restBorder),
              borderRadius: radius,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 22,
                  height: 22,
                  margin: const EdgeInsets.only(top: 2),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: checked ? ZaveColors.white : Colors.transparent,
                    border: Border.all(
                      color: checked ? ZaveColors.white : ZaveColors.ink50,
                      width: 1.5,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(6)),
                  ),
                  child: checked
                      ? const Icon(AppIcons.check, size: 16, color: ZaveColors.ink)
                      : null,
                ),
                SizedBox(width: ZaveSpace.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(title, style: ZaveType.label),
                      SizedBox(height: ZaveSpace.xs),
                      Text(body, style: ZaveType.caption),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── The week's news ─────────────────────────────────────────────────────────

/// The week's news post: up to three headlines from the user's field, a pick,
/// and "Find this week's news" / "Refresh". The web's `NewsPicker`.
///
/// Shown only on the week's news day (Friday on odd weeks, Monday on even
/// ones) and only when the day's role is the news role. Hidden when the
/// search is off and the day holds no headlines — there is no button that
/// could only answer "not switched on". Headlines can be picked only while
/// the day is open (no post yet). Each links to its article in the user's
/// browser; the app never fetches it.
class NewsPicker extends ConsumerWidget {
  const NewsPicker({required this.slotIndex, super.key});

  final int slotIndex;

  /// Whether [slot] at [dayIndex] is its week's news day. `isNewsDaySlot`.
  static bool isNewsDay(PlanSlot slot, int weekNumber, int dayIndex) {
    final ({int dayIndex, String formatId, PostRole role}) day = newsDayFor(
      weekNumber,
    );
    return day.dayIndex == dayIndex &&
        slot.isPublishable &&
        slot.role == day.role;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final WeekPlan? plan = ref.watch(plannerControllerProvider).value?.plan;
    final PlanSlot? slot = plan?.posts.elementAtOrNull(slotIndex);
    if (plan == null ||
        slot == null ||
        !NewsPicker.isNewsDay(slot, plan.weekNumber, slotIndex)) {
      return const SizedBox.shrink();
    }

    final SlotNews? news = slot.news;
    final NewsStatus status =
        ref.watch(plannerNewsStatusProvider).value ?? NewsStatus.off;
    if (news == null && !status.enabled) return const SizedBox.shrink();

    final ({int dayIndex, String formatId, PostRole role}) day = newsDayFor(
      plan.weekNumber,
    );
    final String formatName =
        formatInfo(day.formatId)?.name.toLowerCase() ?? 'post';
    final bool open = slot.isOpen;
    final bool canSearch = open && status.enabled;
    final bool busy =
        ref.watch(plannerBusyProvider)[slotIndex]?.contains(SlotWork.news) ??
        false;
    final PlannerController planner = ref.read(
      plannerControllerProvider.notifier,
    );
    final int? chosen = news?.chosenIndex;
    final NewsCandidate? chosenItem = news?.chosen;
    final bool stale =
        chosenItem != null && !chosenItem.isUsable(news!.fetchedAt);
    final String when = status.entitled
        ? (day.dayIndex == 4
              ? ' — we look on Wednesday'
              : ' — we look with Saturday’s plan')
        : '';

    return Semantics(
      container: true,
      label: "This week's news post",
      child: ZaveCard(
        size: ZaveCardSize.small,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'THIS WEEK’S NEWS POST',
              style: ZaveType.kicker.copyWith(color: ZaveColors.peri),
            ),
            SizedBox(height: ZaveSpace.xs),
            Text(
              day.dayIndex == 4
                  ? 'An $formatName on fresh news from your field: the news, '
                        'your position, one reason from your work.'
                  : 'A news-led $formatName: the news, what it means for your '
                        'readers, three takeaways to save.',
              style: ZaveType.bodyMuted,
            ),
            if (news == null) ...<Widget>[
              SizedBox(height: ZaveSpace.sm),
              Text(
                'We find up to three headlines from your field, from the last '
                '$newsRecencyDays days${canSearch ? when : ''}. Pick one and '
                'the post is written around it. With none, this day keeps its '
                'usual format.',
                style: ZaveType.caption,
              ),
            ] else if (news.candidates.isEmpty) ...<Widget>[
              SizedBox(height: ZaveSpace.sm),
              Text(
                'No fresh headline from your field this week, so this day '
                'keeps its usual format.',
                style: ZaveType.caption,
              ),
            ] else ...<Widget>[
              SizedBox(height: ZaveSpace.md),
              for (int i = 0; i < news.candidates.length; i++)
                Padding(
                  padding: EdgeInsets.only(bottom: ZaveSpace.sm),
                  child: _Headline(
                    item: news.candidates[i],
                    selected: chosen == i,
                    onSelect: open && !busy && i != chosen
                        ? () => _runAction(context, () => planner.pickNews(i))
                        : null,
                    onOpen: () => openLinkAndReport(
                      context,
                      ref,
                      news.candidates[i].url,
                    ),
                  ),
                ),
              Text(
                'The post says only what the article says, names the '
                'publisher, and carries no link.',
                style: ZaveType.caption,
              ),
            ],
            if (stale) ...<Widget>[
              SizedBox(height: ZaveSpace.sm),
              Text(
                'This headline is over $newsUsableDays days old, so the post '
                'will use its usual format.${canSearch ? ' Refresh for fresh news.' : ''}',
                style: ZaveType.caption.copyWith(color: ZaveColors.amber),
              ),
            ],
            if (canSearch) ...<Widget>[
              SizedBox(height: ZaveSpace.md),
              ZaveButton(
                label: busy
                    ? 'Searching…'
                    : news == null
                    ? 'Find this week’s news'
                    : 'Refresh',
                expand: true,
                busy: busy,
                onPressed: busy
                    ? null
                    : () => _runAction(context, planner.findNews),
              ),
            ],
            _Note(slotIndex: slotIndex, work: SlotWork.news),
          ],
        ),
      ),
    );
  }
}

/// One headline: a radio (the whole tile), its title, source and date, its
/// summary, and "Read the article".
class _Headline extends StatelessWidget {
  const _Headline({
    required this.item,
    required this.selected,
    required this.onSelect,
    required this.onOpen,
  });

  final NewsCandidate item;
  final bool selected;

  /// Null once the day is written, or while a pick is saving.
  final VoidCallback? onSelect;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final BorderRadius radius = ZaveRadius.cardSmBr;
    return Semantics(
      inMutuallyExclusiveGroup: true,
      checked: selected,
      enabled: onSelect != null,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onSelect,
          borderRadius: radius,
          child: Ink(
            padding: EdgeInsets.all(ZaveSpace.md),
            decoration: BoxDecoration(
              color: selected
                  ? ZaveColors.peri.withValues(alpha: 0.10)
                  : ZaveGlass.rest,
              border: Border.all(
                color: selected
                    ? ZaveColors.peri.withValues(alpha: 0.5)
                    : ZaveGlass.restBorder,
              ),
              borderRadius: radius,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Drawn, not a Material glyph: the app has one icon
                // vocabulary (AppIcons), and it has no radio.
                Container(
                  width: 20,
                  height: 20,
                  margin: const EdgeInsets.only(top: 2),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: selected ? ZaveColors.peri : ZaveColors.ink50,
                      width: 1.5,
                    ),
                  ),
                  child: selected
                      ? Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: ZaveColors.peri,
                          ),
                        )
                      : null,
                ),
                SizedBox(width: ZaveSpace.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(item.title, style: ZaveType.label),
                      if (item.meta.isNotEmpty) ...<Widget>[
                        SizedBox(height: ZaveSpace.xs),
                        Text(item.meta, style: ZaveType.caption),
                      ],
                      if (item.summary.isNotEmpty) ...<Widget>[
                        SizedBox(height: ZaveSpace.xs),
                        Text(item.summary, style: ZaveType.bodyMuted),
                      ],
                      SizedBox(height: ZaveSpace.xs),
                      Semantics(
                        link: true,
                        child: GestureDetector(
                          onTap: onOpen,
                          child: Text(
                            'Read the article',
                            style: ZaveType.caption.copyWith(
                              color: ZaveColors.peri,
                              decoration: TextDecoration.underline,
                              decorationColor: ZaveColors.peri,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

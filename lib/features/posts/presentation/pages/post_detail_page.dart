import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show Clipboard, ClipboardData;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/ui/widgets/open_link.dart';
import '../../../../core/ui/zave/zave_kit.dart';
import '../../application/post_library_controllers.dart';
import '../../domain/library_post.dart';
import '../post_signal.dart';
import '../widgets/linkedin_preview_card.dart';
import '../widgets/post_confirm_sheet.dart';
import '../widgets/post_states.dart';
import '../widgets/schedule_sheet.dart';

/// **Post** — one post. The web's `/posts/[id]`.
///
/// ## What this screen is for
///
/// Everything a user does to a post that is already written: read it as
/// LinkedIn will show it, approve it, publish it now, reschedule it, edit the
/// words, or delete it. Composing a NEW post is a different screen.
///
/// ## The id
///
/// [postId] is the SERVER id (a cuid). Every action on this screen calls
/// `/posts/{id}` or `/posts/{id}/publish` with it. The previous version of this
/// app passed the local Drift autoincrement instead, and every publish on this
/// screen 404ed silently — which is why the library model ([LibraryPost]) has
/// no local id on it at all and there is no conversion between the two.
///
/// ## What the web does that a phone cannot
///
/// The web's edit mode attaches an image (`POST /api/upload/image`). This app
/// has no image picker on this screen, so that is absent and reported rather
/// than faked.
///
/// The web's other browser-shaped behaviour — opening the published post in a
/// new tab, both from the "View on LinkedIn" link and automatically on a
/// successful publish — IS ported. `target="_blank"` on a phone is not a
/// browser tab: the OS hands `linkedin.com` to the LinkedIn app, and
/// `core/platform/link_opening.dart` reproduces that. The clipboard remains
/// only as the fallback for a device where nothing can open a link.
class PostDetailPage extends ConsumerStatefulWidget {
  const PostDetailPage({required this.postId, super.key});

  /// The server id (cuid), NOT a local row id.
  final String postId;

  @override
  ConsumerState<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends ConsumerState<PostDetailPage> {
  static final DateFormat _createdFormat = DateFormat('MMM d, yyyy');
  static final DateFormat _scheduleDay = DateFormat('EEE, MMM d');
  static final DateFormat _scheduleTime = DateFormat('h:mm a');

  /// LinkedIn's own hard limit, and the web's `charLimit`.
  static const int _charLimit = 3000;

  /// The web turns its counter amber at 90% of the limit.
  static const int _charWarnAt = 2700;

  final TextEditingController _title = TextEditingController();
  final TextEditingController _content = TextEditingController();

  bool _editing = false;
  bool _busy = false;

  /// True once the controllers have been seeded from the loaded post, so a
  /// rebuild (a refetch, an optimistic patch) never overwrites what the user is
  /// part-way through typing.
  bool _seeded = false;

  @override
  void dispose() {
    _title.dispose();
    _content.dispose();
    super.dispose();
  }

  void _seed(LibraryPost post) {
    if (_seeded) return;
    _title.text = post.title ?? '';
    _content.text = post.content;
    _seeded = true;
  }

  void _notify(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          // Zave has no toast component; the platform's is used with the app's
          // own ground colour and type so it belongs to the same surface.
          backgroundColor: ZaveColors.deep,
          behavior: SnackBarBehavior.floating,
          content: Text(message, style: ZaveType.body),
        ),
      );
  }

  PostDetail get _controller =>
      ref.read(postDetailProvider(widget.postId).notifier);

  Future<void> _run(Future<void> Function() action, String failure) async {
    setState(() => _busy = true);
    try {
      await action();
    } on Object {
      _notify(failure);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _approve() => _run(() async {
    await _controller.approve();
    _notify('Post approved. It will go out on schedule.');
  }, 'Could not approve that post.');

  /// Publish, then open the post — the web does both
  /// (`window.open(data.linkedinUrl, '_blank')` in its `handlePublish`).
  ///
  /// The publish is what succeeded; opening is a courtesy on top of it. So a
  /// failure to open never becomes a failure to publish: the success notice
  /// is replaced by the fallback's message, and the post stays published
  /// either way.
  Future<void> _publish() => _run(() async {
    final String? url = await _controller.publish();
    if (url == null) {
      _notify('Published to LinkedIn.');
      return;
    }
    final String? problem = await openLinkOrCopy(ref, url);
    _notify(problem ?? 'Published to LinkedIn.');
  }, 'Could not publish that post.');

  Future<void> _save({required bool asDraft}) => _run(() async {
    await _controller.save(
      title: _title.text.trim().isEmpty ? null : _title.text.trim(),
      content: _content.text,
      // The web's `handleSave('draft')` — one PATCH that carries the body AND
      // the status, rather than two round-trips the user can land between.
      status: asDraft ? PostLibraryStatus.draft : null,
    );
    if (mounted) setState(() => _editing = false);
    _notify(asDraft ? 'Saved as a draft.' : 'Post updated.');
  }, 'Could not save that post.');

  Future<void> _schedule(LibraryPost post) async {
    final ScheduleChoice? choice = await pickSchedule(
      context,
      initial: post.scheduledFor,
    );
    if (choice == null) return;
    await _run(() async {
      await _controller.setSchedule(choice.cleared ? null : choice.when);
      _notify(choice.cleared ? 'Schedule removed.' : 'Post rescheduled.');
    }, 'Could not change the schedule.');
  }

  Future<void> _delete() async {
    final bool confirmed = await confirmDestructive(
      context,
      title: 'Delete this post?',
      message:
          'It is removed from your library and, if it was scheduled, it will '
          'not go out.',
      confirmLabel: 'Delete post',
    );
    if (!confirmed) return;

    setState(() => _busy = true);
    try {
      await _controller.delete();
      if (!mounted) return;
      context.pop();
    } on Object {
      _notify('Could not delete that post.');
      if (mounted) setState(() => _busy = false);
    }
  }

  /// Opens the published post in the LinkedIn app, the way the web's
  /// `target="_blank"` link does.
  Future<void> _openOnLinkedIn(LibraryPost post) async {
    final String? url = post.linkedinUrl;
    if (url == null) return;
    final String? message = await openLinkOrCopy(ref, url);
    if (message != null) _notify(message);
  }

  Future<void> _copyBody(LibraryPost post) async {
    await Clipboard.setData(ClipboardData(text: post.content));
    _notify('Post text copied.');
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<LibraryPost> detail = ref.watch(
      postDetailProvider(widget.postId),
    );

    return ZaveScaffold(
      title: _editing ? 'Edit post' : 'Post',
      leading: ZaveIconButton(
        icon: const Icon(Icons.arrow_back),
        tooltip: 'Back to posts',
        onPressed: () => context.pop(),
      ),
      body: detail.when(
        loading: () => const _DetailSkeleton(),
        error: (Object e, StackTrace _) => ZaveScrollView(
          children: <Widget>[
            PostsError(
              title: 'That post did not load.',
              detail:
                  'It may have been deleted, or the connection dropped on the '
                  'way.',
              onRetry: () => ref.invalidate(postDetailProvider(widget.postId)),
            ),
          ],
        ),
        data: (LibraryPost post) {
          _seed(post);
          return _editing ? _editBody(post) : _viewBody(post);
        },
      ),
    );
  }

  // ── View mode ────────────────────────────────────────────────────────────

  Widget _viewBody(LibraryPost post) {
    final ({Color color, String label}) signal = postSignal(post.status);

    return ZaveScrollView(
      children: <Widget>[
        Row(
          children: <Widget>[
            ZaveDot(signal.color),
            SizedBox(width: ZaveSpace.sm),
            Text(
              signal.label.toUpperCase(),
              style: ZaveType.kicker.copyWith(color: signal.color),
            ),
            SizedBox(width: ZaveSpace.md),
            Expanded(
              child: Text(
                'Created ${_createdFormat.format(post.createdAt)}',
                style: ZaveType.caption,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        SizedBox(height: ZaveSpace.md),
        Text(post.displayTitle, style: ZaveType.h2),

        if (post.scheduledFor != null && !post.isPublished) ...<Widget>[
          SizedBox(height: ZaveSpace.xl),
          _ScheduleBanner(
            when: post.scheduledFor!,
            day: _scheduleDay,
            time: _scheduleTime,
          ),
        ],

        if (post.status == PostLibraryStatus.failed) ...<Widget>[
          SizedBox(height: ZaveSpace.xl),
          // Amber, not red — Zave has no red. A failed publish is "this needs
          // you", which is exactly what amber means in this system.
          ZaveCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    const ZaveDot(ZaveColors.amber),
                    SizedBox(width: ZaveSpace.sm),
                    Text('DID NOT GO OUT', style: ZaveType.kicker),
                  ],
                ),
                SizedBox(height: ZaveSpace.md),
                Text(
                  'The last publish attempt failed. Publishing again is safe — '
                  'nothing reached LinkedIn.',
                  style: ZaveType.bodyMuted,
                ),
              ],
            ),
          ),
        ],

        SizedBox(height: ZaveSpace.xl),
        _ActionBar(
          post: post,
          busy: _busy,
          onPublish: _publish,
          onApprove: _approve,
          onEdit: () => setState(() => _editing = true),
          onSchedule: () => _schedule(post),
          onDelete: _delete,
          onOpenLinkedIn: () => _openOnLinkedIn(post),
          onCopyBody: () => _copyBody(post),
        ),

        SizedBox(height: ZaveSpace.xxl),
        Text('LINKEDIN PREVIEW', style: ZaveType.kicker),
        SizedBox(height: ZaveSpace.md),
        LinkedInPreviewCard(post: post),

        if (post.isPublished && post.metrics != null) ...<Widget>[
          SizedBox(height: ZaveSpace.xxl),
          Text('PERFORMANCE', style: ZaveType.kicker),
          SizedBox(height: ZaveSpace.md),
          _MetricsGrid(metrics: post.metrics!),
        ],
      ],
    );
  }

  // ── Edit mode ────────────────────────────────────────────────────────────

  Widget _editBody(LibraryPost post) {
    final int length = _content.text.characters.length;
    final bool empty = _content.text.trim().isEmpty;

    return ZaveScrollView(
      children: <Widget>[
        ZaveField(
          controller: _title,
          label: 'Title',
          hint: 'Post title (optional)',
          helper: 'Only you see this. LinkedIn shows the body.',
        ),
        SizedBox(height: ZaveSpace.xl),
        ZaveField(
          controller: _content,
          label: 'Post',
          hint: 'Post content...',
          minLines: 8,
          maxLines: null,
          maxLength: _charLimit,
          error: empty ? 'A post needs some words.' : null,
          onChanged: (String _) => setState(() {}),
        ),
        SizedBox(height: ZaveSpace.sm),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            '$length/$_charLimit',
            // Amber past 90% of the limit, as on the web. Amber is "waiting /
            // attention" in Zave; there is no red to escalate to, and none is
            // needed — the field simply stops accepting input at the cap.
            style: ZaveType.caption.copyWith(
              color: length > _charWarnAt ? ZaveColors.amber : ZaveColors.ink50,
            ),
          ),
        ),

        // SHOW the poster, rather than assert that it exists.
        //
        // This block used to be the sentence "This post has an image. Change it
        // on the web." and nothing else — so a planner post whose poster had
        // just been generated, uploaded and thumbnailed looked, on the phone,
        // exactly like a post with no poster at all. It was reported as the
        // planner failing to generate one. Editing still belongs on the web;
        // that is the only part of the old copy worth keeping.
        if (post.allImages.isNotEmpty) ...<Widget>[
          SizedBox(height: ZaveSpace.xl),
          if (post.imageSrc case final String src when src.isNotEmpty)
            GestureDetector(
              // Square here, and a poster is not square — the crop can take
              // the title off the top of the very thing that carries it. Tap
              // for the whole image.
              onTap: () => showPosterSheet(
                context,
                imageUrl: (post.imageUrl?.isNotEmpty ?? false)
                    ? post.imageUrl!
                    : src,
                title: post.title,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(ZaveRadius.cardSm),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Image.network(
                    src,
                    fit: BoxFit.cover,
                    // A poster that will not load must not read as no poster:
                    // say so, and keep the count below honest either way.
                    errorBuilder: (_, _, _) => ColoredBox(
                      color: ZaveGlass.hover,
                      child: Center(
                        child: Icon(
                          Icons.broken_image_outlined,
                          size: 28,
                          color: ZaveColors.ink45,
                        ),
                      ),
                    ),
                    loadingBuilder:
                        (_, Widget child, ImageChunkEvent? progress) =>
                            progress == null
                            ? child
                            : ColoredBox(
                                color: ZaveGlass.hover,
                                child: const Center(
                                  child: SizedBox.square(
                                    dimension: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                ),
                              ),
                  ),
                ),
              ),
            ),
          SizedBox(height: ZaveSpace.md),
          Text(
            post.allImages.length == 1
                ? 'Change this image on the web.'
                : '${post.allImages.length} images. Change them on the web.',
            style: ZaveType.caption,
          ),
        ],

        SizedBox(height: ZaveSpace.xl),
        ZaveButton.primary(
          label: 'Save changes',
          expand: true,
          busy: _busy,
          onPressed: empty ? null : () => _save(asDraft: false),
        ),
        SizedBox(height: ZaveSpace.md),
        ZaveButton(
          label: 'Save as draft',
          expand: true,
          onPressed: empty || _busy ? null : () => _save(asDraft: true),
        ),
        SizedBox(height: ZaveSpace.md),
        ZaveButton(
          label: 'Cancel',
          expand: true,
          onPressed: _busy
              ? null
              : () {
                  // Throw the edits away and re-seed from the server's copy.
                  _seeded = false;
                  _seed(post);
                  setState(() => _editing = false);
                },
        ),
      ],
    );
  }
}

/// "Scheduled for Thu, Sep 25 at 9:00 AM".
///
/// The web paints this banner `bg-[#5761EB]/10`. In Zave the queued state is
/// periwinkle (`--zv-sched`), and it is carried by the dot and the text rather
/// than by tinting the surface — a card's fill is a depth step, never a status.
class _ScheduleBanner extends StatelessWidget {
  const _ScheduleBanner({
    required this.when,
    required this.day,
    required this.time,
  });

  final DateTime when;
  final DateFormat day;
  final DateFormat time;

  @override
  Widget build(BuildContext context) {
    return ZaveCard(
      size: ZaveCardSize.small,
      padding: ZaveSpace.rowPad,
      child: Row(
        children: <Widget>[
          const ZaveDot(ZaveColors.scheduled),
          SizedBox(width: ZaveSpace.md),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: <InlineSpan>[
                  TextSpan(
                    text: 'Scheduled for ${day.format(when)} ',
                    style: ZaveType.label.copyWith(color: ZaveColors.white),
                  ),
                  TextSpan(
                    text: 'at ${time.format(when)}',
                    style: ZaveType.label.copyWith(color: ZaveColors.ink62),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// The view-mode actions.
///
/// One white button, and it is whichever action the post is actually waiting
/// for: Publish while it is unpublished, and nothing white at all once it is
/// live. Everything else is glass.
///
/// The secondary actions sit in a [Wrap], not a [Row]. The web's own bar is
/// `flex flex-wrap`, and on a 375pt screen a fixed row of two icon+label pills
/// plus the delete button does not fit — it would either overflow or force the
/// labels to wrap inside their own pills, which looks broken.
class _ActionBar extends StatelessWidget {
  const _ActionBar({
    required this.post,
    required this.busy,
    required this.onPublish,
    required this.onApprove,
    required this.onEdit,
    required this.onSchedule,
    required this.onDelete,
    required this.onOpenLinkedIn,
    required this.onCopyBody,
  });

  final LibraryPost post;
  final bool busy;
  final VoidCallback onPublish;
  final VoidCallback onApprove;
  final VoidCallback onEdit;
  final VoidCallback onSchedule;
  final VoidCallback onDelete;
  final VoidCallback onOpenLinkedIn;
  final VoidCallback onCopyBody;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        if (!post.isPublished) ...<Widget>[
          ZaveButton.primary(
            label: 'Publish now',
            icon: const Icon(Icons.send_outlined),
            expand: true,
            busy: busy,
            onPressed: onPublish,
          ),
          SizedBox(height: ZaveSpace.md),
        ],

        Wrap(
          spacing: ZaveSpace.sm,
          runSpacing: ZaveSpace.sm,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: <Widget>[
            if (post.canApprove)
              ZaveButton(
                label: 'Approve',
                icon: const Icon(Icons.check_circle_outline),
                onPressed: busy ? null : onApprove,
              ),
            if (!post.isPublished) ...<Widget>[
              ZaveButton(
                label: 'Edit',
                icon: const Icon(Icons.edit_outlined),
                onPressed: busy ? null : onEdit,
              ),
              ZaveButton(
                label: post.scheduledFor == null ? 'Schedule' : 'Reschedule',
                icon: const Icon(Icons.schedule),
                onPressed: busy ? null : onSchedule,
              ),
            ],
            ZaveButton(
              label: 'Copy text',
              icon: const Icon(Icons.copy_all_outlined),
              onPressed: onCopyBody,
            ),
            if (post.linkedinUrl != null)
              ZaveButton(
                label: 'View on LinkedIn',
                icon: const Icon(Icons.open_in_new_rounded),
                onPressed: onOpenLinkedIn,
              ),
            ZaveIconButton(
              icon: const Icon(Icons.delete_outline),
              tooltip: 'Delete post',
              onPressed: busy ? null : onDelete,
            ),
          ],
        ),
      ],
    );
  }
}

/// Impressions / reactions / comments / shares, in the web's order.
/// What the post actually did, in the two shapes the numbers support.
///
/// ## Why it is no longer four boxes with a number in each
///
/// It was four equal tiles: impressions, reactions, comments, shares, each a
/// figure above a caption. Nothing in that layout said which number mattered,
/// and nothing related any number to any other — 214 reactions is meaningless
/// until you know it sat under 4,821 impressions.
///
/// So it is now a lead and a breakdown. Impressions is the denominator of
/// everything else and gets the hero card; the three engagement counts sit
/// under it as shares of their own total.
///
/// ## Every figure here is derived, not decorative
///
/// There is no time series on a [PostMetrics] — it is four point-in-time
/// counts — so there is no sparkline, because drawing one would mean inventing
/// the points between. What IS available is real: the engagement rate is
/// (reactions + comments + shares) / impressions, the standard definition, and
/// each meter is that metric's share of engagement. Both are facts about the
/// post. A chart on this screen is arithmetic, never illustration.
class _MetricsGrid extends StatelessWidget {
  const _MetricsGrid({required this.metrics});

  final PostMetrics metrics;

  int get _engagement => metrics.reactions + metrics.comments + metrics.shares;

  /// The LinkedIn definition. Null when there is nothing to divide by — a post
  /// with no impressions yet has no rate, which is not the same as 0%.
  double? get _rate =>
      metrics.impressions <= 0 ? null : _engagement / metrics.impressions;

  @override
  Widget build(BuildContext context) {
    final NumberFormat number = NumberFormat.decimalPattern();
    final NumberFormat percent = NumberFormat.decimalPercentPattern(
      decimalDigits: 1,
    );
    final double? rate = _rate;

    return Column(
      children: <Widget>[
        ZaveCard(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('IMPRESSIONS', style: ZaveType.kicker),
                    SizedBox(height: ZaveSpace.sm),
                    // The gradient numeral is the reference's treatment for
                    // the one figure a card is about. Exactly one per screen.
                    ZaveGradientText(
                      number.format(metrics.impressions),
                      style: ZaveType.statNumber,
                    ),
                    SizedBox(height: ZaveSpace.xs),
                    Text(
                      rate == null
                          ? 'No reach recorded yet'
                          : '${percent.format(rate)} engaged',
                      style: ZaveType.caption,
                    ),
                  ],
                ),
              ),
              // The wedge reads the real rate. Scaled against 10%, which is a
              // strong post on LinkedIn — against 100% every honest rate would
              // draw as a flat line and the chart would say nothing.
              if (rate != null)
                SizedBox(
                  width: 96,
                  height: 56,
                  child: ZaveAreaWedge(progress: (rate / 0.10).clamp(0.0, 1.0)),
                ),
            ],
          ),
        ),
        SizedBox(height: ZaveSpace.md),
        // One card, three rows — not three cards.
        //
        // Three side-by-side tiles put each bar on its own axis, so a long bar
        // in a narrow card and a short bar in a wide one are not comparable,
        // which defeats the point of drawing them. Stacked, the bars share a
        // left edge and a length, and the shape of the post's engagement is
        // legible at a glance.
        //
        // It also gives each label the full width. Three across could not fit
        // "Comments" and rendered it "Comme…".
        ZaveCard(
          child: Column(
            children: <Widget>[
              _Share(
                label: 'Reactions',
                value: number.format(metrics.reactions),
                share: _engagement == 0 ? 0 : metrics.reactions / _engagement,
              ),
              SizedBox(height: ZaveSpace.lg),
              _Share(
                label: 'Comments',
                value: number.format(metrics.comments),
                share: _engagement == 0 ? 0 : metrics.comments / _engagement,
              ),
              SizedBox(height: ZaveSpace.lg),
              _Share(
                label: 'Shares',
                value: number.format(metrics.shares),
                share: _engagement == 0 ? 0 : metrics.shares / _engagement,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// One engagement count as a labelled bar.
class _Share extends StatelessWidget {
  const _Share({required this.label, required this.value, required this.share});

  final String label;
  final String value;
  final double share;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(child: Text(label, style: ZaveType.body)),
            Text(value, style: ZaveType.label),
          ],
        ),
        SizedBox(height: ZaveSpace.sm),
        ZaveMeter(value: share),
      ],
    );
  }
}

/// The loading state — the same shapes the loaded screen occupies, at the rest
/// fill step. No shimmer: Zave's motion rule forbids anything that loops.
class _DetailSkeleton extends StatelessWidget {
  const _DetailSkeleton();

  @override
  Widget build(BuildContext context) {
    return ZaveScrollView(
      children: <Widget>[
        Container(height: 20, decoration: ZaveSurface.card),
        SizedBox(height: ZaveSpace.lg),
        Container(height: 64, decoration: ZaveSurface.card),
        SizedBox(height: ZaveSpace.xl),
        Container(height: 56, decoration: ZaveSurface.card),
        SizedBox(height: ZaveSpace.md),
        Container(height: 56, decoration: ZaveSurface.card),
        SizedBox(height: ZaveSpace.xxl),
        Container(height: 320, decoration: ZaveSurface.card),
      ],
    );
  }
}

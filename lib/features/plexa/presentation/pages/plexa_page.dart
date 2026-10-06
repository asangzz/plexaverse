import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show Clipboard, ClipboardData;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/links/linkedin.dart';
import '../../../../core/router/zave_routes.dart';
import '../../../../core/ui/widgets/open_link.dart';
import '../../../../core/ui/zave/zave_kit.dart';
import '../../application/plexa_controller.dart';
import '../../domain/plexa_day.dart';
import '../widgets/plexa_item_card.dart';

/// **Open Plexa** — the day's missions as one conversation.
///
/// The web's `components/automate/PlexaDayChat.tsx`, mounted on the dashboard
/// roadmap. Three lanes of work the user walks down: the curated Top Voices
/// posts, the comments written for their own niche, and the people to reach
/// out to.
///
/// ## What is one call here and four on the web
///
/// The web assembles this thread from `/api/plexa/day` plus the three item
/// routes, because its dashboard pages have already fetched those and the chat
/// is reading warm caches. A phone has none of that, so `GET /plexa/day` on
/// mobile returns every lane and the session together — four sequential trips
/// to Tokyo is two to four seconds of empty thread.
///
/// ## A lane that is not ready is not a lane that is finished
///
/// This is the distinction the screen is built around, and it is the one most
/// easily lost: `ready: false` means today's work has not been generated yet,
/// which costs XP to fix. An empty list means it was generated and cleared.
/// Rendering both as "nothing here" would hide a button the user needs behind
/// a day that looks done.
///
/// ## Nothing here is proof
///
/// LinkedIn tells us nothing back. It cannot be asked whether a comment was
/// posted or an invitation sent on any scope this app holds, so every tick is
/// the user saying they did it. The copy says "I did this", never "done".
class PlexaPage extends ConsumerWidget {
  const PlexaPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<PlexaDay> day = ref.watch(plexaControllerProvider);

    return ZaveScaffold(
      title: 'Today with Plexa',
      leading: ZaveIconButton(
        icon: const Icon(Icons.arrow_back),
        tooltip: 'Back',
        onPressed: () =>
            context.canPop() ? context.pop() : context.go(ZaveRoutes.dashboard),
      ),
      body: RefreshIndicator(
        color: ZaveColors.white,
        backgroundColor: ZaveColors.deep,
        onRefresh: () async =>
            ref.read(plexaControllerProvider.notifier).refresh(),
        child: day.when(
          loading: () => const _PlexaSkeleton(),
          error: (Object e, StackTrace _) => ZaveScrollView(
            children: <Widget>[
              SizedBox(height: ZaveSpace.xl),
              Text('Today did not load.', style: ZaveType.h3),
              SizedBox(height: ZaveSpace.sm),
              Text('Pull down to try again.', style: ZaveType.bodyMuted),
            ],
          ),
          data: (PlexaDay d) => _Thread(day: d),
        ),
      ),
    );
  }
}

class _Thread extends ConsumerWidget {
  const _Thread({required this.day});

  final PlexaDay day;

  Future<void> _copy(BuildContext context, String text, String said) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: ZaveColors.deep,
          behavior: SnackBarBehavior.floating,
          content: Text(said, style: ZaveType.body),
        ),
      );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final PlexaController controller = ref.read(
      plexaControllerProvider.notifier,
    );

    return ZaveScrollView(
      children: <Widget>[
        _Greeting(day: day),
        SizedBox(height: ZaveSpace.xl),

        // ── Curated posts ────────────────────────────────────────────────
        if (day.topVoices.ready) ...<Widget>[
          const ZaveSectionHeader(title: 'Five worth commenting on'),
          SizedBox(height: ZaveSpace.md),
          for (final PlexaTopVoice t in day.topVoices.items) ...<Widget>[
            PlexaItemCard(
              kicker: t.authorName,
              body: t.firstLine,
              draft: t.comment,
              isDone: t.isDone,
              // The one lane with a real destination: a curated post has a
              // URL, so the user can be taken to the exact post rather than
              // to a search that approximates it.
              onOpen: t.postUrl.isEmpty
                  ? null
                  : () => openLinkAndReport(context, ref, t.postUrl),
              onCopy: t.comment.isEmpty
                  ? null
                  : () => _copy(context, t.comment, 'Comment copied.'),
              onToggleDone: () => controller.setDone(
                lane: PlexaLane.comments,
                itemId: t.id,
                done: !t.isDone,
                topVoiceId: t.id,
              ),
            ),
            SizedBox(height: ZaveSpace.md),
          ],
          SizedBox(height: ZaveSpace.lg),
        ],

        // ── Comments for the user's own niche ────────────────────────────
        ZaveSectionHeader(
          title: day.topic.isEmpty
              ? 'Comments for your niche'
              : 'Comments on ${day.topic}',
        ),
        SizedBox(height: ZaveSpace.md),
        if (!day.comments.ready)
          _NotReady(
            detail:
                'Today’s set has not been written yet. Opening the comments '
                'screen writes it — that is where the XP is spent.',
            onGo: () => context.push(ZaveRoutes.comments),
          )
        else
          for (final PlexaComment c in day.comments.items) ...<Widget>[
            PlexaItemCard(
              kicker: c.targetPostTitle,
              body: c.comment,
              draft: '',
              isDone: day.session.isDone(PlexaLane.comments, c.id),
              onOpen: c.searchKeywords.isEmpty
                  ? null
                  : () => openLinkAndReport(
                      context,
                      ref,
                      linkedInContentSearchUrl(c.searchKeywords),
                    ),
              onCopy: () => _copy(context, c.comment, 'Comment copied.'),
              onToggleDone: () => controller.setDone(
                lane: PlexaLane.comments,
                itemId: c.id,
                done: !day.session.isDone(PlexaLane.comments, c.id),
              ),
            ),
            SizedBox(height: ZaveSpace.md),
          ],
        SizedBox(height: ZaveSpace.lg),

        // ── People to reach out to ───────────────────────────────────────
        const ZaveSectionHeader(title: 'People to reach out to'),
        SizedBox(height: ZaveSpace.md),
        if (!day.connections.ready)
          _NotReady(
            detail:
                'Today’s targets have not been found yet. Opening the '
                'connections screen finds them.',
            onGo: () => context.push(ZaveRoutes.connections),
          )
        else
          for (final PlexaConnection c in day.connections.items) ...<Widget>[
            PlexaItemCard(
              kicker: '${c.role} · ${c.company}',
              body: c.note,
              draft: '',
              isDone: day.session.isDone(PlexaLane.connections, c.id),
              badge: c.isDirectMessage ? 'Direct message' : null,
              onOpen: c.searchUrl.isEmpty
                  ? null
                  : () => openLinkAndReport(context, ref, c.searchUrl),
              onCopy: () => _copy(context, c.note, 'Note copied.'),
              onToggleDone: () => controller.setDone(
                lane: PlexaLane.connections,
                itemId: c.id,
                done: !day.session.isDone(PlexaLane.connections, c.id),
              ),
            ),
            SizedBox(height: ZaveSpace.md),
          ],
      ],
    );
  }
}

/// The opening line, and the day's count.
class _Greeting extends StatelessWidget {
  const _Greeting({required this.day});

  final PlexaDay day;

  @override
  Widget build(BuildContext context) {
    final int done = day.done;
    final int total = day.total;

    return ZaveCard(
      size: ZaveCardSize.large,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('TODAY', style: ZaveType.kicker),
          SizedBox(height: ZaveSpace.sm),
          Text(
            day.isEmpty
                ? 'Nothing is prepared yet.'
                : done >= total && total > 0
                ? 'That is the day. Nicely done.'
                : 'Here is what today asks for.',
            style: ZaveType.h2,
          ),
          if (!day.isEmpty) ...<Widget>[
            SizedBox(height: ZaveSpace.md),
            Row(
              children: <Widget>[
                Expanded(
                  child: ZaveMeter(value: total == 0 ? 0 : done / total),
                ),
                SizedBox(width: ZaveSpace.md),
                Text('$done / $total', style: ZaveType.label),
              ],
            ),
          ],
          SizedBox(height: ZaveSpace.md),
          Text(
            // Said once, at the top, rather than on every card. LinkedIn
            // reports nothing back to this product, so the whole thread is
            // the user's own account of their day.
            'Plexa cannot see LinkedIn, so nothing here ticks itself. Tap '
            '“I did this” when you have.',
            style: ZaveType.caption,
          ),
        ],
      ),
    );
  }
}

/// A lane whose work has not been generated yet.
///
/// Deliberately not an empty list. Generating costs XP, so the offer has to be
/// explicit and has to say where the cost lands — and a lane rendered as empty
/// would read as finished, hiding the button entirely.
class _NotReady extends StatelessWidget {
  const _NotReady({required this.detail, required this.onGo});

  final String detail;
  final VoidCallback onGo;

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
              Text('NOT READY YET', style: ZaveType.kicker),
            ],
          ),
          SizedBox(height: ZaveSpace.sm),
          Text(detail, style: ZaveType.bodyMuted),
          SizedBox(height: ZaveSpace.lg),
          ZaveButton(
            // Short and fixed, not 'Prepare today's $what'. "connection
            // notes" pushed it to "Prepare today's conne…" at 402 points —
            // the same arithmetic that clipped the engagement cards. What it
            // prepares is already the section heading directly above.
            label: 'Prepare these',
            icon: const Icon(Icons.auto_awesome_outlined),
            expand: true,
            onPressed: onGo,
          ),
        ],
      ),
    );
  }
}

/// The loading state — the shapes the thread occupies, at the rest fill step.
/// No shimmer: Zave's motion rule forbids anything that loops.
class _PlexaSkeleton extends StatelessWidget {
  const _PlexaSkeleton();

  @override
  Widget build(BuildContext context) => ZaveScrollView(
    children: <Widget>[
      for (int i = 0; i < 4; i++) ...<Widget>[
        ZaveCard(
          child: SizedBox(height: i == 0 ? 120 : 96, width: double.infinity),
        ),
        SizedBox(height: ZaveSpace.md),
      ],
    ],
  );
}

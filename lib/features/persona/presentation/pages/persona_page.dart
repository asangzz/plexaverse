import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/links/linkedin.dart';
import '../../../../core/ui/widgets/open_link.dart';
import '../../../../core/ui/zave/zave_kit.dart';
import '../../application/persona_controller.dart';
import '../../domain/persona_repository.dart';
import '../widgets/audience_section.dart';
import '../widgets/identity_section.dart';
import '../widgets/persona_chrome.dart';
import '../../../../core/platform/file_picking.dart';

/// **Your Persona** — the web's `/persona`.
///
/// The trust surface: everything Plexa knows about the user, and what it has to
/// write from. Two tabs, as on the web — a chat with Plexa, and the read-only
/// persona.
///
/// ## What is real here, and what is not
///
/// The web serves this screen from a `getPersona()` service returning
/// `{identity, bank, reach}`. **The mobile API has no `/persona` route at all**,
/// nor a substance bank, reach import, audience suggestion or persona chat. So:
///
///   • **Who you are** is composed from `/user/preferences` + `/auth/me`. Real.
///   • **Who you're writing for** writes `serveRole` / `serveIndustry` /
///     `problemSolved` through the preferences PATCH. Real and editable.
///   • **Your material**, **reach** and **Talk to Plexa** have no endpoint and
///     say so.
///
/// The last point is the important one. The web's empty material bank carries a
/// promise — "Plexa won't invent a story" — and rendering a missing endpoint as
/// an empty bank would turn that promise into a lie and push the user to re-add
/// material they already have. The web guards this with an explicit
/// `unavailable` flag; this screen's version of it is [PersonaUnavailableNote].
class PersonaPage extends ConsumerWidget {
  const PersonaPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<PersonaSnapshot> persona = ref.watch(
      personaControllerProvider,
    );
    final PersonaTab tab = ref.watch(personaTabControllerProvider);

    return ZaveScaffold(
      body: RefreshIndicator(
        color: ZaveColors.white,
        backgroundColor: ZaveColors.deep,
        onRefresh: () async {
          ref.invalidate(personaControllerProvider);
          await ref.read(personaControllerProvider.future);
        },
        child: ZaveScrollView(
          children: <Widget>[
            Text('Your Persona', style: ZaveType.h2),
            SizedBox(height: ZaveSpace.sm),
            Text(
              'Everything Plexa knows about you, and what it has to write '
              'from.',
              style: ZaveType.lead,
            ),
            SizedBox(height: ZaveSpace.xl),

            // The web's two-segment control. In Zave a selected tab INVERTS to
            // solid white with ink letters — it is never underlined and never
            // merely tinted, which is what the web's indigo fill does.
            Wrap(
              spacing: ZaveSpace.sm,
              runSpacing: ZaveSpace.sm,
              children: <Widget>[
                ZaveChip(
                  label: 'Your Persona',
                  selected: tab == PersonaTab.persona,
                  onTap: () => ref
                      .read(personaTabControllerProvider.notifier)
                      .show(PersonaTab.persona),
                ),
                ZaveChip(
                  label: 'Talk to Plexa',
                  selected: tab == PersonaTab.chat,
                  onTap: () => ref
                      .read(personaTabControllerProvider.notifier)
                      .show(PersonaTab.chat),
                ),
              ],
            ),
            SizedBox(height: ZaveSpace.xl),

            if (tab == PersonaTab.chat)
              const _ChatTab()
            else
              switch (persona) {
                AsyncError<PersonaSnapshot>() => _PersonaError(
                  onRetry: () => ref.invalidate(personaControllerProvider),
                ),
                AsyncData<PersonaSnapshot>(:final PersonaSnapshot value) =>
                  _PersonaTab(snapshot: value),
                _ => const _PersonaSkeletonBody(),
              },
          ],
        ),
      ),
    );
  }
}

class _PersonaTab extends StatelessWidget {
  const _PersonaTab({required this.snapshot});

  final PersonaSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final double gap = PersonaSection.gap;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // Keyed on the saved audience so the form's controllers are rebuilt
        // from the server's value after a save, rather than holding the text
        // the user typed as if it were the stored state.
        AudienceSection(
          key: ValueKey<String>(
            '${snapshot.audience.role}|${snapshot.audience.industry}|'
            '${snapshot.audience.problem}',
          ),
          audience: snapshot.audience,
        ),
        SizedBox(height: gap),
        const _ReachSection(),
        SizedBox(height: gap),
        IdentitySection(
          identity: snapshot.identity,
          voiceSampleCount: snapshot.voiceSampleCount,
        ),
        SizedBox(height: gap),
        _MaterialSection(bank: snapshot.bank),
      ],
    );
  }
}

/// **How far your posts are going.**
///
/// LinkedIn's API tells a personal profile nothing about its own performance,
/// which is why the web's version is an *import*: the user downloads their own
/// analytics export and hands it over. That import, the screenshot fallback and
/// the hand-entry form are all mobile-routeless, and two of the three would
/// additionally need a file picker this build does not ship.
class _ReachSection extends StatelessWidget {
  const _ReachSection();

  @override
  Widget build(BuildContext context) {
    return const PersonaSection(
      title: 'How far your posts are going',
      lead:
          "LinkedIn doesn't share personal-profile analytics with any app — "
          'but it lets you download them.',
      child: _ImportReachButton(),
    );
  }
}

/// **Your material** — the substance bank.
///
/// The copy below is the web's, verbatim, because it is a promise rather than a
/// description: Plexa writes from these and only these, and when the bank runs
/// empty it writes general posts instead of inventing a story.
class _MaterialSection extends StatelessWidget {
  const _MaterialSection({required this.bank});

  final SubstanceBank bank;

  @override
  Widget build(BuildContext context) {
    return PersonaSection(
      title: 'Your material',
      lead:
          'Real things that happened to you. Plexa writes posts from these — '
          'and only these. When this runs empty it writes general posts '
          'instead of inventing a story.',
      child: _body(),
    );
  }

  Widget _body() {
    // A bank that could not be READ is not an empty bank, and must never wear
    // the empty state's face. The empty copy is a promise ("Plexa won't invent
    // a story"); showing it after a failed read is a lie that would push the
    // user to re-enter material they already gave us.
    if (bank.unavailable) {
      return const PersonaUnavailableNote(
        title: 'Could not read your material',
        message:
            'This is NOT an empty bank — it is a bank we failed to load. '
            'Nothing of yours has been lost. Pull to refresh, or try again in '
            'a moment.',
      );
    }

    if (bank.isEmpty) {
      return Text(
        'Nothing here yet. Tell Plexa about something that actually happened '
        'and it will write from that instead of writing in general.',
        style: ZaveType.bodyMuted,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            ZavePill(
              label: '${bank.availableCount} ready',
              color: ZaveColors.green,
              leading: const ZaveDot(ZaveColors.green),
            ),
            SizedBox(width: ZaveSpace.sm),
            ZavePill(
              label: '${bank.usedCount} used',
              color: ZaveColors.ink50,
              leading: const ZaveDot(ZaveColors.ink35),
            ),
          ],
        ),
        SizedBox(height: ZaveSpace.lg),
        for (final SubstanceItem item in bank.available) ...<Widget>[
          _MaterialRow(item: item),
          SizedBox(height: ZaveSpace.sm),
        ],
        if (bank.used.isNotEmpty) ...<Widget>[
          SizedBox(height: ZaveSpace.md),
          Text('ALREADY WRITTEN ABOUT', style: ZaveType.kicker),
          SizedBox(height: ZaveSpace.md),
          for (final SubstanceItem item in bank.used) ...<Widget>[
            _MaterialRow(item: item),
            SizedBox(height: ZaveSpace.sm),
          ],
        ],
      ],
    );
  }
}

/// One item of material.
class _MaterialRow extends StatelessWidget {
  const _MaterialRow({required this.item});

  final SubstanceItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: ZaveSpace.rowPad,
      decoration: ZaveSurface.row,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              ZaveDot(item.isUsed ? ZaveColors.ink35 : ZaveColors.green),
              SizedBox(width: ZaveSpace.sm),
              Text(item.kind.toUpperCase(), style: ZaveType.kicker),
              const Spacer(),
              // A figure in the material is worth flagging: it is what makes a
              // grounded post concrete rather than merely true.
              if (item.hasNumber)
                Text(
                  'HAS A NUMBER',
                  style: ZaveType.kicker.copyWith(color: ZaveColors.mint),
                ),
            ],
          ),
          SizedBox(height: ZaveSpace.sm),
          Text(
            item.text,
            style: item.isUsed ? ZaveType.bodyMuted : ZaveType.body,
          ),
        ],
      ),
    );
  }
}

/// **Talk to Plexa** — the chat that fills the bank.
class _ChatTab extends ConsumerStatefulWidget {
  const _ChatTab();

  @override
  ConsumerState<_ChatTab> createState() => _ChatTabState();
}

class _ChatTabState extends ConsumerState<_ChatTab> {
  final TextEditingController _input = TextEditingController();

  @override
  void dispose() {
    _input.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final String text = _input.text;
    if (text.trim().isEmpty) return;
    _input.clear();
    await ref.read(personaChatProvider.notifier).send(text);
  }

  @override
  Widget build(BuildContext context) {
    final List<PersonaTurn> turns = ref.watch(personaChatProvider);

    return PersonaSection(
      title: 'Talk to Plexa',
      lead: 'Free — never costs XP.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if (turns.isEmpty)
            Text(
              'Tell Plexa what you shipped, broke or argued about this week. '
              'It turns that into material your posts are written from.',
              style: ZaveType.bodyMuted,
            ),
          for (int i = 0; i < turns.length; i++) ...<Widget>[
            _Turn(
              turn: turns[i],
              onAccept: () async {
                await ref
                    .read(personaControllerProvider.notifier)
                    .applyProposals(turns[i].proposals);
                ref.read(personaChatProvider.notifier).clearProposals(i);
              },
              onDismiss: () =>
                  ref.read(personaChatProvider.notifier).clearProposals(i),
            ),
            SizedBox(height: ZaveSpace.md),
          ],
          SizedBox(height: ZaveSpace.md),
          ZaveField(
            controller: _input,
            hint: 'What happened this week?',
            maxLines: 3,
            minLines: 1,
            onSubmitted: (_) => _send(),
          ),
          SizedBox(height: ZaveSpace.md),
          ZaveButton.primary(label: 'Send', expand: true, onPressed: _send),
        ],
      ),
    );
  }
}

/// One line of the conversation.
///
/// A Plexa reply may carry PROPOSALS — suggested edits to the user's persona.
/// They render as an explicit accept/dismiss pair and are never applied by the
/// reply itself: a conversation must not silently rewrite who the user says
/// they are.
class _Turn extends StatelessWidget {
  const _Turn({
    required this.turn,
    required this.onAccept,
    required this.onDismiss,
  });

  final PersonaTurn turn;
  final VoidCallback onAccept;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: turn.fromUser
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: ZaveSpace.rowPad,
          decoration: turn.fromUser ? ZaveSurface.rowNow : ZaveSurface.row,
          child: Text(turn.text, style: ZaveType.body),
        ),
        if (turn.proposals.isNotEmpty) ...<Widget>[
          SizedBox(height: ZaveSpace.sm),
          Container(
            padding: ZaveSpace.rowPad,
            decoration: ZaveSurface.card,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('PLEXA SUGGESTS', style: ZaveType.kicker),
                SizedBox(height: ZaveSpace.sm),
                for (final PersonaProposal p in turn.proposals)
                  Padding(
                    padding: EdgeInsets.only(bottom: ZaveSpace.xs),
                    child: Text(
                      '${p.label ?? p.field}: ${p.to}',
                      style: ZaveType.body,
                    ),
                  ),
                SizedBox(height: ZaveSpace.md),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: ZaveButton(
                        label: 'Apply',
                        kind: ZaveButtonKind.primarySmall,
                        expand: true,
                        onPressed: onAccept,
                      ),
                    ),
                    SizedBox(width: ZaveSpace.md),
                    Expanded(
                      child: ZaveButton(
                        label: 'Not now',
                        expand: true,
                        onPressed: onDismiss,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _PersonaError extends StatelessWidget {
  const _PersonaError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return ZaveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("We couldn't load your persona.", style: ZaveType.h3),
          SizedBox(height: ZaveSpace.sm),
          Text(
            'This is a problem on our side. Nothing of yours has been lost — '
            'pull to refresh in a moment.',
            style: ZaveType.caption,
          ),
          SizedBox(height: ZaveSpace.lg),
          ZaveButton(label: 'Try again', onPressed: onRetry),
        ],
      ),
    );
  }
}

class _PersonaSkeletonBody extends StatelessWidget {
  const _PersonaSkeletonBody();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        for (int i = 0; i < 3; i++) ...<Widget>[
          if (i > 0) SizedBox(height: PersonaSection.gap),
          const PersonaSkeleton(),
        ],
      ],
    );
  }
}

/// Imports the LinkedIn analytics export.
///
/// LinkedIn shares no personal-profile analytics with any app — the export
/// a member downloads is the only route to this data, which is why the
/// screen explains the numbers before it has any. It needed a DOCUMENT
/// picker rather than a photo one, which is the whole reason it waited.
class _ImportReachButton extends ConsumerStatefulWidget {
  const _ImportReachButton();

  @override
  ConsumerState<_ImportReachButton> createState() => _ImportReachButtonState();
}

class _ImportReachButtonState extends ConsumerState<_ImportReachButton> {
  bool _busy = false;

  Future<void> _import() async {
    setState(() => _busy = true);
    String? note;
    try {
      final FilePickResult picked = await ref
          .read(filePickingProvider)
          .pick(extensions: <String>['xlsx']);
      switch (picked) {
        case PickedFile():
          note = await ref
              .read(personaControllerProvider.notifier)
              .importReach(picked);
        // Closing the picker is a decision.
        case FilePickCancelled():
          break;
        case FilePickFailure(:final String? message):
          note = message ?? 'Could not open your files.';
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
    if (note == null || !mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(note, style: ZaveType.body)));
  }

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      // The old text sent the user down Settings › Data privacy › Get a copy
      // of your data — a slower route than the web's, which links straight to
      // creator analytics where the download button lives. The app was
      // describing a longer journey AND not linking to it.
      Text(
        'Open your LinkedIn analytics, tap the download button at the top '
        'right, then pick the .xlsx here.',
        style: ZaveType.caption,
      ),
      SizedBox(height: ZaveSpace.md),
      ZaveButton(
        label: 'Open LinkedIn analytics',
        icon: const Icon(Icons.open_in_new_rounded),
        expand: true,
        onPressed: () =>
            openLinkAndReport(context, ref, linkedInCreatorAnalyticsUrl),
      ),
      SizedBox(height: ZaveSpace.md),
      ZaveButton(
        label: 'Import my LinkedIn export',
        icon: const Icon(Icons.upload_file_outlined),
        busy: _busy,
        onPressed: _busy ? null : _import,
      ),
    ],
  );
}

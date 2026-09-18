import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/ui/zave/zave_kit.dart';
import '../../application/persona_controller.dart';
import '../../domain/persona_repository.dart';
import '../widgets/audience_section.dart';
import '../widgets/identity_section.dart';
import '../widgets/persona_chrome.dart';

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
        IdentitySection(identity: snapshot.identity),
        SizedBox(height: gap),
        const _MaterialSection(),
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
      child: PersonaUnavailableNote(
        title: 'Import your numbers on the web',
        message:
            'Bringing your LinkedIn export in is not in the app yet. Nothing '
            'you have already imported has been lost — this screen simply '
            'cannot read it.',
      ),
    );
  }
}

/// **Your material** — the substance bank.
///
/// The copy below is the web's, verbatim, because it is a promise rather than a
/// description: Plexa writes from these and only these, and when the bank runs
/// empty it writes general posts instead of inventing a story.
class _MaterialSection extends StatelessWidget {
  const _MaterialSection();

  @override
  Widget build(BuildContext context) {
    return const PersonaSection(
      title: 'Your material',
      lead:
          'Real things that happened to you. Plexa writes posts from these — '
          'and only these. When this runs empty it writes general posts '
          'instead of inventing a story.',
      child: PersonaUnavailableNote(
        title: 'Not readable from the app',
        message:
            'The material bank has no mobile route yet, so this is NOT an '
            'empty bank — it is a bank the app cannot see. Nothing of yours '
            'has been lost. Add and review material in the web app.',
      ),
    );
  }
}

/// **Talk to Plexa** — the chat that fills the bank.
class _ChatTab extends StatelessWidget {
  const _ChatTab();

  @override
  Widget build(BuildContext context) {
    return const PersonaSection(
      title: 'Talk to Plexa',
      lead: 'Free — never costs XP.',
      child: PersonaUnavailableNote(
        title: 'Not in the app yet',
        message:
            'Telling Plexa what you shipped, broke or argued about — and '
            'having it turn that into posts — runs on a route the mobile API '
            'does not expose. Use the web app; anything you tell it there '
            'feeds the same posts you see here.',
      ),
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

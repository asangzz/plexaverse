import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/persona_repositories.dart';
import '../domain/persona_repository.dart';
import '../../../core/platform/file_picking.dart';

part 'persona_controller.g.dart';

/// The persona screen's state.
///
/// One controller rather than a provider per block, because — unlike Settings —
/// everything this screen can actually read comes from the SAME two requests.
/// Splitting it would buy independent retries for two sections that always
/// succeed or fail together.
@riverpod
class PersonaController extends _$PersonaController {
  @override
  Future<PersonaSnapshot> build() =>
      ref.watch(personaRepositoryProvider).fetchPersona();

  /// Imports the LinkedIn analytics export and refreshes.
  ///
  /// Returns the message to show — the repository passes the server's own
  /// words through on a rejection, because "that does not look like a
  /// LinkedIn export" tells the user what to do next and a generic failure
  /// does not.
  Future<String> importReach(PickedFile file) async {
    final String message =
        await ref.read(personaRepositoryProvider).importReachExport(file);
    // Refresh either way: a partial import still moved the numbers, and a
    // stale screen after a successful one reads as nothing having happened.
    ref.invalidateSelf();
    return message;
  }

  /// Saves who the user writes for.
  ///
  /// Not optimistic. This is a deliberate Save with a busy button attached, and
  /// an audience that appears to save and then reverts would undermine the one
  /// field on this screen the user is least sure about.
  Future<void> saveAudience({
    String? role,
    String? industry,
    String? problem,
  }) async {
    final PersonaSnapshot updated = await ref
        .read(personaRepositoryProvider)
        .saveAudience(role: role, industry: industry, problem: problem);
    state = AsyncData<PersonaSnapshot>(updated);
  }

  /// Seeds the Substance Bank from the CV and past posts.
  ///
  /// Spends real model budget, so it is a button the user presses rather than
  /// something the screen does on open. Idempotent server-side.
  Future<void> harvest() async {
    final PersonaSnapshot updated = await ref
        .read(personaRepositoryProvider)
        .harvest();
    state = AsyncData<PersonaSnapshot>(updated);
  }

  /// Applies proposals the user accepted from a chat turn.
  Future<void> applyProposals(List<PersonaProposal> proposals) async {
    if (proposals.isEmpty) return;
    final PersonaSnapshot updated = await ref
        .read(personaRepositoryProvider)
        .applyProposals(proposals);
    state = AsyncData<PersonaSnapshot>(updated);
  }
}

/// One line of the Plexa conversation.
class PersonaTurn {
  const PersonaTurn({
    required this.text,
    required this.fromUser,
    this.proposals = const <PersonaProposal>[],
  });

  final String text;
  final bool fromUser;

  /// Suggested persona edits attached to a Plexa reply. Rendered as an
  /// explicit accept — a chat turn never writes on its own.
  final List<PersonaProposal> proposals;
}

/// The Plexa conversation.
///
/// Held separately from [PersonaController] because the transcript is UI state
/// with no server counterpart: `/persona/chat` is a single request/response
/// and keeps no history, so reloading the persona must not wipe what the user
/// is in the middle of saying.
@riverpod
class PersonaChat extends _$PersonaChat {
  @override
  List<PersonaTurn> build() => const <PersonaTurn>[];

  bool _sending = false;
  bool get isSending => _sending;

  Future<void> send(String message) async {
    final String text = message.trim();
    if (text.isEmpty || _sending) return;

    _sending = true;
    state = <PersonaTurn>[
      ...state,
      PersonaTurn(text: text, fromUser: true),
    ];

    try {
      final PersonaReply reply = await ref
          .read(personaRepositoryProvider)
          .chat(text);
      state = <PersonaTurn>[
        ...state,
        PersonaTurn(
          text: reply.reply,
          fromUser: false,
          proposals: reply.proposals,
        ),
      ];
    } on Object {
      state = <PersonaTurn>[
        ...state,
        const PersonaTurn(
          text: "Plexa couldn't reply just now. Try again in a moment.",
          fromUser: false,
        ),
      ];
    } finally {
      _sending = false;
    }
  }

  /// Drops the proposals off a turn once the user has accepted or dismissed
  /// them, so the accept row does not linger after it has been acted on.
  void clearProposals(int index) {
    if (index < 0 || index >= state.length) return;
    final List<PersonaTurn> next = List<PersonaTurn>.of(state);
    next[index] = PersonaTurn(
      text: next[index].text,
      fromUser: next[index].fromUser,
    );
    state = next;
  }
}

/// Which persona tab is showing.
///
/// **The web defaults to `chat`; this defaults to `persona`.** That is a
/// deliberate departure with a reason: the web's reasoning is "talking is how
/// the bank actually gets filled", and on mobile the bank cannot be filled at
/// all — there is no persona-chat route. Landing every user on a tab whose only
/// content is an explanation of why it is empty is a worse first screen than
/// landing them on the one with their own details in it. The chat tab is still
/// there, and still says what it is waiting on.
enum PersonaTab { persona, chat }

@riverpod
class PersonaTabController extends _$PersonaTabController {
  @override
  PersonaTab build() => PersonaTab.persona;

  void show(PersonaTab tab) => state = tab;
}

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/persona_repositories.dart';
import '../domain/persona_repository.dart';

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

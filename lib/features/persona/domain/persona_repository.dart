import 'persona_entities.dart';

export 'persona_entities.dart';

/// Thrown when the persona can't be read or written. One const sentinel for the
/// feature, per the slice convention.
class PersonaUnavailable implements Exception {
  const PersonaUnavailable();
}

/// Seam between the Persona screen and the mobile API.
///
/// ## The screen exists; most of its data does not
///
/// The web's `/persona` is served by a `getPersona()` service returning
/// `{identity, bank, reach}` and is fed by a fistful of mutations. The mobile
/// API has **none** of it: no `/persona`, no substance-bank read or write, no
/// reach import, no audience suggestion, no persona chat, and no voice-sample
/// count.
///
/// What it does have is `/user/preferences` and `/auth/me`, and between them
/// they carry the whole "Who you are" block and all three audience columns
/// (`serveRole`, `serveIndustry`, `problemSolved`). So this repository composes
/// that much honestly, and the screen states the rest as unavailable instead of
/// rendering it as empty.
///
/// That distinction is a product decision copied from the web, where the empty
/// material bank promises "Plexa won't invent a story" — a promise that becomes
/// a lie if a failed read wears the same face, and that would push a user to
/// re-enter material they already have.
abstract class PersonaRepository {
  Future<PersonaSnapshot> fetchPersona();

  /// Writes the audience columns and returns the updated snapshot.
  ///
  /// Partial, like every preferences write: only the named fields are sent.
  Future<PersonaSnapshot> saveAudience({
    String? role,
    String? industry,
    String? problem,
  });
}

import 'persona_entities.dart';
import '../../../core/platform/file_picking.dart';

export 'persona_entities.dart';

/// Thrown when the persona can't be read or written. One const sentinel for the
/// feature, per the slice convention.
class PersonaUnavailable implements Exception {
  const PersonaUnavailable();
}

/// Seam between the Persona screen and the mobile API.
///
/// Reads `GET /persona`, which returns everything Plexa knows about the user:
/// the stable identity, the Substance Bank, and the reach the user has
/// reported. Writes go to the narrower routes below.
///
/// This slice was originally built WITHOUT any of it — `/persona` had no mobile
/// counterpart, so the repository composed what it could from
/// `/user/preferences` + `/auth/me` and the screen honestly reported the rest
/// as unavailable. Those routes exist now, so it reads the real thing.
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

  /// `POST /persona/harvest` — seeds the Substance Bank from the CV and past
  /// posts. Idempotent server-side. Spends real model budget, so it is a
  /// deliberate user action rather than something the screen does on open.
  Future<PersonaSnapshot> harvest();

  /// Imports the LinkedIn analytics export.
  ///
  /// Returns a message to show — the server's own where it sent one, because
  /// "that doesn't look like a LinkedIn export" is worth far more to someone
  /// who picked the wrong file than a generic failure.
  Future<String> importReachExport(PickedFile file);

  /// `POST /persona/audience` — asks the model who this user should write for.
  /// Returns candidates; choosing one is a separate [saveAudience].
  Future<List<PersonaAudience>> suggestAudiences();

  /// `POST /persona/chat` — one turn of the Plexa conversation.
  ///
  /// The reply may carry proposals. They are NOT applied here.
  Future<PersonaReply> chat(String message);

  /// `POST /persona/apply` — applies proposals the user accepted.
  ///
  /// The only path that writes a model-suggested persona change.
  Future<PersonaSnapshot> applyProposals(List<PersonaProposal> proposals);
}

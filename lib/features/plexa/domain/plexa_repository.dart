import 'plexa_day.dart';

/// Reading the day, and clearing one item at a time.
///
/// Deliberately small. Open Plexa does not own the work — the comments, the
/// connection targets and the curated posts are generated elsewhere and paid
/// for elsewhere. This reads what exists and records what the user says they
/// did.
abstract class PlexaRepository {
  /// `GET /plexa/day` — every lane and the session, in one round trip.
  ///
  /// Never generates and never charges. A lane with nothing prepared comes
  /// back with `ready: false`, which the screen turns into an offer rather
  /// than an empty list.
  Future<PlexaDay> fetchDay();

  /// `POST /plexa/day` — mark one item done, or undo it.
  ///
  /// [topVoiceId] is set when the item is one of the day's curated posts. That
  /// lane has its own durable stamp which the comments screen reads, so
  /// clearing one here has to stamp it there too — otherwise the two surfaces
  /// disagree about the same five posts.
  ///
  /// Returns the session as it now stands, so the caller can render the new
  /// count without a second read.
  Future<PlexaSession> setItemDone({
    required PlexaLane lane,
    required String itemId,
    bool done,
    String? topVoiceId,
  });

  /// `POST /roadmap/progress` — credit today's roadmap step for a finished
  /// lane.
  ///
  /// The web does this the moment the last comment or the last request clears
  /// (`laneComplete` in `PlexaDayChat.tsx`), and it is the only XP this
  /// surface awards. Without it a user who works the whole day inside the chat
  /// finds the roadmap still showing the step undone, and goes to the
  /// engagement screens to redo work they have already done.
  ///
  /// Idempotent server-side, so a wrap-around that re-clears a lane cannot
  /// double-award.
  Future<void> completeStep({required int levelId, required int stepId});
}

import 'topic.dart';

export 'topic.dart';

/// Why a topics action could not complete.
///
/// Four of these come straight off `error.code` in the mobile envelope, and
/// they are kept apart because the right response differs: a profile that is
/// too thin to seed a suggestion is fixed in Settings, not by tapping the
/// button again, and an XP shortfall is fixed by buying XP. Collapsing them
/// into one sentinel would leave the screen able to say only "try again" to a
/// user for whom trying again cannot work.
enum TopicsFailure {
  /// `PROFILE_INCOMPLETE` — no profession, headline or company context to
  /// suggest from. The server's own note is explicit that the client should
  /// route to profile editing rather than offer a retry.
  profileIncomplete,

  /// `INSUFFICIENT_XP` — suggesting costs 50 XP and the balance is short.
  insufficientXp,

  /// `NOT_CONFIGURED` — the server is missing an AI key. Transient from the
  /// client's point of view; a deploy may fix it.
  notConfigured,

  /// `UPSTREAM_FAILED` — the model failed even after fallback.
  upstream,

  /// Offline, a timeout, a validation rejection, anything else.
  unknown,
}

/// Thrown by [TopicsRepository]. One exception type, a reason inside it.
class TopicsUnavailable implements Exception {
  const TopicsUnavailable([this.reason = TopicsFailure.unknown, this.message]);

  final TopicsFailure reason;

  /// The server's own sentence. The mobile envelope guarantees
  /// `error.message` is safe to show, and it is more specific than anything
  /// the client could compose — the web prints the equivalent string verbatim
  /// in its inline banner.
  final String? message;
}

/// Seam between the Topics screen and the backend.
abstract class TopicsRepository {
  /// `GET /topics` — newest first, as the server orders them.
  Future<List<Topic>> fetchTopics();

  /// `POST /topics`.
  ///
  /// [keywords] is already split and trimmed; the comma-separated string the
  /// user types is a UI concern and never reaches here. It is `required` and
  /// not defaulted because a default on an abstract member is a value no
  /// implementation is obliged to honour — passing an explicit empty list is
  /// one keystroke and cannot drift.
  Future<Topic> createTopic({
    required String name,
    required List<String> keywords,
    String? description,
  });

  /// `PATCH /topics/{id}` — a partial update; only the fields passed are sent.
  ///
  /// **Nothing in the UI calls this yet, and that is on purpose.** The web's
  /// `/topics` renders `isActive` as a read-only pill and offers no edit
  /// control, so this app offers none either — inventing one would be a
  /// divergence, not a courtesy. The method exists because the endpoint does,
  /// and because the seam should describe the API rather than today's screen.
  Future<Topic> setActive({required String id, required bool isActive});

  /// `DELETE /topics/{id}`. Any schedules pointing at the topic have their
  /// `topicId` nulled in the same transaction, server-side.
  ///
  /// Unused by the UI for the same reason as [setActive].
  Future<void> deleteTopic(String id);

  /// `POST /ai/suggest-topics` — three suggestions from the user's profile.
  /// Costs 50 XP per call, whether or not the user keeps any of them.
  Future<List<SuggestedTopic>> suggestTopics();

  /// `POST /roadmap/progress` for Level 5, Step 1 — "Content Strategy
  /// Foundations", which the web completes the moment a user has three topics.
  ///
  /// Idempotent server-side, which is what makes it safe to fire on every load
  /// that finds three topics rather than tracking "have I sent this?" locally.
  Future<void> recordTopicsFoundation();
}

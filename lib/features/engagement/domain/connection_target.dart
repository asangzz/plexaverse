import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/links/linkedin.dart';

part 'connection_target.freezed.dart';
part 'connection_target.g.dart';

/// One person to reach out to, with the note already written.
///
/// The web counterpart is the `Connection` interface in
/// `app/(dashboard)/connections/page.tsx`; the wire shape is
/// `ConnectionResult` from `findConnections()` in `lib/services/ai.service.ts`.
///
/// **These are roles, not people.** [role] and [company] describe who to look
/// for; [searchQuery] and [linkedinSearchUrl] are how to find them. The product
/// never sees a real profile, and a card here is a search brief rather than a
/// person — which is why there is no avatar and no name anywhere on it.
///
/// [isDirectMessage] marks the one card in five that is a DM rather than a
/// connection request. It exists because LinkedIn's free plan caps personalised
/// connection notes at roughly five a week: four requests stay under the cap,
/// and the fifth slot spends an unlimited DM to an Open Profile instead.
@freezed
abstract class ConnectionTarget with _$ConnectionTarget {
  const ConnectionTarget._();

  const factory ConnectionTarget({
    @Default('') String role,
    @Default('') String company,

    /// What to type into LinkedIn's people search.
    @Default('') String searchQuery,

    /// The server's deep link to that search, stamped with
    /// `origin=SWITCH_SEARCH_VERTICAL` by `findConnections()`.
    ///
    /// Read through [searchUrl], never directly — it carries `@Default('')`,
    /// so a server that omits it hands the UI an empty string rather than
    /// null, and an empty string is not a link.
    @Default('') String linkedinSearchUrl,

    /// The connection note / DM body, ready to paste.
    @Default('') String note,
    @Default(false) bool isDirectMessage,

    /// Copied at least once. Local only — the server has no per-target state,
    /// and copying is the last thing this app can observe before the user
    /// leaves for LinkedIn.
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default(false)
    bool isSent,
  }) = _ConnectionTarget;

  factory ConnectionTarget.fromJson(Map<String, dynamic> json) =>
      _$ConnectionTargetFromJson(json);

  /// The search to open for this target: the server's URL when it sent one,
  /// otherwise one built from [searchQuery] with the server's own formula.
  ///
  /// Null when neither exists, which is the only case where the card has
  /// nothing to open and must disable the action. Callers switch on null
  /// rather than on `linkedinSearchUrl.isEmpty`, so the fallback cannot be
  /// forgotten at one call site and honoured at another.
  String? get searchUrl {
    if (linkedinSearchUrl.trim().isNotEmpty) return linkedinSearchUrl.trim();
    if (searchQuery.trim().isEmpty) return null;
    return linkedInPeopleSearchUrl(searchQuery);
  }

  /// LinkedIn's connection-note ceiling. The web shows `{len}/280` against it
  /// and turns the counter amber past 270.
  static const int noteLimit = 280;

  /// The web's amber threshold — a note this long is about to be truncated.
  static const int noteWarnAt = 270;

  /// A DM has no length cap, so the counter is meaningless there.
  bool get showsNoteCounter => !isDirectMessage;

  bool get isNoteTooLong => showsNoteCounter && note.length > noteLimit;

  bool get isNoteNearLimit => showsNoteCounter && note.length > noteWarnAt;
}

/// A day's batch of connection targets.
@freezed
abstract class ConnectionBatch with _$ConnectionBatch {
  const ConnectionBatch._();

  const factory ConnectionBatch({
    @Default(<ConnectionTarget>[]) List<ConnectionTarget> connections,

    /// The profession the server aimed the batch at — the user's LinkedIn
    /// headline, falling back to their stated profession.
    @Default('') String profession,

    /// True when this is today's stored batch, replayed at no cost.
    @Default(false) bool cached,

    /// What a fresh batch would cost. Null until the server has priced one.
    int? xpCost,
  }) = _ConnectionBatch;

  factory ConnectionBatch.fromJson(Map<String, dynamic> json) =>
      _$ConnectionBatchFromJson(json);

  int get sentCount =>
      connections.where((ConnectionTarget c) => c.isSent).length;

  bool get isEmpty => connections.isEmpty;

  /// The denominator for this screen's progress.
  ///
  /// **Not the roadmap's number.** The web deliberately ignores the roadmap
  /// step's count here and uses `connections.length || 5` — every card is one
  /// send, so the target is however many cards came back. (`/comments` does the
  /// opposite and reads the roadmap. The asymmetry is the web's, not ours.)
  int get targetCount => connections.isEmpty ? 5 : connections.length;
}

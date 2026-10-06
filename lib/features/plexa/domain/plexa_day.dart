import 'package:freezed_annotation/freezed_annotation.dart';

part 'plexa_day.freezed.dart';
part 'plexa_day.g.dart';

/// The day's missions, as one conversation.
///
/// The web counterpart is `components/automate/PlexaDayChat.tsx` over
/// `lib/services/plexa-day.service.ts`. The wire shape is whatever
/// `GET /plexa/day` returns.
///
/// ## Why progress lives on the server
///
/// Per-item progress used to be React state on the web's mission pages, so it
/// died on a refresh: someone who did seven of ten comments and came back saw
/// zero of ten. Flutter had the same bug in a different place — `markSent` is
/// in-memory on the engagement controllers, so killing the app resets the day.
///
/// A conversation makes that worse rather than better: a thread that restarts
/// from item one is unusable. So the cleared ids are a server row now, keyed on
/// the user's own day in their own timezone, and this model is what reads it
/// back.
///
/// ## None of it is proof
///
/// LinkedIn tells us nothing back — it cannot be asked whether a comment was
/// posted or an invitation sent, on any scope this app holds. Every id in
/// [PlexaSession] is the user saying they did it. The same honesty the rest of
/// the hand-off surfaces are documented with.

/// Which lane an item belongs to.
///
/// The post has its own pipeline and is deliberately not one of these: it is
/// generated, approved and published by the chain, so it has nothing to clear.
enum PlexaLane {
  comments,
  connections;

  String get wire => name;
}

/// What the user has already cleared today.
@freezed
abstract class PlexaSession with _$PlexaSession {
  const PlexaSession._();

  const factory PlexaSession({
    @Default(<String>[]) List<String> comments,
    @Default(<String>[]) List<String> connections,
  }) = _PlexaSession;

  /// The server nests these under `done`, so this is hand-mapped rather than
  /// generated — `{ done: { comments: [...], connections: [...] } }`.
  factory PlexaSession.fromWire(Map<String, dynamic>? json) {
    final Object? done = json?['done'];
    List<String> lane(String key) {
      if (done is! Map) return const <String>[];
      final Object? v = done[key];
      return v is List
          ? v.whereType<String>().toList(growable: false)
          : const <String>[];
    }

    return PlexaSession(
      comments: lane('comments'),
      connections: lane('connections'),
    );
  }

  List<String> doneIn(PlexaLane lane) =>
      lane == PlexaLane.comments ? comments : connections;

  bool isDone(PlexaLane lane, String itemId) => doneIn(lane).contains(itemId);
}

/// One comment the user can leave on somebody else's post.
@freezed
abstract class PlexaComment with _$PlexaComment {
  const factory PlexaComment({
    @Default('') String id,
    @Default('') String comment,
    @Default('') String searchKeywords,

    /// The KIND of high-reach post this comment fits, not a real post. Nothing
    /// in the product knows which post the user will actually comment on.
    @Default('') String targetPostTitle,
  }) = _PlexaComment;

  factory PlexaComment.fromJson(Map<String, dynamic> json) =>
      _$PlexaCommentFromJson(json);
}

/// One person to reach out to. A role, not a person — the product never sees a
/// real profile.
@freezed
abstract class PlexaConnection with _$PlexaConnection {
  const factory PlexaConnection({
    @Default('') String id,
    @Default('') String role,
    @Default('') String company,
    @Default('') String note,
    @Default('') String searchUrl,

    /// The one card in five that is a DM rather than a connection request —
    /// LinkedIn's free plan caps personalised notes at roughly five a week.
    @Default(false) bool isDirectMessage,
  }) = _PlexaConnection;

  factory PlexaConnection.fromJson(Map<String, dynamic> json) =>
      _$PlexaConnectionFromJson(json);
}

/// One curated Top Voices post, with its comment already written.
@freezed
abstract class PlexaTopVoice with _$PlexaTopVoice {
  const PlexaTopVoice._();

  const factory PlexaTopVoice({
    @Default('') String id,
    @Default('') String postUrl,
    @Default('') String authorName,
    @Default('') String firstLine,
    @Default('') String comment,

    /// This lane carries its own durable stamp rather than relying on the
    /// session map, because the comments screen reads the same rows.
    String? actedAt,
  }) = _PlexaTopVoice;

  factory PlexaTopVoice.fromJson(Map<String, dynamic> json) =>
      _$PlexaTopVoiceFromJson(json);

  bool get isDone => actedAt != null && actedAt!.isNotEmpty;
}

/// One lane of the day.
///
/// [ready] is "has today's work been prepared", NOT "is it done". False means
/// nothing has been generated yet, which is the screen's cue to offer
/// generation — and generating costs XP, which is exactly why the two states
/// are distinguished rather than both rendering as an empty list.
@freezed
abstract class PlexaLaneState<T> with _$PlexaLaneState<T> {
  const factory PlexaLaneState({
    @Default(false) bool ready,
    @Default(<Never>[]) List<T> items,
  }) = _PlexaLaneState<T>;
}

/// Everything one screen needs for the day, in the shape one call returns it.
@freezed
abstract class PlexaDay with _$PlexaDay {
  const PlexaDay._();

  const factory PlexaDay({
    @Default(PlexaSession()) PlexaSession session,
    @Default(PlexaLaneState<PlexaComment>())
    PlexaLaneState<PlexaComment> comments,
    @Default(PlexaLaneState<PlexaConnection>())
    PlexaLaneState<PlexaConnection> connections,
    @Default(PlexaLaneState<PlexaTopVoice>())
    PlexaLaneState<PlexaTopVoice> topVoices,

    /// The topic today's comments were written around.
    @Default('') String topic,
  }) = _PlexaDay;

  /// Hand-mapped: the wire nests lanes under `lanes` and the session under
  /// `done`, and generated `fromJson` for a generic lane type would need a
  /// converter per item type for no gain.
  factory PlexaDay.fromWire(Map<String, dynamic> json) {
    List<T> items<T>(String lane, T Function(Map<String, dynamic>) parse) {
      final Object? lanes = json['lanes'];
      if (lanes is! Map) return <T>[];
      final Object? l = lanes[lane];
      if (l is! Map) return <T>[];
      final Object? raw = l['items'];
      if (raw is! List) return <T>[];
      return raw
          .whereType<Map<String, dynamic>>()
          .map(parse)
          .toList(growable: false);
    }

    bool ready(String lane) {
      final Object? lanes = json['lanes'];
      if (lanes is! Map) return false;
      final Object? l = lanes[lane];
      return l is Map && l['ready'] == true;
    }

    return PlexaDay(
      // A cast, not an `as`. The server's own read never throws — it answers
      // an empty session on a database error so the user still gets a day they
      // can work through — and the client must not be the thing that breaks
      // instead.
      session: PlexaSession.fromWire(
        json['session'] is Map<String, dynamic>
            ? json['session'] as Map<String, dynamic>
            : null,
      ),
      comments: PlexaLaneState<PlexaComment>(
        ready: ready('comments'),
        items: items('comments', PlexaComment.fromJson),
      ),
      connections: PlexaLaneState<PlexaConnection>(
        ready: ready('connections'),
        items: items('connections', PlexaConnection.fromJson),
      ),
      topVoices: PlexaLaneState<PlexaTopVoice>(
        ready: ready('topVoices'),
        items: items('topVoices', PlexaTopVoice.fromJson),
      ),
      topic: json['topic'] as String? ?? '',
    );
  }

  /// How many items the day asks for across every lane.
  int get total =>
      comments.items.length + connections.items.length + topVoices.items.length;

  /// How many are cleared. Top Voices count their own stamp; the other two
  /// read the session.
  int get done =>
      session.comments.length +
      session.connections.length +
      topVoices.items.where((PlexaTopVoice t) => t.isDone).length;

  /// Nothing has been prepared in any lane — a day the user has not started.
  bool get isEmpty => !comments.ready && !connections.ready && !topVoices.ready;
}

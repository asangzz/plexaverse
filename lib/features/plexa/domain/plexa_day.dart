import 'package:freezed_annotation/freezed_annotation.dart';

part 'plexa_day.freezed.dart';
part 'plexa_day.g.dart';

/// Which lane an item belongs to.
///
/// The post has its own pipeline and is deliberately not one of these: it is
/// generated, approved and published by the chain, so it has nothing to hand
/// over.
enum PlexaLane {
  comments,
  connections;

  static PlexaLane parse(String? raw) =>
      raw == 'connections' ? PlexaLane.connections : PlexaLane.comments;

  String get wire => name;

  /// What one of these is called at the head of a line.
  String get noun => this == PlexaLane.comments ? 'Comment' : 'Request';
}

/// One thing to do, flattened from three sources into one shape so the
/// conversation does not have to branch on where it came from.
///
/// Mirrors `DayItem` in the web's `components/automate/PlexaDayChat.tsx`,
/// including [id]'s `tv:` / `nw:` / `cn:` prefixes. Both clients write cleared
/// ids into the same `plexa_day` row, so an id invented here would make a user
/// who worked on the browser and the phone in one day disagree with
/// themselves. The server builds them, for that reason.
@freezed
abstract class DayItem with _$DayItem {
  const DayItem._();

  const factory DayItem({
    @Default('') String id,
    @JsonKey(unknownEnumValue: PlexaLane.comments)
    @Default(PlexaLane.comments)
    PlexaLane lane,

    /// What the user is being pointed at.
    @Default('') String headline,

    /// The sub-line: an author, a company, the context for the headline.
    String? context,

    /// The thing Plexa wrote, copied to the clipboard on open.
    @Default('') String draft,

    /// Where "open" goes.
    @Default('') String url,

    /// Set only for Top Voices rows, which have their own durable stamp.
    String? topVoiceId,
  }) = _DayItem;

  factory DayItem.fromJson(Map<String, dynamic> json) =>
      _$DayItemFromJson(json);

  bool get canOpen => url.isNotEmpty;
}

/// What the user has already cleared today.
@freezed
abstract class PlexaSession with _$PlexaSession {
  const PlexaSession._();

  const factory PlexaSession({
    @Default(<String>[]) List<String> comments,
    @Default(<String>[]) List<String> connections,
  }) = _PlexaSession;

  /// The server nests these under `done`, so this is hand-mapped.
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

  bool isDone(DayItem item) => doneIn(item.lane).contains(item.id);

  PlexaSession withDone(DayItem item, {required bool done}) {
    final List<String> next = List<String>.of(doneIn(item.lane));
    if (done) {
      if (!next.contains(item.id)) next.add(item.id);
    } else {
      next.remove(item.id);
    }
    return item.lane == PlexaLane.comments
        ? copyWith(comments: next)
        : copyWith(connections: next);
  }
}

/// Which lanes have had today's work prepared.
///
/// Not the same question as whether they are finished. `false` means nothing
/// has been generated, which costs XP to fix and needs an offer; an empty list
/// of items means it was generated and cleared. The web never needs this
/// because it generates on open; the mobile route deliberately will not.
@freezed
abstract class PlexaReady with _$PlexaReady {
  const PlexaReady._();

  const factory PlexaReady({
    @Default(false) bool comments,
    @Default(false) bool connections,
    @Default(false) bool topVoices,
  }) = _PlexaReady;

  factory PlexaReady.fromJson(Map<String, dynamic> json) =>
      _$PlexaReadyFromJson(json);

  /// Nothing prepared anywhere — a day the user has not started.
  bool get nothingPrepared => !comments && !connections && !topVoices;
}

/// Everything one conversation needs for the day.
@freezed
abstract class PlexaDay with _$PlexaDay {
  const PlexaDay._();

  const factory PlexaDay({
    @Default(PlexaSession()) PlexaSession session,
    @Default(<DayItem>[]) List<DayItem> items,
    @Default(PlexaReady()) PlexaReady ready,

    /// The topic today's comments were written around.
    @Default('') String topic,
  }) = _PlexaDay;

  factory PlexaDay.fromWire(Map<String, dynamic> json) {
    final Object? rawItems = json['items'];
    return PlexaDay(
      // A check, not an `as`. The server's own read never throws — it answers
      // an empty session on a database error so the user still gets a day they
      // can work through — and the client must not be the thing that breaks
      // instead.
      session: PlexaSession.fromWire(
        json['session'] is Map<String, dynamic>
            ? json['session'] as Map<String, dynamic>
            : null,
      ),
      items: rawItems is List
          ? rawItems
                .whereType<Map<String, dynamic>>()
                .map(DayItem.fromJson)
                .toList(growable: false)
          : const <DayItem>[],
      ready: json['ready'] is Map<String, dynamic>
          ? PlexaReady.fromJson(json['ready'] as Map<String, dynamic>)
          : const PlexaReady(),
      topic: json['topic'] as String? ?? '',
    );
  }

  int get clearedCount => items.where(session.isDone).length;

  List<DayItem> inLane(PlexaLane lane) =>
      items.where((DayItem i) => i.lane == lane).toList(growable: false);
}

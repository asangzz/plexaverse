import 'package:freezed_annotation/freezed_annotation.dart';

part 'topic.freezed.dart';
part 'topic.g.dart';

/// A reusable content seed. Mirrors the `Topic` row in `prisma/schema.prisma`
/// and the `Topic` interface in the web's `app/(dashboard)/topics/page.tsx`.
///
/// A topic is not a post and not a plan: it is the prompt seed a **schedule**
/// resolves when it fires (`schedule → topic → name + description + keywords
/// → generation`). That is why [scheduleCount] travels with the row — the
/// server sends a `_count` rather than the schedules themselves precisely
/// because the only thing any UI does with them is count them.
@freezed
abstract class Topic with _$Topic {
  const Topic._();

  const factory Topic({
    required String id,
    @Default('') String name,

    /// Nullable in the schema and genuinely optional in the UI — the web hides
    /// the paragraph entirely when it is absent rather than printing a blank.
    String? description,

    @Default(<String>[]) List<String> keywords,

    /// The server defaults this to true on create. Nothing in the web UI can
    /// change it; the card shows it as an Active / Inactive pill and that is
    /// all. See `TopicsRepository.setActive` for why the endpoint still exists.
    @Default(true) bool isActive,

    /// ISO timestamp. The list arrives newest-first from the server, so the
    /// client never sorts on this.
    String? createdAt,

    /// How many schedules point at this topic.
    ///
    /// Prisma nests it as `_count.schedules`, which no key name can reach, so
    /// a `readValue` digs it out. Flattening it beats modelling a `_count`
    /// wrapper for a single integer that only ever gets counted.
    @JsonKey(readValue: _readScheduleCount) @Default(0) int scheduleCount,
  }) = _Topic;

  factory Topic.fromJson(Map<String, dynamic> json) => _$TopicFromJson(json);
}

/// Reads `_count.schedules`, or null when the server sent no `_count` at all —
/// which is what `POST /topics` does, since a topic one request old cannot
/// have a schedule yet.
Object? _readScheduleCount(Map<dynamic, dynamic> json, String key) {
  final Object? count = json['_count'];
  return count is Map ? count['schedules'] : null;
}

/// One of the three topics `POST /ai/suggest-topics` proposes.
///
/// Deliberately a different type from [Topic]: a suggestion has no id, has
/// never been stored, and disappears the moment the user adds it or leaves the
/// screen. Giving it the same type would make "has this been saved?" a
/// question about a nullable id rather than about which list it is in.
@freezed
abstract class SuggestedTopic with _$SuggestedTopic {
  const factory SuggestedTopic({
    @Default('') String name,
    @Default('') String description,
    @Default(<String>[]) List<String> keywords,
  }) = _SuggestedTopic;

  factory SuggestedTopic.fromJson(Map<String, dynamic> json) =>
      _$SuggestedTopicFromJson(json);
}

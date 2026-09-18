import 'package:freezed_annotation/freezed_annotation.dart';

part 'inbox_comment.freezed.dart';
part 'inbox_comment.g.dart';

/// LinkedIn's six reaction types, and the two labels each one carries.
///
/// The web renders these with an emoji prefix ("👍 Like", "❤️ Loved").
/// **The emoji are deliberately dropped here.** Zave's first rule is that
/// colour only ever names a status, and a red heart and a yellow hand inside a
/// glass pill are decorative colour competing with the [ZaveDot] that actually
/// carries the state. The words are transcribed exactly; only the glyphs go.
enum CommentReaction {
  like('LIKE', 'Like', 'Liked'),
  praise('PRAISE', 'Celebrate', 'Celebrated'),
  empathy('EMPATHY', 'Love', 'Loved'),
  interest('INTEREST', 'Insightful', 'Insightful'),
  appreciation('APPRECIATION', 'Support', 'Supported'),
  entertainment('ENTERTAINMENT', 'Funny', 'Funny');

  const CommentReaction(this.wire, this.idleLabel, this.doneLabel);

  /// The value the API expects. The server validates against exactly this set
  /// and 400s on anything else, so it is never built from free text.
  final String wire;

  /// What the button says before it is tapped.
  final String idleLabel;

  /// What it says once the reaction landed.
  final String doneLabel;

  /// Unknown or absent → [like]. The server's own default is LIKE, and a
  /// suggestion we cannot read must not block the user from reacting at all.
  static CommentReaction parse(String? raw) {
    final String key = (raw ?? '').trim().toUpperCase();
    for (final CommentReaction r in CommentReaction.values) {
      if (r.wire == key) return r;
    }
    return CommentReaction.like;
  }
}

/// One inbound comment on a company post, with its AI-drafted reply.
///
/// The listing endpoint filters out comments we have already replied to, so
/// everything here is outstanding work. The draft is generated in ONE batched
/// model call for the whole thread — if that call fails the server still ships
/// the listing with a generic fallback body, so an empty [suggestedReply] means
/// the comment had no text, not that drafting broke.
@freezed
abstract class InboxComment with _$InboxComment {
  const InboxComment._();

  const factory InboxComment({
    required String id,
    @Default('') String text,

    /// Epoch milliseconds. The server defaults it to "now" when LinkedIn omits
    /// the timestamp, so it is non-nullable.
    @Default(0) int createdAt,
    @Default('') String suggestedReply,
    @Default('LIKE') String suggestedReaction,
  }) = _InboxComment;

  factory InboxComment.fromJson(Map<String, dynamic> json) =>
      _$InboxCommentFromJson(json);

  CommentReaction get reaction => CommentReaction.parse(suggestedReaction);

  DateTime get receivedAt => DateTime.fromMillisecondsSinceEpoch(createdAt);

  /// The commenter's name is NOT on the wire.
  ///
  /// The endpoint returns LinkedIn's raw `actor` URN and no display name, and
  /// resolving a member profile from a URN needs Partner-Program access we do
  /// not have. The web reads a `comment.authorName` that the API never sends,
  /// so it renders its fallback on every row — which is what we render too,
  /// honestly and on purpose.
  static const String authorFallback = 'Audience Member';
}

/// One entry of the reply batch's `results` array.
///
/// The batch endpoint never aborts on a bad entry: it reports per-reply, so a
/// partial failure has to be surfaced as such rather than as "it worked" or
/// "it all failed".
@freezed
abstract class ReplyOutcome with _$ReplyOutcome {
  const factory ReplyOutcome({
    required String targetUrn,
    @Default(false) bool success,
    String? error,
  }) = _ReplyOutcome;

  factory ReplyOutcome.fromJson(Map<String, dynamic> json) =>
      _$ReplyOutcomeFromJson(json);
}

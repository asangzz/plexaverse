import 'package:freezed_annotation/freezed_annotation.dart';

part 'comment_draft.freezed.dart';
part 'comment_draft.g.dart';

/// One AI-drafted comment the user leaves on somebody ELSE's post.
///
/// The web counterpart is the `CommentGen` interface in
/// `app/(dashboard)/comments/page.tsx`. The wire shape is whatever
/// `generateComments()` in `lib/services/ai.service.ts` produces:
/// `{ comment, targetPostTitle, searchKeywords }`.
///
/// [targetPostTitle] is deliberately NOT a real post — it is the KIND of
/// high-reach post this comment fits ("a hiring-manager post about résumé
/// screening"). Nothing in the product knows which post the user will actually
/// comment on, and pretending otherwise would be the kind of fabricated record
/// this screen has no business showing.
///
/// [isSent] and [taughtText] are local-only. The server has no per-comment
/// state — a comment is "sent" the moment the user copies it, exactly as on the
/// web, because copying is the last thing this app can observe before the user
/// leaves for LinkedIn.
@freezed
abstract class CommentDraft with _$CommentDraft {
  const CommentDraft._();

  const factory CommentDraft({
    @Default('') String comment,
    @Default('') String targetPostTitle,
    @Default('') String searchKeywords,

    /// Copied at least once. Purely local; see the class doc.
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default(false)
    bool isSent,

    /// The last text this draft taught to `/ai/style-memory`.
    ///
    /// Seeded with the generated [comment] when the batch lands, so an
    /// untouched draft never teaches the model its own output back. Only a
    /// genuine user edit differs from it — which is the one thing worth
    /// learning from.
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default('')
    String taughtText,
  }) = _CommentDraft;

  factory CommentDraft.fromJson(Map<String, dynamic> json) =>
      _$CommentDraftFromJson(json);

  /// LinkedIn's own comment ceiling, and the length the prompt asks for.
  static const int charLimit = 300;

  bool get hasText => comment.trim().isNotEmpty;

  /// The user has rewritten this since it was generated (or since the last
  /// time we taught it), so it is worth sending to style memory.
  bool get isWorthTeaching =>
      comment.trim().isNotEmpty && comment != taughtText;
}

/// A day's batch of comments.
///
/// [cached] is the whole reason this screen is cheap to reopen: the server
/// stores one batch per user per day and replays it for free. Only an explicit
/// "new set" spends XP again — and that path does not exist on mobile yet, see
/// `ApiEngagementRepository.generateComments`.
@freezed
abstract class CommentBatch with _$CommentBatch {
  const CommentBatch._();

  const factory CommentBatch({
    @Default(<CommentDraft>[]) List<CommentDraft> comments,

    /// The topic the SERVER picked from the user's niche. There is no manual
    /// topic entry — the web's topic field is unreachable in practice because
    /// the page auto-generates on mount.
    @Default('') String topic,

    /// True when this is today's stored batch, replayed at no cost.
    @Default(false) bool cached,

    /// What a fresh batch would cost. Null until the server has priced one.
    int? xpCost,
  }) = _CommentBatch;

  factory CommentBatch.fromJson(Map<String, dynamic> json) =>
      _$CommentBatchFromJson(json);

  int get sentCount => comments.where((CommentDraft c) => c.isSent).length;

  bool get isEmpty => comments.isEmpty;
}

import 'package:freezed_annotation/freezed_annotation.dart';

part 'calendar_post.freezed.dart';
part 'calendar_post.g.dart';

/// A post's lifecycle, as the calendar reads it.
///
/// Mirrors `StatusKey` in the web's `app/(dashboard)/calendar/calendar-utils.ts`
/// and the `status` column on `Post`. The wire values are snake_case strings —
/// `pending_approval` in particular — so each constant carries an explicit
/// [JsonValue]; renaming a Dart constant must never change what goes on the
/// wire.
///
/// Anything the server sends that is not in this list decodes to [draft], which
/// is the web's own fallback (`STATUS_META[status] ?? STATUS_META.draft`).
enum CalendarPostStatus {
  /// Not scheduled yet. Lives in the pending rail.
  @JsonValue('draft')
  draft,

  /// Waiting on the user's approval before it can publish.
  @JsonValue('pending_approval')
  pendingApproval,

  /// Approved — queued for publish.
  @JsonValue('approved')
  approved,

  /// Queued; Cloud Tasks will publish it on its own.
  @JsonValue('scheduled')
  scheduled,

  /// Live on LinkedIn.
  @JsonValue('published')
  published,

  /// The publish attempt failed.
  @JsonValue('failed')
  failed;

  /// Tolerant parse for the places we read a bare string (a PATCH echo, a
  /// fixture). Unknown → [draft], matching the web.
  static CalendarPostStatus parse(String? raw) => switch (raw) {
    'pending_approval' => CalendarPostStatus.pendingApproval,
    'approved' => CalendarPostStatus.approved,
    'scheduled' => CalendarPostStatus.scheduled,
    'published' => CalendarPostStatus.published,
    'failed' => CalendarPostStatus.failed,
    _ => CalendarPostStatus.draft,
  };

  /// The string the server expects back.
  String get wire => switch (this) {
    CalendarPostStatus.draft => 'draft',
    CalendarPostStatus.pendingApproval => 'pending_approval',
    CalendarPostStatus.approved => 'approved',
    CalendarPostStatus.scheduled => 'scheduled',
    CalendarPostStatus.published => 'published',
    CalendarPostStatus.failed => 'failed',
  };

  /// The label the web shows, verbatim from `STATUS_META`.
  String get label => switch (this) {
    CalendarPostStatus.draft => 'Draft',
    CalendarPostStatus.pendingApproval => 'Awaiting approval',
    CalendarPostStatus.approved => 'Approved',
    CalendarPostStatus.scheduled => 'Scheduled',
    CalendarPostStatus.published => 'Published',
    CalendarPostStatus.failed => 'Failed',
  };

  /// The one-line explanation, verbatim from `STATUS_META`.
  String get description => switch (this) {
    CalendarPostStatus.draft => 'Not scheduled yet',
    CalendarPostStatus.pendingApproval => 'Waiting on your approval to publish',
    CalendarPostStatus.approved => 'Approved — queued for publish',
    CalendarPostStatus.scheduled => 'Queued — will publish automatically',
    CalendarPostStatus.published => 'Live on LinkedIn',
    CalendarPostStatus.failed => 'Publish failed — see details',
  };

  /// A published post is frozen. The server refuses to edit one
  /// (`PostServiceError('CONFLICT', 'Cannot edit a published post')`), so the
  /// UI must not offer "move to…" on it — an action that can only fail is
  /// worse than no action.
  bool get isMovable => this != CalendarPostStatus.published;
}

/// One post as the calendar needs it.
///
/// ## Why this is not the web's `CalendarPost` field-for-field
///
/// The web calls `GET /api/calendar/posts`, a purpose-built endpoint that
/// returns two pre-bucketed lists of a trimmed shape. **The mobile API has no
/// such route**, so this model is decoded from `GET /posts` (`ListedPost` in
/// `lib/services/post.service.ts`) and bucketed on the client by
/// [splitCalendarBuckets]. Two fields the web renders therefore arrive null on
/// mobile and are documented individually below.
///
/// `imageUrl` is deliberately ABSENT from this model. Some legacy rows store a
/// multi-megabyte `data:image/...;base64` string in that column, and the web's
/// calendar payload strips it for exactly that reason. `ListedPost` does not
/// strip it, so the safe thing is to make it unrepresentable here rather than
/// to trust every future call site to remember.
@freezed
abstract class CalendarPost with _$CalendarPost {
  const CalendarPost._();

  const factory CalendarPost({
    required String id,
    String? title,
    @Default('') String content,

    /// The tiny (~5–15 KB) thumbnail. Decoded but **not rendered yet** — see
    /// `CalendarPostTile`: `/posts` does not apply the `data:` guard that
    /// `/api/calendar/posts` does, so a base64 blob can still arrive here and
    /// `Image.network` cannot load one.
    String? imageThumbUrl,

    @JsonKey(unknownEnumValue: CalendarPostStatus.draft)
    @Default(CalendarPostStatus.draft)
    CalendarPostStatus status,

    DateTime? scheduledFor,
    DateTime? publishedAt,
    String? linkedinUrl,

    /// Why the publish failed. **Always null on mobile** — `ListedPost` does
    /// not select it. The row still renders; it simply cannot explain itself.
    String? failureReason,

    /// When it failed. Always null on mobile, same reason as [failureReason].
    DateTime? failedAt,

    DateTime? createdAt,
  }) = _CalendarPost;

  factory CalendarPost.fromJson(Map<String, dynamic> json) =>
      _$CalendarPostFromJson(json);

  /// The instant the grid files this post under.
  ///
  /// `scheduledFor ?? publishedAt`, exactly as the web's `groupByDay` does. A
  /// post with neither is not on the calendar at all.
  DateTime? get calendarDate => scheduledFor ?? publishedAt;

  /// What a chip or row shows — the title if there is one, else the body.
  /// Matches the web's `truncate(post.title || post.content, …)`.
  String get displayText {
    final String? t = title?.trim();
    if (t != null && t.isNotEmpty) return t;
    return content.trim();
  }
}

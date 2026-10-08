import 'package:freezed_annotation/freezed_annotation.dart';

part 'compose_draft.freezed.dart';

/// The voice the AI writes in. Mirrors the web composer's `generateTone`
/// union; the wire value is the enum name verbatim.
enum ComposeTone {
  professional,
  casual,
  inspirational,
  educational;

  String get wire => name;

  /// Sentence case for the chip, matching the web's `capitalize` class.
  String get label => '${name[0].toUpperCase()}${name.substring(1)}';
}

/// How long the generated post should be.
///
/// The web hardcoded this to `medium` at the call site for a long time with no
/// control, which meant short and long were unreachable from the browser while
/// the service default was `long` — web and mobile were quietly producing
/// different-sized posts. The control exists on both now; do not re-hardcode it.
enum ComposeLength {
  short,
  medium,
  long;

  String get wire => name;

  String get label => '${name[0].toUpperCase()}${name.substring(1)}';
}

/// The image attached to the post.
///
/// Exactly one of [dataUri] and [url] is meaningful at a time, and which one it
/// is decides what happens at save:
///
///   • [dataUri] — an AI poster, still inline as `data:image/jpeg;base64,…`.
///     It has to go through `POST /upload/image` before the post is saved, or
///     the row would carry a multi-megabyte base64 blob that every list view
///     then has to download.
///   • [url] — already in storage. Saved as-is, exactly as the web does
///     ("already a URL (regenerated AI image) — no thumb available").
@freezed
abstract class ComposeImage with _$ComposeImage {
  const ComposeImage._();

  const factory ComposeImage({
    String? dataUri,
    String? url,

    /// Drives the "AI generated" badge and whether Regenerate is offered.
    @Default(true) bool aiGenerated,
  }) = _ComposeImage;

  bool get hasPreview => dataUri != null || url != null;

  /// True when this image still has to be uploaded before the post is saved.
  bool get needsUpload => dataUri != null;
}

/// The prompt the last poster was generated from.
///
/// Kept verbatim so Regenerate reproduces the same brief — the web stores it in
/// `lastImagePrompt` for exactly this reason. Without it a regenerate would
/// silently drop the poster title and the user's name from the badge, and the
/// second poster would not look like it belonged to the first.
@freezed
abstract class PosterPrompt with _$PosterPrompt {
  const factory PosterPrompt({
    @Default('') String topic,
    @Default('') String content,
    String? posterTitle,
    String? userName,
    String? profileImageUrl,
    String? category,

    /// The poster style the user picked, or null for "no style" — the default,
    /// and what every poster looked like before the reference library existed.
    ///
    /// It belongs on the prompt rather than beside it so Regenerate reapplies
    /// it without any extra plumbing. The point of storing the brief verbatim
    /// is that the second poster belongs to the same family as the first, and a
    /// style that survived only the first call would break exactly that.
    String? posterTag,
  }) = _PosterPrompt;
}

/// Everything the user has typed or generated but not yet committed.
///
/// This is the mobile counterpart of `PostEditor`'s local `useState` cluster in
/// `components/automate/PostEditor.tsx`. It deliberately holds no server state:
/// the LinkedIn accounts and the brand live in [ComposeContextState], which is
/// fetched, and this is the part that is purely the user's.
@freezed
abstract class ComposeDraft with _$ComposeDraft {
  const ComposeDraft._();

  const factory ComposeDraft({
    @Default('') String title,
    @Default('') String content,
    ComposeImage? image,

    /// "Schedule for later". Off means publish through the normal approval
    /// path as soon as it is approved.
    @Default(false) bool scheduled,

    /// The day, at midnight. Null until the user picks one — a scheduled post
    /// with no date is not submittable, which is why [scheduledFor] returns
    /// null rather than guessing today.
    DateTime? date,

    /// 'HH:mm', 24-hour. The web's default is 09:00 and so is this.
    @Default('09:00') String time,

    /// Which LinkedIn connection publishes this. Null falls back to the
    /// context's active account at save time.
    String? accountId,

    /// Reused verbatim by Regenerate — see [PosterPrompt].
    PosterPrompt? lastPosterPrompt,
  }) = _ComposeDraft;

  /// LinkedIn's own limit, and the same number the web uses everywhere.
  static const int charLimit = 3000;

  /// The web turns the counter amber at 90% of the limit. Named rather than
  /// written as `0.9 * charLimit` at the call site so the two platforms can be
  /// compared by grep.
  static const int charWarnAt = 2700;

  /// `String.length` on purpose, not `characters.length`: the server and the
  /// web both count UTF-16 code units, and a counter that disagreed with the
  /// limit the server enforces would be worse than no counter.
  int get charCount => content.length;

  bool get nearLimit => charCount > charWarnAt;

  bool get isEmpty => content.trim().isEmpty && title.trim().isEmpty;

  /// The web disables its primary action on `!content.trim()`.
  bool get canSubmit => content.trim().isNotEmpty;

  /// The local wall-clock instant this post should go out at, or null when the
  /// user has not asked for one.
  ///
  /// Built in LOCAL time and converted at the network boundary. The user picks
  /// "Tuesday 9:00 AM" meaning their own 9am; constructing this in UTC would
  /// publish it at the wrong hour for everyone outside UTC, which is every
  /// user this product has.
  DateTime? get scheduledFor {
    if (!scheduled || date == null) return null;
    final List<String> parts = time.split(':');
    final int hour = parts.isEmpty ? 9 : (int.tryParse(parts.first) ?? 9);
    final int minute = parts.length < 2 ? 0 : (int.tryParse(parts[1]) ?? 0);
    return DateTime(date!.year, date!.month, date!.day, hour, minute);
  }
}

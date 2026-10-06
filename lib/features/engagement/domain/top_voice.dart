import 'package:characters/characters.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'top_voice.freezed.dart';
part 'top_voice.g.dart';

/// One of today's curated posts, and the comment Plexa drafted for it.
///
/// Mirrors `DailyTopVoice` in `lib/services/top-voices.service.ts` field for
/// field. Unlike [CommentDraft], whose `isSent` is purely local, the done-state
/// here is SERVER-side: [actedAt] is a column on `TopVoiceShown`, stamped the
/// moment the user opens the post to comment on it, and it is the closest
/// thing to proof of the action the product has. That is why this half of the
/// comments screen survives a kill and the other half does not.
///
/// ## Why the post body is here at all
///
/// The user is about to land on the real thing. Showing it in the shape they
/// will see it in means they recognise it on arrival instead of scanning a
/// feed for a summary they half-remember. [postContent] is a ~170-character
/// summary written at import time, not the whole post, which is what keeps a
/// day's five at a few kilobytes.
@freezed
abstract class TopVoice with _$TopVoice {
  const TopVoice._();

  const factory TopVoice({
    /// The `TopVoiceShown` row id. This is what gets stamped, and what Open
    /// Plexa sends as `topVoiceId` — the two surfaces must agree on it or they
    /// disagree about the same five posts.
    @Default('') String shownId,

    /// The `TopVoicePost` id. Not used for anything the client decides; kept
    /// because the wire carries it and dropping a field silently is how a
    /// model and its server drift.
    @Default('') String postId,

    @Default('') String postUrl,
    @Default('') String authorName,
    @Default('') String authorHandle,

    /// One of the forty ids in `core/engagement/top_voice_categories.dart`.
    @Default('') String category,

    @Default('') String postContent,

    /// The post's opening line, when the import captured one. Rendered as the
    /// headline above the body.
    String? firstLine,

    /// ISO 8601. Rendered as LinkedIn's own shorthand — "2h", "3d".
    @Default('') String postedAt,

    /// Null when the batch generated but this one's comment did not come back.
    /// The row is still the user's for the day — losing the pick would hand
    /// them the same post tomorrow and charge for it twice — so the card has
    /// to render without a draft.
    String? comment,

    /// ISO 8601 when the user opened this to comment. Null means outstanding.
    String? actedAt,
  }) = _TopVoice;

  factory TopVoice.fromJson(Map<String, dynamic> json) =>
      _$TopVoiceFromJson(json);

  bool get isActed => actedAt != null;

  bool get hasComment => (comment ?? '').trim().isNotEmpty;

  /// The headline, falling back to the body when the import caught no opener.
  String get headline {
    final String first = (firstLine ?? '').trim();
    if (first.isNotEmpty) return first;
    return postContent.length > 120
        ? '${postContent.substring(0, 120)}…'
        : postContent;
  }

  /// "2h", "3d" — the shorthand LinkedIn itself prints above a post.
  ///
  /// Takes [now] so a test does not have to wait. Returns an empty string for
  /// an unparseable stamp rather than guessing, because a wrong age above a
  /// real post reads as the product being confused about which post it means.
  String age({DateTime? now}) {
    final DateTime? at = DateTime.tryParse(postedAt);
    if (at == null) return '';
    final int mins = (now ?? DateTime.now()).difference(at).inMinutes;
    if (mins < 0) return '';
    if (mins < 60) return '${mins}m';
    if (mins < 1440) return '${(mins / 60).round()}h';
    return '${(mins / 1440).round()}d';
  }

  /// Up to two initials, for the avatar disc.
  String get initials {
    final List<String> words = authorName.trim().split(RegExp(r'\s+'))
      ..removeWhere((String w) => w.isEmpty);
    if (words.isEmpty) return '?';
    return words
        .take(2)
        .map((String w) => w.characters.first.toUpperCase())
        .join();
  }
}

/// Today's curated set, and why it might be empty.
///
/// The two empties need different answers and the server tells them apart:
/// a user who has never opened the subject picker can fix their day in one
/// screen, and a user whose subjects are thinly stocked cannot fix it at all.
/// Showing the first message to the second user is the kind of dead end that
/// makes a screen feel broken.
@freezed
abstract class TopVoiceDay with _$TopVoiceDay {
  const TopVoiceDay._();

  const factory TopVoiceDay({
    @Default(<TopVoice>[]) List<TopVoice> posts,

    /// False only when the user has chosen no subjects at all.
    @Default(true) bool hasCategories,
  }) = _TopVoiceDay;

  factory TopVoiceDay.fromJson(Map<String, dynamic> json) =>
      _$TopVoiceDayFromJson(json);

  int get actedCount => posts.where((TopVoice p) => p.isActed).length;

  bool get isEmpty => posts.isEmpty;

  /// The index of the first post still outstanding, or 0 when the day is done.
  int get firstOutstanding {
    final int i = posts.indexWhere((TopVoice p) => !p.isActed);
    return i == -1 ? 0 : i;
  }

  TopVoiceDay withActed(String shownId) => copyWith(
    posts: posts
        .map(
          (TopVoice p) => p.shownId == shownId && !p.isActed
              // A local stamp standing in for the server's, so the count moves
              // on the tap rather than on the round trip. The value is only
              // ever read as "is this null", so its precision does not matter.
              ? p.copyWith(actedAt: DateTime.now().toUtc().toIso8601String())
              : p,
        )
        .toList(growable: false),
  );
}

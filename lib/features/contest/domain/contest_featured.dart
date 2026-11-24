import 'package:freezed_annotation/freezed_annotation.dart';

part 'contest_featured.freezed.dart';
part 'contest_featured.g.dart';

// The contest shoutout (owner, 22 Nov 2026: the prize of every contest is a
// profile shoutout). Mirrors the web's `lib/contest-featured-types.ts` — the
// bodies of `GET /contest/featured` and `GET/PUT /contest/shoutout`.
//
// WHAT A FEATURED PERSON NEVER CARRIES
//   No user id, no contest XP, no rank — and, for the week's learners, no
//   position. The board stays hidden until the contest's last days, and a
//   card that leaked any of those would be the board by another name. There
//   is no field here to put one in. The Hall of Fame's winners carry a rank
//   only when they also agreed to be named on the leaderboard.

/// Where "Learners of the week" stands for the viewer. Mirrors the web's
/// `LearnersOfWeek['state']`.
///
/// An unknown state reads as [none]: show nothing. A state this build cannot
/// interpret must never draw people the server did not mean to show.
enum LearnersOfWeekState {
  /// No running contest, or the viewer is not in it.
  none,

  /// Today's lesson is not finished yet — the card waits for it.
  @JsonValue('after_lesson')
  afterLesson,

  /// The contest has no completed Sunday→Saturday week yet.
  @JsonValue('no_week')
  noWeek,

  /// The week and up to ten consenting learners, in no order.
  ready,
}

/// One person a card shows — only someone who agreed to be featured
/// (`contest_shoutout`).
@freezed
abstract class FeaturedPerson with _$FeaturedPerson {
  const factory FeaturedPerson({
    /// A stable key for today; derived from no figure and reversible to no id.
    @Default('') String key,
    @Default('') String name,

    /// An https photo link, or null.
    String? image,
    String? headline,

    /// `https://www.linkedin.com/in/<slug>`, or null. Re-checked with
    /// `profileHref` before it is ever opened.
    String? linkedinUrl,
  }) = _FeaturedPerson;

  factory FeaturedPerson.fromJson(Map<String, dynamic> json) =>
      _$FeaturedPersonFromJson(json);
}

/// "Learners of the week" for the viewer, right now.
@freezed
abstract class LearnersOfWeek with _$LearnersOfWeek {
  const LearnersOfWeek._();

  const factory LearnersOfWeek({
    @JsonKey(unknownEnumValue: LearnersOfWeekState.none)
    @Default(LearnersOfWeekState.none)
    LearnersOfWeekState state,

    /// The week's Sunday and Saturday, `YYYY-MM-DD` in the contest's
    /// timezone. Empty unless [state] is ready.
    @Default('') String weekStart,
    @Default('') String weekEnd,

    /// In the day's shuffle — an order that says nothing about who scored
    /// more. Never numbered, never sorted.
    @Default(<FeaturedPerson>[]) List<FeaturedPerson> learners,
  }) = _LearnersOfWeek;

  factory LearnersOfWeek.fromJson(Map<String, dynamic> json) =>
      _$LearnersOfWeekFromJson(json);

  /// The card draws: ready, with someone in it. Before the lesson is done
  /// there is no teaser — the card must never read as a step the lesson
  /// leads to.
  bool get shows => state == LearnersOfWeekState.ready && learners.isNotEmpty;
}

/// A winner in the Hall of Fame: their profile, and the place they finished
/// in — null for a winner who declined to be named on the leaderboard, who is
/// shown without one (and after the placed winners, in the server's daily
/// shuffle). The web's `HallOfFameWinner extends FeaturedPerson`, flattened as
/// the wire sends it.
@freezed
abstract class HallOfFameWinner with _$HallOfFameWinner {
  const HallOfFameWinner._();

  const factory HallOfFameWinner({
    /// The place, or null: never drawn as a number then.
    int? rank,
    @Default('') String key,
    @Default('') String name,
    String? image,
    String? headline,
    String? linkedinUrl,
  }) = _HallOfFameWinner;

  factory HallOfFameWinner.fromJson(Map<String, dynamic> json) =>
      _$HallOfFameWinnerFromJson(json);

  /// The profile, as a tile draws it.
  FeaturedPerson get person => FeaturedPerson(
    key: key,
    name: name,
    image: image,
    headline: headline,
    linkedinUrl: linkedinUrl,
  );
}

/// One finalised round, for the 30 days after its result was fixed.
@freezed
abstract class HallOfFameEntry with _$HallOfFameEntry {
  const factory HallOfFameEntry({
    @Default('') String contestId,

    /// The admin's own name for the round. Never shown: a round is named by
    /// its dates ([lastDayKey]), as on the web (owner, 24 Nov 2026).
    @Default('') String title,

    /// The round's last playable day, `YYYY-MM-DD` in its timezone — "the
    /// round that ended 23 February 2027". Empty from a server before it.
    @Default('') String lastDayKey,
    @Default('') String prizeTitle,
    @Default(0) int rewardTopN,

    /// Instants — shown on the viewer's clock.
    required DateTime finalisedAt,
    required DateTime featuredUntil,

    /// Only the winners who agreed to be featured: the placed ones in place
    /// order, then the unplaced in the server's shuffle.
    @Default(<HallOfFameWinner>[]) List<HallOfFameWinner> winners,
  }) = _HallOfFameEntry;

  factory HallOfFameEntry.fromJson(Map<String, dynamic> json) =>
      _$HallOfFameEntryFromJson(json);
}

/// `GET /contest/featured` → `{week, hallOfFame}`, bare inside `data`.
@freezed
abstract class ContestFeatured with _$ContestFeatured {
  const factory ContestFeatured({
    @Default(LearnersOfWeek()) LearnersOfWeek week,
    @Default(<HallOfFameEntry>[]) List<HallOfFameEntry> hallOfFame,

    /// The viewer placed in a contest whose Hall of Fame is showing —
    /// consented or not. The page then offers them the "Feature me" card even
    /// outside that contest: by the time a result is fixed the page has
    /// usually moved on, and the prize is only theirs if they say yes.
    @Default(false) bool viewerPlaced,
  }) = _ContestFeatured;

  factory ContestFeatured.fromJson(Map<String, dynamic> json) =>
      _$ContestFeaturedFromJson(json);
}

/// `GET/PUT /contest/shoutout` → the viewer's own "Feature me if I make it"
/// choice.
@freezed
abstract class ShoutoutSettings with _$ShoutoutSettings {
  const factory ShoutoutSettings({
    /// Whether the `contest_shoutout` consent is in force. False until they
    /// agree: the box is drawn from this, so it is never pre-ticked.
    @Default(false) bool featured,

    /// The profile link on record, or null. Erased when [featured] is
    /// switched off.
    String? linkedinUrl,

    /// Whether "I am 18 or older" is on record. False: the card asks for the
    /// tick with the link, and sends it (`adult: true`).
    @Default(false) bool adultDeclared,

    /// True only when the learner said yes under words that have since
    /// changed: [featured] is false, and the card says why
    /// (`kShoutoutStaleLine`) instead of looking as if the yes never saved.
    /// Absent from the server's answer otherwise.
    @Default(false) bool stale,
  }) = _ShoutoutSettings;

  factory ShoutoutSettings.fromJson(Map<String, dynamic> json) =>
      _$ShoutoutSettingsFromJson(json);
}

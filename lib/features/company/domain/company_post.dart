import 'package:freezed_annotation/freezed_annotation.dart';

part 'company_post.freezed.dart';
part 'company_post.g.dart';

/// Share statistics for one company post, as LinkedIn returns them merged
/// with our own computed [engagementRate].
///
/// `engagement` and `engagementRate` arrive as JSON numbers that are integer
/// `0` on a post with no impressions and fractional otherwise, so both are
/// modelled as `double` — json_serializable emits `(json[…] as num).toDouble()`
/// for a double field, which reads either shape without throwing.
@freezed
abstract class CompanyPostStats with _$CompanyPostStats {
  const factory CompanyPostStats({
    @Default(0) int impressionCount,
    @Default(0) int clickCount,
    @Default(0) int likeCount,
    @Default(0) int commentCount,
    @Default(0) int shareCount,
    @Default(0) double engagement,
    @Default(0) double engagementRate,
  }) = _CompanyPostStats;

  factory CompanyPostStats.fromJson(Map<String, dynamic> json) =>
      _$CompanyPostStatsFromJson(json);
}

/// One recently-published company post.
///
/// `GET /linkedin/posts` returns at most ten (LinkedIn's own cap) and merges
/// three sources: the post itself, its share statistics, and our local
/// advocacy flag. [isAdvocated] is therefore Plexaverse state, not LinkedIn
/// state — nothing on LinkedIn knows a post is "featured for advocacy".
@freezed
abstract class CompanyPostItem with _$CompanyPostItem {
  const CompanyPostItem._();

  const factory CompanyPostItem({
    required String id,
    @Default('') String text,

    /// Epoch milliseconds. LinkedIn sends a number; the field is absent on
    /// posts whose `createdAt` was not a number, which is why it is nullable.
    int? createdAt,
    @Default(false) bool isAdvocated,
    String? advocacyExpiry,
    @Default(CompanyPostStats()) CompanyPostStats stats,
  }) = _CompanyPostItem;

  factory CompanyPostItem.fromJson(Map<String, dynamic> json) =>
      _$CompanyPostItemFromJson(json);

  DateTime? get publishedOn => createdAt == null
      ? null
      : DateTime.fromMillisecondsSinceEpoch(createdAt!);

  /// The post URN is the id. Named so the call sites that pass it to the
  /// comments and advocacy endpoints read as what they are.
  String get urn => id;

  bool get hasComments => stats.commentCount > 0;
}

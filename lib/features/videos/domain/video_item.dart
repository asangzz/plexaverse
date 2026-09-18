import 'package:freezed_annotation/freezed_annotation.dart';

part 'video_item.freezed.dart';
part 'video_item.g.dart';

/// A single row on the Videos tab (screenshot 2354): thumbnail + title +
/// date line + optional gold status badge ("Avatar IV" / "Draft") and an
/// optional duration chip rendered inside the thumbnail ("00:08").
///
/// The labels are pre-formatted display strings on the wire (`dateLabel`
/// "July 04, 2026", `durationLabel` "00:08") — the list renders them
/// verbatim, mirroring how the HeyGen reference presents them. Keys are
/// camelCase per the project json_serializable convention
/// (`field_rename: none`), so the fixture keys are the Dart field names.
@freezed
abstract class VideoItem with _$VideoItem {
  const factory VideoItem({
    required String id,
    required String title,
    required String dateLabel,
    required String thumbnailUrl,

    /// Gold badge caption below the date ("Avatar IV", "Draft"); no badge
    /// row when null.
    String? badgeLabel,

    /// "mm:ss" chip inside the thumbnail's bottom-left corner; hidden when
    /// null (drafts have no rendered duration).
    String? durationLabel,
  }) = _VideoItem;

  const VideoItem._();

  factory VideoItem.fromJson(Map<String, dynamic> json) =>
      _$VideoItemFromJson(json);
}

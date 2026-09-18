import 'package:freezed_annotation/freezed_annotation.dart';

import 'wonder_type.dart';

part 'wonder_marker.freezed.dart';

/// One of the 8 wonders plotted on the Global Timeline's wonder tracks
/// (screenshot: the pill-shaped construction-span markers alongside the
/// vertical year axis).
///
/// Ported verbatim from Wonderous's wonder-timeline-marker data (type,
/// title, startYr/endYr construction span, thumbnail).
///
/// Keys are camelCase per the project json_serializable convention
/// (`field_rename: none`), so the fixture keys are the Dart field names —
/// except `type`, which is parsed via [WonderTypeX.fromJson] rather than
/// generated `fromJson`, so this model hand-writes its own factory.
@freezed
abstract class WonderMarker with _$WonderMarker {
  const factory WonderMarker({
    required WonderType type,
    required String title,
    required int startYr,
    required int endYr,
    required String thumbnailUrl,
  }) = _WonderMarker;

  factory WonderMarker.fromJson(Map<String, dynamic> json) {
    return WonderMarker(
      type: WonderTypeX.fromJson(json['type'] as String),
      title: json['title'] as String,
      startYr: json['startYr'] as int,
      endYr: json['endYr'] as int,
      thumbnailUrl: json['thumbnailUrl'] as String,
    );
  }
}

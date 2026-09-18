import 'package:freezed_annotation/freezed_annotation.dart';

part 'timeline_event.freezed.dart';
part 'timeline_event.g.dart';

/// A single dated entry on the Global Timeline (screenshot: world-history
/// events plotted along the vertical year axis, alongside the wonder
/// construction markers).
///
/// Ported verbatim from Wonderous's `TimelineEvent` (year + description
/// only — Wonderous's timeline events carry no other fields).
///
/// Keys are camelCase per the project json_serializable convention
/// (`field_rename: none`), so the fixture keys are the Dart field names.
@freezed
abstract class TimelineEvent with _$TimelineEvent {
  const factory TimelineEvent({
    /// Year the event occurred. Negative values are BCE, per Wonderous's
    /// timeline year convention (see `timeline_era.dart` for the BCE/CE
    /// and era-boundary helpers).
    required int year,
    required String description,
  }) = _TimelineEvent;

  factory TimelineEvent.fromJson(Map<String, dynamic> json) =>
      _$TimelineEventFromJson(json);
}

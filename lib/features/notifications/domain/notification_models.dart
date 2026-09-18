import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_models.freezed.dart';
part 'notification_models.g.dart';

/// The kind of a notification — drives the inbox row's icon + tint and maps
/// onto the persisted Drift `type` column. Plexaverse's own product
/// categories (post lifecycle + Odyssey gamification), not ProHealth's
/// order/delivery taxonomy.
enum NotificationCategory {
  @JsonValue('post_published')
  postPublished,
  @JsonValue('post_scheduled')
  postScheduled,
  @JsonValue('post_failed')
  postFailed,
  @JsonValue('mission_complete')
  missionComplete,
  @JsonValue('xp_earned')
  xpEarned,
  @JsonValue('analytics')
  analytics,
  @JsonValue('general')
  system,
}

/// Maps the persisted / wire `type` string onto a [NotificationCategory].
/// Unknown values from a newer server degrade to [system] rather than
/// throwing. The string forms mirror the legacy Drift `type` literals
/// (`post_published`, `xp_earned`, …) so the existing drawer icons/colours
/// keep working across the migration.
extension NotificationCategoryX on NotificationCategory {
  /// The wire / Drift `type` literal for this category.
  String get wire => switch (this) {
        NotificationCategory.postPublished => 'post_published',
        NotificationCategory.postScheduled => 'post_scheduled',
        NotificationCategory.postFailed => 'post_failed',
        NotificationCategory.missionComplete => 'mission_complete',
        NotificationCategory.xpEarned => 'xp_earned',
        NotificationCategory.analytics => 'analytics',
        NotificationCategory.system => 'general',
      };

  static NotificationCategory fromWire(String? raw) => switch (raw) {
        'post_published' => NotificationCategory.postPublished,
        'post_scheduled' => NotificationCategory.postScheduled,
        'post_failed' => NotificationCategory.postFailed,
        'mission_complete' => NotificationCategory.missionComplete,
        'xp_earned' => NotificationCategory.xpEarned,
        'analytics' => NotificationCategory.analytics,
        _ => NotificationCategory.system,
      };
}

/// One inbox notification (`GET /notifications`) and the in-app banner
/// payload for a foreground FCM push (same shape, so a push reconciles with
/// the list). `createdAt` is a full date-time. `route` is the in-app deep
/// link opened on tap (parsed from the FCM `data['route']` per RULINGS #15).
@freezed
abstract class AppNotification with _$AppNotification {
  const factory AppNotification({
    required String id,
    required String title,
    required String body,
    // A value from a newer server we don't know about degrades to `system`
    // rather than throwing during deserialisation.
    @JsonKey(unknownEnumValue: NotificationCategory.system)
    required NotificationCategory category,
    required DateTime createdAt,
    required bool read,
    @JsonKey(includeIfNull: false) String? route,
  }) = _AppNotification;

  factory AppNotification.fromJson(Map<String, dynamic> json) =>
      _$AppNotificationFromJson(json);
}

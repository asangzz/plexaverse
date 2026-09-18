import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/features/notifications/domain/notification_models.dart';

/// Guards that the mock notifications fixture parses cleanly through the
/// regenerated (camelCase) `AppNotification.fromJson` used by the mock flavor.
///
/// After the `field_rename: snake -> none` migration, the generated
/// `fromJson` reads the Dart field names verbatim: `id`, `title`, `body`,
/// `category`, `createdAt`, `read`, `route`. The `category` values remain
/// snake_case wire literals because they come from `@JsonValue` on
/// [NotificationCategory], not from field renaming.
void main() {
  final file = File('assets/mock/notifications/notifications.json');

  test('fixture file exists', () {
    expect(file.existsSync(), isTrue,
        reason: 'expected ${file.path} relative to package root');
  });

  test('every fixture entry parses via AppNotification.fromJson', () {
    final decoded = jsonDecode(file.readAsStringSync()) as List<dynamic>;
    expect(decoded, isNotEmpty);

    final notifications = decoded
        .map((e) => AppNotification.fromJson(e as Map<String, dynamic>))
        .toList();

    expect(notifications.length, decoded.length);

    // No entry silently degraded to `system` unless its wire value is
    // genuinely 'general' — confirms the snake_case enum keys still decode.
    for (final n in notifications) {
      expect(n.id, isNotEmpty);
      expect(n.title, isNotEmpty);
      expect(n.body, isNotEmpty);
    }
  });

  test('camelCase keys map onto the expected fields', () {
    final decoded = jsonDecode(file.readAsStringSync()) as List<dynamic>;
    final first = AppNotification.fromJson(decoded.first as Map<String, dynamic>);

    expect(first.id, 'ntf-1001');
    expect(first.category, NotificationCategory.postPublished);
    expect(first.read, isFalse);
    expect(first.route, '/posts');
    expect(first.createdAt, DateTime.parse('2026-07-05T09:12:00.000Z'));
  });

  test('optional route is null when absent (last fixture entry)', () {
    final decoded = jsonDecode(file.readAsStringSync()) as List<dynamic>;
    final last = AppNotification.fromJson(decoded.last as Map<String, dynamic>);

    expect(last.route, isNull);
    expect(last.category, NotificationCategory.system); // 'general'
  });
}

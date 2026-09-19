import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/core/storage/app_database.dart';
import 'package:plexaverse/core/storage/dao/notification_dao.dart';

/// The notification cache mirrors the server. `remoteId` carries no unique
/// index, so the matching is done in `upsertFromServer` — if that breaks,
/// every sync appends the same notifications again and the drawer grows a
/// copy per refresh.
void main() {
  late AppDatabase db;
  late NotificationDao dao;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    dao = db.notificationDao;
  });
  tearDown(() => db.close());

  RemoteNotification remote(
    String id, {
    String title = 'T',
    bool isRead = false,
  }) =>
      RemoteNotification(
        remoteId: id,
        title: title,
        body: 'B',
        type: 'general',
        isRead: isRead,
        receivedAt: DateTime(2026, 9, 19),
      );

  test('a repeated sync updates rather than duplicating', () async {
    await dao.upsertFromServer([remote('n1'), remote('n2')]);
    await dao.upsertFromServer([remote('n1'), remote('n2')]);

    final rows = await dao.watchAllNotifications().first;
    expect(rows, hasLength(2), reason: 'syncing twice must not double the inbox');
  });

  test('an updated notification is rewritten in place', () async {
    await dao.upsertFromServer([remote('n1', title: 'Before')]);
    await dao.upsertFromServer([remote('n1', title: 'After')]);

    final rows = await dao.watchAllNotifications().first;
    expect(rows, hasLength(1));
    expect(rows.single.title, 'After');
  });

  test('read state follows the server, so a web dismissal sticks', () async {
    await dao.upsertFromServer([remote('n1', isRead: false)]);
    expect(await dao.getUnreadCount(), 1);

    await dao.upsertFromServer([remote('n1', isRead: true)]);
    expect(await dao.getUnreadCount(), 0,
        reason: 'read belongs to the account, not the device');
  });

  test('pruning drops rows the server no longer lists', () async {
    await dao.upsertFromServer([remote('n1'), remote('n2')]);
    await dao.pruneMissing({'n1'});

    final rows = await dao.watchAllNotifications().first;
    expect(rows.map((r) => r.remoteId), <String>['n1']);
  });

  test('pruning NEVER drops an unsynced foreground push', () async {
    // A push that arrived while the app was open has no remote id yet.
    // Deleting it would lose a notification the user genuinely received.
    await dao.insertNotification(
      const NotificationsTableCompanion(
        title: Value('Live push'),
        body: Value('arrived via FCM'),
      ),
    );
    await dao.upsertFromServer([remote('n1')]);
    await dao.pruneMissing({'n1'});

    final rows = await dao.watchAllNotifications().first;
    expect(rows, hasLength(2));
    expect(rows.where((r) => r.remoteId == null), hasLength(1));
  });

  test('an empty page is a no-op, not a wipe', () async {
    await dao.upsertFromServer([remote('n1')]);
    await dao.upsertFromServer(<RemoteNotification>[]);
    expect(await dao.watchAllNotifications().first, hasLength(1));
  });
}

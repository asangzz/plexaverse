import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables.dart';

part 'notification_dao.g.dart';

/// Drift accessor for the persisted notification inbox (RULINGS ruling 15 —
/// the inbox drawer stays; FCM handles the system tray in the background).
/// Lives in `core/storage/dao/` alongside the single [AppDatabase].
@DriftAccessor(tables: [NotificationsTable])
class NotificationDao extends DatabaseAccessor<AppDatabase>
    with _$NotificationDaoMixin {
  NotificationDao(super.db);

  Stream<List<NotificationsTableData>> watchAllNotifications() =>
      (select(notificationsTable)
            ..orderBy([(n) => OrderingTerm.desc(n.receivedAt)]))
          .watch();

  Stream<List<NotificationsTableData>> watchUnreadNotifications() =>
      (select(notificationsTable)
            ..where((n) => n.isRead.equals(false))
            ..orderBy([(n) => OrderingTerm.desc(n.receivedAt)]))
          .watch();

  Future<int> getUnreadCount() async {
    final count = countAll(filter: notificationsTable.isRead.equals(false));
    final query = selectOnly(notificationsTable)..addColumns([count]);
    final result = await query.getSingle();
    return result.read(count) ?? 0;
  }

  Future<int> insertNotification(NotificationsTableCompanion notification) =>
      into(notificationsTable).insert(notification);

  Future<void> markAsRead(int id) =>
      (update(notificationsTable)..where((n) => n.id.equals(id)))
          .write(const NotificationsTableCompanion(isRead: Value(true)));

  Future<void> markAllAsRead() => update(notificationsTable)
      .write(const NotificationsTableCompanion(isRead: Value(true)));

  Future<void> deleteNotification(int id) =>
      (delete(notificationsTable)..where((n) => n.id.equals(id))).go();

  Future<void> clearAll() => delete(notificationsTable).go();
}

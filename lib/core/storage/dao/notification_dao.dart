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

  /// Mirrors a page of SERVER notifications into the cache.
  ///
  /// Keyed on [NotificationsTable.remoteId], which has no unique index — so
  /// matching is done here rather than by the database. Without it every sync
  /// would append the same notifications again and the drawer would grow a
  /// copy per refresh.
  ///
  /// `isRead` follows the server, deliberately: read state belongs to the
  /// account, not the device, and a notification dismissed on the web should
  /// not come back unread on the phone.
  Future<void> upsertFromServer(List<RemoteNotification> incoming) async {
    if (incoming.isEmpty) return;
    await transaction(() async {
      for (final RemoteNotification n in incoming) {
        final existing = await (select(notificationsTable)
              ..where((t) => t.remoteId.equals(n.remoteId))
              ..limit(1))
            .getSingleOrNull();
        final companion = NotificationsTableCompanion(
          remoteId: Value(n.remoteId),
          title: Value(n.title),
          body: Value(n.body),
          type: Value(n.type),
          payload: Value(n.route),
          isRead: Value(n.isRead),
          receivedAt: Value(n.receivedAt),
        );
        if (existing == null) {
          await into(notificationsTable).insert(companion);
        } else {
          await (update(notificationsTable)
                ..where((t) => t.id.equals(existing.id)))
              .write(companion);
        }
      }
    });
  }

  /// Drops cached rows that the server no longer lists.
  ///
  /// Only touches rows that CAME from the server (`remoteId` non-null) — a
  /// foreground push that has not been synced yet has no remote id, and
  /// deleting it would lose a notification the user genuinely received.
  Future<void> pruneMissing(Set<String> keepRemoteIds) async {
    final rows = await (select(notificationsTable)
          ..where((t) => t.remoteId.isNotNull()))
        .get();
    for (final row in rows) {
      final String? rid = row.remoteId;
      if (rid != null && !keepRemoteIds.contains(rid)) {
        await deleteNotification(row.id);
      }
    }
  }
}

/// One server notification, flattened for the cache write.
class RemoteNotification {
  const RemoteNotification({
    required this.remoteId,
    required this.title,
    required this.body,
    required this.type,
    required this.isRead,
    required this.receivedAt,
    this.route,
  });

  final String remoteId;
  final String title;
  final String body;
  final String type;
  final bool isRead;
  final DateTime receivedAt;
  final String? route;
}

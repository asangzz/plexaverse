import 'package:drift/drift.dart';

/// Plexaverse product tables (RULINGS: "Recreate Plexaverse product tables:
/// posts, post_metrics, user_stats, missions, notifications").
///
/// The pre-migration `users` / `sessions` tables are DROPPED (RULINGS ruling
/// 8): the session is owned exclusively by `SessionStore` (secure storage),
/// and profile data comes from the API / mock fixtures — never Drift.
///
/// These live alongside the sync-queue table in a single encrypted
/// [AppDatabase] (see `app_database.dart`). Fresh `schemaVersion = 1`, no
/// migration path (RULINGS ruling 9).

/// Persisted notification inbox (Plexaverse product feature — the inbox
/// drawer stays; RULINGS ruling 15). FCM handles the system tray in the
/// background; delivered notifications are mirrored here for the drawer.
class NotificationsTable extends Table {
  @override
  String get tableName => 'notifications';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get remoteId => text().nullable()();
  TextColumn get title => text()();
  TextColumn get body => text()();
  TextColumn get type => text().withDefault(const Constant('general'))();
  TextColumn get payload => text().nullable()();
  BoolColumn get isRead => boolean().withDefault(const Constant(false))();
  DateTimeColumn get receivedAt => dateTime().withDefault(currentDateAndTime)();
}

/// Authored posts. `status`: draft | scheduled | published | failed.
class PostsTable extends Table {
  @override
  String get tableName => 'posts';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get remoteId => text().nullable()(); // null = local-only draft
  TextColumn get content => text()();
  TextColumn get hookLine => text().nullable()(); // first line / headline
  TextColumn get status => text().withDefault(const Constant('draft'))();
  TextColumn get platform =>
      text().withDefault(const Constant('linkedin'))();
  DateTimeColumn get scheduledAt => dateTime().nullable()();
  DateTimeColumn get publishedAt => dateTime().nullable()();
  TextColumn get errorMessage => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

/// Engagement metrics fetched from the API after publishing.
class PostMetricsTable extends Table {
  @override
  String get tableName => 'post_metrics';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get postId =>
      integer().references(PostsTable, #id, onDelete: KeyAction.cascade)();
  IntColumn get impressions => integer().withDefault(const Constant(0))();
  IntColumn get engagements => integer().withDefault(const Constant(0))();
  IntColumn get comments => integer().withDefault(const Constant(0))();
  IntColumn get reposts => integer().withDefault(const Constant(0))();
  IntColumn get likes => integer().withDefault(const Constant(0))();
  DateTimeColumn get fetchedAt => dateTime().withDefault(currentDateAndTime)();
}

/// Single-row table (always id=1) — streak, XP, level (gamification).
class UserStatsTable extends Table {
  @override
  String get tableName => 'user_stats';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get streakDays => integer().withDefault(const Constant(0))();
  IntColumn get xp => integer().withDefault(const Constant(0))();
  IntColumn get level => integer().withDefault(const Constant(1))();
  TextColumn get levelTitle =>
      text().withDefault(const Constant('Beginner'))();
  IntColumn get weeklyXp => integer().withDefault(const Constant(0))();
  IntColumn get weeklyXpGoal => integer().withDefault(const Constant(2000))();
  // ISO date string YYYY-MM-DD of the last day a post was published.
  TextColumn get lastActiveDateStr => text().nullable()();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

/// Odyssey missions. `status`: done | active | next | locked.
class MissionsTable extends Table {
  @override
  String get tableName => 'missions';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get missionKey => text().unique()(); // stable identifier
  TextColumn get title => text()();
  TextColumn get description => text()();
  TextColumn get status => text().withDefault(const Constant('locked'))();
  IntColumn get xpReward => integer().withDefault(const Constant(100))();
  IntColumn get progress => integer().withDefault(const Constant(0))();
  IntColumn get total => integer().withDefault(const Constant(1))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
}

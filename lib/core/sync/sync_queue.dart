import 'package:drift/drift.dart';

import 'pending_mutation.dart';

/// Drift table backing the offline mutation queue (ProHealth §7.2).
///
/// `idempotencyKey` is a server-known dedup token that survives retries and
/// process restarts. `batchId` groups related mutations (e.g. a post plus its
/// media uploads) so the drainer can ship them as a unit. `nextAttemptAt`
/// powers exponential backoff for transient failures.
class SyncQueue extends Table {
  @override
  String get tableName => 'sync_queue';

  TextColumn get id => text()();
  TextColumn get kind => textEnum<MutationKind>()();
  TextColumn get idempotencyKey => text().unique()();
  TextColumn get batchId => text().nullable()();
  TextColumn get payloadJson => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get nextAttemptAt => dateTime().nullable()();
  IntColumn get attempts => integer().withDefault(const Constant(0))();
  TextColumn get lastError => text().nullable()();
  TextColumn get status => textEnum<SyncStatus>()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

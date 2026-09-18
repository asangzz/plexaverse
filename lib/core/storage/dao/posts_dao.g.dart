// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'posts_dao.dart';

// ignore_for_file: type=lint
mixin _$PostsDaoMixin on DatabaseAccessor<AppDatabase> {
  $PostsTableTable get postsTable => attachedDatabase.postsTable;
  $PostMetricsTableTable get postMetricsTable =>
      attachedDatabase.postMetricsTable;
  PostsDaoManager get managers => PostsDaoManager(this);
}

class PostsDaoManager {
  final _$PostsDaoMixin _db;
  PostsDaoManager(this._db);
  $$PostsTableTableTableManager get postsTable =>
      $$PostsTableTableTableManager(_db.attachedDatabase, _db.postsTable);
  $$PostMetricsTableTableTableManager get postMetricsTable =>
      $$PostMetricsTableTableTableManager(
        _db.attachedDatabase,
        _db.postMetricsTable,
      );
}

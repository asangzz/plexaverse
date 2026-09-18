// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $SyncQueueTable extends SyncQueue
    with TableInfo<$SyncQueueTable, SyncQueueData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncQueueTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<MutationKind, String> kind =
      GeneratedColumn<String>(
        'kind',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<MutationKind>($SyncQueueTable.$converterkind);
  static const VerificationMeta _idempotencyKeyMeta = const VerificationMeta(
    'idempotencyKey',
  );
  @override
  late final GeneratedColumn<String> idempotencyKey = GeneratedColumn<String>(
    'idempotency_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _batchIdMeta = const VerificationMeta(
    'batchId',
  );
  @override
  late final GeneratedColumn<String> batchId = GeneratedColumn<String>(
    'batch_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _payloadJsonMeta = const VerificationMeta(
    'payloadJson',
  );
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
    'payload_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nextAttemptAtMeta = const VerificationMeta(
    'nextAttemptAt',
  );
  @override
  late final GeneratedColumn<DateTime> nextAttemptAt =
      GeneratedColumn<DateTime>(
        'next_attempt_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _attemptsMeta = const VerificationMeta(
    'attempts',
  );
  @override
  late final GeneratedColumn<int> attempts = GeneratedColumn<int>(
    'attempts',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastErrorMeta = const VerificationMeta(
    'lastError',
  );
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
    'last_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<SyncStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<SyncStatus>($SyncQueueTable.$converterstatus);
  @override
  List<GeneratedColumn> get $columns => [
    id,
    kind,
    idempotencyKey,
    batchId,
    payloadJson,
    createdAt,
    nextAttemptAt,
    attempts,
    lastError,
    status,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_queue';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncQueueData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('idempotency_key')) {
      context.handle(
        _idempotencyKeyMeta,
        idempotencyKey.isAcceptableOrUnknown(
          data['idempotency_key']!,
          _idempotencyKeyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_idempotencyKeyMeta);
    }
    if (data.containsKey('batch_id')) {
      context.handle(
        _batchIdMeta,
        batchId.isAcceptableOrUnknown(data['batch_id']!, _batchIdMeta),
      );
    }
    if (data.containsKey('payload_json')) {
      context.handle(
        _payloadJsonMeta,
        payloadJson.isAcceptableOrUnknown(
          data['payload_json']!,
          _payloadJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_payloadJsonMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('next_attempt_at')) {
      context.handle(
        _nextAttemptAtMeta,
        nextAttemptAt.isAcceptableOrUnknown(
          data['next_attempt_at']!,
          _nextAttemptAtMeta,
        ),
      );
    }
    if (data.containsKey('attempts')) {
      context.handle(
        _attemptsMeta,
        attempts.isAcceptableOrUnknown(data['attempts']!, _attemptsMeta),
      );
    }
    if (data.containsKey('last_error')) {
      context.handle(
        _lastErrorMeta,
        lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncQueueData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncQueueData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      kind: $SyncQueueTable.$converterkind.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}kind'],
        )!,
      ),
      idempotencyKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}idempotency_key'],
      )!,
      batchId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}batch_id'],
      ),
      payloadJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload_json'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      nextAttemptAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}next_attempt_at'],
      ),
      attempts: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attempts'],
      )!,
      lastError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_error'],
      ),
      status: $SyncQueueTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
    );
  }

  @override
  $SyncQueueTable createAlias(String alias) {
    return $SyncQueueTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<MutationKind, String, String> $converterkind =
      const EnumNameConverter<MutationKind>(MutationKind.values);
  static JsonTypeConverter2<SyncStatus, String, String> $converterstatus =
      const EnumNameConverter<SyncStatus>(SyncStatus.values);
}

class SyncQueueData extends DataClass implements Insertable<SyncQueueData> {
  final String id;
  final MutationKind kind;
  final String idempotencyKey;
  final String? batchId;
  final String payloadJson;
  final DateTime createdAt;
  final DateTime? nextAttemptAt;
  final int attempts;
  final String? lastError;
  final SyncStatus status;
  const SyncQueueData({
    required this.id,
    required this.kind,
    required this.idempotencyKey,
    this.batchId,
    required this.payloadJson,
    required this.createdAt,
    this.nextAttemptAt,
    required this.attempts,
    this.lastError,
    required this.status,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    {
      map['kind'] = Variable<String>(
        $SyncQueueTable.$converterkind.toSql(kind),
      );
    }
    map['idempotency_key'] = Variable<String>(idempotencyKey);
    if (!nullToAbsent || batchId != null) {
      map['batch_id'] = Variable<String>(batchId);
    }
    map['payload_json'] = Variable<String>(payloadJson);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || nextAttemptAt != null) {
      map['next_attempt_at'] = Variable<DateTime>(nextAttemptAt);
    }
    map['attempts'] = Variable<int>(attempts);
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    {
      map['status'] = Variable<String>(
        $SyncQueueTable.$converterstatus.toSql(status),
      );
    }
    return map;
  }

  SyncQueueCompanion toCompanion(bool nullToAbsent) {
    return SyncQueueCompanion(
      id: Value(id),
      kind: Value(kind),
      idempotencyKey: Value(idempotencyKey),
      batchId: batchId == null && nullToAbsent
          ? const Value.absent()
          : Value(batchId),
      payloadJson: Value(payloadJson),
      createdAt: Value(createdAt),
      nextAttemptAt: nextAttemptAt == null && nullToAbsent
          ? const Value.absent()
          : Value(nextAttemptAt),
      attempts: Value(attempts),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
      status: Value(status),
    );
  }

  factory SyncQueueData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncQueueData(
      id: serializer.fromJson<String>(json['id']),
      kind: $SyncQueueTable.$converterkind.fromJson(
        serializer.fromJson<String>(json['kind']),
      ),
      idempotencyKey: serializer.fromJson<String>(json['idempotencyKey']),
      batchId: serializer.fromJson<String?>(json['batchId']),
      payloadJson: serializer.fromJson<String>(json['payloadJson']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      nextAttemptAt: serializer.fromJson<DateTime?>(json['nextAttemptAt']),
      attempts: serializer.fromJson<int>(json['attempts']),
      lastError: serializer.fromJson<String?>(json['lastError']),
      status: $SyncQueueTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'kind': serializer.toJson<String>(
        $SyncQueueTable.$converterkind.toJson(kind),
      ),
      'idempotencyKey': serializer.toJson<String>(idempotencyKey),
      'batchId': serializer.toJson<String?>(batchId),
      'payloadJson': serializer.toJson<String>(payloadJson),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'nextAttemptAt': serializer.toJson<DateTime?>(nextAttemptAt),
      'attempts': serializer.toJson<int>(attempts),
      'lastError': serializer.toJson<String?>(lastError),
      'status': serializer.toJson<String>(
        $SyncQueueTable.$converterstatus.toJson(status),
      ),
    };
  }

  SyncQueueData copyWith({
    String? id,
    MutationKind? kind,
    String? idempotencyKey,
    Value<String?> batchId = const Value.absent(),
    String? payloadJson,
    DateTime? createdAt,
    Value<DateTime?> nextAttemptAt = const Value.absent(),
    int? attempts,
    Value<String?> lastError = const Value.absent(),
    SyncStatus? status,
  }) => SyncQueueData(
    id: id ?? this.id,
    kind: kind ?? this.kind,
    idempotencyKey: idempotencyKey ?? this.idempotencyKey,
    batchId: batchId.present ? batchId.value : this.batchId,
    payloadJson: payloadJson ?? this.payloadJson,
    createdAt: createdAt ?? this.createdAt,
    nextAttemptAt: nextAttemptAt.present
        ? nextAttemptAt.value
        : this.nextAttemptAt,
    attempts: attempts ?? this.attempts,
    lastError: lastError.present ? lastError.value : this.lastError,
    status: status ?? this.status,
  );
  SyncQueueData copyWithCompanion(SyncQueueCompanion data) {
    return SyncQueueData(
      id: data.id.present ? data.id.value : this.id,
      kind: data.kind.present ? data.kind.value : this.kind,
      idempotencyKey: data.idempotencyKey.present
          ? data.idempotencyKey.value
          : this.idempotencyKey,
      batchId: data.batchId.present ? data.batchId.value : this.batchId,
      payloadJson: data.payloadJson.present
          ? data.payloadJson.value
          : this.payloadJson,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      nextAttemptAt: data.nextAttemptAt.present
          ? data.nextAttemptAt.value
          : this.nextAttemptAt,
      attempts: data.attempts.present ? data.attempts.value : this.attempts,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueData(')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('idempotencyKey: $idempotencyKey, ')
          ..write('batchId: $batchId, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('nextAttemptAt: $nextAttemptAt, ')
          ..write('attempts: $attempts, ')
          ..write('lastError: $lastError, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    kind,
    idempotencyKey,
    batchId,
    payloadJson,
    createdAt,
    nextAttemptAt,
    attempts,
    lastError,
    status,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncQueueData &&
          other.id == this.id &&
          other.kind == this.kind &&
          other.idempotencyKey == this.idempotencyKey &&
          other.batchId == this.batchId &&
          other.payloadJson == this.payloadJson &&
          other.createdAt == this.createdAt &&
          other.nextAttemptAt == this.nextAttemptAt &&
          other.attempts == this.attempts &&
          other.lastError == this.lastError &&
          other.status == this.status);
}

class SyncQueueCompanion extends UpdateCompanion<SyncQueueData> {
  final Value<String> id;
  final Value<MutationKind> kind;
  final Value<String> idempotencyKey;
  final Value<String?> batchId;
  final Value<String> payloadJson;
  final Value<DateTime> createdAt;
  final Value<DateTime?> nextAttemptAt;
  final Value<int> attempts;
  final Value<String?> lastError;
  final Value<SyncStatus> status;
  final Value<int> rowid;
  const SyncQueueCompanion({
    this.id = const Value.absent(),
    this.kind = const Value.absent(),
    this.idempotencyKey = const Value.absent(),
    this.batchId = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.nextAttemptAt = const Value.absent(),
    this.attempts = const Value.absent(),
    this.lastError = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncQueueCompanion.insert({
    required String id,
    required MutationKind kind,
    required String idempotencyKey,
    this.batchId = const Value.absent(),
    required String payloadJson,
    required DateTime createdAt,
    this.nextAttemptAt = const Value.absent(),
    this.attempts = const Value.absent(),
    this.lastError = const Value.absent(),
    required SyncStatus status,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       kind = Value(kind),
       idempotencyKey = Value(idempotencyKey),
       payloadJson = Value(payloadJson),
       createdAt = Value(createdAt),
       status = Value(status);
  static Insertable<SyncQueueData> custom({
    Expression<String>? id,
    Expression<String>? kind,
    Expression<String>? idempotencyKey,
    Expression<String>? batchId,
    Expression<String>? payloadJson,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? nextAttemptAt,
    Expression<int>? attempts,
    Expression<String>? lastError,
    Expression<String>? status,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (kind != null) 'kind': kind,
      if (idempotencyKey != null) 'idempotency_key': idempotencyKey,
      if (batchId != null) 'batch_id': batchId,
      if (payloadJson != null) 'payload_json': payloadJson,
      if (createdAt != null) 'created_at': createdAt,
      if (nextAttemptAt != null) 'next_attempt_at': nextAttemptAt,
      if (attempts != null) 'attempts': attempts,
      if (lastError != null) 'last_error': lastError,
      if (status != null) 'status': status,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncQueueCompanion copyWith({
    Value<String>? id,
    Value<MutationKind>? kind,
    Value<String>? idempotencyKey,
    Value<String?>? batchId,
    Value<String>? payloadJson,
    Value<DateTime>? createdAt,
    Value<DateTime?>? nextAttemptAt,
    Value<int>? attempts,
    Value<String?>? lastError,
    Value<SyncStatus>? status,
    Value<int>? rowid,
  }) {
    return SyncQueueCompanion(
      id: id ?? this.id,
      kind: kind ?? this.kind,
      idempotencyKey: idempotencyKey ?? this.idempotencyKey,
      batchId: batchId ?? this.batchId,
      payloadJson: payloadJson ?? this.payloadJson,
      createdAt: createdAt ?? this.createdAt,
      nextAttemptAt: nextAttemptAt ?? this.nextAttemptAt,
      attempts: attempts ?? this.attempts,
      lastError: lastError ?? this.lastError,
      status: status ?? this.status,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(
        $SyncQueueTable.$converterkind.toSql(kind.value),
      );
    }
    if (idempotencyKey.present) {
      map['idempotency_key'] = Variable<String>(idempotencyKey.value);
    }
    if (batchId.present) {
      map['batch_id'] = Variable<String>(batchId.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (nextAttemptAt.present) {
      map['next_attempt_at'] = Variable<DateTime>(nextAttemptAt.value);
    }
    if (attempts.present) {
      map['attempts'] = Variable<int>(attempts.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $SyncQueueTable.$converterstatus.toSql(status.value),
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueCompanion(')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('idempotencyKey: $idempotencyKey, ')
          ..write('batchId: $batchId, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('nextAttemptAt: $nextAttemptAt, ')
          ..write('attempts: $attempts, ')
          ..write('lastError: $lastError, ')
          ..write('status: $status, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PostsTableTable extends PostsTable
    with TableInfo<$PostsTableTable, PostsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PostsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _remoteIdMeta = const VerificationMeta(
    'remoteId',
  );
  @override
  late final GeneratedColumn<String> remoteId = GeneratedColumn<String>(
    'remote_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hookLineMeta = const VerificationMeta(
    'hookLine',
  );
  @override
  late final GeneratedColumn<String> hookLine = GeneratedColumn<String>(
    'hook_line',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('draft'),
  );
  static const VerificationMeta _platformMeta = const VerificationMeta(
    'platform',
  );
  @override
  late final GeneratedColumn<String> platform = GeneratedColumn<String>(
    'platform',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('linkedin'),
  );
  static const VerificationMeta _scheduledAtMeta = const VerificationMeta(
    'scheduledAt',
  );
  @override
  late final GeneratedColumn<DateTime> scheduledAt = GeneratedColumn<DateTime>(
    'scheduled_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _publishedAtMeta = const VerificationMeta(
    'publishedAt',
  );
  @override
  late final GeneratedColumn<DateTime> publishedAt = GeneratedColumn<DateTime>(
    'published_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _errorMessageMeta = const VerificationMeta(
    'errorMessage',
  );
  @override
  late final GeneratedColumn<String> errorMessage = GeneratedColumn<String>(
    'error_message',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    remoteId,
    content,
    hookLine,
    status,
    platform,
    scheduledAt,
    publishedAt,
    errorMessage,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'posts';
  @override
  VerificationContext validateIntegrity(
    Insertable<PostsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('remote_id')) {
      context.handle(
        _remoteIdMeta,
        remoteId.isAcceptableOrUnknown(data['remote_id']!, _remoteIdMeta),
      );
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('hook_line')) {
      context.handle(
        _hookLineMeta,
        hookLine.isAcceptableOrUnknown(data['hook_line']!, _hookLineMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('platform')) {
      context.handle(
        _platformMeta,
        platform.isAcceptableOrUnknown(data['platform']!, _platformMeta),
      );
    }
    if (data.containsKey('scheduled_at')) {
      context.handle(
        _scheduledAtMeta,
        scheduledAt.isAcceptableOrUnknown(
          data['scheduled_at']!,
          _scheduledAtMeta,
        ),
      );
    }
    if (data.containsKey('published_at')) {
      context.handle(
        _publishedAtMeta,
        publishedAt.isAcceptableOrUnknown(
          data['published_at']!,
          _publishedAtMeta,
        ),
      );
    }
    if (data.containsKey('error_message')) {
      context.handle(
        _errorMessageMeta,
        errorMessage.isAcceptableOrUnknown(
          data['error_message']!,
          _errorMessageMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PostsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PostsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      remoteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}remote_id'],
      ),
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      hookLine: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hook_line'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      platform: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}platform'],
      )!,
      scheduledAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}scheduled_at'],
      ),
      publishedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}published_at'],
      ),
      errorMessage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}error_message'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $PostsTableTable createAlias(String alias) {
    return $PostsTableTable(attachedDatabase, alias);
  }
}

class PostsTableData extends DataClass implements Insertable<PostsTableData> {
  final int id;
  final String? remoteId;
  final String content;
  final String? hookLine;
  final String status;
  final String platform;
  final DateTime? scheduledAt;
  final DateTime? publishedAt;
  final String? errorMessage;
  final DateTime createdAt;
  final DateTime updatedAt;
  const PostsTableData({
    required this.id,
    this.remoteId,
    required this.content,
    this.hookLine,
    required this.status,
    required this.platform,
    this.scheduledAt,
    this.publishedAt,
    this.errorMessage,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || remoteId != null) {
      map['remote_id'] = Variable<String>(remoteId);
    }
    map['content'] = Variable<String>(content);
    if (!nullToAbsent || hookLine != null) {
      map['hook_line'] = Variable<String>(hookLine);
    }
    map['status'] = Variable<String>(status);
    map['platform'] = Variable<String>(platform);
    if (!nullToAbsent || scheduledAt != null) {
      map['scheduled_at'] = Variable<DateTime>(scheduledAt);
    }
    if (!nullToAbsent || publishedAt != null) {
      map['published_at'] = Variable<DateTime>(publishedAt);
    }
    if (!nullToAbsent || errorMessage != null) {
      map['error_message'] = Variable<String>(errorMessage);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  PostsTableCompanion toCompanion(bool nullToAbsent) {
    return PostsTableCompanion(
      id: Value(id),
      remoteId: remoteId == null && nullToAbsent
          ? const Value.absent()
          : Value(remoteId),
      content: Value(content),
      hookLine: hookLine == null && nullToAbsent
          ? const Value.absent()
          : Value(hookLine),
      status: Value(status),
      platform: Value(platform),
      scheduledAt: scheduledAt == null && nullToAbsent
          ? const Value.absent()
          : Value(scheduledAt),
      publishedAt: publishedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(publishedAt),
      errorMessage: errorMessage == null && nullToAbsent
          ? const Value.absent()
          : Value(errorMessage),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory PostsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PostsTableData(
      id: serializer.fromJson<int>(json['id']),
      remoteId: serializer.fromJson<String?>(json['remoteId']),
      content: serializer.fromJson<String>(json['content']),
      hookLine: serializer.fromJson<String?>(json['hookLine']),
      status: serializer.fromJson<String>(json['status']),
      platform: serializer.fromJson<String>(json['platform']),
      scheduledAt: serializer.fromJson<DateTime?>(json['scheduledAt']),
      publishedAt: serializer.fromJson<DateTime?>(json['publishedAt']),
      errorMessage: serializer.fromJson<String?>(json['errorMessage']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'remoteId': serializer.toJson<String?>(remoteId),
      'content': serializer.toJson<String>(content),
      'hookLine': serializer.toJson<String?>(hookLine),
      'status': serializer.toJson<String>(status),
      'platform': serializer.toJson<String>(platform),
      'scheduledAt': serializer.toJson<DateTime?>(scheduledAt),
      'publishedAt': serializer.toJson<DateTime?>(publishedAt),
      'errorMessage': serializer.toJson<String?>(errorMessage),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  PostsTableData copyWith({
    int? id,
    Value<String?> remoteId = const Value.absent(),
    String? content,
    Value<String?> hookLine = const Value.absent(),
    String? status,
    String? platform,
    Value<DateTime?> scheduledAt = const Value.absent(),
    Value<DateTime?> publishedAt = const Value.absent(),
    Value<String?> errorMessage = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => PostsTableData(
    id: id ?? this.id,
    remoteId: remoteId.present ? remoteId.value : this.remoteId,
    content: content ?? this.content,
    hookLine: hookLine.present ? hookLine.value : this.hookLine,
    status: status ?? this.status,
    platform: platform ?? this.platform,
    scheduledAt: scheduledAt.present ? scheduledAt.value : this.scheduledAt,
    publishedAt: publishedAt.present ? publishedAt.value : this.publishedAt,
    errorMessage: errorMessage.present ? errorMessage.value : this.errorMessage,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  PostsTableData copyWithCompanion(PostsTableCompanion data) {
    return PostsTableData(
      id: data.id.present ? data.id.value : this.id,
      remoteId: data.remoteId.present ? data.remoteId.value : this.remoteId,
      content: data.content.present ? data.content.value : this.content,
      hookLine: data.hookLine.present ? data.hookLine.value : this.hookLine,
      status: data.status.present ? data.status.value : this.status,
      platform: data.platform.present ? data.platform.value : this.platform,
      scheduledAt: data.scheduledAt.present
          ? data.scheduledAt.value
          : this.scheduledAt,
      publishedAt: data.publishedAt.present
          ? data.publishedAt.value
          : this.publishedAt,
      errorMessage: data.errorMessage.present
          ? data.errorMessage.value
          : this.errorMessage,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PostsTableData(')
          ..write('id: $id, ')
          ..write('remoteId: $remoteId, ')
          ..write('content: $content, ')
          ..write('hookLine: $hookLine, ')
          ..write('status: $status, ')
          ..write('platform: $platform, ')
          ..write('scheduledAt: $scheduledAt, ')
          ..write('publishedAt: $publishedAt, ')
          ..write('errorMessage: $errorMessage, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    remoteId,
    content,
    hookLine,
    status,
    platform,
    scheduledAt,
    publishedAt,
    errorMessage,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PostsTableData &&
          other.id == this.id &&
          other.remoteId == this.remoteId &&
          other.content == this.content &&
          other.hookLine == this.hookLine &&
          other.status == this.status &&
          other.platform == this.platform &&
          other.scheduledAt == this.scheduledAt &&
          other.publishedAt == this.publishedAt &&
          other.errorMessage == this.errorMessage &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class PostsTableCompanion extends UpdateCompanion<PostsTableData> {
  final Value<int> id;
  final Value<String?> remoteId;
  final Value<String> content;
  final Value<String?> hookLine;
  final Value<String> status;
  final Value<String> platform;
  final Value<DateTime?> scheduledAt;
  final Value<DateTime?> publishedAt;
  final Value<String?> errorMessage;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const PostsTableCompanion({
    this.id = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.content = const Value.absent(),
    this.hookLine = const Value.absent(),
    this.status = const Value.absent(),
    this.platform = const Value.absent(),
    this.scheduledAt = const Value.absent(),
    this.publishedAt = const Value.absent(),
    this.errorMessage = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  PostsTableCompanion.insert({
    this.id = const Value.absent(),
    this.remoteId = const Value.absent(),
    required String content,
    this.hookLine = const Value.absent(),
    this.status = const Value.absent(),
    this.platform = const Value.absent(),
    this.scheduledAt = const Value.absent(),
    this.publishedAt = const Value.absent(),
    this.errorMessage = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : content = Value(content);
  static Insertable<PostsTableData> custom({
    Expression<int>? id,
    Expression<String>? remoteId,
    Expression<String>? content,
    Expression<String>? hookLine,
    Expression<String>? status,
    Expression<String>? platform,
    Expression<DateTime>? scheduledAt,
    Expression<DateTime>? publishedAt,
    Expression<String>? errorMessage,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (remoteId != null) 'remote_id': remoteId,
      if (content != null) 'content': content,
      if (hookLine != null) 'hook_line': hookLine,
      if (status != null) 'status': status,
      if (platform != null) 'platform': platform,
      if (scheduledAt != null) 'scheduled_at': scheduledAt,
      if (publishedAt != null) 'published_at': publishedAt,
      if (errorMessage != null) 'error_message': errorMessage,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  PostsTableCompanion copyWith({
    Value<int>? id,
    Value<String?>? remoteId,
    Value<String>? content,
    Value<String?>? hookLine,
    Value<String>? status,
    Value<String>? platform,
    Value<DateTime?>? scheduledAt,
    Value<DateTime?>? publishedAt,
    Value<String?>? errorMessage,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return PostsTableCompanion(
      id: id ?? this.id,
      remoteId: remoteId ?? this.remoteId,
      content: content ?? this.content,
      hookLine: hookLine ?? this.hookLine,
      status: status ?? this.status,
      platform: platform ?? this.platform,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      publishedAt: publishedAt ?? this.publishedAt,
      errorMessage: errorMessage ?? this.errorMessage,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (remoteId.present) {
      map['remote_id'] = Variable<String>(remoteId.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (hookLine.present) {
      map['hook_line'] = Variable<String>(hookLine.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (platform.present) {
      map['platform'] = Variable<String>(platform.value);
    }
    if (scheduledAt.present) {
      map['scheduled_at'] = Variable<DateTime>(scheduledAt.value);
    }
    if (publishedAt.present) {
      map['published_at'] = Variable<DateTime>(publishedAt.value);
    }
    if (errorMessage.present) {
      map['error_message'] = Variable<String>(errorMessage.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PostsTableCompanion(')
          ..write('id: $id, ')
          ..write('remoteId: $remoteId, ')
          ..write('content: $content, ')
          ..write('hookLine: $hookLine, ')
          ..write('status: $status, ')
          ..write('platform: $platform, ')
          ..write('scheduledAt: $scheduledAt, ')
          ..write('publishedAt: $publishedAt, ')
          ..write('errorMessage: $errorMessage, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $PostMetricsTableTable extends PostMetricsTable
    with TableInfo<$PostMetricsTableTable, PostMetricsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PostMetricsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _postIdMeta = const VerificationMeta('postId');
  @override
  late final GeneratedColumn<int> postId = GeneratedColumn<int>(
    'post_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES posts (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _impressionsMeta = const VerificationMeta(
    'impressions',
  );
  @override
  late final GeneratedColumn<int> impressions = GeneratedColumn<int>(
    'impressions',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _engagementsMeta = const VerificationMeta(
    'engagements',
  );
  @override
  late final GeneratedColumn<int> engagements = GeneratedColumn<int>(
    'engagements',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _commentsMeta = const VerificationMeta(
    'comments',
  );
  @override
  late final GeneratedColumn<int> comments = GeneratedColumn<int>(
    'comments',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _repostsMeta = const VerificationMeta(
    'reposts',
  );
  @override
  late final GeneratedColumn<int> reposts = GeneratedColumn<int>(
    'reposts',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _likesMeta = const VerificationMeta('likes');
  @override
  late final GeneratedColumn<int> likes = GeneratedColumn<int>(
    'likes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _fetchedAtMeta = const VerificationMeta(
    'fetchedAt',
  );
  @override
  late final GeneratedColumn<DateTime> fetchedAt = GeneratedColumn<DateTime>(
    'fetched_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    postId,
    impressions,
    engagements,
    comments,
    reposts,
    likes,
    fetchedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'post_metrics';
  @override
  VerificationContext validateIntegrity(
    Insertable<PostMetricsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('post_id')) {
      context.handle(
        _postIdMeta,
        postId.isAcceptableOrUnknown(data['post_id']!, _postIdMeta),
      );
    } else if (isInserting) {
      context.missing(_postIdMeta);
    }
    if (data.containsKey('impressions')) {
      context.handle(
        _impressionsMeta,
        impressions.isAcceptableOrUnknown(
          data['impressions']!,
          _impressionsMeta,
        ),
      );
    }
    if (data.containsKey('engagements')) {
      context.handle(
        _engagementsMeta,
        engagements.isAcceptableOrUnknown(
          data['engagements']!,
          _engagementsMeta,
        ),
      );
    }
    if (data.containsKey('comments')) {
      context.handle(
        _commentsMeta,
        comments.isAcceptableOrUnknown(data['comments']!, _commentsMeta),
      );
    }
    if (data.containsKey('reposts')) {
      context.handle(
        _repostsMeta,
        reposts.isAcceptableOrUnknown(data['reposts']!, _repostsMeta),
      );
    }
    if (data.containsKey('likes')) {
      context.handle(
        _likesMeta,
        likes.isAcceptableOrUnknown(data['likes']!, _likesMeta),
      );
    }
    if (data.containsKey('fetched_at')) {
      context.handle(
        _fetchedAtMeta,
        fetchedAt.isAcceptableOrUnknown(data['fetched_at']!, _fetchedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PostMetricsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PostMetricsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      postId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}post_id'],
      )!,
      impressions: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}impressions'],
      )!,
      engagements: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}engagements'],
      )!,
      comments: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}comments'],
      )!,
      reposts: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reposts'],
      )!,
      likes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}likes'],
      )!,
      fetchedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fetched_at'],
      )!,
    );
  }

  @override
  $PostMetricsTableTable createAlias(String alias) {
    return $PostMetricsTableTable(attachedDatabase, alias);
  }
}

class PostMetricsTableData extends DataClass
    implements Insertable<PostMetricsTableData> {
  final int id;
  final int postId;
  final int impressions;
  final int engagements;
  final int comments;
  final int reposts;
  final int likes;
  final DateTime fetchedAt;
  const PostMetricsTableData({
    required this.id,
    required this.postId,
    required this.impressions,
    required this.engagements,
    required this.comments,
    required this.reposts,
    required this.likes,
    required this.fetchedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['post_id'] = Variable<int>(postId);
    map['impressions'] = Variable<int>(impressions);
    map['engagements'] = Variable<int>(engagements);
    map['comments'] = Variable<int>(comments);
    map['reposts'] = Variable<int>(reposts);
    map['likes'] = Variable<int>(likes);
    map['fetched_at'] = Variable<DateTime>(fetchedAt);
    return map;
  }

  PostMetricsTableCompanion toCompanion(bool nullToAbsent) {
    return PostMetricsTableCompanion(
      id: Value(id),
      postId: Value(postId),
      impressions: Value(impressions),
      engagements: Value(engagements),
      comments: Value(comments),
      reposts: Value(reposts),
      likes: Value(likes),
      fetchedAt: Value(fetchedAt),
    );
  }

  factory PostMetricsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PostMetricsTableData(
      id: serializer.fromJson<int>(json['id']),
      postId: serializer.fromJson<int>(json['postId']),
      impressions: serializer.fromJson<int>(json['impressions']),
      engagements: serializer.fromJson<int>(json['engagements']),
      comments: serializer.fromJson<int>(json['comments']),
      reposts: serializer.fromJson<int>(json['reposts']),
      likes: serializer.fromJson<int>(json['likes']),
      fetchedAt: serializer.fromJson<DateTime>(json['fetchedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'postId': serializer.toJson<int>(postId),
      'impressions': serializer.toJson<int>(impressions),
      'engagements': serializer.toJson<int>(engagements),
      'comments': serializer.toJson<int>(comments),
      'reposts': serializer.toJson<int>(reposts),
      'likes': serializer.toJson<int>(likes),
      'fetchedAt': serializer.toJson<DateTime>(fetchedAt),
    };
  }

  PostMetricsTableData copyWith({
    int? id,
    int? postId,
    int? impressions,
    int? engagements,
    int? comments,
    int? reposts,
    int? likes,
    DateTime? fetchedAt,
  }) => PostMetricsTableData(
    id: id ?? this.id,
    postId: postId ?? this.postId,
    impressions: impressions ?? this.impressions,
    engagements: engagements ?? this.engagements,
    comments: comments ?? this.comments,
    reposts: reposts ?? this.reposts,
    likes: likes ?? this.likes,
    fetchedAt: fetchedAt ?? this.fetchedAt,
  );
  PostMetricsTableData copyWithCompanion(PostMetricsTableCompanion data) {
    return PostMetricsTableData(
      id: data.id.present ? data.id.value : this.id,
      postId: data.postId.present ? data.postId.value : this.postId,
      impressions: data.impressions.present
          ? data.impressions.value
          : this.impressions,
      engagements: data.engagements.present
          ? data.engagements.value
          : this.engagements,
      comments: data.comments.present ? data.comments.value : this.comments,
      reposts: data.reposts.present ? data.reposts.value : this.reposts,
      likes: data.likes.present ? data.likes.value : this.likes,
      fetchedAt: data.fetchedAt.present ? data.fetchedAt.value : this.fetchedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PostMetricsTableData(')
          ..write('id: $id, ')
          ..write('postId: $postId, ')
          ..write('impressions: $impressions, ')
          ..write('engagements: $engagements, ')
          ..write('comments: $comments, ')
          ..write('reposts: $reposts, ')
          ..write('likes: $likes, ')
          ..write('fetchedAt: $fetchedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    postId,
    impressions,
    engagements,
    comments,
    reposts,
    likes,
    fetchedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PostMetricsTableData &&
          other.id == this.id &&
          other.postId == this.postId &&
          other.impressions == this.impressions &&
          other.engagements == this.engagements &&
          other.comments == this.comments &&
          other.reposts == this.reposts &&
          other.likes == this.likes &&
          other.fetchedAt == this.fetchedAt);
}

class PostMetricsTableCompanion extends UpdateCompanion<PostMetricsTableData> {
  final Value<int> id;
  final Value<int> postId;
  final Value<int> impressions;
  final Value<int> engagements;
  final Value<int> comments;
  final Value<int> reposts;
  final Value<int> likes;
  final Value<DateTime> fetchedAt;
  const PostMetricsTableCompanion({
    this.id = const Value.absent(),
    this.postId = const Value.absent(),
    this.impressions = const Value.absent(),
    this.engagements = const Value.absent(),
    this.comments = const Value.absent(),
    this.reposts = const Value.absent(),
    this.likes = const Value.absent(),
    this.fetchedAt = const Value.absent(),
  });
  PostMetricsTableCompanion.insert({
    this.id = const Value.absent(),
    required int postId,
    this.impressions = const Value.absent(),
    this.engagements = const Value.absent(),
    this.comments = const Value.absent(),
    this.reposts = const Value.absent(),
    this.likes = const Value.absent(),
    this.fetchedAt = const Value.absent(),
  }) : postId = Value(postId);
  static Insertable<PostMetricsTableData> custom({
    Expression<int>? id,
    Expression<int>? postId,
    Expression<int>? impressions,
    Expression<int>? engagements,
    Expression<int>? comments,
    Expression<int>? reposts,
    Expression<int>? likes,
    Expression<DateTime>? fetchedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (postId != null) 'post_id': postId,
      if (impressions != null) 'impressions': impressions,
      if (engagements != null) 'engagements': engagements,
      if (comments != null) 'comments': comments,
      if (reposts != null) 'reposts': reposts,
      if (likes != null) 'likes': likes,
      if (fetchedAt != null) 'fetched_at': fetchedAt,
    });
  }

  PostMetricsTableCompanion copyWith({
    Value<int>? id,
    Value<int>? postId,
    Value<int>? impressions,
    Value<int>? engagements,
    Value<int>? comments,
    Value<int>? reposts,
    Value<int>? likes,
    Value<DateTime>? fetchedAt,
  }) {
    return PostMetricsTableCompanion(
      id: id ?? this.id,
      postId: postId ?? this.postId,
      impressions: impressions ?? this.impressions,
      engagements: engagements ?? this.engagements,
      comments: comments ?? this.comments,
      reposts: reposts ?? this.reposts,
      likes: likes ?? this.likes,
      fetchedAt: fetchedAt ?? this.fetchedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (postId.present) {
      map['post_id'] = Variable<int>(postId.value);
    }
    if (impressions.present) {
      map['impressions'] = Variable<int>(impressions.value);
    }
    if (engagements.present) {
      map['engagements'] = Variable<int>(engagements.value);
    }
    if (comments.present) {
      map['comments'] = Variable<int>(comments.value);
    }
    if (reposts.present) {
      map['reposts'] = Variable<int>(reposts.value);
    }
    if (likes.present) {
      map['likes'] = Variable<int>(likes.value);
    }
    if (fetchedAt.present) {
      map['fetched_at'] = Variable<DateTime>(fetchedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PostMetricsTableCompanion(')
          ..write('id: $id, ')
          ..write('postId: $postId, ')
          ..write('impressions: $impressions, ')
          ..write('engagements: $engagements, ')
          ..write('comments: $comments, ')
          ..write('reposts: $reposts, ')
          ..write('likes: $likes, ')
          ..write('fetchedAt: $fetchedAt')
          ..write(')'))
        .toString();
  }
}

class $UserStatsTableTable extends UserStatsTable
    with TableInfo<$UserStatsTableTable, UserStatsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserStatsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _streakDaysMeta = const VerificationMeta(
    'streakDays',
  );
  @override
  late final GeneratedColumn<int> streakDays = GeneratedColumn<int>(
    'streak_days',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _xpMeta = const VerificationMeta('xp');
  @override
  late final GeneratedColumn<int> xp = GeneratedColumn<int>(
    'xp',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<int> level = GeneratedColumn<int>(
    'level',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _levelTitleMeta = const VerificationMeta(
    'levelTitle',
  );
  @override
  late final GeneratedColumn<String> levelTitle = GeneratedColumn<String>(
    'level_title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Beginner'),
  );
  static const VerificationMeta _weeklyXpMeta = const VerificationMeta(
    'weeklyXp',
  );
  @override
  late final GeneratedColumn<int> weeklyXp = GeneratedColumn<int>(
    'weekly_xp',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _weeklyXpGoalMeta = const VerificationMeta(
    'weeklyXpGoal',
  );
  @override
  late final GeneratedColumn<int> weeklyXpGoal = GeneratedColumn<int>(
    'weekly_xp_goal',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(2000),
  );
  static const VerificationMeta _lastActiveDateStrMeta = const VerificationMeta(
    'lastActiveDateStr',
  );
  @override
  late final GeneratedColumn<String> lastActiveDateStr =
      GeneratedColumn<String>(
        'last_active_date_str',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    streakDays,
    xp,
    level,
    levelTitle,
    weeklyXp,
    weeklyXpGoal,
    lastActiveDateStr,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_stats';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserStatsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('streak_days')) {
      context.handle(
        _streakDaysMeta,
        streakDays.isAcceptableOrUnknown(data['streak_days']!, _streakDaysMeta),
      );
    }
    if (data.containsKey('xp')) {
      context.handle(_xpMeta, xp.isAcceptableOrUnknown(data['xp']!, _xpMeta));
    }
    if (data.containsKey('level')) {
      context.handle(
        _levelMeta,
        level.isAcceptableOrUnknown(data['level']!, _levelMeta),
      );
    }
    if (data.containsKey('level_title')) {
      context.handle(
        _levelTitleMeta,
        levelTitle.isAcceptableOrUnknown(data['level_title']!, _levelTitleMeta),
      );
    }
    if (data.containsKey('weekly_xp')) {
      context.handle(
        _weeklyXpMeta,
        weeklyXp.isAcceptableOrUnknown(data['weekly_xp']!, _weeklyXpMeta),
      );
    }
    if (data.containsKey('weekly_xp_goal')) {
      context.handle(
        _weeklyXpGoalMeta,
        weeklyXpGoal.isAcceptableOrUnknown(
          data['weekly_xp_goal']!,
          _weeklyXpGoalMeta,
        ),
      );
    }
    if (data.containsKey('last_active_date_str')) {
      context.handle(
        _lastActiveDateStrMeta,
        lastActiveDateStr.isAcceptableOrUnknown(
          data['last_active_date_str']!,
          _lastActiveDateStrMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserStatsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserStatsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      streakDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}streak_days'],
      )!,
      xp: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}xp'],
      )!,
      level: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}level'],
      )!,
      levelTitle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}level_title'],
      )!,
      weeklyXp: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}weekly_xp'],
      )!,
      weeklyXpGoal: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}weekly_xp_goal'],
      )!,
      lastActiveDateStr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_active_date_str'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $UserStatsTableTable createAlias(String alias) {
    return $UserStatsTableTable(attachedDatabase, alias);
  }
}

class UserStatsTableData extends DataClass
    implements Insertable<UserStatsTableData> {
  final int id;
  final int streakDays;
  final int xp;
  final int level;
  final String levelTitle;
  final int weeklyXp;
  final int weeklyXpGoal;
  final String? lastActiveDateStr;
  final DateTime updatedAt;
  const UserStatsTableData({
    required this.id,
    required this.streakDays,
    required this.xp,
    required this.level,
    required this.levelTitle,
    required this.weeklyXp,
    required this.weeklyXpGoal,
    this.lastActiveDateStr,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['streak_days'] = Variable<int>(streakDays);
    map['xp'] = Variable<int>(xp);
    map['level'] = Variable<int>(level);
    map['level_title'] = Variable<String>(levelTitle);
    map['weekly_xp'] = Variable<int>(weeklyXp);
    map['weekly_xp_goal'] = Variable<int>(weeklyXpGoal);
    if (!nullToAbsent || lastActiveDateStr != null) {
      map['last_active_date_str'] = Variable<String>(lastActiveDateStr);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  UserStatsTableCompanion toCompanion(bool nullToAbsent) {
    return UserStatsTableCompanion(
      id: Value(id),
      streakDays: Value(streakDays),
      xp: Value(xp),
      level: Value(level),
      levelTitle: Value(levelTitle),
      weeklyXp: Value(weeklyXp),
      weeklyXpGoal: Value(weeklyXpGoal),
      lastActiveDateStr: lastActiveDateStr == null && nullToAbsent
          ? const Value.absent()
          : Value(lastActiveDateStr),
      updatedAt: Value(updatedAt),
    );
  }

  factory UserStatsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserStatsTableData(
      id: serializer.fromJson<int>(json['id']),
      streakDays: serializer.fromJson<int>(json['streakDays']),
      xp: serializer.fromJson<int>(json['xp']),
      level: serializer.fromJson<int>(json['level']),
      levelTitle: serializer.fromJson<String>(json['levelTitle']),
      weeklyXp: serializer.fromJson<int>(json['weeklyXp']),
      weeklyXpGoal: serializer.fromJson<int>(json['weeklyXpGoal']),
      lastActiveDateStr: serializer.fromJson<String?>(
        json['lastActiveDateStr'],
      ),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'streakDays': serializer.toJson<int>(streakDays),
      'xp': serializer.toJson<int>(xp),
      'level': serializer.toJson<int>(level),
      'levelTitle': serializer.toJson<String>(levelTitle),
      'weeklyXp': serializer.toJson<int>(weeklyXp),
      'weeklyXpGoal': serializer.toJson<int>(weeklyXpGoal),
      'lastActiveDateStr': serializer.toJson<String?>(lastActiveDateStr),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  UserStatsTableData copyWith({
    int? id,
    int? streakDays,
    int? xp,
    int? level,
    String? levelTitle,
    int? weeklyXp,
    int? weeklyXpGoal,
    Value<String?> lastActiveDateStr = const Value.absent(),
    DateTime? updatedAt,
  }) => UserStatsTableData(
    id: id ?? this.id,
    streakDays: streakDays ?? this.streakDays,
    xp: xp ?? this.xp,
    level: level ?? this.level,
    levelTitle: levelTitle ?? this.levelTitle,
    weeklyXp: weeklyXp ?? this.weeklyXp,
    weeklyXpGoal: weeklyXpGoal ?? this.weeklyXpGoal,
    lastActiveDateStr: lastActiveDateStr.present
        ? lastActiveDateStr.value
        : this.lastActiveDateStr,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  UserStatsTableData copyWithCompanion(UserStatsTableCompanion data) {
    return UserStatsTableData(
      id: data.id.present ? data.id.value : this.id,
      streakDays: data.streakDays.present
          ? data.streakDays.value
          : this.streakDays,
      xp: data.xp.present ? data.xp.value : this.xp,
      level: data.level.present ? data.level.value : this.level,
      levelTitle: data.levelTitle.present
          ? data.levelTitle.value
          : this.levelTitle,
      weeklyXp: data.weeklyXp.present ? data.weeklyXp.value : this.weeklyXp,
      weeklyXpGoal: data.weeklyXpGoal.present
          ? data.weeklyXpGoal.value
          : this.weeklyXpGoal,
      lastActiveDateStr: data.lastActiveDateStr.present
          ? data.lastActiveDateStr.value
          : this.lastActiveDateStr,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserStatsTableData(')
          ..write('id: $id, ')
          ..write('streakDays: $streakDays, ')
          ..write('xp: $xp, ')
          ..write('level: $level, ')
          ..write('levelTitle: $levelTitle, ')
          ..write('weeklyXp: $weeklyXp, ')
          ..write('weeklyXpGoal: $weeklyXpGoal, ')
          ..write('lastActiveDateStr: $lastActiveDateStr, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    streakDays,
    xp,
    level,
    levelTitle,
    weeklyXp,
    weeklyXpGoal,
    lastActiveDateStr,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserStatsTableData &&
          other.id == this.id &&
          other.streakDays == this.streakDays &&
          other.xp == this.xp &&
          other.level == this.level &&
          other.levelTitle == this.levelTitle &&
          other.weeklyXp == this.weeklyXp &&
          other.weeklyXpGoal == this.weeklyXpGoal &&
          other.lastActiveDateStr == this.lastActiveDateStr &&
          other.updatedAt == this.updatedAt);
}

class UserStatsTableCompanion extends UpdateCompanion<UserStatsTableData> {
  final Value<int> id;
  final Value<int> streakDays;
  final Value<int> xp;
  final Value<int> level;
  final Value<String> levelTitle;
  final Value<int> weeklyXp;
  final Value<int> weeklyXpGoal;
  final Value<String?> lastActiveDateStr;
  final Value<DateTime> updatedAt;
  const UserStatsTableCompanion({
    this.id = const Value.absent(),
    this.streakDays = const Value.absent(),
    this.xp = const Value.absent(),
    this.level = const Value.absent(),
    this.levelTitle = const Value.absent(),
    this.weeklyXp = const Value.absent(),
    this.weeklyXpGoal = const Value.absent(),
    this.lastActiveDateStr = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  UserStatsTableCompanion.insert({
    this.id = const Value.absent(),
    this.streakDays = const Value.absent(),
    this.xp = const Value.absent(),
    this.level = const Value.absent(),
    this.levelTitle = const Value.absent(),
    this.weeklyXp = const Value.absent(),
    this.weeklyXpGoal = const Value.absent(),
    this.lastActiveDateStr = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  static Insertable<UserStatsTableData> custom({
    Expression<int>? id,
    Expression<int>? streakDays,
    Expression<int>? xp,
    Expression<int>? level,
    Expression<String>? levelTitle,
    Expression<int>? weeklyXp,
    Expression<int>? weeklyXpGoal,
    Expression<String>? lastActiveDateStr,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (streakDays != null) 'streak_days': streakDays,
      if (xp != null) 'xp': xp,
      if (level != null) 'level': level,
      if (levelTitle != null) 'level_title': levelTitle,
      if (weeklyXp != null) 'weekly_xp': weeklyXp,
      if (weeklyXpGoal != null) 'weekly_xp_goal': weeklyXpGoal,
      if (lastActiveDateStr != null) 'last_active_date_str': lastActiveDateStr,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  UserStatsTableCompanion copyWith({
    Value<int>? id,
    Value<int>? streakDays,
    Value<int>? xp,
    Value<int>? level,
    Value<String>? levelTitle,
    Value<int>? weeklyXp,
    Value<int>? weeklyXpGoal,
    Value<String?>? lastActiveDateStr,
    Value<DateTime>? updatedAt,
  }) {
    return UserStatsTableCompanion(
      id: id ?? this.id,
      streakDays: streakDays ?? this.streakDays,
      xp: xp ?? this.xp,
      level: level ?? this.level,
      levelTitle: levelTitle ?? this.levelTitle,
      weeklyXp: weeklyXp ?? this.weeklyXp,
      weeklyXpGoal: weeklyXpGoal ?? this.weeklyXpGoal,
      lastActiveDateStr: lastActiveDateStr ?? this.lastActiveDateStr,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (streakDays.present) {
      map['streak_days'] = Variable<int>(streakDays.value);
    }
    if (xp.present) {
      map['xp'] = Variable<int>(xp.value);
    }
    if (level.present) {
      map['level'] = Variable<int>(level.value);
    }
    if (levelTitle.present) {
      map['level_title'] = Variable<String>(levelTitle.value);
    }
    if (weeklyXp.present) {
      map['weekly_xp'] = Variable<int>(weeklyXp.value);
    }
    if (weeklyXpGoal.present) {
      map['weekly_xp_goal'] = Variable<int>(weeklyXpGoal.value);
    }
    if (lastActiveDateStr.present) {
      map['last_active_date_str'] = Variable<String>(lastActiveDateStr.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserStatsTableCompanion(')
          ..write('id: $id, ')
          ..write('streakDays: $streakDays, ')
          ..write('xp: $xp, ')
          ..write('level: $level, ')
          ..write('levelTitle: $levelTitle, ')
          ..write('weeklyXp: $weeklyXp, ')
          ..write('weeklyXpGoal: $weeklyXpGoal, ')
          ..write('lastActiveDateStr: $lastActiveDateStr, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $MissionsTableTable extends MissionsTable
    with TableInfo<$MissionsTableTable, MissionsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MissionsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _missionKeyMeta = const VerificationMeta(
    'missionKey',
  );
  @override
  late final GeneratedColumn<String> missionKey = GeneratedColumn<String>(
    'mission_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('locked'),
  );
  static const VerificationMeta _xpRewardMeta = const VerificationMeta(
    'xpReward',
  );
  @override
  late final GeneratedColumn<int> xpReward = GeneratedColumn<int>(
    'xp_reward',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(100),
  );
  static const VerificationMeta _progressMeta = const VerificationMeta(
    'progress',
  );
  @override
  late final GeneratedColumn<int> progress = GeneratedColumn<int>(
    'progress',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _totalMeta = const VerificationMeta('total');
  @override
  late final GeneratedColumn<int> total = GeneratedColumn<int>(
    'total',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    missionKey,
    title,
    description,
    status,
    xpReward,
    progress,
    total,
    sortOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'missions';
  @override
  VerificationContext validateIntegrity(
    Insertable<MissionsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('mission_key')) {
      context.handle(
        _missionKeyMeta,
        missionKey.isAcceptableOrUnknown(data['mission_key']!, _missionKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_missionKeyMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('xp_reward')) {
      context.handle(
        _xpRewardMeta,
        xpReward.isAcceptableOrUnknown(data['xp_reward']!, _xpRewardMeta),
      );
    }
    if (data.containsKey('progress')) {
      context.handle(
        _progressMeta,
        progress.isAcceptableOrUnknown(data['progress']!, _progressMeta),
      );
    }
    if (data.containsKey('total')) {
      context.handle(
        _totalMeta,
        total.isAcceptableOrUnknown(data['total']!, _totalMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MissionsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MissionsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      missionKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mission_key'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      xpReward: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}xp_reward'],
      )!,
      progress: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}progress'],
      )!,
      total: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $MissionsTableTable createAlias(String alias) {
    return $MissionsTableTable(attachedDatabase, alias);
  }
}

class MissionsTableData extends DataClass
    implements Insertable<MissionsTableData> {
  final int id;
  final String missionKey;
  final String title;
  final String description;
  final String status;
  final int xpReward;
  final int progress;
  final int total;
  final int sortOrder;
  const MissionsTableData({
    required this.id,
    required this.missionKey,
    required this.title,
    required this.description,
    required this.status,
    required this.xpReward,
    required this.progress,
    required this.total,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['mission_key'] = Variable<String>(missionKey);
    map['title'] = Variable<String>(title);
    map['description'] = Variable<String>(description);
    map['status'] = Variable<String>(status);
    map['xp_reward'] = Variable<int>(xpReward);
    map['progress'] = Variable<int>(progress);
    map['total'] = Variable<int>(total);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  MissionsTableCompanion toCompanion(bool nullToAbsent) {
    return MissionsTableCompanion(
      id: Value(id),
      missionKey: Value(missionKey),
      title: Value(title),
      description: Value(description),
      status: Value(status),
      xpReward: Value(xpReward),
      progress: Value(progress),
      total: Value(total),
      sortOrder: Value(sortOrder),
    );
  }

  factory MissionsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MissionsTableData(
      id: serializer.fromJson<int>(json['id']),
      missionKey: serializer.fromJson<String>(json['missionKey']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String>(json['description']),
      status: serializer.fromJson<String>(json['status']),
      xpReward: serializer.fromJson<int>(json['xpReward']),
      progress: serializer.fromJson<int>(json['progress']),
      total: serializer.fromJson<int>(json['total']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'missionKey': serializer.toJson<String>(missionKey),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String>(description),
      'status': serializer.toJson<String>(status),
      'xpReward': serializer.toJson<int>(xpReward),
      'progress': serializer.toJson<int>(progress),
      'total': serializer.toJson<int>(total),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  MissionsTableData copyWith({
    int? id,
    String? missionKey,
    String? title,
    String? description,
    String? status,
    int? xpReward,
    int? progress,
    int? total,
    int? sortOrder,
  }) => MissionsTableData(
    id: id ?? this.id,
    missionKey: missionKey ?? this.missionKey,
    title: title ?? this.title,
    description: description ?? this.description,
    status: status ?? this.status,
    xpReward: xpReward ?? this.xpReward,
    progress: progress ?? this.progress,
    total: total ?? this.total,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  MissionsTableData copyWithCompanion(MissionsTableCompanion data) {
    return MissionsTableData(
      id: data.id.present ? data.id.value : this.id,
      missionKey: data.missionKey.present
          ? data.missionKey.value
          : this.missionKey,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      status: data.status.present ? data.status.value : this.status,
      xpReward: data.xpReward.present ? data.xpReward.value : this.xpReward,
      progress: data.progress.present ? data.progress.value : this.progress,
      total: data.total.present ? data.total.value : this.total,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MissionsTableData(')
          ..write('id: $id, ')
          ..write('missionKey: $missionKey, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('status: $status, ')
          ..write('xpReward: $xpReward, ')
          ..write('progress: $progress, ')
          ..write('total: $total, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    missionKey,
    title,
    description,
    status,
    xpReward,
    progress,
    total,
    sortOrder,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MissionsTableData &&
          other.id == this.id &&
          other.missionKey == this.missionKey &&
          other.title == this.title &&
          other.description == this.description &&
          other.status == this.status &&
          other.xpReward == this.xpReward &&
          other.progress == this.progress &&
          other.total == this.total &&
          other.sortOrder == this.sortOrder);
}

class MissionsTableCompanion extends UpdateCompanion<MissionsTableData> {
  final Value<int> id;
  final Value<String> missionKey;
  final Value<String> title;
  final Value<String> description;
  final Value<String> status;
  final Value<int> xpReward;
  final Value<int> progress;
  final Value<int> total;
  final Value<int> sortOrder;
  const MissionsTableCompanion({
    this.id = const Value.absent(),
    this.missionKey = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.status = const Value.absent(),
    this.xpReward = const Value.absent(),
    this.progress = const Value.absent(),
    this.total = const Value.absent(),
    this.sortOrder = const Value.absent(),
  });
  MissionsTableCompanion.insert({
    this.id = const Value.absent(),
    required String missionKey,
    required String title,
    required String description,
    this.status = const Value.absent(),
    this.xpReward = const Value.absent(),
    this.progress = const Value.absent(),
    this.total = const Value.absent(),
    this.sortOrder = const Value.absent(),
  }) : missionKey = Value(missionKey),
       title = Value(title),
       description = Value(description);
  static Insertable<MissionsTableData> custom({
    Expression<int>? id,
    Expression<String>? missionKey,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? status,
    Expression<int>? xpReward,
    Expression<int>? progress,
    Expression<int>? total,
    Expression<int>? sortOrder,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (missionKey != null) 'mission_key': missionKey,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (status != null) 'status': status,
      if (xpReward != null) 'xp_reward': xpReward,
      if (progress != null) 'progress': progress,
      if (total != null) 'total': total,
      if (sortOrder != null) 'sort_order': sortOrder,
    });
  }

  MissionsTableCompanion copyWith({
    Value<int>? id,
    Value<String>? missionKey,
    Value<String>? title,
    Value<String>? description,
    Value<String>? status,
    Value<int>? xpReward,
    Value<int>? progress,
    Value<int>? total,
    Value<int>? sortOrder,
  }) {
    return MissionsTableCompanion(
      id: id ?? this.id,
      missionKey: missionKey ?? this.missionKey,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      xpReward: xpReward ?? this.xpReward,
      progress: progress ?? this.progress,
      total: total ?? this.total,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (missionKey.present) {
      map['mission_key'] = Variable<String>(missionKey.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (xpReward.present) {
      map['xp_reward'] = Variable<int>(xpReward.value);
    }
    if (progress.present) {
      map['progress'] = Variable<int>(progress.value);
    }
    if (total.present) {
      map['total'] = Variable<int>(total.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MissionsTableCompanion(')
          ..write('id: $id, ')
          ..write('missionKey: $missionKey, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('status: $status, ')
          ..write('xpReward: $xpReward, ')
          ..write('progress: $progress, ')
          ..write('total: $total, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }
}

class $NotificationsTableTable extends NotificationsTable
    with TableInfo<$NotificationsTableTable, NotificationsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NotificationsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _remoteIdMeta = const VerificationMeta(
    'remoteId',
  );
  @override
  late final GeneratedColumn<String> remoteId = GeneratedColumn<String>(
    'remote_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
    'body',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('general'),
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isReadMeta = const VerificationMeta('isRead');
  @override
  late final GeneratedColumn<bool> isRead = GeneratedColumn<bool>(
    'is_read',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_read" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _receivedAtMeta = const VerificationMeta(
    'receivedAt',
  );
  @override
  late final GeneratedColumn<DateTime> receivedAt = GeneratedColumn<DateTime>(
    'received_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    remoteId,
    title,
    body,
    type,
    payload,
    isRead,
    receivedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'notifications';
  @override
  VerificationContext validateIntegrity(
    Insertable<NotificationsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('remote_id')) {
      context.handle(
        _remoteIdMeta,
        remoteId.isAcceptableOrUnknown(data['remote_id']!, _remoteIdMeta),
      );
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('body')) {
      context.handle(
        _bodyMeta,
        body.isAcceptableOrUnknown(data['body']!, _bodyMeta),
      );
    } else if (isInserting) {
      context.missing(_bodyMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    }
    if (data.containsKey('is_read')) {
      context.handle(
        _isReadMeta,
        isRead.isAcceptableOrUnknown(data['is_read']!, _isReadMeta),
      );
    }
    if (data.containsKey('received_at')) {
      context.handle(
        _receivedAtMeta,
        receivedAt.isAcceptableOrUnknown(data['received_at']!, _receivedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  NotificationsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NotificationsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      remoteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}remote_id'],
      ),
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      body: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      ),
      isRead: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_read'],
      )!,
      receivedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}received_at'],
      )!,
    );
  }

  @override
  $NotificationsTableTable createAlias(String alias) {
    return $NotificationsTableTable(attachedDatabase, alias);
  }
}

class NotificationsTableData extends DataClass
    implements Insertable<NotificationsTableData> {
  final int id;
  final String? remoteId;
  final String title;
  final String body;
  final String type;
  final String? payload;
  final bool isRead;
  final DateTime receivedAt;
  const NotificationsTableData({
    required this.id,
    this.remoteId,
    required this.title,
    required this.body,
    required this.type,
    this.payload,
    required this.isRead,
    required this.receivedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || remoteId != null) {
      map['remote_id'] = Variable<String>(remoteId);
    }
    map['title'] = Variable<String>(title);
    map['body'] = Variable<String>(body);
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || payload != null) {
      map['payload'] = Variable<String>(payload);
    }
    map['is_read'] = Variable<bool>(isRead);
    map['received_at'] = Variable<DateTime>(receivedAt);
    return map;
  }

  NotificationsTableCompanion toCompanion(bool nullToAbsent) {
    return NotificationsTableCompanion(
      id: Value(id),
      remoteId: remoteId == null && nullToAbsent
          ? const Value.absent()
          : Value(remoteId),
      title: Value(title),
      body: Value(body),
      type: Value(type),
      payload: payload == null && nullToAbsent
          ? const Value.absent()
          : Value(payload),
      isRead: Value(isRead),
      receivedAt: Value(receivedAt),
    );
  }

  factory NotificationsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NotificationsTableData(
      id: serializer.fromJson<int>(json['id']),
      remoteId: serializer.fromJson<String?>(json['remoteId']),
      title: serializer.fromJson<String>(json['title']),
      body: serializer.fromJson<String>(json['body']),
      type: serializer.fromJson<String>(json['type']),
      payload: serializer.fromJson<String?>(json['payload']),
      isRead: serializer.fromJson<bool>(json['isRead']),
      receivedAt: serializer.fromJson<DateTime>(json['receivedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'remoteId': serializer.toJson<String?>(remoteId),
      'title': serializer.toJson<String>(title),
      'body': serializer.toJson<String>(body),
      'type': serializer.toJson<String>(type),
      'payload': serializer.toJson<String?>(payload),
      'isRead': serializer.toJson<bool>(isRead),
      'receivedAt': serializer.toJson<DateTime>(receivedAt),
    };
  }

  NotificationsTableData copyWith({
    int? id,
    Value<String?> remoteId = const Value.absent(),
    String? title,
    String? body,
    String? type,
    Value<String?> payload = const Value.absent(),
    bool? isRead,
    DateTime? receivedAt,
  }) => NotificationsTableData(
    id: id ?? this.id,
    remoteId: remoteId.present ? remoteId.value : this.remoteId,
    title: title ?? this.title,
    body: body ?? this.body,
    type: type ?? this.type,
    payload: payload.present ? payload.value : this.payload,
    isRead: isRead ?? this.isRead,
    receivedAt: receivedAt ?? this.receivedAt,
  );
  NotificationsTableData copyWithCompanion(NotificationsTableCompanion data) {
    return NotificationsTableData(
      id: data.id.present ? data.id.value : this.id,
      remoteId: data.remoteId.present ? data.remoteId.value : this.remoteId,
      title: data.title.present ? data.title.value : this.title,
      body: data.body.present ? data.body.value : this.body,
      type: data.type.present ? data.type.value : this.type,
      payload: data.payload.present ? data.payload.value : this.payload,
      isRead: data.isRead.present ? data.isRead.value : this.isRead,
      receivedAt: data.receivedAt.present
          ? data.receivedAt.value
          : this.receivedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NotificationsTableData(')
          ..write('id: $id, ')
          ..write('remoteId: $remoteId, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('type: $type, ')
          ..write('payload: $payload, ')
          ..write('isRead: $isRead, ')
          ..write('receivedAt: $receivedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, remoteId, title, body, type, payload, isRead, receivedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NotificationsTableData &&
          other.id == this.id &&
          other.remoteId == this.remoteId &&
          other.title == this.title &&
          other.body == this.body &&
          other.type == this.type &&
          other.payload == this.payload &&
          other.isRead == this.isRead &&
          other.receivedAt == this.receivedAt);
}

class NotificationsTableCompanion
    extends UpdateCompanion<NotificationsTableData> {
  final Value<int> id;
  final Value<String?> remoteId;
  final Value<String> title;
  final Value<String> body;
  final Value<String> type;
  final Value<String?> payload;
  final Value<bool> isRead;
  final Value<DateTime> receivedAt;
  const NotificationsTableCompanion({
    this.id = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.title = const Value.absent(),
    this.body = const Value.absent(),
    this.type = const Value.absent(),
    this.payload = const Value.absent(),
    this.isRead = const Value.absent(),
    this.receivedAt = const Value.absent(),
  });
  NotificationsTableCompanion.insert({
    this.id = const Value.absent(),
    this.remoteId = const Value.absent(),
    required String title,
    required String body,
    this.type = const Value.absent(),
    this.payload = const Value.absent(),
    this.isRead = const Value.absent(),
    this.receivedAt = const Value.absent(),
  }) : title = Value(title),
       body = Value(body);
  static Insertable<NotificationsTableData> custom({
    Expression<int>? id,
    Expression<String>? remoteId,
    Expression<String>? title,
    Expression<String>? body,
    Expression<String>? type,
    Expression<String>? payload,
    Expression<bool>? isRead,
    Expression<DateTime>? receivedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (remoteId != null) 'remote_id': remoteId,
      if (title != null) 'title': title,
      if (body != null) 'body': body,
      if (type != null) 'type': type,
      if (payload != null) 'payload': payload,
      if (isRead != null) 'is_read': isRead,
      if (receivedAt != null) 'received_at': receivedAt,
    });
  }

  NotificationsTableCompanion copyWith({
    Value<int>? id,
    Value<String?>? remoteId,
    Value<String>? title,
    Value<String>? body,
    Value<String>? type,
    Value<String?>? payload,
    Value<bool>? isRead,
    Value<DateTime>? receivedAt,
  }) {
    return NotificationsTableCompanion(
      id: id ?? this.id,
      remoteId: remoteId ?? this.remoteId,
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
      payload: payload ?? this.payload,
      isRead: isRead ?? this.isRead,
      receivedAt: receivedAt ?? this.receivedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (remoteId.present) {
      map['remote_id'] = Variable<String>(remoteId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (isRead.present) {
      map['is_read'] = Variable<bool>(isRead.value);
    }
    if (receivedAt.present) {
      map['received_at'] = Variable<DateTime>(receivedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NotificationsTableCompanion(')
          ..write('id: $id, ')
          ..write('remoteId: $remoteId, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('type: $type, ')
          ..write('payload: $payload, ')
          ..write('isRead: $isRead, ')
          ..write('receivedAt: $receivedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SyncQueueTable syncQueue = $SyncQueueTable(this);
  late final $PostsTableTable postsTable = $PostsTableTable(this);
  late final $PostMetricsTableTable postMetricsTable = $PostMetricsTableTable(
    this,
  );
  late final $UserStatsTableTable userStatsTable = $UserStatsTableTable(this);
  late final $MissionsTableTable missionsTable = $MissionsTableTable(this);
  late final $NotificationsTableTable notificationsTable =
      $NotificationsTableTable(this);
  late final PostsDao postsDao = PostsDao(this as AppDatabase);
  late final UserStatsDao userStatsDao = UserStatsDao(this as AppDatabase);
  late final NotificationDao notificationDao = NotificationDao(
    this as AppDatabase,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    syncQueue,
    postsTable,
    postMetricsTable,
    userStatsTable,
    missionsTable,
    notificationsTable,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'posts',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('post_metrics', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$SyncQueueTableCreateCompanionBuilder =
    SyncQueueCompanion Function({
      required String id,
      required MutationKind kind,
      required String idempotencyKey,
      Value<String?> batchId,
      required String payloadJson,
      required DateTime createdAt,
      Value<DateTime?> nextAttemptAt,
      Value<int> attempts,
      Value<String?> lastError,
      required SyncStatus status,
      Value<int> rowid,
    });
typedef $$SyncQueueTableUpdateCompanionBuilder =
    SyncQueueCompanion Function({
      Value<String> id,
      Value<MutationKind> kind,
      Value<String> idempotencyKey,
      Value<String?> batchId,
      Value<String> payloadJson,
      Value<DateTime> createdAt,
      Value<DateTime?> nextAttemptAt,
      Value<int> attempts,
      Value<String?> lastError,
      Value<SyncStatus> status,
      Value<int> rowid,
    });

class $$SyncQueueTableFilterComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<MutationKind, MutationKind, String> get kind =>
      $composableBuilder(
        column: $table.kind,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get idempotencyKey => $composableBuilder(
    column: $table.idempotencyKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get batchId => $composableBuilder(
    column: $table.batchId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get nextAttemptAt => $composableBuilder(
    column: $table.nextAttemptAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<SyncStatus, SyncStatus, String> get status =>
      $composableBuilder(
        column: $table.status,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );
}

class $$SyncQueueTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get idempotencyKey => $composableBuilder(
    column: $table.idempotencyKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get batchId => $composableBuilder(
    column: $table.batchId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get nextAttemptAt => $composableBuilder(
    column: $table.nextAttemptAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncQueueTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<MutationKind, String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get idempotencyKey => $composableBuilder(
    column: $table.idempotencyKey,
    builder: (column) => column,
  );

  GeneratedColumn<String> get batchId =>
      $composableBuilder(column: $table.batchId, builder: (column) => column);

  GeneratedColumn<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get nextAttemptAt => $composableBuilder(
    column: $table.nextAttemptAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get attempts =>
      $composableBuilder(column: $table.attempts, builder: (column) => column);

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SyncStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);
}

class $$SyncQueueTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncQueueTable,
          SyncQueueData,
          $$SyncQueueTableFilterComposer,
          $$SyncQueueTableOrderingComposer,
          $$SyncQueueTableAnnotationComposer,
          $$SyncQueueTableCreateCompanionBuilder,
          $$SyncQueueTableUpdateCompanionBuilder,
          (
            SyncQueueData,
            BaseReferences<_$AppDatabase, $SyncQueueTable, SyncQueueData>,
          ),
          SyncQueueData,
          PrefetchHooks Function()
        > {
  $$SyncQueueTableTableManager(_$AppDatabase db, $SyncQueueTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncQueueTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncQueueTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncQueueTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<MutationKind> kind = const Value.absent(),
                Value<String> idempotencyKey = const Value.absent(),
                Value<String?> batchId = const Value.absent(),
                Value<String> payloadJson = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> nextAttemptAt = const Value.absent(),
                Value<int> attempts = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<SyncStatus> status = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncQueueCompanion(
                id: id,
                kind: kind,
                idempotencyKey: idempotencyKey,
                batchId: batchId,
                payloadJson: payloadJson,
                createdAt: createdAt,
                nextAttemptAt: nextAttemptAt,
                attempts: attempts,
                lastError: lastError,
                status: status,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required MutationKind kind,
                required String idempotencyKey,
                Value<String?> batchId = const Value.absent(),
                required String payloadJson,
                required DateTime createdAt,
                Value<DateTime?> nextAttemptAt = const Value.absent(),
                Value<int> attempts = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                required SyncStatus status,
                Value<int> rowid = const Value.absent(),
              }) => SyncQueueCompanion.insert(
                id: id,
                kind: kind,
                idempotencyKey: idempotencyKey,
                batchId: batchId,
                payloadJson: payloadJson,
                createdAt: createdAt,
                nextAttemptAt: nextAttemptAt,
                attempts: attempts,
                lastError: lastError,
                status: status,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncQueueTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncQueueTable,
      SyncQueueData,
      $$SyncQueueTableFilterComposer,
      $$SyncQueueTableOrderingComposer,
      $$SyncQueueTableAnnotationComposer,
      $$SyncQueueTableCreateCompanionBuilder,
      $$SyncQueueTableUpdateCompanionBuilder,
      (
        SyncQueueData,
        BaseReferences<_$AppDatabase, $SyncQueueTable, SyncQueueData>,
      ),
      SyncQueueData,
      PrefetchHooks Function()
    >;
typedef $$PostsTableTableCreateCompanionBuilder =
    PostsTableCompanion Function({
      Value<int> id,
      Value<String?> remoteId,
      required String content,
      Value<String?> hookLine,
      Value<String> status,
      Value<String> platform,
      Value<DateTime?> scheduledAt,
      Value<DateTime?> publishedAt,
      Value<String?> errorMessage,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$PostsTableTableUpdateCompanionBuilder =
    PostsTableCompanion Function({
      Value<int> id,
      Value<String?> remoteId,
      Value<String> content,
      Value<String?> hookLine,
      Value<String> status,
      Value<String> platform,
      Value<DateTime?> scheduledAt,
      Value<DateTime?> publishedAt,
      Value<String?> errorMessage,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$PostsTableTableReferences
    extends BaseReferences<_$AppDatabase, $PostsTableTable, PostsTableData> {
  $$PostsTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$PostMetricsTableTable, List<PostMetricsTableData>>
  _postMetricsTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.postMetricsTable,
    aliasName: $_aliasNameGenerator(
      db.postsTable.id,
      db.postMetricsTable.postId,
    ),
  );

  $$PostMetricsTableTableProcessedTableManager get postMetricsTableRefs {
    final manager = $$PostMetricsTableTableTableManager(
      $_db,
      $_db.postMetricsTable,
    ).filter((f) => f.postId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _postMetricsTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PostsTableTableFilterComposer
    extends Composer<_$AppDatabase, $PostsTableTable> {
  $$PostsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get remoteId => $composableBuilder(
    column: $table.remoteId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hookLine => $composableBuilder(
    column: $table.hookLine,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get platform => $composableBuilder(
    column: $table.platform,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get scheduledAt => $composableBuilder(
    column: $table.scheduledAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get publishedAt => $composableBuilder(
    column: $table.publishedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> postMetricsTableRefs(
    Expression<bool> Function($$PostMetricsTableTableFilterComposer f) f,
  ) {
    final $$PostMetricsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.postMetricsTable,
      getReferencedColumn: (t) => t.postId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PostMetricsTableTableFilterComposer(
            $db: $db,
            $table: $db.postMetricsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PostsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $PostsTableTable> {
  $$PostsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get remoteId => $composableBuilder(
    column: $table.remoteId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hookLine => $composableBuilder(
    column: $table.hookLine,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get platform => $composableBuilder(
    column: $table.platform,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get scheduledAt => $composableBuilder(
    column: $table.scheduledAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get publishedAt => $composableBuilder(
    column: $table.publishedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PostsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $PostsTableTable> {
  $$PostsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get remoteId =>
      $composableBuilder(column: $table.remoteId, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<String> get hookLine =>
      $composableBuilder(column: $table.hookLine, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get platform =>
      $composableBuilder(column: $table.platform, builder: (column) => column);

  GeneratedColumn<DateTime> get scheduledAt => $composableBuilder(
    column: $table.scheduledAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get publishedAt => $composableBuilder(
    column: $table.publishedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> postMetricsTableRefs<T extends Object>(
    Expression<T> Function($$PostMetricsTableTableAnnotationComposer a) f,
  ) {
    final $$PostMetricsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.postMetricsTable,
      getReferencedColumn: (t) => t.postId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PostMetricsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.postMetricsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PostsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PostsTableTable,
          PostsTableData,
          $$PostsTableTableFilterComposer,
          $$PostsTableTableOrderingComposer,
          $$PostsTableTableAnnotationComposer,
          $$PostsTableTableCreateCompanionBuilder,
          $$PostsTableTableUpdateCompanionBuilder,
          (PostsTableData, $$PostsTableTableReferences),
          PostsTableData,
          PrefetchHooks Function({bool postMetricsTableRefs})
        > {
  $$PostsTableTableTableManager(_$AppDatabase db, $PostsTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PostsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PostsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PostsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> remoteId = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<String?> hookLine = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> platform = const Value.absent(),
                Value<DateTime?> scheduledAt = const Value.absent(),
                Value<DateTime?> publishedAt = const Value.absent(),
                Value<String?> errorMessage = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => PostsTableCompanion(
                id: id,
                remoteId: remoteId,
                content: content,
                hookLine: hookLine,
                status: status,
                platform: platform,
                scheduledAt: scheduledAt,
                publishedAt: publishedAt,
                errorMessage: errorMessage,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> remoteId = const Value.absent(),
                required String content,
                Value<String?> hookLine = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> platform = const Value.absent(),
                Value<DateTime?> scheduledAt = const Value.absent(),
                Value<DateTime?> publishedAt = const Value.absent(),
                Value<String?> errorMessage = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => PostsTableCompanion.insert(
                id: id,
                remoteId: remoteId,
                content: content,
                hookLine: hookLine,
                status: status,
                platform: platform,
                scheduledAt: scheduledAt,
                publishedAt: publishedAt,
                errorMessage: errorMessage,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PostsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({postMetricsTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (postMetricsTableRefs) db.postMetricsTable,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (postMetricsTableRefs)
                    await $_getPrefetchedData<
                      PostsTableData,
                      $PostsTableTable,
                      PostMetricsTableData
                    >(
                      currentTable: table,
                      referencedTable: $$PostsTableTableReferences
                          ._postMetricsTableRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$PostsTableTableReferences(
                            db,
                            table,
                            p0,
                          ).postMetricsTableRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.postId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$PostsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PostsTableTable,
      PostsTableData,
      $$PostsTableTableFilterComposer,
      $$PostsTableTableOrderingComposer,
      $$PostsTableTableAnnotationComposer,
      $$PostsTableTableCreateCompanionBuilder,
      $$PostsTableTableUpdateCompanionBuilder,
      (PostsTableData, $$PostsTableTableReferences),
      PostsTableData,
      PrefetchHooks Function({bool postMetricsTableRefs})
    >;
typedef $$PostMetricsTableTableCreateCompanionBuilder =
    PostMetricsTableCompanion Function({
      Value<int> id,
      required int postId,
      Value<int> impressions,
      Value<int> engagements,
      Value<int> comments,
      Value<int> reposts,
      Value<int> likes,
      Value<DateTime> fetchedAt,
    });
typedef $$PostMetricsTableTableUpdateCompanionBuilder =
    PostMetricsTableCompanion Function({
      Value<int> id,
      Value<int> postId,
      Value<int> impressions,
      Value<int> engagements,
      Value<int> comments,
      Value<int> reposts,
      Value<int> likes,
      Value<DateTime> fetchedAt,
    });

final class $$PostMetricsTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $PostMetricsTableTable,
          PostMetricsTableData
        > {
  $$PostMetricsTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $PostsTableTable _postIdTable(_$AppDatabase db) =>
      db.postsTable.createAlias(
        $_aliasNameGenerator(db.postMetricsTable.postId, db.postsTable.id),
      );

  $$PostsTableTableProcessedTableManager get postId {
    final $_column = $_itemColumn<int>('post_id')!;

    final manager = $$PostsTableTableTableManager(
      $_db,
      $_db.postsTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_postIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PostMetricsTableTableFilterComposer
    extends Composer<_$AppDatabase, $PostMetricsTableTable> {
  $$PostMetricsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get impressions => $composableBuilder(
    column: $table.impressions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get engagements => $composableBuilder(
    column: $table.engagements,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get comments => $composableBuilder(
    column: $table.comments,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reposts => $composableBuilder(
    column: $table.reposts,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get likes => $composableBuilder(
    column: $table.likes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$PostsTableTableFilterComposer get postId {
    final $$PostsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.postId,
      referencedTable: $db.postsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PostsTableTableFilterComposer(
            $db: $db,
            $table: $db.postsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PostMetricsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $PostMetricsTableTable> {
  $$PostMetricsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get impressions => $composableBuilder(
    column: $table.impressions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get engagements => $composableBuilder(
    column: $table.engagements,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get comments => $composableBuilder(
    column: $table.comments,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reposts => $composableBuilder(
    column: $table.reposts,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get likes => $composableBuilder(
    column: $table.likes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$PostsTableTableOrderingComposer get postId {
    final $$PostsTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.postId,
      referencedTable: $db.postsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PostsTableTableOrderingComposer(
            $db: $db,
            $table: $db.postsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PostMetricsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $PostMetricsTableTable> {
  $$PostMetricsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get impressions => $composableBuilder(
    column: $table.impressions,
    builder: (column) => column,
  );

  GeneratedColumn<int> get engagements => $composableBuilder(
    column: $table.engagements,
    builder: (column) => column,
  );

  GeneratedColumn<int> get comments =>
      $composableBuilder(column: $table.comments, builder: (column) => column);

  GeneratedColumn<int> get reposts =>
      $composableBuilder(column: $table.reposts, builder: (column) => column);

  GeneratedColumn<int> get likes =>
      $composableBuilder(column: $table.likes, builder: (column) => column);

  GeneratedColumn<DateTime> get fetchedAt =>
      $composableBuilder(column: $table.fetchedAt, builder: (column) => column);

  $$PostsTableTableAnnotationComposer get postId {
    final $$PostsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.postId,
      referencedTable: $db.postsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PostsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.postsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PostMetricsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PostMetricsTableTable,
          PostMetricsTableData,
          $$PostMetricsTableTableFilterComposer,
          $$PostMetricsTableTableOrderingComposer,
          $$PostMetricsTableTableAnnotationComposer,
          $$PostMetricsTableTableCreateCompanionBuilder,
          $$PostMetricsTableTableUpdateCompanionBuilder,
          (PostMetricsTableData, $$PostMetricsTableTableReferences),
          PostMetricsTableData,
          PrefetchHooks Function({bool postId})
        > {
  $$PostMetricsTableTableTableManager(
    _$AppDatabase db,
    $PostMetricsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PostMetricsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PostMetricsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PostMetricsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> postId = const Value.absent(),
                Value<int> impressions = const Value.absent(),
                Value<int> engagements = const Value.absent(),
                Value<int> comments = const Value.absent(),
                Value<int> reposts = const Value.absent(),
                Value<int> likes = const Value.absent(),
                Value<DateTime> fetchedAt = const Value.absent(),
              }) => PostMetricsTableCompanion(
                id: id,
                postId: postId,
                impressions: impressions,
                engagements: engagements,
                comments: comments,
                reposts: reposts,
                likes: likes,
                fetchedAt: fetchedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int postId,
                Value<int> impressions = const Value.absent(),
                Value<int> engagements = const Value.absent(),
                Value<int> comments = const Value.absent(),
                Value<int> reposts = const Value.absent(),
                Value<int> likes = const Value.absent(),
                Value<DateTime> fetchedAt = const Value.absent(),
              }) => PostMetricsTableCompanion.insert(
                id: id,
                postId: postId,
                impressions: impressions,
                engagements: engagements,
                comments: comments,
                reposts: reposts,
                likes: likes,
                fetchedAt: fetchedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PostMetricsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({postId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (postId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.postId,
                                referencedTable:
                                    $$PostMetricsTableTableReferences
                                        ._postIdTable(db),
                                referencedColumn:
                                    $$PostMetricsTableTableReferences
                                        ._postIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PostMetricsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PostMetricsTableTable,
      PostMetricsTableData,
      $$PostMetricsTableTableFilterComposer,
      $$PostMetricsTableTableOrderingComposer,
      $$PostMetricsTableTableAnnotationComposer,
      $$PostMetricsTableTableCreateCompanionBuilder,
      $$PostMetricsTableTableUpdateCompanionBuilder,
      (PostMetricsTableData, $$PostMetricsTableTableReferences),
      PostMetricsTableData,
      PrefetchHooks Function({bool postId})
    >;
typedef $$UserStatsTableTableCreateCompanionBuilder =
    UserStatsTableCompanion Function({
      Value<int> id,
      Value<int> streakDays,
      Value<int> xp,
      Value<int> level,
      Value<String> levelTitle,
      Value<int> weeklyXp,
      Value<int> weeklyXpGoal,
      Value<String?> lastActiveDateStr,
      Value<DateTime> updatedAt,
    });
typedef $$UserStatsTableTableUpdateCompanionBuilder =
    UserStatsTableCompanion Function({
      Value<int> id,
      Value<int> streakDays,
      Value<int> xp,
      Value<int> level,
      Value<String> levelTitle,
      Value<int> weeklyXp,
      Value<int> weeklyXpGoal,
      Value<String?> lastActiveDateStr,
      Value<DateTime> updatedAt,
    });

class $$UserStatsTableTableFilterComposer
    extends Composer<_$AppDatabase, $UserStatsTableTable> {
  $$UserStatsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get streakDays => $composableBuilder(
    column: $table.streakDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get xp => $composableBuilder(
    column: $table.xp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get levelTitle => $composableBuilder(
    column: $table.levelTitle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get weeklyXp => $composableBuilder(
    column: $table.weeklyXp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get weeklyXpGoal => $composableBuilder(
    column: $table.weeklyXpGoal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastActiveDateStr => $composableBuilder(
    column: $table.lastActiveDateStr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserStatsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $UserStatsTableTable> {
  $$UserStatsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get streakDays => $composableBuilder(
    column: $table.streakDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get xp => $composableBuilder(
    column: $table.xp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get levelTitle => $composableBuilder(
    column: $table.levelTitle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get weeklyXp => $composableBuilder(
    column: $table.weeklyXp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get weeklyXpGoal => $composableBuilder(
    column: $table.weeklyXpGoal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastActiveDateStr => $composableBuilder(
    column: $table.lastActiveDateStr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserStatsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserStatsTableTable> {
  $$UserStatsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get streakDays => $composableBuilder(
    column: $table.streakDays,
    builder: (column) => column,
  );

  GeneratedColumn<int> get xp =>
      $composableBuilder(column: $table.xp, builder: (column) => column);

  GeneratedColumn<int> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<String> get levelTitle => $composableBuilder(
    column: $table.levelTitle,
    builder: (column) => column,
  );

  GeneratedColumn<int> get weeklyXp =>
      $composableBuilder(column: $table.weeklyXp, builder: (column) => column);

  GeneratedColumn<int> get weeklyXpGoal => $composableBuilder(
    column: $table.weeklyXpGoal,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastActiveDateStr => $composableBuilder(
    column: $table.lastActiveDateStr,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$UserStatsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserStatsTableTable,
          UserStatsTableData,
          $$UserStatsTableTableFilterComposer,
          $$UserStatsTableTableOrderingComposer,
          $$UserStatsTableTableAnnotationComposer,
          $$UserStatsTableTableCreateCompanionBuilder,
          $$UserStatsTableTableUpdateCompanionBuilder,
          (
            UserStatsTableData,
            BaseReferences<
              _$AppDatabase,
              $UserStatsTableTable,
              UserStatsTableData
            >,
          ),
          UserStatsTableData,
          PrefetchHooks Function()
        > {
  $$UserStatsTableTableTableManager(
    _$AppDatabase db,
    $UserStatsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserStatsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserStatsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserStatsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> streakDays = const Value.absent(),
                Value<int> xp = const Value.absent(),
                Value<int> level = const Value.absent(),
                Value<String> levelTitle = const Value.absent(),
                Value<int> weeklyXp = const Value.absent(),
                Value<int> weeklyXpGoal = const Value.absent(),
                Value<String?> lastActiveDateStr = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => UserStatsTableCompanion(
                id: id,
                streakDays: streakDays,
                xp: xp,
                level: level,
                levelTitle: levelTitle,
                weeklyXp: weeklyXp,
                weeklyXpGoal: weeklyXpGoal,
                lastActiveDateStr: lastActiveDateStr,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> streakDays = const Value.absent(),
                Value<int> xp = const Value.absent(),
                Value<int> level = const Value.absent(),
                Value<String> levelTitle = const Value.absent(),
                Value<int> weeklyXp = const Value.absent(),
                Value<int> weeklyXpGoal = const Value.absent(),
                Value<String?> lastActiveDateStr = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => UserStatsTableCompanion.insert(
                id: id,
                streakDays: streakDays,
                xp: xp,
                level: level,
                levelTitle: levelTitle,
                weeklyXp: weeklyXp,
                weeklyXpGoal: weeklyXpGoal,
                lastActiveDateStr: lastActiveDateStr,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserStatsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserStatsTableTable,
      UserStatsTableData,
      $$UserStatsTableTableFilterComposer,
      $$UserStatsTableTableOrderingComposer,
      $$UserStatsTableTableAnnotationComposer,
      $$UserStatsTableTableCreateCompanionBuilder,
      $$UserStatsTableTableUpdateCompanionBuilder,
      (
        UserStatsTableData,
        BaseReferences<_$AppDatabase, $UserStatsTableTable, UserStatsTableData>,
      ),
      UserStatsTableData,
      PrefetchHooks Function()
    >;
typedef $$MissionsTableTableCreateCompanionBuilder =
    MissionsTableCompanion Function({
      Value<int> id,
      required String missionKey,
      required String title,
      required String description,
      Value<String> status,
      Value<int> xpReward,
      Value<int> progress,
      Value<int> total,
      Value<int> sortOrder,
    });
typedef $$MissionsTableTableUpdateCompanionBuilder =
    MissionsTableCompanion Function({
      Value<int> id,
      Value<String> missionKey,
      Value<String> title,
      Value<String> description,
      Value<String> status,
      Value<int> xpReward,
      Value<int> progress,
      Value<int> total,
      Value<int> sortOrder,
    });

class $$MissionsTableTableFilterComposer
    extends Composer<_$AppDatabase, $MissionsTableTable> {
  $$MissionsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get missionKey => $composableBuilder(
    column: $table.missionKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get xpReward => $composableBuilder(
    column: $table.xpReward,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get progress => $composableBuilder(
    column: $table.progress,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get total => $composableBuilder(
    column: $table.total,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MissionsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $MissionsTableTable> {
  $$MissionsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get missionKey => $composableBuilder(
    column: $table.missionKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get xpReward => $composableBuilder(
    column: $table.xpReward,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get progress => $composableBuilder(
    column: $table.progress,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get total => $composableBuilder(
    column: $table.total,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MissionsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $MissionsTableTable> {
  $$MissionsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get missionKey => $composableBuilder(
    column: $table.missionKey,
    builder: (column) => column,
  );

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get xpReward =>
      $composableBuilder(column: $table.xpReward, builder: (column) => column);

  GeneratedColumn<int> get progress =>
      $composableBuilder(column: $table.progress, builder: (column) => column);

  GeneratedColumn<int> get total =>
      $composableBuilder(column: $table.total, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);
}

class $$MissionsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MissionsTableTable,
          MissionsTableData,
          $$MissionsTableTableFilterComposer,
          $$MissionsTableTableOrderingComposer,
          $$MissionsTableTableAnnotationComposer,
          $$MissionsTableTableCreateCompanionBuilder,
          $$MissionsTableTableUpdateCompanionBuilder,
          (
            MissionsTableData,
            BaseReferences<
              _$AppDatabase,
              $MissionsTableTable,
              MissionsTableData
            >,
          ),
          MissionsTableData,
          PrefetchHooks Function()
        > {
  $$MissionsTableTableTableManager(_$AppDatabase db, $MissionsTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MissionsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MissionsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MissionsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> missionKey = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> xpReward = const Value.absent(),
                Value<int> progress = const Value.absent(),
                Value<int> total = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
              }) => MissionsTableCompanion(
                id: id,
                missionKey: missionKey,
                title: title,
                description: description,
                status: status,
                xpReward: xpReward,
                progress: progress,
                total: total,
                sortOrder: sortOrder,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String missionKey,
                required String title,
                required String description,
                Value<String> status = const Value.absent(),
                Value<int> xpReward = const Value.absent(),
                Value<int> progress = const Value.absent(),
                Value<int> total = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
              }) => MissionsTableCompanion.insert(
                id: id,
                missionKey: missionKey,
                title: title,
                description: description,
                status: status,
                xpReward: xpReward,
                progress: progress,
                total: total,
                sortOrder: sortOrder,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MissionsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MissionsTableTable,
      MissionsTableData,
      $$MissionsTableTableFilterComposer,
      $$MissionsTableTableOrderingComposer,
      $$MissionsTableTableAnnotationComposer,
      $$MissionsTableTableCreateCompanionBuilder,
      $$MissionsTableTableUpdateCompanionBuilder,
      (
        MissionsTableData,
        BaseReferences<_$AppDatabase, $MissionsTableTable, MissionsTableData>,
      ),
      MissionsTableData,
      PrefetchHooks Function()
    >;
typedef $$NotificationsTableTableCreateCompanionBuilder =
    NotificationsTableCompanion Function({
      Value<int> id,
      Value<String?> remoteId,
      required String title,
      required String body,
      Value<String> type,
      Value<String?> payload,
      Value<bool> isRead,
      Value<DateTime> receivedAt,
    });
typedef $$NotificationsTableTableUpdateCompanionBuilder =
    NotificationsTableCompanion Function({
      Value<int> id,
      Value<String?> remoteId,
      Value<String> title,
      Value<String> body,
      Value<String> type,
      Value<String?> payload,
      Value<bool> isRead,
      Value<DateTime> receivedAt,
    });

class $$NotificationsTableTableFilterComposer
    extends Composer<_$AppDatabase, $NotificationsTableTable> {
  $$NotificationsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get remoteId => $composableBuilder(
    column: $table.remoteId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isRead => $composableBuilder(
    column: $table.isRead,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get receivedAt => $composableBuilder(
    column: $table.receivedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$NotificationsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $NotificationsTableTable> {
  $$NotificationsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get remoteId => $composableBuilder(
    column: $table.remoteId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isRead => $composableBuilder(
    column: $table.isRead,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get receivedAt => $composableBuilder(
    column: $table.receivedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$NotificationsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $NotificationsTableTable> {
  $$NotificationsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get remoteId =>
      $composableBuilder(column: $table.remoteId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<bool> get isRead =>
      $composableBuilder(column: $table.isRead, builder: (column) => column);

  GeneratedColumn<DateTime> get receivedAt => $composableBuilder(
    column: $table.receivedAt,
    builder: (column) => column,
  );
}

class $$NotificationsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NotificationsTableTable,
          NotificationsTableData,
          $$NotificationsTableTableFilterComposer,
          $$NotificationsTableTableOrderingComposer,
          $$NotificationsTableTableAnnotationComposer,
          $$NotificationsTableTableCreateCompanionBuilder,
          $$NotificationsTableTableUpdateCompanionBuilder,
          (
            NotificationsTableData,
            BaseReferences<
              _$AppDatabase,
              $NotificationsTableTable,
              NotificationsTableData
            >,
          ),
          NotificationsTableData,
          PrefetchHooks Function()
        > {
  $$NotificationsTableTableTableManager(
    _$AppDatabase db,
    $NotificationsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NotificationsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NotificationsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NotificationsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> remoteId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> body = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String?> payload = const Value.absent(),
                Value<bool> isRead = const Value.absent(),
                Value<DateTime> receivedAt = const Value.absent(),
              }) => NotificationsTableCompanion(
                id: id,
                remoteId: remoteId,
                title: title,
                body: body,
                type: type,
                payload: payload,
                isRead: isRead,
                receivedAt: receivedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> remoteId = const Value.absent(),
                required String title,
                required String body,
                Value<String> type = const Value.absent(),
                Value<String?> payload = const Value.absent(),
                Value<bool> isRead = const Value.absent(),
                Value<DateTime> receivedAt = const Value.absent(),
              }) => NotificationsTableCompanion.insert(
                id: id,
                remoteId: remoteId,
                title: title,
                body: body,
                type: type,
                payload: payload,
                isRead: isRead,
                receivedAt: receivedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$NotificationsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NotificationsTableTable,
      NotificationsTableData,
      $$NotificationsTableTableFilterComposer,
      $$NotificationsTableTableOrderingComposer,
      $$NotificationsTableTableAnnotationComposer,
      $$NotificationsTableTableCreateCompanionBuilder,
      $$NotificationsTableTableUpdateCompanionBuilder,
      (
        NotificationsTableData,
        BaseReferences<
          _$AppDatabase,
          $NotificationsTableTable,
          NotificationsTableData
        >,
      ),
      NotificationsTableData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SyncQueueTableTableManager get syncQueue =>
      $$SyncQueueTableTableManager(_db, _db.syncQueue);
  $$PostsTableTableTableManager get postsTable =>
      $$PostsTableTableTableManager(_db, _db.postsTable);
  $$PostMetricsTableTableTableManager get postMetricsTable =>
      $$PostMetricsTableTableTableManager(_db, _db.postMetricsTable);
  $$UserStatsTableTableTableManager get userStatsTable =>
      $$UserStatsTableTableTableManager(_db, _db.userStatsTable);
  $$MissionsTableTableTableManager get missionsTable =>
      $$MissionsTableTableTableManager(_db, _db.missionsTable);
  $$NotificationsTableTableTableManager get notificationsTable =>
      $$NotificationsTableTableTableManager(_db, _db.notificationsTable);
}

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(appDatabase)
final appDatabaseProvider = AppDatabaseProvider._();

final class AppDatabaseProvider
    extends $FunctionalProvider<AppDatabase, AppDatabase, AppDatabase>
    with $Provider<AppDatabase> {
  AppDatabaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appDatabaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appDatabaseHash();

  @$internal
  @override
  $ProviderElement<AppDatabase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AppDatabase create(Ref ref) {
    return appDatabase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppDatabase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppDatabase>(value),
    );
  }
}

String _$appDatabaseHash() => r'931e61446d0ed29fd03f7b505ecfea464f11fd0c';

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $JournalEntryRecordsTable extends JournalEntryRecords
    with TableInfo<$JournalEntryRecordsTable, JournalEntryRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $JournalEntryRecordsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
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
  static const VerificationMeta _dayKeyMeta = const VerificationMeta('dayKey');
  @override
  late final GeneratedColumn<String> dayKey = GeneratedColumn<String>(
    'day_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tagsJsonMeta = const VerificationMeta(
    'tagsJson',
  );
  @override
  late final GeneratedColumn<String> tagsJson = GeneratedColumn<String>(
    'tags_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    content,
    date,
    createdAt,
    dayKey,
    tagsJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'journal_entry_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<JournalEntryRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('day_key')) {
      context.handle(
        _dayKeyMeta,
        dayKey.isAcceptableOrUnknown(data['day_key']!, _dayKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_dayKeyMeta);
    }
    if (data.containsKey('tags_json')) {
      context.handle(
        _tagsJsonMeta,
        tagsJson.isAcceptableOrUnknown(data['tags_json']!, _tagsJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_tagsJsonMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  JournalEntryRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return JournalEntryRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      dayKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}day_key'],
      )!,
      tagsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tags_json'],
      )!,
    );
  }

  @override
  $JournalEntryRecordsTable createAlias(String alias) {
    return $JournalEntryRecordsTable(attachedDatabase, alias);
  }
}

class JournalEntryRecord extends DataClass
    implements Insertable<JournalEntryRecord> {
  final int id;
  final String content;
  final DateTime date;
  final DateTime createdAt;
  final String dayKey;
  final String tagsJson;
  const JournalEntryRecord({
    required this.id,
    required this.content,
    required this.date,
    required this.createdAt,
    required this.dayKey,
    required this.tagsJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['content'] = Variable<String>(content);
    map['date'] = Variable<DateTime>(date);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['day_key'] = Variable<String>(dayKey);
    map['tags_json'] = Variable<String>(tagsJson);
    return map;
  }

  JournalEntryRecordsCompanion toCompanion(bool nullToAbsent) {
    return JournalEntryRecordsCompanion(
      id: Value(id),
      content: Value(content),
      date: Value(date),
      createdAt: Value(createdAt),
      dayKey: Value(dayKey),
      tagsJson: Value(tagsJson),
    );
  }

  factory JournalEntryRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return JournalEntryRecord(
      id: serializer.fromJson<int>(json['id']),
      content: serializer.fromJson<String>(json['content']),
      date: serializer.fromJson<DateTime>(json['date']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      dayKey: serializer.fromJson<String>(json['dayKey']),
      tagsJson: serializer.fromJson<String>(json['tagsJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'content': serializer.toJson<String>(content),
      'date': serializer.toJson<DateTime>(date),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'dayKey': serializer.toJson<String>(dayKey),
      'tagsJson': serializer.toJson<String>(tagsJson),
    };
  }

  JournalEntryRecord copyWith({
    int? id,
    String? content,
    DateTime? date,
    DateTime? createdAt,
    String? dayKey,
    String? tagsJson,
  }) => JournalEntryRecord(
    id: id ?? this.id,
    content: content ?? this.content,
    date: date ?? this.date,
    createdAt: createdAt ?? this.createdAt,
    dayKey: dayKey ?? this.dayKey,
    tagsJson: tagsJson ?? this.tagsJson,
  );
  JournalEntryRecord copyWithCompanion(JournalEntryRecordsCompanion data) {
    return JournalEntryRecord(
      id: data.id.present ? data.id.value : this.id,
      content: data.content.present ? data.content.value : this.content,
      date: data.date.present ? data.date.value : this.date,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      dayKey: data.dayKey.present ? data.dayKey.value : this.dayKey,
      tagsJson: data.tagsJson.present ? data.tagsJson.value : this.tagsJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('JournalEntryRecord(')
          ..write('id: $id, ')
          ..write('content: $content, ')
          ..write('date: $date, ')
          ..write('createdAt: $createdAt, ')
          ..write('dayKey: $dayKey, ')
          ..write('tagsJson: $tagsJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, content, date, createdAt, dayKey, tagsJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is JournalEntryRecord &&
          other.id == this.id &&
          other.content == this.content &&
          other.date == this.date &&
          other.createdAt == this.createdAt &&
          other.dayKey == this.dayKey &&
          other.tagsJson == this.tagsJson);
}

class JournalEntryRecordsCompanion extends UpdateCompanion<JournalEntryRecord> {
  final Value<int> id;
  final Value<String> content;
  final Value<DateTime> date;
  final Value<DateTime> createdAt;
  final Value<String> dayKey;
  final Value<String> tagsJson;
  const JournalEntryRecordsCompanion({
    this.id = const Value.absent(),
    this.content = const Value.absent(),
    this.date = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.dayKey = const Value.absent(),
    this.tagsJson = const Value.absent(),
  });
  JournalEntryRecordsCompanion.insert({
    this.id = const Value.absent(),
    required String content,
    required DateTime date,
    required DateTime createdAt,
    required String dayKey,
    required String tagsJson,
  }) : content = Value(content),
       date = Value(date),
       createdAt = Value(createdAt),
       dayKey = Value(dayKey),
       tagsJson = Value(tagsJson);
  static Insertable<JournalEntryRecord> custom({
    Expression<int>? id,
    Expression<String>? content,
    Expression<DateTime>? date,
    Expression<DateTime>? createdAt,
    Expression<String>? dayKey,
    Expression<String>? tagsJson,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (content != null) 'content': content,
      if (date != null) 'date': date,
      if (createdAt != null) 'created_at': createdAt,
      if (dayKey != null) 'day_key': dayKey,
      if (tagsJson != null) 'tags_json': tagsJson,
    });
  }

  JournalEntryRecordsCompanion copyWith({
    Value<int>? id,
    Value<String>? content,
    Value<DateTime>? date,
    Value<DateTime>? createdAt,
    Value<String>? dayKey,
    Value<String>? tagsJson,
  }) {
    return JournalEntryRecordsCompanion(
      id: id ?? this.id,
      content: content ?? this.content,
      date: date ?? this.date,
      createdAt: createdAt ?? this.createdAt,
      dayKey: dayKey ?? this.dayKey,
      tagsJson: tagsJson ?? this.tagsJson,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (dayKey.present) {
      map['day_key'] = Variable<String>(dayKey.value);
    }
    if (tagsJson.present) {
      map['tags_json'] = Variable<String>(tagsJson.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('JournalEntryRecordsCompanion(')
          ..write('id: $id, ')
          ..write('content: $content, ')
          ..write('date: $date, ')
          ..write('createdAt: $createdAt, ')
          ..write('dayKey: $dayKey, ')
          ..write('tagsJson: $tagsJson')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $JournalEntryRecordsTable journalEntryRecords =
      $JournalEntryRecordsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [journalEntryRecords];
}

typedef $$JournalEntryRecordsTableCreateCompanionBuilder =
    JournalEntryRecordsCompanion Function({
      Value<int> id,
      required String content,
      required DateTime date,
      required DateTime createdAt,
      required String dayKey,
      required String tagsJson,
    });
typedef $$JournalEntryRecordsTableUpdateCompanionBuilder =
    JournalEntryRecordsCompanion Function({
      Value<int> id,
      Value<String> content,
      Value<DateTime> date,
      Value<DateTime> createdAt,
      Value<String> dayKey,
      Value<String> tagsJson,
    });

class $$JournalEntryRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $JournalEntryRecordsTable> {
  $$JournalEntryRecordsTableFilterComposer({
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

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dayKey => $composableBuilder(
    column: $table.dayKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tagsJson => $composableBuilder(
    column: $table.tagsJson,
    builder: (column) => ColumnFilters(column),
  );
}

class $$JournalEntryRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $JournalEntryRecordsTable> {
  $$JournalEntryRecordsTableOrderingComposer({
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

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dayKey => $composableBuilder(
    column: $table.dayKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tagsJson => $composableBuilder(
    column: $table.tagsJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$JournalEntryRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $JournalEntryRecordsTable> {
  $$JournalEntryRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get dayKey =>
      $composableBuilder(column: $table.dayKey, builder: (column) => column);

  GeneratedColumn<String> get tagsJson =>
      $composableBuilder(column: $table.tagsJson, builder: (column) => column);
}

class $$JournalEntryRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $JournalEntryRecordsTable,
          JournalEntryRecord,
          $$JournalEntryRecordsTableFilterComposer,
          $$JournalEntryRecordsTableOrderingComposer,
          $$JournalEntryRecordsTableAnnotationComposer,
          $$JournalEntryRecordsTableCreateCompanionBuilder,
          $$JournalEntryRecordsTableUpdateCompanionBuilder,
          (
            JournalEntryRecord,
            BaseReferences<
              _$AppDatabase,
              $JournalEntryRecordsTable,
              JournalEntryRecord
            >,
          ),
          JournalEntryRecord,
          PrefetchHooks Function()
        > {
  $$JournalEntryRecordsTableTableManager(
    _$AppDatabase db,
    $JournalEntryRecordsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$JournalEntryRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$JournalEntryRecordsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$JournalEntryRecordsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> dayKey = const Value.absent(),
                Value<String> tagsJson = const Value.absent(),
              }) => JournalEntryRecordsCompanion(
                id: id,
                content: content,
                date: date,
                createdAt: createdAt,
                dayKey: dayKey,
                tagsJson: tagsJson,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String content,
                required DateTime date,
                required DateTime createdAt,
                required String dayKey,
                required String tagsJson,
              }) => JournalEntryRecordsCompanion.insert(
                id: id,
                content: content,
                date: date,
                createdAt: createdAt,
                dayKey: dayKey,
                tagsJson: tagsJson,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$JournalEntryRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $JournalEntryRecordsTable,
      JournalEntryRecord,
      $$JournalEntryRecordsTableFilterComposer,
      $$JournalEntryRecordsTableOrderingComposer,
      $$JournalEntryRecordsTableAnnotationComposer,
      $$JournalEntryRecordsTableCreateCompanionBuilder,
      $$JournalEntryRecordsTableUpdateCompanionBuilder,
      (
        JournalEntryRecord,
        BaseReferences<
          _$AppDatabase,
          $JournalEntryRecordsTable,
          JournalEntryRecord
        >,
      ),
      JournalEntryRecord,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$JournalEntryRecordsTableTableManager get journalEntryRecords =>
      $$JournalEntryRecordsTableTableManager(_db, _db.journalEntryRecords);
}

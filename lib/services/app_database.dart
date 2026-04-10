import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:todo_app/models/journal_entry.dart';

part 'app_database.g.dart';

class JournalEntryRecords extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get content => text()();

  DateTimeColumn get date => dateTime()();

  DateTimeColumn get createdAt => dateTime()();

  TextColumn get dayKey => text()();

  TextColumn get tagsJson => text()();
}

@DriftDatabase(tables: [JournalEntryRecords])
class AppDatabase extends _$AppDatabase {
  AppDatabase()
    : super(
        driftDatabase(
          name: 'dev_journal',
          web: DriftWebOptions(
            sqlite3Wasm: Uri.parse('sqlite3.wasm'),
            driftWorker: Uri.parse('drift_worker.js'),
          ),
        ),
      );

  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 1;

  Future<List<JournalEntry>> allEntries() async {
    final rows = await (select(
      journalEntryRecords,
    )..orderBy([(tbl) => OrderingTerm.desc(tbl.createdAt)])).get();
    return rows.map(_mapRow).toList();
  }

  Future<JournalEntry> insertEntry(String text) async {
    final now = DateTime.now();
    final entry = JournalEntry.create(text, id: 0);
    final id = await into(journalEntryRecords).insert(
      JournalEntryRecordsCompanion.insert(
        content: entry.content,
        date: now,
        createdAt: now,
        dayKey: buildDayKey(now),
        tagsJson: _encodeTags(entry.tags),
      ),
    );

    return JournalEntry(
      id: id,
      content: entry.content,
      date: now,
      createdAt: now,
      dayKey: buildDayKey(now),
      tags: entry.tags,
    );
  }

  Future<JournalEntry?> updateEntry(int id, String text, DateTime date) async {
    final existing = await (select(
      journalEntryRecords,
    )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
    if (existing == null) {
      return null;
    }

    final normalized = text.trim();
    final tags = extractTags(normalized);
    final normalizedDate = DateTime(
      date.year,
      date.month,
      date.day,
      existing.date.hour,
      existing.date.minute,
      existing.date.second,
      existing.date.millisecond,
      existing.date.microsecond,
    );
    await (update(
      journalEntryRecords,
    )..where((tbl) => tbl.id.equals(id))).write(
      JournalEntryRecordsCompanion(
        content: Value(normalized),
        date: Value(normalizedDate),
        dayKey: Value(buildDayKey(normalizedDate)),
        tagsJson: Value(_encodeTags(tags)),
      ),
    );

    return JournalEntry(
      id: existing.id,
      content: normalized,
      date: normalizedDate,
      createdAt: existing.createdAt,
      dayKey: buildDayKey(normalizedDate),
      tags: tags,
    );
  }

  Future<void> removeEntry(int id) {
    return (delete(
      journalEntryRecords,
    )..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<int> countEntries() async {
    final countExpression = journalEntryRecords.id.count();
    final query = selectOnly(journalEntryRecords)
      ..addColumns([countExpression]);
    final row = await query.getSingle();
    return row.read(countExpression) ?? 0;
  }

  Future<void> importEntriesIfEmpty(List<JournalEntry> entries) async {
    if (entries.isEmpty) {
      return;
    }

    final existingCount = await countEntries();
    if (existingCount > 0) {
      return;
    }

    await batch((batch) {
      batch.insertAll(
        journalEntryRecords,
        entries.map((entry) {
          return JournalEntryRecordsCompanion.insert(
            id: Value(entry.id),
            content: entry.content,
            date: entry.date,
            createdAt: entry.createdAt,
            dayKey: entry.dayKey,
            tagsJson: _encodeTags(entry.tags),
          );
        }).toList(),
      );
    });
  }

  JournalEntry _mapRow(JournalEntryRecord row) {
    return JournalEntry(
      id: row.id,
      content: row.content,
      date: row.date,
      createdAt: row.createdAt,
      dayKey: row.dayKey,
      tags: _decodeTags(row.tagsJson),
    );
  }
}

String _encodeTags(List<String> tags) => tags.join('\u0001');

List<String> _decodeTags(String raw) {
  if (raw.isEmpty) {
    return const <String>[];
  }

  return raw
      .split('\u0001')
      .where((tag) => tag.isNotEmpty)
      .toList(growable: false);
}

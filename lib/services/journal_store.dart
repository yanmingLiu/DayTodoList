import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/models/journal_entry.dart';
import 'package:todo_app/services/app_database.dart';

abstract class JournalStore {
  Future<List<JournalEntry>> loadEntries();
  Future<JournalEntry> addEntry(String text);
  Future<JournalEntry?> updateEntry(int id, String text, DateTime date);
  Future<void> deleteEntry(int id);
}

class DriftJournalStore implements JournalStore {
  DriftJournalStore._(this._database);

  static const String _legacyStorageKey = 'dev_journal_entries';

  final AppDatabase _database;

  static Future<DriftJournalStore> open() async {
    final database = AppDatabase();
    final store = DriftJournalStore._(database);
    await store._importLegacyEntries();
    return store;
  }

  factory DriftJournalStore.forTesting(QueryExecutor executor) {
    return DriftJournalStore._(AppDatabase.forTesting(executor));
  }

  @override
  Future<JournalEntry> addEntry(String text) {
    return _database.insertEntry(text);
  }

  @override
  Future<JournalEntry?> updateEntry(int id, String text, DateTime date) {
    return _database.updateEntry(id, text, date);
  }

  @override
  Future<void> deleteEntry(int id) {
    return _database.removeEntry(id);
  }

  @override
  Future<List<JournalEntry>> loadEntries() {
    return _database.allEntries();
  }

  Future<void> close() => _database.close();

  Future<void> _importLegacyEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final rawEntries =
        prefs.getStringList(_legacyStorageKey) ?? const <String>[];

    if (rawEntries.isEmpty) {
      return;
    }

    final legacyEntries = rawEntries
        .map((value) => JournalEntry.fromJson(jsonDecode(value)))
        .toList();

    await _database.importEntriesIfEmpty(legacyEntries);
    await prefs.remove(_legacyStorageKey);
  }
}

class MemoryJournalStore implements JournalStore {
  MemoryJournalStore([List<JournalEntry>? seed])
    : _entries = List<JournalEntry>.from(seed ?? const <JournalEntry>[]);

  final List<JournalEntry> _entries;
  int _nextId = 1;

  @override
  Future<JournalEntry> addEntry(String text) async {
    final entry = JournalEntry.create(text, id: _nextId++);
    _entries.insert(0, entry);
    return entry;
  }

  @override
  Future<JournalEntry?> updateEntry(int id, String text, DateTime date) async {
    final index = _entries.indexWhere((entry) => entry.id == id);
    if (index == -1) {
      return null;
    }

    final existing = _entries[index];
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
    final updated = JournalEntry(
      id: existing.id,
      content: text.trim(),
      date: normalizedDate,
      createdAt: existing.createdAt,
      dayKey: buildDayKey(normalizedDate),
      tags: extractTags(text),
    );
    _entries[index] = updated;
    return updated;
  }

  @override
  Future<void> deleteEntry(int id) async {
    _entries.removeWhere((entry) => entry.id == id);
  }

  @override
  Future<List<JournalEntry>> loadEntries() async {
    return List<JournalEntry>.from(_entries)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }
}

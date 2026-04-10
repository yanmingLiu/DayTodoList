import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_app/app.dart';
import 'package:todo_app/l10n/app_localizations.dart';
import 'package:todo_app/models/journal_entry.dart';
import 'package:todo_app/services/export/journal_exporter.dart';
import 'package:todo_app/services/journal_store.dart';

void main() {
  testWidgets('renders dev journal shell', (tester) async {
    await tester.pumpWidget(DevJournalApp(store: MemoryJournalStore()));
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Dev Journal'), findsOneWidget);
    expect(find.textContaining('Calendar'), findsWidgets);
    expect(find.textContaining('Quick Add'), findsWidgets);
    expect(find.byIcon(Icons.file_download_outlined), findsAtLeastNWidgets(1));
    expect(find.byIcon(Icons.add_rounded), findsOneWidget);
  });

  test('memory store creates a new journal entry with tags', () async {
    final store = MemoryJournalStore();
    final entry = await store.addEntry('完成首页联调 #flutter #release');
    final entries = await store.loadEntries();

    expect(entries, hasLength(1));
    expect(entries.first.content, '完成首页联调 #flutter #release');
    expect(entries.first.tags, <String>['flutter', 'release']);
    expect(entry.dayKey, buildDayKey(entry.date));
  });

  test('memory store updates entry content and tags', () async {
    final store = MemoryJournalStore();
    final entry = await store.addEntry('完成首页联调 #flutter');
    final updated = await store.updateEntry(
      entry.id,
      '修复发布问题 #release',
      DateTime(2026, 4, 24),
    );
    final entries = await store.loadEntries();

    expect(updated, isNotNull);
    expect(entries.single.content, '修复发布问题 #release');
    expect(entries.single.tags, <String>['release']);
    expect(entries.single.dayKey, '2026-04-24');
  });

  test('exporter creates markdown and json payloads', () async {
    final entry = JournalEntry(
      id: 1,
      content: '完成导出功能 #drift',
      date: DateTime(2026, 4, 9, 10, 30),
      createdAt: DateTime(2026, 4, 9, 10, 30),
      dayKey: '2026-04-09',
      tags: const <String>['drift'],
    );

    final l10n = await AppLocalizations.delegate.load(const Locale('en'));
    final markdown = toMarkdown(<JournalEntry>[entry], l10n);
    final json = toJson(<JournalEntry>[entry]);

    expect(markdown, contains('# Dev Journal Export'));
    expect(markdown, contains('完成导出功能 #drift'));
    expect(markdown, contains('Tags: #drift'));
    expect(json, contains('"content": "完成导出功能 #drift"'));
    expect(json, contains('"tags": ['));
  });
}

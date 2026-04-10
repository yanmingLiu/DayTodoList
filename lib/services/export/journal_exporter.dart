import 'dart:convert';

import 'package:todo_app/l10n/app_localizations.dart';
import 'package:todo_app/models/journal_entry.dart';
import 'package:todo_app/services/export/journal_exporter_impl.dart';

enum JournalExportFormat { markdown, json }

class JournalExportResult {
  const JournalExportResult({
    required this.fileName,
    this.path,
    required this.message,
  });

  final String fileName;
  final String? path;
  final String message;
}

class JournalExporter {
  const JournalExporter();

  Future<JournalExportResult> export(
    List<JournalEntry> entries,
    JournalExportFormat format,
    AppLocalizations l10n,
  ) {
    final fileName = _buildFileName(format);
    final content = switch (format) {
      JournalExportFormat.markdown => toMarkdown(entries, l10n),
      JournalExportFormat.json => toJson(entries),
    };
    return saveExportedJournal(
      fileName: fileName,
      content: content,
      mimeType: switch (format) {
        JournalExportFormat.markdown => 'text/markdown;charset=utf-8',
        JournalExportFormat.json => 'application/json;charset=utf-8',
      },
      downloadMessage: l10n.downloadStarted(fileName),
      exportedMessageBuilder: (path) => l10n.exportedToPath(path),
    );
  }
}

String toMarkdown(List<JournalEntry> entries, AppLocalizations l10n) {
  final buffer = StringBuffer('${l10n.exportHeader}\n\n');
  buffer.writeln(l10n.exportedAt(DateTime.now().toIso8601String()));
  buffer.writeln('${l10n.exportRecordCount(entries.length)}\n');

  for (final entry in entries) {
    buffer.writeln('## ${formatEntryTime(entry.date)}');
    buffer.writeln();
    buffer.writeln(entry.content);
    if (entry.tags.isNotEmpty) {
      buffer.writeln();
      buffer.writeln(
        l10n.exportTags(entry.tags.map((tag) => '#$tag').join(' ')),
      );
    }
    buffer.writeln();
  }

  return buffer.toString().trimRight();
}

String toJson(List<JournalEntry> entries) {
  return const JsonEncoder.withIndent(
    '  ',
  ).convert(entries.map((entry) => entry.toJson()).toList(growable: false));
}

String _buildFileName(JournalExportFormat format) {
  final now = DateTime.now();
  final timestamp =
      '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}_'
      '${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}';
  final suffix = format == JournalExportFormat.markdown ? 'md' : 'json';
  return 'dev_journal_$timestamp.$suffix';
}

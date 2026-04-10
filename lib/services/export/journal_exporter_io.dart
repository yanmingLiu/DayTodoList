import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:todo_app/services/export/journal_exporter.dart';

Future<JournalExportResult> saveExportedJournal({
  required String fileName,
  required String content,
  required String mimeType,
  required String downloadMessage,
  required String Function(String path) exportedMessageBuilder,
}) async {
  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/$fileName');
  await file.writeAsString(content);

  return JournalExportResult(
    fileName: fileName,
    path: file.path,
    message: exportedMessageBuilder(file.path),
  );
}

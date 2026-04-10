// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use

import 'dart:html' as html;
import 'dart:convert';

import 'package:todo_app/services/export/journal_exporter.dart';

Future<JournalExportResult> saveExportedJournal({
  required String fileName,
  required String content,
  required String mimeType,
  required String downloadMessage,
  required String Function(String path) exportedMessageBuilder,
}) async {
  final bytes = utf8.encode(content);
  final blob = html.Blob(<Object>[bytes], mimeType);
  final url = html.Url.createObjectUrlFromBlob(blob);
  final anchor = html.AnchorElement(href: url)
    ..download = fileName
    ..style.display = 'none';

  html.document.body?.children.add(anchor);
  anchor.click();
  anchor.remove();
  html.Url.revokeObjectUrl(url);

  return JournalExportResult(fileName: fileName, message: downloadMessage);
}

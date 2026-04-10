import 'package:flutter/material.dart';
import 'package:todo_app/app.dart';
import 'package:todo_app/services/journal_store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final store = await DriftJournalStore.open();
  runApp(DevJournalApp(store: store));
}

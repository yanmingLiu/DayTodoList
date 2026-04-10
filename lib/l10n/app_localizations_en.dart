// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Dev Journal';

  @override
  String get appSubtitle => 'Focus on today.';

  @override
  String get savedLog => 'Log saved';

  @override
  String get deletedLog => 'Log deleted';

  @override
  String get updatedLog => 'Log updated';

  @override
  String get noLogsToExport => 'There are no logs to export';

  @override
  String get exportLogs => 'Export';

  @override
  String get exportCurrentView => 'Current view';

  @override
  String get exportMarkdown => 'Export Markdown';

  @override
  String get exportJson => 'Export JSON';

  @override
  String get cancel => 'Cancel';

  @override
  String get filterLogs => 'Filter';

  @override
  String get searchKeyword => 'Search';

  @override
  String get tags => 'Tags';

  @override
  String get allTags => 'All tags';

  @override
  String get done => 'Done';

  @override
  String get deleteLog => 'Delete';

  @override
  String get deleteLogConfirm =>
      'This log cannot be recovered after deletion. Continue?';

  @override
  String get delete => 'Delete';

  @override
  String get confirmDelete => 'Delete';

  @override
  String get editLog => 'Edit';

  @override
  String get editLogHint => 'Update text and tags';

  @override
  String get dateLabel => 'Date';

  @override
  String get save => 'Save';

  @override
  String get saveChanges => 'Save';

  @override
  String get today => 'Today';

  @override
  String get calendar => 'Calendar';

  @override
  String get all => 'All';

  @override
  String get calendarTitle => 'Calendar';

  @override
  String get viewDayLogs => 'Open';

  @override
  String get quickRecord => 'Quick Add';

  @override
  String get quickRecordHintCompact => 'What did you finish? #tag';

  @override
  String get quickRecordHintFull => 'Write one line. Add #tags if needed.';

  @override
  String get quickRecordSupportTags => 'One line. Tags supported.';

  @override
  String get filterTooltip => 'Filter';

  @override
  String get exportTooltip => 'Export';

  @override
  String get languageTooltip => 'Language';

  @override
  String get languageCode => 'EN';

  @override
  String get totalCount => 'Total';

  @override
  String get resultCount => 'Results';

  @override
  String get selectedDayCount => 'Day';

  @override
  String selectedDateLabel(Object date) {
    return 'Date $date';
  }

  @override
  String get entriesTitleToday => 'Today';

  @override
  String get entriesTitleCalendar => 'Selected Day';

  @override
  String get entriesTitleAll => 'All Logs';

  @override
  String entriesCount(int count) {
    return '$count items';
  }

  @override
  String get emptyViewLogs => 'Nothing here yet.';

  @override
  String get filterAll => 'Filter · All';

  @override
  String filterResults(int count) {
    return 'Filter · $count items';
  }

  @override
  String downloadStarted(Object fileName) {
    return 'Downloading $fileName';
  }

  @override
  String exportedToPath(Object path) {
    return 'Exported to $path';
  }

  @override
  String get exportHeader => '# Dev Journal Export';

  @override
  String exportedAt(Object time) {
    return 'Exported at: $time';
  }

  @override
  String exportRecordCount(int count) {
    return 'Record count: $count';
  }

  @override
  String exportTags(Object tags) {
    return 'Tags: $tags';
  }
}

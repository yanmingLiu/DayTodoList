import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Dev Journal'**
  String get appTitle;

  /// No description provided for @appSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Focus on today.'**
  String get appSubtitle;

  /// No description provided for @savedLog.
  ///
  /// In en, this message translates to:
  /// **'Log saved'**
  String get savedLog;

  /// No description provided for @deletedLog.
  ///
  /// In en, this message translates to:
  /// **'Log deleted'**
  String get deletedLog;

  /// No description provided for @updatedLog.
  ///
  /// In en, this message translates to:
  /// **'Log updated'**
  String get updatedLog;

  /// No description provided for @noLogsToExport.
  ///
  /// In en, this message translates to:
  /// **'There are no logs to export'**
  String get noLogsToExport;

  /// No description provided for @exportLogs.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get exportLogs;

  /// No description provided for @exportCurrentView.
  ///
  /// In en, this message translates to:
  /// **'Current view'**
  String get exportCurrentView;

  /// No description provided for @exportMarkdown.
  ///
  /// In en, this message translates to:
  /// **'Export Markdown'**
  String get exportMarkdown;

  /// No description provided for @exportJson.
  ///
  /// In en, this message translates to:
  /// **'Export JSON'**
  String get exportJson;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @filterLogs.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filterLogs;

  /// No description provided for @searchKeyword.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get searchKeyword;

  /// No description provided for @tags.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get tags;

  /// No description provided for @allTags.
  ///
  /// In en, this message translates to:
  /// **'All tags'**
  String get allTags;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @deleteLog.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteLog;

  /// No description provided for @deleteLogConfirm.
  ///
  /// In en, this message translates to:
  /// **'This log cannot be recovered after deletion. Continue?'**
  String get deleteLogConfirm;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @confirmDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get confirmDelete;

  /// No description provided for @editLog.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get editLog;

  /// No description provided for @editLogHint.
  ///
  /// In en, this message translates to:
  /// **'Update text and tags'**
  String get editLogHint;

  /// No description provided for @dateLabel.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get dateLabel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveChanges;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @calendar.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get calendar;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @calendarTitle.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get calendarTitle;

  /// No description provided for @viewDayLogs.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get viewDayLogs;

  /// No description provided for @quickRecord.
  ///
  /// In en, this message translates to:
  /// **'Quick Add'**
  String get quickRecord;

  /// No description provided for @quickRecordHintCompact.
  ///
  /// In en, this message translates to:
  /// **'What did you finish? #tag'**
  String get quickRecordHintCompact;

  /// No description provided for @quickRecordHintFull.
  ///
  /// In en, this message translates to:
  /// **'Write one line. Add #tags if needed.'**
  String get quickRecordHintFull;

  /// No description provided for @quickRecordSupportTags.
  ///
  /// In en, this message translates to:
  /// **'One line. Tags supported.'**
  String get quickRecordSupportTags;

  /// No description provided for @filterTooltip.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filterTooltip;

  /// No description provided for @exportTooltip.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get exportTooltip;

  /// No description provided for @languageTooltip.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageTooltip;

  /// No description provided for @languageCode.
  ///
  /// In en, this message translates to:
  /// **'EN'**
  String get languageCode;

  /// No description provided for @totalCount.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get totalCount;

  /// No description provided for @resultCount.
  ///
  /// In en, this message translates to:
  /// **'Results'**
  String get resultCount;

  /// No description provided for @selectedDayCount.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get selectedDayCount;

  /// No description provided for @selectedDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Date {date}'**
  String selectedDateLabel(Object date);

  /// No description provided for @entriesTitleToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get entriesTitleToday;

  /// No description provided for @entriesTitleCalendar.
  ///
  /// In en, this message translates to:
  /// **'Selected Day'**
  String get entriesTitleCalendar;

  /// No description provided for @entriesTitleAll.
  ///
  /// In en, this message translates to:
  /// **'All Logs'**
  String get entriesTitleAll;

  /// No description provided for @entriesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} items'**
  String entriesCount(int count);

  /// No description provided for @emptyViewLogs.
  ///
  /// In en, this message translates to:
  /// **'Nothing here yet.'**
  String get emptyViewLogs;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'Filter · All'**
  String get filterAll;

  /// No description provided for @filterResults.
  ///
  /// In en, this message translates to:
  /// **'Filter · {count} items'**
  String filterResults(int count);

  /// No description provided for @downloadStarted.
  ///
  /// In en, this message translates to:
  /// **'Downloading {fileName}'**
  String downloadStarted(Object fileName);

  /// No description provided for @exportedToPath.
  ///
  /// In en, this message translates to:
  /// **'Exported to {path}'**
  String exportedToPath(Object path);

  /// No description provided for @exportHeader.
  ///
  /// In en, this message translates to:
  /// **'# Dev Journal Export'**
  String get exportHeader;

  /// No description provided for @exportedAt.
  ///
  /// In en, this message translates to:
  /// **'Exported at: {time}'**
  String exportedAt(Object time);

  /// No description provided for @exportRecordCount.
  ///
  /// In en, this message translates to:
  /// **'Record count: {count}'**
  String exportRecordCount(int count);

  /// No description provided for @exportTags.
  ///
  /// In en, this message translates to:
  /// **'Tags: {tags}'**
  String exportTags(Object tags);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

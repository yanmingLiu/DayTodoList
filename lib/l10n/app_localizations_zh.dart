// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'Dev Journal';

  @override
  String get appSubtitle => '聚焦今天。';

  @override
  String get savedLog => '已保存日志';

  @override
  String get deletedLog => '已删除日志';

  @override
  String get updatedLog => '已更新日志';

  @override
  String get noLogsToExport => '当前没有可导出的日志';

  @override
  String get exportLogs => '导出';

  @override
  String get exportCurrentView => '当前视图';

  @override
  String get exportMarkdown => '导出 Markdown';

  @override
  String get exportJson => '导出 JSON';

  @override
  String get cancel => '取消';

  @override
  String get filterLogs => '筛选';

  @override
  String get searchKeyword => '搜索';

  @override
  String get tags => '标签';

  @override
  String get allTags => '全部标签';

  @override
  String get done => '完成';

  @override
  String get deleteLog => '删除';

  @override
  String get deleteLogConfirm => '删除后将无法恢复，确认继续吗？';

  @override
  String get delete => '删除';

  @override
  String get confirmDelete => '确认删除';

  @override
  String get editLog => '编辑';

  @override
  String get editLogHint => '更新内容和标签';

  @override
  String get dateLabel => '日期';

  @override
  String get save => '保存';

  @override
  String get saveChanges => '保存';

  @override
  String get today => '今天';

  @override
  String get calendar => '日历';

  @override
  String get all => '全部';

  @override
  String get calendarTitle => '日历';

  @override
  String get viewDayLogs => '打开';

  @override
  String get quickRecord => '快速添加';

  @override
  String get quickRecordHintCompact => '完成了什么？可加 #标签';

  @override
  String get quickRecordHintFull => '输入一行记录，可选 #标签。';

  @override
  String get quickRecordSupportTags => '一行记录，支持标签。';

  @override
  String get filterTooltip => '筛选';

  @override
  String get exportTooltip => '导出';

  @override
  String get languageTooltip => '语言';

  @override
  String get languageCode => '中';

  @override
  String get totalCount => '总数';

  @override
  String get resultCount => '结果';

  @override
  String get selectedDayCount => '当天';

  @override
  String selectedDateLabel(Object date) {
    return '日期 $date';
  }

  @override
  String get entriesTitleToday => '今天';

  @override
  String get entriesTitleCalendar => '所选日期';

  @override
  String get entriesTitleAll => '全部日志';

  @override
  String entriesCount(int count) {
    return '$count 条';
  }

  @override
  String get emptyViewLogs => '这里还没有记录。';

  @override
  String get filterAll => '筛选 · 全部';

  @override
  String filterResults(int count) {
    return '筛选 · $count 条';
  }

  @override
  String downloadStarted(Object fileName) {
    return '开始下载 $fileName';
  }

  @override
  String exportedToPath(Object path) {
    return '已导出到 $path';
  }

  @override
  String get exportHeader => '# Dev Journal Export';

  @override
  String exportedAt(Object time) {
    return '导出时间: $time';
  }

  @override
  String exportRecordCount(int count) {
    return '记录数量: $count';
  }

  @override
  String exportTags(Object tags) {
    return '标签: $tags';
  }
}

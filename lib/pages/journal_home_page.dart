import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todo_app/l10n/app_localizations.dart';
import 'package:todo_app/models/journal_entry.dart';
import 'package:todo_app/services/export/journal_exporter.dart';
import 'package:todo_app/services/journal_store.dart';
import 'package:todo_app/widgets/entry_card.dart';
import 'package:todo_app/widgets/quick_entry_card.dart';
import 'package:todo_app/widgets/stats_row.dart';

enum JournalView { today, calendar, all }

class JournalHomePage extends StatefulWidget {
  const JournalHomePage({
    super.key,
    required this.store,
    required this.onToggleLocale,
  });

  final JournalStore store;
  final VoidCallback onToggleLocale;

  @override
  State<JournalHomePage> createState() => _JournalHomePageState();
}

class _JournalHomePageState extends State<JournalHomePage> {
  static const JournalExporter _exporter = JournalExporter();

  final TextEditingController _entryController = TextEditingController();
  final TextEditingController _keywordController = TextEditingController();

  List<JournalEntry> _entries = <JournalEntry>[];
  bool _isLoading = true;
  DateTime _focusedDay = startOfDay(DateTime.now());
  DateTime _selectedDay = startOfDay(DateTime.now());
  String? _selectedTag;

  AppLocalizations get l10n => AppLocalizations.of(context)!;
  JournalView _currentView = JournalView.today;

  @override
  void initState() {
    super.initState();
    _keywordController.addListener(_refreshView);
    _loadEntries();
  }

  @override
  void dispose() {
    _entryController.dispose();
    _keywordController.dispose();
    super.dispose();
  }

  Future<void> _loadEntries() async {
    final entries = await widget.store.loadEntries();
    if (!mounted) {
      return;
    }

    setState(() {
      _entries = entries;
      _isLoading = false;
    });
  }

  Future<void> _addEntry() async {
    final text = _entryController.text.trim();
    if (text.isEmpty) {
      return;
    }

    final entry = await widget.store.addEntry(text);
    if (!mounted) {
      return;
    }

    setState(() {
      _entries = <JournalEntry>[entry, ..._entries];
      _focusedDay = startOfDay(entry.date);
      _selectedDay = startOfDay(entry.date);
      _currentView = JournalView.today;
      _entryController.clear();
      if (_selectedTag != null && !entry.tags.contains(_selectedTag)) {
        _selectedTag = null;
      }
    });
    _showFeedback('已保存日志');
  }

  Future<void> _deleteEntry(JournalEntry entry) async {
    final shouldDelete = await _showDeleteConfirmDialog();
    if (shouldDelete != true) {
      return;
    }

    await widget.store.deleteEntry(entry.id);
    if (!mounted) {
      return;
    }

    setState(() {
      _entries = _entries.where((item) => item.id != entry.id).toList();
      if (_selectedTag != null &&
          !_collectTags(_entries).contains(_selectedTag)) {
        _selectedTag = null;
      }
    });
    _showFeedback('已删除日志');
  }

  Future<void> _editEntry(JournalEntry entry) async {
    final controller = TextEditingController(text: entry.content);
    final draft = await _showEditDialog(entry, controller);
    controller.dispose();

    if (!mounted || draft == null || draft.text.isEmpty) {
      return;
    }

    final updated = await widget.store.updateEntry(
      entry.id,
      draft.text,
      draft.date,
    );
    if (!mounted || updated == null) {
      return;
    }

    setState(() {
      _entries =
          _entries
              .map((item) => item.id == updated.id ? updated : item)
              .toList()
            ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      _selectedDay = startOfDay(updated.date);
      _focusedDay = startOfDay(updated.date);
      if (_selectedTag != null &&
          !_collectTags(_entries).contains(_selectedTag)) {
        _selectedTag = null;
      }
    });
    _showFeedback('已更新日志');
  }

  void _refreshView() {
    if (mounted) {
      setState(() {});
    }
  }

  void _showFeedback(String message) {
    if (!mounted) {
      return;
    }

    final messenger = ScaffoldMessenger.of(context);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
  }

  Future<void> _exportEntries(
    List<JournalEntry> entries,
    JournalExportFormat format,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    if (entries.isEmpty) {
      _showFeedback(l10n.noLogsToExport);
      return;
    }

    final result = await _exporter.export(entries, format, l10n);
    if (!mounted) {
      return;
    }
    _showFeedback(result.message);
  }

  Future<void> _showExportOptions(List<JournalEntry> entries) async {
    final l10n = AppLocalizations.of(context)!;
    if (_isAppleMobile(context)) {
      await showCupertinoModalPopup<void>(
        context: context,
        builder: (sheetContext) {
          return CupertinoActionSheet(
            title: Text(l10n.exportLogs),
            message: Text(l10n.exportCurrentView),
            actions: [
              CupertinoActionSheetAction(
                onPressed: () async {
                  Navigator.of(sheetContext).pop();
                  await _exportEntries(entries, JournalExportFormat.markdown);
                },
                child: Text(l10n.exportMarkdown),
              ),
              CupertinoActionSheetAction(
                onPressed: () async {
                  Navigator.of(sheetContext).pop();
                  await _exportEntries(entries, JournalExportFormat.json);
                },
                child: Text(l10n.exportJson),
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              onPressed: () => Navigator.of(sheetContext).pop(),
              child: Text(l10n.cancel),
            ),
          );
        },
      );
      return;
    }

    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.description_outlined),
                  title: Text(l10n.exportMarkdown),
                  onTap: () async {
                    Navigator.of(sheetContext).pop();
                    await _exportEntries(entries, JournalExportFormat.markdown);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.data_object),
                  title: Text(l10n.exportJson),
                  onTap: () async {
                    Navigator.of(sheetContext).pop();
                    await _exportEntries(entries, JournalExportFormat.json);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showFilterSheet(List<String> allTags) async {
    final l10n = AppLocalizations.of(context)!;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return SafeArea(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  16,
                  8,
                  16,
                  16 + MediaQuery.viewInsetsOf(context).bottom,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.filterLogs,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _keywordController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.search),
                          hintText: l10n.searchKeyword,
                        ),
                        onChanged: (_) {
                          setState(() {});
                          setSheetState(() {});
                        },
                      ),
                      if (allTags.isNotEmpty) ...[
                        const SizedBox(height: 18),
                        Text(
                          l10n.tags,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            ChoiceChip(
                              label: Text(l10n.allTags),
                              selected: _selectedTag == null,
                              onSelected: (_) {
                                setState(() => _selectedTag = null);
                                setSheetState(() {});
                              },
                            ),
                            for (final tag in allTags)
                              ChoiceChip(
                                label: Text('#$tag'),
                                selected: _selectedTag == tag,
                                onSelected: (_) {
                                  setState(() {
                                    _selectedTag = _selectedTag == tag
                                        ? null
                                        : tag;
                                  });
                                  setSheetState(() {});
                                },
                              ),
                          ],
                        ),
                      ],
                      const SizedBox(height: 18),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: () => Navigator.of(sheetContext).pop(),
                          child: Text(l10n.done),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _showQuickEntrySheet() async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              16,
              8,
              16,
              16 + MediaQuery.viewInsetsOf(sheetContext).bottom,
            ),
            child: QuickEntryCard(
              controller: _entryController,
              autofocus: true,
              onSubmit: () async {
                await _addEntry();
                if (sheetContext.mounted) {
                  Navigator.of(sheetContext).pop();
                }
              },
            ),
          ),
        );
      },
    );
  }

  Future<bool?> _showDeleteConfirmDialog() {
    final l10n = AppLocalizations.of(context)!;
    if (_isAppleMobile(context)) {
      return showCupertinoDialog<bool>(
        context: context,
        builder: (dialogContext) {
          return CupertinoAlertDialog(
            title: Text(l10n.deleteLog),
            content: Text(l10n.deleteLogConfirm),
            actions: [
              CupertinoDialogAction(
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: Text(l10n.cancel),
              ),
              CupertinoDialogAction(
                isDestructiveAction: true,
                onPressed: () => Navigator.of(dialogContext).pop(true),
                child: Text(l10n.delete),
              ),
            ],
          );
        },
      );
    }

    return showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(l10n.deleteLog),
          content: Text(l10n.deleteLogConfirm),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(l10n.confirmDelete),
            ),
          ],
        );
      },
    );
  }

  Future<_EntryEditDraft?> _showEditDialog(
    JournalEntry entry,
    TextEditingController controller,
  ) {
    final l10n = AppLocalizations.of(context)!;
    if (_isAppleMobile(context)) {
      return showCupertinoModalPopup<_EntryEditDraft>(
        context: context,
        builder: (dialogContext) {
          var selectedDate = startOfDay(entry.date);

          return StatefulBuilder(
            builder: (context, setModalState) {
              return AnimatedPadding(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOut,
                padding: EdgeInsets.only(
                  bottom: MediaQuery.viewInsetsOf(context).bottom,
                ),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 430,
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                    decoration: const BoxDecoration(
                      color: CupertinoColors.systemBackground,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(24),
                      ),
                    ),
                    child: SafeArea(
                      top: false,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CupertinoButton(
                                padding: EdgeInsets.zero,
                                onPressed: () =>
                                    Navigator.of(dialogContext).pop(),
                                child: Text(l10n.cancel),
                              ),
                              const Spacer(),
                              CupertinoButton(
                                padding: EdgeInsets.zero,
                                onPressed: () {
                                  Navigator.of(dialogContext).pop(
                                    _EntryEditDraft(
                                      text: controller.text.trim(),
                                      date: selectedDate,
                                    ),
                                  );
                                },
                                child: Text(l10n.save),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            l10n.editLog,
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 12),
                          CupertinoTextField(
                            controller: controller,
                            autofocus: true,
                            maxLines: 4,
                            textInputAction: TextInputAction.done,
                            placeholder: l10n.editLogHint,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            l10n.selectedDateLabel(buildDayKey(selectedDate)),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Expanded(
                            child: CupertinoDatePicker(
                              mode: CupertinoDatePickerMode.date,
                              initialDateTime: selectedDate,
                              onDateTimeChanged: (value) {
                                setModalState(() {
                                  selectedDate = startOfDay(value);
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      );
    }

    return showDialog<_EntryEditDraft>(
      context: context,
      builder: (dialogContext) {
        var selectedDate = startOfDay(entry.date);

        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(l10n.editLog),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: controller,
                    autofocus: true,
                    minLines: 2,
                    maxLines: 5,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(hintText: l10n.editLogHint),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(l10n.dateLabel),
                    subtitle: Text(buildDayKey(selectedDate)),
                    trailing: const Icon(Icons.calendar_today_outlined),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2035, 12, 31),
                      );
                      if (picked != null) {
                        setDialogState(() {
                          selectedDate = startOfDay(picked);
                        });
                      }
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: Text(l10n.cancel),
                ),
                FilledButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop(
                      _EntryEditDraft(
                        text: controller.text.trim(),
                        date: selectedDate,
                      ),
                    );
                  },
                  child: Text(l10n.saveChanges),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final entriesByDay = _buildEntriesByDay(_entries);
    final allTags = _collectTags(_entries);
    final visibleEntries = _visibleEntries();
    final isMobile = MediaQuery.sizeOf(context).width < 900;
    final selectedDayLabel = buildDayKey(_selectedDay);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 76,
        titleSpacing: 20,
        title: Text(
          l10n.appTitle,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: const Color(0xFF17313E),
          ),
        ),
        actions: [
          IconButton(
            tooltip: l10n.languageTooltip,
            onPressed: widget.onToggleLocale,
            icon: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBF5),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: const Color(0xFFE4D8C8)),
              ),
              child: Text(
                l10n.languageCode,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF17313E),
                ),
              ),
            ),
          ),
          IconButton(
            tooltip: l10n.filterTooltip,
            onPressed: () => _showFilterSheet(_collectTags(_entries)),
            icon: const Icon(Icons.tune_rounded),
          ),
          IconButton(
            tooltip: l10n.exportTooltip,
            onPressed: () => _showExportOptions(visibleEntries),
            icon: const Icon(Icons.file_download_outlined),
          ),
          const SizedBox(width: 8),
        ],
      ),
      floatingActionButton: isMobile
          ? FloatingActionButton(
              onPressed: _showQuickEntrySheet,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(Icons.add_rounded),
            )
          : null,
      body: SafeArea(
        child: Stack(
          children: [
            const Positioned(
              top: -120,
              right: -30,
              child: _BackdropOrb(
                size: 280,
                colors: [Color(0x1FBF8B5B), Color(0x11FFFFFF)],
              ),
            ),
            const Positioned(
              top: 110,
              left: -60,
              child: _BackdropOrb(
                size: 220,
                colors: [Color(0x192C7A72), Color(0x08FFFFFF)],
              ),
            ),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : LayoutBuilder(
                    builder: (context, constraints) {
                      final width = constraints.maxWidth;
                      final isDesktop = width >= 1100;
                      final maxWidth = isDesktop ? 1360.0 : 980.0;
                      final horizontalPadding = width >= 1400 ? 36.0 : 20.0;

                      return Align(
                        alignment: Alignment.topCenter,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: maxWidth),
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(
                              horizontalPadding,
                              12,
                              horizontalPadding,
                              24,
                            ),
                            child: isDesktop
                                ? _buildDesktopLayout(
                                    context: context,
                                    entriesByDay: entriesByDay,
                                    visibleEntries: visibleEntries,
                                    allTags: allTags,
                                    selectedDayLabel: selectedDayLabel,
                                  )
                                : _buildMobileLayout(
                                    context: context,
                                    entriesByDay: entriesByDay,
                                    visibleEntries: visibleEntries,
                                    allTags: allTags,
                                    selectedDayLabel: selectedDayLabel,
                                  ),
                          ),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopLayout({
    required BuildContext context,
    required Map<DateTime, List<JournalEntry>> entriesByDay,
    required List<JournalEntry> visibleEntries,
    required List<String> allTags,
    required String selectedDayLabel,
  }) {
    final todayCount = _entriesForView(JournalView.today).length;
    final calendarCount = _entriesForView(JournalView.calendar).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeroBanner(
          visibleCount: visibleEntries.length,
          selectedDayLabel: selectedDayLabel,
        ),
        const SizedBox(height: 20),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 8,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildViewTabs(
                        todayCount: todayCount,
                        calendarCount: calendarCount,
                      ),
                      const SizedBox(height: 18),
                      _buildFiltersCard(allTags),
                      const SizedBox(height: 18),
                      _buildCalendarPanel(entriesByDay, desktop: true),
                      const SizedBox(height: 18),
                      StatsRow(
                        totalCount: _entries.length,
                        visibleCount: visibleEntries.length,
                        selectedDayCount: _entriesForView(
                          JournalView.calendar,
                        ).length,
                        highlightLabel: selectedDayLabel,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                flex: 11,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildListPanel(
                      context: context,
                      entries: visibleEntries,
                      desktop: true,
                    ),
                    const SizedBox(height: 16),
                    QuickEntryCard(
                      controller: _entryController,
                      onSubmit: _addEntry,
                      trailing: OutlinedButton.icon(
                        onPressed: () => _showExportOptions(visibleEntries),
                        icon: const Icon(Icons.file_download_outlined),
                        label: Text(l10n.exportLogs),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout({
    required BuildContext context,
    required Map<DateTime, List<JournalEntry>> entriesByDay,
    required List<JournalEntry> visibleEntries,
    required List<String> allTags,
    required String selectedDayLabel,
  }) {
    final todayCount = _entriesForView(JournalView.today).length;
    final calendarCount = _entriesForView(JournalView.calendar).length;

    return Stack(
      children: [
        RefreshIndicator.adaptive(
          onRefresh: _loadEntries,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeroBanner(
                      visibleCount: visibleEntries.length,
                      selectedDayLabel: selectedDayLabel,
                      compact: true,
                    ),
                    const SizedBox(height: 16),
                    _buildViewTabs(
                      todayCount: todayCount,
                      calendarCount: calendarCount,
                      compact: true,
                    ),
                    const SizedBox(height: 18),
                    if (_currentView == JournalView.calendar) ...[
                      _buildCalendarPanel(entriesByDay, desktop: false),
                      const SizedBox(height: 16),
                    ],
                    _buildMobileSummary(
                      visibleCount: visibleEntries.length,
                      selectedDayCount: _entriesForView(
                        JournalView.calendar,
                      ).length,
                    ),
                    const SizedBox(height: 16),
                    _buildSectionHeader(context, visibleEntries.length),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
              if (visibleEntries.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 96),
                    child: _buildEmptyState(context),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.only(bottom: 96),
                  sliver: SliverList.builder(
                    itemCount: visibleEntries.length,
                    itemBuilder: (context, index) {
                      final entry = visibleEntries[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: EntryCard(
                          entry: entry,
                          compactActions: true,
                          onEdit: () => _editEntry(entry),
                          onDelete: () => _deleteEntry(entry),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildViewTabs({
    required int todayCount,
    required int calendarCount,
    bool compact = false,
  }) {
    final tabs = <({JournalView view, String label, int count, IconData icon})>[
      (
        view: JournalView.today,
        label: l10n.today,
        count: todayCount,
        icon: Icons.today_outlined,
      ),
      (
        view: JournalView.calendar,
        label: l10n.calendar,
        count: calendarCount,
        icon: Icons.calendar_month_outlined,
      ),
      (
        view: JournalView.all,
        label: l10n.all,
        count: _entries.length,
        icon: Icons.view_agenda_outlined,
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F2E7),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE6DACA)),
      ),
      child: Row(
        children: [
          for (final tab in tabs)
            Expanded(
              child: _ViewTabButton(
                label: tab.label,
                count: tab.count,
                icon: tab.icon,
                compact: compact,
                selected: _currentView == tab.view,
                onTap: () {
                  setState(() {
                    _currentView = tab.view;
                  });
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFiltersCard(List<String> allTags) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.filterLogs,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: const Color(0xFF17313E),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              l10n.searchKeyword,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: const Color(0xFF6C756D),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _keywordController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: l10n.searchKeyword,
              ),
            ),
            if (allTags.isNotEmpty) ...[
              const SizedBox(height: 14),
              Align(
                alignment: Alignment.centerLeft,
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ChoiceChip(
                      label: Text(l10n.allTags),
                      selected: _selectedTag == null,
                      onSelected: (_) {
                        setState(() {
                          _selectedTag = null;
                        });
                      },
                    ),
                    for (final tag in allTags)
                      ChoiceChip(
                        label: Text('#$tag'),
                        selected: _selectedTag == tag,
                        onSelected: (_) {
                          setState(() {
                            _selectedTag = _selectedTag == tag ? null : tag;
                          });
                        },
                      ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarPanel(
    Map<DateTime, List<JournalEntry>> entriesByDay, {
    required bool desktop,
  }) {
    return Card(
      color: const Color(0xFFFFFBF5),
      child: Padding(
        padding: EdgeInsets.all(desktop ? 18 : 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  l10n.calendarTitle,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF17313E),
                  ),
                ),
                const Spacer(),
                if (_currentView != JournalView.calendar)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _currentView = JournalView.calendar;
                      });
                    },
                    child: Text(l10n.viewDayLogs),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            _buildCalendarCard(entriesByDay, rowHeight: desktop ? 52 : 42),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileSummary({
    required int visibleCount,
    required int selectedDayCount,
  }) {
    final l10n = AppLocalizations.of(context)!;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _SummaryChip(label: '${l10n.totalCount} ${_entries.length}'),
        _SummaryChip(label: '${l10n.resultCount} $visibleCount'),
        _SummaryChip(label: '${l10n.selectedDayCount} $selectedDayCount'),
        if (_currentView == JournalView.calendar)
          _SummaryChip(
            label: l10n.selectedDateLabel(buildDayKey(_selectedDay)),
          ),
        if (_selectedTag != null) _SummaryChip(label: '#$_selectedTag'),
      ],
    );
  }

  bool _isAppleMobile(BuildContext context) {
    return Theme.of(context).platform == TargetPlatform.iOS &&
        MediaQuery.sizeOf(context).width < 900;
  }

  Widget _buildCalendarCard(
    Map<DateTime, List<JournalEntry>> entriesByDay, {
    required double rowHeight,
    VoidCallback? onSelectionChanged,
    VoidCallback? onDateConfirmed,
  }) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 12, 8, 6),
        child: TableCalendar<JournalEntry>(
          firstDay: DateTime.utc(2020),
          lastDay: DateTime.utc(2035, 12, 31),
          focusedDay: _focusedDay,
          rowHeight: rowHeight,
          daysOfWeekHeight: 22,
          selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
          eventLoader: (day) =>
              entriesByDay[startOfDay(day)] ?? const <JournalEntry>[],
          calendarFormat: CalendarFormat.month,
          headerStyle: const HeaderStyle(
            titleCentered: true,
            formatButtonVisible: false,
            leftChevronMargin: EdgeInsets.zero,
            rightChevronMargin: EdgeInsets.zero,
            titleTextStyle: TextStyle(
              color: Color(0xFF17313E),
              fontWeight: FontWeight.w800,
              fontSize: 18,
            ),
            leftChevronIcon: Icon(
              Icons.chevron_left_rounded,
              color: Color(0xFF17313E),
            ),
            rightChevronIcon: Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFF17313E),
            ),
          ),
          calendarStyle: CalendarStyle(
            todayDecoration: BoxDecoration(
              color: const Color(0x1FBE7C4D),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFBE7C4D), width: 1.2),
            ),
            selectedDecoration: const BoxDecoration(
              color: Color(0xFF17313E),
              shape: BoxShape.circle,
            ),
            markerDecoration: const BoxDecoration(
              color: Color(0xFF2C7A72),
              shape: BoxShape.circle,
            ),
            defaultTextStyle: const TextStyle(
              color: Color(0xFF303734),
              fontWeight: FontWeight.w600,
            ),
            weekendTextStyle: const TextStyle(color: Color(0xFF505C57)),
            outsideTextStyle: const TextStyle(color: Color(0xFFC4C8C6)),
          ),
          daysOfWeekStyle: const DaysOfWeekStyle(
            weekdayStyle: TextStyle(
              color: Color(0xFF9AA4A0),
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
            weekendStyle: TextStyle(
              color: Color(0xFF9AA4A0),
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
          ),
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = startOfDay(selectedDay);
              _focusedDay = startOfDay(focusedDay);
              _currentView = JournalView.calendar;
            });
            onSelectionChanged?.call();
            onDateConfirmed?.call();
          },
          onPageChanged: (focusedDay) {
            _focusedDay = startOfDay(focusedDay);
            onSelectionChanged?.call();
          },
        ),
      ),
    );
  }

  Widget _buildListPanel({
    required BuildContext context,
    required List<JournalEntry> entries,
    required bool desktop,
  }) {
    return Expanded(
      child: Card(
        color: const Color(0xFFFFFBF5),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader(context, entries.length),
              const SizedBox(height: 12),
              if (entries.isEmpty)
                Expanded(child: _buildEmptyState(context))
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: entries.length,
                    itemBuilder: (context, index) {
                      final entry = entries[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: EntryCard(
                          entry: entry,
                          compactActions: !desktop,
                          onEdit: () => _editEntry(entry),
                          onDelete: () => _deleteEntry(entry),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, int visibleCount) {
    final l10n = AppLocalizations.of(context)!;
    final title = switch (_currentView) {
      JournalView.today => l10n.entriesTitleToday,
      JournalView.calendar => l10n.entriesTitleCalendar,
      JournalView.all => l10n.entriesTitleAll,
    };

    return Row(
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
            color: const Color(0xFF17313E),
            letterSpacing: -0.3,
          ),
        ),
        const Spacer(),
        Text(
          l10n.entriesCount(visibleCount),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: const Color(0xFF6C756D),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildHeroBanner({
    required int visibleCount,
    required String selectedDayLabel,
    bool compact = false,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(compact ? 20 : 28),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(34),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF17313E), Color(0xFF2C7A72)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _HeroBadge(
                label: l10n.appSubtitle,
                icon: Icons.auto_awesome_rounded,
              ),
              _HeroBadge(
                label: l10n.entriesCount(visibleCount),
                icon: Icons.layers_outlined,
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            l10n.quickRecord,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            selectedDayLabel,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: const Color(0xE6FFFFFF),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          l10n.emptyViewLogs,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(color: const Color(0xFF57706A)),
        ),
      ),
    );
  }

  List<JournalEntry> _visibleEntries() {
    final keyword = _keywordController.text.trim().toLowerCase();
    final baseEntries = _entriesForView(_currentView);

    return baseEntries.where((entry) {
      final matchesKeyword =
          keyword.isEmpty ||
          entry.content.toLowerCase().contains(keyword) ||
          entry.tags.any((tag) => tag.toLowerCase().contains(keyword));
      final matchesTag =
          _selectedTag == null || entry.tags.contains(_selectedTag);
      return matchesKeyword && matchesTag;
    }).toList()..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  List<JournalEntry> _entriesForView(JournalView view) {
    switch (view) {
      case JournalView.today:
        final today = startOfDay(DateTime.now());
        return _entries.where((entry) => isSameDay(entry.date, today)).toList();
      case JournalView.calendar:
        return _entries
            .where((entry) => isSameDay(entry.date, _selectedDay))
            .toList();
      case JournalView.all:
        return List<JournalEntry>.from(_entries);
    }
  }

  Map<DateTime, List<JournalEntry>> _buildEntriesByDay(
    List<JournalEntry> entries,
  ) {
    final map = <DateTime, List<JournalEntry>>{};
    for (final entry in entries) {
      final day = startOfDay(entry.date);
      map.putIfAbsent(day, () => <JournalEntry>[]).add(entry);
    }
    return map;
  }

  List<String> _collectTags(List<JournalEntry> entries) {
    final tags = <String>{};
    for (final entry in entries) {
      tags.addAll(entry.tags);
    }
    final ordered = tags.toList()..sort();
    return ordered;
  }
}

class _SummaryChip extends StatelessWidget {
  const _SummaryChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFD4E1DC)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: const Color(0xFF45635D),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _ViewTabButton extends StatelessWidget {
  const _ViewTabButton({
    required this.label,
    required this.count,
    required this.icon,
    required this.compact,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final int count;
  final IconData icon;
  final bool compact;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final foreground = selected ? Colors.white : const Color(0xFF17313E);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Material(
        color: selected ? const Color(0xFF17313E) : Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: compact ? 6 : 10,
              vertical: compact ? 11 : 12,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 16, color: foreground),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    '$label $count',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: foreground,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HeroBadge extends StatelessWidget {
  const _HeroBadge({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0x22FFFFFF),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0x2EFFFFFF)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: Colors.white),
            const SizedBox(width: 6),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BackdropOrb extends StatelessWidget {
  const _BackdropOrb({required this.size, required this.colors});

  final double size;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(colors: colors),
        ),
      ),
    );
  }
}

class _EntryEditDraft {
  const _EntryEditDraft({required this.text, required this.date});

  final String text;
  final DateTime date;
}

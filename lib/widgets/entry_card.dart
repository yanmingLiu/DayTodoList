import 'package:flutter/material.dart';
import 'package:todo_app/l10n/app_localizations.dart';
import 'package:todo_app/models/journal_entry.dart';

class EntryCard extends StatelessWidget {
  const EntryCard({
    super.key,
    required this.entry,
    required this.onEdit,
    required this.onDelete,
    this.compactActions = false,
  });

  final JournalEntry entry;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final bool compactActions;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0ECE7),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.notes_rounded,
                    color: Color(0xFF2C7A72),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    entry.content,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF17313E),
                      height: 1.45,
                    ),
                  ),
                ),
                if (compactActions)
                  PopupMenuButton<_EntryAction>(
                    tooltip: l10n.filterTooltip,
                    onSelected: (action) {
                      switch (action) {
                        case _EntryAction.edit:
                          onEdit();
                        case _EntryAction.delete:
                          onDelete();
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: _EntryAction.edit,
                        child: Text(l10n.editLog),
                      ),
                      PopupMenuItem(
                        value: _EntryAction.delete,
                        child: Text(l10n.delete),
                      ),
                    ],
                  )
                else ...[
                  IconButton(
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit_outlined),
                    tooltip: l10n.editLog,
                  ),
                  IconButton(
                    onPressed: onDelete,
                    icon: const Icon(Icons.delete_outline),
                    tooltip: l10n.delete,
                  ),
                ],
              ],
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _MetaChip(
                  icon: Icons.calendar_today_outlined,
                  label: formatEntryTime(entry.date),
                ),
                for (final tag in entry.tags)
                  _MetaChip(icon: Icons.tag, label: '#$tag'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

enum _EntryAction { edit, delete }

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFFE6F1EE),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: const Color(0xFF125B50)),
            const SizedBox(width: 6),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: const Color(0xFF125B50),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:todo_app/l10n/app_localizations.dart';

class QuickEntryCard extends StatelessWidget {
  const QuickEntryCard({
    super.key,
    required this.controller,
    required this.onSubmit,
    this.compact = false,
    this.trailing,
    this.autofocus = false,
  });

  final TextEditingController controller;
  final Future<void> Function() onSubmit;
  final bool compact;
  final Widget? trailing;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    final isCompact = MediaQuery.sizeOf(context).width < 640;
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    if (compact) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.quickRecord,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF17313E),
                      ),
                    ),
                  ),
                  trailing ?? const SizedBox.shrink(),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: controller,
                autofocus: autofocus,
                textInputAction: TextInputAction.done,
                minLines: 1,
                maxLines: 2,
                onSubmitted: (_) => onSubmit(),
                decoration: InputDecoration(
                  isDense: true,
                  hintText: l10n.quickRecordHintCompact,
                  prefixIcon: const Icon(Icons.edit_note_rounded),
                ),
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: FilledButton.icon(
                  onPressed: onSubmit,
                  icon: const Icon(Icons.bolt_rounded, size: 16),
                  label: Text(l10n.save),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFEEE3D1),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                l10n.quickRecord,
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF8B5A36),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.quickRecord,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF17313E),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.quickRecordSupportTags,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFF6C756D),
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                if (trailing != null) ...[const SizedBox(width: 16), trailing!],
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              autofocus: autofocus,
              textInputAction: TextInputAction.done,
              minLines: 1,
              maxLines: 4,
              onSubmitted: (_) => onSubmit(),
              decoration: InputDecoration(
                hintText: l10n.quickRecordHintFull,
                prefixIcon: const Padding(
                  padding: EdgeInsets.only(left: 6),
                  child: Icon(Icons.auto_awesome_outlined),
                ),
                prefixIconConstraints: const BoxConstraints(minWidth: 44),
              ),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: isCompact
                  ? Alignment.centerLeft
                  : Alignment.centerRight,
              child: FilledButton.icon(
                onPressed: onSubmit,
                icon: const Icon(Icons.bolt_rounded),
                label: Text(l10n.save),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

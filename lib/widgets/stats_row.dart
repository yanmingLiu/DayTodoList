import 'package:flutter/material.dart';
import 'package:todo_app/l10n/app_localizations.dart';

class StatsRow extends StatelessWidget {
  const StatsRow({
    super.key,
    required this.totalCount,
    required this.visibleCount,
    required this.selectedDayCount,
    this.highlightLabel,
  });

  final int totalCount;
  final int visibleCount;
  final int selectedDayCount;
  final String? highlightLabel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isCompact = MediaQuery.sizeOf(context).width < 720;

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        SizedBox(
          width: isCompact ? double.infinity : 180,
          child: _StatCard(
            label: l10n.totalCount,
            value: '$totalCount',
            accent: const Color(0xFF17313E),
          ),
        ),
        SizedBox(
          width: isCompact ? double.infinity : 180,
          child: _StatCard(
            label: l10n.resultCount,
            value: '$visibleCount',
            accent: const Color(0xFF2C7A72),
          ),
        ),
        SizedBox(
          width: isCompact ? double.infinity : 180,
          child: _StatCard(
            label: l10n.selectedDayCount,
            value: '$selectedDayCount',
            accent: const Color(0xFFBE7C4D),
          ),
        ),
        if (highlightLabel != null)
          SizedBox(
            width: isCompact ? double.infinity : 220,
            child: _StatCard(
              label: l10n.dateLabel,
              value: highlightLabel!,
              accent: const Color(0xFF72573C),
              isWide: true,
            ),
          ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.accent,
    this.isWide = false,
  });

  final String label;
  final String value;
  final Color accent;
  final bool isWide;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(color: accent, shape: BoxShape.circle),
            ),
            const SizedBox(height: 14),
            Text(
              value,
              maxLines: isWide ? 2 : 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w900,
                color: const Color(0xFF17313E),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: const Color(0xFF6C756D),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

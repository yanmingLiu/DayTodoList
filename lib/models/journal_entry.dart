class JournalEntry {
  JournalEntry({
    required this.id,
    required this.content,
    required this.date,
    required this.createdAt,
    required this.dayKey,
    required this.tags,
  });

  factory JournalEntry.create(String text, {required int id}) {
    final now = DateTime.now();
    return JournalEntry(
      id: id,
      content: text.trim(),
      date: now,
      createdAt: now,
      dayKey: buildDayKey(now),
      tags: extractTags(text),
    );
  }

  factory JournalEntry.fromJson(Map<String, dynamic> json) {
    return JournalEntry(
      id: (json['id'] as num).toInt(),
      content: json['content'] as String,
      date: DateTime.parse(json['date'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      dayKey: json['dayKey'] as String,
      tags: ((json['tags'] as List<dynamic>?) ?? const <dynamic>[])
          .map((tag) => tag.toString())
          .toList(),
    );
  }

  final int id;
  final String content;
  final DateTime date;
  final DateTime createdAt;
  final String dayKey;
  final List<String> tags;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'content': content,
      'date': date.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'dayKey': dayKey,
      'tags': tags,
    };
  }
}

String buildDayKey(DateTime value) {
  final month = value.month.toString().padLeft(2, '0');
  final day = value.day.toString().padLeft(2, '0');
  return '${value.year}-$month-$day';
}

DateTime startOfDay(DateTime value) {
  return DateTime(value.year, value.month, value.day);
}

String formatEntryTime(DateTime value) {
  final hour = value.hour.toString().padLeft(2, '0');
  final minute = value.minute.toString().padLeft(2, '0');
  return '${buildDayKey(value)} $hour:$minute';
}

List<String> extractTags(String text) {
  final tags = <String>[];
  final matches = RegExp(r'#([\p{L}\p{N}_-]+)', unicode: true).allMatches(text);

  for (final match in matches) {
    final tag = match.group(1);
    if (tag != null && tag.isNotEmpty && !tags.contains(tag)) {
      tags.add(tag);
    }
  }

  return tags;
}

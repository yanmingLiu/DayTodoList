# 📘 开发者工作日志系统（App + Web）设计方案

## 一、项目目标

实现一个极简但高效的工作日志工具：

- 输入一句话即可记录事务
- 自动记录当前日期
- 支持日历视图查看
- 支持按日期 / 关键词 / 标签筛选
- 同时兼容 App（iOS / Android）+ Web

---

## 二、核心功能

### ✅ 1. 快速输入
- 单输入框
- 输入内容后自动保存
- 自动记录时间（无需手动选择）

---

### ✅ 2. 自动日期记录
```dart
DateTime.now()
```

---

### ✅ 3. 日历视图
- 按日期展示每日记录
- 点击日期查看详情

---

### ✅ 4. 筛选能力
- 按日期筛选
- 按关键词搜索
- 按标签筛选（如 #flutter）

---

## 三、技术选型

- Flutter（全端）
- isar（本地数据库，支持 Web）
- table_calendar（日历 UI）

---

## 四、数据结构设计

```dart
@collection
class Todo {
  Id id = Isar.autoIncrement;

  late String content;
  late DateTime date;
  List<String> tags = [];
  DateTime createdAt = DateTime.now();
}
```

---

## 五、核心实现

### 添加记录

```dart
Future<void> addTodo(String text) async {
  final todo = Todo()
    ..content = text
    ..date = DateTime.now()
    ..createdAt = DateTime.now();

  await isar.writeTxn(() async {
    await isar.todos.put(todo);
  });
}
```

---

### 日历数据构建

```dart
Map<DateTime, List<Todo>> eventMap = {};

Future<void> loadTodos() async {
  final all = await isar.todos.where().findAll();

  eventMap.clear();

  for (var t in all) {
    final key = DateTime(t.date.year, t.date.month, t.date.day);
    eventMap.putIfAbsent(key, () => []).add(t);
  }
}
```

---

### 筛选

```dart
List<Todo> search(String keyword, List<Todo> all) {
  return all.where((e) => e.content.contains(keyword)).toList();
}
```

---

## 六、标签解析

```dart
List<String> extractTags(String text) {
  final reg = RegExp(r'#(\w+)');
  return reg.allMatches(text).map((e) => e.group(1)!).toList();
}
```

---

## 七、项目结构

```
lib/
 ├── models/
 ├── services/
 ├── pages/
 ├── widgets/
 └── main.dart
```

---

## 八、开发步骤

1. 初始化 Flutter 项目
2. 集成 isar
3. 实现输入 + 存储
4. 实现列表展示
5. 接入日历
6. 实现筛选
7. （可选）云同步

---

## 九、扩展方向

- AI 自动生成日报
- Git 同步
- 热力图统计

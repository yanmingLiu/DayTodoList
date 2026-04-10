# DayTodoList

DayTodoList is a cross-platform Flutter journal and lightweight task capture app built for fast daily logging, calendar-based review, and structured export.

DayTodoList 是一个基于 Flutter 的跨平台日志与轻量任务记录应用，面向“快速记录、按日回看、结构化导出”这类真实日常使用场景。

## Overview | 项目概览

DayTodoList helps users capture short daily notes, organize them by date, discover entries through calendar and keyword filters, and export the current view as Markdown or JSON.

DayTodoList 支持用户快速记录当天内容，按日期组织日志，通过日历、关键字和标签进行筛选，并将当前视图导出为 Markdown 或 JSON。

This repository is positioned as a production-style Flutter app starter with a complete UI shell, local persistence, localization, and basic test coverage.

这个仓库不是单纯的示例代码，而是一个具备完整 UI 外壳、本地持久化、多语言和基础测试覆盖的 Flutter 产品化起点。

## Core Features | 核心能力

- Quick capture for daily logs with lightweight text-first input.
- Built-in tag extraction from `#tag` syntax.
- Three browsing modes: Today, Calendar, and All Logs.
- Keyword search and tag-based filtering.
- Editable and removable entries.
- Local persistence powered by Drift.
- Markdown and JSON export for the current view.
- English and Chinese localization.
- Responsive layout for mobile and desktop form factors.

- 支持快速记录，适合一行式日志输入。
- 支持从 `#标签` 自动提取标签。
- 提供“今天 / 日历 / 全部日志”三种浏览模式。
- 支持关键字搜索与标签筛选。
- 支持日志编辑与删除。
- 基于 Drift 的本地持久化存储。
- 支持将当前视图导出为 Markdown 和 JSON。
- 支持中英文双语。
- 支持移动端与桌面端响应式布局。

## Product Scenarios | 使用场景

- Daily development log
- Lightweight stand-up notes
- Personal work journal
- Study or reading notes
- Exportable activity history for weekly reports

- 开发日报记录
- 轻量站会备忘
- 个人工作日志
- 学习与阅读笔记
- 可导出的周报素材沉淀

## Tech Stack | 技术栈

- Flutter
- Dart
- Drift
- Shared Preferences
- Table Calendar
- Material 3
- Flutter localization (`l10n`)

## Architecture | 架构说明

### App Layer | 应用层

- `lib/app.dart`
  App theme, localization configuration, and root application setup.

- `lib/main.dart`
  App bootstrap and database-backed store initialization.

### Presentation Layer | 展示层

- `lib/pages/journal_home_page.dart`
  Main screen containing the dashboard, calendar, filters, and log list.

- `lib/widgets/`
  Reusable UI components such as entry cards, stats cards, and quick entry panels.

### Domain / Data Layer | 数据层

- `lib/models/journal_entry.dart`
  Journal entry model, tag parsing, and date formatting helpers.

- `lib/services/journal_store.dart`
  Abstract storage contract plus in-memory and Drift-backed implementations.

- `lib/services/app_database.dart`
  Local database definitions and persistence logic.

- `lib/services/export/`
  Export pipeline for Markdown and JSON outputs across platforms.

## Project Structure | 目录结构

```text
.
├── lib
│   ├── app.dart
│   ├── main.dart
│   ├── models
│   ├── pages
│   ├── services
│   └── widgets
├── l10n
├── test
├── android
├── ios
├── macos
├── linux
├── windows
└── web
```

## Getting Started | 快速开始

### Prerequisites | 环境要求

- Flutter SDK `>= 3.10.0`
- Dart SDK compatible with the Flutter version in this repo
- Xcode / Android Studio / Chrome environment depending on your target platform

- Flutter SDK `>= 3.10.0`
- 与当前 Flutter 版本兼容的 Dart SDK
- 根据目标平台准备 Xcode / Android Studio / Chrome 环境

### Install Dependencies | 安装依赖

```bash
flutter pub get
```

### Run the App | 启动应用

```bash
flutter run
```

Examples:

```bash
flutter run -d chrome
flutter run -d ios
flutter run -d macos
```

示例：

```bash
flutter run -d chrome
flutter run -d ios
flutter run -d macos
```

## Localization | 国际化

The app currently ships with:

- English
- Chinese

语言资源位于 `l10n/`，生成后的本地化代码位于 `lib/l10n/`。

If you update ARB files, regenerate localization artifacts with:

```bash
flutter gen-l10n
```

如果你修改了 ARB 文件，可使用以下命令重新生成本地化代码：

```bash
flutter gen-l10n
```

## Export Support | 导出能力

Users can export the currently visible entries as:

- Markdown
- JSON

导出功能适合以下场景：

- 周报汇总
- 开发日志归档
- 数据备份
- 与其他系统做结构化数据对接

## Testing | 测试

Run static analysis:

```bash
flutter analyze
```

Run widget and unit tests:

```bash
flutter test
```

运行静态检查：

```bash
flutter analyze
```

运行组件与单元测试：

```bash
flutter test
```

## Deploy to GitHub Pages | 部署到 GitHub Pages

This repo includes a GitHub Actions workflow at `.github/workflows/deploy-web.yml`.

Push to the `main` branch, then enable GitHub Pages in the repository settings:

1. Open `Settings -> Pages`
2. Set `Source` to `GitHub Actions`
3. Wait for the workflow to finish

The site will then be published at:

```text
https://yanmingLiu.github.io/DayTodoList/
```

Important limitation:

- The current web app stores data in the browser's local database.
- Your entries persist on the same browser and device, but they do not sync automatically across different devices or browsers.

仓库已内置 GitHub Actions 工作流 `.github/workflows/deploy-web.yml`。

推送到 `main` 分支后，在仓库设置中启用 GitHub Pages：

1. 打开 `Settings -> Pages`
2. 将 `Source` 设为 `GitHub Actions`
3. 等待工作流执行完成

发布地址将是：

```text
https://yanmingLiu.github.io/DayTodoList/
```

重要限制：

- 当前 Web 版数据保存在浏览器本地数据库中。
- 同一台设备、同一个浏览器里记录会保留，但不会自动同步到其他设备或其他浏览器。

## Current Status | 当前状态

This repository already includes:

- A functioning local-first journaling workflow
- Responsive UI for multiple device classes
- CRUD operations for entries
- Filter, calendar, and export capabilities
- Basic automated test coverage

当前仓库已具备：

- 可用的本地优先日志记录流程
- 面向多设备尺寸的响应式 UI
- 完整的日志增删改查能力
- 筛选、日历和导出能力
- 基础自动化测试覆盖

## Roadmap | 发展方向

- Cloud sync
- Authentication and multi-device account support
- Richer task management workflow
- Better analytics and weekly insights
- Design system refinement based on production UI specs

- 云端同步
- 账号体系与多设备同步
- 更完整的任务管理流程
- 更强的统计分析与周报洞察
- 基于正式设计稿继续完善设计系统

## Contributing | 参与贡献

Pull requests and issues are welcome. For larger changes, open an issue first to align on scope, architecture, and expected UX impact.

欢迎提交 Issue 与 Pull Request。对于较大的改动，建议先开 Issue 讨论范围、架构方案和交互影响。

## License | 许可证

This project currently does not declare an open-source license.

当前仓库尚未声明开源许可证。如需对外发布，建议补充明确的 License 文件。

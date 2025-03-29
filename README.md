# nsysu_q_form

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

---

## 🔧 修改 App 名稱 / Logo / Bundle ID

若要修改 App 顯示名稱、App 圖示與套件包名，可使用以下工具與指令：

### 1️⃣ 修改 App 顯示名稱（App 名稱）

使用 [`rename`](https://pub.dev/packages/rename) 套件：

```bash
flutter pub global activate rename
flutter pub global run rename setAppName --value "中山行動永續APP"

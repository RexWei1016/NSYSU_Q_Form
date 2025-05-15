import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:intl/intl.dart';
import '../models/food_record.dart';
import '../repositories/food_record_repository.dart';
import '../services/food_sync_service.dart';

class FoodRecordViewModel extends ChangeNotifier {
  final FoodSyncService _syncService = FoodSyncService();
  final FoodRecordRepository _repo = FoodRecordRepository();

  List<FoodRecord> todayRecords = [];
  List<Map<String, String>> weekRecords = [];
  Map<String, String> _pendingUpdates = {};

  Map<String, String> get pendingUpdates => _pendingUpdates;

  Future<void> loadTodayRecords(String date) async {
    todayRecords = await _repo.getRecordsByDate(date);
    notifyListeners();
  }

  void updatePendingMeal(String meal, String value) {
    _pendingUpdates[meal] = value;
    notifyListeners();
  }

  Future<void> submitPendingUpdates(String date, String uuid) async {
    if (_pendingUpdates.isEmpty) return;

    // 先更新本地資料庫
    List<FoodRecord> records = [];
    for (var entry in _pendingUpdates.entries) {
      final record = FoodRecord(date: date, mealType: entry.key, bagType: entry.value);
      await _repo.insertRecord(record);
      records.add(record);
    }

    // 同步到 Google Sheet
    try {
      await _syncService.syncRecordToGoogleSheet(records, uuid);
      debugPrint('所有記錄同步成功');
    } catch (e) {
      debugPrint('同步失敗: $e');
      // TODO: 可以顯示 UI 提示或排入 retry queue
    }

    // 清空待更新列表
    _pendingUpdates.clear();
    
    // 重新載入資料
    await loadTodayRecords(date);
    await loadWeekRecords();
    notifyListeners();
  }

  Future<void> loadWeekRecords() async {
    final now = DateTime.now();
    final monday = now.subtract(Duration(days: now.weekday - 1));
    weekRecords.clear();

    for (int i = 0; i < 7; i++) {
      final day = monday.add(Duration(days: i));
      final dateStr = DateFormat('yyyy-MM-dd').format(day);
      final records = await _repo.getRecordsByDate(dateStr);

      final dayMap = {
        '早餐': records.firstWhereOrNull((r) => r.mealType == '早餐')?.bagType ?? '-',
        '午餐': records.firstWhereOrNull((r) => r.mealType == '午餐')?.bagType ?? '-',
        '晚餐': records.firstWhereOrNull((r) => r.mealType == '晚餐')?.bagType ?? '-',
      };

      weekRecords.add(dayMap);
    }

    notifyListeners();
  }
}

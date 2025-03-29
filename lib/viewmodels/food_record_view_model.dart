import 'package:flutter/material.dart';
import '../models/food_record.dart';
import '../services/food_db_service.dart';
import 'package:collection/collection.dart';
import 'package:intl/intl.dart';

// viewmodels/food_record_view_model.dart
class FoodRecordViewModel extends ChangeNotifier {
  List<FoodRecord> todayRecords = [];
  List<Map<String, String>> weekRecords = [];

  Future<void> loadTodayRecords(String date) async {
    todayRecords = await FoodDBService.getRecordsByDate(date);
    notifyListeners();
  }

  Future<void> updateMeal(String date, String mealType, String bagType) async {
    final record = FoodRecord(date: date, mealType: mealType, bagType: bagType);
    await FoodDBService.insertRecord(record);
    await loadTodayRecords(date);
  }

  Future<void> loadWeekRecords() async {
    final now = DateTime.now();
    final monday = now.subtract(Duration(days: now.weekday - 1));
    weekRecords.clear();

    for (int i = 0; i < 7; i++) {
      final day = monday.add(Duration(days: i));
      final dateStr = DateFormat('yyyy-MM-dd').format(day);
      final records = await FoodDBService.getRecordsByDate(dateStr);

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

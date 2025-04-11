import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:intl/intl.dart';
import '../models/food_record.dart';
import '../repositories/food_record_repository.dart';

class FoodRecordViewModel extends ChangeNotifier {
  final FoodRecordRepository _repo = FoodRecordRepository();

  List<FoodRecord> todayRecords = [];
  List<Map<String, String>> weekRecords = [];

  Future<void> loadTodayRecords(String date) async {
    todayRecords = await _repo.getRecordsByDate(date);
    notifyListeners();
  }

  Future<void> updateMeal(String date, String mealType, String bagType) async {
    final record = FoodRecord(date: date, mealType: mealType, bagType: bagType);
    await _repo.insertRecord(record);
    await loadTodayRecords(date);
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

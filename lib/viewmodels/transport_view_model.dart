import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:intl/intl.dart';
import '../models/transport_record.dart';
import '../repositories/transport_record_repository.dart';

class TransportViewModel extends ChangeNotifier {
  final _repo = TransportRecordRepository();

  List<Map<String, dynamic>> weekRecords = [];
  int todaySteps = 0;
  int todayBike = 0;
  int todayPublic = 0;
  int todayMotorcycle = 0;

  final Health health = Health(); // 使用新版 Health API

  List<TransportRecord> weeklyRecords = [];

  TransportViewModel() {
    _initializeHealth();
  }

  Future<void> _initializeHealth() async {
    try {
      health.configure(); // ✅ 必須先 configure
      if (Platform.isAndroid) {
        await health.getHealthConnectSdkStatus();
      }
    } catch (e) {
      debugPrint('Health 初始化失敗: $e');
    }
  }


  Future<void> loadWeeklyData() async {
    final allRecords = await _repo.getWeeklyRecords();

    final now = DateTime.now();
    final monday = now.subtract(Duration(days: now.weekday - 1));

    weekRecords.clear();

    for (int i = 0; i < 7; i++) {
      final day = monday.add(Duration(days: i));
      final dateStr = DateFormat('yyyy-MM-dd').format(day);

      final r = allRecords.firstWhereOrNull((e) => e.date == dateStr);

      weekRecords.add({
        'date': dateStr,
        'steps': r?.steps ?? '-',
        'bike': r?.bike ?? '-',
        'motorcycle': r?.motorcycle ?? '-',
        'public': r?.publicTransport ?? '-',
      });

      if (dateStr == DateFormat('yyyy-MM-dd').format(now)) {
        todaySteps = r?.steps ?? 0;
        todayBike = r?.bike ?? 0;
        todayMotorcycle = r?.motorcycle ?? 0;
        todayPublic = r?.publicTransport ?? 0;
      }
    }

    notifyListeners();
  }

  Future<void> fetchStepsFromHealth() async {
    try {
      final types = [HealthDataType.STEPS];
      final now = DateTime.now();
      final start = DateTime(now.year, now.month, now.day);

      // Android 上建議先請求感應器權限
      if (Platform.isAndroid) {
        // Android 權限應使用 permission_handler，但可在外部處理
      }

      final authorized = await health.requestAuthorization(types);
      if (!authorized) {
        debugPrint('❌ 無法取得健康資料授權');
        return;
      }

      final steps = await health.getTotalStepsInInterval(start, now);
      todaySteps = steps ?? 0;
      notifyListeners();
    } catch (e) {
      debugPrint('讀取步數失敗: $e');
    }
  }

  Future<void> submitToday(
      String date,
      int steps,
      int bike,
      int motorcycle,
      int publicTransport,
      ) async {
    final record = TransportRecord(
      date: date,
      steps: steps,
      bike: bike,
      motorcycle: motorcycle,
      publicTransport: publicTransport,
    );

    await _repo.insertOrUpdateRecord(record);

    todaySteps = steps;
    todayBike = bike;
    todayMotorcycle = motorcycle;
    todayPublic = publicTransport;

    await loadWeeklyData();
  }
}

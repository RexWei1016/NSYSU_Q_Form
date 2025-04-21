import 'dart:io';

import 'package:flutter/material.dart';
import 'package:health/health.dart';
import '../models/transport_record.dart';
import '../repositories/transport_record_repository.dart';

class TransportViewModel extends ChangeNotifier {
  final _repo = TransportRecordRepository();

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
    weeklyRecords = await _repo.getWeeklyRecords();

    final today = DateTime.now().toIso8601String().substring(0, 10);
    final todayRecord = weeklyRecords.firstWhere(
          (r) => r.date == today,
      orElse: () => TransportRecord(
        date: today,
        steps: 0,
        bike: 0,
        publicTransport: 0,
        motorcycle: 0,
      ),
    );

    todaySteps = todayRecord.steps;
    todayBike = todayRecord.bike;
    todayMotorcycle = todayRecord.motorcycle;
    todayPublic = todayRecord.publicTransport;

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

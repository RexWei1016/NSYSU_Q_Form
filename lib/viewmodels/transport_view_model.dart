// transport_view_model.dart
import 'package:flutter/material.dart';
import '../models/transport_record.dart';
import '../services/transport_db_service.dart';

class TransportViewModel extends ChangeNotifier {
  int todaySteps = 0;
  int todayBike = 0;
  int todayPublic = 0;

  List<TransportRecord> weeklyRecords = [];

  Future<void> loadWeeklyData() async {
    weeklyRecords = await TransportDBService.instance.getWeeklyRecords();
    notifyListeners();
  }

  Future<void> submitToday(String date, int steps, int bike, int publicTransport) async {
    final record = TransportRecord(
      date: date,
      steps: steps,
      bike: bike,
      publicTransport: publicTransport,
    );
    await TransportDBService.instance.insertOrUpdateRecord(record);
    todaySteps = steps;
    todayBike = bike;
    todayPublic = publicTransport;
    await loadWeeklyData();
  }
}

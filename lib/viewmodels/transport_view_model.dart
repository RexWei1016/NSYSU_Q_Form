import 'package:flutter/material.dart';
import '../models/transport_record.dart';
import '../repositories/transport_record_repository.dart';

class TransportViewModel extends ChangeNotifier {
  final _repo = TransportRecordRepository();

  int todaySteps = 0;
  int todayBike = 0;
  int todayPublic = 0;

  List<TransportRecord> weeklyRecords = [];

  Future<void> loadWeeklyData() async {
    weeklyRecords = await _repo.getWeeklyRecords();
    notifyListeners();
  }

  Future<void> submitToday(String date, int steps, int bike, int publicTransport) async {
    final record = TransportRecord(
      date: date,
      steps: steps,
      bike: bike,
      publicTransport: publicTransport,
    );

    await _repo.insertOrUpdateRecord(record);

    todaySteps = steps;
    todayBike = bike;
    todayPublic = publicTransport;

    await loadWeeklyData();
  }
}

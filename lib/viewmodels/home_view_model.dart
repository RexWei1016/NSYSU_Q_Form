import 'package:flutter/material.dart';
import '../models/announcement_model.dart';
import '../repositories/food_record_repository.dart';
import 'package:intl/intl.dart';

class HomeViewModel extends ChangeNotifier {
  final AnnouncementModel announcement = AnnouncementModel(
    message: '🌱 歡迎使用永續APP！記得每日記錄喔～',
  );

  String? _latestNotificationTitle;
  String? _latestNotificationBody;
  final _foodRepo = FoodRecordRepository();
  bool _hasTodayFoodRecord = false;

  String? get latestNotificationTitle => _latestNotificationTitle;
  String? get latestNotificationBody => _latestNotificationBody;
  bool get hasTodayFoodRecord => _hasTodayFoodRecord;

  Future<void> refreshTodayFoodRecord() async {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final records = await _foodRepo.getRecordsByDate(today);
    _hasTodayFoodRecord = records.any((record) => record.bagType != '無用餐');
    notifyListeners();
  }

  void updateNotification(String title, String body) {
    _latestNotificationTitle = title;
    _latestNotificationBody = body;
    notifyListeners();
  }

  void onProfilePressed(BuildContext context) {
    Navigator.pushNamed(context, '/profile');
  }

  void onTransportPressed(BuildContext context) {
    Navigator.pushNamed(context, '/transport');
  }

  void onFoodPressed(BuildContext context) {
    Navigator.pushNamed(context, '/food_record');
  }

  void onScanPressed(BuildContext context) {
    Navigator.pushNamed(context, '/scan_qr');
  }
}

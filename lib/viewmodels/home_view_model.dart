import 'package:flutter/material.dart';
import '../models/announcement_model.dart';

class HomeViewModel extends ChangeNotifier {
  final AnnouncementModel announcement = AnnouncementModel(
    message: '🌱 歡迎使用永續APP！記得每日記錄喔～',
  );

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

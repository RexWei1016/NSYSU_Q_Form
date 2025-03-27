import 'package:flutter/material.dart';
import '../models/announcement_model.dart';

class HomeViewModel extends ChangeNotifier {
  final AnnouncementModel announcement = AnnouncementModel(
    message: '🌱 歡迎使用永續APP！記得每日記錄喔～',
  );

  void onProfilePressed() {
    // TODO: 跳轉至個人基本資料
  }

  void onTransportPressed() {
    // TODO: 跳轉至交通方法日誌
  }

  void onFoodPressed() {
    // TODO: 跳轉至購餐紀錄
  }
}

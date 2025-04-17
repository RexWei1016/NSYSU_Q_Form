import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import '../models/user_profile.dart';
import '../services/local_storage_service.dart';
import 'package:flutter/foundation.dart';

class ProfileRepository {
  static const String baseUrl = 'http://10.0.2.2:5026';

  Future<UserProfile?> getLocalProfile() async {
    return await LocalStorageService.getProfile();
  }

  Future<void> saveLocalProfile(UserProfile profile) async {
    await LocalStorageService.saveProfile(profile);
  }

  Future<void> syncProfileToServer(UserProfile profile) async {
    final url = Uri.parse('$baseUrl/api/Participant');
    final token = await FirebaseMessaging.instance.getToken() ?? 'no-token';

    final body = jsonEncode({
      'uuid': profile.userId,
      'deviceToken': token,
      'name': profile.email // 根據實際 API 欄位調整
    });

    try {
      final response = await http.post(url, headers: {
        'Content-Type': 'application/json',
      }, body: body);

      if (response.statusCode != 200) {
        debugPrint('同步 API 失敗: ${response.body}');
      }
    } catch (e) {
      debugPrint('API 錯誤: $e');
    }
  }

  Future<String?> joinStudy(String uuid, String studyId) async {
    final url = Uri.parse('$baseUrl/api/Participant/join');
    final body = jsonEncode({
      'uuid': uuid,
      'studyId': studyId,
    });

    try {
      final response = await http.post(url, headers: {
        'Content-Type': 'application/json',
      }, body: body);

      if (response.statusCode == 200) {
        return null; // null 代表成功
      } else {
        debugPrint('加入研究失敗: ${response.body}');
        return response.body; // 回傳錯誤訊息
      }
    } catch (e) {
      debugPrint('加入研究 API 錯誤: $e');
      return '無法連線至伺服器';
    }
  }


}
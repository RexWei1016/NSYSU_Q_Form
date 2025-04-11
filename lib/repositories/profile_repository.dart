import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import '../models/user_profile.dart';
import '../services/local_storage_service.dart';
import 'package:flutter/foundation.dart';

class ProfileRepository {
  final _apiUrl = 'http://10.0.2.2:5026/api/Participant';

  Future<UserProfile?> getLocalProfile() async {
    return await LocalStorageService.getProfile();
  }

  Future<void> saveLocalProfile(UserProfile profile) async {
    await LocalStorageService.saveProfile(profile);
  }

  Future<void> syncProfileToServer(UserProfile profile) async {
    final url = Uri.parse(_apiUrl);
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
}

// lib/services/local_storage_service.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_profile.dart';

class LocalStorageService {
  static const _key = 'user_profile';

  static Future<void> saveProfile(UserProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_key, jsonEncode(profile.toJson()));
  }

  static Future<UserProfile?> getProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);
    if (jsonString == null) return null;

    final Map<String, dynamic> json = jsonDecode(jsonString);
    return UserProfile.fromJson(json);
  }
}

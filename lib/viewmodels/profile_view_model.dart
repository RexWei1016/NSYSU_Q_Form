// lib/viewmodels/profile_view_model.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_profile.dart';
import '../services/local_storage_service.dart';

class ProfileViewModel extends ChangeNotifier {
  UserProfile _profile = const UserProfile(
    email: 'example@email.com',
    department: '資訊管理學系',
    grade: '碩二',
    birthYear: '1995',
    gender: '男',
    userId: '',
  );

  UserProfile get profile => _profile;

  Future<UserProfile> loadProfileWithReturn() async {
    final data = await LocalStorageService.getProfile();
    if (data != null) {
      _profile = data;
      notifyListeners();
    }
    return _profile;
  }

  Future<void> updateProfile(UserProfile newProfile) async {
    _profile = newProfile;
    await LocalStorageService.saveProfile(_profile);
    notifyListeners();
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/user_profile.dart';
import '../repositories/profile_repository.dart';
import '../repositories/SurveyRepository.dart';
class ProfileViewModel extends ChangeNotifier {
  final ProfileRepository _repository = ProfileRepository();
  final SurveyRepository _surveyRepository = SurveyRepository();

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
    final data = await _repository.getLocalProfile();
    if (data != null) {
      _profile = data;
      notifyListeners();
    }
    return _profile;
  }

  Future<void> updateProfile(UserProfile newProfile) async {
    _profile = newProfile;
    await _repository.saveLocalProfile(newProfile);
    await _repository.syncProfileToServer(newProfile);
    notifyListeners();
  }

  Future<void> syncToServerIfNeeded() async {
    if (_profile.userId.isNotEmpty) {
      await _repository.syncProfileToServer(_profile);
    }
  }

  Future<String?> joinStudy(String studyId) async {
    return await _repository.joinStudy(_profile.userId, studyId);
  }

  Future<List<String>> getMySurveys() async {
    return await _surveyRepository.fetchSurveyLinks(_profile);
  }



}

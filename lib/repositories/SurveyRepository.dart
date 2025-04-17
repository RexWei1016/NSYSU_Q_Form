import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_profile.dart';
import '../models/food_record.dart';
import '../models/transport_record.dart';
import '../services/food_db_service.dart';
import '../services/transport_db_service.dart';
import 'package:flutter/foundation.dart';

class SurveyRepository {
  // static const String baseUrl = 'http://10.0.2.2:5026';
  static const String baseUrl = 'https://nsysu-q-backside.onrender.com';

  Future<List<Map<String, dynamic>>> getAvailableSurveys(String uuid) async {
    final url = Uri.parse('$baseUrl/api/Participant/$uuid/surveys');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> raw = jsonDecode(response.body);
        return raw.cast<Map<String, dynamic>>();
      } else {
        debugPrint('取得問卷失敗: ${response.body}');
        return [];
      }
    } catch (e) {
      debugPrint('取得問卷錯誤: $e');
      return [];
    }
  }

  Future<List<String>> fetchSurveyLinks(UserProfile profile) async {
    final uuid = profile.userId;
    if (uuid.isEmpty) {
      debugPrint(' UUID 為空，無法查詢問卷');
      return [];
    }

    final surveys = await getAvailableSurveys(uuid);
    final links = <String>[];

    final today = DateTime.now();
    final dateStr = '${today.year.toString().padLeft(4, '0')}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

    final foodRecords = await FoodDBService.getRecordsByDate(dateStr);
    final transportRecords = await TransportDBService.instance.getWeeklyRecords();
    final todayTransport = transportRecords.firstWhere(
          (r) => r.date == dateStr,
      orElse: () => TransportRecord(date: dateStr, steps: 0, bike: 0, publicTransport: 0),
    );

    for (final s in surveys) {
      final entryMap = s['entryMap'] as Map<String, dynamic>?;
      if (entryMap == null) continue;

      String prefilledUrl = s['prefilledUrl'] ?? s['originalUrl'];

      void addParam(String key, String value) {
        final entry = entryMap[key]?['entry'];
        if (entry != null) {
          final placeholder = '{{${entry.replaceAll('entry.', '')}}}'; // ✅ 變成 {{53025757}}
          prefilledUrl = prefilledUrl.replaceAll(placeholder, Uri.encodeComponent(value));
        }
      }



      addParam('系所年級', '${profile.department}${profile.grade}');
      addParam('性別', profile.gender);
      addParam('裝置編號 (uuid)', profile.userId);
      addParam('出生年', profile.birthYear);

      for (var meal in ['早餐', '午餐', '晚餐']) {
        final mealRecord = foodRecords.firstWhere(
              (r) => r.mealType == meal,
          orElse: () => FoodRecord(date: dateStr, mealType: meal, bagType: '無用餐'),
        );
        addParam('購餐紀錄 ($meal)', '$meal${mealRecord.bagType}');
      }

      addParam('今日步數', todayTransport.steps.toString());
      addParam('摩托車次數', todayTransport.bike.toString());
      addParam('公共交通次數', todayTransport.publicTransport.toString());

      links.add(prefilledUrl);
    }

    return links;
  }
}

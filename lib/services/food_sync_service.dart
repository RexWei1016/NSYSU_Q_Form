import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/food_record.dart';

class FoodSyncService {
  static const String endpoint =
      'https://script.google.com/macros/s/AKfycbzoEb-qgJMkkQAnPqd8aiUiJyupdrhNNfB5dK04rRdZeOCJpXj8J2y7IKUuDqyDlkj2/exec';

  Future<void> syncRecordToGoogleSheet(List<FoodRecord> records, String uuid) async {
    // 將所有記錄合併成一個物件
    final Map<String, dynamic> payload = {
      "日期": records.first.date,
      "UUID": uuid,
    };

    // 將每筆記錄的餐點類型加入 payload
    for (var record in records) {
      payload[record.mealType] = record.bagType;
    }

    try {
      final response = await http.post(
        Uri.parse(endpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode([payload]), // 保持陣列格式以符合 API 要求
      );

      if (response.statusCode != 200) {
        throw Exception('POST 失敗: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/food_record.dart';

class FoodSyncService {
  static const String endpoint =
      'https://script.google.com/macros/s/AKfycbzoEb-qgJMkkQAnPqd8aiUiJyupdrhNNfB5dK04rRdZeOCJpXj8J2y7IKUuDqyDlkj2/exec';

  Future<void> syncRecordToGoogleSheet(FoodRecord record, String uuid) async {
    final payload = [
      {
        "日期": record.date,
        "UUID": uuid,
        record.mealType: record.bagType,
      }
    ];

    try {
      final response = await http.post(
        Uri.parse(endpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      if (response.statusCode != 200) {
        throw Exception('POST 失敗: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/transport_record.dart';

class TransportSyncService {
  static const String endpoint =
      'https://script.google.com/macros/s/AKfycbx5kMtwVcPTZrqyiHv6JHwwQVB_Yhg57kQtbyoaqU_xN_chCb50TIco7fWwVng5y0j3SA/exec';

  Future<void> syncRecordToGoogleSheet(
      TransportRecord record, String uuid) async {
    final payload = [
      {
        "日期": record.date,
        "UUID": uuid,
        "步數": record.steps,
        "腳踏車次數": record.bike,
        "公共交通次數": record.publicTransport,
        "摩托車次數": record.motorcycle,
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
      rethrow; // 讓上層決定是否處理錯誤
    }
  }
}

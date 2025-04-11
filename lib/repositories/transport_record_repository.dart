import '../models/transport_record.dart';
import '../services/transport_db_service.dart';

class TransportRecordRepository {
  final _service = TransportDBService.instance;

  Future<void> insertOrUpdateRecord(TransportRecord record) async {
    await _service.insertOrUpdateRecord(record);
  }

  Future<List<TransportRecord>> getWeeklyRecords() async {
    return await _service.getWeeklyRecords();
  }
}

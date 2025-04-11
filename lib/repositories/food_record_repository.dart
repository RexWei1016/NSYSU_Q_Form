import '../models/food_record.dart';
import '../services/food_db_service.dart';

class FoodRecordRepository {
  Future<void> insertRecord(FoodRecord record) async {
    await FoodDBService.insertRecord(record);
  }

  Future<List<FoodRecord>> getRecordsByDate(String date) async {
    return await FoodDBService.getRecordsByDate(date);
  }
}

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/food_record.dart';

class FoodDBService {
  static Database? _db;

  static Future<Database> get database async {
    _db ??= await _initDB();
    return _db!;
  }

  static Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'food_record.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE food_records (
            date TEXT,
            mealType TEXT,
            bagType TEXT,
            PRIMARY KEY (date, mealType)
          )
        ''');
      },
    );
  }

  static Future<void> insertRecord(FoodRecord record) async {
    final db = await database;
    await db.insert(
      'food_records',
      record.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<FoodRecord>> getRecordsByDate(String date) async {
    final db = await database;
    final result = await db.query(
      'food_records',
      where: 'date = ?',
      whereArgs: [date],
    );
    return result.map((e) => FoodRecord.fromMap(e)).toList();
  }
}

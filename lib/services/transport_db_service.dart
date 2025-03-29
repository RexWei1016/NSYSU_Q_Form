import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/transport_record.dart';

class TransportDBService {
  static final TransportDBService instance = TransportDBService._internal();
  TransportDBService._internal();

  static Database? _db;

  Future<Database> get db async {
    _db ??= await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final path = join(await getDatabasesPath(), 'transport.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE transport (
            date TEXT PRIMARY KEY,
            steps INTEGER,
            bike INTEGER,
            public INTEGER
          )
        ''');
      },
    );
  }

  Future<void> insertOrUpdateRecord(TransportRecord record) async {
    final dbClient = await db;
    await dbClient.insert(
      'transport',
      record.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<TransportRecord>> getWeeklyRecords() async {
    final dbClient = await db;
    final now = DateTime.now();
    final monday = now.subtract(Duration(days: now.weekday - 1));
    final week = List.generate(7, (i) => monday.add(Duration(days: i)));

    final result = await dbClient.rawQuery(
      'SELECT * FROM transport WHERE date IN (${List.filled(7, '?').join(',')})',
      week.map((d) => d.toIso8601String().substring(0, 10)).toList(),
    );

    return result.map((e) => TransportRecord.fromMap(e)).toList();
  }
}

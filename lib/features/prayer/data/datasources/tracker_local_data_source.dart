import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import '../../../../core/utils/database_helper.dart';
import '../models/prayer_time_record_model.dart';

abstract class TrackerLocalDataSource {
  Future<void> savePrayerRecord(PrayerTimeRecordModel record);
  Future<List<PrayerTimeRecordModel>> getPrayerRecords(
    DateTime startDate,
    DateTime endDate,
  );
  Future<List<PrayerTimeRecordModel>> getPrayerRecordsForDate(DateTime date);
}

class TrackerLocalDataSourceImpl implements TrackerLocalDataSource {
  final DatabaseHelper dbHelper;

  TrackerLocalDataSourceImpl(this.dbHelper);

  @override
  Future<void> savePrayerRecord(PrayerTimeRecordModel record) async {
    final db = await dbHelper.database;
    await db.insert(
      'prayer_records',
      record.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<List<PrayerTimeRecordModel>> getPrayerRecords(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final db = await dbHelper.database;
    final startStr = DateFormat('yyyy-MM-dd').format(startDate);
    final endStr = DateFormat('yyyy-MM-dd').format(endDate);

    final maps = await db.query(
      'prayer_records',
      where: 'date >= ? AND date <= ?',
      whereArgs: [startStr, endStr],
    );

    return maps.map((map) => PrayerTimeRecordModel.fromJson(map)).toList();
  }

  @override
  Future<List<PrayerTimeRecordModel>> getPrayerRecordsForDate(
    DateTime date,
  ) async {
    final db = await dbHelper.database;
    final dateStr = DateFormat('yyyy-MM-dd').format(date);

    final maps = await db.query(
      'prayer_records',
      where: 'date = ?',
      whereArgs: [dateStr],
    );

    return maps.map((map) => PrayerTimeRecordModel.fromJson(map)).toList();
  }
}

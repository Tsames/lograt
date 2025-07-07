import 'package:lograt/data/models/workout_summary_model.dart';
import 'package:sqflite/sqflite.dart';
import '../../models/workout_model.dart';
import '../app_database.dart';

class WorkoutDao {
  final AppDatabase _db;
  static const _tableName = 'workouts';

  WorkoutDao(this._db);

  /// Get an workout by its ID as a [WorkoutSummaryModel]
  /// Returns null if no workout with the given ID exists
  Future<WorkoutSummaryModel?> getSummaryById(int id) async {
    final database = await _db.database;
    final maps = await database.query(_tableName, where: 'id = ?', whereArgs: [id]);

    if (maps.isEmpty) return null;
    return WorkoutSummaryModel.fromMap(maps.first);
  }

  /// Get an workout by its ID as a [WorkoutModel]
  /// Returns null if no workout with the given ID exists
  Future<WorkoutModel?> getById(int id) async {
    final database = await _db.database;
    final maps = await database.query(_tableName, where: 'id = ?', whereArgs: [id]);

    if (maps.isEmpty) return null;
    return WorkoutModel.fromMap(maps.first);
  }

  /// Get a list of the most recent [limit] number of workouts as [WorkoutSummaryModel]
  /// for workouts within the last three months of the current date
  Future<List<WorkoutSummaryModel>> getRecentSummaries({int limit = 20}) async {
    final db = await _db.database;
    final sixMonthsAgo = DateTime.now().subtract(Duration(days: 90)).millisecondsSinceEpoch;

    final maps = await db.query(
      _tableName,
      where: 'createdOn >= ?',
      whereArgs: [sixMonthsAgo],
      orderBy: 'createdOn DESC',
      limit: limit,
    );

    return maps.map((map) => WorkoutSummaryModel.fromMap(map)).toList();
  }

  Future<int> insert(WorkoutModel workout) async {
    final db = await _db.database;
    return await db.insert(_tableName, workout.toMap(), conflictAlgorithm: ConflictAlgorithm.fail);
  }

  Future<int> insertWithTransaction({required WorkoutModel workout, required Transaction txn}) async {
    return await txn.insert(_tableName, workout.toMap());
  }

  Future<int> update(WorkoutModel workout) async {
    final db = await _db.database;
    return await db.update(_tableName, workout.toMap(), where: 'id = ?', whereArgs: [workout.id]);
  }

  Future<int> delete(int id) async {
    final db = await _db.database;
    return await db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> clearTable() async {
    final db = await _db.database;
    await db.delete(_tableName);
  }
}

import 'package:lograt/data/database/app_database.dart';
import 'package:lograt/data/models/workout_model.dart';
import 'package:sqflite/sqflite.dart';

class WorkoutDao {
  final AppDatabase _db;
  static const _tableName = 'workouts';

  WorkoutDao(this._db);

  /// Get a workout by its ID
  /// Returns null if no workout with the given ID exists
  Future<WorkoutModel?> getById(String id) async {
    final database = await _db.database;
    final maps = await database.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;
    return WorkoutModel.fromMap(maps.first);
  }

  /// Get a list of the workouts of length [limit]
  /// Workouts returned will be in order of creation date DESC
  Future<List<WorkoutModel>> getWorkoutSummaries({
    int? limit,
    int? offset,
  }) async {
    final db = await _db.database;

    final maps = await db.query(
      _tableName,
      orderBy: 'date DESC',
      limit: limit,
      offset: offset,
    );

    return maps.map((map) => WorkoutModel.fromMap(map)).nonNulls.toList();
  }

  /// Get a list of the workouts that were created after the given datetime in milliseconds
  /// Workouts returned will be in order of creation date DESC
  Future<List<WorkoutModel>> getWorkoutSummariesAfterTime(
    int dateThresholdInMilliseconds,
  ) async {
    final db = await _db.database;

    final maps = await db.query(
      _tableName,
      where: 'date >= ?',
      whereArgs: [dateThresholdInMilliseconds],
      orderBy: 'date DESC',
    );

    return maps.map((map) => WorkoutModel.fromMap(map)).nonNulls.toList();
  }

  Future<void> insert(WorkoutModel workout) async {
    final db = await _db.database;
    await db.insert(
      _tableName,
      workout.toMap(),
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }

  Future<void> insertWithTransaction(
    WorkoutModel workout,
    Transaction txn,
  ) async {
    await txn.insert(_tableName, workout.toMap());
  }

  Future<int> update(WorkoutModel workout) async {
    final db = await _db.database;
    return await db.update(
      _tableName,
      workout.toMap(),
      where: 'id = ?',
      whereArgs: [workout.id],
    );
  }

  Future<int> delete(String id) async {
    final db = await _db.database;
    return await db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> clearTable() async {
    final db = await _db.database;
    await db.delete(_tableName);
  }
}

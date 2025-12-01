import 'package:lograt/data/database/app_database.dart';
import 'package:lograt/data/models/workouts/workout_model.dart';
import 'package:sqflite/sqflite.dart';

class WorkoutDao {
  final AppDatabase _db;

  WorkoutDao(this._db);

  Future<WorkoutModel?> getById(String id, [Transaction? txn]) async {
    final DatabaseExecutor executor = txn ?? await _db.database;
    final maps = await executor.query(
      workoutsTable,
      where: '${WorkoutFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;
    return WorkoutModel.fromMap(maps.first);
  }

  /// Get a list of the workouts of length [limit] starting from [offset]
  /// Workouts returned will be in order of creation date DESC
  Future<List<WorkoutModel>> getListOfWorkoutsOrderedByCreationDate({
    int? limit,
    int? offset,
    Transaction? txn,
  }) async {
    final DatabaseExecutor executor = txn ?? await _db.database;

    final maps = await executor.query(
      workoutsTable,
      orderBy: '${WorkoutFields.date} DESC',
      limit: limit,
      offset: offset,
    );

    return maps.map((map) => WorkoutModel.fromMap(map)).nonNulls.toList();
  }

  Future<void> insert(WorkoutModel workout, [Transaction? txn]) async {
    final DatabaseExecutor executor = txn ?? await _db.database;
    await executor.insert(
      workoutsTable,
      workout.toMap(),
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }

  Future<int> update(WorkoutModel workout, [Transaction? txn]) async {
    final DatabaseExecutor executor = txn ?? await _db.database;
    return await executor.update(
      workoutsTable,
      workout.toMap(),
      where: '${WorkoutFields.id} = ?',
      whereArgs: [workout.id],
    );
  }

  Future<int> delete(String id, [Transaction? txn]) async {
    final DatabaseExecutor executor = txn ?? await _db.database;
    return await executor.delete(
      workoutsTable,
      where: '${WorkoutFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future<void> clearTable([Transaction? txn]) async {
    final DatabaseExecutor executor = txn ?? await _db.database;
    await executor.delete(workoutsTable);
  }
}

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
  Future<List<WorkoutModel>> getAllPaginatedOrderedByCreationDate({
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

  Future<void> batchInsert(
    List<WorkoutModel> workouts, [
    Transaction? txn,
  ]) async {
    if (workouts.isEmpty) return;

    final DatabaseExecutor executor = txn ?? await _db.database;
    final batch = executor.batch();

    for (final workout in workouts) {
      batch.insert(
        workoutsTable,
        workout.toMap(),
        conflictAlgorithm: ConflictAlgorithm.fail,
      );
    }

    await batch.commit(noResult: true);
  }

  Future<void> update(WorkoutModel workout, [Transaction? txn]) async {
    final DatabaseExecutor executor = txn ?? await _db.database;
    final rowsUpdated = await executor.update(
      workoutsTable,
      workout.toMap(),
      where: '${WorkoutFields.id} = ?',
      whereArgs: [workout.id],
    );

    if (rowsUpdated == 0) {
      throw Exception('Cannot update workout $workout: does not exist');
    }
  }

  Future<void> batchUpdate(
    List<WorkoutModel> workouts, [
    Transaction? txn,
  ]) async {
    if (workouts.isEmpty) return;

    Future<void> executeUpdate(Transaction transaction) async {
      for (final workout in workouts) {
        final exists = await getById(workout.id, transaction);
        if (exists == null) {
          throw Exception('Cannot update workout $workout: does not exist');
        }
      }

      final batch = transaction.batch();
      for (final workout in workouts) {
        batch.update(
          workoutsTable,
          workout.toMap(),
          where: '${WorkoutFields.id} = ?',
          whereArgs: [workout.id],
        );
      }
      await batch.commit(noResult: true);
    }

    // If no transaction provided, create one
    if (txn != null) {
      await executeUpdate(txn);
    } else {
      final db = await _db.database;
      await db.transaction((transaction) async {
        await executeUpdate(transaction);
      });
    }
  }

  Future<void> delete(String id, [Transaction? txn]) async {
    final DatabaseExecutor executor = txn ?? await _db.database;
    final rowsDeleted = await executor.delete(
      workoutsTable,
      where: '${WorkoutFields.id} = ?',
      whereArgs: [id],
    );

    if (rowsDeleted == 0) {
      throw Exception('Cannot delete workout $id: does not exist');
    }
  }

  Future<void> clearTable([Transaction? txn]) async {
    final DatabaseExecutor executor = txn ?? await _db.database;
    await executor.delete(workoutsTable);
  }
}

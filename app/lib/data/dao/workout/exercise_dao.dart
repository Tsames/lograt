import 'package:lograt/data/database/app_database.dart';
import 'package:lograt/data/models/workouts/exercise_model.dart';
import 'package:lograt/data/models/workouts/workout_model.dart';
import 'package:sqflite/sqflite.dart';

class ExerciseDao {
  final AppDatabase _db;
  static const String _tableName = exercisesTable;

  ExerciseDao(this._db);

  Future<ExerciseModel?> getById(String id, [Transaction? txn]) async {
    final DatabaseExecutor executor = txn ?? await _db.database;
    final maps = await executor.query(
      _tableName,
      where: '${ExerciseFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;
    return ExerciseModel.fromMap(maps.first);
  }

  Future<List<ExerciseModel>> getAllExercisesWithWorkoutId(
    String workoutId, [
    Transaction? txn,
  ]) async {
    final DatabaseExecutor executor = txn ?? await _db.database;
    final maps = await executor.query(
      _tableName,
      where: '${ExerciseFields.workoutId} = ?',
      whereArgs: [workoutId],
    );

    return maps.map((map) => ExerciseModel.fromMap(map)).nonNulls.toList();
  }

  Future<ExerciseModel?> getMostRecentExerciseThatHasExerciseTypeId(
    String exerciseTypeId, [
    Transaction? txn,
  ]) async {
    final DatabaseExecutor executor = txn ?? await _db.database;

    final maps = await executor.rawQuery(
      '''
    SELECT e.*
    FROM $_tableName e
    INNER JOIN $workoutsTable w ON e.${ExerciseFields.workoutId} = w.${WorkoutFields.id}
    WHERE e.${ExerciseFields.exerciseTypeId} = ?
    ORDER BY w.${WorkoutFields.date} DESC, e.${ExerciseFields.order} DESC
    LIMIT 1
    ''',
      [exerciseTypeId],
    );

    if (maps.isEmpty) return null;
    return ExerciseModel.fromMap(maps.first);
  }

  Future<int> insert(ExerciseModel exercise, [Transaction? txn]) async {
    final DatabaseExecutor executor = txn ?? await _db.database;
    return await executor.insert(
      _tableName,
      exercise.toMap(),
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }

  Future<void> batchInsert(
    List<ExerciseModel> exercises, [
    Transaction? txn,
  ]) async {
    if (exercises.isEmpty) return;

    final DatabaseExecutor executor = txn ?? await _db.database;
    final batch = executor.batch();

    for (final exercise in exercises) {
      batch.insert(
        _tableName,
        exercise.toMap(),
        conflictAlgorithm: ConflictAlgorithm.fail,
      );
    }

    await batch.commit(noResult: true);
  }

  Future<void> update(ExerciseModel exercise, [Transaction? txn]) async {
    final DatabaseExecutor executor = txn ?? await _db.database;
    final rowsUpdated = await executor.update(
      _tableName,
      exercise.toMap(),
      where: '${ExerciseFields.id} = ?',
      whereArgs: [exercise.id],
    );

    if (rowsUpdated == 0) {
      throw Exception('Cannot update exercise $exercise: does not exist');
    }
  }

  Future<void> batchUpdate(
    List<ExerciseModel> exercises, [
    Transaction? txn,
  ]) async {
    if (exercises.isEmpty) return;

    Future<void> executeUpdate(Transaction transaction) async {
      for (final exercise in exercises) {
        final exists = await getById(exercise.id, transaction);
        if (exists == null) {
          throw Exception('Cannot update exercise $exercise: does not exist');
        }
      }

      final batch = transaction.batch();
      for (final exercise in exercises) {
        batch.update(
          _tableName,
          exercise.toMap(),
          where: '${ExerciseFields.id} = ?',
          whereArgs: [exercise.id],
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

  Future<void> delete(String exerciseId, [Transaction? txn]) async {
    final DatabaseExecutor executor = txn ?? await _db.database;
    final rowsDeleted = await executor.delete(
      _tableName,
      where: '${ExerciseFields.id} = ?',
      whereArgs: [exerciseId],
    );

    if (rowsDeleted == 0) {
      throw Exception('Cannot delete exercise $exerciseId: does not exist');
    }
  }

  Future<void> clearTable([Transaction? txn]) async {
    final DatabaseExecutor executor = txn ?? await _db.database;
    await executor.delete(_tableName);
  }
}
